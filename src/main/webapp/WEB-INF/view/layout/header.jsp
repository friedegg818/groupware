<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String cp = request.getContextPath();
%>

<script>
	$(function(){
		function ajaxJSON(url, type, query, fn) {
			$.ajax({
				type:type,
				url:url,
				data:query,
				dataType:"JSON",
				success:function(data) {
					fn(data);
				},
				beforeSend:function(jqXHR) {
			        jqXHR.setRequestHeader("AJAX", true);
			    },
			    error:function(jqXHR) {
			    	if(jqXHR.status==403) {
			    		login();
			    		return false;
			    	}
			    	console.log(jqXHR.responseText);
			    }
			});
		}
		
		function mainAlert() {
			var url = "<%=cp%>/main/mainAlert";
			var fn = function(data) {
				var mainCnt = data.mailCnt + data.stepCnt + data.newsCnt;
				
				var alertCnt = mainCnt;
				$("#mainCnt").html(alertCnt);
				
				var mailCnt = data.mailCnt;
				var stepCnt = data.stepCnt;
				var newsCnt = data.newsCnt;
				
				var out = "<p id='allAlert' style='margin-left: 10px; padding-top: 10px; font-size: 15px; margin-right: 10px; font-weight: bold; border-bottom: 1px solid #ccc; padding-bottom: 10px;'>전체 알림</p>";
				
				
				out += "<p id='mailCnt'><a href='<%=cp%>/buddy/rlist'><i class='fas fa-square fa-stack-2x' style='color: #632A7E; text-align: left; margin-left: 15px; padding-top: 10px;'></i>";
				out += "<i class='fas fa-envelope-open-text fa-stack-1x fa-inverse' style='width: 50px; backgroud: white; text-align: left; color: white; position: relative; margin-left: 25px; margin-top: 20px;'>";
				out += "<span style='position: absolute; background: #FFE641; color: #585858; width: 20px; height: 20px; border-radius: 50%; font-size: 16px; line-height: 20px; margin-top: -15px; text-align: center;'>";
				out += + mailCnt + "</span></i></a>" + "<span style='font-size: 15px; margin-left: 0px;'>새로운 메일 " + "<span style='font-weight: 1000;'>" + mailCnt + " 개</span></span>" + "</p>";
				
				
				
				out += "<p id='stepCnt'><a href='<%=cp%>/sign/mainList'><i class='fas fa-square fa-stack-2x' style='color: #632A7E; text-align: left; margin-left: 15px; margin-top: 15px;'></i>";
				out += "<i class='fas fa-clock fa-stack-1x fa-inverse'  style='width: 50px; backgroud: white; text-align: left; color: white; position: relative; margin-left: 25px; margin-top: 27px;'>";
				out += "<span style='position: absolute; background: #FFE641; color: #585858; width: 20px; height: 20px; border-radius: 50%; font-size: 16px; line-height: 20px; margin-top: -15px; text-align: center;'>";
				out += + stepCnt + "</span></i></a>" + "<span style='font-size: 15px; margin-left: 0px;'>처리해야 할 결재 " + "<span style='font-weight: 1000;'>" + stepCnt + " 건</span></span>" + "</p>";
				
				
				out += "<p id='newsCnt'><a class='newsClick' href='<%=cp%>/news/list'><i class='fas fa-square fa-stack-2x' style='color: #632A7E; text-align: left; margin-left: 15px; margin-top: 15px;'></i>";
				out += "<i class='far fa-building fa-stack-1x fa-inverse' style='width: 50px; backgroud: white; text-align: left; color: white; position: relative; margin-left: 25px; margin-top: 27px;'>";
				out += "<span style='position: absolute; background: #FFE641; color: #585858; width: 20px; height: 20px; border-radius: 50%; font-size: 16px; line-height: 20px; margin-top: -15px; text-align: center;'>";
				out += + newsCnt + "</span></i></a>" + "<span style='font-size: 15px; margin-left: 0px;'>회사소식 " + "<span style='font-weight: 1000;'>" + newsCnt + " 건</span></span>" + "</p>";
				
				$(".alertInfo").html(out);
				
				$("#mailCnt").css("font-size","25px");
				$("#stepCnt").css("font-size","25px");
				$("#newsCnt").css("font-size", "25px");
				
				if(mainCnt == 0) {
					$("#mainCnt").hide();
				} else {
					$("#mainCnt").show();
				}
				
			};
			
			var query = "";
			
			ajaxJSON(url, "post", query, fn);
		}
		mainAlert();
	});
	
	$(function(){
		$("body").on("click", "#headerAlert", function(){
			$(".alertTable").slideToggle();
		});
	});
	
	$(function(){
		$(".alertTable").hide();
	});
	
	// 전체 메뉴
	$(function(){
		$("#pullMenu").hide();
	});
	
	$(function(){
		$("body").on("click", "#hMenu", function(){
			$("#pullMenu").slideToggle();
		});
	});
</script>

<style>
.alertList {
	background-image: linear-gradient(to top, #cd9cf2 0%, #f6f3ff 100%);
}
</style>

<div class="header-top">
	<div class="header-left">
		<p style="margin: 2px 0 0 20px;">
			<a href="<%=cp%>/main">
				<span>
				<img src="<%=cp%>/resource/images/logo3.png" width="120" height="60">
				</span>
			</a>
		</p>
	</div>
	<div class="header-right">
		<div class="header-menu" style="position: relative;">
			<c:if test="${not empty sessionScope.employee}">
				<span style="color: white; font-size: 15px; position: relative; left: -50px;">${sessionScope.employee.name}님</span>
				<c:if test="${not empty sessionScope.employee.imageFilename}">
					<a href="<%=cp%>/profile/list"><img src="<%=cp%>/uploads/profile/${sessionScope.employee.imageFilename}" style="width: 36px; height: 36px; margin-right: 5px; border-radius: 18px; position: absolute; left: 20px; top: 15px;"></a>
				</c:if>
				<c:if test="${empty sessionScope.employee.imageFilename}">
					<a href="<%=cp%>"><i class="far fa-user-circle" style="margin-right: 5px;"></i></a> <!-- 프로필 -->
				</c:if>
				&nbsp;
			</c:if>
			
			<!-- 알림 -->
			<a href="#" id="headerAlert">
				<i class="far fa-bell" style='position: relative; margin-left: 10px; margin-top: 10px;'>
					<span id="mainCnt" style='position: absolute; top: -10px; right: -12px; background: #FFE641; color: #585858; width: 20px; height: 20px; border-radius: 50%; font-size: 16px; text-align: center; line-height: 20px;'></span>
				</i>
			</a>
			&nbsp;
			<a href="#" id="hMenu"><i class="fas fa-bars"></i></a> <!-- 메뉴 -->
			&nbsp;
			<c:if test="${sessionScope.employee.rCode == 'admin'}">
				<a href="<%=cp%>/employee/main"><i class="fas fa-user-cog"></i></a> <!-- 관리자 -->
				&nbsp;
			</c:if>
			<c:if test="${not empty sessionScope.employee}">
				<a href="<%=cp%>/employee/logout"><i class="fas fa-sign-out-alt"></i></a>
			</c:if>
		</div>
	</div>
	
	<!-- 알림창 -->
	<div class="alertTable" style="position: absolute; right: 30px; top: 65px; display: none;">
		<div class="alertList" style="width: 250px; height: 220px; position: relative; z-index: 2;">
			<span class="alertInfo"></span>
		</div>
	</div>
	
	<!-- header 메뉴 -->
	<div id="pullMenu" style="background: #F8EFFB; width: 1920px; top: 65px; position: absolute; z-index: 2; display: none;">
		<div style="position: relative; width: 1661px; margin: 0px auto;" class="pullMenu">
			<ul>	
				<li class="pullTitle" style="float: left; width: 217px; text-align: center; padding: 10px;">
				<p style="font-size: 20px; width: 217px; height: 30px; border-bottom: 1px solid #632A7E; font-weight: bold;">주소록</p>
					<ul class="submenu" style="font-size: 15px; padding: 5px;">
						<li style="margin-bottom: 10px; margin-top: 5px;"><a href="<%=cp%>/publicAddr/main">&nbsp;공용주소록</a></li>
						<li><a href="<%=cp%>/privateAddr/main">&nbsp;개인주소록</a></li>
					</ul>
				</li>

				<li class="pullTitle" style="float: left; width: 217px; text-align: center; padding: 10px;">
				<p style="font-size: 20px; width: 217px; height: 30px; border-bottom: 1px solid #632A7E; font-weight: bold;">메일</p>
					<ul class="submenu" style="font-size: 15px; padding: 5px;">
						<li style="margin-bottom: 10px; margin-top: 5px;"><a href="<%=cp%>/buddy/rlist">&nbsp;받은 메일함</a></li>
						<li style="margin-bottom: 10px;"><a href="<%=cp%>/buddy/slist">&nbsp;보낸 메일함</a></li>
						<li><a href="<%=cp%>/buddy/keep">&nbsp;중요 보관함</a></li>
					</ul>
				</li>

				<li class="pullTitle" style="float: left; width: 217px; text-align: center; padding: 10px;">
				<p style="font-size: 20px; width: 217px; height: 30px; border-bottom: 1px solid #632A7E; font-weight: bold;">전자결재</p>
					<ul class="submenu" style="font-size: 15px; padding: 5px;">						
						<li style="margin-bottom: 10px; margin-top: 5px;"><a href="<%=cp%>/sign/list?mode=1">&nbsp;결재 대기함</a></li>
						<li style="margin-bottom: 10px;"><a href="<%=cp%>/sign/list?mode=2">&nbsp;수신 대기함</a></li>
						<li><a href="<%=cp%>/sign/list?mode=3">&nbsp;결재 완료함</a></li>
					</ul>
				</li>
				
				<li class="pullTitle" style="float: left; width: 217px; text-align: center; padding: 10px;">
				<p style="font-size: 20px; width: 217px; height: 30px; border-bottom: 1px solid #632A7E; font-weight: bold;">근태</p>
					<ul class="submenu" style="font-size: 15px; padding: 5px;">
						<li style="margin-top: 5px;"><a href="<%=cp%>/workTime/main">&nbsp;근태관리</a></li>
					</ul>
				</li>

				<li class="pullTitle" style="float: left; width: 217px; text-align: center; padding: 10px;">
				<p style="font-size: 20px; width: 217px; height: 30px; border-bottom: 1px solid #632A7E; font-weight: bold;">캘린더</p>
					<ul class="submenu" style="font-size: 15px; padding: 5px;">
						<li style="margin-top: 5px;"><a href="<%=cp%>/scheduler/scheduler">&nbsp;일정 관리</a></li>
					</ul>
				</li>

				<li class="pullTitle" style="float: left; width: 217px; text-align: center; padding: 10px;">
				<p style="font-size: 20px; width: 217px; height: 30px; border-bottom: 1px solid #632A7E; font-weight: bold;">게시판</p>
					<ul class="submenu" style="font-size: 15px; padding: 5px;">
						<li style="margin-bottom: 10px; margin-top: 5px;"><a href="<%=cp%>/notice/list">&nbsp;공지</a></li>
						<li style="margin-bottom: 10px;"><a href="<%=cp%>/news/list">&nbsp;News</a></li>
						<li style="margin-bottom: 10px;"><a href="<%=cp%>/community/list">&nbsp;커뮤니티</a></li>
						<li><a href="<%=cp%>/food/month">&nbsp;식단표</a></li>
					</ul>
				</li>
			
				<li class="pullTitle" style="float: left; width: 217px; text-align: center; padding: 10px;">
				<p style="font-size: 20px; width: 217px; height: 30px; border-bottom: 1px solid #632A7E; font-weight: bold;">자료실</p>
					<ul class="submenu" style="font-size: 15px; padding: 5px;">
						<li style="margin-top: 5px;"><a href="<%=cp%>/data/list">&nbsp;자료실</a></li>
					</ul>
				</li>
			</ul>
		</div>	
	</div>
</div>