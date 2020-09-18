<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>

<link rel="stylesheet" href="<%=cp%>/resource/css/community.css" type="text/css">
<script type="text/javascript" src="<%=cp%>/resource/se/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">
//clone을 사용하는 경우
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

  <c:if test="${mode=='update'}">
  function deleteFile(fileNum) {
		var url="<%=cp%>/community/deleteFile";
		$.post(url, {fileNum:fileNum}, function(data){
			$("#f"+fileNum).remove();
		}, "json");
  }
</c:if>
</script>

<script type="text/javascript">
    function check() {
        var f = document.communityForm;

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

    	f.action="<%=cp%>/community/${mode}";
		
    	return true;
    }
 
</script>

<script type="text/javascript">
$(document).ready(function(){
   var fileTarget = $('.filebox .upload-hidden');

    fileTarget.on('change', function(){
        if(window.FileReader){
            // 파일명 추출
            var filename = $(this)[0].files[0].name;
        } 

        else {
            // Old IE 파일명 추출
            var filename = $(this).val().split('/').pop().split('\\').pop();
        };

        $(this).siblings('.upload-name').val(filename);
    });

    //preview image 
    var imgTarget = $('.preview-image .upload-hidden');

    imgTarget.on('change', function(){
        var parent = $(this).parent();
        parent.children('.upload-display').remove();

        if(window.FileReader){
            //image 파일만
            if (!$(this)[0].files[0].type.match(/image\//)) return;
            
            var reader = new FileReader();
            reader.onload = function(e){
                var src = e.target.result;
                parent.prepend('<div class="upload-display"><div class="upload-thumb-wrap"><img src="'+src+'" class="upload-thumb"></div></div>');
            }
            reader.readAsDataURL($(this)[0].files[0]);
        }

        else {
            $(this)[0].select();
            $(this)[0].blur();
            var imgSrc = document.selection.createRange().text;
            parent.prepend('<div class="upload-display"><div class="upload-thumb-wrap"><img class="upload-thumb"></div></div>');

            var img = $(this).siblings('.upload-display').find('img');
            img[0].style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(enable='true',sizingMethod='scale',src=\""+imgSrc+"\")";        
        }
    });
});
</script>


<div class="container">
    <div class="board-container" style="margin-left: 200px;">
        <div class="body-title" style="font-size: 18px;">
            <h3><i class="fas fa-satellite-dish"></i>&nbsp;&nbsp;커뮤니티 </h3>
        </div>  
        
        <div class="board-body" style="float: left; width: 20%;">	      
	        	<div style="margin-top: 20px; margin-left: 20px;">	        	
	           		<button type="button" style="width: 220px; height: 50px; background: #9565A4; color: white; font-size: 25px; border: none; border-radius: 10px;" onclick="javascript:location.href='<%=cp%>/community/list';"><i class="fas fa-list"></i></button>
	           	</div>   
        </div>
        
        <div class="board-created" style="margin-top: 20px;">
         <div class="body-title" style="margin-bottom: 10px;">
          		  <h3 style="font-size: 20px;">| 글쓰기 </h3>
         </div>
         
			<form name="communityForm" method="post" enctype="multipart/form-data" onsubmit="return submitContents(this);">
			  <table class="boardtable" style="margin-left: 5px; ">
			  <tbody id="tb">
			  	  <tr align="left" height="50" > 
			  	     <td style="width: 100px; background: white; color: #424242; text-align: center; border-bottom: 1px solid #cccccc;">T O .</td>
				      <td style="color: #424242; background: white; text-align: left; padding-left: 10px; border-bottom: 1px solid #cccccc;">				      
			      		<select name="clubCode" style="width: 200x; text-align: center; background: white; height: 30px; border-radius: 4px; border: 1px solid #cccccc;">
			      		 <c:forEach var="dto" items="${listClub}"> 
			      		 	<option value="${dto.clubCode}">${dto.clubType}</option>			
			     		</c:forEach>		     				     	
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
				        <textarea name="content" id="content" rows="12" class="boxTA" style="width: 95%;">${dto.content}</textarea>
				      </td>
				  </tr>  
				  
				  <tr align="left" height="50"> 
				      <td style="width: 100px; background: white; color: #424242; text-align: center; padding-top: 10px; padding-bottom: 10px; border-bottom: 1px solid #cccccc;">첨부</td>
				      <td style="padding-left:10px; padding-top: 10px; padding-bottom: 10px; border-bottom: 1px solid #cccccc;"> 
				      	<div class="filebox">				       
				          <input class="upload-name" value="파일 선택" disabled="disabled">
				          <label for="ex_filename">업로드</label>
				          <input type="file" id="ex_filename" class="upload-hidden" name="upload" class="boxTF" size="53" style="width: 95%; height: 25px;">
				        </div>
				       </td>
			  	  </tr> 
			  	  
			  	   <c:if test="${mode=='update'}">
				   <c:forEach var="vo" items="${listFile}">
						  <tr id="f${vo.fileNum}" height="40" style="border-bottom: 1px solid #cccccc;"> 
						      <td style="width: 100px; text-align: center;">첨부된파일</td>
						      <td style="padding-left:10px;"> 
								<a href="javascript:deleteFile('${vo.fileNum}');"><i class="far fa-trash-alt"></i></a> 
								${vo.originalFilename}
						      </td>
						  </tr>
				   </c:forEach>
				</c:if>				
             	 </tbody>          
			  </table>			  
			
			  <table class="boardtable" style="margin-left: 320px; background: white; margin-top: 35px;">
			     <tr height="45"> 
			      <td align="center" >
			        <button type="submit" class="boardBtn">${mode=='update'?'수 정':'등 록'}</button>
			        <button type="reset" class="boardBtn2">다시입력</button>
			      	 <c:if test="${mode=='update'}">
			         	 <input type="hidden" name="commuNum" value="${dto.commuNum}">
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
/* 		oEditors.getById["content"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);  */
	},
	fCreator: "createSEditor2"
});

function pasteHTML() {
	/* var sHTML = "<span style='color:#FF0000;'>이미지도 같은 방식으로 삽입합니다.<\/span>"; */
	oEditors.getById["content"].exec("PASTE_HTML", [sHTML]);
}

function showHTML() {
	var sHTML = oEditors.getById["content"].getIR();
	alert(sHTML);
}
	
function submitContents(elClickedObj) {
	oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);	
	// 에디터의 내용이 textarea에 적용됩니다.
	
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

