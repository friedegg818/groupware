package com.of.profile;

import java.io.File;


import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.of.employee.SessionInfo;

@Controller("profile.profileController")
@RequestMapping("/profile/*")
public class ProfileController {
	@Autowired
	private ProfileService service;
		
	@RequestMapping(value="list")
	public String list(
		HttpSession session,
		Model model) throws Exception {
		
		SessionInfo info=(SessionInfo)session.getAttribute("employee");		
		String empNo = info.getEmpNo();

		Profile dto = service.readProfile(empNo);
	
		model.addAttribute("dto", dto);

		return ".profile.list";
	}
	
	@RequestMapping(value="created", method=RequestMethod.GET)
	public String createdForm(HttpSession session, Model model) throws Exception {
		
		SessionInfo info=(SessionInfo)session.getAttribute("employee");		
		String empNo = info.getEmpNo();
		
		Profile dto = service.readProfile(empNo);
		
		model.addAttribute("dto", dto);
		
		return ".profile.created";
	}
	
	@RequestMapping(value="created", method=RequestMethod.POST)
	public String createdSubmit(
			Profile dto,
			HttpSession session) throws Exception {
		String root=session.getServletContext().getRealPath("/");
		String path=root+"uploads"+File.separator+"profile";
		
		SessionInfo info=(SessionInfo)session.getAttribute("employee");		
		
		try {
			dto.setEmpNo(info.getEmpNo());
			service.updateProfile(dto, path);
			info.setImageFilename(dto.getImageFilename());
		} catch (Exception e) {
		}
		
		return "redirect:/profile/list";
	}
}
