package com.quizz.configurations;

import java.util.Collection;
import java.util.Collections;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.quizz.entities.Users;

public class WebUserDetails implements UserDetails {
    private final Users user;

    public WebUserDetails(Users user) {
	this.user = user;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
	String roleWithPrefix = user.getRole().startsWith("ROLE_") ? user.getRole() : "ROLE_" + user.getRole();
	return Collections.singleton(new SimpleGrantedAuthority(roleWithPrefix));
    }

    @Override
    public String getPassword() {
	return user.getPassword();
    }

    @Override
    public String getUsername() {
	return user.getUsername();
    }

    @Override
    public boolean isAccountNonExpired() {
	return true;
    }

    @Override
    public boolean isAccountNonLocked() {
	return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
	return true;
    }

    @Override
    public boolean isEnabled() {
	return user.getIsActive();
    }

    public Users getUser() {
	return user;
    }

    public Long getUserId() {
	return user.getUserId();
    }
}
