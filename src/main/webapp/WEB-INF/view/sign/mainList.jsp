<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String cp = request.getContextPath();
%>

<link rel="stylesheet" href="<%=cp%>/resource/css/sign.css" type="text/css">
<script type="text/javascript"	src="<%=cp%>/resource/jquery/js/jquery-ui.min.js"></script>
<script type="text/javascript"	src="<%=cp%>/resource/jquery/js/jquery.ui.datepicker-ko.js"></script>

<script type="text/javascript">
	function ajaxHTML(url, type, query, selector) {
		$.ajax({
			type : type,
			url : url,
			data : query,
			success : function(data) {
				$(selector).html(data);
			},
			error : function(e) {
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

	/*===============================================================*/
	
	function searchList(){
		var f = document.searchForm;
		
		var str = f.keyword.value;
		if(! str){
			alert("빈내용은 검색 할 수 없습니다.");
			f.condition.focus();
			return;
		}
		
		f.submit();
	}
	
	$(function(){
		$("body").on("click", ".articleSign", function(){
			var option = $(this).closest("tr").find("input[class=dtostNum]").val();
			var valueSnum = $(this).closest("tr").find("input[class=dtoSnum]").val();
			
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
					
					var query = "option="+ option+ "&mode=article"+"&valueSnum="+valueSnum;
					
					ajaxHTML(url, "GET", query, ".showSing");
				
					
				},
				close : function(event, ui) {
						
				}
			});
		});
		
	});
	

	$(function(){
		$("body").on("click", ".choiceBtn", function(){
			var sNum = $(this).closest("form").find("input[class=hiddenSnum]").val();
			var option = $("input[name=option]").val();
			var val = $(this).val();
			
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
						location.href="<%=cp%>/sign/list?mode="+option;
					}
					ajaxJSON(url, "GET", query, fn);
				});
			}
		});
	});
	
	
	
	
</script>
<div class="container">
	<div class="board-container" style="width: 1600px;">
			<div class="body-title" style="height: 50px;">
				<span style="font-size: 18px; font-weight: 900;">♬ 전자결재</span>
			</div>
			
			<div class="board-body" style="float: left; width: 20%">
			<div>
				<button type="button" class="btnSend" style="width: 220px; cursor: pointer; height: 50px; border-radius: 10px; border: none; background: #9565A4;" onclick="javascript:location.href='<%=cp%>/sign/created';">
					<i class="fas fa-paste" style="color: white;"><span style="font-family: NanumSquareRound; font-size: 18px;">&nbsp;&nbsp;새결재진행</span></i>
				</button>
				<br>

				<form name="searchForm" action="<%=cp%>/sign/list?mode=5" method="post">
					<div class="selectGroup" style="margin-left: -0px;">
						<select class="selectBox" id="condition" name="condition" class="selectField">
							<option value="emptyVal" ${condition=="emptyVal"?"selected='selected'":""}>&nbsp;&nbsp;::선택::&nbsp;&nbsp;</option>
							<option value="title" ${condition=="title"?"selected='selected'":""}>제목</option>
							<option value="content" ${condition=="content"?"selected='selected'":""}>내용</option>
							<option value="created" ${condition=="created"?"selected='selected'":""}>기안일</option>
						</select>
					</div>
					<div style="margin-top: -10px;">
						<p style="font-size: 20px; border: 1px solid #cccccc; width: 220px;">
							<input type="text" id="keyword" name="keyword" class="boxTF" style="width: 170px; height: 35px; border: none; font-size: 15px; padding-left: 10px;">&nbsp;
							<button type=button onclick="searchList();" style="border: none; background: transparent;">
								<i class="fas fa-search"></i>
							</button>
						</p>
					</div>
				</form>
			</div>
		</div>
	
		<div class="board-body" style="float: left; width: 58%;">
			<div class="board-bodys" id="div1" style="height: 300px;">
				<div style=" border-bottom: 3px solid #9565A4; ">
					<table>
						<tr>
							<td align="left" data-tab="wait"><h3>| 결재대기함</h3></td>
						</tr>
					</table>
				</div>
				
				<div style="height: 140px;">
					<table style="border-collapse: collapse; width: 850px;">
						<tr align="center" bgcolor="#9565A4;">
							<th width="100">부서</th>
							<th width="100">기안자</th>
							<th width="100">종류</th>
							<th width="350">제목</th>
							<th width="100">기안일</th>
							<th width="100">결재상태</th>

						</tr>

						<c:if test="${list.size()==0}">
							<tr id="sList">
								<td class="board-paging" align="center" colspan="6" style="cursor: pointer;">
									<p style="text-align: center;">등록된 게시물이 없습니다.</p>
								</td>
							</tr>
						</c:if>
						<c:forEach var="dto" items="${list}">
							<tr id="sList" align="center" style="border-bottom: 1px solid #cccccc; cursor: pointer;">
								<td width="100">${dto.dType}</td>
								<td width="100">${dto.name}&nbsp;${dto.pType}</td>
								<td width="100">
								<input type="hidden" class="dtoSnum" value="${dto.snum}">
								<input type="hidden" class="dtostNum" value="${dto.stnum}">
									<c:choose>
										<c:when test="${dto.stnum == 1}">기안</c:when>
										<c:when test="${dto.stnum == 2}">휴가</c:when>
									</c:choose>
								</td>
								<td align="left" style="padding-left: 10px; width: 350px;">
									<a class="articleSign" >${dto.ssubject}</a>
								</td>
								<td width="100">${dto.sdate}</td>
								<td width="100">${dto.scurrStep!=dto.sendStep ?'미결':'완료'}</td>
							</tr>
						</c:forEach>
					</table>
				</div>

				<div style="text-align: right;" class="buttonDiv">
					<button type="button" class="btnPlus" id="btnPlus" name="btnPlus" onclick="javascript:location.href='<%=cp%>/sign/list?mode=1';" style="border: none; background: none;">
						<i class="fas fa-plus" style="font-size: 20px; margin-top: 10px; color: #9565A4; color: #9565A4;"></i>
					</button>
				</div>
			</div>

			<div class="board-bodys" id="div1" style="height: 300px; margin-top: 20px;">
				<div style=" border-bottom: 3px solid #9565A4; ">	
					<table>
						<tr>
							<td align="left"><h3>| 수신대기함</h3></td>
						</tr>
					</table>
				</div>

				<div style="height: 140px;">
					<table style="border-collapse: collapse; width: 850px;">
						<tr align="center" bgcolor="#006461;">
							<th width="100">부서</th>
							<th width="100">기안자</th>
							<th width="100">종류</th>
							<th width="350">제목</th>
							<th width="100">기안일</th>
							<th width="100">결재상태</th>
						</tr>
						<c:if test="${rlist.size()==0}">
							<tr id="sList">
								<td class="board-paging" align="center" colspan="6" style="cursor: pointer;">
									<p style="text-align: center;">등록된 게시물이 없습니다.</p>
								</td>
							</tr>
						</c:if>

						<c:forEach var="dto" items="${rlist}">
							<tr align="center" style="border-bottom: 1px solid #cccccc;">
								<td>${dto.dType}</td>
								<td>${dto.name}&nbsp;${dto.pType}</td>
								<td>
								<input type="hidden" class="dtoSnum" value="${dto.snum}">
								<input type="hidden" class="dtostNum" value="${dto.stnum}">
									<c:choose>
										<c:when test="${dto.stnum == 1}">기안</c:when>
										<c:when test="${dto.stnum == 2}">휴가</c:when>
									</c:choose>
								</td>
								<td align="left" style="padding-left: 10px;">
								<a class="articleSign">${dto.ssubject}</a>
								</td>
								<td>${dto.sdate}</td>
								<td>${dto.scurrStep!=dto.sendStep ?'미결':'완료'}</td>
							</tr>
						</c:forEach>
					</table>
				</div>
				<div style="text-align: right;" class="buttonDiv">
					<button type="button" class="btnPlus" id="btnPlus" name="btnPlus" onclick="javascript:location.href='<%=cp%>/sign/list?mode=2';" style="border: none; background: none;">
						<i class="fas fa-plus" style="font-size: 20px; margin-top: 10px; color: #9565A4;"></i>
					</button>
				</div>
			</div>

			<div class="board-bodys" id="div1"
				style="height: 300px;  margin-top: 20px;">
				<div style=" border-bottom: 3px solid #9565A4; ">
					<table>
						<tr>
							<td align="left"><h3>| 결재완료함</h3></td>
						</tr>
					</table>
				</div>


				<div style="height: 140px;">
					<table style="border-collapse: collapse; width: 850px;">
						<tr align="center" bgcolor="#006461;">
							<th width="100">부서</th>
							<th width="100">기안자</th>
							<th width="100">종류</th>
							<th width="350">제목</th>
							<th width="100">기안일</th>
							<th width="100">결재상태</th>
						</tr>
						<c:if test="${flist.size()==0}">
							<tr id="sList">
								<td class="board-paging" align="center" colspan="6" style="cursor: pointer;">
									<p style="text-align: center;">등록된 게시물이 없습니다.</p>
								</td>
							</tr>
						</c:if>

						<c:forEach var="dto" items="${flist}">
							<tr id="sList" align="center" style="border-bottom: 1px solid #cccccc; cursor: pointer;">
								<td>${dto.dType}</td>
								<td>${dto.name}&nbsp;${dto.pType}</td>
								<td>
								<input type="hidden" class="dtoSnum" value="${dto.snum}">
								<input type="hidden" class="dtostNum" value="${dto.stnum}">
									<c:choose>
										<c:when test="${dto.stnum == 1}">기안</c:when>
										<c:when test="${dto.stnum == 2}">휴가</c:when>
									</c:choose>
								</td>
								<td align="left" style="padding-left: 10px;">
								<a class="articleSign">${dto.ssubject}</a>
								</td>
								<td>${dto.sdate}</td>
								<td>${dto.scurrStep=='0'?'미결':'완료'}</td>
							</tr>
						</c:forEach>
					</table>
				</div>

				<div style="text-align: right;" class="buttonDiv">
					<button type="button" class="btnPlus" id="btnPlus" name="btnPlus" onclick="javascript:location.href='<%=cp%>/sign/list?mode=3';" style="border: none; background: none;">
						<i class="fas fa-plus" style="font-size: 20px; margin-top: 10px; color: #9565A4;"></i>
					</button>
				</div>
			</div>
			</div>
		
					<div class="board-body" style="float:left; width: 22%;">
						<div class="body-title" style="margin-top: -20px; margin-bottom: 15px;" >
							<table
								style="margin-top: 30px; margin-bottom: 5px; width: 100%; border: 1px solid #cccccc; border-bottom: none;">
								<tr align="left">
									<td style="font-weight: bold; font-size: 16px; padding-left: 10px;">
										<a href="javascript:location.href='<%=cp%>/sign/list?mode=4' " style="color: black;"><i class="fas fa-inbox">&nbsp;&nbsp;반려함</i></a>
									</td>
								</tr>
								<tr align="left">
									<c:if test="${returnList.size() != 0 }">
										<c:forEach var="dto" items="${returnList}">
											<td style="padding-left: 12px; color: #505050; border-bottom: 1px solid #cccccc;">
												<i class="fas fa-arrow-right"></i> ${dto.name} :
												${dto.ssubject}
											</td>
										</c:forEach>
									</c:if>
									<c:if test="${returnList.size() == 0 }">
										<td
											style="padding-left: 12px; color: #505050; border-bottom: 1px solid #cccccc;">
											<i class="fas fa-arrow-right"></i> 반려함이 비어있습니다. 
											<i class="fas fa-clock"></i>
										</td>
									</c:if>
								</tr>
								<tr align="left">
									<td style="font-weight: bold; font-size: 16px; padding-left: 10px;">
										<a href="javascript:location.href='<%=cp%>/sign/list?mode=6' " style="color: black; ">
											<i class="fas fa-save">&nbsp;&nbsp;임시보관함</i>
										</a>
									</td>
								</tr>
								<c:if test="${storageList.size() != 0 }">
										<c:forEach var="dto" items="${storageList}">
											<td style="padding-left: 12px; color: #505050; border-bottom: 1px solid #cccccc;">
												<i class="fas fa-arrow-right"></i> ${dto.name} : ${dto.ssubject}
											</td>
										</c:forEach>
									</c:if>
									<c:if test="${storageList.size() == 0 }">
										<td
											style="padding-left: 12px; color: #505050; border-bottom: 1px solid #cccccc;">
											<i class="fas fa-arrow-right"></i> 임시저장함이 비어있습니다. 
											<i class="fas fa-clock"></i>
										</td>
									</c:if>
							</table>
						</div>
				</div>
		</div>
</div>




<!-- 아티클 모달 -->
<div id="articleModal-dialog" class="articleModal" style="font-family: NanumSquareRound;">
	<div class="showSing">
	</div>
</div>

