package com.of.notice;

import java.io.File;
import java.io.PrintWriter;
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

@Controller("noticeController")
@RequestMapping("/notice/*")
public class NoticeController {
	@Autowired
	private NoticeService service;
	@Autowired
	private MyUtil myUtil;
	@Autowired
	private FileManager fileManager;

	@RequestMapping(value="list")
	public String list(
			@RequestParam(value="page", defaultValue="1") int current_page,
			@RequestParam(defaultValue="title") String condition,
			@RequestParam(defaultValue="") String keyword,
			HttpServletRequest req,
			Model model
			) throws Exception{
		int rows = 10;
		int total_page=0;
		int dataCount=0;
		
		if(req.getMethod().equalsIgnoreCase("GET")) {
			keyword=URLDecoder.decode(keyword, "utf-8");
		}
		// 전체 페이지 수
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("condition", condition);
		map.put("keyword", keyword);
		
		dataCount = service.dataCount(map);
		if(dataCount!=0) {
			total_page=myUtil.pageCount(rows, dataCount);
		}
		
		// 다른 사람이 자료를 삭제하여 전체 페이지수가 변화 된 경우
		if(current_page>total_page) {
			current_page=total_page;
		}
		// 리스트에 출력할 데이터를 가져오기
		int offset = (current_page-1)*rows;
		if(offset < 0) offset=0;
		map.put("offset", offset);
		map.put("rows", rows);
		
		// 글 리스트
		List<Notice> list=service.listNotice(map);
		
		// 리스트의 번호
		Date endDate = new Date();
		long gap;
		int listNum, n=0;
		for(Notice dto : list) {
			listNum=dataCount-(offset+n);
			dto.setListNum(listNum);
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date beginDate = formatter.parse(dto.getCreated());
			
			// 날짜차이
			gap=(endDate.getTime()-beginDate.getTime())/(60*60* 1000);
			dto.setGap(gap);
			
			dto.setCreated(dto.getCreated().substring(0,10));
			n++;
		}
		
		String cp=req.getContextPath();
		String query="";
		String listUrl=cp+"/notice/list";
		String articleUrl=cp+"/notice/article?page="+current_page;
		if(keyword.length()!=0) {
			query="condition="+condition+"&keyword="+URLEncoder.encode(keyword, "utf-8");
		}
		if(query.length()!=0) {
			listUrl=cp+"/notice/list?"+query;
			articleUrl=cp+"/notice/article?page="+current_page+"&"+query;
		}
		
		String paging = myUtil.paging(current_page, total_page, listUrl);
		
		model.addAttribute("list", list);
		model.addAttribute("page", current_page);
		model.addAttribute("dataCount", dataCount);
		model.addAttribute("total_page", total_page);
		model.addAttribute("paging", paging);
		model.addAttribute("articleUrl", articleUrl);
		model.addAttribute("condition", condition);
		model.addAttribute("keyword", keyword);
				
		return ".notice.list";		
	}
	
	@RequestMapping(value="created", method=RequestMethod.GET)
	public String createdForm(HttpSession session, Model model) throws Exception{
		model.addAttribute("mode", "created");
		return ".notice.created";
	}
	
	@RequestMapping(value="created", method=RequestMethod.POST)
	public String createdSubmit(
			Notice dto,
			HttpSession session
			) throws Exception{
		SessionInfo info=(SessionInfo)session.getAttribute("employee");
		
		try {
			String root = session.getServletContext().getRealPath("/");
			String pathname = root + "uploads" + File.separator + "notice";		
			
			dto.setWriter(info.getEmpNo());
			service.insertNotice(dto, pathname);
		} catch (Exception e) {
		}
		return "redirect:/notice/list";
	}
	
	@RequestMapping(value="article")
	public String article(
			@RequestParam int noticeNum,
			@RequestParam String page,
			@RequestParam(defaultValue="title") String condition,
			@RequestParam(defaultValue="") String keyword,
			Model model
			) throws Exception{

		
		keyword = URLDecoder.decode(keyword, "utf-8");
		
		String query="page="+page;
		if(keyword.length()!=0) {
			query+="&condition="+condition+"&keyword="+URLEncoder.encode(keyword, "utf-8");
		}
		
		service.updateHitCount(noticeNum);
		
		Notice dto = service.readNotice(noticeNum);
		if(dto==null) {
			return "redirect:/notice/list?"+query;
		}
		//dto.setContent(dto.getContent().replaceAll("\n", "<br>"));
		
		// 이전글, 다음글
		Map<String, Object> map = new HashMap<>();
		map.put("condition", condition);
		map.put("keyword", keyword);
		map.put("noticeNum", noticeNum);
		
		Notice preReadDto=service.preReadNotice(map);
		Notice nextReadDto=service.nextReadNotice(map);
		
		// 파일
		List<Notice> listFile = service.listFile(noticeNum);
		
		model.addAttribute("dto",dto);
		model.addAttribute("preReadDto", preReadDto);
		model.addAttribute("nextReadDto",nextReadDto);
		model.addAttribute("listFile", listFile);
		model.addAttribute("page", page);
		model.addAttribute("query",query);
		
		return ".notice.article";
	}
	@RequestMapping(value="update", method=RequestMethod.GET)
	public String updateForm(
			@RequestParam int noticeNum,
			@RequestParam String page,
			HttpSession session,
			Model model
			) throws Exception{
		
		
		Notice dto=service.readNotice(noticeNum);
		if(dto==null) {
			return "redirect:/notice/list?page="+page;
		}
		
		// 파일
		List<Notice> listFile = service.listFile(noticeNum);
		
		model.addAttribute("mode", "update");
		model.addAttribute("page", page);
		model.addAttribute("dto", dto);
		model.addAttribute("listFile", listFile);
		
		return ".notice.created";
	}
	
	@RequestMapping(value="update", method=RequestMethod.POST)
	public String updateSubmit(
			Notice dto,
			@RequestParam String page,
			HttpSession session
			) throws Exception{
		
		SessionInfo info=(SessionInfo)session.getAttribute("employee");
		try {
			String root = session.getServletContext().getRealPath("/");
			String pathname = root + File.separator + "uploads" + File.separator + "notice";		
			
			dto.setWriter(info.getEmpNo());
			service.updateNotice(dto, pathname);
		} catch (Exception e) {
		}
		
		return "redirect:/notice/list?page="+page;
	}
	
	@RequestMapping("delete")
	public String delete(
			@RequestParam int noticeNum,
			@RequestParam String page,
			@RequestParam(defaultValue="title") String condition,
			@RequestParam(defaultValue="") String keyword,
			HttpSession session
			) throws Exception{
		keyword = URLDecoder.decode(keyword, "utf-8");
		String query="page="+page;
		if(keyword.length()!=0) {
			query+="&condition="+condition+"&keyword="+URLEncoder.encode(keyword, "UTF-8");
		}
/*		
		if(! info.getUserId().equals("admin")) {
			return "redirect:/notice/list?"+query;
		}
		*/
		try {
			String root = session.getServletContext().getRealPath("/");
			String pathname = root + "uploads" + File.separator + "notice";
			service.deleteNotice(noticeNum, pathname);
		} catch (Exception e) {
		}
		
		return "redirect:/notice/list?"+query;
	}
	
	@RequestMapping("download")
	public void download(
			@RequestParam int fileNum,
			HttpServletResponse resp,
			HttpSession session			
			) throws Exception{
		String root = session.getServletContext().getRealPath("/");		
		String pathname = root + "uploads" + File.separator + "notice"; // session필요한 이유 : 이미지파일때문에 경로찾는것임

		boolean b = false;
		
		Notice dto=service.readFile(fileNum);
		if(dto!=null) {
			String saveFilename= dto.getSaveFilename();
			String originalFilename=dto.getOriginalFilename();
			
			b=fileManager.doFileDownload(saveFilename, originalFilename, pathname, resp);
		}
		
		if(!b) {
			try {
				resp.setContentType("text/html;charset=utf-8");
				PrintWriter out=resp.getWriter();
				out.println("<script>alert('파일 다운로드가 불가능 합니다 !!!');history.back();</script>");
			} catch (Exception e) {
			}
		}
	}
	
	@RequestMapping(value="deleteFile", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteFile(
			@RequestParam int fileNum,
			HttpSession session) throws Exception {
		
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "notice";
		
		Notice dto=service.readFile(fileNum);
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
	
	
	// 댓글 등록
	@RequestMapping(value="insertReply", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insertReply(
			NoticeReply dto, 
			HttpSession session
			) throws Exception{
		SessionInfo info =(SessionInfo)session.getAttribute("employee");
		String state="true";
		
		try {
			dto.setReplyWriter(info.getEmpNo());
			service.insertReply(dto);
		} catch (Exception e) {
			state="false";
		}
		
		Map<String, Object> model = new HashMap<>();
		model.put("state", state);
		return model;
	}
	
	//댓글 리스트
	@RequestMapping("listReply")
	public String listReply(
			@RequestParam int noticeNum,
			@RequestParam(value="pageNo", defaultValue="1") int current_page,
			Model model
			) throws Exception{
		
		int rows=5;
		int total_page=0;
		int dataCount=0;
		
		Map<String, Object> map = new HashMap<>();
		map.put("noticeNum", noticeNum);
		
		dataCount=service.replyCount(map);
		total_page=myUtil.pageCount(rows, dataCount);
		if(current_page>total_page) {
			current_page=total_page;
		}
		
		int offset = (current_page-1)*rows;
		if(offset<0) offset=0;
		map.put("offset", offset);
		map.put("rows", rows);
		List<NoticeReply> listReply = service.listReply(map);
		
		for(NoticeReply dto : listReply) {
			dto.setContent(dto.getContent().replaceAll("\n", "<br>"));
		}
		
		// ajax용 페이징
		String paging=myUtil.pagingMethod(current_page, total_page, "listPage");
		
		// 포워딩할  jsp로 넘길 데이터
		model.addAttribute("listReply", listReply);
		model.addAttribute("pageNo", current_page);
		model.addAttribute("replyCount", dataCount);
		model.addAttribute("total_page", total_page);
		model.addAttribute("paging", paging);
		
		return "notice/listReply";
		
	}
	
	//댓글삭제
	@RequestMapping(value="deleteReply", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteReply(
			@RequestParam Map<String, Object> paramMap
			){
		String state="true";
		
		try {
			service.deleteReply(paramMap);
		} catch (Exception e) {
			state="false";
		}
		
		Map<String, Object> map = new HashMap<>();
		map.put("state", state);
		return map;
	}
	
}
