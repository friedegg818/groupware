package com.of.workTime;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.of.employee.SessionInfo;

@Controller("workTime.workTimeController")
@RequestMapping("/workTime/*")
public class WorkTimeController {
	@Autowired
	private WorkTimeService service;

	@RequestMapping(value = "main")
	public String main(HttpServletRequest req, HttpSession session, Model model) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat sdf3 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		SessionInfo info = (SessionInfo) session.getAttribute("employee");

		Date nowDate = new Date();


		
		WorkTime wk = service.toDayChekc(Integer.parseInt(info.getEmpNo()));

		Date date = new Date();

		if (wk != null) {
			date = sdf.parse(wk.getWorkDate());
			wk.setWorkDate(sdf1.format(date));

			if (wk.getClockIn() != null) {
				date = sdf.parse(wk.getClockIn());
				wk.setClockIn(sdf3.format(date));
			}
			if (wk.getClockOut() != null) {
				date = sdf.parse(wk.getClockOut());
				wk.setClockOut(sdf3.format(date));
			}
			switch (wk.getWorkCode()) {
			case "A":
				wk.setWorkCode("미퇴근");
				break;
			case "B":
				wk.setWorkCode("지각");
				break;
			case "C":
				wk.setWorkCode("결근");
				break;
			case "D":
				wk.setWorkCode("조퇴");
				break;
			case "E":
				wk.setWorkCode("외근");
				break;
			case "F":
				wk.setWorkCode("정상");
				break;
			case "G":
				wk.setWorkCode("연차");
				break;
			case "H":
				wk.setWorkCode("초과근무");
				break;
			case "EE":
				wk.setWorkCode("정상");
				model.addAttribute("stat", "EE");
				break;
			}
		}

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("empNo", info.getEmpNo());

		String currDate = sdf1.format(nowDate);
		map.put("currDate", currDate.substring(0, 7));

		List<WorkTime> monthList = service.monthList(map);

		for (WorkTime dto : monthList) {
			date = new Date();

			date = sdf.parse(dto.getWorkDate());
			dto.setWorkDate(sdf1.format(date));

			if (dto.getClockIn() != null) {
				date = sdf.parse(dto.getClockIn());
				dto.setClockIn(sdf3.format(date));
			}

			if (dto.getClockOut() != null) {
				date = sdf.parse(dto.getClockOut());
				dto.setClockOut(sdf3.format(date));
			}

			switch (dto.getWorkCode()) {
			case "A":
				dto.setWorkCode("미퇴근");
				break;
			case "B":
				dto.setWorkCode("지각");
				break;
			case "C":
				dto.setWorkCode("결근");
				break;
			case "D":
				dto.setWorkCode("조퇴");
				break;
			case "E":
				dto.setWorkCode("외근");
				break;
			case "F":
				dto.setWorkCode("정상");
				break;
			case "G":
				dto.setWorkCode("연차");
				break;
			case "H":
				dto.setWorkCode("초과근무");
				break;
			case "EE":
				dto.setWorkCode("정상");
				model.addAttribute("stat", "EE");
				break;
			
			}
		}
		
		map.put("empNo", info.getEmpNo());
		map.put("currDate2", currDate.substring(0, 4));
		
		Map<String, Integer> resultMap = new HashMap<>();
		
		resultMap = service.countCode(map);
		
		model.addAttribute("codeB", resultMap.get("codeB"));
		model.addAttribute("codeC", resultMap.get("codeC"));
		model.addAttribute("codeG", resultMap.get("codeG"));
		model.addAttribute("monthList", monthList);
		model.addAttribute("wk", wk);
		model.addAttribute("empNo", info.getEmpNo());
		return ".workTime.main";

	};

	@RequestMapping(value = "workOrHome")
	public String workOrHome(
			HttpSession session,
			HttpServletRequest req,
			String val,
			Model model
			) throws Exception {
		SimpleDateFormat sdf2 = new SimpleDateFormat("HH:mm:ss");
		SimpleDateFormat sdf4 = new SimpleDateFormat("yyyyMMdd");
		
		Map<String, Object> map = new HashMap<>();
		SessionInfo info = (SessionInfo) session.getAttribute("employee");
		
		Date nowDate = new Date();

		String status = sdf2.format(nowDate);

		String[] time = status.split(":");
		int hour = Integer.parseInt(time[0]);

		map.put("empNo", info.getEmpNo());
		map.put("ipAddr", req.getRemoteAddr());
		switch (val) {
		case "work":
			if (hour < 9) {
				map.put("workCode", "A");
			} else {
				map.put("workCode", "B");
			}

			service.insertWorkTime(map);
			break;
		case "home":
			map.put("empNo", info.getEmpNo());
			map.put("workDate", sdf4.format(nowDate));


			WorkTime wk = service.toDayChekc(Integer.parseInt(info.getEmpNo()));
			
			if(hour < 18) {
				
				if(wk.getWorkCode().equalsIgnoreCase("B")) {
					
				}else {
					map.put("workCode", "D");
				}
			}else if(wk.getWorkCode().equalsIgnoreCase("A")){
				if(hour >= 19) {
					map.put("workCode","H");
				}else {
					map.put("workCode","F");
				}
			}else {
				map.put("workCode", wk.getWorkCode());
			}
			service.updateWorkTime(map);
			break;
		}

		return "redirect:/workTime/main";
	}
	
	@RequestMapping(value="out")
	public String out(
			@RequestParam String out,
			HttpSession session,
			HttpServletRequest req,
			String val,
			Model model
			) throws Exception{
		SimpleDateFormat sdf2 = new SimpleDateFormat("HH:mm:ss");
		SimpleDateFormat sdf4 = new SimpleDateFormat("yyyyMMdd");
		
		Map<String, Object> map = new HashMap<>();
		SessionInfo info = (SessionInfo) session.getAttribute("employee");
		
		Date nowDate = new Date();

		String status = sdf2.format(nowDate);

		String[] time = status.split(":");
		int hour = Integer.parseInt(time[0]);

		map.put("empNo", info.getEmpNo());
		map.put("ipAddr", req.getRemoteAddr());
		switch (val) {
		case "work":
			if (hour < 9) {
				map.put("workCode", "A");
			} else {
				map.put("workCode", "B");
			}

			service.outInsert(map);
			break;
		case "home":
			map.put("empNo", info.getEmpNo());
			map.put("workDate", sdf4.format(nowDate));

			WorkTime wk = service.toDayChekc(Integer.parseInt(info.getEmpNo()));
			if(hour < 18 ){
				map.put("workCode", "D");
			}else if(wk.getWorkCode().equalsIgnoreCase("A")){
				if(hour >= 19) {
					map.put("workCode","H");
				}else {
					map.put("workCode","F");
				}
			}else {
				map.put("workCode", wk.getWorkCode());
			}
			service.outUpdate(map);
			break;
		}
		return "redirect:/workTime/main";
	}
	
	
	@RequestMapping(value="update")
	public String update(
			String other,
			String workDate,
			HttpSession session,
			Model model
			) {
		SessionInfo info = (SessionInfo) session.getAttribute("employee");
		Map<String, Object> map = new HashMap<>();
		
		try {
			
			map.put("workMemo", other);
			
			map.put("workDate", workDate);
			
			map.put("empNo", info.getEmpNo());
			
			service.otherMemo(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		model.addAttribute("empNo", info.getEmpNo());
		return "redirect:/workTime/main";
	}
	
	@RequestMapping(value="vacation")
	public String vacation(
			String startDay,
			String endDay,
			HttpServletRequest req,
			HttpSession session,
			Model model
			) {
		SessionInfo info = (SessionInfo) session.getAttribute("employee");
		
		Map<String, Object> map = new HashMap<>();
		
		map.put("ipAddr", req.getRemoteAddr());
		map.put("empNo", info.getEmpNo());
		map.put("startDay", startDay);
		map.put("endDay", "~ "+endDay);
		map.put("workCode", "G");
		
		service.insertVacation(map);
		
		return "redirect:/workTime/main";
	}
	
	@RequestMapping(value="mainWorkOrHome")
	public String mainWorkOrHome(
			HttpSession session,
			HttpServletRequest req,
			String val,
			Model model
			) throws Exception{
		SimpleDateFormat sdf2 = new SimpleDateFormat("HH:mm:ss");
		SimpleDateFormat sdf4 = new SimpleDateFormat("yyyyMMdd");
		
		Map<String, Object> map = new HashMap<>();
		SessionInfo info = (SessionInfo) session.getAttribute("employee");
		
		Date nowDate = new Date();

		String status = sdf2.format(nowDate);

		String[] time = status.split(":");
		int hour = Integer.parseInt(time[0]);
		
		map.put("empNo", info.getEmpNo());
		map.put("ipAddr", req.getRemoteAddr());
		switch (val) {
		case "work":
			if (hour < 9) {
				map.put("workCode", "A");
			} else {
				map.put("workCode", "B");
			}
			service.insertWorkTime(map);
			break;
		case "home":
			map.put("empNo", info.getEmpNo());
			map.put("workDate", sdf4.format(nowDate));


			WorkTime wk = service.toDayChekc(Integer.parseInt(info.getEmpNo()));
			if(hour < 18 ){
				map.put("workCode", "D");
			}else if(wk.getWorkCode().equalsIgnoreCase("A")){
				if(hour >= 19) {
					map.put("workCode","H");
				}else {
					map.put("workCode","F");
				}
			}else {
				map.put("workCode", wk.getWorkCode());
			}
			service.updateWorkTime(map);
			break;
		}

		return "redirect:/main";
	}
}
