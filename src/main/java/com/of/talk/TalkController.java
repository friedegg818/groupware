package com.of.talk;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.of.common.MyUtil;
import com.of.employee.SessionInfo;

@RestController("talk.talkController")
@RequestMapping("/talk/*")
public class TalkController {
	
	@Autowired
	private TalkService service;
	
	@Autowired
	private MyUtil myUtil;
	
	@RequestMapping(value="talk")
	public ModelAndView talk(Model model) {
		return new ModelAndView(".talk.talk");
	}
	
	@RequestMapping(value="chat")
	public ModelAndView chat(Model model) {
		return new ModelAndView(".chat.chat");
	}
	
	@RequestMapping(value="list")
	public Map<String, Object> list(
			@RequestParam(value="pageNo", defaultValue="1") int current_page
			) throws Exception{
		int rows=5;
		int dataCount=service.dataCount();
		int total_page=myUtil.pageCount(rows, dataCount);
		if(current_page>total_page) {
			current_page=total_page;
		}
		
		Map<String, Object> map = new HashMap<>();
		int offset = (current_page-1)*rows;
		if(offset<0) offset=0;
		map.put("offset", offset);
		map.put("rows", rows);
		
		int listNum, n =0;
		List<Talk> list = service.listTalk(map);
		for(Talk dto : list) {
			dto.setContent(dto.getContent().replaceAll("\n", "<br>"));			
			listNum=dataCount-(offset+n);
			dto.setListNum(listNum);
			n++;
		}
		// 작업 결과를 json으로 전송
		Map<String, Object> model = new HashMap<>();
		// 데이터개수
		model.put("total_page", total_page);
		model.put("dataCount", dataCount);
		model.put("pageNo", current_page);
		model.put("list", list);
		// 게시물 리스트
		return model;
	}
	
	@RequestMapping(value="insert", method=RequestMethod.POST)
	public Map<String , Object> createdSubmit(
			Talk dto,
			HttpSession session
			) throws Exception{
		SessionInfo info=(SessionInfo)session.getAttribute("employee");
		
		String state="true";
		try {
			dto.setWriter(info.getEmpNo());
			dto.setImageFilename(info.getImageFilename());
			service.insertTalk(dto);
		} catch (Exception e) {
			state="false";
		}
		
		Map<String, Object> model=new HashMap<>();
		model.put("state", state);
		return model;
	}
	
	@RequestMapping(value="delete", method=RequestMethod.POST)
	public Map<String, Object> talkDelete(
			@RequestParam int talkNum,
			HttpSession session
			) throws Exception {
		SessionInfo info=(SessionInfo)session.getAttribute("employee");
		
		String state="true";
		try {
			Map<String, Object> map=new HashMap<>();
			map.put("talkNum", talkNum);
			map.put("writer", info.getEmpNo());
			service.deleteTalk(map);
		} catch (Exception e) {
			state="false";
		}			
		
		Map<String, Object> model=new HashMap<>();
		model.put("state", state);
		return model;
	}

}
