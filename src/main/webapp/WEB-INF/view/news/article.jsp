<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>
<link rel="stylesheet" href="<%=cp%>/resource/css/article.css" type="text/css">
<style>
.sidebar{
	min-height: 1000px;
}
</style>

<script type="text/javascript">
function deleteNews() {
	<c:if test="${sessionScope.employee.dCode=='PR' || sessionScope.employee.empNo==dto.writer}">
		var q = "newsNum=${dto.newsNum}&${query}";
		var url = "<%=cp%>/news/delete?" + q;
	
		if(confirm("위 자료를 삭제 하시 겠습니까 ? ")){
			  	location.href=url;
		}
	</c:if>
	<c:if test="${sessionScope.employee.dCode!='PR' && sessionScope.employee.empNo!=dto.writer}">
		alert("권한이 없습니다.");
	</c:if>
}

function updateNews() {
	<c:if test="${sessionScope.employee.dCode=='PR' || sessionScope.employee.empNo==dto.writer}">
	  var q = "newsNum=${dto.newsNum}&page=${page}";
	  var url = "<%=cp%>/news/update?" + q;

	  location.href=url;
	 </c:if>
	 <c:if test="${sessionScope.employee.dCode!='PR' && sessionScope.employee.empNo!=dto.writer}">
		alert("권한이 없습니다.");
	</c:if>
} 

function writeNews() {
	<c:if test="${sessionScope.employee.dCode=='PR'}">
		var url = "<%=cp%>/news/created";
		location.href=url;
	</c:if>

	<c:if test="${sessionScope.employee.dCode!='PR'}">
		alert("권한이 없습니다.");
	</c:if>
}
	  
function ajaxJSON(url, method, query, fn) {
	$.ajax({
		type: method, 
		url: url,
		data: query,
		dataType: "json",
		success: function(data){
			fn(data);
		}, 
		beforeSend: function(jqXHR) {
			jqXHR.setRequestHeader("AJAX", true);
		}, 
		error: function(jqXHR) {
			if(jqXHR.state==403) {		// 로그인이 안됐으면 
				login(); 
				return false;
			} 			
			console.log(jqXHR.responseText);
		}
	});
}

function ajaxHTML(url, method, query, selector) {
	$.ajax({
		type: method, 
		url: url,
		data: query,
		success: function(data){
			$(selector).html(data);
		}, 
		beforeSend: function(jqXHR) {
			jqXHR.setRequestHeader("AJAX", true);
		}, 
		error: function(jqXHR) {
			if(jqXHR.state==403) {		
				login(); 
				return false;
			} 			
			console.log(jqXHR.responseText);
		}
	});		}

//댓글 리스트, 페이징처리 
$(function(){
	listPage(1);
});

function listPage(page) {
	var url = "<%=cp%>/news/listReply";
	var query = "newsNum=${dto.newsNum}&pageNo="+page;
	var selector = "#listReply";
			
	ajaxHTML(url, "get", query, selector);
}

// 댓글 등록  (num, content, answer 서버로 전송 / userId는 session 정보 들어가있음)
$(function(){
	$(".btnSendReply").click(function(){
		var newsNum = "${dto.newsNum}";
		var $ta = $(this).closest("table").find("textarea")
		var content = $ta.val().trim();
		if(! content) {
			$ta.focus();
			return false;
		}
		content = encodeURIComponent(content);
		
		var url = "<%=cp%>/news/insertReply";
		var query = "newsNum=" + newsNum + "&content=" + content;
		var fn = function(data) {
			var state = data.state;
			if(state=="false") {
				alert("댓글을 추가하지 못했습니다.");
				return false;
			}
					
			$ta.val("");
			listPage(1);
		}
				
		ajaxJSON(url, "post", query, fn)
	});
});


		// 댓글 삭제 
$(function(){
	$("body").on("click", ".deleteReply", function(){
		if(! confirm("댓글을 삭제 하시겠습니까?")) {
			return false;
		}
		var replyNum = $(this).attr("data-replyNum");
		var page = $(this).attr("data-pageNo");
		
		var url = "<%=cp%>/news/deleteReply";
		var query = "replyNum="+replyNum;
		var fn = function(data){
			listPage(page);
		};
		ajaxJSON(url, "post", query, fn);		
	});
});
		
		

</script>



	
<div class="container">
    <div class="board-container"  style="margin-left: 200px;">
        <div class="board-title"  style="font-size: 18px;">
             <h3><i class="far fa-newspaper"></i>&nbsp;&nbsp;소식 </h3>
        </div>
        
        <div class="board-body" style="float: left; width: 20%;">
        	<div class="leftside">	        	
	       		<button class="leftsidebtn" type="button" onclick="writeNews();" title="글쓰기"><i class="fas fa-marker"></i></button>
	       		<button class="leftsidebtn" type="button" onclick="javascript:location.href='<%=cp%>/news/list?${query}';" title="목록으로"><i class="fas fa-list"></i></button>	
	       </div>   
	       	
        </div>
        
        <div class="board-article" style="margin-top: 10px; width: 80%; float: left;">
			<table class="articleTable">
				<tr align="left" height="40"  > 
				      
				      <c:if test="${sessionScope.employee.empNo == dto.writer || sessionScope.employee.dCode=='PR'}">			      	 
				     	<td class="typeTd" colspan="2">
				      	<button type="button" class="articlebtn" onclick="updateNews();"><i class="fas fa-edit"></i><span style="font-size: 13px;">수정</span></button>
				      	<button type="button" class="articlebtn" onclick="deleteNews();"><i class="far fa-trash-alt"></i> <span style="font-size: 13px;"> 삭제 </span></button>
				 	  </c:if>	
				 	  
				 	   <c:if test="${sessionScope.employee.empNo != dto.writer && sessionScope.employee.dCode !='PR'}">
				 	   <td class="typeTd" colspan="2" style="padding-bottom: 10px;">
						    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					 	  	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					 	  	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				      </c:if>
				 	  
				 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				 		
				 		<c:if test="${not empty preReadDto}">
				      	<button type="button" class="articlebtn" onclick="javascript:location.href='<%=cp%>/news/article?${query}&newsNum=${preReadDto.newsNum}';"><i class="fas fa-arrow-up"></i> <span style="font-size: 13px;"> 다음 </span></button>	
				      	</c:if>	
				      	<c:if test="${empty preReadDto}">
				      	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				      	</c:if>	
				      	<c:if test="${not empty nextReadDto}">
				      	<button type="button" class="articlebtn" onclick="javascript:location.href='<%=cp%>/news/article?${query}&newsNum=${nextReadDto.newsNum}';"><i class="fas fa-arrow-down"></i> <span style="font-size: 13px;"> 이전 </span></button>
				      	</c:if>	
				      </td>
				</tr>
				<tr align="left" height="50"> 
					 <td class="titleTd" colspan="2">
					 	[${dto.nType}] ${dto.title}  
					</td>   
				</tr>	
				<tr height="35" style="border-bottom: 1px solid #cccccc;">
				    <td class="nameTd" align="left">
				      	작성자 : [${dto.dType}]&nbsp;${dto.name}&nbsp;${dto.pType}
				    </td>
				    <td class="createdTd" align="right">
				        ${dto.created}
				    </td>
				</tr>
				<tr>
				  <td class="contentTd" colspan="2" align="left" valign="top">
				      ${dto.content}
				   </td>
				</tr>	
			</table>
		<div>
			<table class="replyTable">
				<tr>
					<td style='padding:5px 5px 0px;'>
						<textarea class='replyArea' style="resize: none;"></textarea>
					</td>
				</tr>
				<tr>
					<td align='right'>
						<button type='button' class='btn btnSendReply'>댓글 등록</button>
					</td>
				</tr>
			</table> 
		</div>	
		
		<div id="listReply"></div>	   
      </div>
    </div>
</div>
