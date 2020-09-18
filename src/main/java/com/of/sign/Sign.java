package com.of.sign;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public class Sign {
	private int snum;
	private int listNum;
	private String name;
	private String tel;
	private String email;
	private String enterDate;
	private String dType;
	private int pCode;
	private String pType;
	private int stnum;
	private int stsubject;
	private String sdept;
	private String sdate;
	private String perdate;
	private String srefer;
	private String ssubject;
	private String scontent;
	private String sstorage;
	private int sendStep;
	private String scurrStep;
	private String writer;
	private int empNo;
	
	private String pEmpNo2;
	private String pEmpNo3;
	private String pEmpNo4;
	private String startDay;
	private String rreason;
	private int enabled;
	

	private int sfNum;
	private String sfOriginalFilename;
	private String sfSaveFilename;
	private int fileCount;
	
	private List<MultipartFile> upload;
	
	private List<String> originals;
	private List<String> saves;
	
 
	
	
	public List<String> getOriginals() {
		return originals;
	}

	public void setOriginals(List<String> originals) {
		this.originals = originals;
	}

	public List<String> getSaves() {
		return saves;
	}

	public void setSaves(List<String> saves) {
		this.saves = saves;
	}

	public int getpCode() {
		return pCode;
	}

	public void setpCode(int pCode) {
		this.pCode = pCode;
	}

	public int getSfNum() {
		return sfNum;
	}

	public void setSfNum(int sfNum) {
		this.sfNum = sfNum;
	}

	public String getSfOriginalFilename() {
		return sfOriginalFilename;
	}

	public void setSfOriginalFilename(String sfOriginalFilename) {
		this.sfOriginalFilename = sfOriginalFilename;
	}

	public String getSfSaveFilename() {
		return sfSaveFilename;
	}

	public void setSfSaveFilename(String sfSaveFilename) {
		this.sfSaveFilename = sfSaveFilename;
	}

	public int getFileCount() {
		return fileCount;
	}

	public void setFileCount(int fileCount) {
		this.fileCount = fileCount;
	}

	public List<MultipartFile> getUpload() {
		return upload;
	}

	public void setUpload(List<MultipartFile> upload) {
		this.upload = upload;
	}

	public String getRreason() {
		return rreason;
	}

	public void setRreason(String rreason) {
		this.rreason = rreason;
	}

	public String getWriter() {
		return writer;
	}

	public void setWriter(String writer) {
		this.writer = writer;
	}

	public String getStartDay() {
		return startDay;
	}

	public void setStartDay(String startDay) {
		this.startDay = startDay;
	}

	public int getSnum() {
		return snum;
	}

	public void setSnum(int snum) {
		this.snum = snum;
	}

	public int getListNum() {
		return listNum;
	}

	public void setListNum(int listNum) {
		this.listNum = listNum;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getEnterDate() {
		return enterDate;
	}

	public void setEnterDate(String enterDate) {
		this.enterDate = enterDate;
	}

	public String getdType() {
		return dType;
	}

	public void setdType(String dType) {
		this.dType = dType;
	}

	public String getpType() {
		return pType;
	}

	public void setpType(String pType) {
		this.pType = pType;
	}

	public int getStnum() {
		return stnum;
	}

	public void setStnum(int stnum) {
		this.stnum = stnum;
	}

	public int getStsubject() {
		return stsubject;
	}

	public void setStsubject(int stsubject) {
		this.stsubject = stsubject;
	}

	public String getSdept() {
		return sdept;
	}

	public void setSdept(String sdept) {
		this.sdept = sdept;
	}

	public String getSdate() {
		return sdate;
	}

	public void setSdate(String sdate) {
		this.sdate = sdate;
	}

	public String getPerdate() {
		return perdate;
	}

	public void setPerdate(String perdate) {
		this.perdate = perdate;
	}

	public String getSrefer() {
		return srefer;
	}

	public void setSrefer(String srefer) {
		this.srefer = srefer;
	}

	public String getSsubject() {
		return ssubject;
	}

	public void setSsubject(String ssubject) {
		this.ssubject = ssubject;
	}

	public String getScontent() {
		return scontent;
	}

	public void setScontent(String scontent) {
		this.scontent = scontent;
	}

	public String getSstorage() {
		return sstorage;
	}

	public void setSstorage(String sstorage) {
		this.sstorage = sstorage;
	}

	public int getSendStep() {
		return sendStep;
	}

	public void setSendStep(int sendStep) {
		this.sendStep = sendStep;
	}

	public String getScurrStep() {
		return scurrStep;
	}

	public void setScurrStep(String scurrStep) {
		this.scurrStep = scurrStep;
	}

	public int getEmpNo() {
		return empNo;
	}

	public void setEmpNo(int empNo) {
		this.empNo = empNo;
	}

	public String getpEmpNo2() {
		return pEmpNo2;
	}

	public void setpEmpNo2(String pEmpNo2) {
		this.pEmpNo2 = pEmpNo2;
	}

	public String getpEmpNo3() {
		return pEmpNo3;
	}

	public void setpEmpNo3(String pEmpNo3) {
		this.pEmpNo3 = pEmpNo3;
	}

	public String getpEmpNo4() {
		return pEmpNo4;
	}

	public void setpEmpNo4(String pEmpNo4) {
		this.pEmpNo4 = pEmpNo4;
	}

	public int getEnabled() {
		return enabled;
	}

	public void setEnabled(int enabled) {
		this.enabled = enabled;
	}

}
