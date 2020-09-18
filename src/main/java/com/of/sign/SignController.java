
package com.of.sign;

import java.io.File;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
import com.of.news.News;

@Controller("sign.signController")
@RequestMapping("/sign/*")
public class SignController {
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
	private SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd"); 

	@Autowired
	private SignService service;
	@Autowired
	private MyUtil myUtil;
	@Autowired
	private FileManager fileManager;

	// main리스트 출력
	@RequestMapping(value = "mainList")
	public String list(HttpServletRequest req, HttpSession session, Model model) throws Exception {

		int rows = 3;
		int offset = 0;

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("offset", offset);
		map.put("rows", rows);

		SessionInfo info = (SessionInfo) session.getAttribute("employee");
		map.put("empNo", info.getEmpNo());

		List<Sign> list = service.listSign(map, "wait");

		List<Sign> list2 = service.stepList(map, "reci");

		List<Sign> list3 = service.finishList(map, "fini");

		map.put("finish", "finish");

		// 결재대기함
		
		for (Sign dto : list) {
			Date date = sdf.parse(dto.getSdate());
			String sd = sdf1.format(date);
			dto.setSdate(sd);
		}
		model.addAttribute("list", list);

		// 수신대기함
		for (Sign dto : list2) {
			Date date = sdf.parse(dto.getSdate());
			String sd = sdf1.format(date);
			dto.setSdate(sd);
		}
		model.addAttribute("rlist", list2);
		
		// 결재 완료함
		for (Sign dto : list3) {
			Date date = sdf.parse(dto.getSdate());
			String sd = sdf1.format(date);
			dto.setSdate(sd);
		}
		model.addAttribute("flist", list3);
		
		// 반려함
		rows = 1;
		offset = 0;

		map.put("offset", offset);
		map.put("rows", rows);

		List<Sign> returnList4 = service.returnSignList(map);
		model.addAttribute("returnList", returnList4);
		
		// 임시저장함
		List<Sign> storageList = service.storageList(map);
		
		for(Sign dto : storageList) {
			if(dto.getSsubject().length()>=32) {
				dto.setSsubject(dto.getSsubject().substring(0, 32) + "…");
			}
		}
		
		model.addAttribute("storageList",storageList);
		
		
		return ".sign.mainList";
	}

	// 희망 문서함 페이징처리 후 리스트 출력
	@RequestMapping(value = "list")
	public String showList(
			HttpServletRequest req,
			@RequestParam(value = "page", defaultValue = "1") int current_page,
			@RequestParam(defaultValue = "all") String condition,
			@RequestParam(defaultValue = "") String keyword,
			@RequestParam String mode,
			HttpSession session,
			String storage,
			Model model) throws Exception {

		String cp = req.getContextPath();

		SessionInfo info = (SessionInfo) session.getAttribute("employee");

		int rows = 15; // 15 줄씩 출력
		int total_page = 0;
		int dataCount = 0;

		if (req.getMethod().equalsIgnoreCase("GET")) {
			keyword = URLDecoder.decode(keyword, "utf-8");
		}
		// 페이지 수 출력
		Map<String, Object> map = new HashMap<>();
		map.put("condition", condition);
		map.put("keyword", keyword);

		int offset = (current_page - 1) * rows;
		if (offset < 0)
			offset = 0;
		map.put("offset", offset);
		map.put("rows", rows);
		// 문서함 종류 선택

		List<Sign> list = null;
		int listNum, n = 0;
		String paging = null;
		String query = "";
		String listUrl = cp + "/sign/list?mode=" + mode;
		String articleUrl = cp + "/sign/article?page=" + current_page;

		String option = mode;
		map.put("empNo", info.getEmpNo());
		switch (mode) {
		case "1":
			mode = "결재대기함";

			list = service.listSign(map, "wait");

			dataCount = service.dataCount(map, "wait");

			if (dataCount != 0) {
				total_page = myUtil.pageCount(rows, dataCount);
			}

			// 페이지 변화 시 설정
			if (total_page < current_page) {
				current_page = total_page;
			}

			for (Sign dto : list) {
				listNum = dataCount - (offset + n)-1;
				dto.setListNum(listNum);
				
				Date date = sdf.parse(dto.getSdate());
				String sd = sdf1.format(date);
				dto.setSdate(sd);
				
				n++;
			}
			paging = myUtil.paging(current_page, total_page, listUrl);

			break;

		case "2":
			mode = "수신대기함";

			list = service.stepList(map, keyword);

			dataCount = service.stepCount(map);
			if (dataCount != 0) {
				total_page = myUtil.pageCount(rows, dataCount);
			}

			// 페이지 변화 시 설정
			if (total_page < current_page) {
				current_page = total_page;
			}

			for (Sign dto : list) {
				listNum = dataCount - (offset + n);
				dto.setListNum(listNum);

				Date date = sdf.parse(dto.getSdate());
				String sd = sdf1.format(date);
				dto.setSdate(sd);
				
				n++;
			}

			paging = myUtil.paging(current_page, total_page, listUrl);

			model.addAttribute("list", list);
			model.addAttribute("dataCount", dataCount);
			model.addAttribute("total_page", total_page);
			model.addAttribute("page", current_page);
			model.addAttribute("paging", paging);
			break;
		case "3":
			mode = "결재완료함";

			list = service.finishList(map, keyword);

			dataCount = service.dataCount(map, "fini");

			if (dataCount != 0) {
				total_page = myUtil.pageCount(rows, dataCount);
			}

			// 페이지 변화 시 설정
			if (total_page < current_page) {
				current_page = total_page;
			}

			for (Sign dto : list) {
				listNum = dataCount - (offset + n);
				dto.setListNum(listNum);

				Date date = sdf.parse(dto.getSdate());
				String sd = sdf1.format(date);
				dto.setSdate(sd);
				n++;
			}
			paging = myUtil.paging(current_page, total_page, listUrl);

			break;
		case "4":
			mode = "반려함";

			int empNo = Integer.parseInt(info.getEmpNo());

			map.put("empNo", empNo);
			list = service.returnSignList(map);
			dataCount = service.returnDataCount(empNo);

			if (dataCount != 0) {
				total_page = myUtil.pageCount(rows, dataCount);
			}

			if (total_page < current_page) {
				current_page = total_page;
			}
			
			for (Sign dto : list) {
				listNum = dataCount - (offset + n);
				dto.setListNum(listNum);

				Date date = sdf.parse(dto.getSdate());
				String sd = sdf1.format(date);
				dto.setSdate(sd);
				n++;
			}

			paging = myUtil.paging(current_page, total_page);

			break;
		case "5":
			mode = "검색리스트";

			list = service.seatchList(map, "searching");

			dataCount = service.searchDataCount(map, "searching");

			if (dataCount != 0) {
				total_page = myUtil.pageCount(rows, dataCount);
			}

			// 페이지 변화 시 설정
			if (total_page < current_page) {
				current_page = total_page;
			}

			for (Sign dto : list) {
				listNum = dataCount - (offset + n);
				dto.setListNum(listNum);

				Date date = sdf.parse(dto.getSdate());
				String sd = sdf1.format(date);
				dto.setSdate(sd);
				n++;
			}
			paging = myUtil.paging(current_page, total_page, listUrl);

			break;

		case "6":
			mode = "임시보관함";
			empNo = Integer.parseInt(info.getEmpNo());
			map.put("empNo", empNo);
			
			list = service.storageList(map);
			
			dataCount = service.storageDataCount(empNo); 
			
			if (dataCount != 0) {
				total_page = myUtil.pageCount(rows, dataCount);
			}

			// 페이지 변화 시 설정
			if (total_page < current_page) {
				current_page = total_page;
			}

			for (Sign dto : list) {
				listNum = dataCount - (offset + n);
				dto.setListNum(listNum);

				Date date = sdf.parse(dto.getSdate());
				String sd = sdf1.format(date);
				dto.setSdate(sd);
				n++;
			}
			paging = myUtil.paging(current_page, total_page, listUrl);

			break;
		}

		if (keyword.length() != 0) {
			query = "condition=" + condition + "&keyword=" + URLEncoder.encode(keyword, "utf-8") + "&mode=" + mode;
		}

		if (query.length() != 0) {
			listUrl = cp + "/sign/list?mode=" + mode + query;
			articleUrl = cp + "sign/article?page=" + current_page + "&" + query;
		}

		model.addAttribute("option", option);
		model.addAttribute("list", list);
		model.addAttribute("dataCount", dataCount);
		model.addAttribute("total_page", total_page);
		model.addAttribute("page", current_page);
		model.addAttribute("paging", paging);
		model.addAttribute("articleUrl", articleUrl);
		model.addAttribute("condition", condition);
		model.addAttribute("keyword", keyword);
		model.addAttribute("mode", mode);

		return ".sign.list";
	}

	// create jsp 호출
	@RequestMapping(value = "created", method = RequestMethod.GET)
	public String craeteForm(HttpSession session, Model model) throws Exception {
		// model.addAttribute("mode", "created");
		return ".sign.created";
	}

	// insert
	@RequestMapping(value = "created", method = RequestMethod.POST)
	public String craeteSubmit(
			Sign dto,
			@RequestParam int option,
			@RequestParam String lineEmp2,
			@RequestParam String lineEmp3,
			@RequestParam String lineEmp4,
			@RequestParam(defaultValue="") String pempNo2,
			@RequestParam(defaultValue="") String pempNo3,
			@RequestParam(defaultValue="") String pempNo4,
			@RequestParam(defaultValue="") String article,
			@RequestParam(defaultValue="") String endDate,
			@RequestParam(defaultValue="") String hiddenSnum,
			@RequestParam(defaultValue="") String modes,
			HttpSession session
			) throws Exception {
		try {
			dto.setStnum(option);
			String root = session.getServletContext().getRealPath("/");
			String pathname = root + "uploads" + File.separator + "sign";

			SessionInfo info = (SessionInfo) session.getAttribute("employee");

			dto.setEmpNo(Integer.parseInt(info.getEmpNo()));
			dto.setName(info.getName());
			dto.setSdept(info.getdType());
			int count = 1;
			
			if(modes.equals("임시보관함")) {
				article = "";
				lineEmp2 = pempNo2;
				lineEmp3 = pempNo3;
				lineEmp4 = pempNo4;
			}
			
			if(article.equals("article")) {
				lineEmp2 = pempNo2;
				lineEmp3 = pempNo3;
				lineEmp4 = pempNo4;
			}
			
			if (!lineEmp2.equals("0")) {
				count++;
			}
			dto.setpEmpNo2(lineEmp2);

			if (!lineEmp3.equals("0")) {
				count++;
			}
			dto.setpEmpNo3(lineEmp3);

			if (!lineEmp4.equals("0")) {
				count++;
			}
			dto.setpEmpNo4(lineEmp4);

			dto.setSendStep(count);
			
			if(endDate.length() != 0) {
				String content = dto.getScontent() + " / " + endDate;
				dto.setScontent(content);
			}
			service.insertSign(dto, pathname, article, hiddenSnum);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:/sign/mainList";
	}
	
	@RequestMapping(value = "storage", method = RequestMethod.POST)
	public String storageSubmit(
			Sign dto,
			@RequestParam int option,
			@RequestParam String lineEmp2,
			@RequestParam String lineEmp3,
			@RequestParam String lineEmp4,
			HttpSession session,
			@RequestParam String storage
			) throws Exception {
		try {
			String root = session.getServletContext().getRealPath("/");
			String pathname = root + "uploads" + File.separator + "sign";

			dto.setStnum(option);

			SessionInfo info = (SessionInfo) session.getAttribute("employee");

			dto.setEmpNo(Integer.parseInt(info.getEmpNo()));
			dto.setName(info.getName());
			dto.setSdept(info.getdType());
			int count = 1;

			if (!lineEmp2.equals("0")) {
				count++;
			}
			dto.setpEmpNo2(lineEmp2);

			if (!lineEmp3.equals("0")) {
				count++;
			}
			dto.setpEmpNo3(lineEmp3);

			if (!lineEmp4.equals("0")) {
				count++;
			}
			dto.setpEmpNo4(lineEmp4);

			dto.setSendStep(count);

			service.insertStorage(dto, pathname);

		} catch (Exception e) {
		}
		return "redirect:/sign/mainList";
	}

	// 문서 종류 호출
	@RequestMapping(value = "search", method = RequestMethod.GET)
	public String search(@RequestParam String option,
			@RequestParam(defaultValue = "") String mode,
			@RequestParam(defaultValue = "") String valueSnum,
			@RequestParam(defaultValue = "") String listVal,
			HttpSession session,
			Model model) throws Exception {
		
		SessionInfo info = (SessionInfo) session.getAttribute("employee");
		String returnAddr = "sign/" + option;
		Sign dto = null;
		Sign writer = null;
		Sign pempNo2 = null;
		Sign pempNo3 = null;
		Sign pempNo4 = null;
		List<Sign> listFile = null;

		try {
			if (mode.equalsIgnoreCase("article")) {
				
					Map<String, Object> map = new HashMap<>();

					writer = service.readWriter(Integer.parseInt(valueSnum));
					
					map.put("valueSnum", valueSnum);
					
					if(! listVal.equals("반려함") && ! listVal.equals("임시보관함")) {
						dto = service.readSign(map);
					}else if(listVal.equals("반려함")) {
						dto = service.readReturnSign(map);
						model.addAttribute("listVal", listVal);
					}else if(listVal.equals("임시보관함")) {
						
						info = (SessionInfo) session.getAttribute("employee");
						
						writer = service.readEmp(Integer.parseInt(info.getEmpNo()));
						
						dto = service.readStorage(map);
						model.addAttribute("modes", "임시보관함");
					}
					
					Date date = sdf.parse(dto.getSdate());
					String sd = sdf1.format(date);
					dto.setSdate(sd);

					date = sdf.parse(dto.getStartDay());
					sd = sdf1.format(date);
					dto.setStartDay(sd);

					if (dto.getpEmpNo2() != null) {
						pempNo2 = service.readEmp(Integer.parseInt(dto.getpEmpNo2()));
						model.addAttribute("pempNo2", pempNo2);
					}

					if (dto.getpEmpNo3() != null) {
						pempNo3 = service.readEmp(Integer.parseInt(dto.getpEmpNo3()));
						model.addAttribute("pempNo3", pempNo3);
					}

					if (dto.getpEmpNo4() != null) {
						pempNo4 = service.readEmp(Integer.parseInt(dto.getpEmpNo4()));
						model.addAttribute("pempNo4", pempNo4);
					}
					
					if(listVal.equals("임시보관함")) {
						if(dto.getSfSaveFilename()!=null) {
							listFile = new ArrayList<Sign>();
							String []s1 = dto.getSfSaveFilename().split(":::");
							String []s2 = dto.getSfOriginalFilename().split(":::");

							for(int i=0; i<s1.length; i++) {
								Sign vo=new Sign();
								vo.setSfSaveFilename(s1[i]);
								vo.setSfOriginalFilename(s2[i]);
								listFile.add(vo);
							}
						}
					} else {
						listFile = service.listFile(Integer.parseInt(valueSnum));
					}
					
					if(option.equals("2")) {
						String[] a1 = dto.getScontent().split("/");
						
						model.addAttribute("a0", a1[0]);
						model.addAttribute("a1", a1[1]);
					}

				}
			
			Map<String, Object> map = new HashMap<>();

			List<Sign> list = service.empList(info.getpCode(), info.getEmpNo(), map);
	
			model.addAttribute("list", list);
			model.addAttribute("dto", dto);
			model.addAttribute("sNum", valueSnum);
			model.addAttribute("mode", mode);
			model.addAttribute("writer", writer);
			model.addAttribute("listFile", listFile);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnAddr;
	}

	@RequestMapping(value = "passSign")
	@ResponseBody
	public Map<String,Object> passSign(
			@RequestParam String passVal,
			@RequestParam String sNum,
			String writer,
			String returnMemo,
			@RequestParam(defaultValue = "") String reason, @RequestParam(defaultValue = "all") String condition,
			@RequestParam(defaultValue = "") String keyword, HttpSession session, Model model) throws Exception {

		Map<String, Object> map12 = new HashMap<>();
		
		switch (passVal) {
		case "ok":
			service.updateScurrStep(Integer.parseInt(sNum));
			map12.put("state", "ok");
			break;
		case "no":
			Map<String, Object> map = new HashMap<>();
			map.put("sNum", sNum);
			map.put("writer", writer);
			map.put("rReason", returnMemo);
			service.insertReturnSign(map);
			service.updateScurrStepReturn(Integer.parseInt(sNum));
			map12.put("state", "no");
			break;
		}
		
		return map12;
	}
	@RequestMapping("download")
	public void download(
			@RequestParam int sfNum,
			HttpServletResponse resp,
			HttpSession session
			) throws Exception{
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "sign";
		
		boolean b = false;
		
		Sign dto = service.readFile(sfNum);
		if(dto != null) {
			String saveFilename = dto.getSfSaveFilename();
			String originalFilename = dto.getSfOriginalFilename();
			
			b = fileManager.doFileDownload(saveFilename, originalFilename, pathname, resp);
		}
		
		if(! b) {
			try {
				resp.setContentType("text/html;charset=utf-8");
				PrintWriter out = resp.getWriter();
				out.println("<script>alert('파일 다운로드가 불가능 합니다!.');history.back();</script>");
			} catch (Exception e) {
			}
		}
	}
	
	
	@RequestMapping(value="delete", method=RequestMethod.POST)
	@ResponseBody
	public void deleteCheck(
			@RequestParam(value="valueArrTest[]") List<String> valueArr,
			Model model
			) {
		for(String ss : valueArr) {
			try {
				service.deleteStorage(Integer.parseInt(ss));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
}
