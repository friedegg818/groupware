package com.of.buddy;

import java.io.File;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.of.common.FileManager;
import com.of.common.MyUtil;
import com.of.employee.SessionInfo;

@Controller("buddy.buddyController")
public class BuddyController {
	@Autowired
	private BuddyService service;
	@Autowired
	private MyUtil myUtil;
	@Autowired
	private FileManager fileManager;
	
	
	/* 메일 작성 */
	@RequestMapping(value = "/buddy/created", method = RequestMethod.GET)
	public String createdForm(Model model, HttpSession session) throws Exception {		
		
		return ".buddy.created";
	}

	@RequestMapping(value = "/buddy/created", method = RequestMethod.POST)
	public String createdSubmit(Buddy dto, HttpSession session) throws Exception {

		SessionInfo info = (SessionInfo) session.getAttribute("employee");

		try {
			String root = session.getServletContext().getRealPath("/");
			String pathname = root + "uploads" + File.separator + "buddy";

			dto.setSender(info.getEmpNo());
			service.sendBuddy(dto, pathname);
		} catch (Exception e) {
		}
		return "redirect:/buddy/rlist";
	}
	
	/* 답장 쓰기 */
	@RequestMapping(value = "/buddy/reply", method = RequestMethod.GET)
	public String replyForm(
			Model model, 
			HttpSession session,
			@RequestParam int buddyNum,
			@RequestParam String page
			) throws Exception {		
		
		Buddy dto = service.readBuddy(buddyNum);
		
		if(dto==null) {
			return "redirect:/buddy/rlist?page="+page;
		}
		
		model.addAttribute("dto", dto);		
		
		return ".buddy.reply";
	}	
	

	@RequestMapping(value = "/buddy/reply", method = RequestMethod.POST)
	public String replySubmit(
			Buddy dto,
			@RequestParam String page,
			HttpSession session) throws Exception {

		SessionInfo info = (SessionInfo) session.getAttribute("employee");

		try {
			String root = session.getServletContext().getRealPath("/");
			String pathname = root + "uploads" + File.separator + "buddy";
		
			dto.setSender(info.getEmpNo());
			service.sendBuddy(dto, pathname);
		} catch (Exception e) {
		}
		return "redirect:/buddy/rlist?page="+page;
	}
	
	/* 전달하기 */
	@RequestMapping(value = "/buddy/forward", method = RequestMethod.GET)
	public String forwardForm(
			Model model, 
			HttpSession session,
			@RequestParam int buddyNum,
			@RequestParam String page
			) throws Exception {		
		
		Buddy dto = service.readBuddy(buddyNum);
		List<Buddy> listFile=service.listFile(buddyNum);
		
		if(dto==null) {
			return "redirect:/buddy/rlist?page="+page;
		}
		
		model.addAttribute("dto", dto);	
		model.addAttribute("listFile", listFile);
		
		return ".buddy.forward";
	}
	
	@RequestMapping(value = "/buddy/forward", method = RequestMethod.POST)
	public String forwardSubmit(
			Buddy dto,
			@RequestParam String page,
			HttpSession session) throws Exception {

		SessionInfo info = (SessionInfo) session.getAttribute("employee");

		try {
			String root = session.getServletContext().getRealPath("/");
			String pathname = root + "uploads" + File.separator + "buddy";
		
			dto.setSender(info.getEmpNo());
			service.sendBuddy(dto, pathname);
		} catch (Exception e) {
		}
		return "redirect:/buddy/rlist?page="+page;
	}
	
	/*받는 사람 검색*/
	@ResponseBody
	@RequestMapping(value="/buddy/searchEmailList", method=RequestMethod.GET)
	public Map<String, Object> searchList(
			@RequestParam String col, 
			@RequestParam String keyword
			) {
		
		Map<String, Object> model = new HashMap<>();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("col", col);
		map.put("keyword", keyword);
		
		List<Buddy>adlist = service.listAddr(map);
		
		model.put("adlist", adlist);
		
		return model;
	}
	
	
	/*받은 편지함*/
	@RequestMapping(value = "/buddy/rlist")
	public String rlist(@RequestParam(value="page", defaultValue="1") int current_page,
			@RequestParam(defaultValue="all") String condition,
			@RequestParam(defaultValue="") String keyword,
			HttpServletRequest req,
			HttpSession session,
			Model model) throws Exception {
		
		// 페이징 처리 
		int rows = 10; 
		int total_page = 0;
		int dataCount = 0;
   	    
		// 검색 조건 
		if(req.getMethod().equalsIgnoreCase("GET")) { 
			keyword = URLDecoder.decode(keyword, "utf-8");
		}		
      
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("condition", condition);
        map.put("keyword", keyword);
        
        // 받은 사람 조건 설정 
        SessionInfo info = (SessionInfo) session.getAttribute("employee");
        String receiver = info.getEmpNo();
        map.put("receiver", receiver);

        // 받은 메일 개수
        dataCount = service.rbuddyCount(map);
        if(dataCount != 0)
            total_page = myUtil.pageCount(rows,  dataCount) ;
       
        if(total_page < current_page) 
            current_page = total_page;           
        
        int offset = (current_page-1) * rows;
		if(offset < 0) offset = 0;
        map.put("offset", offset);
        map.put("rows", rows);
       
        List<Buddy> rlist = service.listRbuddy(map); 
        
        for(Buddy dto : rlist) {
        	dto.setrDate(dto.getrDate().substring(0, 16));
        }
        
        // 읽지 않은 메일 개수 
        int unreadCount = service.unreadCount(receiver);
        
        String cp=req.getContextPath();
        String query = "";
        String listUrl = cp+"/buddy/rlist";
        String articleUrl = cp+"/buddy/mail2?page=" + current_page;
        if(keyword.length()!=0) {
        	query = "condition=" + condition + 
        	         "&keyword=" + URLEncoder.encode(keyword, "utf-8");	
        }
        
        if(query.length()!=0) {
        	listUrl = cp+"/buddy/rlist?" + query;
        	articleUrl = cp+"/buddy/mail2?page=" + current_page + "&"+ query;
        }
        
        String paging = myUtil.paging(current_page, total_page, listUrl);   

		model.addAttribute("rlist", rlist);
		model.addAttribute("page", current_page);
		model.addAttribute("dataCount", dataCount);
		model.addAttribute("total_page", total_page);
		model.addAttribute("paging", paging);		
		model.addAttribute("articleUrl", articleUrl);
		model.addAttribute("unreadCount", unreadCount);
			
		model.addAttribute("condition", condition);
		model.addAttribute("keyword", keyword);

		return ".buddy.rlist";
	}	
	
	
	/*보낸 편지함*/
	@RequestMapping(value = "/buddy/slist")
	public String slist(@RequestParam(value="page", defaultValue="1") int current_page,
			@RequestParam(defaultValue="all") String condition,
			@RequestParam(defaultValue="") String keyword,
			HttpServletRequest req,
			HttpSession session,
			Model model) throws Exception {
		
		// 페이징 처리 
		int rows = 10; 
		int total_page = 0;
		int dataCount = 0;
   	    
		// 검색 조건 
		if(req.getMethod().equalsIgnoreCase("GET")) { 
			keyword = URLDecoder.decode(keyword, "utf-8");
		}		
      
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("condition", condition);
        map.put("keyword", keyword);
        
        // 보낸 사람 조건 설정 
        SessionInfo info = (SessionInfo) session.getAttribute("employee");
        String sender = info.getEmpNo();
        map.put("sender", sender);

        // 보낸 메일 개수
        dataCount = service.sbuddyCount(map);
        if(dataCount != 0)
            total_page = myUtil.pageCount(rows,  dataCount) ;
       
        if(total_page < current_page) 
            current_page = total_page;           
        
        int offset = (current_page-1) * rows;
		if(offset < 0) offset = 0;
        map.put("offset", offset);
        map.put("rows", rows);
        
        // 읽지 않은 메일 개수 
        int unreadCount = service.unreadCount(sender);
       
        List<Buddy> slist = service.listSbuddy(map);  
        
        for(Buddy dto : slist) {
        	dto.setsDate(dto.getsDate().substring(0, 16));
        }

        String cp=req.getContextPath();
        String query = "";
        String listUrl = cp+"/buddy/slist";
        String articleUrl = cp+"/buddy/sendmail2?page=" + current_page;
        if(keyword.length()!=0) {
        	query = "condition=" + condition + 
        	         "&keyword=" + URLEncoder.encode(keyword, "utf-8");	
        }
        
        if(query.length()!=0) {
        	listUrl = cp+"/buddy/slist?" + query;
        	articleUrl = cp+"/buddy/sendmail2?page=" + current_page + "&"+ query;
        }
        
        String paging = myUtil.paging(current_page, total_page, listUrl);   

		model.addAttribute("slist", slist);
		model.addAttribute("page", current_page);
		model.addAttribute("dataCount", dataCount);
		model.addAttribute("total_page", total_page);
		model.addAttribute("paging", paging);		
		model.addAttribute("articleUrl", articleUrl);
		model.addAttribute("unreadCount", unreadCount);
			
		model.addAttribute("condition", condition);
		model.addAttribute("keyword", keyword);

		return ".buddy.slist";
	}
	
	/*중요 보관함*/
	@RequestMapping(value = "/buddy/keep")
	public String klist(@RequestParam(value="page", defaultValue="1") int current_page,
			@RequestParam(defaultValue="all") String condition,
			@RequestParam(defaultValue="") String keyword,
			HttpServletRequest req,
			HttpSession session,
			Model model) throws Exception {
		
		// 페이징 처리 
		int rows = 10; 
		int total_page = 0;
		int dataCount = 0;
   	    
		// 검색 조건 
		if(req.getMethod().equalsIgnoreCase("GET")) { 
			keyword = URLDecoder.decode(keyword, "utf-8");
		}		
      
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("condition", condition);
        map.put("keyword", keyword);
        
        // 받은 사람 조건 설정 
        SessionInfo info = (SessionInfo) session.getAttribute("employee");
        String receiver = info.getEmpNo();
        map.put("receiver", receiver);

        // 받은 메일 개수
        dataCount = service.keepCount(map);
        if(dataCount != 0)
            total_page = myUtil.pageCount(rows,  dataCount) ;
       
        if(total_page < current_page) 
            current_page = total_page;           
        
        int offset = (current_page-1) * rows;
		if(offset < 0) offset = 0;
        map.put("offset", offset);
        map.put("rows", rows);
        
        // 읽지 않은 메일 개수 
        int unreadCount = service.unreadCount(receiver);
       
        List<Buddy> klist = service.listKeep(map);  
        
        for(Buddy dto : klist) {
        	dto.setrDate(dto.getrDate().substring(0, 16));
        }

        String cp=req.getContextPath();
        String query = "";
        String listUrl = cp+"/buddy/keep";
        String articleUrl = cp+"/buddy/mail2?page=" + current_page;
        if(keyword.length()!=0) {
        	query = "condition=" + condition + 
        	         "&keyword=" + URLEncoder.encode(keyword, "utf-8");	
        }
        
        if(query.length()!=0) {
        	listUrl = cp+"/buddy/keep?" + query;
        	articleUrl = cp+"/buddy/mail2?page=" + current_page + "&"+ query;
        }
        
        String paging = myUtil.paging(current_page, total_page, listUrl);   

		model.addAttribute("klist", klist);
		model.addAttribute("page", current_page);
		model.addAttribute("dataCount", dataCount);
		model.addAttribute("total_page", total_page);
		model.addAttribute("paging", paging);		
		model.addAttribute("articleUrl", articleUrl);
		model.addAttribute("unreadCount", unreadCount);
			
		model.addAttribute("condition", condition);
		model.addAttribute("keyword", keyword);

		return ".buddy.keep";
	}	
	
	
	//받은 메일 읽기  (미리보기)
	@RequestMapping(value="/buddy/mail", method=RequestMethod.GET)
	public String mail(
			@RequestParam int buddyNum,
			@RequestParam String page,
			@RequestParam(defaultValue="title") String condition,
			@RequestParam(defaultValue="") String keyword,
			HttpServletRequest req,
			Model model) throws Exception {

		keyword = URLDecoder.decode(keyword, "utf-8");
		
		String query="page="+page;
		if(keyword.length()!=0) {
			query+="&condition="+condition+"&keyword="+URLEncoder.encode(keyword, "UTF-8");
		}	
		
		service.updateCheck(buddyNum);

		Buddy dto = service.readBuddy(buddyNum);
		
		if(dto==null) {
			return "redirect:/Buddy/rlist?"+query;
		} 
		
		dto.setsDate(dto.getsDate().substring(0,9));
         
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("condition", condition);
		map.put("keyword", keyword);
		map.put("buddyNum", buddyNum);

		Buddy preReadDto = service.preReadBuddy(map);
		Buddy nextReadDto = service.nextReadBuddy(map);
        		
		List<Buddy> listFile=service.listFile(buddyNum);
		
		String cp=req.getContextPath();
		String articleUrl = cp+"/buddy/mail2?page=" + page;
						
		model.addAttribute("dto", dto);
		model.addAttribute("preReadDto", preReadDto);
		model.addAttribute("nextReadDto", nextReadDto);
		model.addAttribute("listFile", listFile);
		model.addAttribute("page", page);
		model.addAttribute("query", query);
		model.addAttribute("articleUrl", articleUrl);
		
		return "/buddy/mail";
	}	
	
	//받은 메일 읽기  (전체보기)
		@RequestMapping(value="/buddy/mail2", method=RequestMethod.GET)
		public String mail2(
				@RequestParam int buddyNum,
				@RequestParam String page,
				@RequestParam(defaultValue="title") String condition,
				@RequestParam(defaultValue="") String keyword,
				Model model) throws Exception {

			keyword = URLDecoder.decode(keyword, "utf-8");
			
			String query="page="+page;
			if(keyword.length()!=0) {
				query+="&condition="+condition+"&keyword="+URLEncoder.encode(keyword, "UTF-8");
			}	
			
			service.updateCheck(buddyNum);

			Buddy dto = service.readBuddy(buddyNum);
			
			if(dto==null) {
				return "redirect:/Buddy/rlist?"+query;
			}      
	         
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("condition", condition);
			map.put("keyword", keyword);
			map.put("buddyNum", buddyNum);

			Buddy preReadDto = service.preReadBuddy(map);
			Buddy nextReadDto = service.nextReadBuddy(map);
	        		
			List<Buddy> listFile=service.listFile(buddyNum);
							
			model.addAttribute("dto", dto);
			model.addAttribute("preReadDto", preReadDto);
			model.addAttribute("nextReadDto", nextReadDto);
			model.addAttribute("listFile", listFile);
			model.addAttribute("page", page);
			model.addAttribute("query", query);
			
			return ".buddy.mail2";
		}	
		
	
	//보낸 메일 읽기 (미리보기)
		@RequestMapping(value="/buddy/sendmail", method=RequestMethod.GET)
		public String sendmail(
				@RequestParam int buddyNum,
				@RequestParam String empNo,
				@RequestParam String page,
				@RequestParam(defaultValue="title") String condition,
				@RequestParam(defaultValue="") String keyword,
				HttpServletRequest req,
				Model model) throws Exception {

			keyword = URLDecoder.decode(keyword, "utf-8");
			
			String query="page="+page;
			if(keyword.length()!=0) {
				query+="&condition="+condition+"&keyword="+URLEncoder.encode(keyword, "UTF-8");
			}	
			
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("buddyNum", buddyNum);
			map.put("empNo", empNo);

			Buddy dto = service.readSendBuddy(map);
			
			if(dto==null) {
				return "redirect:/Buddy/slist?"+query;
			} 
			
			dto.setsDate(dto.getsDate().substring(0,9));
	         
			Map<String, Object> map2 = new HashMap<String, Object>();
			map.put("condition", condition);
			map.put("keyword", keyword);
			map.put("buddyNum", buddyNum);

			Buddy preReadDto = service.preReadBuddy(map2);
			Buddy nextReadDto = service.nextReadBuddy(map2);
	        		
			List<Buddy> listFile=service.listFile(buddyNum);
			
			String cp=req.getContextPath();
			String articleUrl = cp+"/buddy/sendmail2?page=" + page;
							
			model.addAttribute("dto", dto);
			model.addAttribute("preReadDto", preReadDto);
			model.addAttribute("nextReadDto", nextReadDto);
			model.addAttribute("listFile", listFile);
			model.addAttribute("page", page);
			model.addAttribute("query", query);
			model.addAttribute("articleUrl", articleUrl);
			
			return "/buddy/sendmail";
		}	
	
	//보낸 메일 읽기 (전체보기) 
		@RequestMapping(value="/buddy/sendmail2")
		public String sendmail2(
				@RequestParam int buddyNum,
				@RequestParam String empNo,
				@RequestParam String page,
				@RequestParam(defaultValue="title") String condition,
				@RequestParam(defaultValue="") String keyword,
				Model model) throws Exception {

			keyword = URLDecoder.decode(keyword, "utf-8");
				
			String query="page="+page;
			if(keyword.length()!=0) {
				query+="&condition="+condition+"&keyword="+URLEncoder.encode(keyword, "UTF-8");
			}			
			
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("buddyNum", buddyNum);
			map.put("empNo", empNo);


			Buddy dto = service.readSendBuddy(map);
			if(dto==null) {
				return "redirect:/Buddy/slist?"+query;
			}       
		         
			Map<String, Object> map2 = new HashMap<String, Object>();
			map.put("condition", condition);
			map.put("keyword", keyword);
			map.put("buddyNum", buddyNum);

			Buddy preReadDto = service.preReadBuddy(map2);
			Buddy nextReadDto = service.nextReadBuddy(map2);
		        		
			List<Buddy> listFile=service.listFile(buddyNum);
						
			model.addAttribute("dto", dto);
			model.addAttribute("preReadDto", preReadDto);
			model.addAttribute("nextReadDto", nextReadDto);
			model.addAttribute("listFile", listFile);
			model.addAttribute("page", page);
			model.addAttribute("query", query);
				
			return ".buddy.sendmail2";
		}		
	
	// 중요 표시 (받은편지함)
	@RequestMapping(value="/buddy/update")
	public String buddyState(
			@RequestParam int buddyNum
			) throws Exception {
		
		try {
			service.updateState(buddyNum);
		} catch (Exception e) {
		}
	
		return "redirect:/buddy/rlist";
	}
	
	// 중요 표시 해제 (받은편지함)
	@RequestMapping(value="/buddy/update2")
	public String buddyState2(
			@RequestParam int buddyNum
			) throws Exception {
			
		try {
			service.updateState2(buddyNum);
		} catch (Exception e) {
		}
		
		return "redirect:/buddy/rlist";
	}
	
	// 중요 표시 (보관함)
		@RequestMapping(value="/buddy/update3")
		public String buddyState3(
				@RequestParam int buddyNum
				) throws Exception {
			
			try {
				service.updateState(buddyNum);
			} catch (Exception e) {
			}
		
			return "redirect:/buddy/keep";
		}
		
		// 중요 표시 해제 (보관함)
		@RequestMapping(value="/buddy/update4")
		public String buddyState4(
				@RequestParam int buddyNum
				) throws Exception {
				
			try {
				service.updateState2(buddyNum);
			} catch (Exception e) {
			}
			
			return "redirect:/buddy/keep";
		}
		
		
	// 파일 다운로드 
	@RequestMapping(value="/buddy/download")
	public void download(
			@RequestParam int fileNum,
			HttpServletResponse resp,
			HttpSession session) throws Exception {
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "buddy";

		boolean b = false;
		
		Buddy dto = service.readFile(fileNum);
		if(dto!=null) {
			String saveFilename = dto.getSaveFilename();
			String originalFilename = dto.getOriginalFilename();
			
			b = fileManager.doFileDownload(saveFilename, originalFilename, pathname, resp);
		}
		
		if (!b) {
			try {
				resp.setContentType("text/html; charset=utf-8");
				PrintWriter out = resp.getWriter();
				out.println("<script>alert('파일 다운로드가 불가능 합니다 !!!');history.back();</script>");
			} catch (Exception e) {
			}
		}
	}
	
	@RequestMapping(value="/buddy/zipdownload")
	public void zipdownload(
			@RequestParam int buddyNum,
			HttpServletResponse resp,
			HttpSession session) throws Exception {
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "buddy";

		boolean b = false;
		
		List<Buddy> listFile = service.listFile(buddyNum);
		if(listFile.size()>0) {
			String []sources = new String[listFile.size()];			// 소스파일명
			String []originals = new String[listFile.size()];		// 원래파일명
			String zipFilename = buddyNum+".zip";
			
			for(int idx = 0; idx<listFile.size(); idx++) {
				sources[idx] = pathname+File.separator+listFile.get(idx).getSaveFilename();
				originals[idx] = File.separator+listFile.get(idx).getOriginalFilename();
			}
			
			b = fileManager.doZipFileDownload(sources, originals, zipFilename, resp);
		}
		
		if (!b) {
			try {
				resp.setContentType("text/html; charset=utf-8");
				PrintWriter out = resp.getWriter();
				out.println("<script>alert('파일 다운로드가 불가능 합니다 !!!');history.back();</script>");
			} catch (Exception e) {
			}
		}
	}
	
	
	// 메일 삭제
	@RequestMapping(value="/buddy/delete")
	public String delete(
			@RequestParam int buddyNum,
			@RequestParam String page,
			@RequestParam(defaultValue="all") String condition,
			@RequestParam(defaultValue="") String keyword,
			HttpSession session) throws Exception {
		
		SessionInfo info=(SessionInfo)session.getAttribute("employee");
		
		keyword = URLDecoder.decode(keyword, "utf-8");
		String query="page="+page;
		if(keyword.length()!=0) {
			query+="&condition="+condition+"&keyword="+URLEncoder.encode(keyword, "UTF-8");
		}
		
/*		if(! info.getrCode().equals("admin")) {
			return "redirect:/community/list?"+query;
		}*/		
		
		try {
			String root = session.getServletContext().getRealPath("/");
			String pathname = root + "uploads" + File.separator + "buddy";
			service.deleteBuddy(buddyNum, pathname);
		} catch (Exception e) {
		}		
		
			return "redirect:/buddy/rlist?"+query;
		
	}
	
	@RequestMapping(value="/buddy/deleteList", method=RequestMethod.POST)
	public String deleteList(
			@RequestParam List<String> buddyNums,
			@RequestParam String page
			) throws Exception {
		
		service.deleteListBuddy(buddyNums);		
		
		return "redirect:/buddy/rlist?page="+page;
	}
	
	// 파일 삭제
	@RequestMapping(value="/buddy/deleteFile", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteFile(
			@RequestParam int fileNum,
			HttpSession session) throws Exception {
		
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "buddy";
		
		Buddy dto=service.readFile(fileNum);
		if(dto!=null) {
			fileManager.doFileDelete(dto.getSaveFilename(), pathname);
		}
		
		Map<String, Object> map=new HashMap<String, Object>();
		map.put("field", "fileNum");
		map.put("num", fileNum);
		service.deleteFile(map);
		
   	    // 작업 결과를 json으로 전송
		Map<String, Object> model = new HashMap<>(); 
		model.put("state", "true");
		return model;
	}
		
}
