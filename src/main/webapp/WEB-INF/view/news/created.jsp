<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>

<link rel="stylesheet" href="<%=cp%>/resource/css/article.css" type="text/css">
<script type="text/javascript" src="<%=cp%>/resource/se/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">

</script>
<script type="text/javascript">
    function check() {
        var f = document.newsForm;

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
        
        str = f.nCode.value;
        if(!str) {
            alert("분류를 선택하세요.");
            f.nCode.focus();
            return false;
        }
    	<c:if test="${sessionScope.employee.dCode!='PR'}">
	    	alert("권한이 없습니다.");
	    	return false;
    	</c:if>
    	
    	<c:if test="${sessionScope.employee.dCode=='PR'}">
	   		f.action="<%=cp%>/news/${mode}";
	        return true;

    	</c:if>

    }
    
</script>

<div class="container">
    <div class="board-container">
        <div class="board-title"  style="font-size: 18px;">
             <h3><i class="far fa-newspaper"></i>&nbsp;&nbsp;소식 </h3>
        </div>
        
        <div class="board-body" style="float: left; width: 20%;">	      
	        	<div style="margin-top: 20px; margin-left: 20px;">	        	
	           		<button type="button" style="width: 220px; height: 50px; background: #9565A4; color: white; font-size: 25px; border: none; border-radius: 10px;" onclick="javascript:location.href='<%=cp%>/news/list" title="목록으로"><i class="fas fa-list"></i></button>
	           	</div>   
        </div> 
        
        <div class="board-created"  style="margin-top: 20px;">
	        <div class="body-title" style="margin-bottom: 10px;">
	          	<h3 style="font-size: 20px;">| 소식 알리기  </h3>
	         </div>
			<form name="newsForm" method="post" onsubmit="return submitContents(this);">
			  <table class="boardtable">
				  <tr align="left" height="50" > 
			  	     <td class="ctypeTd" style="width: 100px; color: #424242; text-align: center; border-bottom: 1px solid #cccccc;">분류</td>
				      <td class="cselectTd">				      		      		
			     		<select class="cselectBox" name="nCode">
			     			  <option value="">::선 택::</option>
						      <option value="COMPANY" ${dto.nCode=="COMPANY"?"selected='selected'":""}>회사소식</option>
						      <option value="MR" ${dto.nCode=="MR"?"selected='selected'":""}>결혼</option>
						      <option value="FU" ${dto.nCode=="FU"?"selected='selected'":""}>부고</option>
						      <option value="BI" ${dto.nCode=="BI"?"selected='selected'":""}>츨산</option>
						      <option value="PR" ${dto.nCode=="PR"?"selected='selected'":""}>승진</option>
						      <option value="ETC" ${dto.nCode=="ETC"?"selected='selected'":""}>기타</option>	     				     	
			     		</select>					
			      	</td>
				  </tr>		
				  <tr align="left" height="50"  > 
				      <td style="width: 100px; background: white; color: #424242; text-align: center; border-bottom: 1px solid #cccccc;">제 목</td>
				      <td style="padding-left:10px; border-bottom: 1px solid #cccccc;"> 
				        <input type="text" name="title" maxlength="100" style="height: 27px; width: 930px; border: 1px solid #cccccc;" value="${dto.title}">
				      </td>
				  </tr>		  
			
				  <tr align="left" height="300"> 
				      <td style="width: 100px; background: white; color: #424242; border-bottom: 1px solid #cccccc; text-align: center; padding-top:10px;" valign="middle">내 용</td>
				      <td valign="top" style="padding:20px 0px 20px 10px; border-bottom: 1px solid #cccccc;"> 
				        <textarea name="content" id="content" rows="12" class="boxTA" style="width: 95%; resize: none;">${dto.content}</textarea>
				      </td>
				  </tr>      
				</tbody>  
				</table>
				
			<table class="boardtable" style="margin-left: 320px; background: white; margin-top: 35px;">
			     <tr height="45"> 
			      <td align="center" >
			        <button type="submit" class="boardBtn">${mode=='update'?'수정완료':'등록하기'}</button>
			        <button type="reset" class="boardBtn">다시입력</button>
			        <button type="button" class="boardBtn" onclick="javascript:location.href='<%=cp%>/news/list';">${mode=='update'?'수정취소':'등록취소'}</button>
			        <c:if test="${mode=='update'}">
			         	 <input type="hidden" name="newsNum" value="${dto.newsNum}">
			        	 <input type="hidden" name="page" value="${page}">
			        </c:if>
			      </td>
			    </tr>
			  </table>
			</form>
        </div>

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

