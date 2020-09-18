package com.of.main;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.of.buddy.BuddyService;
import com.of.employee.Employee;
import com.of.employee.EmployeeService;
import com.of.employee.SessionInfo;
import com.of.news.News;
import com.of.news.NewsService;
import com.of.notice.Notice;
import com.of.notice.NoticeService;
import com.of.profile.Profile;
import com.of.profile.ProfileService;
import com.of.scheduler.Scheduler;
import com.of.scheduler.SchedulerJSON;
import com.of.sign.Sign;
import com.of.sign.SignService;
import com.of.workTime.WorkTime;
import com.of.workTime.WorkTimeService;

@Controller("mainController")
public class MainController {
	@Autowired
	MainService service;
	
	@Autowired
	NoticeService nservice;
	
	@Autowired
	NewsService nwservice;
	
	@Autowired
	SignService sgservice;
	
	@Autowired
	BuddyService bdService;
	
	@Autowired
	WorkTimeService wkService;
	
	@Autowired
	EmployeeService empService;
	
	@Autowired
	ProfileService proService;
	
	@RequestMapping(value = "/main", method = RequestMethod.GET)
	public String main(
			HttpSession session,
			HttpServletRequest req,
			Model model,
			@RequestParam(defaultValue="") String nCode
			) throws Exception{
		
		SessionInfo info=(SessionInfo)session.getAttribute("employee");
		String empNo = info.getEmpNo();
		
		// 투두 리스트 
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("empNo", empNo);
		List<Main> list=service.listTodo(map);
		
		// 공지 리스트 		
		String cp=req.getContextPath();
		String noticeUrl=cp+"/notice/article?page=";
		
		int offset = 0;
		map.put("offset", offset);
		map.put("rows", 10);
		
		List<Notice> nlist = nservice.listNotice(map);	
		
		for(Notice dto : nlist) {
			if(dto.getTitle().length()>=15) {
				dto.setTitle(dto.getTitle().substring(0, 15) + "…");
			}
		}
		
		// 소식 리스트
		String newsUrl=cp+"/news/article?page=";
		map.put("offset", offset);
		map.put("rows", 10);
		map.put("nCode", nCode);
		List<News> nwlist = nwservice.listNews(map);	
		
		for(News dto : nwlist) {
			if(dto.getTitle().length()>=15) {
				dto.setTitle(dto.getTitle().substring(0, 15) + "…");
			}
		}
		
		// 결재 수신함 리스트
		String signUrl = cp + "/sign/article?page=";
		map.put("offset", offset);
		map.put("rows", 10);
		
		List<Sign> sglist = sgservice.stepList(map,"reci");
		
		for(Sign dto : sglist) {
			dto.setSdate(dto.getSdate().substring(0,10));
		}
		
		// 출퇴근 시각
		WorkTime wk = wkService.toDayChekc(Integer.parseInt(info.getEmpNo()));
		
		// 사원 로그인 날짜 찍기
		empService.updateLastLogin(empNo);
		
		model.addAttribute("list", list);
		model.addAttribute("nlist", nlist);
		model.addAttribute("nwlist", nwlist);
		model.addAttribute("sglist", sglist);
		model.addAttribute("newsUrl", newsUrl);
		model.addAttribute("noticeUrl", noticeUrl);
		model.addAttribute("signUrl", signUrl);
		model.addAttribute("wk",wk);
				
		return ".mainLayout";		
	}
	
	
	@RequestMapping(value="/main/created", method=RequestMethod.POST)
	public String createdSubmit(
			Main dto,
			HttpSession session
			) throws Exception{
		SessionInfo info=(SessionInfo)session.getAttribute("employee");
		
		try {			
			dto.setEmpNo(info.getEmpNo());
			service.insertTodo(dto);
		} catch (Exception e) {
		}
		return "redirect:/main";
	}
	
	@RequestMapping(value="/main/delete")
	public String delete(
			@RequestParam int todoNum
			) throws Exception{
	
		try {
			service.deleteTodo(todoNum);
		} catch (Exception e) {
		}
		
		return "redirect:/main";
	}
	
	@RequestMapping(value="/main/update")
	public String update(
			@RequestParam int todoNum
			) throws Exception {
		
		try {
			service.updateTodo(todoNum);
		} catch (Exception e) {
		}
		
		return "redirect:/main";
	}
	
	@RequestMapping(value="/main/update2")
	public String update2(
			@RequestParam int todoNum
			) throws Exception {
		
		try {
			service.updateTodo2(todoNum);
		} catch (Exception e) {
		}
		
		return "redirect:/main";
	}
	
	
	@RequestMapping(value="/main/month")
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
		
		List<Scheduler> list = service.listWeekScheduler(map);
		
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
	
	@RequestMapping(value = "/main/mainAlert")
	@ResponseBody
	public Map<String, Object> mainAlert(HttpSession session) throws Exception {		
		
		SessionInfo info = (SessionInfo) session.getAttribute("employee");
		
		Map<String, Object> map = new HashMap<>();
		map.put("empNo", info.getEmpNo());
		
		int mailCnt = 0;
		int stepCnt = 0;
		int newsCnt = 0;
		
		try {
			mailCnt = bdService.unreadCount(info.getEmpNo());
			stepCnt = sgservice.stepCount(map);
			newsCnt = nwservice.dataCountAlert(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		Map<String, Object> model = new HashMap<>();
		model.put("mailCnt", mailCnt);
		model.put("stepCnt", stepCnt);
		model.put("newsCnt", newsCnt);
		
		return model;
	}
	
	
	
	@RequestMapping(value="/main/profile")
	public String profileSearch(
			@RequestParam String empNo,
			Model model
			) {
		Profile dto = 	proService.readProfile(empNo);
		
		model.addAttribute("dto",dto);
		return "profile/semi";
	}
}
