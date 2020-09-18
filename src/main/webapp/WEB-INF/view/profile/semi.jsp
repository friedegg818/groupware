<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	String cp=request.getContextPath();
%>

			<div style="text-align: center; margin-top: 10px;">
				<p style="font-size: 20px; font-weight: bold; font-family: NanumSquareRound; color: #585858;"> ${dto.intro} </p>							
			</div>	
					
			<div style="margin-top: 15px; text-align: center;">
				<img src="<%=cp%>/uploads/profile/${dto.imageFilename}" width="140" height="140" border="0" style="border-radius: 140px;"> 
			</div>							
	
			<div style="margin-top: 20px; text-align: center; font-size: 17px; font-weight: bold; font-family: NanumSquareRound; color: #585858;">
				<p style="font-size: 22px;">${dto.name}</p>
				<%-- <p style="padding-top: 10px;">${dto.dType}&nbsp;${dto.pType} </p> --%>
				<p style="padding-top: 10px;">${dto.tel}</p>
				<p style="padding-top: 5px;">${dto.email}</p>					
			</div>
			
			
