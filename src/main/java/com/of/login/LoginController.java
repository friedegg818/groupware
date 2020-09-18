package com.of.login;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("loginController")
public class LoginController {
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String main() {
		
		return "login/login";
	}
}
