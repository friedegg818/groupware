<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>
<link rel="stylesheet" href="<%=cp%>/resource/css/employee.css" type="text/css">

<div>
	<div id="complete-form">
		<div id="title-form">
			<span>${title}</span>
		</div>
		
		<div id="messageBox">
			<div>
	        	${message}
			</div>
		</div>
	</div>
	<div id="button-form">
		<div>
			<button type="button" onclick="javascript:location.href='<%=cp%>/employee/main';" style="width: 100px; height: 30px;">목록으로</button>
		</div>
	</div>
</div>