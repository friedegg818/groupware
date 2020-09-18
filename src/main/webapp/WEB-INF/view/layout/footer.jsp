<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String cp = request.getContextPath();
%>

<style>

.ui-dialog-title {
	font-size: 15px;
	font-family: NanumSquareRound;
}


</style>

<script type="text/javascript">
$(function(){
	$(document)
	   .ajaxStart(function(){ // AJAX 시작시
		   $("#loadingImage").center();
		   $("#loadingLayout").fadeTo("slow", 0.5);
	   })
	   .ajaxComplete(function(){ // AJAX 종료시
		   $("#loadingLayout").hide();
	   });
});
</script>

<script type="text/javascript">

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


$(function(){
	function ajaxJSON(url, type, query, fn) {
		$.ajax({
			type:type
			,url:url
			,data:query
			,dataType:"json"
			,success:function(data) {
				fn(data);
			}
			,beforeSend:function(jqXHR) {
		        jqXHR.setRequestHeader("AJAX", true);
		    }
		    ,error:function(jqXHR) {
		    	if(jqXHR.status==403) {
		    		login();
		    		return false;
		    	}
		    	console.log(jqXHR.responseText);
		    }
		});
	}
	
	
	function listDept() {
		var url="<%=cp%>/employee/listDept";
		var query="";
		
		var fn = function(data){
			printDept(data);
		};
		
		ajaxJSON(url, "get", query, fn);		
	}
	
	function printDept(data) {
	
		var uid="${sessionScope.employee.empNo}";		
		
		var out="";
		for(var idx=0; idx<data.length; idx++) {
			var dType=data[idx];
			
			out+="<tr ><td class='fp-dept'>";
			out+="<span class='dept-icon fp-dept-more' data-dept='"+dType+"'><i class='fas fa-caret-down'></i>&nbsp;"+dType+"</span>";
			out+="<span class='dept-icon fp-dept-less' style='display:none'><i class='fas fa-caret-up'></i>&nbsp;"+dType+"</span></td></tr>";
			out+="<tr style='display:none;'><td class='fp-person'></td></tr>";
		}
		
		$("#listPerson").append(out);
	}
	
	listDept();
	
	$("body").on("click", ".dept-icon",function(){
		  var obj = $(this);
		  var $td = $(this).closest("tr").next("tr").children("td");
		  if( obj.hasClass("fp-dept-more") ){
		    obj.hide();
		    obj.next().show();            
		    obj.parent().parent().next().show();
		    
		    $td.empty();
		    
		    var dept = obj.attr("data-dept");
		    
		    var url="<%=cp%>/employee/listOrg";
			var query="dept="+dept;
			
			var fn = function(data){
				printOrg(data, $td);
			};
			
			ajaxJSON(url, "post", query, fn);
		    
 
		  }else{
		     obj.hide();
		     obj.prev().show();
		     obj.parent().parent().next().hide();
		  }
	});	
	
	function printOrg(data,obj) {
		var uid="${sessionScope.employee.empNo}";

		var out="";
		for(var idx=0; idx<data.listOrg.length; idx++) {
			var dType=data.listOrg[idx].dType;
			var name=data.listOrg[idx].name;
			var pType=data.listOrg[idx].pType;
			var image=data.listOrg[idx].imageFilename;
			var empNo=data.listOrg[idx].empNo
			var clockIn=data.listOrg[idx].clockIn;
			var clockOut=data.listOrg[idx].clockOut;
			
			out+=" <p>";
			if(clockIn!=null && (clockOut==null)){
				out+=" <i class='fas fa-circle' style='font-size: 8px; color:LIME;' ></i>";	
			}else{
				out+=" <i class='fas fa-circle' style='font-size: 8px; color:lightgray;'></i>";				
			}
			out+=" &nbsp;&nbsp;&nbsp;";
			out+=" <img src='<%=cp%>/uploads/profile/"+image+"' style='width: 30px; height: 30px; border-radius: 15px; vertical-align:middle;'>&nbsp;"+pType+"&nbsp;|&nbsp;"+name+"&nbsp;";
			out+=" <a class='chatInput' <%-- href=' --%>'><span><i class='fas fa-comments'></i></span></a>";
			out+=" <a class='messageInput' <%-- href='<%=cp%>/buddy/created --%>'><span><i class='fas fa-envelope'></i></span></a>";
			out+=" <a class='information' data-empNo='"+empNo+"' data-name='"+name+"'><input type='hidden' value='"+empNo+"'><span><i class='fas fa-info-circle'></i></span></a></p>";							
		}		
		obj.html(out);	
	}
	
	
});

<%-- 		//===========
$(function(){
	$("body").on("click", ".information",function(){
		var selectEmp = $(this).attr("data-empNo");
		var selectName =$(this).attr("data-name");
		var dlg = $("#person-detail").dialog({
				  autoOpen: false,
				  modal: true,
				  buttons: {
				       " 닫기 " : function() {
				    	   $(this).dialog("close");
				        }
				  },
				  height: 480,
				  width: 550,
				  title: "사원정보",
				  close: function(event, ui) {
				  }
			});	
		$('.information').load("<%=cp%>/publicAddr/main", function() {
			$("#schedulerTitle").html(name);
			$("#schedulerName").html(name);
			$("#schedulerCategory").html();
			$("#schedulerAllDay").html();

			
			dlg.dialog("open");
		});
		
	});
});	
		//=============== --%>

$(function(){
	$(".footer-icon").click(function(){
		$(".footer-detail").toggle(100);
	});

});

$(function(){
	$(".header1").on("click",function(){
		$(".footer-profileTB").css("display", "inline-block");
		$(".footer-chatTB").css("display", "none");
		$(".footer-messageTB").css("display", "none");
	});
	
	/* $(".header2").on("click",function(){
		$(".footer-profileTB").css("display", "none");
		$(".footer-chatTB").css("display", "inline-block");
		$(".footer-messageTB").css("display", "none");
	});
	
	$(".header3").on("click",function(){
		$(".footer-profileTB").css("display", "none");
		$(".footer-chatTB").css("display", "none");
		$(".footer-messageTB").css("display", "inline-block");
	}); */
});


$("body").on("click", ".information", function(){
	
	var data = $(this).find("input[type=hidden]").val();
	
	$("#testbox").dialog({
		modal : true,
		width : 300,
		height : 390,
		title : "미니 프로필",
		position : {my:"center top", at:"center top"},
		show : "fade",
		resizable : false,
		open : function(){

			$(".ui-draggable .ui-dialog-titlebar").css("background", "white");
			$(".ui-draggable .ui-dialog-titlebar").css("border", "white");
			
			var url = "<%=cp%>/main/profile"
			
			var query = "empNo=" + data;
			
			ajaxHTML(url, "GET", query, ".showProfile");
			
		},close : function(){
			
		}
	});
	 
	
});


</script>

<!-- 프로필 modal -->
<div id="testbox" style="display: none;">
	<div class="showProfile"></div>
</div>



<div class="footer">
	<div class="footer-detail"style="">
		<div class="footer-detail-top">
				
			<div id="footericon" style="text-align: center; line-height: 60px;">
				<a class="fixedIcon header1"><span><i class="fas fa-user"></i></span></a>
				<a class="fixedIcon header2" href="<%=cp%>/chat/main"><span><i class="fas fa-comments"></i></span></a>
				<a class="fixedIcon header3" href="<%=cp%>/buddy/created"><span><i class="fas fa-envelope"></i></span></a>
			</div>
		
			<div class="footer-detail-content" style="width: 300px; height: 350px; text-align: left; overflow: auto ">
				<div class="footer-profile" style="width: 300px; height: 340px; overflow: auto; display: inline-block; ">				
					<table class="footer-profileTB" style="/* display: none; */">
		  					<tbody  id="listPerson" ></tbody>
						<%-- <tr >
		   					<td class="fp-dept">
		   						<span class="dept-icon fp-dept-more "><i class="fas fa-caret-down"></i>${dto.dType}</span>
		         				<span class="dept-icon fp-dept-less " style="display:none"><i class="fas fa-caret-up"></i>${dto.dType}</span> 
		         			</td>
		  				</tr> --%>
		    				<%-- <td  class="fp-person" >
		    					<p> <i class="fas fa-circle" style="font-size: 8px"></i>&nbsp;&nbsp;&nbsp;
		    						<i class="fas fa-user-circle"></i>${dto.pType} | ${dto.name}
		    						<a class="chatInput"><span><i class="fas fa-comments"></i></span></a>
		    						<a class="messageInput"><span><i class="fas fa-paper-plane"></i></span></a>
		    						<a class="information"><span><i class="fas fa-info-circle"></i></span></a>			
		    					</p>
		    				</td> --%>
					</table>														
				</div>	
				
				
				<div class="footer-chat">
					<p class="footer-chatTB chat-title" style="display: none;">대화하하하하</p>
					<table class="footer-chatTB" style="border-bottom: 1px solid red; width: 280px; margin-left: 10px; padding: 10px;  " >
						<tr>
							<td rowspan="2"><i style="font-size: 35px;" class="fas fa-user-circle"></i></td>
							<td><p>홍보부 김수현 사원</p></td>
						</tr>
						<tr>							
							<td style="color:red"><p>대화내용이요~~</p></td>
						</tr>
					</table>
				</div>
				
				<div class="footer-message">
					<p class="footer-messageTB msg-title" >받은쪽지함</p>
					<table class="footer-messageTB" style="border-bottom: 1px solid red; width: 280px; margin-left: 10px; padding: 10px; " >
						<tr>
							<td rowspan="2"><i style="font-size: 35px;" class="fas fa-user-circle"></i></td>
							<td><p>홍보부 김수현 사원</p></td>
						</tr>
						<tr>							
							<td style="color:plum"><p>쪽지요~~~</p></td>
						</tr>
					</table>
				</div>
			</div>			
			
		</div>
		
	</div>
	
	
	<div class="footer-icon">
		<a><i class="fas fa-sitemap"></i></a>
	</div>
	
<!-- 	
	 <div id="person-detail" style="display: none;" ></div>
	 -->
	
	
</div>