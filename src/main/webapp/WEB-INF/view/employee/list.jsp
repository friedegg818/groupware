<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String cp=request.getContextPath();
%>

<div id="list-header">
	<table id="list-menu">
		<tr id="list-title">
			<td id="empNo-list">사원번호</td>
			<td id="name-list">이름</td>
			<td id="tel-list">전화번호</td>
			<td id="email-list">이메일</td>
			<td id="enterDate-list">입사</td>
			<td id="dType-list">부서</td>
			<td id="pType-list">직위</td>
			<td id="search-list">상세</td>
		</tr>
		
		<c:forEach var="dto" items="${list}">
			<tr id="list-content">
				<td>${dto.empNo}</td>
				<td>${dto.name}</td>
				<td>${dto.tel}</td>
				<td>${dto.email}</td>
				<td>${dto.enterDate}</td>
				<td>${dto.dType}</td>
				<td>${dto.pType}</td>
				<td id="listView"><a href="<%=cp%>/employee/article?employeeNum=${dto.employeeNum}&page=${page}"><i class="fas fa-search"></i></a></td>
			</tr>
		</c:forEach>
		<tr>
			<td colspan="8" id="list-paging">${dataCount == 0 ? "등록된 게시물이 없습니다." : paging}</td>
		</tr>
	</table>
</div>