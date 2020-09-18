<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>

<link rel="stylesheet" href="<%=cp%>/resource/css/community.css" type="text/css">
<script type="text/javascript">
function deleteCommu() {
	var q = "commuNum=${dto.commuNum}&${query}";
	var url = "<%=cp%>/community/delete?" + q;

	if(confirm("글을 삭제 하시 겠습니까 ? ")){
		  	location.href=url;
	}
}

function updateCommu() {
	  var q = "commuNum=${dto.commuNum}&page=${page}";
	  var url = "<%=cp%>/community/update?" + q;

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

//게시글 공감 
$(function(){
	$(".btnSendCommuLike").click(function(){
		var url = "<%=cp%>/community/insertCommuLike";
		var n = "${dto.commuNum}";
		var query = {commuNum:n};		// 객체 형태 
		
		if(! confirm("게시물에 공감하십니까?")) {
			return false;
		}
		
		var fn = function(data) {
			var state = data.state;
			if(state=="false") {
				alert("게시글의 공감은 한번만 가능합니다.");
				return;
			}
			
			var count = data.commuLikeCount; 
			$("#commuLikeCount").text(count);
		}		
		ajaxJSON(url, "post", query, fn); 
		location.reload();
	});
});

//댓글 리스트, 페이징처리 
$(function(){
	listPage(1);
});

function listPage(page) {
	var url = "<%=cp%>/community/listReply";
	var query = "commuNum=${dto.commuNum}&pageNo="+page;
	var selector = "#listReply";
	
	ajaxHTML(url, "get", query, selector);
}

// 댓글 등록  (num, content, answer 서버로 전송 / userId는 session 정보 들어가있음)
$(function(){
	$(".btnSendReply").click(function(){
		var commuNum = "${dto.commuNum}";
		var $ta = $(this).closest("table").find("textarea")
		var content = $ta.val().trim();
		if(! content) {
			$ta.focus();
			return false;
		}
		content = encodeURIComponent(content);
		
		var url = "<%=cp%>/community/insertReply";
		var query = "commuNum=" + commuNum + "&content=" + content;
		var fn = function(data) {
			
			var state = data.state;
			var replyCount = data.replyCount;
			
			if(state=="false") {
				alert("댓글을 추가하지 못했습니다.");
				return false;
			}
			
			$ta.val("");
			$(".replyCount").text(replyCount);
			listPage(1);
		}
		
		ajaxJSON(url, "post", query, fn)
		
	});
});

//댓글 좋아요/싫어요 
$(function(){
	$("body").on("click", ".btnSendReplyLike", function(){
		var replyNum = $(this).attr("data-replyNum");
		var replyLike = $(this).attr("data-replyLike");
		var $btn = $(this);
		
		var msg="댓글이 마음에 들지 않으십니까?";
		if(replyLike==1) {
			msg="댓글에 공감하십니까?";
		}
		
		if(! confirm(msg)) {
			return false;
		}
		
		var url = "<%=cp%>/community/insertReplyLike";
		var query = "replyNum=" + replyNum + "&replyLike=" + replyLike;
		var fn = function(data){
			var state = data.state;
			if(state=="true") {
				var likeCount = data.likeCount;
				var disLikeCount = data.disLikeCount;
				
				$btn.parent("td").children().eq(0).find("span").html(likeCount);
				$btn.parent("td").children().eq(1).find("span").html(disLikeCount); 
			} else {
				alert("이미 공감 하셨습니다.");
			}
		};
		ajaxJSON(url, "post", query, fn);
	
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
		
		var url = "<%=cp%>/community/deleteReply";
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
	var url = "<%=cp%>/community/listReplyAnswer";
	var query = {answer:answer};
	var selector = "#listReplyAnswer" + answer;
	ajaxHTML(url, "get", query, selector);
}

// 댓글별 답글 개수 
function countReplyAnswer(answer) {
	var url = "<%=cp%>/community/countReplyAnswer";
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
		var commuNum = "${dto.commuNum}";
		var replyNum = $(this).attr("data-replyNum");
		var $td = $(this).closest("td");
		var content = $td.find("textarea").val().trim();
		if(! content) {
			$td.find("textarea").focus();
			return false;
		}
		content = encodeURIComponent(content);
		
		var url = "<%=cp%>/community/insertReply";		
		var query = "commuNum="+commuNum+"&content="+content+"&answer="+replyNum;		
	
		
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
		
		var url = "<%=cp%>/community/deleteReply";
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
    <div class="board-container" style="margin-left: 200px;">
       <div class="body-title" style="font-size: 18px;">
            <h3><i class="fas fa-satellite-dish"></i>&nbsp;&nbsp;커뮤니티 </h3>
      </div>
      
      <div class="board-body" style="float: left; width: 20%;">	      
	       <div style="margin-top: 20px; margin-left: 20px;">	        	
	       		<button type="button" style="width: 110px; height: 50px; background: #9565A4; color: white; font-size: 25px; border: none; border-radius: 10px;" onclick="javascript:location.href='<%=cp%>/community/created';"><i class="fas fa-marker"></i></button>
	       		<button type="button" style="width: 110px; height: 50px; background: #9565A4; color: white; font-size: 25px; border: none; border-radius: 10px;" onclick="javascript:location.href='<%=cp%>/community/list';"><i class="fas fa-list"></i></button>	
	       </div>   
      </div>
        
        <div class="board-article" style="margin-top: 10px; width: 80%; float: left;">
			<table>
			<tr align="left" height="40"  > 
			      <td colspan="2" style="width: 100px; padding-left: 10px; color: #424242; text-align: left; font-size: 20px; border-bottom: 1px solid #cccccc;">			      	 
					
					<c:if test="${sessionScope.employee.name == dto.name}">
			      		<button type="button" class="articlebtn" onclick="updateCommu();"><i class="fas fa-edit"></i><span style="font-size: 13px;">수정</span></button>
			      		<button type="button" class="articlebtn" onclick="deleteCommu();"><i class="far fa-trash-alt"></i> <span style="font-size: 13px;"> 삭제 </span></button>
			 		</c:if>
			 		
			 		<c:if test="${sessionScope.employee.name != dto.name}">
			      		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 		</c:if>
			 		
			 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			 		
			 		<c:if test="${not empty nextReadDto.commuNum && not empty preReadDto.commuNum}">
			      		<button type="button" class="articlebtn" onclick="javascript:location.href='<%=cp%>/community/article?${query}&commuNum=${nextReadDto.commuNum}';"><i class="fas fa-arrow-up"></i> <span style="font-size: 13px;"> 다음 </span></button>		
			      		<button type="button" class="articlebtn" onclick="javascript:location.href='<%=cp%>/community/article?${query}&commuNum=${preReadDto.commuNum}';"><i class="fas fa-arrow-down"></i> <span style="font-size: 13px;"> 이전 </span></button>
			      	</c:if>
			      	
			      	<c:if test="${not empty preReadDto.commuNum && empty nextReadDto.commuNum}">
			      		<i class="fas fa-arrow-up" style="color: #CACFD2;"></i><span style="color: #CACFD2; font-size: 13px;"> 다음  </span>
			      		<button type="button" class="articlebtn" onclick="javascript:location.href='<%=cp%>/community/article?${query}&commuNum=${preReadDto.commuNum}';"><i class="fas fa-arrow-down"></i> <span style="font-size: 13px;"> 이전 </span></button>
			     	</c:if>
			     	
			     	<c:if test="${empty preReadDto.commuNum && not empty nextReadDto.commuNum}">
			      		<button type="button" class="articlebtn" onclick="javascript:location.href='<%=cp%>/community/article?${query}&commuNum=${nextReadDto.commuNum}';"><i class="fas fa-arrow-up"></i> <span style="font-size: 13px;"> 다음 </span></button>	
			      		<i class="fas fa-arrow-down" style="color: #CACFD2;"></i><span style="color: #CACFD2; font-size: 13px;"> 이전  </span>
			     	</c:if>
			      </td>
			</tr>		 		
			 <tr align="left" height="50"> 
				 <td colspan="2" style="padding-top: 10px; width: 100px; font-size: 23px; color: #424242; text-align: left; padding-left: 10px;">
				 	${dto.title}  
				</td>   
			 </tr>		 	
			
			<tr height="35" style="border-bottom: 1px solid #cccccc;">
			    <td width="50%" align="left" style="padding-left: 14px; font-size: 15px;">
			     [${dto.dType}]&nbsp;${dto.name}&nbsp;${dto.pType}
			    </td>
			    <td width="50%" align="right" style="padding-right: 5px;">
			        ${dto.created}
			    </td>
			</tr>
			
			<tr>
			  <td colspan="2" align="left" style="padding: 10px 5px; padding-top: 30px; font-size: 17px;" valign="top" height="250">
			      ${dto.content}
			   </td>
			</tr>
			
			<tr>
				<td colspan="2" height="40" align="center" style="padding-bottom: 15px;">
					<button type="button" class="btn btnSendCommuLike" title="좋아요"><i class="fas fa-heart"></i> 좋아요 </button>
				</td>
			</tr>
			
			<c:forEach var="vo" items="${listFile}">
				<tr style="border-bottom: 1px solid #ccc;">
					<td colspan="2" height="35" align="left" style="padding-left: 10px; font-size: 15px;">
				     <i class="fas fa-save"></i> | <a href="<%=cp%>/community/download?fileNum=${vo.fileNum}" style="font-size: 13px;">${vo.originalFilename}</a>			       
				    </td>
				</tr>
			</c:forEach>
					
			</table>	
					
        <div>
		<table style="margin-top: 20px;">
			<tr height='30'> 
				 <td align='left' style="padding-left: 10px; font-size: 14px; color: #6E6E6E;" >
				 	<i class="fas fa-comment-alt"></i>&nbsp;&nbsp;<span class="replyCount">${dto.replyCount}</span>&nbsp;&nbsp;|&nbsp;&nbsp;조회 ${dto.hitCount}&nbsp;&nbsp;|&nbsp;&nbsp;<i class="fas fa-heart"></i> ${dto.commuLikeCount}
				 </td>
			</tr>
			<tr>
			   	<td style='padding:5px 5px 0px;'>
					<textarea class='boxTA' style='width:99%; height: 70px; border: 1px solid #cccccc;'></textarea>
			    </td>
			</tr>
			<tr>
			   <td align='right'>
			        <button type='button' class='btn btnSendReply' style='padding:10px 20px;'>댓글 등록</button>
			    </td>
			 </tr>
		</table>  		
			<div id="listReply"></div>	
	</div>    
        </div>
    </div>
</div>


