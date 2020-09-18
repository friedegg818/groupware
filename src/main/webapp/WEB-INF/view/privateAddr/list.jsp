<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String cp = request.getContextPath();
%>

<div id="list-Box">		
	<div id="speedInsertBox">
		<label><button id="addrAdd"><i class="fas fa-plus"><span class="titleFont">&nbsp;&nbsp;빠른 등록</span></i></button></label>&nbsp;&nbsp;
		<label><button type="button" id="excelOut" onclick="javascript:location.href='<%=cp%>/privateAddr/excel';"><i class="fas fa-file-export"><span class="titleFont">&nbsp;&nbsp;내보내기</span></i></button></label>
	</div>
	
	<form name="addrAddForm" method="post">
		<div id="speedInsert">
			<label id="textBox">
				<input type="text" name="name" id="name" placeholder="이름(표시명)"/>
				<input type="text" name="email" id="email" placeholder="이메일">
				<input type="text" name="tel" id="tel" placeholder="전화번호">
				<input type="hidden" name="groupNum" id="groupNum" value="${dto.groupNum}" placeholder="그룹분류" ${mode == "update" ? "disabled='disabled'" : ""}>
				<input type="text" name="groupType" id="groupType" value="${dto.groupType}" placeholder="그룹분류" readonly="readonly" ${mode == "update" ? "disabled='disabled'" : ""}>
				<a class="btn" href="#ex7"><button type="button" id="groupButton">그룹추가</button></a>
				<button type="button" id="groupAddButton" onclick="addrAdd();"><i class="fas fa-plus"> 추가</i></button>
			</label>
		</div>

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
					<td id="name-title">이름</td>
					<td id="tel-title">전화번호</td>
					<td id="email-title">이메일</td>
					<td id="dName-title">회사명</td>
					<td id="group-title">그룹</td>
					<td id="view-title">상세</td>
					<td id="delete-title">삭제</td>
				</tr>
				
				<tr id="list-cotainer">
					<c:forEach var="dto" items="${list}">
						<tr id="list-content">
							<td>${dto.name}</td>
							<td>${dto.tel}</td>
							<td>${dto.email}</td>
							<td>${dto.company}</td>
							<td>${dto.groupType}</td>
							<td><button type="button" onclick="updatePrivateAddr('${dto.addrNum}', '${page}');"><i class="fas fa-search"></i></button></td>
							<td><button type="button" onclick="deletePrivateAddr('${dto.addrNum}', '${page}');"><i class="fas fa-trash-alt"></i></button></td>
						</tr>
					</c:forEach>
				</tr>
				
				<tr>
					<td colspan="8" id="list-paging">${dataCount == 0 ? "등록된 연락처가 없습니다." : paging}</td>
				</tr>
			</table>
		</div>
	</form>	
	
	<!-- 모달창 -->
	<div id="ex7" class="modal">
		<p> &nbsp; </p>	
		<h3><i class="fas fa-object-group"></i> 그룹 추가 </h3>		

		<div class="board-created">
			<form name="modalGroup" method="post">
			
				<div class="jyy">
					<c:forEach var = "dto" items="${modalList}">
						<button type="button" class="groupNameList" name="groupNameList" data-groupType="${dto.groupType}" data-groupNum="${dto.groupNum}">${dto.groupType}</button>
					</c:forEach>
				</div>
			
				<div class="edit" id="edit">
					<input class="txt_mini" id="newGroupName" name="groupType" type="text" placeholder="새 그룹 이름">
					<button type="button" id="saveGroup" name="saveGroup"><i class="fas fa-check"></i></button>
					<button type="reset" id="edit-reset"><i class="fas fa-undo-alt"></i></button>
				</div>
			
		  		<div id="newGroupAdd">
		    		<button type="button" id="groupAdd">새 그룹 추가</button>
		     	</div>
			</form>
		</div>
	</div>
	
	<script>
		$('a[href="#ex7"]').click(function(event) {
			event.preventDefault();

			$(this).modal({
				fadeDuration : 250,
			});
		});
	</script>
</div>