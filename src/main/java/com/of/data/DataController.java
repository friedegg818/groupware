package com.of.data;

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

@Controller("data.dataController")
public class DataController {
	@Autowired
	private DataService service;
	@Autowired
	private MyUtil myUtil;
	@Autowired
	private FileManager fileManager;
	
	@RequestMapping(value="/data/list")
	public String list(			
			@RequestParam(value="page", defaultValue="1") int current_page,
			@RequestParam(defaultValue="all") String condition,
			@RequestParam(defaultValue="") String keyword,
			@RequestParam(defaultValue="NON") String dCode,
			HttpServletRequest req,
			Model model) throws Exception {
		
		int rows = 10; 
		int total_page = 0;
		int dataCount = 0;
   	    
		if(req.getMethod().equalsIgnoreCase("GET")) { 
			keyword = URLDecoder.decode(keyword, "utf-8");
		}		
      
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("condition", condition);
        map.put("keyword", keyword);
        map.put("dCode", dCode);

        dataCount = service.dataCount(map);
        if(dataCount != 0)
            total_page = myUtil.pageCount(rows,  dataCount) ;
       
        if(total_page < current_page) 
            current_page = total_page;           
        
        int offset = (current_page-1) * rows;
		if(offset < 0) offset = 0;
        map.put("offset", offset);
        map.put("rows", rows);
      
        List<Data> list = service.listData(map);
        int totalFile = service.totalFile();
        
        Date endDate = new Date();
        long gap;
        int listNum, n = 0;
        for(Data dto : list) {
            listNum = dataCount - (offset + n);
            dto.setListNum(listNum);
            
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date beginDate = formatter.parse(dto.getCreated());            
            
            gap=(endDate.getTime() - beginDate.getTime()) / (24 * 60 * 60* 1000);
            dto.setGap(gap);

            dto.setCreated(dto.getCreated().substring(0, 10));
            
            n++;
        }
        
        String cp=req.getContextPath();
        String query = "";
        String listUrl = cp+"/data/list";
        String articleUrl = cp+"/data/article?page=" + current_page;
        if(keyword.length()!=0) {
        	query = "condition=" + condition + 
        	         "&keyword=" + URLEncoder.encode(keyword, "utf-8");	
        }
        
        if(query.length()!=0) {
        	listUrl = cp+"/data/list?" + query;
        	articleUrl = cp+"/data/article?page=" + current_page + "&"+ query;
        }
        
        String paging = myUtil.paging(current_page, total_page, listUrl);   
              
        model.addAttribute("totalFile", totalFile);
		model.addAttribute("list", list);
		model.addAttribute("page", current_page);
		model.addAttribute("dataCount", dataCount);
		model.addAttribute("total_page", total_page);
		model.addAttribute("paging", paging);		
		model.addAttribute("articleUrl", articleUrl);
		
		model.addAttribute("dCode", dCode);			
		model.addAttribute("condition", condition);
		model.addAttribute("keyword", keyword);
		
		return ".data.list";
	}	
	
	@RequestMapping(value="/data/deptList")
	public String deptListData(			
			@RequestParam(value="page", defaultValue="1") int current_page,
			@RequestParam(defaultValue="all") String condition,
			@RequestParam(defaultValue="") String keyword,
			@RequestParam(defaultValue="") String dCode,
			HttpServletRequest req,
			Model model) throws Exception {
		
		int rows = 10; 
		int total_page = 0;
		int dataCount = 0;
   	    
		if(req.getMethod().equalsIgnoreCase("GET")) { 
			keyword = URLDecoder.decode(keyword, "utf-8");
		}		
      
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("condition", condition);
        map.put("keyword", keyword);
        map.put("dCode", dCode);

        dataCount = service.dataCount(map);
        if(dataCount != 0)
            total_page = myUtil.pageCount(rows,  dataCount) ;
       
        if(total_page < current_page) 
            current_page = total_page;           
        
        int offset = (current_page-1) * rows;
		if(offset < 0) offset = 0;
        map.put("offset", offset);
        map.put("rows", rows);
      
      
        List<Data> list = service.deptListData(map);
        int totalFile = service.totalFile();
        String type = "";
        Date endDate = new Date();
        long gap;
        int listNum, n = 0;
        for(Data dto : list) {
            listNum = dataCount - (offset + n);
            dto.setListNum(listNum);
            
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date beginDate = formatter.parse(dto.getCreated());            
            
            gap=(endDate.getTime() - beginDate.getTime()) / (24 * 60 * 60* 1000);
            dto.setGap(gap);
            
            type = dto.getdType();
            
            dto.setCreated(dto.getCreated().substring(0, 10));
            
            n++;
        }
        
        
        
        String cp=req.getContextPath();
        String query = "";
        String listUrl = cp+"/data/deptList";
        String articleUrl = cp+"/data/article?page=" + current_page;
        if(keyword.length()!=0) {
        	query = "condition=" + condition + 
        	         "&keyword=" + URLEncoder.encode(keyword, "utf-8");	
        }
        
        if(query.length()!=0) {
        	listUrl = cp+"/data/deptList?" + query;
        	articleUrl = cp+"/data/article?page=" + current_page + "&"+ query;
        }
        
        String paging = myUtil.paging(current_page, total_page, listUrl);   
              
        model.addAttribute("totalFile", totalFile);
		model.addAttribute("list", list);
		model.addAttribute("page", current_page);
		model.addAttribute("dataCount", dataCount);
		model.addAttribute("total_page", total_page);
		model.addAttribute("paging", paging);		
		model.addAttribute("articleUrl", articleUrl);
		model.addAttribute("val", type);		
		model.addAttribute("dCode", dCode);
		model.addAttribute("condition", condition);
		model.addAttribute("keyword", keyword);
		
		return ".data.deptList";
	}	
	
	@RequestMapping(value="/data/created", method=RequestMethod.GET)
	public String createdForm(
			Model model,
			HttpSession session
			) throws Exception {

		SessionInfo info=(SessionInfo)session.getAttribute("employee");
/*		if(! info.getEmpNo().equals("admin")) {
			return "redirect:/community/list";
		}
		*/
		model.addAttribute("mode", "created");
		
		return ".data.created";
	}

	@RequestMapping(value="/data/created", method=RequestMethod.POST)
	public String createdSubmit(
			Data dto,
			HttpSession session) throws Exception {
		
		SessionInfo info=(SessionInfo)session.getAttribute("employee");
		
/*		if(! info.getrCode().equals("admin")) {
			return "redirect:/data/list";	
		}*/

		try {
			String root = session.getServletContext().getRealPath("/");
			String pathname = root + "uploads" + File.separator + "data";		
			
			dto.setWriter(info.getEmpNo());
			service.insertData(dto, pathname);
		} catch (Exception e) {
		}
		
		return "redirect:/data/list";
	}
	
	
	@RequestMapping(value="/data/article")
	public String article(
			@RequestParam int dataNum,
			@RequestParam String page,
			@RequestParam(defaultValue="title") String condition,
			@RequestParam(defaultValue="") String keyword,
			Model model) throws Exception {

		keyword = URLDecoder.decode(keyword, "utf-8");
		
		String query="page="+page;
		if(keyword.length()!=0) {
			query+="&condition="+condition+"&keyword="+URLEncoder.encode(keyword, "UTF-8");
		}		

		Data dto = service.readData(dataNum);
		if(dto==null) {
			return "redirect:/data/list?"+query;
		}       
         
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("condition", condition);
		map.put("keyword", keyword);
		map.put("dataNum", dataNum);

		Data preReadDto = service.preReadData(map);
		Data nextReadDto = service.nextReadData(map);
        		
		List<Data> listFile=service.listFile(dataNum);
				
		model.addAttribute("dto", dto);
		model.addAttribute("preReadDto", preReadDto);
		model.addAttribute("nextReadDto", nextReadDto);
		model.addAttribute("listFile", listFile);
		model.addAttribute("page", page);
		model.addAttribute("query", query);
		
		return ".data.article";
	}	
	
	@RequestMapping(value="/data/update", method=RequestMethod.GET)
	public String updateForm(
			@RequestParam int dataNum,
			@RequestParam String page,
			HttpSession session,			
			Model model	) throws Exception {
		SessionInfo info=(SessionInfo)session.getAttribute("employee");
		
	/*	if(! info.getrCode().equals("admin")) {
			return "redirect:/community/list?page="+page;
		}*/
		
		System.out.println(page);

		Data dto = service.readData(dataNum);
		if(dto==null) {
			return "redirect:/data/list?page="+page;
		}
		
		List<Data> listFile=service.listFile(dataNum);	
			
		model.addAttribute("mode", "update");
		model.addAttribute("page", page);
		model.addAttribute("dto", dto);
		model.addAttribute("listFile", listFile);
		
		return ".data.created";
	}

	@RequestMapping(value="/data/update", method=RequestMethod.POST)
	public String updateSubmit(
			Data dto,
			@RequestParam(defaultValue="1") String page,
			HttpSession session) throws Exception {		

		SessionInfo info=(SessionInfo)session.getAttribute("employee");
/*		if(! info.getrCode().equals("admin")) {
			return "redirect:/community/list?page="+page;
		}*/
		
		try {
			String root = session.getServletContext().getRealPath("/");
			String pathname = root + File.separator + "uploads" + File.separator + "data";		
			
			dto.setWriter(info.getEmpNo());
			service.updateData(dto, pathname);
		} catch (Exception e) {
		}
		
		return "redirect:/data/list?page="+page;
	}	
	
	
	@RequestMapping(value="/data/delete")
	public String delete(
			@RequestParam int dataNum,
			@RequestParam String page,
			@RequestParam(defaultValue="all") String condition,
			@RequestParam(defaultValue="") String keyword,
			@RequestParam String dCode,
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
			String pathname = root + "uploads" + File.separator + "data";
			service.deleteData(dataNum, pathname);
		} catch (Exception e) {
		}
		
		if(dCode.equals("NON")) {
			return "redirect:/data/list?"+query;
		} else {
			return "redirect:/data/deptList?dCode="+dCode;
		}
		
		
	}
	
	
	
	@RequestMapping(value="/data/download")
	public void download(
			@RequestParam int fileNum,
			HttpServletResponse resp,
			HttpSession session) throws Exception {
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "data";

		boolean b = false;
		
		Data dto = service.readFile(fileNum);
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
	
	@RequestMapping(value="/data/zipdownload")
	public void zipdownload(
			@RequestParam int dataNum,
			HttpServletResponse resp,
			HttpSession session) throws Exception {
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "data";

		boolean b = false;
		
		List<Data> listFile = service.listFile(dataNum);
		if(listFile.size()>0) {
			String []sources = new String[listFile.size()];			// 소스파일명
			String []originals = new String[listFile.size()];		// 원래파일명
			String zipFilename = dataNum+".zip";
			
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
	
	@RequestMapping(value="/data/deleteFile", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteFile(
			@RequestParam int fileNum,
			HttpSession session) throws Exception {
		
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "data";
		
		Data dto=service.readFile(fileNum);
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
	
	
	
	
	@RequestMapping(value="/data/listReply")
	public String list(
			@RequestParam int dataNum,
			@RequestParam(value="pageNo", defaultValue="1") int current_page,
			Model model
			) throws Exception {
		
		int rows=5;
		int dataCount=0;
		int total_page=0;
		
		Map<String, Object> map = new HashMap<>();
		map.put("dataNum", dataNum);
		
		dataCount = service.replyCount(map);
		total_page=myUtil.pageCount(rows, dataCount);		
		
		if(current_page>total_page) {
			current_page=total_page;
		}
		
		int offset=(current_page-1)*rows;
		if(offset<0) offset=0;
		
		map.put("offset", offset);
		map.put("rows", rows);
		
		List<DataReply> list = service.listReply(map);
		for(DataReply dto:list) {
			dto.setContent(myUtil.htmlSymbols(dto.getContent()));
		}
		
		String paging = myUtil.pagingMethod(current_page, 
				total_page, "listPage");
		
		model.addAttribute("listReply", list);
		model.addAttribute("pageNo", current_page);
		model.addAttribute("replyCount", dataCount);
		model.addAttribute("total_page", total_page);
		model.addAttribute("paging", paging);
		
		return "data/listReply";
	}
	
	
	@RequestMapping(value="/data/insertReply", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insertReply(
			DataReply dto,
			HttpSession session 
			) throws Exception {
		Map<String, Object> model = new HashMap<>();
		String state ="true";
		SessionInfo info = (SessionInfo)session.getAttribute("employee");
		
		try {
			dto.setReplyWriter(info.getEmpNo());
			service.insertReply(dto);
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		
		return model;
	}	
	
	@RequestMapping(value="/data/listReplyAnswer")
	public String listReplyAnswer(
			@RequestParam int answer,
			Model model
			) throws Exception {
		
		List<DataReply> list = service.listReplyAnswer(answer);
		for(DataReply dto : list) {
			dto.setContent(myUtil.htmlSymbols(dto.getContent()));
		}
		
		model.addAttribute("listReplyAnswer", list);
		
		return "data/listReplyAnswer";		
	}	
	
	
	@RequestMapping(value="/data/countReplyAnswer")
	@ResponseBody
	public Map<String, Object> countReplyAnswer(
			@RequestParam int answer
			) throws Exception {
		Map<String, Object> model = new HashMap<>();
		
		int count = service.replyAnswerCount(answer);
		model.put("count", count);
		
		return model;
	}
	
	
	@RequestMapping(value="/data/deleteReply", method=RequestMethod.POST)
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
	
	
	@RequestMapping(value="/data/deleteList", method=RequestMethod.POST)
	public String deleteList(
			@RequestParam List<String> dataNums,
			@RequestParam String page
			) throws Exception {
		
		service.deleteListData(dataNums);		
		
		return "redirect:/data/list?page="+page;
	}	
}
