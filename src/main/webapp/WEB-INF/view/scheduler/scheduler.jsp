<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	String cp=request.getContextPath();
%>

<link rel="stylesheet" href="<%=cp%>/resource/fullcalendar/fullcalendar.min.css" type="text/css">
<link rel="stylesheet" href="<%=cp%>/resource/fullcalendar/fullcalendar.print.min.css" media='print' type="text/css">



<style type="text/css">
.hbtn {
	font-family: NanumSquareRound, "Malgun Gothic", "맑은 고딕", NaschNumGothic, 나눔고딕, 돋움, sans-serif;
    background-image:none;
    color:#fff;
    line-height: 1.5;
    text-align: center;
    padding: 5px 10px;
    font-size: 12px;
    text-decoration: none;
    position: relative;
    float: left;    
}
.hbtn:hover, .hbtn:active {
    background-image:none;
    color:#fff;
    text-decoration: none;
}

.hbtn:focus {
    background-image:none;
    color:#fff;
    text-decoration: none;
}

.hbtn-bottom {				/* 오른쪽 위 버튼 */
	border:1px solid #cccccc;
	font-weight: 900;
}


.fc-unthemed td.fc-today {		/* 오늘 해당 칸 */
	background: #F8EFFB;
	border-top: 1px solid #ddd;
}

.fc-widget-header {		/* 요일 칸 */
	height: 22px;
	line-height: 22px;
}

/* 일요일 */
.fc-widget-header .fc-sun {
	color: red;
	background: #FBEFEF;
}

.fc-widget-content .fc-sun {   
	background: #FBEFEF;
	color: red;
}

 /* 토요일 */
 .fc-widget-header .fc-sat {
 	background: #EFF2FB;
	color: blue;
}
 
.fc-widget-content .fc-sat {  
	background: #EFF2FB;
	color: blue;
}

#calendar {
	margin: 20px auto 10px;
}

#schLoading {
	display: none;
	position: absolute;
	top: 10px;
	right: 10px;
}

.fc-center h2{
	display: block;
	font-family: NanumSquareRound, "Malgun Gothic", "맑은 고딕", NaschNumGothic, 나눔고딕, 돋움, sans-serif;
	font-size: 1.5em;
	font-weight: bolder;
	/* -webkit-margin-after: 0.83em; */
	-webkit-margin-start: 0px;
	-webkit-margin-end: 0px;
}

.fc-event-container {
	border-radius: 0px;
}

.ui-dialog-title {
	font-size: 18px;
}

.ui-button.ui-corner-all.ui-widget {
	border: 1px solid #cccccc;
	font-size: 15px;
	font-family: NanumSquareRound;
}

.ui-dialog .ui-dialog-buttonpane {
	margin-top: -5px;
}

.fc-content {
	height: 17px;
	line-height: 17px;
	padding-left: 3px;
}

.fc-content .fc-title{
	font-size: 9pt;
}

/* 일정분류버튼 css */
#classifyGroup .btn, #classifyGroup .focus.btn, #classifyGroup .btn:focus, #classifyGroup .btn:hover {
    color: #fff; background-image:none;
}
.btn-private {
    background-color:#D0A9F5; border-color:#D0A9F5;
}
.btn-private:hover, .btn-private:focus {
    background-color:#D0A9F5; border-color:#D0A9F5;
}
.btn-black {
    background-color:black; border-color:black;
}
.btn-black:hover, .btn-black:focus {
    background-color:black; border-color:black;
}
.btn-company {
    background-color:#AED6F1 ; border-color:#AED6F1 ; color: #484848;
}
.btn-company:hover, .btn-company:focus {
    background-color:#AED6F1 ; border-color:#AED6F1 ;
}
.btn-red {
    background-color: #F5A9A9; border-color:#F5A9A9;
}
.btn-red:hover, .btn-red:focus {
    background-color:#F5A9A9; border-color:#F5A9A9;
}

/* 모달대화상자 */
/* 타이틀바 */
.ui-widget-header {
	background: none;
	border: none;
	height:35px;
	line-height:35px;
	border-bottom: 1px solid #cccccc;
	border-radius: 0px;
}
/* 내용 */
.ui-widget-content {
   /* border: none; */
   border-color: #cccccc; 
   font-family: NanumSquareRound;
}
</style>

<script type="text/javascript" src="<%=cp%>/resource/fullcalendar/lib/moment.min.js"></script>
<script type="text/javascript" src="<%=cp%>/resource/fullcalendar/fullcalendar.min.js"></script>
<script type="text/javascript" src="<%=cp%>/resource/fullcalendar/locale-all.js"></script>

<script type="text/javascript">

function ajaxJSON(url, type, query, fn) {
	$.ajax({
		type:type
		,url:url
		,data:query
		,dataType:"json"
		,success:function(data, text, request) {
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

//-------------------------------------------------------
//달력
var calendar=null;
var group="all";
var tempContent;

//start:2016-01-01 => 2016-01-01 일정
//start:2016-01-01, end:2016-01-02 => 2016-01-01 일정
//start:2016-01-01, end:2016-01-03 => 2016-01-01 ~ 2016-01-02 일정
$(function() {
		calendar = $('#calendar').fullCalendar({
			header: {
				left: 'prev,next today',
				center: 'title',
				right: 'month,agendaWeek,agendaDay,listMonth'
			},
			locale: 'ko',
			selectable: true,
			selectHelper: true,
			select: function(start, end, allDay) {
				// start, end : moment 객체
				// 일정하나를 선택하는 경우 종일일정인경우 end는 start 보다 1일이 크다.
				//  캘런더에 start<=일정날짜또는시간<end 까지 표시함
				
				// 달력의 빈공간을 클릭하거나 선택할 경우 입력 화면
				insertForm(start, end);
				
			},
			eventClick: function(calEvent, jsEvent, view) {
				// 일정 제목을 선택할 경우 상세 일정
				articleForm(calEvent);
			},
			editable: true,
			eventLimit: true,
		/* 	events: {
				title : "회사일정"
				,text-color: "#484848"
			}, */
			events: function(start, end, timezone, callback){
				// 캘린더가 처음 실행되거나 월이 변경되면
				var startDate=start.format("YYYY-MM-DD");
				var endDate=end.format("YYYY-MM-DD");
		        
				var url="<%=cp%>/main/month";
                var query="start="+startDate+"&end="+endDate+"&group="+group+"&tmp="+new Date().getTime();
                
            	var fn = function(data){
            		var events = eval(data.list);
			        callback(events);
            	};
            	
            	ajaxJSON(url, "post", query, fn);
            	
			},
			eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc, jsEvent, ui, view) {
				// 일정을 드래그 한 경우
				updateDrag(event);
			},
			eventResize: function(event, dayDelta, minuteDelta, allDay, revertFunc) {
				// 일정의 크기를 변경 한 경우
				updateDrag(event);
			},
			loading: function(bool) {
				$('#schLoading').toggle(bool);
			}
		});

});

// 분류별 검색
function classification(kind, idx) {
	$("#calendarHeader a").each(function(){
		$(this).removeClass("hbtn-bottom");
		// $(this).css("opacity","0.8");
	});
	$("#calendarHeader a:eq("+idx+")").addClass("hbtn-bottom");
	// $("#calendarHeader a:eq("+idx+")").css("opacity","1.0");
	
	group=kind;
	calendar.fullCalendar('refetchEvents');
}

// -------------------------------------------
// -- 상세 일정 보기
function articleForm(calEvent) {
	var str;
	
	var schNum=calEvent.schNum;
	var title=calEvent.title;
	var name=calEvent.name;
	var writer=calEvent.writer;
	
	//var category=calEvent.category;
	var color=calEvent.color;
	var category="";
	if(color=="#D0A9F5") category="개인일정";
	else if(color=="#AED6F1 ") category="회사일정";
	else if(color=="#F5A9A9") category="부서일정";
	
	var allDay=calEvent.allDay;
	var startDate="", startTime="", sday="";
	var endDate="", endTime="", eday="";
	var strDay;
	startDate=calEvent.start.format("YYYY-MM-DD");
	if(calEvent.start.hasTime()) {
	    startTime=calEvent.start.format("HH:mm");
	    if(calEvent.end!=null && calEvent.start.format()!=calEvent.end.format()) {
			endDate=calEvent.end.format("YYYY-MM-DD");
			endTime=calEvent.end.format("HH:mm");
		}	    
	} else {
		if(calEvent.end!=null && calEvent.start.format()!=calEvent.end.add("-1", "days").format()) {
			endDate=calEvent.end.format("YYYY-MM-DD");
		}
		if(calEvent.end!=null)
		    calEvent.end.add("1", "days");
	}
	if(allDay==false) {
		sday=startDate+" "+ startTime;
		eday=endDate+" "+ endTime;
		strDay="시간일정";
	}else if(allDay==false) {
		sday=startDate+" "+ startTime;
		eday=endDate;
		endTime="";
		strDay="시간일정";
	}else {
		sday=startDate;
		eday=endDate;
		startTime="";
		endTime="";
		strDay="하루종일";
	}
	
	var content=calEvent.content;
	if(! content) content="";
	tempContent=content;
	
	var dlg = $("#schedulerModal").dialog({
		  autoOpen: false,
		  modal: true,
		  buttons: {

		       " 수정" : function() {
		    	   if(writer=="${sessionScope.employee.empNo}"){
			    	   updateForm(schNum,title,allDay,startDate,endDate,startTime,endTime,color);
		    	   } else {
					alert("수정할 수 없습니다.");
				   }
		        },
			   " 삭제" : function() {
				   deleteOk(schNum);
			   },
			   
		       " 닫기 " : function() {
		    	   $(this).dialog("close");
		        }
		  },
		  height: 450,
		  width: 450,
		  title: "상세 일정",
		  close: function(event, ui) {
		  }
	});	
	
	$('#schedulerModal').load("<%=cp%>/scheduler/detailForm", function() {
		$("#schedulerTitle").html(title);
		$("#schedulerName").html(name);
		$("#schedulerCategory").html(category);
		$("#schedulerAllDay").html(strDay);
		$("#schedulerStartDate").html(sday);
		$("#schedulerEndDate").html(eday);
		$("#schedulerContent").html(content);
		
		dlg.dialog("open");
	});
}

// -------------------------------------------
// -- 입력 및 수정 대화상자
// 일정 등록 폼
function insertForm(start, end) {
	var dlg = $("#schedulerModal").dialog({
		  autoOpen: false,
		  modal: true,
		  buttons: {
		       " 확인 " : function() {
		    	   insertOk();
		        },
		       " 닫기 " : function() {
		    	   $(this).dialog("close");
		        }
		  },
		  height: 480,
		  width: 550,
		  title: "일정 추가",
		  close: function(event, ui) {
		  }
	});
	
	$('#schedulerModal').load("<%=cp%>/scheduler/insertForm", function() {
		var startDate="", startTime="";
		var endDate="", endTime="";
		
		startDate=start.format("YYYY-MM-DD");
		startTime=start.format("HH:mm");

		$("input[name='startDate']").val(startDate);

		if(start.hasTime()) {
			// 시간 일정인 경우
			$("#allDayChk").prop("checked", false);
			$("#allDayHidden").prop("disabled", false);
			
			$("#startTime").show();
			$("#endTime").show();
          
			$("input[name='startTime']").val(startTime);
			if(start.format()!=end.format()) {
				endDate=end.format("YYYY-MM-DD");
				endTime=end.format("HH:mm");
			
				$("input[name='endDate']").val(endDate);
				$("input[name='endTime']").val(endTime);
			}
			
		} else {
			// 하루종일 일정인 경우
			$("#allDayChk").prop("checked", true);
			$("#allDayHidden").prop("disabled", true);
			
			$("input[name='startTime']").val("");
			$("input[name='endTime']").val("");
			$("#startTime").hide();
			$("#endTime").hide();
			
			if(start.format()!=end.add("-1", "days").format()) {
				endDate=end.format("YYYY-MM-DD");
				$("input[name='endDate']").val(endDate);
			}
			end.add("1", "days")
		}
		
		dlg.dialog("open");
		calendar.fullCalendar('unselect');
	});	
}

// 새로운 일정 등록
function insertOk() {
	if(! validCheck()) {
		return;
	}
	
	var url="<%=cp%>/scheduler/created";
	var query=$("form[name=schedulerForm]").serialize();

	var fn = function(data){
   	   var state=data.state;
  	   if(state=="true") {
  		   group="all";
  		   calendar.fullCalendar('refetchEvents');

  		    $("#calendarHeader a").each(function(){
  				$(this).removeClass("hbtn-bottom");
  			});
  			$("#calendarHeader a:eq(0)").addClass("hbtn-bottom");
  	   }
	};
	ajaxJSON(url, "post", query, fn);
    
    $("#schedulerModal").dialog("close");
}

function validCheck() {
	var title=$.trim($("input[name='title']").val());
	var category=$.trim($("select[name='category']").val());
	var allDay=$("#allDayChk:checked").val();
	var startDate=$.trim($("input[name='startDate']").val());
	var endDate=$.trim($("input[name='endDate']").val());
	var startTime=$.trim($("input[name='startTime']").val());
	var endTime=$.trim($("input[name='endTime']").val());
	var content=$.trim($("textarea[name='content']").val());
	
	if(! title) {
		alert("제목을 입력 하세요 !!!");
		$("input[name='title']").focus();
		return false;
	}
	
	 if(! /[12][0-9]{3}-[0-9]{2}-[0-9]{2}/.test(startDate)){
			alert("날짜를 정확히 입력 하세요 [yyyy-mm-dd] !!! ");
			$("input[name='startDate']").focus();
			return false;
	 }
	 if(endDate!="" && ! /[12][0-9]{3}-[0-9]{2}-[0-9]{2}/.test(endDate)){
			alert("날짜를 정확히 입력 하세요 [yyyy-mm-dd] !!! ");
			$("input[name='endDate']").focus();
			return false;
	 }
	
	 if(startTime!="" && ! /[0-2][0-9]:[0-5][0-9]/.test(startTime)){
			alert("시간을 정확히 입력 하세요 [hh:mm] !!! ");
			$("input[name='startTime']").focus();
			return false;
	 }
	 if(allDay==undefined && startTime=="") {
		    alert("시간을 정확히 입력 하세요 [hh:mm] !!! ");
			$("input[name='startTime']").focus();
			return false;
	 }
	 
	 if(endTime!="" && ! /[0-2][0-9]:[0-5][0-9]/.test(endTime)){
			alert("시간을 정확히 입력 하세요 [hh:mm] !!! ");
			$("input[name='endTime']").focus();
			return false;
	 }
	 
	 if(allDay==undefined && endDate!="" && endTime=="") {
		 alert("시간을 정확히 입력 하세요 [hh:mm] !!! ");
			$("input[name='endTime']").focus();
			return false;
	 }

	// 종료 날짜는 종일일정인 경우 하루가 더 커야한다.
	// 캘런더에 start<=일정날짜또는시간<end 까지 표시함
    var end;
    if(endDate!="") {
    	if(endTime!="") {
        	end=moment(endDate+"T"+endTime);
			endDate=end.format("YYYY-MM-DD");
			endTime=end.format("HH:mm");
    	} else {
        	end=moment(endDate);
        	end=end.add("1", "days");
			endDate=end.format("YYYY-MM-DD");
    	}
    	$("input[name='endDate']").val(endDate);
    }
    
	if(allDay=="true") {
		$("input[name='startTime']").val("");
		$("input[name='endTime']").val("");
		$("#allDayHidden").prop("disabled", true);
	} else {
		$("input[name='endTime']").val(endTime);
		$("#allDayHidden").prop("disabled", false);
	}
	
	return true;
}

// -------------------------------------------------
// 수정 폼
function updateForm(schNum, title, allDay, startDate, endDate, startTime, endTime, category) {
	var dlg = $("#schedulerModal").dialog({
		  autoOpen: false,
		  modal: true,
		  buttons: {
		       " 확인 " : function() {
		    	   updateOk(schNum);
		        },
		       " 닫기 " : function() {
		    	   $(this).dialog("close");
		        }
		  },
		  height: 480,
		  width: 550,
		  title: "일정 수정",
		  close: function(event, ui) {
		  }
	});
	
	$('#schedulerModal').load("<%=cp%>/scheduler/insertForm", function() {
		$("input[name='title']").val(title);
		$("select[name='category']").val(category);
		$("input[name='startDate']").val(startDate);
		$("input[name='endDate']").val(endDate);
		$("input[name='startTime']").val(startTime);
		$("input[name='endTime']").val(endTime);
		$("textarea[name='content']").val(tempContent);
		
		if(allDay==true || allDay=="true") {
			$("#allDayChk").prop('checked', true);
			$("#allDayHidden").prop("disabled", true);
			
			$("#startTime").hide();
			$("#endTime").hide();
		} else {
			$("#allDayChk").prop('checked', false);
			$("#allDayHidden").prop("disabled", false);
			
			$("#startTime").show();
			$("#endTime").show();
		}
		$("input[name='title']").focus();

		dlg.dialog("open");
	});	
}

// 수정 완료
function updateOk(schNum) {
	if(! validCheck()) { 
		return;
	}
	
	var url="<%=cp%>/scheduler/update";
	$("form[name=schedulerForm] input[name=schNum]").val(schNum);
	var query=$("form[name=schedulerForm]").serialize();

	var fn = function(data){
		var state=data.state;
		if(state=="updateFAIL"){
			alert("수정안됨");
			return false;
		}
		 group="all";
    	 calendar.fullCalendar('refetchEvents', schNum);
    	 
			$("#calendarHeader a").each(function(){
				$(this).removeClass("hbtn-bottom");
			});
			$("#calendarHeader a:eq(0)").addClass("hbtn-bottom");
	};
	ajaxJSON(url, "post", query, fn);
    
    $("#schedulerModal").dialog("close");
}

// -------------------------------------------------------
// 일정을 드래그하거나 일정의 크기를 변경할 때 일정 수정
function updateDrag(e) {
	var schNum=e.schNum;
	var title=e.title;
	var category=e.category;
	var allDay=e.allDay;
	var startDate="", startTime="";
	var endDate="", endTime="";
	
	startDate=e.start.format("YYYY-MM-DD");
	if(e.start.hasTime()) {
		// 시간 일정인 경우
		startTime=e.start.format("HH:mm");
		
		if(e.end) {
		    endDate=e.end.format("YYYY-MM-DD");
		    endTime=e.end.format("HH:mm");
		    if(e.start.format()==e.end.format()) {
			    endDate="";
			    endTime="";
		    }
		}
	} else {
		// 하루종일 일정인 경우
		if(e.end) {
			endDate=e.end.format("YYYY-MM-DD");
			if(e.start.format()==e.end.add("-1", "days").format()) {
				endDate="";
			}
			e.end.add("1", "days")
		}
	}
	
	if(startTime=="" && endTime=="") {
		allDay="true";
	} else {
		allDay="false";
	}
	
	var content=e.content;
	if(! content) content="";

	var url="<%=cp%>/scheduler/update";
	var query="schNum="+schNum
           +"&title="+title
           +"&category="+category
           +"&allDay="+allDay
           +"&startDate="+startDate
           +"&endDate="+endDate
           +"&startTime="+startTime
           +"&endTime="+endTime
           +"&content="+content;
	alert(query);
	var fn = function(data){
		// console.log(data.state);
	};
	ajaxJSON(url, "post", query, fn);
}

// -------------------------------------------
function deleteOk(schNum) {
	if(confirm("삭제 하시겠습니까 ?")) {
		
		var url="<%=cp%>/scheduler/delete";
		var query="schNum="+schNum;
		
		var fn = function(data){
			// calendar.fullCalendar('removeEvents', schNum);
			calendar.fullCalendar('refetchEvents');
		};
		
		ajaxJSON(url, "post", query, fn);
	}
	
	 $("#schedulerModal").dialog("close");
}

// -------------------------------------------------
// 입력 및 수정 화면에서 일정 분류를 선택 한 경우
function classifyChange(category) {
	$("#btnTitle")
				.removeClass("btn-private")
				.removeClass("btn-company")
				.removeClass("btn-red");
	$("#btnDropdown")
				.removeClass("btn-private")
				.removeClass("btn-company")
				.removeClass("btn-red");
	
	if(category=="#D0A9F5") {
		$("#btnTitle").html("개인일정")
		$("#btnTitle").addClass("btn-private");
		$("#btnDropdown").addClass("btn-private");
	} else if(category=="#AED6F1 ") {
		$("#btnTitle").html("회사일정")
		$("#btnTitle").addClass("btn-company");
		$("#btnDropdown").addClass("btn-company");
	} else if(category=="#F5A9A9") {
		$("#btnTitle").html("부서일정")
		$("#btnTitle").addClass("btn-red");
		$("#btnDropdown").addClass("btn-red");
	}
	$("#schedulerModal input[name='category']").val(category);
}

// 종일일정에 따른 시간 입력폼 보이기/숨기기
$(function(){
	$(document).on("click","#allDayChk",function(){
		var allDay=$("#allDayChk:checked").val();
		if(allDay=='true') {
			$("#startTime").hide();
			$("#endTime").hide();
			$("#allDayHidden").prop("disabled", false);
		} else {
			$("#startTime").show();
            $("#endTime").show();
			$("#allDayHidden").prop("disabled", true);
		}
	});
});


</script>
<div class="container">
<div class="board-container"  style="width: 900px; float: left; position:absolute; margin-left: 490px;">
    <div class="body-title" style=" margin-bottom: 30px;" align="left">
        <p style="font-size: 22px; font-weight: bold; padding-top: 10px;"><i class="far fa-calendar-alt"></i> 일정관리 </p>
    </div>  
      
    <div style="margin-top: -20px;">
            <div id="calendarHeader" style="height: 35px; line-height: 35px;">
                <div style="text-align: right;">
                    <div style="clear: both; display: inline-block;">
                         <a class="hbtn hbtn-bottom" style="background: white; color:#2f3741;"
                               href="javascript:classification('all', 0);">전체일정</a>
                         <a class="hbtn" style="background: #D0A9F5;"
                               href="javascript:classification('#D0A9F5', 1);">개인일정</a>          
                         <a class="hbtn" style="background: #AED6F1 ;"
                               href="javascript:classification('#AED6F1 ', 2);">회사일정</a>
                         <a class="hbtn" style="background: #F5A9A9;"
                               href="javascript:classification('#F5A9A9', 3);">부서일정</a>
                     </div>
                </div>
            </div>
    
            <div id="calendar"></div>
	        <div id='schLoading'>loading...</div>
    </div>
</div>


<div id="schedulerModal" style="display: none;"></div>


</div>