package com.of.publicAddr;

import java.net.URLDecoder;
import java.net.URLEncoder;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.View;

import com.of.common.MyExcelView;
import com.of.common.MyUtil;
import com.of.employee.Employee;
import com.of.employee.SessionInfo;

@Controller("publicAddrController")
public class PublicAddrController {

	@Autowired
	private PublicAddrService service;

	@Autowired
	private MyUtil myUtil;
	
	@Autowired
	private MyExcelView excelView;

	// ---------------------------------------------------------------------------------------------
	// 공용 주소록 리스트
	@RequestMapping("/publicAddr/main")
	public String main(HttpSession session, Model model) throws Exception {
		
		SessionInfo info = (SessionInfo) session.getAttribute("employee");
		String empNo = info.getEmpNo();

		int dataCount = 0;
		
		Map<String, Object> map = new HashMap<String, Object>();
		dataCount = service.dataCount(map);
		
		model.addAttribute("dataCount", dataCount);
		
		return ".publicAddr.main";
	}

	@RequestMapping("/publicAddr/list")
	public String list(
			@RequestParam(value="page", defaultValue = "1") int current_page,
			@RequestParam(defaultValue = "all") String condition,
			@RequestParam(defaultValue = "") String keyword,
			@RequestParam(defaultValue = "가") String kor,
			@RequestParam(defaultValue = "힣") String kor2,
			HttpServletRequest req,
			Model model) throws Exception {

		int rows = 10;
		int total_page = 0;
		int dataCount = 0;

		if(req.getMethod().equalsIgnoreCase("GET")) {
			keyword=URLDecoder.decode(keyword, "UTF-8");
		}

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("condition", condition);
		map.put("keyword", keyword);
		map.put("kor", kor);
		map.put("kor2", kor2);

		dataCount = service.dataCount(map);
		
		if(dataCount != 0) {
			total_page = myUtil.pageCount(rows, dataCount);			
		}

		if(current_page>total_page) {
			current_page=total_page;
		}

		int offset = (current_page-1)*rows;
		if(offset < 0) offset=0;
		map.put("offset", offset);
		map.put("rows", rows);

		List<PublicAddr> list = null;
		
		list = service.listPublicAddr(map);
		
		String paging = myUtil.pagingMethod(current_page, total_page, "listPage");
		
		model.addAttribute("list", list);
		model.addAttribute("dataCount", dataCount);
		model.addAttribute("page", current_page);
		model.addAttribute("paging", paging);
		model.addAttribute("total_page", total_page);

		model.addAttribute("condition", condition);
		model.addAttribute("keyword", keyword);

		return "publicAddr/list";
	}
	
	// ---------------------------------------------------------------------------------------------
	// 공용 주소록 내보내기
	@RequestMapping("/publicAddr/excel")
	public View excel(Map<String, Object> model, HttpSession session) throws Exception {

		SessionInfo info = (SessionInfo) session.getAttribute("employee");

		List<PublicAddr> list = service.listAllPublicAddr();

		String sheetName = "공용 주소록";
		List<String> columnLabels = new ArrayList<>();
		List<Object[]> columnValues = new ArrayList<>();

		columnLabels.add("이름");
		columnLabels.add("생년월일");
		columnLabels.add("전화번호");
		columnLabels.add("이메일");
		columnLabels.add("부서");
		columnLabels.add("직위");

		for (PublicAddr dto : list) {
			columnValues.add(new Object[] {
					dto.getName(),
					dto.getBirth(),
					dto.getTel(),
					dto.getEmail(),
					dto.getdType(),
					dto.getpType()
			});
		}

		model.put("filename", "publicAddress.xls");
		model.put("sheetName", sheetName);
		model.put("columnLabels", columnLabels);
		model.put("columnValues", columnValues);

		return excelView;
	}

}
