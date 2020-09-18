<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	String cp=request.getContextPath();
%>

<table style="margin: 7px auto 0px; width: 100%; border-spacing: 0px; border-radius: 5px; padding-top: 10px;">
		  <tr height="30"> 
		     <td style="text-align: left; border-top: 1px solid #cccccc; font-size: 14px; padding-left: 5px;"> 
		  		<span id="schedulerStartDate"></span> ~ <span id="schedulerEndDate"></span>
		  	</td>
		      <td style="text-align: right; border-top: 1px solid #cccccc; font-size: 14px; padding-right: 5px;"> 
		          	   작성자 : <span id="schedulerName"></span>
		      </td>
		  </tr>	

		  <tr height="40"> 
		      <td colspan="2" style="font-size: 17px; border-bottom: 1px solid #cccccc; padding: 7px 5px; padding-top: 2px; font-weight: 600;"> 
                    [<span id="schedulerCategory"></span>] <span id="schedulerTitle"></span>
              </td>
		  </tr>
		  
	<!-- 	  <tr height="40"> 
		      <td width="100" style="font-weight:600; padding-right:15px; text-align: right;">종일일정&nbsp;&nbsp;|</td>
		      <td> 
		        	<span id="schedulerAllDay"></span>
		      </td>
		  </tr> -->
		 
		  <tr height="230"> 
		      <td colspan="2" style="vertical-align: middle; border-bottom: 1px solid #cccccc; padding-left: 7px;"> 
		           <div id="schedulerContent" style="height: 60px; line-height:100%; white-space: pre; padding-top: 10px; overflow: auto;"></div>
		      </td>
		  </tr>
</table>
