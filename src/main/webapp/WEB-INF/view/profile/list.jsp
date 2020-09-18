<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>
<link rel="stylesheet" href="<%=cp%>/resource/css/employee.css" type="text/css">

<script type="text/javascript">
	$(function(){
		$('.selectBox').attr('disabled', 'true');
	});
</script>

<div class="container">
	<div class="testbox">
		<h1>마이 페이지</h1>

		<form name="employeeForm" method="post">
			<div id="div-one">
				<div id="div-one-right" style="margin-top: 55px;">
					 <div class="imgLayout" style="margin-top: 20px; margin-left: 22px; width: 250px; height: 250px; padding: 5px; padding-top: 10px;  border: 1px solid #cccccc;  text-align: center; vertical-align: middle;">
			            <c:if test="${sessionScope.employee.imageFilename != null}"> 
			             	<img src="<%=cp%>/uploads/profile/${dto.imageFilename}" width="240" height="240" border="0">
			         	</c:if>
			         	<c:if test="${sessionScope.employee.imageFilename == null}">
									<img src="<%=cp%>/resource/images/basic.gif" style="width: 240px; height: 240px;" border="0">
						</c:if>
			         </div>
				
					<div style="padding-left: 0px;">
						<label id="icon" style="margin-left: 0px;"><i class="fas fa-pen"></i></label>
							<input type="text" name="intro" value="${dto.intro}" placeholder="&nbsp;자신을 표현 해 보세요!" readonly="readonly" />
					</div>					
				</div>
				
	
				<div id="div-two" style="margin-top: 40px;">
					<div>
						<label id="icon"><i class="fas fa-user"></i></label>
							<input type="text" name="empNo" id="empNo" value="${sessionScope.employee.empNo}" readonly="readonly" />
					</div>
					
					<div>
					<label id="icon"><i class="fas fa-signature"></i></label>
						<input type="text" name="name" value="${sessionScope.employee.name}" readonly="readonly" />
					</div>
					
					<div>
					<label id="icon"><i class="fas fa-users"></i></label>
						<input type="text" name="addr" value="${sessionScope.employee.dType} | ${sessionScope.employee.pType}" readonly="readonly" />
					</div>				
					
					<div>
					<label id="icon"><i class="fas fa-birthday-cake"></i></label>
						<input type="text" name="birth" value="${dto.birth}" readonly="readonly" />
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
						<label id="icon"><i class="fas fa-sign-in-alt"></i></label>
							<input type="text" name="enterDate" value="${dto.enterDate}" readonly="readonly" />
					</div>				
					
					
				</div>
			</div>
			
			<div id="buttonBox">
				<div id="buttonSubBox">
					<button type="button" class="button" onclick="javascript:location.href='<%=cp%>/profile/created';">수정</button>
					<button type="button" class="button" onclick="javascript:location.href='<%=cp%>/main';">메인으로</button>
				</div>
			</div>			
			<div>
				${message}
			</div>
		</form>
	</div>
</div>
