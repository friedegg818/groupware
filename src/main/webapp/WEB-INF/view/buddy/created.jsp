<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>

<link rel="stylesheet" href="<%=cp%>/resource/css/article.css" type="text/css">
<link rel="stylesheet" href="<%=cp%>/resource/css/buddy.css" type="text/css">
<script type="text/javascript" src="<%=cp%>/resource/se/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">
/* 다중 파일 처리 */
$(function(){
	$("form input[name=upload]").change(function(){
		if(! $(this).val()) return;
		
		var b=false;
		$("form input[name=upload]").each(function(){
			if(! $(this).val()) {
				b=true;
				return;
			}
		});
		if(b) return false;
			
		var $tr = $(this).closest("tr").clone(true); // 이벤트도 복제
		$tr.find("input").val("");
		$("#tb").append($tr);
	});
});
</script>

<script type="text/javascript">
/* 입력 폼 */
    function check() {
        var f = document.buddyForm;

    	var str = f.title.value;
        if(!str) {
            alert("제목을 입력하세요. ");
            f.title.focus();
            return false;
        }

     	str = f.content.value;
        if(!str) {
            alert("내용을 입력하세요. ");
            f.content.focus();
            return false;
        } 

    	f.action="<%=cp%>/buddy/created";
    	
    	return true;
    } 
</script>

<script type="text/javascript">

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

/* 사원 검색 */
$(function() {
	$("body").on("click", "#searchEmail", function(){
		var $btn = $(this);
		$("#searchEmail-dialog").dialog({
			modal : true,
			width : 530,
			title : '[사원 검색]',
			open : function() {
			},
			close : function(event, ui) {
			}
		});
	});
	
	$("body").on("click", "#searchOk", function(){
		/* each 써서 체크 한 것 내용 가져오기 */
		$('#searchEmail-dialog').dialog("close");
		
		var empNos = ""; 
		
		 $("input[type=checkbox]:checked").each(function() {
			 var val = $(this).val();
			 var name = $(this).data("name");
			 var email = $(this).data("email");
			 var dType = $(this).data("dtype");
			 var pType = $(this).data("ptype");
			 $("#receiverEmpList").append("<p style='padding-top: 3px;'>"+ "&nbsp;&nbsp;| " + dType + " " + name + pType + "  [" + email +  "] " + " ;" + "</p>");
			 
			 empNos += val + ",";
			 rempNos = empNos.substr(0,empNos.length-1);
		});
		 
		 $("input[name=receiver]").val(rempNos);
		 
	});
	

	
	$(".btnSearch").click(function(){
		var col = $("form[name=searchEmpForm] select[name=col]").val();
		var keyword=$("form[name=searchEmpForm] input[name=keyword]").val().trim();
		if(! keyword) {
			$("form[name=searchEmpForm] input[name=keyword]").focus();
			return false;
		}
		
		var query = "col="+encodeURIComponent(col)+"&keyword="+encodeURIComponent(keyword);
		var url = "<%=cp%>/buddy/searchEmailList";
		var fn = function(data) {
			console.log(data);
			
			var out="";
			
			out += "<table class='empListTable' style='margin-top: 5px; margin-bottom: 20px; width: 500px; border-top: 1px solid #cccccc;'>";
			out += "	<tr>";
			out += " 		<td width='5%' style='margin-left: 10px;'> <input type='checkbox' name='chkAll' id='chkAll' value='all' > </td>";
			out += "    	<td width='20%'> 부서 </td>";
			out += "        <td width='20%'> 직급 </td>";
			out += "        <td width='15%'> 이름 </td>";
			out += "        <td width='40%'> email </td>";						
			out += "	</tr>";
			
			for(var i=0; i<data.adlist.length; i++) {
				var empNo = data.adlist[i].empNo;
				var name = data.adlist[i].name;
				var email = data.adlist[i].email;
				var dType = data.adlist[i].dType;
				var pType = data.adlist[i].pType;
		
				out += "<tr> ";
				out += "	<td> <input type='checkbox' class='selectEmailEmp' value='"+empNo+"' data-name='"+name+"' data-email='"+email+"' data-dtype='"+dType+"' data-ptype='"+pType+"' >";
				out +="		<td> " + dType + "</td>";	
				out +="		<td> " + pType + "</td>";	
				out +="		<td> " + name + "</td>";	
				out +="		<td> " + email + "</td>";	
				out +="</tr>";
			}
				out +="</table>";
			
			$(".resultList").append(out);
		}				
		ajaxJSON(url, "get", query, fn)		
	});
		
});
</script>

<div class="container">
    <div class="board-container">
        <div class="body-title" style="font-size: 18px;">
            <h3><i class="far fa-envelope"></i>&nbsp;&nbsp;메일 </h3>
        </div> 
        
        <div class="board-body" style="float: left; width: 20%;">	      
	        	<div style="margin-top: 20px; margin-left: 20px;">	        	
	           		<button type="button" style="width: 220px; height: 50px; background: #9565A4; color: white; font-size: 25px; border: none; border-radius: 10px;" onclick="javascript:location.href='<%=cp%>/buddy/rlist';"><i class="fas fa-list"></i></button>
	           	</div>   
        </div> 
        
        <div class="board-created" style="margin-top: 20px;">
	        <div class="body-title" style="margin-bottom: 10px;">
	       		  <h3 style="font-size: 20px;">| 메일 쓰기  </h3>
	        </div>
         
			<form name="buddyForm" method="post" enctype="multipart/form-data" onsubmit="return submitContents(this);">
			  <table class="boardtable">
			  <tbody id="tb">
				   <tr align="left" height="50"  > 
				      <td style="width: 100px; background: white; color: #424242; text-align: center; border-bottom: 1px solid #cccccc;">발신</td>
				      <td style="padding-left:10px; border-bottom: 1px solid #cccccc;"> 
				        <input type="text" name="sender" maxlength="100" style="height: 27px; width: 930px; border: 1px solid #cccccc;" value="${sessionScope.employee.dType}&nbsp;${sessionScope.employee.name}${sessionScope.employee.pType}">
				      </td>
				  </tr>	
				  
				   <tr align="left" height="50"  > 
				      <td style="width: 100px; background: white; color: #424242; text-align: center; border-bottom: 1px solid #cccccc;">수신</td>
					      <td style="padding-left:10px; border-bottom: 1px solid #cccccc;"> 
						      <button type="button" id="searchEmail" style="background: none; border: none;  margin-top: 5px;"> <i class="fas fa-plus-circle" style="color: #585858; font-size: 15px;"></i></button>
						      <div id="receiverEmpList" style="display: inline-block; vertical-align: top; margin-top: 5px; margin-bottom: 5px;"></div> 
						       <input type="hidden" name="receiver">		    
					      </td>
				  </tr>	
				  
				   <tr align="left" height="50"  > 
				      <td style="width: 100px; background: white; color: #424242; text-align: center; border-bottom: 1px solid #cccccc;">제목</td>
				      <td style="padding-left:10px; border-bottom: 1px solid #cccccc;"> 
				        <input type="text" name="title" maxlength="100" style="height: 27px; width: 930px; border: 1px solid #cccccc;" value="${dto.title}">
				      </td>
				  </tr>				  
				   
				  <tr align="left" height="300"> 
				      <td style="width: 100px; background: white; color: #424242; border-bottom: 1px solid #cccccc; text-align: center; padding-top:10px;" valign="middle">내용</td>
				      <td valign="top" style="padding:20px 0px 20px 10px; border-bottom: 1px solid #cccccc;"> 
				        <textarea name="content" id="content" rows="12" class="boxTA" style="width: 95%;">${dto.content}</textarea>
				      </td>
				  </tr> 
			  	
			  	  <tr align="left" height="50"> 
				      <td style="width: 100px; background: white; color: #424242; text-align: center; padding-top: 10px; padding-bottom: 10px; border-bottom: 1px solid #cccccc;">첨부</td>
				      <td style="padding-left:10px; padding-top: 10px; padding-bottom: 10px; border-bottom: 1px solid #cccccc;"> 
				   	      <input type="file" name="upload" class="boxTF" size="53" style="width: 95%; height: 25px;">     
				       </td>
			  	  </tr> 			  	
             	 </tbody>
			  </table>			  
			
			    <table class="boardtable" style="margin-left: 320px; background: white; margin-top: 35px;">
			     <tr height="45"> 
			      <td align="center" >
			        <button type="submit" class="boardBtn">전송</button>
			        <button type="reset" class="boardBtn2">다시입력</button>
			      	 <c:if test="${mode=='update'}">
			         	 <input type="hidden" name="buddyNum" value="${dto.buddyNum}">
			        </c:if>
			      </td>
			    </tr>
			  </table>
			</form>
        </div>

    </div>
</div>


<!-- 사원 검색 모달 -->
<div id="searchEmail-dialog" class="emailModal" style="display: none;">
	<div class="searchList">
	    <form name="searchEmpForm">
	    	<div style="margin-top: 10px; height: 35px;">
				<select name="col" style="width: 60px; height: 30px; border: 1px solid #cccccc; text-align: center; color: #424242;">
					<option value="d.dType"> 부서 </option>
					<option value="name"> 이름 </option>	
				</select>
				<input type="text" name="keyword" style="height: 28px; width: 90px; border: 1px solid #cccccc; padding-left: 5px;"> 
				<button type="button" style="border: none; background: none; padding-left: 3px; font-size: 16px; color: #424242;" class="btnSearch"> <i class="fas fa-search"></i> </button>    <!-- 검색버튼 -->	
			</div>
			<div class="resultList"></div>			
			<button type="button" id="searchOk" class="close" style="border: 1px solid #cccccc; color: #848484;  padding: 5px 8px; border-radius: 4px; background: none; margin-left: 230px; font-size: 15px;">선택</button>	  <!-- 선택버튼 -->
			
		</form>
	</div>
</div>


<script type="text/javascript">
var oEditors = [];
nhn.husky.EZCreator.createInIFrame({
	oAppRef: oEditors,
	elPlaceHolder: "content",
	sSkinURI: "<%=cp%>/resource/se/SmartEditor2Skin.html",	
	htParams : {bUseToolbar : true,
		fOnBeforeUnload : function(){
			//alert("아싸!");
		}
	}, //boolean
	fOnAppLoad : function(){
		//예제 코드
		//oEditors.getById["content"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
	},
	fCreator: "createSEditor2"
});

function pasteHTML() {
	var sHTML = "<span style='color:#FF0000;'>이미지도 같은 방식으로 삽입합니다.<\/span>";
	oEditors.getById["content"].exec("PASTE_HTML", [sHTML]);
}

function showHTML() {
	var sHTML = oEditors.getById["content"].getIR();
	alert(sHTML);
}
	
function submitContents(elClickedObj) {
	oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.
	
	// 에디터의 내용에 대한 값 검증은 이곳에서 document.getElementById("content").value를 이용해서 처리하면 됩니다.
	
	try {
		// elClickedObj.form.submit();
		return check();
	} catch(e) {}
}

function setDefaultFont() {
	var sDefaultFont = '돋움';
	var nFontSize = 24;
	oEditors.getById["content"].setDefaultFont(sDefaultFont, nFontSize);
}
</script>

