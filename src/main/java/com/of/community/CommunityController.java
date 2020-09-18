package com.of.community;

import java.io.File;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
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

@Controller("community.communityController")
public class CommunityController {
	@Autowired
	private CommunityService service;
	@Autowired
	private MyUtil myUtil;
	@Autowired
	private FileManager fileManager;
	
	@RequestMapping(value="/community/list")
	public String list(
			@RequestParam(value="page", defaultValue="1") int current_page,
			@RequestParam(defaultValue="all") String condition,
			@RequestParam(defaultValue="") String keyword,
			HttpServletRequest req,
			Model model) throws Exception {
		
		int rows = 5; // 한 화면에 보여주는 게시물 수
		int total_page = 0;
		int dataCount = 0;
   	    
		if(req.getMethod().equalsIgnoreCase("GET")) { // GET 방식인 경우
			keyword = URLDecoder.decode(keyword, "utf-8");
		}
		
        // 전체 페이지 수
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("condition", condition);
        map.put("keyword", keyword);

        dataCount = service.dataCount(map);
        if(dataCount != 0)
            total_page = myUtil.pageCount(rows,  dataCount) ;

        // 다른 사람이 자료를 삭제하여 전체 페이지수가 변화 된 경우
        if(total_page < current_page) 
            current_page = total_page;   
        
        // 리스트에 출력할 데이터를 가져오기
        int offset = (current_page-1) * rows;
		if(offset < 0) offset = 0;
        map.put("offset", offset);
        map.put("rows", rows);

        // 글 리스트
        List<Community> list = service.listCommu(map);
        
        List<Community> listClub = service.listClub(map);

        // 리스트의 번호
        Date endDate = new Date();
        long gap;
        int listNum, n = 0;
        for(Community dto : list) {
            listNum = dataCount - (offset + n);
            dto.setListNum(listNum);
            
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date beginDate = formatter.parse(dto.getCreated());
            
            // 날짜차이(일)
            gap=(endDate.getTime() - beginDate.getTime()) / (24 * 60 * 60* 1000);
            dto.setGap(gap);

            dto.setCreated(dto.getCreated().substring(0, 10));
            
            n++;
        }
        
        String cp=req.getContextPath();
        String query = "";
        String listUrl = cp+"/community/list";
        String articleUrl = cp+"/community/article?page=" + current_page;
        if(keyword.length()!=0) {
        	query = "condition=" + condition + 
        	         "&keyword=" + URLEncoder.encode(keyword, "utf-8");	
        }
        
        if(query.length()!=0) {
        	listUrl = cp+"/community/list?" + query;
        	articleUrl = cp+"/community/article?page=" + current_page + "&"+ query;
        }
        
        String paging = myUtil.paging(current_page, total_page, listUrl);
		
		model.addAttribute("list", list);
		model.addAttribute("listClub", listClub);
		model.addAttribute("page", current_page);
		model.addAttribute("dataCount", dataCount);
		model.addAttribute("total_page", total_page);
		model.addAttribute("paging", paging);		
		model.addAttribute("articleUrl", articleUrl);
		
		model.addAttribute("condition", condition);
		model.addAttribute("keyword", keyword);
		
		return ".community.list";
	}

	@RequestMapping(value="/community/created", method=RequestMethod.GET)
	public String createdForm(
			Model model,
			HttpSession session
			) throws Exception {

		SessionInfo info=(SessionInfo)session.getAttribute("employee");
/*		if(! info.getEmpNo().equals("admin")) {
			return "redirect:/community/list";
		}
		*/
		Map<String, Object> map = new HashMap<String, Object>();			        
	    List<Community> listClub = service.listClub(map);	    
	   
		model.addAttribute("listClub", listClub);		
		model.addAttribute("mode", "created");
		
		return ".community.created";
	}

	@RequestMapping(value="/community/created", method=RequestMethod.POST)
	public String createdSubmit(
			Community dto,
			HttpSession session) throws Exception {
		
		SessionInfo info=(SessionInfo)session.getAttribute("employee");
		
/*		if(! info.getrCode().equals("admin")) {
			return "redirect:/community/list";	
		}*/

		try {
			String root = session.getServletContext().getRealPath("/");
			String pathname = root + "uploads" + File.separator + "community";		
			
			dto.setWriter(info.getEmpNo());
			service.insertCommu(dto, pathname);
		} catch (Exception e) {
		}
		
		return "redirect:/community/list";
	}

	@RequestMapping(value="/community/article")
	public String article(
			@RequestParam int commuNum,
			@RequestParam String page,
			@RequestParam(defaultValue="title") String condition,
			@RequestParam(defaultValue="") String keyword,
			Model model) throws Exception {

		keyword = URLDecoder.decode(keyword, "utf-8");
		
		String query="page="+page;
		if(keyword.length()!=0) {
			query+="&condition="+condition+"&keyword="+URLEncoder.encode(keyword, "UTF-8");
		}
		
		service.updateHitCount(commuNum);

		Community dto = service.readCommu(commuNum);
		if(dto==null) {
			return "redirect:/community/list?"+query;
		}
		
        //dto.setContent(dto.getContent().replaceAll("\n", "<br>"));
         
		// 이전 글, 다음 글
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("condition", condition);
		map.put("keyword", keyword);
		map.put("commuNum", commuNum);

		Community preReadDto = service.preReadCommu(map);
		Community nextReadDto = service.nextReadCommu(map);
        
		// 파일
		List<Community> listFile=service.listFile(commuNum);
				
		model.addAttribute("dto", dto);
		model.addAttribute("preReadDto", preReadDto);
		model.addAttribute("nextReadDto", nextReadDto);
		model.addAttribute("listFile", listFile);
		model.addAttribute("page", page);
		model.addAttribute("query", query);
		
		return ".community.article";
	}

	@RequestMapping(value="/community/update", method=RequestMethod.GET)
	public String updateForm(
			@RequestParam int commuNum,
			@RequestParam String page,
			HttpSession session,			
			Model model	) throws Exception {
		SessionInfo info=(SessionInfo)session.getAttribute("employee");
		
	/*	if(! info.getrCode().equals("admin")) {
			return "redirect:/community/list?page="+page;
		}*/
		
		System.out.println(page);

		Community dto = service.readCommu(commuNum);
		if(dto==null) {
			return "redirect:/community/list?page="+page;
		}
		
		List<Community> listFile=service.listFile(commuNum);
		
		Map<String, Object> map = new HashMap<String, Object>();			        
	    List<Community> listClub = service.listClub(map);	    
	   
		model.addAttribute("listClub", listClub);				
		model.addAttribute("mode", "update");
		model.addAttribute("page", page);
		model.addAttribute("dto", dto);
		model.addAttribute("listFile", listFile);
		
		return ".community.created";
	}

	@RequestMapping(value="/community/update", method=RequestMethod.POST)
	public String updateSubmit(
			Community dto,
			@RequestParam(defaultValue="1") String page,
			HttpSession session) throws Exception {		

		SessionInfo info=(SessionInfo)session.getAttribute("employee");
/*		if(! info.getrCode().equals("admin")) {
			return "redirect:/community/list?page="+page;
		}*/
		
		try {
			String root = session.getServletContext().getRealPath("/");
			String pathname = root + File.separator + "uploads" + File.separator + "community";		
			
			dto.setWriter(info.getEmpNo());
			service.updateCommu(dto, pathname);
		} catch (Exception e) {
		}
		
		return "redirect:/community/list?page="+page;
	}

	@RequestMapping(value="/community/delete")
	public String delete(
			@RequestParam int commuNum,
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
			String pathname = root + "uploads" + File.separator + "community";
			service.deleteCommu(commuNum, pathname);
		} catch (Exception e) {
		}
		
		return "redirect:/community/list?"+query;
	}

	/*서버에 저장된 파일 이름, 경로, 원래 파일 이름 필요*/
	@RequestMapping(value="/community/download")
	public void download(
			@RequestParam int fileNum,
			HttpServletResponse resp,
			HttpSession session) throws Exception {
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "community";

		boolean b = false;
		
		Community dto = service.readFile(fileNum);
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
	
	@RequestMapping(value="/community/zipdownload")
	public void zipdownload(
			@RequestParam int commuNum,
			HttpServletResponse resp,
			HttpSession session) throws Exception {
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "community";

		boolean b = false;
		
		List<Community> listFile = service.listFile(commuNum);
		if(listFile.size()>0) {
			String []sources = new String[listFile.size()];			// 소스파일명
			String []originals = new String[listFile.size()];		// 원래파일명
			String zipFilename = commuNum+".zip";
			
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
	
	@RequestMapping(value="/community/deleteFile", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteFile(
			@RequestParam int fileNum,
			HttpSession session) throws Exception {
		
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "community";
		
		Community dto=service.readFile(fileNum);
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
	
	// 게시글 좋아요 
		@RequestMapping(value="/community/insertCommuLike", method=RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> insertCommuLike(
				@RequestParam Map<String, Object> paramMap,
				HttpSession session
				) throws Exception {
			
			SessionInfo info = (SessionInfo)session.getAttribute("employee");
			paramMap.put("writer", info.getEmpNo());
			String state = "true";
			int count = 0;
			
			try {
				service.insertCommuLike(paramMap);
				
			} catch (Exception e) {
				state = "false";
			}
			
			int commuNum = Integer.parseInt((String)paramMap.get("commuNum"));
			count = service.commuLikeCount(commuNum);
			
			Map<String, Object> model = new HashMap<>();
			
			model.put("state", state);
			model.put("commuLikeCount", count);
			
			return model;		
		}
	
	// 댓글 리스트 : AJAX-text/html
		@RequestMapping(value="/community/listReply")
		public String list(
				@RequestParam int commuNum,
				@RequestParam(value="pageNo", defaultValue="1") int current_page,
				Model model
				) throws Exception {
			
			int rows=5;
			int dataCount=0;
			int total_page=0;
			
			Map<String, Object> map = new HashMap<>();
			map.put("commuNum", commuNum);
			
			dataCount = service.replyCount(map);
			total_page=myUtil.pageCount(rows, dataCount);		
			
			if(current_page>total_page) {
				current_page=total_page;
			}
			
			int offset=(current_page-1)*rows;
			if(offset<0) offset=0;
			
			map.put("offset", offset);
			map.put("rows", rows);
			
			List<CommuReply> list = service.listReply(map);
			for(CommuReply dto:list) {
				dto.setContent(myUtil.htmlSymbols(dto.getContent()));
			}
			
			String paging = myUtil.pagingMethod(current_page, 
					total_page, "listPage");
			
			model.addAttribute("listReply", list);
			model.addAttribute("pageNo", current_page);
			model.addAttribute("replyCount", dataCount);
			model.addAttribute("total_page", total_page);
			model.addAttribute("paging", paging);
			
			return "community/listReply";
		}
		
		// 댓글 및 답글 등록 : AJAX-JSON 
		@RequestMapping(value="/community/insertReply", method=RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> insertReply(
				CommuReply dto,
				HttpSession session 
				) throws Exception {
			Map<String, Object> model = new HashMap<>();
			String state ="true";
			SessionInfo info = (SessionInfo)session.getAttribute("employee");
			
			try {
				dto.setReplyWriter(info.getEmpNo());
				service.insertReply(dto);
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("commuNum", dto.getCommuNum());
				int replyCount = service.replyCount(map);
				model.put("replyCount", replyCount);
				
			} catch (Exception e) {
				state = "false";
			}
			
			model.put("state", state);
			
			return model;
		}
		
		// 댓글의 답글 리스트 : AJAX-Text 
		@RequestMapping(value="/community/listReplyAnswer")
		public String listReplyAnswer(
				@RequestParam int answer,
				Model model
				) throws Exception {
			
			List<CommuReply> list = service.listReplyAnswer(answer);
			for(CommuReply dto : list) {
				dto.setContent(myUtil.htmlSymbols(dto.getContent()));
			}
			
			model.addAttribute("listReplyAnswer", list);
			
			return "community/listReplyAnswer";		
		}	
		
		// 댓글의 답글 개수 : AJAX-JSON 
		@RequestMapping(value="/community/countReplyAnswer")
		@ResponseBody
		public Map<String, Object> countReplyAnswer(
				@RequestParam int answer
				) throws Exception {
			Map<String, Object> model = new HashMap<>();
			
			int count = service.replyAnswerCount(answer);
			model.put("count", count);
			
			return model;
		}
		
		// 댓글 및 댓글의 답글 삭제 : AJAX-JSON
		@RequestMapping(value="/community/deleteReply", method=RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> deleteReply(
				@RequestParam Map<String, Object> paramMap
				) throws Exception {
			String state = "true"; 
			try {
				service.deleteReply(paramMap);
				
			} catch (Exception e) {
				state = "false";
			}
			
			Map<String, Object> map = new HashMap<>();
			map.put("state", state);
			return map;
		}
		
		// 댓글 좋아요/싫어요 추가 및 좋아요/싫어요 개수 가져오기 
		@RequestMapping(value="/community/insertReplyLike", method=RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> insertReplyLike(
					@RequestParam Map<String, Object> paramMap,
					HttpSession session 
				) throws Exception {
			
			SessionInfo info = (SessionInfo)session.getAttribute("employee");
			String state = "true";
			
			try {
				paramMap.put("replyWriter", info.getEmpNo());
				service.insertReplyLike(paramMap);
			} catch (Exception e) {
				state = "false";
			}
			
			// 좋아요/싫어요 개수 가져오기 
			Map<String, Object> countMap = service.replyLikeCount(paramMap);
			
			// 마이바티스의 resultType이 map인 경우 int형은 BigDecimal로 넘어옴 		
			int likeCount = ((BigDecimal)countMap.get("LIKECOUNT")).intValue();
			int disLikeCount = ((BigDecimal)countMap.get("DISLIKECOUNT")).intValue();
			
			Map<String, Object> model = new HashMap<>();
			model.put("state", state);
			model.put("likeCount", likeCount);
			model.put("disLikeCount", disLikeCount);
			return model;
		}
		
		@RequestMapping(value="/community/clubMake", method=RequestMethod.GET)
		public String clubMakeForm(HttpSession session) throws Exception {

			SessionInfo info=(SessionInfo)session.getAttribute("employee");
	/*		if(! info.getEmpNo().equals("admin")) {
				return "redirect:/community/list";
			}
			*/			
			
			return ".community.clubMake";
		}

		@RequestMapping(value="/community/clubMake", method=RequestMethod.POST)
		public String clubMakeSubmit(
				Community dto,
				HttpSession session) throws Exception {
			
			SessionInfo info=(SessionInfo)session.getAttribute("employee");
			
	/*		if(! info.getrCode().equals("admin")) {
				return "redirect:/community/list";	
			}*/

			try {
				service.insertClub(dto);
			} catch (Exception e) {
			}
			
			return "redirect:/community/list";
		}		
	
}
