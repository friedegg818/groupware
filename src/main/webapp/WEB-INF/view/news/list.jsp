﻿<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>
<link rel="stylesheet" href="<%=cp%>/resource/css/data.css" type="text/css">
<style>

.newsSort{
	margin-left:20px;
	padding-top: 22px;
	cursor: pointer;
}
.newsSort a {color :#632A7E }
.newsSort a:hover {color :#632A7E; font-weight: bold;}
.newsSort a:focus {color :#632A7E; font-weight: bold;}
.newsSort a:active {color :#632A7E; font-weight: bold;}

#newsbtn{
	background: transparent;
	border:none;
	height: 47px; 
    margin-top: 10px;
    text-align: left; 
    line-height: 47px;
    font-size: 16px;
}

</style>

<script type="text/javascript">
	function searchList() {
		var f=document.searchForm;
		f.submit();
	}
	
	function searchList2(nCode) {
		var f=document.searchForm;
		f.nCode.value=nCode;
		f.submit();
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


	
</script>




<div class="container">
    <div class="board-container"  style="margin-left: 200px;">
        <div class="board-title"  style="font-size: 18px;">
            <h3><i class="far fa-newspaper"></i>&nbsp;&nbsp;소식 </h3>
        </div>
        
        <div class="board-body" style="float: left; width: 20%;">
        	<div style="margin-top: 20px; margin-left: 20px;">
      				<button type="button" style="width: 220px; height: 50px; background: #9565A4; color: white; font-size: 25px; border: none; border-radius: 10px;" onclick="writeNews();" title="글쓰기"><i class="fas fa-pen-alt"></i> </button>

	       	</div>	
	       	
	       	
	       	<form name="searchForm"  action="<%=cp%>/news/list" method="post">
	        	<div class="selectGroup">
	        		  <select class="selectBox selectField" name="condition">			              
			          	   <option value="title" ${condition=="title"?"selected='selected'":""}>제목</option>
			               <option value="name" ${condition=="name"?"selected='selected'":""}>작성자</option>
			            <%--    <option value="content" ${condition=="content"?"selected='selected'":""}>분류</option> --%>
			               <option value="created" ${condition=="created"?"selected='selected'":""}>등록일</option>
				      </select> 
				      		<input type="hidden" name="rows" value="${rows}">
							<input type="hidden" name="newsNum" value="${newsNum}">
							<input type="hidden" name="nCode" value="${nCode}">
				</div>
	        	
	        	<div style="margin-left: 20px; margin-top: -10px;">
	        		<p style="font-size: 20px; border: 1px solid #cccccc; width: 220px;"><input type="text" name="keyword" class="boxTF" style="width: 170px; height: 35px; border: none; font-size: 15px; padding-left: 10px;">&nbsp;
	        				<button type=button onclick="searchList()" style="border: none; background: transparent;"><i class="fas fa-search"></i></button></p>
	        	</div>  
        	</form> 
        </div>

		<div class="board-body" style="width: 58%; float: left;" > 
			<div class="body-title" style="margin-top: 20px; margin-bottom: 15px;">
				 <h3 style="font-size: 18px;">| 전체 소식
          		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		  
          		  <button type="button" style="border: none; background: transparent;" onclick="javascript:location.href='<%=cp%>/news/list';"><i class="fas fa-redo-alt"></i></button>
          		  </h3>          		 
      		 </div>
      		 <div style="width: 800px;">
      		 	<%-- <div style="margin: 20px 0 20px 0; text-align: right;">
      		 	<c:if test="${dataCount==0}">
      		 		<p>&nbsp;</p>
      		 	</c:if>
      		 	<c:if test="${dataCount!=0}">
				     ${dataCount}개(${page==0? "":page}/${total_page} page)
				</c:if>
				</div> --%>
				<table class="tablesorter" style="border-collapse: collapse; border-bottom: 1px solid #cccccc;">
				  <tr align="center" style="border-bottom: 1px solid #cccccc; border-top: 1px solid #cccccc; font-size: 14px; font-weight: bold; color: #424242;"> 
				      <th width="90">번호</th>
				      <th width="80">분류</th>
				      <th width="410">제목</th>
				      <th width="120">작성자</th>
				      <th width="100">작성일</th>
				  </tr>
				<c:forEach var="dto" items="${list}">
				  <tr align="center" style="border-bottom: 1px solid #E6E6E6;"> 
				      <td>${dto.listNum}</td>
				      <td style="text-align: left">
				      	 <c:if test="${dto.nType=='결혼'}">
				       		   <i class="fas fa-heart"></i>&nbsp;&nbsp;${dto.nType}
				      	 </c:if>
				     	 <c:if test="${dto.nType=='부고'}">
				      		   <i class="fas fa-ribbon"></i>&nbsp;&nbsp;${dto.nType}
				     	 </c:if>
				     	 <c:if test="${dto.nType=='회사소식'}">
				       		  <i class="fas fa-building"></i>&nbsp;&nbsp;${dto.nType}
				     	 </c:if>
				     	 <c:if test="${dto.nType=='출산'}">
				       		  <i class="fas fa-baby"></i>&nbsp;&nbsp;${dto.nType}
				     	 </c:if>
				     	 <c:if test="${dto.nType=='승진'}">
				       		 <i class="fas fa-level-up-alt"></i>&nbsp;&nbsp;${dto.nType}
				       	 </c:if>
				     	 <c:if test="${dto.nType=='기타'}">																		
							<i class="fas fa-asterisk"></i>&nbsp;&nbsp;${dto.nType}										
						 </c:if>     
				      </td>
				      <td align="left" style="padding-left: 14px;">
				           <a href="${articleUrl}&newsNum=${dto.newsNum}">${dto.title}&nbsp;(${dto.replyCount})</a>
				      </td>
				      <td>${dto.name}&nbsp;${dto.pType} </td>
				      <td>${dto.created}</td>
				  </tr>
				</c:forEach>
				</table>
			 
				<table style="margin-top: 10px; width: 100%">
				   <tr>
					<td class="board-paging" align="center">
				         ${dataCount==0 ? "등록된 게시물이 없습니다.":paging}
					</td>
				   </tr>
				</table>
			</div>
        </div>
        	

        
        <div class="board-body" style="width: 22%; float: left;" > 
			<div class="body-title" style="margin-top: 25px; margin-bottom: 15px;">
          		  <div class="newsSort">
	          		  <p><a id="newsbtn" onclick="javascript:searchList2('MR');"> <i class="fas fa-heart"></i>&nbsp;&nbsp; 결혼  </a></p>
					  <p><a id="newsbtn" onclick="javascript:searchList2('FU');"> <i class="fas fa-ribbon"></i>&nbsp;&nbsp; 부고  </a></p>
					  <p><a id="newsbtn" onclick="javascript:searchList2('BI');"> <i class="fas fa-baby"></i>&nbsp;&nbsp; 출산  </a>
					  <p><a id="newsbtn" onclick="javascript:searchList2('PR');"> <i class="fas fa-level-up-alt"></i>&nbsp;&nbsp; 승진  </a></p>
					  <p><a id="newsbtn" onclick="javascript:searchList2('COMPANY');"> <i class="fas fa-building"></i>&nbsp;&nbsp;회사소식  </a></p>
					  <p><a id="newsbtn" onclick="javascript:searchList2('ETC');"> <i class="fas fa-asterisk"></i>&nbsp;&nbsp; 기타  </a></p>
				</div>		
   			</div>
		</div>
	</div>
	</div>
		

