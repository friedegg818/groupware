<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String cp=request.getContextPath();
%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.0.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-modal/0.9.1/jquery.modal.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-modal/0.9.1/jquery.modal.min.css" />
<link rel="stylesheet" href="<%=cp%>/resource/css/privateAddr.css" type="text/css">

<script type="text/javascript">	
	$(function(){
		listPage(1);
	});
	
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
	
	function ajaxHTML(url, type, query, selector) {
		$.ajax({
			type:type,
			url:url,
			data:query,
			success:function(data) {
				if($.trim(data)=="error") {
					listPage(1);
					return false;
				}	
				$(selector).html(data);
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
	
	//글리스트 및 페이징 처리
	function listPage(page) {
		var url="<%=cp%>/publicAddr/list";
		var query="page="+page;
		var search=$('form[name=publicAddrSearchForm]').serialize();
		query = query + "&" + search;
		var selector = "#tab-content";
		
		ajaxHTML(url, "get", query, selector);
	}
</script>

<script>
	function searchList() {
		var f = document.publicAddrSearchForm;
		f.condition.value = $("#condition").val();
		f.keyword.value = $.trim($("#keyword").val());
		
		listPage(1);
	}
	
	$(function(){
		$("body").on("click", ".all", function(){
			
			var f = document.publicAddrSearchForm;
			f.condition.value="all";
			f.keyword.value="";
			f.kor.value="";
			f.kor2.value="";
			
			$("#condition").val("all");
			$("#keyword").val("");
			
			listPage(1);
		});
	}); 

	$(function(){
		$("body").on("click", ".kor", function(){				
	
			var kor = $(this).attr("data-kor");
			var kor2 = $(this).next().attr("data-kor");
			
			var f = document.publicAddrSearchForm;
			f.condition.value="all";
			f.keyword.value="";
			$("#condition").val("all");
			$("#keyword").val("");
			
			f.kor.value=kor;
			f.kor2.value=kor2;
			
			listPage(1);
		});
	});
</script>

<div class="container">
	<div id="list-container">
		<div id="body-title">
			<i class="fas fa-map-pin"><span class="titleFont"> 공용주소록 |<span id="privateAddr-count">&nbsp;${dataCount}개</span></span></i>
		</div>
	
		<div id="listBtnBox">	
			<div id="listBtnBox-left">
				<button type="button" class="new-button3" onclick="javascript:location.href='<%=cp%>/publicAddr/main';"><i class="fas fa-undo-alt"></i></button>
			</div>
			
			<form name="searchForm" action="<%=cp%>/publicAddr/main" method="post">
				<div class="selectGroup-list">
					<select name="condition" id="condition" class="selectBox-list">
						<option value="all" ${condition=="all"?"selected='selected'":""}>모두</option>
						<option value="name" ${condition=="name"?"selected='selected'":""}>이름</option>
						<option value="birth" ${condition=="birth"?"selected='selected'":""}>생년월일</option>
						<option value="tel" ${condition=="tel"?"selected='selected'":""}>전화번호</option>
						<option value="dType" ${condition=="dType"?"selected='selected'":""}>부서</option>
						<option value="pType" ${condition=="pType"?"selected='selected'":""}>직위</option>
					</select>
				</div>
				<div id="searchBox">
					<p><input type="text" id="keyword" name="keyword" value="${keyword}">
					<button type="button" onclick="searchList()"><i class="fas fa-search"></i></button>
				</div>
			</form>
		
			<div id="tab-content"></div>
		</div>
		
		<form name="publicAddrSearchForm" action="" method="post">
			<input type="hidden" name="condition" value="all">
			<input type="hidden" name="keyword" value="">
			<input type="hidden" name="kor" value="">
			<input type="hidden" name="kor2" value="">
		</form>
	</div>
</div>