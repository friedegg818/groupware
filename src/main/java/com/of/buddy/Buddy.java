package com.of.buddy;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public class Buddy {
	private int buddyNum;
	private String title;
	private String content; 
	
	private int rbuddyNum;
	private String sender;
	private int buddyState;
	private int buddyCheck;
	private String rDate;
	
	private int sbuddyNum;
	private String receiver; 
	private String sDate;	
	
	private int fileNum;
	private String originalFilename;
	private String saveFilename;
	private int fileCount;
	private List<MultipartFile> upload;
	private long fileSize;
	private String imageFilename;
	
	private String empNo;
	private String name;
	private String email;
	private String dType;
	private String pType;
	private String tel;
	
	
	
	
	public int getBuddyCheck() {
		return buddyCheck;
	}
	public void setBuddyCheck(int buddyCheck) {
		this.buddyCheck = buddyCheck;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getImageFilename() {
		return imageFilename;
	}
	public void setImageFilename(String imageFilename) {
		this.imageFilename = imageFilename;
	}
	public int getBuddyNum() {
		return buddyNum;
	}
	public void setBuddyNum(int buddyNum) {
		this.buddyNum = buddyNum;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getRbuddyNum() {
		return rbuddyNum;
	}
	public void setRbuddyNum(int rbuddyNum) {
		this.rbuddyNum = rbuddyNum;
	}
	public String getSender() {
		return sender;
	}
	public void setSender(String sender) {
		this.sender = sender;
	}
	public int getBuddyState() {
		return buddyState;
	}
	public void setBuddyState(int buddyState) {
		this.buddyState = buddyState;
	}
	public String getrDate() {
		return rDate;
	}
	public void setrDate(String rDate) {
		this.rDate = rDate;
	}
	public int getSbuddyNum() {
		return sbuddyNum;
	}
	public void setSbuddyNum(int sbuddyNum) {
		this.sbuddyNum = sbuddyNum;
	}
	public String getReceiver() {
		return receiver;
	}
	public void setReceiver(String receiver) {
		this.receiver = receiver;
	}
	public String getsDate() {
		return sDate;
	}
	public void setsDate(String sDate) {
		this.sDate = sDate;
	}
	
	public int getFileNum() {
		return fileNum;
	}
	public void setFileNum(int fileNum) {
		this.fileNum = fileNum;
	}
	public String getOriginalFilename() {
		return originalFilename;
	}
	public void setOriginalFilename(String originalFilename) {
		this.originalFilename = originalFilename;
	}
	public String getSaveFilename() {
		return saveFilename;
	}
	public void setSaveFilename(String saveFilename) {
		this.saveFilename = saveFilename;
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
	public long getFileSize() {
		return fileSize;
	}
	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}
	public String getEmpNo() {
		return empNo;
	}
	public void setEmpNo(String empNo) {
		this.empNo = empNo;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
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

}