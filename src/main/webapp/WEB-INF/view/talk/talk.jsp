<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>

<link rel="stylesheet" href="<%=cp%>/resource/css/talk.css" type="text/css">
<style>
.talk-container{
	width:800px;
	align-content: center;
	margin:30px 0 0 200px;
}
</style>

<script type="text/javascript">
var pageNo=1;
var totalPage=1;

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

$(function(){
	listPage(1);
});

function listPage(page) {
	var url="<%=cp%>/talk/list";
	var query="pageNo="+page;
	
	var fn = function(data){
		printTalk(data);
	};
	
	ajaxJSON(url, "get", query, fn);		
}

$(function(){
	$(window).scroll(function(){
		if($(window).scrollTop()+50>=$(document).height()-$(window).height()) {
			if(pageNo<totalPage) {
				++pageNo;
				listPage(pageNo);
			}
		}
	});
});



function printTalk(data) {
	var uid="${sessionScope.employee.empNo}";
	var dataCount = data.dataCount;
	pageNo=data.pageNo;
	page=data.page;
	totalPage = data.total_page;
	
	var out="";
	if(dataCount!=0) {
		for(var idx=0; idx<data.list.length; idx++) {
			var talkNum=data.list[idx].talkNum;
			var name=data.list[idx].name;
			var writer=data.list[idx].writer;
			var content=data.list[idx].content;
			var created=data.list[idx].created;
			var image=data.list[idx].imageFilename;
			var dType=data.list[idx].dType;
			var pType=data.list[idx].pType;
			
			out+="    <tr height='40'>";
			if(image!=null){
				out+="	<td style='font-size:18px; padding-top:10px'><img src='<%=cp%>/uploads/profile/"+image+"' style='width: 36px; height: 36px; margin: 0 5px 0 5px; border-radius: 18px; vertical-align:middle;'><a class='nameDropdown'>["+dType+"]&nbsp;"+name+"&nbsp;"+pType+"</a>";
				out+="	&nbsp;<i style='color:plum;' class='far fa-comment-dots'></i>&nbsp;&nbsp;"+content+"</td>";			
			} else {
				out+=" <td style='font-size:18px; line-height:35px;'><i class='far fa-user-circle' style='margin: 0 5px 0 5px ;'></i>["+dType+"]&nbsp;"+name+"&nbsp;"+pType+"<i class='far fa-comment-dots'></i>"+content+"</td>";
			}			
			out+="    </tr>";
			out+="    <tr style='height: 40px; border-bottom:1px solid #cccccc ; margin-bottom:10px' >";
			out+="      <td  align='right' style='padding-right: 5px; border-left:none; color:#ABB2B9'>" + created;
			if(uid==writer || uid=="10003") {
				out+=" | <a  class='talkBtn' onclick='deleteTalk(\""+talkNum+"\", \""+page+"\");'>삭제</a></td>" ;
			}
			out+="    </tr>";
		}
		
		$("#listTalkBody").append(out);
		
		if(! checkScrollBar()) { // checkScrollBar() 함수는 util-jquery.js 에 존재
			if(pageNo<totalPage) {
				++pageNo;
				listPage(pageNo);
			}
		}
	}
}

function sendTalk() {
	if(! $.trim($("#content").val()) ) {
		$("#content").focus();
		return;
	}
	
	var url="<%=cp%>/talk/insert";
	var query=$("form[name=talkForm]").serialize();
	
	var fn = function(data){
		$("#content").val("");
		
		$("#listTalkBody").empty();
		pageNo=1;
		listPage(1);
	};
	
	ajaxJSON(url, "post", query, fn);
}

function deleteTalk(talkNum, page) {
	if(confirm("게시물을 삭제하시겠습니까 ? ")) {	
		var url="<%=cp%>/talk/delete";
		var query="talkNum="+talkNum;
		
		var fn = function(data){
			// var state=data.state;
			$("#listTalkBody").empty();
			pageNo=1;
			listPage(1);
		};
		
		ajaxJSON(url, "post", query, fn);
	}
}




</script>



<div class="container">
	<div class="talk-container" >
	    <div class="body-title">
	        <h3><i class="far fa-edit"></i> 오늘의한마디이이^_^ </h3>
	    </div>
	    <div>
    		<form name="talkForm" method="post" action="">
           	 <div class="talk-write" align="center" >
                 <div style="padding-top: 10px; float: left">
                       <textarea name="content" id="content" class="boxTF" style="display:block; width: 700px; height:35px; padding: 6px 12px; box-sizing:border-box; resize: none;" required="required" placeholder="오늘의 한마디를 입력하세요..."></textarea>
                  </div>
                  <div style="text-align: right; padding-top: 10px;float: left;">
                       <a class="talkBtn" onclick="sendTalk();" ><i class="fas fa-chevron-circle-up"></i> </a>
                  </div>           
          	 </div>
           </form>      	          
	          <div id="listTalk" style=" height: 500px;">
	           	<table style='width: 90%; margin: 10px auto 10px; border-spacing: 0px;  border-collapse: collapse;'>                   	           
		         <tbody id="listTalkBody"></tbody>
		        </table>
	          </div> 
                      
 	 	</div>
 	 
	</div>   
</div>