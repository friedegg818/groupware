<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String cp = request.getContextPath();
%>
<link rel="stylesheet" href="<%=cp%>/resource/css/employee.css" type="text/css">
<link rel="stylesheet" href="<%=cp%>/resource/css/profile.css" type="text/css">

<script type="text/javascript">
	function profileOk() {
		var f = document.profileForm;
/* 		var str;
		
		if(!/^(?=.*[a-z])(?=.*[!@#$%^*+=-]|.*[0-9]).{5,10}$/i.test(str)) { 
			alert("비밀번호는 5~10자이며 하나 이상의 숫자나 특수문자가 포함되어야 합니다.");
			f.pwd.focus();
			return;
		}
		
		f.pwd.value = str; */

	 	f.action = "<%=cp%>/profile/created";
	 	
	   	f.submit();
	}
</script>

<div class="container">
	<div class="testbox">
		<h1><i class="fas fa-pencil-alt"></i>프로필 수정</h1>

		<form name="profileForm" method="post" enctype="multipart/form-data">
			<div id="div-one">
				<div id="div-one-right" style="margin-top: 45px;">
					 <div class="imgLayout" style="margin-top: 20px; margin-left: 22px; width: 250px; height: 250px; padding: 5px; padding-top: 10px;  border: 1px solid #cccccc;  text-align: center; vertical-align: middle;">
			             <c:if test="${sessionScope.employee.imageFilename != null}"> 
			             	<img src="<%=cp%>/uploads/profile/${dto.imageFilename}" width="240" height="240" border="0">
			         	</c:if>
			         	<c:if test="${sessionScope.employee.imageFilename == null}">
							<img src="<%=cp%>/resource/images/basic.gif" style="width: 240px; height: 240px;" border="0">
						</c:if>			           
			         </div>
			         
			           <div class="filebox" style="margin-left: 33px; width: 250px; height: 50px;">				       
					          <input class="upload-name" value="프로필 사진  (240x240)" disabled="disabled" style="width: 160px;">
					          <label for="ex_filename">업로드</label>
					          <input type="file" id="ex_filename" class="upload-hidden" name="upload" class="boxTF"  style="width: 50px;">
				        </div>
				
					<div style="padding-left: 0px;">
						<label id="icon" style="margin-left: 0px;"><i class="fas fa-pen"></i></label>
							<input type="text" style="border: 2px solid  #FFBF00;" name="intro" value="${dto.intro}"/>
					</div>					
				</div>
				
				<div id="div-two" style="margin-top: 15px;">
					<div>
						<label id="icon"><i class="fas fa-user"></i></label>
							<input type="text" name="empNo" id="empNo" value="${sessionScope.employee.empNo}" readonly="readonly" />
					</div>
					
					<div>
					<label id="icon"><i class="fas fa-signature"></i></label>
						<input type="text" name="name" value="${sessionScope.employee.name}" readonly="readonly" />
					</div>
					
					<div>
					<label id="icon"><i class="fas fa-lock"></i></label>
						<input type="password" style="border: 2px solid  #FFBF00;" name="pwd" id="pwd" value="${dto.pwd}" placeholder="비밀번호"/>
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
					<button type="button" name="sendButton" class="button" onclick="profileOk();">정보 수정</button>
					<button type="reset" class="button">다시입력</button>
					<button type="button" class="button" onclick="javascript:location.href='<%=cp%>/profile/list';">수정 취소</button>
				</div>
			</div>
		</form>
	</div>
</div>