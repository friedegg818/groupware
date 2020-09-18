<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>

<script type="text/javascript" src="<%=cp%>/resource/se/js/HuskyEZCreator.js" charset="utf-8"></script>

<script type="text/javascript">
    function sendOk() {
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
    <div class="board-container">
        <div class="body-title">
            <h3>♬ 커뮤니티 만들기 </h3>
        </div>
        
        <div class="board-created">
			<form name="clubForm" method="post">
			  <table class="boardtable" style="margin: 20px auto 0px; ">
			  <tbody id="tb">
				  <tr align="left" height="40"> 
				      <td width="100"  style="text-align: center;">동호회 코드</td>
				      <td style="padding-left:10px;"> 
				          <input class="inputnoline" type="text" name="clubCode" maxlength="100">
				      </td>
				  </tr>
				  
				  <tr align="left" height="50" > 
				      <td width="100" bgcolor="#eeeeee" style="text-align: center;">동호회 이름</td>
				      <td style="padding-left:10px;"> 
				        <input class="inputnoline" type="text" name="clubType" maxlength="100">
				      </td>
				  </tr>		
				  
				   <tr align="left" height="50" > 
				      <td width="100" bgcolor="#eeeeee" style="text-align: center;">동호회 설명</td>
				      <td style="padding-left:10px;"> 
				        <input class="inputnoline" type="text" name="clubExp" maxlength="100">
				      </td>
				  </tr>					  
		
             	 </tbody>              
				
			  </table>			  
			
			  <table>
			     <tr height="45"> 
			      <td align="center" >
			        <button type="submit" class="boardBtn" onclick="sendOk()">커뮤니티 만들기</button>
			        <button type="reset" class="boardBtn">다시입력</button>
			        <button type="button" class="boardBtn" onclick="javascript:location.href='<%=cp%>/community/list';">만들기 취소</button>
			     </td>
			    </tr>
			  </table>
			</form>
        </div>

    </div>
</div>
