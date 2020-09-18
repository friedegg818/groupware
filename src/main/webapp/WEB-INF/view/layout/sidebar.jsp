<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String cp = request.getContextPath();
%>

<script type="text/javascript">
	$(function() {
	  var Accordion = function(el, multiple) {
	    this.el = el || {};
	    this.multiple = multiple || false;
	    
	    var dropdownlink = this.el.find('.menu-icon');
	    dropdownlink.on('click',
	                    { el: this.el, multiple: this.multiple },
	                    this.dropdown);
	  };
	  
	  Accordion.prototype.dropdown = function(e) {
	    var $el = e.data.el,
	        $this = $(this),
	        $next = $this.next();
	    
	    $next.slideToggle();
	    $this.parent().toggleClass('open');
	    
	    if(!e.data.multiple) {
	      $el.find('.sub-menu').not($next).slideUp().parent().removeClass('open');
	    }
	  }
	  
	  var accordion = new Accordion($('.menu-bar'), false);
	})
</script>

<div id="sideBarMenu">
	<ul class="menu-bar">
		<li>
			<div class="menu-icon" style="CURSOR:hand;" title="공용주소록">
				<a href="#"><i class="fas fa-briefcase"></i></a>
			</div>
			<ul class="sub-menu">
				<li><a class="sm2" href="<%=cp%>/publicAddr/main">공용<br>주소록</a></li>
			</ul>
		</li>
		
		<li>
			<div class="menu-icon" style="CURSOR:hand;" title="개인주소록">
				<a href="#"><i class="far fa-address-book"></i></a>
			</div>
			<ul class="sub-menu">
				<li><a class="sm2" href="<%=cp%>/privateAddr/main">개인<br>주소록</a></li>
			</ul>
		</li>	
		
		<li>
			<div class="menu-icon" style="CURSOR:hand;" title="메일">
				<a href="#"><i class="fas fa-envelope"></i></a>
			</div>
			<ul class="sub-menu">
				<li><a class="sm1" href="<%=cp%>/buddy/rlist">메일</a></li>
			</ul>
		</li>
		
		<li>
			<div class="menu-icon" style="CURSOR:hand;" title="전자결재">
				<a href="#"><i class="fas fa-file-signature"></i></a>
			</div>
			<ul class="sub-menu">
				<li><a class="sm3" href="<%=cp%>/sign/mainList">전자결재</a></li>
			</ul>
		</li>		
		
		<li>
			<div class="menu-icon" style="CURSOR:hand;" title="일정">
				<a href="#"><i class="fas fa-calendar-alt"></i></a>
			</div>
			<ul class="sub-menu">
				<li><a class="sm1" href="<%=cp%>/scheduler/scheduler">일정</a></li>
			</ul>
		</li>
		
		<li>
			<div class="menu-icon" style="CURSOR:hand;" title="커뮤니티">
				<a href="#"><i class="fas fa-users"></i></a>
			</div>
			<ul class="sub-menu">
				<li><a class="sm3" href="<%=cp%>/community/list">커뮤니티</a></li>
			</ul>
		</li>
		
		<li>
			<div class="menu-icon" style="CURSOR:hand;" title="게시판">
				<a href="#"><i class="fas fa-bullhorn"></i></a>
			</div>
			<ul class="sub-menu">
				<li><a class="sm4" href="<%=cp%>/notice/list">공지</a></li>
				<li><a class="sm4" href="<%=cp%>/news/list">News</a></li>
				<li><a class="sm4" href="<%=cp%>/food/month">식단표</a></li>
			</ul>
		</li>
		
		<li>
			<div class="menu-icon" style="CURSOR:hand;" title="근태관리">
				<a href="#"><i class="fas fa-user-clock"></i></a>
			</div>
			<ul class="sub-menu">
				<li><a class="sm3" href="<%=cp%>/workTime/main">근태관리</a></li>
			</ul>
		</li>
		
		<li>
			<div class="menu-icon" style="CURSOR:hand;" title="자료실">
				<a href="#"><i class="fas fa-download"></i></a>
			</div>
			<ul class="sub-menu">
				<li><a class="sm1" href="<%=cp%>/data/list">자료실</a></li>
			</ul>
		</li>
	</ul>
</div>
