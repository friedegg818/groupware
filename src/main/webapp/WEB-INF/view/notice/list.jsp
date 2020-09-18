<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>
<link rel="stylesheet" href="<%=cp%>/resource/css/data.css" type="text/css">
<script type="text/javascript">
	function searchList() {
		var f=document.searchForm;
		f.submit();
	}

    
    function writeNotice() {
    	<c:if test="${sessionScope.employee.dCode=='HR'}">
    		var url = "<%=cp%>/notice/created";
    		location.href=url;
    	</c:if>

    	<c:if test="${sessionScope.employee.dCode!='HR'}">
    		alert("권한이 없습니다.");
    	</c:if>
    }
    	  
</script>

<div class="container">
    <div class="board-container"  style="margin-left: 200px;">
        <div class="board-title"  style="font-size: 18px;">
            <h3><i class="fas fa-bullhorn"></i>&nbsp;&nbsp;공지사항 </h3>
        </div>
        
        <div class="board-body" style="float: left; width: 20%;">
        	<div style="margin-top: 20px; margin-left: 20px;">
      			<button type="button" style="width: 220px; height: 50px; background: #9565A4; color: white; font-size: 25px; border: none; border-radius: 10px;" onclick="writeNotice();" title="글쓰기"><i class="fas fa-pen-alt"></i> </button>
	       	</div>	
	       	
	       	<form name="searchForm"  action="<%=cp%>/notice/list" method="post">
	        	<div class="selectGroup">
	        		  <select class="selectBox selectField" name="condition">			              
			          	   <option value="title" ${condition=="title"?"selected='selected'":""}>제목</option>
			               <option value="name" ${condition=="name"?"selected='selected'":""}>작성자</option>
			               <option value="content" ${condition=="content"?"selected='selected'":""}>내용</option>
			               <option value="created" ${condition=="created"?"selected='selected'":""}>등록일</option>
				      </select> 
				      		<input type="hidden" name="rows" value="${rows}">
							<input type="hidden" name="noticeNum" value="${noticeNum}">
				</div>	        	
	        	<div style="margin-left: 20px; margin-top: -10px;">
	        		<p style="font-size: 20px; border: 1px solid #cccccc; width: 220px;"><input type="text" name="keyword" class="boxTF" style="width: 170px; height: 35px; border: none; font-size: 15px; padding-left: 10px;">&nbsp;
	        				<button type=button onclick="searchList()" style="border: none; background: transparent;"><i class="fas fa-search"></i></button></p>
	        	</div>  
        	</form> 
        </div>
        
        <div class="board-body" style="width: 58%; float: left;" > 
			<div class="body-title" style="margin-top: 20px; margin-bottom: 15px;">
				 <h3 style="font-size: 18px;">| 전체 공지사항
          		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		  
          		  <button type="button" style="border: none; background: transparent;" onclick="javascript:location.href='<%=cp%>/notice/list';"><i class="fas fa-redo-alt"></i></button>
          		  </h3>          		 
      		 </div>
      		 <div style="width: 800px;">
			
				<table class="tablesorter" style="border-collapse: collapse; border-bottom: 1px solid #cccccc;">
				  <tr align="center" style="border-bottom: 1px solid #cccccc; border-top: 1px solid #cccccc; font-size: 14px; font-weight: bold; color: #424242;"> 
				      <th width="90">번호</th>
				      <th width="400">제목</th>
				      <th width="110">작성자</th>
				      <th width="110">작성일</th>
				      <th width="90">조회수</th>
				  </tr>
				<c:forEach var="dto" items="${list}">
				  <tr align="center" style="border-bottom: 1px solid #cccccc;"> 
				      <td>${dto.listNum}</td>
				      <td align="left" style="padding-left: 10px;">
				           <a href="${articleUrl}&noticeNum=${dto.noticeNum}">${dto.title}</a>
				           <c:if test="${dto.gap < 24}">
			               	<img src="<%=cp%>/resource/images/new.png">
			          	   </c:if>
				      </td>
				      <td>${dto.name}&nbsp;${dto.pType }</td>
				      <td>${dto.created}</td>
				      <td>${dto.hitCount}</td>
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
		<div class="board-body" style="width: 22%; float: left; padding-top: 30px" > 
				<img src="<%=cp %>/resource/images/office.png" width=350" height="650">
		</div>       
    </div>
</div>

