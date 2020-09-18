<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>
<link rel="stylesheet" href="<%=cp%>/resource/css/employee.css" type="text/css">

<script type="text/javascript">
	function deleteEmployee() {
		var q = "empNo=${dto.empNo}&page=${page}";
		var url = "<%=cp%>/employee/delete?" + q;
	
		if(confirm("위 자료를 삭제 하시 겠습니까 ? ")){
			  	location.href=url;
		}
	}
	
	$(function(){
		$('.selectBox').attr('disabled', 'true');
	});
</script>

<div class="container">
	<div class="testbox">
		<i class="fas fa-address-card">&nbsp;사원 정보</i>

		<form name="employeeForm" method="post">
			<div id="div-one">
				<div id="div-one-right">
					<div>
						<label id="icon"><i class="fas fa-user"></i></label>
							<input type="text" name="empNo" id="empNo" value="${dto.empNo}" readonly="readonly" />
					</div>
					
					<div>
					<label id="icon"><i class="fas fa-signature"></i></label>
						<input type="text" name="name" value="${dto.name}" readonly="readonly" />
					</div>
					
					<div>
					<label id="icon"><i class="fas fa-birthday-cake"></i></label>
						<input type="date" name="birth" value="${dto.birth}" readonly="readonly" />
					</div>
					
					<div>
					<label id="icon"><i class="fas fa-mobile-alt"></i></label>
						<input type="text" name="tel" value="${dto.tel}" readonly="readonly" />
					</div>
					
					<div>
					<label id="icon"><i class="far fa-envelope-open"></i></label>
						<input type="text" name="email" value="${dto.email}" readonly="readonly" />
					</div>
					
					<div>
					<label id="icon"><i class="fas fa-home"></i></label>
						<input type="text" name="addr" value="${dto.addr}" readonly="readonly" />
					</div>
				</div>
				
	
				<div id="div-two">
					<div class="selectGroup">
						<label id="icon"><i class="far fa-hand-rock"></i></label>
						<select class="selectBox" name="rCode" onFocus='this.initialSelect = this.selectedIndex;' onChange='this.selectedIndex = this.initialSelect;'>
							<option selected="selected" value="basic" ${dto.rCode=="basic"?"selected='selected'":"" }>기본</option>
							<option value="team" ${dto.rCode=="team"?"selected='selected'":"" }>팀장</option>
							<option value="admin" ${dto.rCode=="admin"?"selected='selected'":"" }>관리자</option>
						</select>
					</div>
					<div class="selectGroup">
						<label id="icon"><i class="fas fa-users"></i></label>
						<select class="selectBox" name="dCode" onFocus='this.initialSelect = this.selectedIndex;' onChange='this.selectedIndex = this.initialSelect;'>
							<option selected="selected" value="">::: 부서 :::</option>
							<option value="DV" ${dto.dCode=="DV"?"selected='selected'":"" }>개발부</option>
							<option value="PM" ${dto.dCode=="PM"?"selected='selected'":"" }>기획부</option>
							<option value="HR" ${dto.dCode=="HR"?"selected='selected'":"" }>인사부</option>
							<option value="PR" ${dto.dCode=="PR"?"selected='selected'":"" }>홍보부</option>
							<option value="TOP" ${dto.dCode=="TOP"?"selected='selected'":"" }>대표이사</option>
							<option value="BM" ${dto.dCode=="BM"?"selected='selected'":"" }>경영지원부</option>
						</select>
					</div>
					
					<div class="selectGroup">
						<label id="icon"><i class="fas fa-layer-group"></i></label>
						<select class="selectBox" name="pCode" onFocus='this.initialSelect = this.selectedIndex;' onChange='this.selectedIndex = this.initialSelect;'>
							<option selected="selected" value="">::: 직위 :::</option>
							<option value="01" ${dto.pCode=="01"?"selected='selected'":"" }>사원</option>
							<option value="02" ${dto.pCode=="02"?"selected='selected'":"" }>대리</option>
							<option value="03" ${dto.pCode=="03"?"selected='selected'":"" }>과장</option>
							<option value="04" ${dto.pCode=="04"?"selected='selected'":"" }>차장</option>
							<option value="05" ${dto.pCode=="05"?"selected='selected'":"" }>부장</option>
							<option value="06" ${dto.pCode=="06"?"selected='selected'":"" }>이사</option>
							<option value="11" ${dto.pCode=="11"?"selected='selected'":"" }>부사장</option>
							<option value="12" ${dto.pCode=="12"?"selected='selected'":"" }>대표이사</option>
						</select>
					</div>
					
					<div>
						<label id="icon"><i class="fas fa-sign-in-alt"></i></label>
							<input type="date" name="enterDate" value="${dto.enterDate}" readonly="readonly" />
					</div>
					
					<div>
						<label id="icon"><i class="fas fa-sign-out-alt"></i></label>
							<input type="date" name="exitDate" value="${dto.exitDate}" readonly="readonly" />
					</div>
					
					<div>
						<label id="icon"><i class="fas fa-sync"></i></label>
							<input type="date" name="apDate" value="${dto.apDate}" readonly="readonly" />
					</div>
					
					<div>
						<label id="icon"><i class="far fa-sticky-note"></i></label>
							<input type="text" name="memo" value="${dto.memo}" readonly="readonly" />
					</div>
				</div>
			</div>
			
			<div id="buttonBox">
				<div id="buttonSubBox">
					<button type="button" class="button" onclick="javascript:location.href='<%=cp%>/employee/update?employeeNum=${employeeNum}&page=${page}';">수정</button>
					<!-- <button type="button" class="button" onclick="deleteEmployee();">삭제</button> -->
					<button type="button" class="button" onclick="javascript:location.href='<%=cp%>/employee/main?${query}';">리스트</button>
				</div>
			</div>			
			<div>
				${message}
			</div>
		</form>
	</div>
</div>
