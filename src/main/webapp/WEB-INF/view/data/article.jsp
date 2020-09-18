<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>
<link rel="stylesheet" href="<%=cp%>/resource/css/article.css" type="text/css">

<script type="text/javascript">
function deleteDatadept() {
	var q = "dataNum=${dto.dataNum}&${query}&dCode=${dto.dCode}";
	var url = "<%=cp%>/data/delete?" + q;

	if(confirm("위 자료를 삭제 하시 겠습니까 ? ")){
		  	location.href=url;
	}
}

function deleteData() {
	var q = "dataNum=${dto.dataNum}&${query}&dCode=NON";
	var url = "<%=cp%>/data/delete?" + q;

	if(confirm("위 자료를 삭제 하시 겠습니까 ? ")){
		  	location.href=url;
	}
}

function updateData() {
	  var q = "dataNum=${dto.dataNum}&page=${page}";
	  var url = "<%=cp%>/data/update?" + q;

	  location.href=url;
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
	});	
}


//댓글 리스트, 페이징처리 
$(function(){
	listPage(1);
});

function listPage(page) {
	var url = "<%=cp%>/data/listReply";
	var query = "dataNum=${dto.dataNum}&pageNo="+page;
	var selector = "#listReply";
	
	ajaxHTML(url, "get", query, selector);
}

// 댓글 등록  (num, content, answer 서버로 전송 / userId는 session 정보 들어가있음)
$(function(){
	$(".btnSendReply").click(function(){
		var dataNum = "${dto.dataNum}";
		var $ta = $(this).closest("table").find("textarea")
		var content = $ta.val().trim();
		if(! content) {
			$ta.focus();
			return false;
		}
		content = encodeURIComponent(content);
		
		var url = "<%=cp%>/data/insertReply";
		var query = "dataNum=" + dataNum + "&content=" + content;
		var fn = function(data) {
			var state = data.state;
			if(state=="false") {
				alert("댓글을 추가하지 못했습니다.");
				return false;
			}
			
			$ta.val("");
			listPage(1);
		}
		
		ajaxJSON(url, "post", query, fn);
		location.reload();
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
		
		var url = "<%=cp%>/data/deleteReply";
		var query = "replyNum="+replyNum+"&mode=reply";
		var fn = function(data){
			listPage(page);
		};
		ajaxJSON(url, "post", query, fn);
		location.reload();
	});
});

// 댓글별 답글 리스트 
function listReplyAnswer(answer) {
	var url = "<%=cp%>/data/listReplyAnswer";
	var query = {answer:answer};
	var selector = "#listReplyAnswer" + answer;
	ajaxHTML(url, "get", query, selector);
}

// 댓글별 답글 개수 
function countReplyAnswer(answer) {
	var url = "<%=cp%>/data/countReplyAnswer";
	var query = {answer:answer};
	
	var fn = function(data) {
		var count = data.count;
		var selector = "#answerCount" + answer;
		$(selector).text(count); 
	};
	ajaxJSON(url, "post", query, fn);
}

// 답글 버튼 : 댓글별 답글 폼, 댓글별 답글 리스트 출력 
$(function(){
	$("body").on("click", ".btnReplyAnswerLayout", function(){		// on : 동적으로 추가된 객체의 이벤트 처리
		var $trAnswer = $(this).closest("tr").next();
		var isVisible = $trAnswer.is(":visible");
		var replyNum = $(this).attr("data-replyNum");
		
		if(isVisible) {
			$trAnswer.hide();
		} else {
			$trAnswer.show();
			
			// 답글 리스트 
			listReplyAnswer(replyNum);		
			
			// 답글 개수 
			countReplyAnswer(replyNum);
		}
		
	});
});

// 댓글별 답글 등록 
$(function(){
	$("body").on("click", ".btnSendReplyAnswer", function(){
		var dataNum = "${dto.dataNum}";
		var replyNum = $(this).attr("data-replyNum");
		var $td = $(this).closest("td");
		var content = $td.find("textarea").val().trim();
		if(! content) {
			$td.find("textarea").focus();
			return false;
		}
		content = encodeURIComponent(content);
		
		var url = "<%=cp%>/data/insertReply";		
		var query = "dataNum="+dataNum+"&content="+content+"&answer="+replyNum;		
	
		
		var fn = function(data) {
			$td.find("textarea").val("");
			
			var state = data.state;
			if(state=="true") {
				// 댓글의 답글 리스트
				listReplyAnswer(replyNum);
				
				// 댓글의 답글 개수 
				countReplyAnswer(replyNum);
			}
		}
		
		ajaxJSON(url, "post", query, fn);
		 
	});
});

// 답글 삭제 
$(function(){
	$("body").on("click", ".deleteReplyAnswer", function(){
		if(! confirm("댓글을 삭제 하시겠습니까?")) {
			return false;
		}
		
		var replyNum = $(this).attr("data-replyNum");
		var answer = $(this).attr("data-answer");
		
		var url = "<%=cp%>/data/deleteReply";
		var query = "replyNum=" + replyNum + "&mode=answer";
		
		var fn = function(data) {
			listReplyAnswer(answer);
			countReplyAnswer(answer);
		};
		ajaxJSON(url, "post", query, fn);
	});
});

</script>
</head>
<body>

	
<div class="container">
     <div class="board-container">
       <div class="body-title" style="font-size: 18px;">
            <h3><i class="fas fa-cloud-download-alt"></i>&nbsp;&nbsp;자료실 </h3>
      </div>
      
       <div class="board-body" style="float: left; width: 20%;">	      
	       <div class="leftside">	        	
	       		<button class="leftsidebtn" type="button" onclick="javascript:location.href='<%=cp%>/data/created';"><i class="fas fa-marker"></i></button>
	       		<button class="leftsidebtn" type="button" onclick="javascript:location.href='<%=cp%>/data/list';"><i class="fas fa-list"></i></button>	
	       </div>   
      </div>
        
      <div class="board-article" style="margin-top: 10px; width: 80%; float: left;">
			<table class="articleTable">
			<tr align="left" height="40"  > 
			      <td class="typeTd" colspan="2">			      	 
				  
			      <c:if test="${sessionScope.employee.name == dto.name}">	
				      	<button type="button" class="articlebtn" onclick="updateData();"><i class="fas fa-edit"></i><span style="font-size: 13px;">수정</span></button>
				      	
				      	<c:if test="${dto.dCode=='NON'}">
				      		<button type="button" class="articlebtn" onclick="deleteData();"><i class="far fa-trash-alt"></i> <span style="font-size: 13px;"> 삭제 </span></button>
				 		</c:if>
				 		<c:if test="${dto.dCode!='NON'}">
				 			<button type="button" class="articlebtn" onclick="deleteDatadept();"><i class="far fa-trash-alt"></i> <span style="font-size: 13px;"> 삭제 </span></button>
				 		</c:if>
			 	  </c:if>
			 	  
			 	  <c:if test="${sessionScope.employee.name != dto.name}">
			 	  	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 	  	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 	  	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 	  </c:if>
			 	  	
			 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 	   
			 	   <c:if test="${not empty nextReadDto.dataNum && not empty preReadDto.dataNum}">	
				      	<button type="button" class="articlebtn" onclick="javascript:location.href='<%=cp%>/data/article?${query}&dataNum=${nextReadDto.dataNum}';"><i class="fas fa-arrow-up"></i> <span style="font-size: 13px;"> 다음 </span></button>		
				      	<button type="button" class="articlebtn" onclick="javascript:location.href='<%=cp%>/data/article?${query}&dataNum=${preReadDto.dataNum}';"><i class="fas fa-arrow-down"></i> <span style="font-size: 13px;"> 이전 </span></button>
			       </c:if>
			       
			       <c:if test="${empty nextReadDto.dataNum && not empty preReadDto.dataNum}">	
				      	<i class="fas fa-arrow-up" style="color: #CACFD2;"></i><span style="color: #CACFD2; font-size: 13px;"> 다음  </span>	
				      	<button type="button" class="articlebtn" onclick="javascript:location.href='<%=cp%>/data/article?${query}&dataNum=${preReadDto.dataNum}';"><i class="fas fa-arrow-down"></i> <span style="font-size: 13px;"> 이전 </span></button>
			       </c:if>
			       
			       <c:if test="${not empty nextReadDto.dataNum && empty preReadDto.dataNum}">	
				      	<button type="button" class="articlebtn" onclick="javascript:location.href='<%=cp%>/data/article?${query}&dataNum=${nextReadDto.dataNum}';"><i class="fas fa-arrow-up"></i> <span style="font-size: 13px;"> 다음 </span></button>		
				      	<i class="fas fa-arrow-down" style="color: #CACFD2;"></i><span style="color: #CACFD2; font-size: 13px;"> 이전  </span>
			       </c:if>
			       
			      </td>
			</tr>		
			 		
			 <tr align="left" height="50"> 
				 <td class="titleTd" colspan="2">
				 	${dto.title}  
				</td>   
			 </tr>		 	
			
			<tr height="35" style="border-bottom: 1px solid #cccccc;">
			    <td class="nameTd" align="left">
			      [${dto.dType}]&nbsp;${dto.name}&nbsp;${dto.pType}
			    </td>
			    <td class="createdTd" align="right";>
			        ${dto.created}
			    </td>
			</tr>
			
			<c:forEach var="vo" items="${listFile}">
				<tr>
				    <td class="fileTd" colspan="2" align="left">
				     <i class="fas fa-save"></i> 첨부 자료 | <a href="<%=cp%>/data/download?fileNum=${vo.fileNum}" style="font-size: 15px;">${vo.originalFilename}  (<fmt:formatNumber value="${vo.fileSize/1024}" pattern="0.00"/> KByte) </a>	        
				    </td>
				</tr>
			</c:forEach>
			
			<tr>
			  <td class="contentTd" colspan="2" align="left" valign="top">
			      ${dto.content}
			   </td>
			</tr>	
			</table>			
			
			
        <div>
		<table class="replyTable">
			<tr height='30'> 
				<td class="replyTd" align='left'>
				 	<i class="fas fa-comment-alt"></i>&nbsp;&nbsp;${dto.replyCount}&nbsp;&nbsp;
				 </td>
			</tr>
			<tr>
			   	<td style='padding:5px 5px 0px;'>
					<textarea class='replyArea'></textarea>
			    </td>
			</tr>
			<tr>
			   <td align='right'>
			        <button type='button' class='btn btnSendReply'>댓글 등록</button>
			    </td>
			 </tr>
		</table>  		
			<div id="listReply"></div>	
	</div>    
        </div>
    </div>
</div>


