package com.quizz.api.users.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.util.MimeTypeUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.quizz.api.users.dto.ApiLoginRequestDTO;
import com.quizz.api.users.dto.ApiLoginResponseDTO;
import com.quizz.api.users.services.ApiUserService;


@RestController
@RequestMapping("/api/auth")
public class ApiAuthController {
    private final AuthenticationManager authenticationManager;
    private final ApiUserService apiUserService;

    @Autowired
    public ApiAuthController(AuthenticationManager authenticationManager, ApiUserService apiUserService) {
	super();

	this.authenticationManager = authenticationManager;
	this.apiUserService = apiUserService;
    }

    @RequestMapping(value = "/login", produces = MimeTypeUtils.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> login(@RequestBody ApiLoginRequestDTO loginRequest
	 ) {
	try {
	  
	    Authentication authentication = authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(
		    loginRequest.getUsernameOrEmail(), loginRequest.getPassword()));
	    SecurityContextHolder.getContext().setAuthentication(authentication);
	    UserDetails userDetails = (UserDetails) authentication.getPrincipal();
	    ApiLoginResponseDTO response = new ApiLoginResponseDTO();
	    response.setUsername(userDetails.getUsername());
	    response.setRole(userDetails.getAuthorities().iterator().next().getAuthority());
	    response.setUserDto(apiUserService.findUserDtoByUsername(userDetails.getUsername()));
	    return ResponseEntity.ok(response);

	} catch (Exception e) {
	    return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
		    .body("Invalid username or password ++:" + e.getMessage());
	}

    }

}
