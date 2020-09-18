<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String cp=request.getContextPath();
%>

<table>
	<thead id='listReplyHeader' style="margin: 20px auto 0px;">
		<tr height='30'> 
			<td class="replyTd" align='left'>
				<i class="fas fa-comment-alt"></i>&nbsp;&nbsp;${replyCount}
			</td>
		</tr>
	</thead>
	
	<tbody id='listReplyBody'>
	<c:forEach var="vo" items="${listReply}">
		<tr height='35' style='background: white;'>
			<td class="replyNameTd" >
				<span><b>[${vo.dType}]&nbsp;${vo.name}&nbsp;${vo.pType}</b></span>
			</td>
			<td class="replyNameTd" align='right'>
				<span>${vo.created}</span> 
				 <c:if test="${sessionScope.employee.name == vo.name || sessionScope.employee.rCode=='admin'}">
					&nbsp;|&nbsp;&nbsp;<span class="deleteReply" style="cursor: pointer;" data-replyNum='${vo.replyNum}' data-pageNo='${pageNo}'>삭제</span>
			     </c:if>
			</td>
		</tr>
		<tr>
			<td class="replyContentTd" colspan='2' valign='top'>
				${vo.content}
			</td>
		</tr>
	</c:forEach>
	</tbody>

	<tfoot id='listReplyFooter'>
		<tr height='40' align="center">
			<td colspan='2' >
				${paging}
			</td>
		</tr>
	</tfoot>
</table>
