<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>


<link rel="stylesheet" href="<%=cp%>/resource/css/community.css" type="text/css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.0.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-modal/0.9.1/jquery.modal.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-modal/0.9.1/jquery.modal.min.css" />
<script type="text/javascript">
	function searchList() {
		var f=document.searchForm;
		f.submit();
	}
	
	   function sendOk2() {
	        var f = document.clubForm;

	    	var str = f.clubCode.value;
	        if(!str) {
	            alert("동호회 코드를 입력하세요. ");
	            f.title.focus();
	            return false;
	        }

	    	str = f.clubType.value;
	        if(!str) {
	            alert("동호회 이름을 입력하세요. ");
	            f.content.focus();
	            return false;
	        }

	    	f.action="<%=cp%>/community/clubMake";
			
	    	return true;
	    }	
</script>

<div class="container">
    <div class="board-container" style="margin-left: 200px;">
        <div class="body-title" style="font-size: 18px;">
            <h3><i class="fas fa-satellite-dish"></i>&nbsp;&nbsp;커뮤니티 </h3>
        </div>   

        <div class="board-body" style="float: left; width: 20%;">	      
	        	<div style="margin-top: 20px; margin-left: 20px;">
	        		<button type="button" style="width: 110px; height: 50px; background: #9565A4; color: white; font-size: 25px; border: none; border-radius: 10px;" onclick="javascript:location.href='<%=cp%>/community/created';"><i class="fas fa-marker"></i></button>
	        		<button type="button" class="modalbtn" style="width: 110px; height: 50px; background: #9565A4; color: white; font-size: 23px; border: none; border-radius: 10px;"><a class="btn" href="#ex7"><i class="fas fa-user-friends"></i>&nbsp;<i class="fas fa-plus-circle"></i></a></button>
	        	</div> 
	     
            <form name="searchForm" action="" method="post">
        	<div class="selectGroup">
        		  <select class="selectBox" name="condition" class="selectField">			              
		          	  <option value="title" ${condition=="title"?"selected='selected'":""}>제목</option>
		          	  <option value="clubType" ${condition=="clubType"?"selected='selected'":""}>동호회명</option>
		           	  <option value="name" ${condition=="name"?"selected='selected'":""}>작성자</option>
		           	  <option value="created" ${condition=="created"?"selected='selected'":""}>등록일</option>
			      </select>        
        	</div>
        	<div style="margin-left: 20px; margin-top: -10px;">
        		<p style="font-size: 20px; border: 1px solid #cccccc; width: 220px; background: white;"><input type="text" name="keyword" class="boxTF" style="width: 170px; height: 35px; border: none; font-size: 15px; padding-left: 10px;">&nbsp;
        				<button type=button onclick="searchList()" style="border: none; background: white;"><i class="fas fa-search"></i></button></p>
        	</div>   
        	       
        	</form>
        </div>
        
        
        
        <div class="board-body" style="width: 45%; float: left;" >        
        	  <div class="body-title" style="margin-top: 20px; margin-bottom: 15px;">
          		  <h3 style="font-size: 18px;">| 최신글
          		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		  <button type="button" style="border: none; background: transparent;" onclick="javascript:location.href='<%=cp%>/community/list';"><i class="fas fa-redo-alt"></i></button>
          		  </h3>          		 
      		  </div> 	      		        	  	
      		        		
			<c:forEach var="dto" items="${list}">
				<table style="border-collapse: collapse; margin-bottom: 20px; width: 100%; border-bottom: 1px solid #cccccc; border-top: 1px solid #cccccc; background: white;">		 
					  <tr align="left"> 		
					      <td width="80%;" style="color: gray; font-weight: bold; font-size: 14px;">&nbsp;&nbsp;[${dto.clubType}]</td>
						    <c:if test="${dto.commuLikeCount==0}">	
						      <td rowspan="2" style="font-size: 30px; text-align: center; padding-left: 10px; padding-top: 10px; color: #BDBDBD;"> 
						      		<i class="fas fa-heart"><span style="font-size: 15px; font-weight: bold;"> ${dto.commuLikeCount} </span></i> 
						      		<c:if test="${dto.replyCount==0}">
						     			<i class="fas fa-comment-alt" style="color: #BDBDBD;"><span style="font-size: 15px; font-weight: bold; color: #BDBDBD;"> ${dto.replyCount} </span></i>
						     		</c:if>
						     		<c:if test="${dto.replyCount!=0}">
						     			<i class="fas fa-comment-alt" style="color: #FFBF00;"><span style="font-size: 15px; font-weight: bold; color: #FFBF00;"> ${dto.replyCount} </span></i>
						     		</c:if>	
						      </td>			   
						  	</c:if>
						  	<c:if test="${dto.commuLikeCount!=0}">	
						      <td rowspan="2" style="font-size: 30px; text-align: center; padding-left: 10px; padding-top: 10px; color: #632A7E;"> 
						      		<i class="fas fa-heart"></i><span style="font-size: 15px; font-weight: bold;"> ${dto.commuLikeCount} </span> 
						      		<c:if test="${dto.replyCount==0}">
						     			<i class="fas fa-comment-alt" style="color: #BDBDBD;"><span style="font-size: 15px; font-weight: bold; color: #BDBDBD;"> ${dto.replyCount} </span></i>
						     		</c:if>
						     		<c:if test="${dto.replyCount!=0}">
						     			<i class="fas fa-comment-alt" style="color: #FFBF00;"><span style="font-size: 15px; font-weight: bold; color: #FFBF00;"> ${dto.replyCount} </span></i>
						     		</c:if>						     		
						      </td>			   
						  	</c:if>					  	
					  </tr>
					  <tr align="left">
					      <td align="left" style="padding-left: 10px; font-weight: bold; font-size: 16px;">					       
					         		<a class="btn"  style=" color: #041910;"  href="#smallarticle">${dto.title}</a>
						         		<input type="hidden" class="hcommuNum" value="${dto.commuNum}">
						         		<span id="hcontent${dto.commuNum}" style="display: none;">${dto.content}</span>
						         		<input type="hidden" class="hreplyCount" value="${dto.replyCount}">
						         		<input type="hidden" class="hname" value="[${dto.dType}]&nbsp;${dto.name}&nbsp;${dto.pType}">
 					            <c:if test="${dto.gap < 1}">
		             	  			<img src='<%=cp%>/resource/images/new.png'>
		        	  		    </c:if>
				          </td>					          	      
				      </tr>
				      <tr align="left">
					      <td style="color: #5a5a5a;">&nbsp;&nbsp;[${dto.dType}]&nbsp;${dto.name}&nbsp;${dto.pType}</td>	
					      <td style="color: #5a5a5a; text-align: center;">${dto.created}</td>	
					  </tr>
				</table>
			 </c:forEach>
			 
			<table style="margin: 10px 0 0 100px; width: 50%;">
			   <tr>
             	  <td colspan="8" id="list-paging">${dataCount == 0 ? "등록된 글이 없습니다." : paging}</td>
			   </tr>
			</table>				
        </div>   
        
        
        
        
        <div class="board-body" style="width: 30%; float: left; margin-left: 60px;"> 
        	<div class="body-title" style="margin-top: 20px; margin-bottom: 15px;">
          		  <h3 style="font-size: 18px;">| 커뮤니티 정보</h3>           
          		  <table class="clubTableList" style="margin-top: 15px; margin-bottom: 5px; width: 100%; border: 1px solid #cccccc; border-bottom: none; background: white;">		 
          		  <c:forEach var="dto" items="${listClub}">          		  	  
					  <tr align="left"> 		
					      <td style="font-weight: bold; font-size: 16px; padding-left: 10px;">
					      <c:if test="${dto.clubType == '홀인원'}"> <i class="fas fa-golf-ball"></i> </c:if> 
					      <c:if test="${dto.clubType == '스트라이크'}"> <i class="fas fa-bowling-ball"></i> </c:if> 
					      <c:if test="${dto.clubType == '샬라샬라'}"> <i class="fas fa-sort-alpha-up"></i> </c:if> 
					      <c:if test="${dto.clubType == '보드게임'}"> <i class="fas fa-gamepad"></i> </c:if> 					      
					      <c:if test="${dto.clubType == '냥냥펀치'}"> <i class="fas fa-paw"></i> </c:if>
					      <c:if test="${dto.clubNew == 'NEW'}"> <i class="fas fa-smile-wink"></i> </c:if>
					     <a href="javascript:location.href='<%=cp%>/community/list?condition=clubType&keyword=${dto.clubType}'"> ${dto.clubType} </a> </td>					     			      				   
					  </tr>					 
					  <tr align="left">
					  	 <td style="padding-left: 12px; color: #505050; border-bottom: 1px solid #cccccc;"> <i class="fas fa-arrow-right"></i>  ${dto.clubExp} [ <i class="fas fa-clock"></i> 개설일 : ${dto.clubMake} ] </td>
					 </tr>								
          		  </c:forEach>
				</table>  		 
      	    </div> 
        </div>  
		
		
		
		
		<!-- 모달창 -->
		<div id="ex7" class="modal">
			<p> &nbsp; </p>	
			<p><i class="fas fa-cube" style="font-size: 22px;"></i> 새 커뮤니티 만들기 </p>		
			<div class="board-created">
			<form name="clubForm" method="post">
			  <table class="boardtable" style="margin: 20px auto 0px; ">
			  <tbody id="tb">
				  <tr align="left" height="40"> 
				      <td width="100" style="text-align: center; background: #6E3C89;">동호회 코드</td>
				      <td style="padding-left:10px;"> 
				          <input class="clubinput" type="text" name="clubCode" maxlength="100" style="width: 300px;">
				      </td>
				  </tr>
				  
				  <tr align="left" height="50" > 
				      <td width="100" bgcolor="#eeeeee" style="text-align: center; background:#6E3C89;">동호회명</td>
				      <td style="padding-left:10px;"> 
				        <input class="clubinput" type="text" name="clubType" maxlength="100" style="width: 300px;">
				      </td>
				  </tr>		
				  
				   <tr align="left" height="50" > 
				      <td width="100" bgcolor="#eeeeee" style="text-align: center; background:#6E3C89;">간단한 설명</td>
				      <td style="padding-left:10px;"> 
				        <input class="clubinput" type="text" name="clubExp" maxlength="100" style="width: 300px;">
				      </td>
				  </tr>			  
             	 </tbody>              
			  </table>			  
			
			  <table style="width: 450px; margin-top: 10px;">
			     <tr height="45"> 
			      <td align="center" >
			        <button type="submit" class="clubBtn" onclick="sendOk2()">커뮤니티 만들기</button>
			        <button type="reset" class="clubBtn">다시입력</button>
			        <button type="button" class="clubBtn" onclick="javascript:location.href='<%=cp%>/community/list';">취소</button>
			     </td>
			    </tr>
			  </table>
			</form>
        </div>
		</div>
		
		
		<div id="smallarticle" class="modal">
			<h2> <i class="fab fa-readme"></i>  글 미리보기 </h2>	
			
			<table style="width: 100%; height: 600px; margin-top: 20px; margin-bottom: 20px; border-collapse: collapse;">
				<tr style="height: 12%; background: #6E3C89; color: white; border: 1px solid #cccccc;">
					<td id="mtitle" style="padding-left: 10px; font-size: 21px; font-weight: bold;"> 제목 </td>
				</tr>
				<tr style="height: 10%; background: white; color: #505050; font-size: 13px; border: 1px solid #cccccc;">
					<td id="mname" style="padding-left: 10px; border-bottom: 1px solid #cccccc;"> 작성자 </td>
				</tr>
				<tr style="font-size: 15px; color: #505050; border: 1px solid #cccccc;" valign="top">
					<td  style="padding-left:10px; text-align: left; "><div id="mcontent" style="white-space: pre; padding-top: 15px;">내용</div> </td>
				</tr>	
			</table>
			
			<p style="text-align: right; color: #505050;"><a id="articleurl"> <i class="far fa-hand-point-right"></i> 자세히 보기 </a></p>
			
		</div>
		
	   
    </div>
</div>




<script>
    $('a[href="#ex7"]').click(function(event) {
      event.preventDefault();  
		 
    $(this).modal({
     fadeDuration: 250
	  });
  });
</script>    

<script>	
    $('a[href="#smallarticle"]').click(function(event) {
      event.preventDefault();  
      
      var app = $(this).closest("td").find("input[type=hidden]").val();
      var title = $(this).text();
      var name = "&nbsp;작성자 | " + $(this).closest("td").find("input[class=hname]").val();   
      var commuNum = $(this).closest("td").find("input[class=hcommuNum]").val();
      var content = $("#hcontent"+commuNum).html(); 
      
      $("#mtitle").html(title);
      $("#mcontent").html(content);      
      $("#mname").html(name);  
      $("#articleurl").attr("href", "${articleUrl}&commuNum="+commuNum);
      
    $(this).modal({
    	fadeDuration: 250    
	  });
  });
</script>  
  
