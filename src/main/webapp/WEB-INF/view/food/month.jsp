<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>
<link rel="stylesheet" href="<%=cp%>/resource/css/tabs.css" type="text/css">
<style>
/*왼쪽메뉴리스트*/
<%-- .leftMenu{
	background-size: 180px 220px;

	width:180px;
	height:220px; 
	background-image: url("<%=cp%>/resource/images/menu.png");
	
} --%>

.ui-dialog-title {
	padding-left: 17px;
	text-align: center;
	border-bottom: 1px solid ;
	font-weight: bold;
	font-size: 18px;
	color: #2E2E2E;
}

</style>
<script type="text/javascript">

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

$(function(){
	$("#tab-month").addClass("active");
});

$(function(){
	var today="${today}";
	$("#largeCalendar .textDate").each(function (i) {
        var s=$(this).attr("data-date");
        if(s==today) {
	        $(this).parent().css("background", "#E6E0F8"); 
        /*    $(this).parent().css("border-bottom", "1px solid #D0A9F5");  */
        /* 	$(this).parent().css("border-radius", "4px"); */
        }
    });
});


function changeDate(year, month) {
	var url="<%=cp%>/food/month?year="+year+"&month="+month;
	location.href=url;
}

// 스케쥴 등록 -----------------------
// 등록 대화상자 출력
<c:if test="${sessionScope.employee.empNo=='10001'}">

$(function(){
	$(".textDate").click(function(){
		// 폼 reset
		$("form[name=foodForm]").each(function(){
			this.reset();
		});
		
		var date=$(this).attr("data-date");
		date=date.substr(0,4)+"-"+date.substr(4,2)+"-"+date.substr(6,2);

		$("form[name=foodForm] input[name=created]").val(date);
		
		$("#form-created").datepicker({showMonthAfterYear:true});
		
		$("#form-created").datepicker("option", "defaultDate", date);
		
		$('#food-dialog').dialog({
			  modal: true,
			  height: 500,
			  width: 500,
			  title: '식단등록',
			  close: function(event, ui) {
			  }
		});

	});
});

// 등록
$(function(){
	$("#btnFoodSendOk").click(function(){

		if(! check()) {
			return false;
		}
		
		var query=$("form[name=foodForm]").serialize();
		var url="<%=cp%>/food/insert";
		
		$.ajax({
			type:"post"
			,url:url
			,data:query
			,dataType:"json"
			,success:function(data) {
				var state=data.state;
				if(state=="true") {
					var dd=$("#form-created").val().split("-");
					var y=dd[0];
					var m=dd[1];
					if(m.substr(0,1)=="0") 	m=m.substr(1,1);
					location.href="<%=cp%>/food/month?year="+y+"&month="+m;
				}
			}
			,beforeSend : function(jqXHR) {
		        jqXHR.setRequestHeader("AJAX", true);
		    }
		    ,error:function(jqXHR) {
		    	if(jqXHR.status==403) {
		    		location.href="<%=cp%>/login";
		    		return;
		    	}
		    	console.log(jqXHR.responseText);
		    }
		});
		
	});
});

// 등록 대화상자 닫기
$(function(){
	$("#btnFoodSendCancel").click(function(){
		$('#food-dialog').dialog("close");
	});
});

</c:if>

// 등록내용 유효성 검사
function check() {
	if(! $("#form-subject").val()) {
		$("#form-subject").focus();
		return false;
	}

	if(! $("#form-created").val()) {
		$("#form-created").focus();
		alert("내용을 입력하세요");
		return false;
	}

	return true;
}

 $(function(){			
	 $(".foodSubject:contains('DINNER')").css("color", "#632A7E");
	 $(".foodSubject:contains('LUNCH')").css("color", "#975A97");
	 $(".foodSubject:contains('SNACK')").css("color", "#A13297");
	 
/* 	 $(".foodSubject:contains('DINNER')").css("border-left", "1.5px solid #632A7E");
	 $(".foodSubject:contains('LUNCH')").css("border-left", "1.5px solid #9153B2");
	 $(".foodSubject:contains('SNACK')").css("border-left", "1.5px solid #9879A9"); */
	
}); 


// 스케쥴 제목 클릭 -----------------------

$(function(){
	$(".foodSubject").click(function(){
		var selectDate = $(this).attr("data-date");
		var date=selectDate;
		date=date.substr(0,4)+"년 "+date.substr(4,2)+"월 "+date.substr(6,2);
		$('#food-detail').dialog({
			  modal: true,
			  height: 550,
			  width: 450,
			  title: date+'일 식단',
			  resizable: false,
			  
			  close: function(event, ui) {
			  },
			  open:function(){
					$(this).parents(".ui-dialog:first").find(".ui-dialog-titlebar-close").remove();	// x버튼 바꿨음
					
					var url="<%=cp%>/food/listDate?selectDate="+selectDate;
					$("#food-detail").load(url);
					
				},
				buttons:{		//버튼추가!
					"확인":function(){
						$(this).dialog("close");
					}
				}
		});		
	});

});

//식단상자 닫기
$(function(){
	$("#btnFoodDetail").click(function(){
		$('#food-detail').dialog("close");
	});
});


function deleteOk(num) {
	if(confirm("일정을 삭제 하시 겠습니까 ? ")) {
		var url="<%=cp%>/food/delete?foodNum="+num;
		location.href=url;
	}
}


</script>
<div class="container">	
	<div class="board-container" style="margin-left: 200px;">
	  	<div class="body-title" style="margin-bottom: 15px; margin-left: 40px;" align="left">
       		 <p style="font-size: 22px; font-weight: bold; padding-top: 10px;"><i class="fas fa-utensils"></i>&nbsp;&nbsp;월간 식단표 </p>
   		 </div>  
	    
    	<div class="board-body " style="float: left; width: 20%;">	     
    	 
	       	  <div style="margin: 70px 0 0 20px; ">
              <table class="todayMenu">     
               <!--   <tr>
                    <td class="titleBtn" >                                           
                       <button type="button" class="titleBtn" disabled="disabled"; ></button>
                       <i  class="fas fa-utensils"></i>
                       
                    </td>                 
                 </tr> -->
                 
                 <tr>
                    <td style="text-align: center;">
                       <p>&nbsp;</p>
                       <p style="font-size: 20px; font-weight: 700; color: #545454; "><i class="fas fa-concierge-bell"></i> &nbsp;오늘의 메뉴</p>   
                       <p>&nbsp;</p>
                       <p>${todayYear}년 ${todayMonth}월  ${todayDate}일 </p>
                    </td>
                 </tr>
              </table>
              
              <c:if test="${list.size()==0}">
            <table class="leftMenu" style="margin-top: 50px">
               <tr height="35" style="border:1px solid MISTYROSE; background: transparent;">
                  <td align="center">등록된 식단이 없습니다.</td>
               </tr>
            </table>
            </c:if>
            
            <div class="leftMenuDIV">
	            <c:forEach var="dto" items="${list}">
	            <table class="leftMenu">
	               <tr height="35">
	                  <td style="text-align: left;  padding-left: 20px;  padding-bottom: 5px; ">
	                     <p style="font-size:18px; font-weight: 700;">
	                     <c:choose>
	                         <c:when test="${dto.subject=='LUNCH'}"><i class="fas fa-utensil-spoon"></i>&nbsp;&nbsp;점심</c:when>
	                         <c:when test="${dto.subject=='DINNER'}"><i class="fas fa-utensil-spoon"></i>&nbsp;&nbsp;저녁</c:when>
	                      <c:otherwise><i class="fas fa-cookie-bite"></i>&nbsp;&nbsp;간식</c:otherwise>
	                      </c:choose>
	                      
	                     </p>
	                  </td>
	               </tr>
	               <tr>
	                  <td style="text-align: ; margin-top: 5px;">
	                     <p style="text-align: ; padding-bottom: 10px; padding-left: 45px ">
	                        <span style="font-size: 15px;">${dto.content}</span>
	                     </p>
	                  </td>
	               </tr>
	            </table>
	            </c:forEach>   
			</div>
           </div>                    
        </div> 

		   <div id="tab-content" style="padding-bottom:20px; float: left; margin-left: 100px;"> 		   
		   		<table style="width: 840px; margin:0px auto; border-spacing: 0;" >
		   			<tr height="60">
		   			     <td width="200">&nbsp;</td>
		   			     <td align="center">
		   			         <span class="btnDate" onclick="changeDate(${todayYear}, ${todayMonth});">오늘</span>
		   			         <span class="btnDate" onclick="changeDate(${year}, ${month-1});">＜</span>
		   			         <span class="titleDate">${year}년 ${month}월</span>
		   			         <span class="btnDate" onclick="changeDate(${year}, ${month+1});">＞</span>
		   			     </td>
		   			     <td width="200">&nbsp;</td>
		   			</tr>
		   		</table>
		   		
			    <table id="largeCalendar" style="width: 900px; margin:10px auto; font-weight: 700" >
					<tr align="center" height="27" bgcolor="#ffffff">
						<td width="120" style="color:#F5A9A9; background: #F2F2F2;">일</td>
						<td width="120" style="background: #F2F2F2;">월</td>
						<td width="120" style="background: #F2F2F2;">화</td>
						<td width="120" style="background: #F2F2F2;">수</td>
						<td width="120" style="background: #F2F2F2;">목</td>
						<td width="120" style="background: #F2F2F2;">금</td>
						<td width="120" style="color:#A9A9F5; background: #F2F2F2;">토</td>
					</tr>

				<c:forEach var="row" items="${days}" >
						<tr align="center" height="130" valign="top">
							<c:forEach var="d" items="${row}">
								<td style="padding: 5px; box-sizing:border-box;">
									${d}
								</td>
							</c:forEach>
						</tr>
				</c:forEach>
			    </table>		   
		   </div>

    </div>


   <div id="food-dialog" class="modal" style="display: none;">
		<form name="foodForm">
			<table style="width: 100%; margin: 20px auto 0px; border-spacing: 0px; border-collapse: collapse;">
			  <tr>
				  <td width="90" valign="middle" style="text-align: center;">
			            <label style="font-weight: 900;">분류</label>
			      </td>
			      <td valign="middle" >
			        <p>
			            <select name="subject" id="form-subject" class="selectField">
			              <option class="titleOPT" value="LUNCH">점심</option>
			              <option class="titleOPT" value="DINNER">저녁</option>
			              <option class="titleOPT" value="SNACK">간식</option>
			          </select>
			        </p>			        
			      </td>
			  </tr>
			  		<tr>
			  		<td colspan="2">&nbsp;</td>
					</tr>	
			  
			
			  <tr>
			      <td width="90" valign="middle" style="text-align: center;">
			            <label style="font-weight: 900;">날짜</label>
			      </td>
			      <td valign="middle" >
			        <p>
			            <input type="text" name="created" id="form-created" maxlength="10" class="boxTF" readonly="readonly" style="width: 100px; height:25px; background: ghostwhite; padding-left: 3px;">
  			        </p>
			      </td>
			  </tr>
					<tr>
			  		<td colspan="2">&nbsp;</td>
					</tr>	
			  
			  <tr>
			      <td width="90" valign="top" style="text-align: center;">
			            <label style="font-weight: 900;">내용</label>
			      </td>
			      <td style="padding-bottom: 15px;">
			        <p style="margin-top: 1px; margin-bottom: 5px;">
			            <textarea name="content" id="form-content" class="boxTA" style=""></textarea>
			        </p>
			      </td>
			  </tr>
			  
			  <tr height="45">
			      <td align="center" colspan="2">
			        <button type="button" class="foodBtn" id="btnFoodSendOk">식단등록</button>
			        <button type="reset" class="foodBtn">다시입력</button>
			        <button type="button" class="foodBtn" id="btnFoodSendCancel">등록취소</button>
			      </td>
			  </tr>
			</table>
		</form>
    </div>
    
    
    <div id="food-detail"></div>
		
</div>    