package com.of.privateaddr;
 
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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.View;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.of.common.MyExcelView;
import com.of.common.MyUtil;
import com.of.employee.SessionInfo;

@Controller("privateAddrController")
public class PrivateAddrController {

	@Autowired
	private PrivateAddrService service;

	@Autowired
	private MyUtil myUtil;

	@Autowired
	private MyExcelView excelView;

	// ---------------------------------------------------------------------------------------------
	// 개인 주소록 리스트
	@RequestMapping("/privateAddr/main")
	public String main(
			HttpSession session,
			Model model
			) throws Exception {
		
		int dataCount = 0;
		
		SessionInfo info = (SessionInfo)session.getAttribute("employee");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("empNo", info.getEmpNo());
		dataCount = service.dataCount(map);
		
		model.addAttribute("dataCount", dataCount);
		
		return ".privateAddr.main";
	}

	@RequestMapping("/privateAddr/list")
	public String list(
			@RequestParam(value = "page", defaultValue = "1") int current_page,
			@RequestParam(defaultValue = "all") String condition,
			@RequestParam(defaultValue = "") String keyword,
			@RequestParam(defaultValue = "가") String kor,
			@RequestParam(defaultValue = "힣") String kor2,
			HttpServletRequest req,
			HttpSession session,
			Model model) throws Exception {

		SessionInfo info = (SessionInfo) session.getAttribute("employee");

		int rows = 5;
		int total_page = 0;
		int dataCount = 0;

		if (req.getMethod().equalsIgnoreCase("GET")) {
			keyword = URLDecoder.decode(keyword, "UTF-8");
		}

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("condition", condition);
		map.put("keyword", keyword);
		map.put("empNo", info.getEmpNo());
		map.put("kor", kor);
		map.put("kor2", kor2);

		dataCount = service.dataCount(map);
		total_page = myUtil.pageCount(rows, dataCount);
		
		if(dataCount != 0) {
			total_page = myUtil.pageCount(rows, dataCount);			
		}

		if(current_page>total_page) {
			current_page=total_page;
		}

		int offset = (current_page-1) * rows;
		if(offset < 0) offset = 0;
		map.put("offset", offset);
		map.put("rows", rows);

		List<PrivateAddr> list = null;

		list = service.listPrivateAddr(map);

		List<PrivateAddr> modalList = service.modalList(info.getEmpNo());
		
		String paging = myUtil.pagingMethod(current_page, total_page, "listPage");

		model.addAttribute("list", list);
		model.addAttribute("dataCount", dataCount);
		model.addAttribute("page", current_page);
		model.addAttribute("paging", paging);
		model.addAttribute("total_page", total_page);
		model.addAttribute("modalList", modalList);

		model.addAttribute("condition", condition);
		model.addAttribute("keyword", keyword);

		return "privateAddr/list";
	}

	// ---------------------------------------------------------------------------------------------
	// 개인 주소록 등록
	@RequestMapping(value = "/privateAddr/privateAddr", method = RequestMethod.GET)
	public String privateAddrForm(Model model, HttpSession session) {

		SessionInfo info = (SessionInfo) session.getAttribute("employee");

		List<PrivateAddr> modalList = service.modalList(info.getEmpNo());

		model.addAttribute("page", 1);
		model.addAttribute("mode", "privateAddr");
		model.addAttribute("modalList", modalList);

		return ".privateAddr.privateAddr";
	}

	@RequestMapping(value = "/privateAddr/privateAddr", method = RequestMethod.POST)
	public String privateAddrSubmit(
			PrivateAddr dto,
			final RedirectAttributes reAttr,
			Model model,
			HttpSession session) {

		SessionInfo info = (SessionInfo) session.getAttribute("employee");

		try {
			dto.setTel(dto.getTel().replaceAll("-", ""));

			String tel1 = dto.getTel().substring(0, 3);
			String tel2 = dto.getTel().substring(3, 7);
			String tel3 = dto.getTel().substring(7);

			dto.setTel(tel1 + "-" + tel2 + "-" + tel3);

			dto.setEmpNo(info.getEmpNo());

			service.insertPrivateAddr(dto);
		} catch (Exception e) {
			model.addAttribute("mode", "privateAddr");

			return ".privateAddr.privateAddr";
		}

		return "redirect:/privateAddr/main";
	}

	// ---------------------------------------------------------------------------------------------
	// 개인 주소록 빠른 등록
	@RequestMapping(value = "/privateAddr/privateAddr2", method = RequestMethod.POST)
	public String privateAddrSubmit2(
			PrivateAddr dto,
			final RedirectAttributes reAttr,
			Model model,
			HttpSession session) {

		SessionInfo info = (SessionInfo) session.getAttribute("employee");

		try {
			dto.setTel(dto.getTel().replaceAll("-", ""));

			String tel1 = dto.getTel().substring(0, 3);
			String tel2 = dto.getTel().substring(3, 7);
			String tel3 = dto.getTel().substring(7);

			dto.setTel(tel1 + "-" + tel2 + "-" + tel3);

			dto.setEmpNo(info.getEmpNo());

			service.insertPrivateAddrSpeed(dto);
		} catch (Exception e) {
			model.addAttribute("mode", "privateAddr2");

			return ".privateAddr.main";
		}

		return "redirect:/privateAddr/main";
	}

	// ---------------------------------------------------------------------------------------------
	// 모달 그룹 추가
	@RequestMapping(value = "/privateAddr/modalInsert", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> modalInsert(PrivateAddr dto, HttpSession session) throws Exception {

		SessionInfo info = (SessionInfo) session.getAttribute("employee");

		String state = "false";

		try {
			dto.setEmpNo(info.getEmpNo());

			service.modalInsert(dto);

			state = "true";
		} catch (Exception e) {
			e.printStackTrace();
		}

		Map<String, Object> model = new HashMap<>();
		model.put("state", state);
		model.put("dto", dto);

		return model;
	}

	// ---------------------------------------------------------------------------------------------
	// 개인 주소록 수정
	@RequestMapping(value = "/privateAddr/update", method = RequestMethod.GET)
	public String updateForm(
			@RequestParam int addrNum,
			@RequestParam String page,
			HttpSession session,
			Model model) throws Exception {

		SessionInfo info = (SessionInfo) session.getAttribute("employee");

		PrivateAddr dto = service.readAddress(addrNum);		

		/*if (dto == null) {
			return "privateAddr/error";
		}*/
		
		/*if(!info.getEmpNo().equals(dto.getEmpNo())) {
			return "private/error";
		}*/

		List<PrivateAddr> modalList = service.modalList(info.getEmpNo());

		model.addAttribute("mode", "update");
		model.addAttribute("dto", dto);
		model.addAttribute("page", page);
		model.addAttribute("modalList", modalList);

		return ".privateAddr.privateAddr";
	}

	@RequestMapping(value = "/privateAddr/update", method = RequestMethod.POST)
	public String updateSubmit(PrivateAddr dto, @RequestParam String page, HttpSession session) throws Exception {
		
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("employee");
		
			dto.setTel(dto.getTel().replaceAll("-", ""));

			String tel1 = dto.getTel().substring(0, 3);
			String tel2 = dto.getTel().substring(3, 7);
			String tel3 = dto.getTel().substring(7);

			dto.setTel(tel1 + "-" + tel2 + "-" + tel3);

			dto.setEmpNo(info.getEmpNo());

			service.updatePrivateAddr(dto);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return "redirect:/privateAddr/main?page=" + page;
	}

	// ---------------------------------------------------------------------------------------------
	// 개인 주소록 삭제
	@RequestMapping(value = "/privateAddr/delete")
	public String delete(
			@RequestParam int addrNum,
			@RequestParam String page,
			@RequestParam(defaultValue = "all") String condition,
			@RequestParam(defaultValue = "") String keyword,
			HttpSession session) throws Exception {

		SessionInfo info = (SessionInfo) session.getAttribute("employee");

		keyword = URLDecoder.decode(keyword, "UTF-8");
		String query = "page=" + page;
		if (keyword.length() != 0) {
			query += "&condition=" + condition + "&keyword=" + URLEncoder.encode(keyword, "UTF-8");
		}

		System.out.println(addrNum);
		System.out.println(addrNum);
		
		System.out.println(addrNum);System.out.println(addrNum);
		System.out.println(addrNum);
		
		System.out.println(addrNum);
		System.out.println(addrNum);
		System.out.println(addrNum);
		System.out.println(addrNum);
		System.out.println(addrNum);
		
		service.deletePrivateAddr(addrNum);

		return "redirect:/privateAddr/main?" + query;
	}

	// ---------------------------------------------------------------------------------------------
	// 개인 주소록 내보내기
	@RequestMapping("/privateAddr/excel")
	public View excel(Map<String, Object> model, HttpSession session) throws Exception {

		SessionInfo info = (SessionInfo) session.getAttribute("employee");

		List<PrivateAddr> list = service.listAllPrivateAddr(info.getEmpNo());

		String sheetName = "개인 주소록";
		List<String> columnLabels = new ArrayList<>();
		List<Object[]> columnValues = new ArrayList<>();
		
		columnLabels.add("번호");
		columnLabels.add("이름");
		columnLabels.add("전화번호");
		columnLabels.add("이메일");
		columnLabels.add("회사명");
		columnLabels.add("부서명");
		columnLabels.add("회사번호");
		columnLabels.add("회사주소");
		columnLabels.add("메모");
		columnLabels.add("그룹명");

		for (PrivateAddr dto : list) {
			columnValues.add(new Object[] {
					dto.getAddrNum(),
					dto.getName(),
					dto.getTel(),
					dto.getEmail(),
					dto.getCompany(),
					dto.getdName(),
					dto.getdTel(),
					dto.getdAddr(),
					dto.getMemo(),
					dto.getGroupType()
			});
		}

		model.put("filename", "privateAddress.xls");
		model.put("sheetName", sheetName);
		model.put("columnLabels", columnLabels);
		model.put("columnValues", columnValues);

		return excelView;
	}
}
