package com.of.community;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public class Community {
	private int listNum, commuNum;
	private String clubCode;
	private String clubType;
	private String clubExp;
	private String clubMake;
	private String clubNew;
	private String title;
	private String writer;
	private String name;	
	private String content;
	private String created; 
	private int hitCount;
	private String pType;
	private String dType;

	private int fileNum;
	private String originalFilename, saveFilename;	
	private int fileCount;	
	private List<MultipartFile> upload; 
	private long gap;
	
	private int replyCount;	
	private int commuLikeCount;	
	
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

	public int getCommuLikeCount() {
		return commuLikeCount;
	}

	public void setCommuLikeCount(int commuLikeCount) {
		this.commuLikeCount = commuLikeCount;
	}

	public int getReplyCount() {
		return replyCount;
	}

	public void setReplyCount(int replyCount) {
		this.replyCount = replyCount;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getListNum() {
		return listNum;
	}

	public void setListNum(int listNum) {
		this.listNum = listNum;
	}

	public int getCommuNum() {
		return commuNum;
	}

	public void setCommuNum(int commuNum) {
		this.commuNum = commuNum;
	}

	public String getClubCode() {
		return clubCode;
	}

	public void setClubCode(String clubCode) {
		this.clubCode = clubCode;
	}	

	public String getClubType() {
		return clubType;
	}

	public void setClubType(String clubType) {
		this.clubType = clubType;
	}		

	public String getClubExp() {
		return clubExp;
	}

	public void setClubExp(String clubExp) {
		this.clubExp = clubExp;
	}	

	public String getClubMake() {
		return clubMake;
	}

	public void setClubMake(String clubMake) {
		this.clubMake = clubMake;
	}	

	public String getClubNew() {
		return clubNew;
	}

	public void setClubNew(String clubNew) {
		this.clubNew = clubNew;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getWriter() {
		return writer;
	}

	public void setWriter(String writer) {
		this.writer = writer;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getCreated() {
		return created;
	}

	public void setCreated(String created) {
		this.created = created;
	}

	public int getHitCount() {
		return hitCount;
	}

	public void setHitCount(int hitCount) {
		this.hitCount = hitCount;
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

	public long getGap() {
		return gap;
	}

	public void setGap(long gap) {
		this.gap = gap;
	}

	@Override
	public String toString() {
		return "Community [listNum=" + listNum + ", commuNum=" + commuNum + ", clubCode=" + clubCode + ", clubType="
				+ clubType + ", title=" + title + ", writer=" + writer + ", content=" + content + ", created=" + created
				+ ", hitCount=" + hitCount + ", fileNum=" + fileNum + ", originalFilename=" + originalFilename
				+ ", saveFilename=" + saveFilename + ", fileCount=" + fileCount + ", upload=" + upload + ", gap=" + gap
				+ "]";
	}	
}
