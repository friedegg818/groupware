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

<script>
	function addrAdd() {
		var f = document.addrAddForm;
		var str;
		
		str = f.name.value;
		str = str.trim();
		
		if(!str) {
			alert("이름을 입력해주세요.");
			f.name.focus();
			return;
		}
		
		str = f.email.value;
		str = str.trim();
		
		if(!str) {
			alert("이메일을 입력해주세요.");
			f.email.focus();
			return;
		}
		
		str = f.tel.value;
		str = str.trim();
		
		if(!str) {
			alert("전화번호를 입력해주세요.");
			f.tel.focus();
			return;
		}
		
		str = f.groupNum.value;
		str = str.trim();
		
		if(!str) {
			alert("그룹을 추가해주세요.");
			f.groupNum.focus();
			return;
		}
		
	 	f.action = "<%=cp%>/privateAddr/privateAddr2";
	 	
	   	f.submit();
	}
</script>

<script>
	$(function(){
		$("body").on("click", "#addrAdd", function(){
			$("#textBox").slideToggle();
		});
	});
</script>

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
		var url="<%=cp%>/privateAddr/list";
		var query="page="+page;
		var search=$('form[name=privateAddrSearchForm]').serialize();
		query = query + "&" + search;
		var selector = "#tab-content";
		
		ajaxHTML(url, "get", query, selector);
	}
</script>

<script>
	// 모달창 그룹 추가 버튼 누르면 효과
	$(function(){
		$("body").on("click", "#groupAdd", function(){
			$("#edit").slideToggle();
		});
	});
	
	// 모달창 리스트 & 추가
	$(function(){
		$("body").on("click", "#saveGroup", function(){
			if($("#newGroupName").val().length == 0) {
				alert("그룹을 추가해 주세요.");
				$(".txt_mini").focus();
				return;
			}
			
			var query=$("form[name=modalGroup]").serialize();
			var url="<%=cp%>/privateAddr/modalInsert";
			
			$.ajax({
				type:"post",
				url:url,
				data:query,
				dataType : "JSON",
				success:function(data) {
					var state=data.state;
					if(state=="true") {
						//location.href="<%=cp%>/privateAddr/privateAddr";
						var s="<button type='button' class='groupNameList' name='groupNameList' data-groupType='"+data.dto.groupType+"' data-groupNum='"+data.dto.groupNum+"'>"+data.dto.groupType+"</button>";
						$(".jyy").append(s);
					}
				},
				beforeSend : function(jqXHR) {
			        jqXHR.setRequestHeader("AJAX", true);
			    },
			    error:function(jqXHR) {
			    	if(jqXHR.status==403) {
			    		location.href="<%=cp%>/login";
			    		return;
			    	}
			    	console.log(jqXHR.responseText);
			    }
			});		
		});
	});
	
	 $(function(){
 		$("body").on("click", ".groupNameList", function(){
 			var groupNum=$(this).attr("data-groupNum");
		 	$("#groupNum").val(groupNum);
		 	
		 	var groupType=$(this).attr("data-groupType");
		 	$("#groupType").val(groupType);
		});
	});
</script>

<script>
	function searchList() {
		var f = document.privateAddrSearchForm;
		f.condition.value = $("#condition").val();
		f.keyword.value = $.trim($("#keyword").val());
		
		listPage(1);
	}
	
	$(function(){
		$("body").on("click", ".all", function(){
			
			var f = document.privateAddrSearchForm;
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
			
			var f = document.privateAddrSearchForm;
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

<script>
	function updatePrivateAddr(addrNum, page) {
		var query = "addrNum=" + addrNum + "&page=" + page;
		var url = "<%=cp%>/privateAddr/update?" + query;
		
		console.log(addrNum);
		
		location.href = url;
	} 

	function deletePrivateAddr(addrNum) {
		var query = "addrNum=" + addrNum + "&page=${page}";
		var url = "<%=cp%>/privateAddr/delete?" + query;
	
		if(confirm("선택한 주소록을 삭제 하시겠습니까 ? ")){
			  	location.href=url;
		}
	}
</script>

<div class="container">
	<div id="list-container">
		<div id="body-title">
			<i class="fas fa-map-pin"><span class="titleFont"> 개인주소록 |<span id="privateAddr-count">&nbsp;${dataCount}개</span></span></i>
		</div>
	
		<div id="listBtnBox">
			<div id="listBtnBox-left">
				<button type="button" class="new-button1" onclick="javascript:location.href='<%=cp%>/privateAddr/privateAddr';"><i class="fas fa-user-plus"></i></button>
				<button type="button" class="new-button2" onclick="javascript:location.href='<%=cp%>/privateAddr/main';"><i class="fas fa-undo-alt"></i></button>
			</div>
		
			<form name="searchForm" action="<%=cp%>/privateAddr/main" method="post">
				<div class="selectGroup-list">
					<select name="condition" id="condition" class="selectBox-list">
						<option value="all" ${condition=="all"?"selected='selected'":""}>모두</option>
						<option value="name" ${condition=="name"?"selected='selected'":""}>이름</option>
						<option value="tel" ${condition=="tel"?"selected='selected'":""}>전화번호</option>
						<option value="company" ${condition=="company"?"selected='selected'":""}>회사명</option>
						<option value="groupType" ${condition=="groupType"?"selected='selected'":""}>그룹명</option>
					</select>
				</div>
				<div id="searchBox">
					<p><input type="text" id="keyword" name="keyword" value="${keyword}">
					<button type="button" onclick="searchList()"><i class="fas fa-search"></i></button>
				</div>
			</form>
			
			<div id="tab-content"></div>
		</div>
		
		<form name="privateAddrSearchForm" action="" method="post">
			<input type="hidden" name="condition" value="all">
			<input type="hidden" name="keyword" value="">
			<input type="hidden" name="kor" value="">
			<input type="hidden" name="kor2" value="">
		</form>
	</div>
</div>