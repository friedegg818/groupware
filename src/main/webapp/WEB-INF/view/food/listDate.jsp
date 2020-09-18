<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String cp = request.getContextPath();
%>

<link rel="stylesheet" href="<%=cp%>/resource/css/tabs.css" type="text/css">

 <div id="food-detail" >
		<form name="foodDetail-Form">
			<c:forEach var="dto" items="${list}">
			<table style="width: 80%; margin:0 auto 10px; margin-top: 10px; border-spacing: 0px; background: ${dto.subject=='LUNCH'? '#975A97' : (dto.subject=='DINNER'? '#632A7E': '#A13297')}; border-radius: 5px;">
			  <tr  height="20">
			  		<td  style="padding: 10px 0 10px 25px;">
			  			<span style="color: white"><i class="fas fa-asterisk"></i>&nbsp;</span>
						<span style="font-size: 18px; font-weight: 700; color: white;"> ${dto.subject=='LUNCH'? '점심' : (dto.subject=='DINNER'? '저녁': '간식')} </span>
						<span>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<c:if test="${sessionScope.employee.empNo=='10001'}">			      
				        	<button type="button" class="btn" id="btnFoodDelete"  onclick="deleteOk('${dto.foodNum}');"><i class="far fa-trash-alt" style="font-size: 14px; color: white;"></i></button>
			        	</c:if>
			        	</span>
					</td>
			  </tr>	

			  <tr height="45">
			      <td style="padding: 0 0 5px 40px;">
			        <p style="margin-bottom: 5px; font-family: NanumSquareRound; color: white; font-size: 15px; padding-left: 10px;">${dto.content}</p>
			      </td>
			  </tr>
			  
			</table>
			 </c:forEach> 

		</form>
    </div>

