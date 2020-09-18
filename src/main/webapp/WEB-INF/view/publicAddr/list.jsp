<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String cp = request.getContextPath();
%>

<div id="list-Box">
	<div id="speedInsertBox">
		<label><button type="button" id="excelOut" onclick="javascript:location.href='<%=cp%>/publicAddr/excel';"><i class="fas fa-file-export"><span class="titleFont">&nbsp;내보내기</span></i></button></label>
	</div>
	
	<form name="addrAddForm" method="post">
		<div id="addrPrivate-container">
			<div id="addrPrivate">
				<ul>
					<li class="all">
						<span>전체</span>
					</li>
					<li class="kor" data-kor="가">
						<span>ㄱ</span>
					</li>
					<li class="kor" data-kor="나">
						<span>ㄴ</span>
					</li>
					<li data-kor="다" class="kor">
						<span>ㄷ</span>
					</li>
					<li data-kor="라" class="kor">
						<span>ㄹ</span>
					</li>
					<li data-kor="마" class="kor">
						<span>ㅁ</span>
					</li>
					<li data-kor="바" class="kor">
						<span>ㅂ</span>
					</li>
					<li data-kor="사" class="kor">
						<span>ㅅ</span>
					</li>
					<li data-kor="아" class="kor">
						<span>ㅇ</span>
					</li>
					<li data-kor="자" class="kor">
						<span>ㅈ</span>
					</li>
					<li data-kor="차" class="kor">
						<span>ㅊ</span>
					</li>
					<li data-kor="카" class="kor">
						<span>ㅋ</span>
					</li>
					<li data-kor="타" class="kor">
						<span>ㅌ</span>
					</li>
					<li data-kor="파" class="kor">
						<span>ㅍ</span>
					</li>
					<li data-kor="하" class="kor">
						<span>ㅎ</span>
					</li>
				</ul>
			</div>
		</div>
		
		<div id="list-header">
			<table id="list-menu">
				<tr id="list-title">
					<td colspan="2" id="name-title">이름</td>
					<td id="birth-title">생년월일</td>
					<td id="tel-title">전화번호</td>
					<td id="email-title">이메일</td>
					<td id="dType-title">부서</td>
					<td id="pType-title">직위</td>
				</tr>
				
				<tr id="list-cotainer">
					<c:forEach var="dto" items="${list}">
						<tr id="list-content">
							<td style="padding-left: 25px; padding-top: 3px;"><img src="<%=cp%>/uploads/profile/${dto.imageFilename}" border="0" style="border-radius: 45px; width: 45px; height: 45px;"></td>
							<td><span style="line-height: 50px; padding-right: 50px;">${dto.name}</span></td>
							<td>${dto.birth}</td>
							<td>${dto.tel}</td>
							<td>${dto.email}</td>
							<td>${dto.dType}</td>
							<td>${dto.pType}</td>
						</tr>
					</c:forEach>
				</tr>
				<tr>
					<td colspan="8" id="list-paging">${dataCount == 0 ? "등록된 연락처가 없습니다." : paging}</td>
				</tr>
			</table>
		</div>
	</form>
</div>