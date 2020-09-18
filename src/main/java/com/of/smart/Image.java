package com.of.smart;

import org.springframework.web.multipart.MultipartFile;

public class Image {
    private String callback; 
    private String callback_func; 
    private MultipartFile Filedata; // Photo_Quick_UploadPopup.html에서 파일 필드의 이름...
    
	public String getCallback() {
		return callback;
	}
	public void setCallback(String callback) {
		this.callback = callback;
	}
	public String getCallback_func() {
		return callback_func;
	}
	public void setCallback_func(String callback_func) {
		this.callback_func = callback_func;
	}
	public MultipartFile getFiledata() {
		return Filedata;
	}
	public void setFiledata(MultipartFile filedata) {
		Filedata = filedata;
	}
}
