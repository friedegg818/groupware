package com.of.employee;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;

// 로그인 성공 후에 할 작업을 처리하는 클래스
public class MyAuthenticationSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {

	@Autowired
	private EmployeeService service;

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws ServletException, IOException {

		// 로그인 날짜 변경
		String empNo = authentication.getName();

		try {
			service.updateLastLogin(empNo);
		} catch (Exception e) {

		}

		// 로그인 정보 세션에 저장
		Employee dto = service.readEmployee(empNo);
		SessionInfo info = new SessionInfo();
		info.setEmpNo(empNo);

		HttpSession session = request.getSession();
		session.setAttribute("employee", info);

		super.onAuthenticationSuccess(request, response, authentication);
	}

}
