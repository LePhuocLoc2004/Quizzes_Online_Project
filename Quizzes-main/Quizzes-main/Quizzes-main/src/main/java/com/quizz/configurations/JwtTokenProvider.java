package com.quizz.configurations;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;

@Component
public class JwtTokenProvider {
    // Tạo khóa bí mật an toàn cho HS512
    private final SecretKey SECRET_KEY = Keys.secretKeyFor(SignatureAlgorithm.HS512);
    private final long ACCESS_TOKEN_VALIDITY_IN_MS = 15000000; // 25 phút cho access token
    private final long REFRESH_TOKEN_VALIDITY_IN_MS = 7 * 24 * 60 * 60 * 1000; // 7 ngày cho refresh token

    // Tạo access token
    public String generateAccessToken(String username, String role) {
        return Jwts.builder()
            .setSubject(username)
            .claim("role", role)
            .setIssuedAt(new Date())
            .setExpiration(new Date(System.currentTimeMillis() + ACCESS_TOKEN_VALIDITY_IN_MS))
            .signWith(SECRET_KEY)
            .compact();
    }

    // Tạo refresh token
    public String generateRefreshToken(String username) {
        return Jwts.builder()
            .setSubject(username)
            .setIssuedAt(new Date())
            .setExpiration(new Date(System.currentTimeMillis() + REFRESH_TOKEN_VALIDITY_IN_MS))
            .signWith(SECRET_KEY)
            .compact();
    }

    // Lấy username từ token
    public String getUsernameFromToken(String token) {
        try {
            return Jwts.parserBuilder()
                .setSigningKey(SECRET_KEY)
                .build()
                .parseClaimsJws(token)
                .getBody()
                .getSubject();
        } catch (JwtException e) {
            throw new IllegalArgumentException("Invalid JWT token: " + e.getMessage());
        }
    }

    // Lấy role từ token (chỉ áp dụng cho access token)
    public String getRoleFromToken(String token) {
        try {
            Claims claims = Jwts.parserBuilder()
                .setSigningKey(SECRET_KEY)
                .build()
                .parseClaimsJws(token)
                .getBody();
            return claims.get("role", String.class);
        } catch (JwtException e) {
            throw new IllegalArgumentException("Invalid JWT token or missing role: " + e.getMessage());
        }
    }

    // Xác thực token (dùng cho cả access và refresh token)
    public boolean validateToken(String token) {
        try {
            Jws<Claims> claims = Jwts.parserBuilder()
                .setSigningKey(SECRET_KEY)
                .build()
                .parseClaimsJws(token);
            Date expiration = claims.getBody().getExpiration();
            Date now = new Date();
            if (expiration.before(now)) {
                System.out.println("Token has expired: " + token);
                return false;
            }
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            System.out.println("Invalid JWT token: " + e.getMessage());
            return false;
        }
    }
}