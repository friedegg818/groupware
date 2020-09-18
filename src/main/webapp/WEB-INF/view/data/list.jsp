<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>

<script type="text/javascript" src="<%=cp%>/resource/jquery/js/jquery.tablesorter.min.js"></script>
<link rel="stylesheet" href="<%=cp%>/resource/css/data.css" type="text/css">

<script type="text/javascript">
	function searchList() {
		var f=document.searchForm;
		f.submit();
	}
</script>

<script type="text/javascript">
  $(document).ready(function() {
    $("#dataTable").tablesorter();
  });
</script>

<script type="text/javascript">
$(function() {
	$("#chkAll").click(function() {
		if($(this).is(":checked")) {
			$("input[name=dataNums]").prop("checked", true);
		} else {
			$("input[name=dataNums]").prop("checked", false);
		}
	});
	
	$("#btnDeleteList").click(function(){
		var cnt = $("input[name=dataNums]:checked").length;
		
		if(cnt == 0) {
			alert("삭제 할 자료를 선택 하세요.");
			return false;
		}
		
		if(confirm("선택한 자료를 삭제 하시겠습니까?")) {
			var f = document.dataListForm;
			f.action = "<%=cp%>/data/deleteList";
			f.submit();
		}
	});
});
</script>



<div class="container">
    <div class="board-container" style="margin-left: 200px;">
        <div class="board-title" style="font-size: 18px;">
            <h3><i class="fas fa-cloud-download-alt"></i>&nbsp;&nbsp;자료실 </h3>
        </div>
        
        <div class="board-body" style="float: left; width: 20%;">
			<div style="margin-top: 20px; margin-left: 20px;">
	        		<button type="button" style="width: 220px; height: 50px; background: #9565A4; color: white; font-size: 25px; border: none; border-radius: 10px;" onclick="javascript:location.href='<%=cp%>/data/created';"><i class="fas fa-upload"></i> </button>
	       	</div>	
	       	
	       	<div style="margin-top: 10px; margin-left: 20px; margin-bottom: 5px;">	 
	       	   <p style="font-size: 14px; font-weight: bold;"> 총 사용 용량 </p> 
	       	   
	       	   	<c:if test="${totalFile/(1024*1024) == 0}">   
		       	   <table style="width: 1px;  margin-top: 7px; margin-bottom: 3px; border:1px solid #632A7E; border-radius: 4px;">
		       	   		<tr style="height: 20px;">
		       	   			<td style="background: #632A7E;"></td>
		       	   		</tr>
		       	   </table> 
		       	 </c:if> 
	       	   
		       	 <c:if test="${0 < totalFile/(1024*1024) && totalFile/(1024*1024) <= 1}">   
		       	   <table style="width: 22px;  margin-top: 7px; margin-bottom: 3px; border:1px solid #632A7E; border-radius: 4px;">
		       	   		<tr style="height: 20px;">
		       	   			<td style="background: #632A7E;"></td>
		       	   		</tr>
		       	   </table> 
		       	  </c:if> 	 	
		       	  
		       	  <c:if test="${1 < totalFile/(1024*1024) && totalFile/(1024*1024) <= 2}">   
		       	   <table style="width: 44px;  margin-top: 7px; margin-bottom: 3px; border:1px solid #632A7E; border-radius: 4px;">
		       	   		<tr style="height: 20px;">
		       	   			<td style="background: #632A7E;"></td>
		       	   		</tr>
		       	   </table> 
		       	  </c:if> 
		       	  
		       	  <c:if test="${2 < totalFile/(1024*1024) && totalFile/(1024*1024) <= 3}">   
		       	   <table style="width: 66px;  margin-top: 7px; margin-bottom: 3px; border:1px solid #632A7E; border-radius: 4px;">
		       	   		<tr style="height: 20px;">
		       	   			<td style="background: #632A7E;"></td>
		       	   		</tr>
		       	   </table> 
		       	  </c:if> 
		       	  
		       	    <c:if test="${3 < totalFile/(1024*1024) && totalFile/(1024*1024) <= 4}">   
		       	   <table style="width: 88px;  margin-top: 7px; margin-bottom: 3px; border:1px solid #632A7E; border-radius: 4px;">
		       	   		<tr style="height: 20px;">
		       	   			<td style="background: #632A7E;"></td>
		       	   		</tr>
		       	   </table> 
		       	  </c:if> 
		       	  
		       	    <c:if test="${4 < totalFile/(1024*1024) && totalFile/(1024*1024) <= 5}">   
		       	   <table style="width: 110px;  margin-top: 7px; margin-bottom: 3px; border:1px solid #632A7E; border-radius: 4px;">
		       	   		<tr style="height: 20px;">
		       	   			<td style="background: #632A7E;"></td>
		       	   		</tr>
		       	   </table> 
		       	  </c:if> 
		       	  
		       	    <c:if test="${5 < totalFile/(1024*1024) && totalFile/(1024*1024) <= 6}">   
		       	   <table style="width: 132px;  margin-top: 7px; margin-bottom: 3px; border:1px solid #632A7E; border-radius: 4px;">
		       	   		<tr style="height: 20px;">
		       	   			<td style="background: #632A7E;"></td>
		       	   		</tr>
		       	   </table> 
		       	  </c:if> 
		       	  
		       	    <c:if test="${6 < totalFile/(1024*1024) && totalFile/(1024*1024) <= 7}">   
		       	   <table style="width: 154px;  margin-top: 7px; margin-bottom: 3px; border:1px solid #632A7E; border-radius: 4px;">
		       	   		<tr style="height: 20px;">
		       	   			<td style="background: #632A7E;"></td>
		       	   		</tr>
		       	   </table> 
		       	  </c:if> 
		       	  
		       	    <c:if test="${7 < totalFile/(1024*1024) && totalFile/(1024*1024) <= 8}">   
		       	   <table style="width: 176px;  margin-top: 7px; margin-bottom: 3px; border:1px solid #632A7E; border-radius: 4px;">
		       	   		<tr style="height: 20px;">
		       	   			<td style="background: #632A7E;"></td>
		       	   		</tr>
		       	   </table> 
		       	  </c:if> 
		       	  
		       	    <c:if test="${8 < totalFile/(1024*1024) && totalFile/(1024*1024) <= 9}">   
		       	   <table style="width: 198px;  margin-top: 7px; margin-bottom: 3px; border:1px solid #632A7E; border-radius: 4px;">
		       	   		<tr style="height: 20px;">
		       	   			<td style="background: #632A7E;"></td>
		       	   		</tr>
		       	   </table> 
		       	  </c:if> 
		       	  
		       	    <c:if test="${9 < totalFile/(1024*1024)}">   
		       	   <table style="width: 220px;  margin-top: 7px; margin-bottom: 3px; border:1px solid #632A7E; border-radius: 4px;">
		       	   		<tr style="height: 20px;">
		       	   			<td style="background: #632A7E;"></td>
		       	   		</tr>
		       	   </table> 
		       	  </c:if> 
	    
		       <p style="text-align: right; margin-right: 60px; font-size: 13px; font-style: italic;"> <fmt:formatNumber value="${totalFile/(1024*1024)}" pattern="0.00"/> GB / 10.0GB </p>
			</div>
	       	
	       	<form name="searchForm" action="" method="post">
        	<div class="selectGroup">
        		  <select class="selectBox" name="condition" class="selectField">			              
		          	   <option value="title" ${condition=="title"?"selected='selected'":""}>제목</option>
		               <option value="dataType" ${condition=="dataType"?"selected='selected'":""}>분류</option>
		               <option value="name" ${condition=="name"?"selected='selected'":""}>작성자</option>
		               <option value="created" ${condition=="created"?"selected='selected'":""}>등록일</option>
			      </select>        
        	</div>
        	<div style="margin-left: 20px; margin-top: -10px;">
        		<p style="font-size: 20px; border: 1px solid #cccccc; width: 220px;"><input type="text" name="keyword" class="boxTF" style="width: 170px; height: 35px; border: none; font-size: 15px; padding-left: 10px;">&nbsp;
        				<button type=button onclick="searchList()" style="border: none; background: transparent;"><i class="fas fa-search"></i></button></p>
        	</div>  
        	</form>     	
	    </div>
			
			
			
			
		<div class="board-body" style="width: 58%; float: left;" > 
			<div class="body-title" style="margin-top: 20px; margin-bottom: 15px;">
          		  <h3 style="font-size: 18px;">| 전체 자료실
          		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		 
          		 <c:if test="${sessionScope.employee.rCode == 'admin'}"> 
          			  <button type="button" id="btnDeleteList" style="border:none; background: none; font-size: 20px; margin-bottom: 7px; margin-left: 5px; color: #353535;"> <i class="far fa-trash-alt"></i></button>   
          		 </c:if>
          		 <c:if test="${sessionScope.employee.rCode != 'admin'}"> 
          		 	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		 </c:if>
          		  &nbsp;
          		  <button type="button" style="border: none; background: transparent;" onclick="javascript:location.href='<%=cp%>/data/list';"><i class="fas fa-redo-alt"></i></button>
          		  </h3>          		 
      		  </div> 	
      		  
      		  
      		        	
      		<form method="post" name="dataListForm">	        
			<table id="dataTable" class="tablesorter" style="border-collapse: collapse; border-bottom: 1px solid #cccccc;  width: 810px;">
				<thead>				 
				  <tr align="center" style="border-bottom: 1px solid #cccccc; border-top: 1px solid #cccccc; font-size: 14px; font-weight: bold; color: #424242;">		
				  	  <td> <input type="checkbox" name="chkAll" id="chkAll" value="all" ></td>  				  
				      <td width="80px;">분류 <span style="font-size: 11px;"> <i class="fas fa-sort"></i> </span></td>
				      <td width="400px;">제목 <span style="font-size: 11px;"> <i class="fas fa-sort"></i> </span></td>	
				      <td>자료 크기 <span style="font-size: 11px;"> <i class="fas fa-sort"></i> </span> </td>		      
				      <td>등록 날짜 <span style="font-size: 11px;"> <i class="fas fa-sort"></i> </span> </td>			   
				     <td>다운로드</td>
				  </tr>
				</thead>
				
			 <tbody>
			 <c:forEach var="dto" items="${list}">
			  <tr align="center" style="border-bottom: 1px solid #E6E6E6;"> 
			  	  <td ><input type="checkbox" name="dataNums" value="${dto.dataNum}"></td>		      
			      <td>${dto.dataType}</td>
			      <td align="left" style="padding-left: 10px;">
			           <a href="${articleUrl}&dataNum=${dto.dataNum}">${dto.title}</a>
		        	   <c:if test="${dto.gap < 1}">		             	  
		        	   </c:if>
			      </td>			   
			      <td>
			      	<c:if test="${dto.fileCount != 0}">
			      		<fmt:formatNumber value="${dto.fileSize/(1024*1024)}" pattern="0.00"/> MB
			      	</c:if>
			      	<c:if test="${dto.fileCount == 0}">
			      		-
			      	</c:if>
			      </td>   
			      <td>${dto.created}</td>			     
			      <td>
                   <c:if test="${dto.fileCount != 0}">
                        <a href="<%=cp%>/data/zipdownload?dataNum=${dto.dataNum}"><i class="fas fa-arrow-circle-down"></i></a>
                   </c:if>		      
		     	  </td>
			  </tr>
			 </c:forEach>
			 </tbody>
			</table>			
				<input type="hidden" name="page" value="${page}">		
				<input type="hidden" name="dCode" value="${dto.dCode}">	
			</form>			
			 
			<table style="margin-top: 10px;">
			   <tr>
				 <td colspan="8" id="list-paging">${dataCount == 0 ? "등록된 자료가 없습니다." : paging}</td>
			   </tr>
			</table>
		</div>
		
		
		<div class="board-body" style="width: 22%; float: left;" > 
			<div class="body-title" style="margin-top: 20px; margin-bottom: 15px;">
          		  <h3 style="font-size: 18px;">| 부서별 자료실 </h3> 
          		  <div class="deptdata">
          		  <button id="dbtn" type="button" style="margin-top: 25px;" onclick="javascript:location.href='<%=cp%>/data/deptList?dCode=DV';"> <i class="fas fa-folder-open"></i>&nbsp;&nbsp;개발부 </button>
          		  <button id="dbtn" type="button" onclick="javascript:location.href='<%=cp%>/data/deptList?dCode=BM';"> <i class="fas fa-folder-open"></i>&nbsp;&nbsp;경영지원부 </button>   
          		  <button id="dbtn" type="button" onclick="javascript:location.href='<%=cp%>/data/deptList?dCode=PM';"> <i class="fas fa-folder-open"></i>&nbsp;&nbsp;기획부 </button>   
          		  <button id="dbtn" type="button" onclick="javascript:location.href='<%=cp%>/data/deptList?dCode=HR';"> <i class="fas fa-folder-open"></i>&nbsp;&nbsp;인사부 </button>   
          		  <button id="dbtn" type="button" onclick="javascript:location.href='<%=cp%>/data/deptList?dCode=PR';"> <i class="fas fa-folder-open"></i>&nbsp;&nbsp;홍보부 </button>       	 
				</div>
				  		 
            </div>
		</div>		
		  
    </div>
</div>
