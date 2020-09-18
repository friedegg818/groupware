package com.of.smart;

import java.io.File;
import java.io.InputStream;
import java.io.PrintWriter;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.of.common.FileManager;
import com.of.common.ImageManager;

@Controller("smart.imageController")
public class ImageController {
	@Resource(name="fileManager")
	private FileManager fileManager;
	
	@Autowired
	private ImageManager imageManager;

	// HTML 5을 지원하지 않는 브라우저
	@RequestMapping(value="/image/generalUpload")
	public String generalUpload(HttpServletRequest req,
			HttpSession session, Image image) throws Exception {
		
			String cp=req.getContextPath();
		
		    String root = session.getServletContext().getRealPath("/");
		    String pathname = root + "uploads" + File.separator + "image";
			File dir = new File(pathname);
			if(!dir.exists())
				dir.mkdirs();

		    String strUrl = image.getCallback() + "?callback_func=" + image.getCallback_func();
		    
		    boolean flag=false;
		    String saveFilename = fileManager.doFileUpload(image.getFiledata(), pathname);
		    
		    if(saveFilename!=null) {
				String fullpathname=pathname+"/"+saveFilename;
				int width=imageManager.getImageWidth(fullpathname);
				if(width>600)
					width=600;
		    	
		    	strUrl += "&bNewLine=true&sFileName="; 
                strUrl += saveFilename;
                strUrl += "&sWidth="+width;
                strUrl += "&sFileURL="+cp+"/uploads/image/"+saveFilename;
                
                flag=true;
		    }
			
			if(! flag) {
				strUrl += "&errstr=error";
			}
			
			return "redirect:"+strUrl;
	}

	// HTML 5 upload
	@RequestMapping(value="/image/html5Upload")
	public void html5Upload(HttpServletRequest req,
			HttpServletResponse resp,
			HttpSession session) throws Exception {
		
			String cp=req.getContextPath();
		
		    String root = session.getServletContext().getRealPath("/");
		    String pathname = root + "uploads" + File.separator + "image";
			File dir = new File(pathname);
			if(!dir.exists())
				dir.mkdirs();

		    String strUrl ="";
		    if(!"OPTIONS".equals(req.getMethod().toUpperCase())) {
		    	String filename=req.getHeader("file-name");
		    	// String ext=filename.substring(filename.lastIndexOf("."));
		    	
		    	InputStream is=req.getInputStream();
		    	String saveFilename = fileManager.doFileUpload(is, filename, pathname);
		    	
				String fullpathname=pathname+"/"+saveFilename;
				
				// 그림 크기 줄이는것. 생략가능
				int width=imageManager.getImageWidth(fullpathname);
				if(width>600)
					width=600;
		    	
				strUrl += "&bNewLine=true&sFileName="; 
                strUrl += saveFilename;
                strUrl += "&sWidth="+width;
                strUrl += "&sFileURL="+cp+"/uploads/image/"+saveFilename;
		    }
			
			PrintWriter out=resp.getWriter();
			out.print(strUrl);
	}
}
