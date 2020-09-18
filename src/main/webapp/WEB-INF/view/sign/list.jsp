<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>

<link rel="stylesheet" href="<%=cp%>/resource/css/sign.css" type="text/css">
<script type="text/javascript" src="<%=cp%>/resource/jquery/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="<%=cp%>/resource/jquery/js/jquery.ui.datepicker-ko.js"></script>
<script type="text/javascript">
	function searchList() {
		var f=document.searchForm;
		f.submit();
	}
	
	function ajaxHTML(url, type, query, selector) {
		$.ajax({
			type:type,
			url:url,
			data:query,
			success:function(data){
				$(selector).html(data);
			},
			error:function(e){
				console.log(e.responseText);
			}
		});
	}
	

	function ajaxJSON(url, type, query, fn) {
		$.ajax({
			type:type
			,url:url
			,data:query
			,dataType:"json"
			,success:function(data) {
				fn(data);
			}
			/* , beforeSend:function(jqXHR) {
		        jqXHR.setRequestHeader("AJAX", true);
		    } */
		    ,error:function(jqXHR) {
		    	if(jqXHR.status==403) {
		    		login();
		    		return false;
		    	}
		    	console.log(jqXHR.responseText);
		    }
		});
	}
	
	$(function(){
		$("body").on("click", ".articleSign", function(){
			var option = $(this).closest("tr").find("input[class=dtoStnum]").val();
			var valueSnum = $(this).closest("tr").find("input[class=dtoSnum]").val();
			var listVal = "${mode}";
			
			$("#articleModal-dialog").dialog({
				modal : true,
				width : 1070,
				height : 1100,
				position : {my:"center top", at:"center top"},
				show : "fade",
				resizable : false,
				open : function() {
					
					$(".showSing").show();
					
					$(".ui-draggable .ui-dialog-titlebar").css("background", "white");
					$(".ui-draggable .ui-dialog-titlebar").css("border", "white");
					
					var url = "<%=cp%>/sign/search";
					
					if(option==0){
						return;
					}
					
					var query = "option="+ option+ "&mode=article"+"&valueSnum="+valueSnum+"&listVal="+listVal;
					
					ajaxHTML(url, "GET", query, ".showSing");
				
					
				},
				close : function(event, ui) {
						
				}
			});
		});
		
	});
	
	
	$(function(){
		$("body").on("click", ".choiceBtn", function(){
			var val = $(this).val();
			var sNum = $(this).closest("form").find("input[class=hiddenSnum]").val();
			
			var url = "<%=cp%>/sign/passSign";
			
			if(val == "ok"){
				var result = confirm("승인하시겠습니까?");
				
				if(result){
					var query = "passVal="+val+"&sNum="+sNum;
					ajaxHTML(url, "GET", query,"");
					
					location.reload();					
				}
			}else if(val == "no"){
				$(".returnMemoDiv").show();
				
				$("body").on("click", ".returnMemo", function(){
					var writer = $(this).closest("div").find("input[type=hidden]").val();
					var returnMemo = $(this).closest("div").find("textarea").val();
					
					var query = "passVal="+val+"&sNum="+sNum+"&writer="+writer+"&returnMemo="+returnMemo;
					var fn = function(data){
						var option = "${option}";
						location.href="<%=cp%>/sign/list?mode="+option;
					}
					ajaxJSON(url, "GET", query, fn);
				});
			}
		});
	});
	
	

	function check() {
		var f = document.inputForm;
		var hiddenSnum = $("input[class=hiddenSnum]").val();
		var option = $("input[class=option]").val();
		
		var pempNo2 = $("input[id=pempNo2]").val();
		var pempNo3 = $("input[id=pempNo3]").val();
		var pempNo4 = $("input[id=pempNo4]").val();
		
		var str = f.ssubject.value;
		if(!str){
			alert("제목을 입력하세요.");
			f.ssubject.focus();
			return false;
		}
		
		str = f.scontent.value;
		if(!str || str == "<p>&nbsp;</p>"){
			alert("내용을 입력하세요.");
			f.scontent.focus();
			return false;
		}
		
		
		storage = f.sStorage.value;
		
		var chk =  $("input:checkbox[id='sStorage']").is(":checked");
		
		if(chk){
			f.action = "<%=cp%>/sign/storage?option="+option+"&storage="+storage;
			f.submit();
			return;
		}
		
		if(! chk){
			f.action = "<%=cp%>/sign/created?option="+option+"&hiddenSnum="+hiddenSnum+"&pempNo2="+pempNo2+"&pempNo3="+pempNo3+"&pempNo4="+pempNo4+"&article=article";
			f.submit();
			return;
		}
	}
	

	$(function() {
		$("body").on("click", "button[id=btnLine]", function(){
			var value = $(this).closest("div").find("input[name=lineDivChild]").val();
			var $btn = $(this);
			$("#lineModal-dialog").dialog({
				modal : true,
				width : 600,
				title : '결재라인',
				open : function() {
				},
				close : function(event, ui) {
						var empNo = $("#listTable input[name=cb]:checked").val();
						if(empNo == undefined){
							return;
						}
						var dType = $("#listTable input[name=cb]:checked").closest("td").next().children("input[name=hDType]").val();
						var pType = $("#listTable input[name=cb]:checked").closest("td").next().next().children("input[name=hPType]").val();
						var tdName = $("#listTable input[name=cb]:checked").closest("td").next().next().next().children("input[name=hName]").val();
						$btn.closest("table").find(".typeTd").append("<span>"+ dType + " | " + pType + "</span>");
						$btn.closest("table").find(".nameTd").append("<span>"+ tdName + "</span>");
						
						
						$("#listTable input[name=cb]").prop("checked", false);
						
						$btn.closest("td").find("input").val(empNo);
				}
			});
		});
		
		$("body").on("click", "#btnLineSelectOk", function(){
			$('#lineModal-dialog').dialog("close");
		});
			
	});

	function deleteChk(){
		var checkArr = [];
		$("input[name=chkVal]:checked").closest("td").find("input[type=hidden]").each(function(i){
			checkArr.push($(this).val());
		});
		
		var url = "<%=cp%>/sign/delete";
		
		$.ajax({
			url : url,
			type : "POST",
			dataType : "text",
			data : {
				valueArrTest : checkArr
			}
		});
		
		location.reload();
	}
	
</script>

<div class="container">
	<div class="board-container" style="width: 1600px;">
		<div class="body-title" style="height: 50px;">
				<span style="font-size: 20px; font-weight: 900;">♬ 전자결재</span>
		</div>
	
		
		<div class="board-body" style="float: left; width: 20%">
			<div>
				<button type="button" class="btnSend" style="width: 98px; cursor: pointer; height: 50px; border-radius: 10px; border: none; background: #9565A4;" onclick="javascript:location.href='<%=cp%>/sign/created';">
					<i class="fas fa-paste" style="color: white; font-size: 18px;">&nbsp;New</i>
				</button>
				<button type="button" class="boardBtn"style="width: 98px; cursor: pointer; height: 50px; border-radius: 10px; border: none; background: #9565A4;"  onclick="javascript:location.href='<%=cp%>/sign/mainList';">
					<i class="far fa-arrow-alt-circle-left" style="color: white; font-size: 18px; font-weight: bold">&nbsp;back</i>
				</button>
			</div>
		</div>
		
		 
        <div class="board-body">
			<div class="board-body" style="float: left; width: 58%;">
			
				  <h3 style="font-size: 18px;">| ${mode}
				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				   <span>${mode=='임시보관함' ? '<button type="button" class="deleteBtn" onclick="deleteChk();" style="background: #9565A4; height: 30px; width: 70px; border: none; color: white; font-weight: bold; font-size: 15px;">삭제하기</button>' : '' }</span>
				  </h3>
		<form method="POST" name="deleteForm">
			<table class="trData" style="border-collapse: collapse; width: 850px; margin-top: 20px;">
			  <tr align="center" bgcolor="#006461;" style="border-top: 3px solid #9565A4;"> 
			      <th width="100">${mode=='임시보관함' ? '선택' : '부서' }</th>
				  <th width="100">기안자</th>
			      <th width="100">종류</th>
			      <th width="350">제목</th>
			      <th width="100">기안일</th>
			      <th width="100">상태</th>
			  </tr>
			<c:forEach var="dto" items="${list}">
			  <tr id="sList" align="center" style="border-bottom: 1px solid #cccccc; cursor: pointer;">
			      <td> ${mode=='임시보관함' ?
			       		'<input type="checkbox" class="chkVal" name="chkVal">' : dto.dType }
			      	<input type="hidden" class="dtoSnum" value="${dto.snum}"></td>
				  <td>
				  	<c:if test="${mode=='임시보관함'}">
				  		${sessionScope.employee.name}&nbsp;
				  		${sessionScope.employee.pType}
				  	</c:if>
				  	<c:if test="${mode!='임시보관함'}">
				  		${dto.name}&nbsp;${dto.pType}
				  	</c:if>
				  </td>
			      <td class="stNum">
			      <c:choose>
			      	<c:when test="${dto.stnum == 1}">기안</c:when>
			      	<c:when test="${dto.stnum == 2}">휴가</c:when>
			      </c:choose>
			      	<input type="hidden" class="dtoStnum" value="${dto.stnum}"></td>
			      <td align="left" style="padding-left: 10px;" class="ssubject">
			           <a class="articleSign">${dto.ssubject}</a>
			      </td>
			      <td>${dto.sdate}</td>
			      <td>${dto.scurrStep!=dto.sendStep?'미결':'완료'}</td>
			  </tr>
			</c:forEach>
			</table>
		</form>
			 
			<table style="width: 850px;">
			   <tr>
				<td class="board-paging" align="center" id="list-paging">
			        ${dataCount==0 ? "등록된 게시물이 없습니다.":paging}
				</td>
			   </tr>
			</table>
			</div>
        </div>
        
        <div class="board-body" style="float: left; color: #323232">
				<table style="width: 100%; border: 1px solid #cccccc; border-bottom: none; width: 250px; margin-top: 40px;">
					<tr align="left">
						<td style="padding-left: 12px; padding: 13px; border-bottom: 1px solid #cccccc; font-weight: bold; font-size: 18px; ">
						<i class="fas fa-bookmark" style="color: #323232;"></i>
							<a class="signList" href="javascript:location.href='<%=cp%>/sign/list?mode=1'">&nbsp;&nbsp;결재대기함 </a>
						</td>
					</tr>
					<tr align="left">
						<td style="padding-left: 12px; padding: 13px; border-bottom: 1px solid #cccccc; font-weight: bold; font-size: 18px; ">
						<i class="fas fa-bookmark" style="color: #323232;"></i>
							<a class="signList" href="javascript:location.href='<%=cp%>/sign/list?mode=2'">&nbsp;&nbsp;수신대기함 </a>
						</td>
					</tr>
					<tr align="left">
						<td style="padding-left: 12px; padding: 13px; border-bottom: 1px solid #cccccc; font-weight: bold; font-size: 18px; ">
						<i class="fas fa-bookmark" style="color: #323232;"></i>
							<a class="signList" href="javascript:location.href='<%=cp%>/sign/list?mode=3'">&nbsp;&nbsp;결재완료함 </a>
						</td>
					</tr>
					<tr align="left">
						<td style="padding-left: 12px; padding: 13px; border-bottom: 1px solid #cccccc; font-weight: bold; font-size: 18px; ">
						<i class="fas fa-bookmark" style="color: #323232;"></i>
							<a class="signList" href="javascript:location.href='<%=cp%>/sign/list?mode=6'">&nbsp;&nbsp;임시보관함 </a>
						</td>
					</tr>
					<tr align="left">
						<td style="padding-left: 12px; padding: 13px; border-bottom: 1px solid #cccccc; font-weight: bold; font-size: 18px; ">
						<i class="fas fa-bookmark" style="color: #323232;"></i>
							<a class="signList" href="javascript:location.href='<%=cp%>/sign/list?mode=4'">&nbsp;&nbsp;반려함 </a>
						</td>
					</tr>
				</table>
			</div>
		</div>        
    </div>



<!-- 아티클 모달 -->
<div id="articleModal-dialog" class="articleModal" style="font-family: NanumSquareRound;">
	<div class="showSing">
	</div>
</div>

