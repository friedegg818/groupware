<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String cp = request.getContextPath();
%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.0.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-modal/0.9.1/jquery.modal.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-modal/0.9.1/jquery.modal.min.css" />
<link rel="stylesheet" href="<%=cp%>/resource/css/privateAddr.css" type="text/css">

<style>
::-webkit-scrollbar {
	width: 10px;
	background: transparent;
}

.sidebar {
	min-height: 1000px;
}
</style>

<script type="text/javascript">
	function privateAddr() {
		var f = document.privateAddrForm;
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
		
		$("#name").removeAttr("disabled");
		$("#email").removeAttr("disabled");
		$("#tel").removeAttr("disabled");
		$("#company").removeAttr("disabled");
		$("#dName").removeAttr("disabled");
		$("#dTel").removeAttr("disabled");
		$("#dAddr").removeAttr("disabled");
		$("#memo").removeAttr("disabled");
		$("#groupType").removeAttr("disabled");
		$("#groupNum").removeAttr("disabled");
		
	 	f.action = "<%=cp%>/privateAddr/${mode}";
	 	
	   	f.submit();
	}
</script>

<script type="text/javascript">
	$(function(){
		$('#button_on1').click(function() {
			$("input[name=name]").prop('disabled', false).css('border-bottom', '2px solid #B336ED');
			var len = $('#name').val().length;
			$('#name').focus();
			$('#name')[0].setSelectionRange(len, len);
		});
				
		$('#button_on2').click(function() {
			$("input[name=email]").prop('disabled', false).css('border-bottom', '2px solid #B336ED');
			var len = $('#email').val().length;
			$('#email').focus();
			$('#email')[0].setSelectionRange(len, len);
		});
		
		$('#button_on3').click(function() {
			$("input[name=tel]").prop('disabled', false).css('border-bottom', '2px solid #B336ED');
			var len = $('#tel').val().length;
			$('#tel').focus();
			$('#tel')[0].setSelectionRange(len, len);
			
		});
		
		$('#button_on4').click(function() {
			$("input[name=company]").prop('disabled', false).css('border-bottom', '2px solid #B336ED');
			var len = $('#company').val().length;
			$('#company').focus();
			$('#company')[0].setSelectionRange(len, len);
		});
		
		$('#button_on5').click(function() {
			$("input[name=dName]").prop('disabled', false).css('border-bottom', '2px solid #B336ED');
			var len = $('#dName').val().length;
			$('#dName').focus();
			$('#dName')[0].setSelectionRange(len, len);
		});
		
		$('#button_on6').click(function() {
			$("input[name=dTel]").prop('disabled', false).css('border-bottom', '2px solid #B336ED');
			var len = $('#dTel').val().length;
			$('#dTel').focus();
			$('#dTel')[0].setSelectionRange(len, len);
		});
		
		$('#button_on7').click(function() {
			$("input[name=dAddr]").prop('disabled', false).css('border-bottom', '2px solid #B336ED');
			var len = $('#dAddr').val().length;
			$('#dAddr').focus();
			$('#dAddr')[0].setSelectionRange(len, len);
		});
		
		$('#button_on8').click(function() {
			$("input[name=memo]").prop('disabled', false).css('border-bottom', '2px solid #B336ED');
			var len = $('#memo').val().length;
			$('#memo').focus();
			$('#memo')[0].setSelectionRange(len, len);
		});
		
		$('#button_on9').click(function() {
			$("input[name=groupNum]").prop('disabled', false).css('border-bottom', '2px solid #B336ED').focus("");
			var len = $('#groupNum').val().length;
			$('#groupNum').focus();
			$('#groupNum')[0].setSelectionRange(len, len);
		});
		
	});	
	
	
	// 모달창에 그룹 추가
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
	
	// 모달창 그룹 추가 버튼 누르면 효과
	$(function(){
		$("body").on("click", "#groupAdd", function(){
			$("#edit").slideToggle();
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

<div class="container">
	<div class="privateAddr-container">
		<div class="privateAddr-title">
			<h2>${mode == "privateAddr" ? "연락처 추가" : "연락처 수정"}</h2>

			<form name="privateAddrForm" method="post">
				<input type="text" class="privateAddr-input" name="name" id="name" placeholder="이름" value="${dto.name}" ${mode == "update" ? "disabled='disabled'" : ""}>
				<button type="button" class="button_on" id="button_on1"><i class="far fa-edit"></i></button>
						
				<input type="text" class="privateAddr-input" name="email" id="email" placeholder="이메일" value="${dto.email}" ${mode == "update" ? "disabled='disabled'" : ""}>
				<button type="button" class="button_on" id="button_on2"><i class="far fa-edit"></i></button>
				
				<input type="text" class="privateAddr-input" name="tel" id="tel" placeholder="전화번호" value="${dto.tel}" ${mode == "update" ? "disabled='disabled'" : ""}>
				<button type="button" class="button_on" id="button_on3"><i class="far fa-edit"></i></button>
				
				<input type="text" class="privateAddr-input" name="company" id="company" placeholder="회사명" value="${dto.company}" ${mode == "update" ? "disabled='disabled'" : ""}>
				<button type="button" class="button_on" id="button_on4"><i class="far fa-edit"></i></button>
				
				<input type="text" class="privateAddr-input" name="dName" id="dName" placeholder="부서명" value="${dto.dName}" ${mode == "update" ? "disabled='disabled'" : ""}>
				<button type="button" class="button_on" id="button_on5"><i class="far fa-edit"></i></button>
				
				<input type="text" class="privateAddr-input" name="dTel" id="dTel" placeholder="회사번호" value="${dto.dTel}" ${mode == "update" ? "disabled='disabled'" : ""}>
				<button type="button" class="button_on" id="button_on6"><i class="far fa-edit"></i></button>
				
				<input type="text" class="privateAddr-input" name="dAddr" id="dAddr" placeholder="회사주소" value="${dto.dAddr}" ${mode == "update" ? "disabled='disabled'" : ""}>
				<button type="button" class="button_on" id="button_on7"><i class="far fa-edit"></i></button>
				
				<input type="text" class="privateAddr-input" name="memo" id="memo" placeholder="메모" value="${dto.memo}" ${mode == "update" ? "disabled='disabled'" : ""}>
				<button type="button" class="button_on" id="button_on8"><i class="far fa-edit"></i></button>
				
				<input type="text" class="privateAddr-input" name="groupType" id="groupType" value="${dto.groupType}" placeholder="그룹분류" ${mode == "update" ? "disabled='disabled'" : ""}>
				<input type="hidden" class="privateAddr-input" name="groupNum" id="groupNum" value="${dto.groupNum}" placeholder="그룹분류" ${mode == "update" ? "disabled='disabled'" : ""}>
				<a class="btn" href="#ex7"><button type="button" class="button_on"><i class="far fa-plus-square" style="font-size: 20px;"></i></button></a>

				<div class="button-container">
					<button type="button" class="privateAddr-button" onclick="privateAddr();">${mode == 'privateAddr' ? '등록' : '수정'}</button>
					<button type="button" class="privateAddr-button" onclick="javascript:location.href='<%=cp%>/privateAddr/main';">취소</button>
				</div>
				<c:if test="${mode=='update'}">
					<input type="hidden" name="addrNum" value="${dto.addrNum}">
		        	<input type="hidden" name="page" value="${page}">
		        </c:if>
			</form>
			
			<!-- 모달창 -->
			<div id="ex7" class="modal">
				<p> &nbsp; </p>	
				<h3><i class="far fa-object-group" style="font-size: 25px;"></i> 그룹 추가 </h3>		

				<div class="board-created">
					<form name="modalGroup" method="post">
					
						<div class="jyy">
							<c:forEach var = "dto" items="${modalList}">
								<button type="button" class="groupNameList" name="groupNameList" data-groupType="${dto.groupType}" data-groupNum="${dto.groupNum}">${dto.groupType}</button>
							</c:forEach>
						</div>
					
						<div class="edit" id="edit" style="display: none;">
							<input class="txt_mini" id="newGroupName" name="groupType" type="text" placeholder="새 그룹 이름">
							<button type="button" id="saveGroup" name="saveGroup"><i class="fas fa-check"></i></button>
							<button type="reset" id="edit-reset"><i class="fas fa-undo-alt"></i></button>
						</div>
					
				  		<div style="width: 450px; margin-top: 10px;">
				    		<button type="button" id="groupAdd">+ 새그룹</button>
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
	</div>
</div>