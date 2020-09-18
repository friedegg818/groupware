package com.of.scheduler;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.of.employee.SessionInfo;

@Controller("scheduler.schedulerController")
@RequestMapping("/scheduler/*")
public class SchedulerController {
	@Autowired
	private SchedulerService service;
	
	@RequestMapping(value="scheduler")
	public String scheduler() throws Exception{
		return ".scheduler.scheduler";
	}
	
	// 대화상자에 출력 할 일정 추가 폼
	@RequestMapping(value="insertForm")
	public String insertForm() throws Exception{
		return "scheduler/insertForm";
	}
	
	// 대화상자에 출력 할 일정 상세 폼
	@RequestMapping(value="detailForm")
	public String detailForm() throws Exception{
		return "scheduler/detailForm";
	}
	
	@RequestMapping(value="created", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> created(Scheduler scheduler, HttpSession session) throws Exception{
		SessionInfo info=(SessionInfo)session.getAttribute("employee");
		
		String state="true";
		try {
			scheduler.setWriter(info.getEmpNo());
			scheduler.setdCode(info.getdCode());
			service.insertScheduler(scheduler);
		} catch (Exception e) {
			state="false";
		}
		
		Map<String, Object> model = new HashMap<>();
		model.put("state", state);		
		
		return model;
	}
	
	@RequestMapping(value="month")
	@ResponseBody
	public Map<String, Object> month(
			@RequestParam String start,
			@RequestParam String end,
			@RequestParam(defaultValue="all") String group,
			HttpSession session
			) throws Exception{
		SessionInfo info=(SessionInfo)session.getAttribute("employee");
		
		Map<String, Object> map = new HashMap<>();
		map.put("group", group);
		map.put("start", start);
		map.put("end", end);
		map.put("writer", info.getEmpNo());
		map.put("dCode", info.getdCode());
		
		List<Scheduler> list = service.listMonthSchedule(map);
		
		List<SchedulerJSON> listJSON =new ArrayList<>();		
		for(Scheduler scheduler:list) {
			SchedulerJSON dto= new SchedulerJSON();
			dto.setSchNum(scheduler.getSchNum());
			dto.setTitle(scheduler.getTitle());
			dto.setWriter(scheduler.getWriter());
			dto.setName(scheduler.getName());
			dto.setdCode(scheduler.getdCode());
			dto.setCategory(scheduler.getCategory());
			dto.setColor(scheduler.getColor());
			
			if(scheduler.getAllDay().equals("true")) {
				dto.setAllDay(true);
			} else {
				dto.setAllDay(false);
			}
			
			if(scheduler.getStartTime()!=null && scheduler.getStartTime().length()!=0) {
				dto.setStart(scheduler.getStartDate()+" "+scheduler.getStartTime());
			} else {
				dto.setStart(scheduler.getStartDate());
			}
			
			if(scheduler.getEndTime()!=null && scheduler.getEndTime().length()!=0) {
				dto.setEnd(scheduler.getEndDate()+" "+scheduler.getEndTime());
			} else {
				dto.setEnd(scheduler.getEndDate());
			}
			
			dto.setContent(scheduler.getContent());
			dto.setCreated(scheduler.getCreated());
			
			
			listJSON.add(dto);
		}
			
		// 작업결과를 json으로 전송
		Map<String, Object> model = new HashMap<>();
		model.put("list", listJSON);
		return model;		
	}
		
	@RequestMapping(value="delete", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delete(
			@RequestParam int schNum
			) throws Exception{
		String state="true";
		try {
			service.deleteScheduler(schNum);
		} catch (Exception e) {
			state="false";
		}
			
		Map<String, Object> model = new HashMap<>();
		model.put("state", state);
		return model;		
	}
	
	@RequestMapping(value="update", method=RequestMethod.POST)
	@ResponseBody
	public Map<String , Object> update(
			Scheduler scheduler,
			HttpSession session
			) throws Exception{
		SessionInfo info=(SessionInfo)session.getAttribute("employee");
		
		String state= "true";
		try {
			scheduler.setWriter(info.getEmpNo());
			int result=service.updateScheduler(scheduler);
			if(result==0) {
				state="updateFAIL";
			}
		} catch (Exception e) {
			state="false";
		}
		
		Map<String , Object> model = new HashMap<>();
		model.put("state", state);
		return model;	
		
		
	}
	
	
	

}
