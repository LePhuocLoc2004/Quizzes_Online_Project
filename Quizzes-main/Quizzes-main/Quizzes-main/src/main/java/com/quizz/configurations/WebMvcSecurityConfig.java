package com.quizz.configurations;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.web.filter.OncePerRequestFilter;

import com.quizz.services.WebUserService;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Configuration
@EnableWebSecurity
public class WebMvcSecurityConfig {
    private final WebUserService webUserService;
    private final BCryptPasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;

    @Autowired
    public WebMvcSecurityConfig(WebUserService webUserService, BCryptPasswordEncoder passwordEncoder, JwtTokenProvider jwtTokenProvider) {
        this.webUserService = webUserService;
        this.passwordEncoder = passwordEncoder;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }

    private AuthenticationSuccessHandler roleBasedSuccessHandler() {
        return new AuthenticationSuccessHandler() {
            @Override
            public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                    Authentication authentication) throws IOException, ServletException {
                Map<String, String> urls = new HashMap<>();
                urls.put("ROLE_ADMIN", "/admin/dashboard");
                urls.put("ROLE_USER", "/auth/welcome");

                List<GrantedAuthority> authorities = (List<GrantedAuthority>) authentication.getAuthorities();
                String role = authorities.get(0).getAuthority();
                String redirectUrl = urls.getOrDefault(role, "/auth/welcome");
                System.out.println("Role: " + role);
                response.sendRedirect(redirectUrl);
            }
        };
    }

    @Bean
    @Order(0)
    SecurityFilterChain apiFilterChain(HttpSecurity http) throws Exception {
        return http
            .securityMatcher("/api/**")
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers(HttpMethod.POST, "/api/admin/login").permitAll()
                .requestMatchers(HttpMethod.POST, "/api/admin/users/add").permitAll()
                .requestMatchers(HttpMethod.POST, "/api/admin/refresh-token").permitAll() // Cho phép refresh token
                .requestMatchers(HttpMethod.PUT, "/api/admin/users/edit").hasRole("ADMIN")
                .requestMatchers("/api/**").permitAll()
                .anyRequest().authenticated()
            )
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .addFilterBefore(new JwtAuthenticationFilter(jwtTokenProvider, webUserService), UsernamePasswordAuthenticationFilter.class)
            .exceptionHandling(ex -> ex.authenticationEntryPoint((request, response, authException) -> {
                System.out.println("API Unauthorized: " + authException.getMessage() + " for " + request.getRequestURI());
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.setContentType("application/json");
                response.getWriter().write("{\"error\": \"Unauthorized\", \"message\": \"" + authException.getMessage() + "\"}");
            }))
            .build();
    }

    @Bean
    @Order(1)
    SecurityFilterChain adminFilterChain(HttpSecurity http) throws Exception {
        return http
            .securityMatcher("/admin/**")
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/admin/login", "/", "/auth/login", "/auth/**", "/assets/**",
                    "/css/**", "/js/**", "/img/**", "/webjars/**").permitAll()
                .requestMatchers("/admin/**").hasRole("ADMIN")
                .anyRequest().authenticated())
            .formLogin(form -> form
                .loginPage("/admin/login")
                .loginProcessingUrl("/admin/process-login")
                .usernameParameter("usernameOrEmail")
                .passwordParameter("password")
                .successHandler(roleBasedSuccessHandler())
                .failureUrl("/admin/login?error")
                .permitAll())
            .logout(logout -> logout
                .logoutRequestMatcher(new AntPathRequestMatcher("/admin/logout"))
                .logoutSuccessUrl("/admin/login?logout")
                .permitAll())
            .exceptionHandling(ex -> ex.accessDeniedPage("/auth/access-denied"))
            .build();
    }

    @Bean
    @Order(2)
    SecurityFilterChain webFilterChain(HttpSecurity http) throws Exception {
        return http
            .securityMatcher(request -> !request.getRequestURI().startsWith("/api/") && !request.getRequestURI().startsWith("/admin/"))
            .csrf(csrf -> csrf.ignoringRequestMatchers("/take-quiz/**"))
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/", "/auth/login", "/auth/**", "/assets/**", "/css/**","/uploads/**",
                    "/js/**", "/img/**", "/webjars/**").permitAll()
                .anyRequest().authenticated())
            .formLogin(form -> form
                .loginPage("/auth/login")
                .loginProcessingUrl("/auth/process-login")
                .usernameParameter("usernameOrEmail")
                .passwordParameter("password")
                .successHandler(roleBasedSuccessHandler())
                .failureUrl("/auth/login?error")
                .permitAll())
            .logout(logout -> logout
                .logoutRequestMatcher(new AntPathRequestMatcher("/auth/logout"))
                .logoutSuccessUrl("/auth/login?logout")
                .permitAll())
            .exceptionHandling(ex -> ex.accessDeniedPage("/auth/access-denied"))
            .build();
    }

    @Autowired
    public void configureGlobal(AuthenticationManagerBuilder builder) throws Exception {
        builder.userDetailsService(webUserService).passwordEncoder(passwordEncoder);
    }
}

// Filter JWT (giữ nguyên)
class JwtAuthenticationFilter extends OncePerRequestFilter {
    private final JwtTokenProvider jwtTokenProvider;
    private final WebUserService webUserService;

    public JwtAuthenticationFilter(JwtTokenProvider jwtTokenProvider, WebUserService webUserService) {
        this.jwtTokenProvider = jwtTokenProvider;
        this.webUserService = webUserService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        String token = request.getHeader("Authorization");
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);
            if (jwtTokenProvider.validateToken(token)) {
                String username = jwtTokenProvider.getUsernameFromToken(token);
                UserDetails userDetails = webUserService.loadUserByUsername(username);
                UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(
                    userDetails, null, userDetails.getAuthorities());
                SecurityContextHolder.getContext().setAuthentication(auth);
            }
        }
        filterChain.doFilter(request, response);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) throws ServletException {
        // Bỏ qua filter cho /api/admin/refresh-token
        return request.getRequestURI().equals("/api/admin/refresh-token");
    }

}