<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String cp=request.getContextPath();
%>

<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.2.0/css/all.css">
<link rel="stylesheet" href="<%=cp%>/resource/css/normalize.css" type="text/css">
<link rel="stylesheet" href="<%=cp%>/resource/css/style.css" type="text/css">
<link rel="stylesheet" href="<%=cp%>/resource/css/login.css" type="text/css">

<script type="text/javascript">
function sendLogin() {
    var f = document.loginForm;

	var str = f.empNo.value;
    if(!str) {
        alert("사원번호를 입력해주세요.");
        f.empNo.focus();
        return;
    }

    str = f.pwd.value;
    if(!str) {
        alert("비밀번호를 입력해주세요.");
        f.pwd.focus();
        return;
    }

    f.action = "<%=cp%>/login/login";
    f.submit();
}
</script>

<div class="wrap">
	<div class="login-content">
		<c:if test="${empty sessionScope.employee}">
		<form name="loginForm" method="post">
			<div class="userIcon user">
				<div class="i">
					<i class="fas fa-user"></i>
				</div>
				
				<div class="div">
					<h5>User</h5>
					<input type="text" class="input" name="empNo" autocomplete="off" style="CURSOR:hand;" title="사번은 5자리입니다.">				
				</div>
			</div>
			
			<div class="userIcon lock">
				<div class="i">
					<i class="fas fa-lock"></i>
				</div>
				
				<div class="div">
					<h5>PassWord</h5>
						<input type="password" class="input" name="pwd">
				</div>
			</div>
			
			<button type="button" class="btn" onclick="sendLogin();">Login</button>
			
		</form>
		</c:if>
	</div>
	
	<div style="font-size: 20px; text-align: center; height: 70px; padding-top: 30px;">
		${message}
	</div>
</div>