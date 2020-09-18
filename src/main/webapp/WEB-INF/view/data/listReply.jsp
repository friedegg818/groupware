<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String cp=request.getContextPath();
%>

<table>
	<thead id='listReplyHeader' style="margin: 20px auto 0px;">
	</thead>
	

	<tbody id='listReplyBody'>
	<c:forEach var="vo" items="${listReply}">
		<tr height='35' style='background: white;'>
			<td class="replyNameTd" >
				<span><b> [${vo.dType}]&nbsp;${vo.name}&nbsp;${vo.pType}</b></span>
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

		<tr>
			<td class="replyBtnTd">
				<button type='button' class='btn btnReplyAnswerLayout' data-replyNum='${vo.replyNum}'><i class="fas fa-reply"></i>&nbsp;답글 ${vo.answerCount}</button>
			</td>	
		</tr>

		<tr class='replyAnswer' style='display: none;'>
			<td colspan='2'>
				<div id='listReplyAnswer${vo.replyNum}' class='answerList'></div>
				<div style='clear: both; padding: 10px 10px; padding-right: 0px; padding-top: 15px;'>
					<div style='float: left; width: 5%;'>&nbsp;</div>
					<div style='float: left; width:95%'>
						<textarea class="replyAnswerArea" cols='72' rows='12'></textarea>
					</div>
				</div>
				<div class="replyAnswerBtn">
					<button type='button' class='btn btnSendReplyAnswer' data-replyNum='${vo.replyNum}'>답글 등록</button>
				</div>
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
