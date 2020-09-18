<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String cp=request.getContextPath();
%>


<c:forEach var="vo" items="${listReplyAnswer}">
	<div class='answer' style='padding: 0px 10px;'>
		<div style='clear:both; padding: 10px 0px;'>
			<div style='float: left; width: 3%;  color:#6E6E6E;'><i class="fas fa-angle-double-right"></i></div>
			<div style='float: left; width:97%;'>
				<div style='float: left; color: #424242;'><b> [${vo.dType}]&nbsp;${vo.name}&nbsp;${vo.pType}</b></div>
				<div style='float: right; color: #424242;'>
					<span>${vo.created}</span> 
						<c:if test="${sessionScope.employee.name == vo.name || sessionScope.employee.rCode=='admin'}">
							&nbsp;|&nbsp;&nbsp;<span class='deleteReplyAnswer' style='cursor: pointer;' data-replyNum='${vo.replyNum}' data-answer='${vo.answer}'>삭제</span>
						</c:if>
				</div>
			</div>
		</div>
		<div style='clear:both; padding: 5px 5px 5px 3%; color: #2E2E2E;'>
			${vo.content}
		</div>
	</div>
</c:forEach>
