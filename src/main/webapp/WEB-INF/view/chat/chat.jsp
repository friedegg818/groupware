<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>

<link rel="stylesheet" href="<%=cp%>/resource/css/chat.css" type="text/css">


<script src="http://localhost:3001/socket.io/socket.io.js"></script>
<script type="text/javascript">

//왼쪽 사원 리스트 출력
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
	
	function listDept2() {
		var url="<%=cp%>/employee/listDept";
		var query="";
		
		var fn = function(data){
			printDept2(data);
		};
		
		ajaxJSON(url, "get", query, fn);		
	}
	
	function printDept2(data) {
	
		var uid="${sessionScope.employee.empNo}";		
		
		var out="";
		for(var idx=0; idx<data.length; idx++) {
			var dType=data[idx];
			
			out+="<tr ><td class='fp-dept2'>";
			out+="<span class='dept-icon2 fp-dept-more2' data-dept2='"+dType+"'><i class='fas fa-caret-down'></i>&nbsp;"+dType+"</span>";
			out+="<span class='dept-icon2 fp-dept-less2' style='display:none'><i class='fas fa-caret-up'></i>&nbsp;"+dType+"</span></td></tr>";
			out+="<tr style='display:none;'><td class='fp-person2'></td></tr>";
		}
		
		$("#guestListContainer").append(out);
	}
	
	listDept2();
	
	$("body").on("click", ".dept-icon2",function(){
		  var obj = $(this);
		  var $td = $(this).closest("tr").next("tr").children("td");
		  if( obj.hasClass("fp-dept-more2") ){
		    obj.hide();
		    obj.next().show();            
		    obj.parent().parent().next().show();
		    
		    $td.empty();
		    
		    var dept = obj.attr("data-dept2");
		    
		    var url="<%=cp%>/employee/listOrg";
			var query="dept="+dept;
			
			var fn = function(data){
				printOrg2(data, $td);
			};
			
			ajaxJSON(url, "post", query, fn);
		    
 
		  }else{
		     obj.hide();
		     obj.prev().show();
		     obj.parent().parent().next().hide();
		  }
	});	
	
	function printOrg2(data,obj) {
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
			
			out+=" <p data-empNo='"+empNo+"' data-image='"+image+"'>";
			if(clockIn!=null && (clockOut==null)){
				out+=" <i class='fas fa-circle' style='font-size: 8px; color:LIME;'></i>";	
			}else{
				out+=" <i class='fas fa-circle' style='font-size: 8px; color:lightgray;'></i>";				
			}
			out+=" &nbsp;&nbsp;&nbsp;";
			out+=" <img src='<%=cp%>/uploads/profile/"+image;
			out+="' style='width: 30px; height: 30px; border-radius: 15px; vertical-align:middle;'>&nbsp;";
			out+=pType+"&nbsp;|&nbsp;"+name+"</i>";
		}		
		obj.html(out);
	}	
	
});
// ---------------------
//날짜가져오기
function convertStringToDate(str) {
	// yyyy-mm-dd hh:mi:ss
    
    return new Date(str.substr(0,4), str.substr(5,2)-1, str.substr(8,2), str.substr(11,2), str.substr(14,2), str.substr(17,2));
}

function convertDateTimeToString(date) {
    var y = date.getFullYear();
    var m = date.getMonth() + 1;
    m = (m>9 ? '' : '0') + m;
    var d = date.getDate();
    d = (d>9 ? '' : '0') + d;

    var hh = date.getHours();
    hh = (hh>9 ? '' : '0') + hh;
    var mi=date.getMinutes();
    mi = (mi>9 ? '' : '0') + mi;
    var ss=date.getSeconds();
    ss = (ss>9 ? '' : '0') + ss;
    
    return y + '-' + m + '-' + d +' ' + hh + ':'+mi+":"+ss;
}

function convertDateToString(date) {
	var week = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
    var y = date.getFullYear();
    var m = date.getMonth() + 1;
    var d = date.getDate();
    var w = week[date.getDay()];
    
    return y + '년 ' + m + '월 ' + d +"일 " + w;
}

function yyyymmdd(date) {
    var y = date.getFullYear();
    var m = date.getMonth() + 1;
    var d = date.getDate();
    
    return [y,
        (m>9 ? '' : '0') + m,
        (d>9 ? '' : '0') + d
       ].join('');
}

function convertTimeToString(date) {
    var h = date.getHours();
    var m=date.getMinutes();
    var ampm='오전';
    if (h>=12) ampm='오후';
    if (h>12) h=h-12;
    if (h==0) h=12;
    
    return ampm+" "+h+":"+m;
}

function compareToDate(date1, date2) {
	var d1, d2;
	
	if (typeof date1 === 'object' && date1 instanceof Date && typeof date2 === 'object' && date2 instanceof Date) {
		d1 = new Date(date1.getFullYear(), date1.getMonth(), date1.getDate());
		d2 = new Date(date2.getFullYear(), date2.getMonth(), date2.getDate());
	} else {
		// yyyymmdd
		d1 = new Date(date1.substr(0,4), date1.substr(4,2)-1, date1.substr(6,2));
		d2 = new Date(date2.substr(0,4), date2.substr(4,2)-1, date2.substr(6,2));
	}
	
	return d1.getTime() - d2.getTime();
}

//----------------------------

$(function(){
	//채티이이잉
	var uid = "${sessionScope.employee.empNo}";
	var name = "${sessionScope.employee.name}";
	var uphoto="${sessionScope.employee.imageFilename}";
	
	if(! uid) {
	    location.href="<%=cp%>/login";
	    return;
    }
	var first_date = null; // 화면에 출력된 메시지의 최초의 날짜 
	var last_date = null;  // 화면에 출력된 메시지의 마지막 날짜 
	var room = null;
	//var image=null;
	// 채팅 서버에 접속
	var sock = io('http://localhost:3001/chat');
	
	
	// 채팅방 입장
	$("body").on("click", ".fp-person2 p", function(){
		room = $(this).attr("data-empNo");
		alert(room);
		image=$(this).attr("data-image");
		
		
	//^_^요기까지.........
		first_date = last_date = new Date();
		
		// 룸이름
		var roomName = $(this).text();
		alert(roomName);
		$(".chatting-content-list").empty();
		if(uid=='10001'){
			$(".chatting-room-name").html(roomName);		
		} else if(uid=='10002'){		
			$(".chatting-room-name").html("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;홍보부 | 김수현");
		}
		
		$("#chatRoomList").css("display","none");
		$("#chatContentList").css("display","");
	
		$(".backToChatroom").on("click", function(){
			$("#chatRoomList").css("display","");
			$(".chatList").css("display","");
			
			$("#chatContentList").css("display","none");
		});
		
	<%-- 	if(room){
			$(".room-image").html("<img width='60' height='60' style='border-radius:30px;' src='<%=cp%>/uploads/profile/"+image+"'>");			
		} 
	--%>
	
		
			
		
		
		$("body").on("click", ".chatList", function(){
			$("#chatRoomList").css("display","none");
			$("#chatContentList").css("display","");
		});
		
		$("body").on("click", "td.roomout", function(e){
			alert("채팅방을 나가시겠습니까?");
			$(this).closest("table").remove();			
			e.stopPropagation();			
		});

		
		
		
/* 		
		var out="";
		function roomList(data){
			
			out+= "<table class='chatList' style='border-bottom: 1px solid red; width: 670px; margin-left: 10px; padding: 10px;'>";
			out+= " <tr><td rowspan='2' width='70'><i style='font-size: 60px;' class='fas fa-user-circle'></i></td>";
			out+= "		<td class='chatting-room-name' width='400'><p>dType홍보부 name김수현 pType사원</p></td>";
			out+= "		<td class='latestTime' width='100'><p></p></td>";
			out+= "		<td rowspan='2'><i title='나가기' style='font-size: 30px;' class='fas fa-sign-out-alt'></i></td>";
			out+= "	</tr>";
			out+= "<tr><td class='latestChat' style='color:red'><p>대화내용이요~~</p></td><td></td></tr></table>";
		}
		$(".chatListContainer").append(out);
		
		 */
		//채팅방 리스트 생성

		
		
		// 오늘 날짜의 룸 채팅 문자열 리스트 요청
		sock.emit("chat-msg-list", {
			room : room,
			writeDate : convertDateTimeToString(last_date)
		});
	});
	
	// 채팅 메시지 보내기
	$("#chatMsg").on("keydown",function(event) {
    	// 엔터키가 눌린 경우, 서버로 메시지를 전송한다.
        if (event.keyCode == 13) {
        	var message = $("#chatMsg").val().trim();
        	
        	if(! message) {
        		return false;
        	}
        	
        	var msg = {
        		room:room,	
        		writeDate:convertDateTimeToString(new Date()),	
        		empNo:uid,
        		name:name,
        		image:image,
        		message:message,	
        	};
        	
			sock.emit("chat-msg", msg);
        	
        	$("#chatMsg").val("");
        	$("#chatMsg").focus();
        }
    });
	
	
	// 채팅 문자열이 전송된 경우
	sock.on("chat-msg", function(data) {
		writeToScreen(data);
	});	
	
	function writeToScreen(data) {
		var room = data.room;
		var writeDate = convertStringToDate(data.writeDate);
		var empNo = data.empNo;
		var name = data.name;
		var message = data.message;
		
		var out;
		var dispDate = convertDateToString(writeDate);
		var dispTime = convertTimeToString(writeDate);
		var strDate = yyyymmdd(writeDate);
    	var cls = "date-"+strDate;

		if(! $(".chatting-content-list").children("div").hasClass(cls)) {
			// 날짜 출력
			out =  "<div class='"+cls+"'>";
	    	out += " <div style='clear: both; margin:10px 5px 3px;'>";
		    out += "   <div style='float: left; font-size: 12px; padding-right: 5px; margin:8px 0 20px 0'><i class='far fa-calendar'></i> "+dispDate+"</div>";
		    out += "   <hr>";
		    out += "  </div>";
		    out += "</div>";
		    
		    if(compareToDate(strDate, yyyymmdd(last_date)) >=0 ) {
		    	last_date = writeDate;
		    	$(".chatting-content-list").append(out);
		    } else {
		    	$(".chatting-content-list").prepend(out);
		    }
		}
		
		
		
		// 메시지 출력
		if(uid==empNo) {		
			out="<div class='my_message' style='clear: both; '>";
        	out+="	<div class='my-tooltip toolmsg' style='float: right; cursor: pointer;' >"+message+"</div>";
			out+="	<div class='toolTime' style='float: right; font-size: 12px; margin: 20px 4px 0 0;'>"+dispTime+"</div>";
			out+="	<div class='myChatImage'  style='clear:both; float: right; '>";
			out+="		<img src='<%=cp%>/uploads/profile/"+uphoto+"'></div>";
			out += "</div>";
			
		} else {
			out=" <div class='you_message' style='clear: both; '>";
        	out+="	<div class='you-tooltip toolmsg' style='cursor: pointer; float: left;' >"+message+"</div>";
        	out+="	<div class='toolTime' style='float:left; font-size: 12px; margin: 20px 0 0 4px ;'>"+dispTime+"</div>";
			out+="<div class='youChatImage'  style='clear:both; '>";
			if(uid=='10002'){
				out+="<img src='<%=cp%>/resource/images/김수현.png'><span>"+name+"</span></div>";				
			} else{
			out+="<img src='<%=cp%>/resource/images/차승원.png'><span>"+name+"</span></div>";		
				
			}
			out += "</div>";
		}
		
		$("."+cls).append(out);
		$('#chatMsgContainer').scrollTop($('#chatMsgContainer').prop('scrollHeight'));
		
		
		
		var latestChat= $(".chatting-content-list").children().children().last().children(".toolmsg").text();
		var latestTime= $(".chatting-content-list").children().children().last().children(".toolTime").text();
		
		$(".latestChat p").text(latestChat);
		$(".latestTime p").text(latestTime);
		
	}	
	
	$("body").on("click", ".topToChatroom", function(e){
		$('#chatMsgContainer').scrollTop(0);		
	});
	$("body").on("click", ".bottomToChatroom", function(e){
		$('#chatMsgContainer').scrollTop($('#chatMsgContainer').prop('scrollHeight'));	
	});
	
});

</script>
<div class="container">
	<div class="board-container">
	     <div class="body-title" >
	         <h3 style="font-size: 18px"><i class="far fa-comment-alt"></i> 채팅 </h3>
	     </div>
	     
	     <div class="board-body" style="" >
	         <div class="alert-info">
	            <i class="fas fa-info-circle"></i> 사원들과 실시간으로 대화를 나눌 수 있는 공간 입니다.
	        </div>
	     
		    <div style="clear: both;">
		    	<div style="float: left; width: 300px;">
		            <div style="clear: both; padding-bottom: 5px; margin-top: 10px;">
		                <span style="font-weight: 600;">＞</span>
		                <span style="font-weight: 600; color: #424951;">사원목록</span>
		            </div>
		            <div id="guestListContainer" class="scrollStyle"></div>
		        </div>
		        
		        <div style="float: left; width: 20px;">&nbsp;</div>
		        		        
		        <div id="chatRoomList" style="float: left; width: 700px;  /* display: none;  */  ">
		             <div style="clear: both; padding-bottom: 5px; margin-top: 10px;">
		                 <span style="font-weight: 600;">＞</span>
		                 <span style="font-weight: 600; font-family:color: #424951;">채팅 목록</span>
		             </div>
		             <div id="chatListContainer" >
		             	<table class="chatList"style="border-bottom: 1px double #9565A4; width: 670px; margin-left: 10px; padding: 10px;  display: none;" >
							<tr>
								<td class="room-image"rowspan="2" width="70" height="70">
									<c:if test="${sessionScope.employee.empNo=='10001'}">
										<img style="width: 60px; height: 60px; border-radius: 30px;" src="<%=cp%>/resource/images/차승원.png">
									</c:if>
									<c:if test="${sessionScope.employee.empNo=='10002'}">
										<img style="width: 60px; height: 60px; border-radius: 30px;" src="<%=cp%>/resource/images/김수현.png">
									</c:if>
								</td>
								<td class="chatting-room-name" ><p></p></td>
								<td class="latestTime" width="120"><p></p></td>
								<td class="roomout" rowspan="2"><i title="나가기" style="font-size: 30px; color:#9565A4; "  class="fas fa-sign-out-alt"></i></td>
							</tr>
							<tr>							
								<td class="latestChat"><p></p></td>
								<td></td>
							</tr>
						</table>
						<c:if test="${sessionScope.employee.empNo=='10001'}">
						<table class="chatList"style="border-bottom: 1px double #9565A4; width: 670px; margin-left: 10px; padding: 10px; " >
							<tr>
								<td class="room-image-smp"rowspan="2" width="70" height="70"><img style="width: 60px; height: 60px; border-radius: 30px;" src="<%=cp%>/resource/images/woobin.jpg"></td>
								<td class="chatting-room-name-smp" ><p style="padding-left: 10px;">&nbsp;&nbsp;경영지원부 | 김우빈</p></td>
								<td class="latestTime-smp" width="120"><p>목요일 오후 5:16</p></td>
								<td class="roomout" rowspan="2"><i title="나가기" style="font-size: 30px; color:#9565A4; "  class="fas fa-sign-out-alt"></i></td>
							</tr>
							<tr>							
								<td class="latestChat-smp"><p>오늘 볼링 치러 갈래?</p></td>
								<td></td>
							</tr>
						</table>
						<table class="chatList"style="border-bottom: 1px double #9565A4; width: 670px; margin-left: 10px; padding: 10px;  " >
							<tr>
								<td class="room-image-smp"rowspan="2" width="70" height="70"><img style="width: 60px; height: 60px; border-radius: 30px;" src="<%=cp%>/resource/images/김다미.jpg"></td>
								<td class="chatting-room-name-smp" ><p style="padding-left: 10px;">&nbsp;&nbsp;홍보부 | 김다미</p></td>
								<td class="latestTime-smp" width="120"><p>수요일 오후 2:16</p></td>
								<td class="roomout" rowspan="2"><i title="나가기" style="font-size: 30px; color:#9565A4; "  class="fas fa-sign-out-alt"></i></td>
							</tr>
							<tr>							
								<td class="latestChat-smp"><p>그래서 회식은 어디로 가나요?</p></td>
								<td></td>
							</tr>
						</table>
						<table class="chatList"style="border-bottom: 1px double #9565A4; width: 670px; margin-left: 10px; padding: 10px; " >
							<tr>
								<td class="room-image-smp"rowspan="2" width="70" height="70"><img style="width: 60px; height: 60px; border-radius: 30px;" src="<%=cp%>/resource/images/박보검.jpg"></td>
								<td class="chatting-room-name-smp" ><p style="padding-left: 10px;">&nbsp;&nbsp;개발부 | 박보검</p></td>
								<td class="latestTime-smp" width="120"><p> 수요일 오후 2:11</p></td>
								<td class="roomout" rowspan="2"><i title="나가기" style="font-size: 30px; color:#9565A4; "  class="fas fa-sign-out-alt"></i></td>
							</tr>
							<tr>							
								<td class="latestChat-smp"><p>자바 때리실?</p></td>
								<td></td>
							</tr>
						</table>
						<table class="chatList"style="border-bottom: 1px double #9565A4; width: 670px; margin-left: 10px; padding: 10px;  " >
							<tr>
								<td class="room-image-smp"rowspan="2" width="70" height="70"><img style="width: 60px; height: 60px; border-radius: 30px;" src="<%=cp%>/resource/images/서강준.jpg"></td>
								<td class="chatting-room-name-smp" ><p style="padding-left: 10px;">&nbsp;&nbsp;홍보부 | 서강준</p></td>
								<td class="latestTime-smp" width="120"><p>수요일 오후 1:54</p></td>
								<td class="roomout" rowspan="2"><i title="나가기" style="font-size: 30px; color:#9565A4; "  class="fas fa-sign-out-alt"></i></td>
							</tr>
							<tr>							
								<td class="latestChat-smp"><p>오늘 점심 뭐먹었음?</p></td>
								<td></td>
							</tr>
						</table>
						<table class="chatList"style="border-bottom: 1px double #9565A4; width: 670px; margin-left: 10px; padding: 10px;  " >
							<tr>
								<td class="room-image-smp"rowspan="2" width="70" height="70"><img style="width: 60px; height: 60px; border-radius: 30px;" src="<%=cp%>/resource/images/서예지.jpg"></td>
								<td class="chatting-room-name-smp" ><p style="padding-left: 10px;">&nbsp;&nbsp;인사부 | 서예지</p></td>
								<td class="latestTime-smp" width="120"><p>화요일 오후 2:16</p></td>
								<td class="roomout" rowspan="2"><i title="나가기" style="font-size: 30px; color:#9565A4; "  class="fas fa-sign-out-alt"></i></td>
							</tr>
							<tr>							
								<td class="latestChat-smp"><p>보고싶어~</p></td>
								<td></td>
							</tr>
						</table>
						<table class="chatList"style="border-bottom: 1px double #9565A4; width: 670px; margin-left: 10px; padding: 10px;  " >
							<tr>
								<td class="room-image-smp"rowspan="2" width="70" height="70"><img style="width: 60px; height: 60px; border-radius: 30px;" src="<%=cp%>/resource/images/한소희.jpg"></td>
								<td class="chatting-room-name-smp"><p style="padding-left: 10px;">&nbsp;&nbsp;인사부 | 한소희</p></td>
								<td class="latestTime-smp" width="120"><p>화요일 오전 10:57</p></td>
								<td class="roomout" rowspan="2"><i title="나가기" style="font-size: 30px; color:#9565A4; "  class="fas fa-sign-out-alt"></i></td>
							</tr>
							<tr>							
								<td class="latestChat-smp"><p>보고싶어~</p></td>
								<td></td>
							</tr>
						</table>
						</c:if>
		             </div>
		        </div>

		        
		        <div id="chatContentList"  style="float: left; width: 700px; display: none;">
		             <div style="clear: both; padding-bottom: 5px; margin-top: 10px;">
		                 <span style="font-weight: 600;">＞</span>
		                 <span style="font-weight: 600; color: #424951;">채팅 메시지</span>
		             </div>
		             <div id="chatMsgContainer" class="scrollStyle">
		             	<div class="backToChatroom" style=""><i style="font-size: 20px" class="far fa-arrow-alt-circle-left"></i>뒤로</div>
		             		<div class="chatting-content-list"></div>
		             		<%-- <div class='my_message' style='clear: both; margin: 5px 5px;'>
					        	<div class="my-tooltip" style='float: right; cursor: pointer;' >메세지입력ㄱㄱ</div>
								<div style='float: right; font-size: 12px; margin: 20px 4px 0 0;'>시ddd간</div>
								<div class="myChatImage"  style='clear:both; float: right; margin: 15px 35px 0 0; '><img src='<%=cp%>/uploads/profile/${sessionScope.employee.imageFilename}'></div>
							</div>
							
							<div class='you_message' style='clear: both; margin: 5px 5px;'>
					        	<div class="you-tooltip" style='cursor: pointer; float: left;' >니가보낸메세지ㄱㄱ</div>
					        	<div style="float:left; font-size: 12px; margin: 20px 0 0 4px ;">상대방이보낸시간</div>
								<div class="youChatImage"  style='clear:both; margin-left:30px; padding-top:15px'><img src='<%=cp%>/resource/images/basic.gif'><span>dTye이름pType</span></div>
							</div>
							<div class='you_message' style='clear: both; margin: 5px 5px;'>
					        	<div class="you-tooltip" style='cursor: pointer; float: left;' >니가보낸메세지ㄱㄱ</div>
					        	<div style="float:left; font-size: 12px; margin: 20px 0 0 4px ;">상대방이보낸시간</div>
								<div class="youChatImage"  style='clear:both; margin-left:30px; padding-top:15px'><img src='<%=cp%>/resource/images/basic.gif'><span>dTye이름pType</span></div>
							</div> --%>
		             </div>
		             <div class="backToChatroom" style=" margin-top: 10px; float: left;">
		             	<span><i style="font-size: 20px" class="far fa-arrow-alt-circle-left"></i>뒤로</span>
		             </div>

		             <div class="topToChatroom"  style="margin-top: 10px; float: right;">
		             	<span><i style="font-size: 20px" class="far fa-arrow-alt-circle-up"></i>맨 위로&nbsp;</span>
		             </div>
		             <div class="bottomToChatroom"  style="margin-top: 10px; float: right;">
		             	<span><i style="font-size: 20px" class="far fa-arrow-alt-circle-down"></i>맨 아래로&nbsp;&nbsp;&nbsp;&nbsp;</span>
		             </div>
		             <div style="clear: both; padding-top: 5px; ">
		             	<input type="text" id="chatMsg" class="boxTF"  style=""
		                            placeholder="채팅 메시지를 입력 하세요...">
		             </div>
		        </div>


		       
		        
		        
		    </div>
	         
	     </div>
	</div>
</div>
