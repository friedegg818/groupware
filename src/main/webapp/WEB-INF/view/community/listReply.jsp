<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String cp=request.getContextPath();
%>
<link rel="stylesheet" href="<%=cp%>/resource/css/community.css" type="text/css">

<table>
	<thead id='listReplyHeader' style="margin: 20px auto 0px;">
	</thead>
	

	<tbody id='listReplyBody'>
	<c:forEach var="vo" items="${listReply}">
		<tr height='35'>
			<td width='50%' style='padding:5px 5px; border-top: 1px solid #cccccc; color: #424242;'>
				<span><b>[${vo.dType}]&nbsp;${vo.name}&nbsp;${vo.pType}</b></span>
			</td>
			<td width='50%' style='padding:5px 5px; border-top: 1px solid #cccccc; color: #424242;' align='right'>
				<span>${vo.created}</span>
				<c:if test="${sessionScope.employee.name == vo.name || sessionScope.employee.rCode=='admin'}">
					&nbsp;|&nbsp;&nbsp;<span class="deleteReply" style="cursor: pointer;" data-replyNum='${vo.replyNum}' data-pageNo='${pageNo}'>삭제</span>
				</c:if>
			</td>
		</tr>
		<tr>
			<td colspan='2' valign='top' style='padding:5px 5px; font-size: 15px; color: #2E2E2E;'>
				${vo.content}
			</td>
		</tr>

		<tr>
			<td style='padding:7px 5px;  border-bottom: 1px solid #cccccc; color: #6E6E6E;'>
				<button type='button' class='btn btnReplyAnswerLayout' data-replyNum='${vo.replyNum}'><i class="fas fa-reply"></i>&nbsp;답글 ${vo.answerCount}</button>
			</td>
			<td style='padding:7px 5px;  border-bottom: 1px solid #cccccc; color: #6E6E6E;' align='right'>
				<button type='button' class='btn btnSendReplyLike' data-replyNum='${vo.replyNum}' data-replyLike='1'> <i class="fas fa-thumbs-up"></i>&nbsp;<span>${vo.likeCount}</span></button>
				&nbsp;&nbsp;<button type='button' class='btn btnSendReplyLike' data-replyNum='${vo.replyNum}' data-replyLike='0'> <i class="fas fa-thumbs-down"></i>&nbsp;<span>${vo.disLikeCount}</span></button>	        
			</td>
		</tr>

		<tr class='replyAnswer' style='display: none;'>
			<td colspan='2'>
				<div id='listReplyAnswer${vo.replyNum}' class='answerList'></div>
				<div style='clear: both; padding: 10px 10px; padding-right: 0px; padding-top: 15px;'>
					<div style='float: left; width:5%;'>&nbsp;</div>
					<div style='float: left; width:95%;'>
						<textarea cols='72' rows='12' class='boxTA' style='width:98%; height: 70px; border: 1px solid #cccccc;'></textarea>
					</div>
				</div>
				<div style='padding: 0px 13px 10px 10px; text-align: right;'>
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
