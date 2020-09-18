<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String cp = request.getContextPath();

	Date nowDate = new Date();
	SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
%>
<style>
* {
	padding: 0px;
	margin: 0px;
	font-size: 13px;
}

input {
	border: 1px solid gray;
	height: 30px;
	padding-left: 10px;
	border-radius: 5px;
}

textarea {
	border: 1px solid gray;
	width: 900px;
	height: 500px;
	padding-left: 10px;
	border-radius: 5px;
}

.body { 
	width: 100%;
	margin-bottom: 10px;
}

.headLineTr {
	height: 100px;
	text-align: center;
}

.headLineTd {
	text-align: center;
}

.pTag {
	font-size: 40px;
	font-weight: 900;
	padding: 60px;
}

.bodyDiv {
	border-collapse: collapse;
	border: none;
}

.leftMenu {
	float: left;
	width: 30%;
}

.leftMenu table {
	width: 100%;
	border-collapse: collapse;
	border: 1px solid black;
}

.leftMenu tr {
	border: 1px solid black;
}

.leftMenu tr td {
	height: 35px;
	border-left: 1px solid black;
}

.rightMenu {
	float: right;
	width: 15%;
	height: 150px;
}

.rightMenu table {
	width: 100%;
	border-collapse: collapse;
}

.rightMenu tr {
}

.rightMenu tr td {
	border:1px solid black;
	padding-left: 5px;
	padding-top: 5px;
	padding-bottom: 5px;
}

#lineDiv1{
	width:150px;
	height:150px;
	float: right;
}
#lineDiv2{
	width:150px;
	height:150px;
	float: right;
}
#lineDiv3{
	width:150px;
	height:150px;
	float: right;
}
#lineDiv4{
	width:150px;
	height:150px;
}

.content {
	width: 100%;
	border-collapse: collapse;
	border: 1px solid black;
	margin-bottom: 10px;
}

.content tr {
	border: 1px solid black;
}

.content tr td {
	border-left: 1px solid black;
	padding-top: 5px;
	padding-bottom: 5px;
}

.contentDiv {
	padding: 3px;
}

.lineModal {
	display: none;
	background-color: #FFFFFF;
	position: absolute;
	border: 2px solid #E2E2E2;
	z-Index: 9999
}

.checkFini{
	margin:auto; 
	border: 1px solid red; 
	border-radius:180px; 
	width: 50px; 
	height: 50px; 
	vertical-align: middle;
	line-height: 50px;
}

.ui-widget-header {
	background: none;
	border: none;
	font-size: 20px;
	border-bottom: 1px solid #cccccc;
	margin-bottom: 10px;
}

.ui-button .ui-icon {
	border: none;
}
</style>

<form method="post" name="inputForm" id="inputForm" enctype="multipart/form-data" style="width: 980px; margin: auto;">
	<input type="hidden" class="hiddenSnum" id="hiddenSnum" value="${sNum}">
	<input type="hidden" name="option" value="1">
	<input type="hidden" name="modes" value="${modes}">
	<input type="hidden" name="option" value="1">
	<table class="body" style="text-align: center;">
		<tr class="headLineTr">
			<td class="headLineTd" colspan="4">
			<div class="returnMemoDiv" style=" position: absolute ; ${listVal == null ? 'display:none' : ' ' };">
				<input type="hidden" class="hiddenWriter" value="${writer.empNo}">
					<c:if test="${listVal == null}">
						<textarea  class="returnTxADiv" rows="5" cols="10" placeholder="반려사유를 작성해주세요" style="width: 350px; height: 100px; resize: none;
								padding-top: 5px;"></textarea>
						<br><button type="button" class="returnMemo">반려하기</button>
					</c:if>
					<c:if test="${listVal != null}">
					<div style=" float: left; border: 1px solid black; margin-top: 10px; width: 300px; height: 125px; padding-top: 5px; border: none; color: #EB5A5A; font-weight: bold; font-size: 20px;">
						반려 사유
						<textarea class="returnTxADiv" rows="4" cols="8" placeholder="" style="color: #EB5A5A; margin-top: 10px; width: 290px; height: 80px; border: none; font-size: 15px; resize: none;" readonly="readonly">: ${dto.rreason}</textarea>
					</div>
					</c:if>
			</div>
			<p class="pTag">업 무 기 안</p>
			</td>
		</tr>
		<tr>
			<td class="menus"></td>
		</tr>
		<tr>
			<td>
				<div class="leftMenu">
					<table>
						<tr>
							<td style="width: 30%; background: #DDDDDD;"><b>기안자</b></td>
							<c:if test="${mode!='article'}">
								<td>${sessionScope.employee.name}</td>
							</c:if>
							<c:if test="${mode=='article'}">
								<td>${writer.name}</td>
							</c:if>	
						</tr>
						<tr>
							<td style="background: #DDDDDD"><b>소속</b></td>
							<c:if test="${mode!='article'}">
								<td>${sessionScope.employee.dType}</td>
							</c:if>
							<c:if test="${mode=='article'}">
								<td>${writer.dType}</td>
							</c:if>	
						</tr>
						<tr>
							<td style="background: #DDDDDD"><b>기안일</b></td>
							<c:if test="${mode=='article'}">
								<td class="sdayTd">
									${dto.sdate}</td>
							</c:if>
							<c:if test="${mode!='article'}">
								<td><%=sf.format(nowDate)%></td>
							</c:if>
						</tr>
						<tr>
							<td style="background: #DDDDDD"><b>문서번호</b></td>
							<td>-</td>
						</tr>
					</table>
				</div>
				<div class="rightMenu" id="lineDiv4">
					<input type="hidden" value="4" name="lineDivChild">
					<table style="width: 150px;">
						<tr>
							<td class="typeTd" style="height: 17px; width: 1000px;">
							${ mode=="article" ? pempNo4.dType : " " } ${ mode=="article" ? " | " : " "} ${ mode=="article" ? pempNo4.pType : " " }</td>
						</tr>
						<tr>
							<td class="nameTd" style="width: 210px; height: 80px;">
							<c:if test="${mode=='article'}">
									<c:choose>
								<c:when test="${dto.scurrStep > 3 }">
									<span style=" position:absolute; z-index:200; top:38px; left:60px; ">${pempNo4.name}</span>
									<span style="color: #B7BDE2; position:absolute; z-index:100; top:15px; left:27px; background-position: center center ; font-size: 20px;"><i class="far fa-check-circle fa-3x"></i></span>
								</c:when>
								<c:otherwise>
									<span>${pempNo4.name}</span>								
								</c:otherwise>
							</c:choose>
							</c:if>
								<input type="hidden" id="pempNo4" value="${pempNo4.empNo}">
							</td>
						</tr>
						<tr>
							<td style="height: 20px;"><c:if test="${empty mode || modes=='임시보관함'}">
									<button type="button" class="btnLine" style="font-weight: bold; width: 20px; height: 20px; background: none;">+</button>
								</c:if> <c:if test="${not empty mode}">
									<p id="btnLine">
										<c:if test="${dto.scurrStep == 3}">
											<c:if test="${pempNo4.empNo == sessionScope.employee.empNo}">
												<button type="button" class="choiceBtn"
													style="font-weight: bold" value="ok">승인</button>
												<button type="button" class="choiceBtn"
													style="font-weight: bold" value="no">반려</button>
											</c:if>
										</c:if>
										<c:if test="${dto.scurrStep > 3 }">
										<p>결재완료</p>
										</c:if>
									</p>
								</c:if> <input type="hidden" name="lineEmp4" id="lineEmp4" value="0">
							</td>
						</tr>
					</table>
				</div>
				<div class="rightMenu" id="lineDiv3">
					<input type="hidden" value="3" name="lineDivChild">
					<table style="width: 150px;">
						<tr>
							<td class="typeTd" style="height: 17px; width: 1000px; border-right: none;"><span>
							${ mode=="article" ? pempNo3.dType : " "} ${ mode=="article" ? " | " : " "} ${ mode=="article" ? pempNo3.pType : " " }</span></td>
							
						</tr>
						<tr>
							<td class="nameTd" style="width: 210px; height: 80px; border-right: none; margin: 10px auto; position: relative;">
							<c:if test="${mode=='article'}">
							<c:choose>
								<c:when test="${dto.scurrStep > 2 }">
									<span style=" position:absolute; z-index:200; top:38px; left:60px; ">${pempNo3.name}</span>
									<span style="color: #B7BDE2; position:absolute; z-index:100; top:15px; left:47px; background-position: center center ; font-size: 20px;"><i class="far fa-check-circle fa-3x"></i></span>
								</c:when>
								<c:otherwise>
									<span>${pempNo3.name}</span>								
								</c:otherwise>
							</c:choose>
							</c:if>
								<input type="hidden" id="pempNo3" value="${pempNo3.empNo}">
							</td>
							
						</tr>
						<tr>
							<td style="height: 20px; border-right: none;">
							<c:if test="${empty mode || modes=='임시보관함'}">
									<button type="button" class="btnLine" style="font-weight: bold; width: 20px; height: 20px; background: none;">+</button>
								</c:if> <c:if test="${not empty mode}">
									<p id="pTageLine">
										<c:if test="${dto.scurrStep == 2}">
											<c:if test="${pempNo3.empNo == sessionScope.employee.empNo}">
												<button type="button" class="choiceBtn"
													style="font-weight: bold" value="ok">승인</button>
												<button type="button" class="choiceBtn"
													style="font-weight: bold" value="no">반려</button>
											</c:if>
										</c:if>
										<c:if test="${dto.scurrStep > 2 }">
										<p>결재완료</p>
										</c:if>
									</p>
								</c:if> <input type="hidden" name="lineEmp3" id="lineEmp3" value="0">
							</td>
						</tr>
					</table>
				</div>
				<div class="rightMenu" id="lineDiv2">
					<input type="hidden" value="2" name="lineDivChild">
					<table style="width: 150px;">
						<tr>
							<td class="typeTd" style="height: 17px; border-right: none;">
							${ mode=="article" ? pempNo2.dType : " " } ${ mode=="article" ? " | " : " "} ${ mode=="article" ? pempNo2.pType : " " }</td>
						</tr>
						<tr>
							<td class="nameTd" style="height: 80px; border-right: none; margin: 10px auto; position: relative;">
							<c:if test="${mode=='article'}">
								<c:choose>
								<c:when test="${dto.scurrStep > 1 }">
									<span style=" position:absolute; z-index:200; top:38px; left:60px; ">${pempNo2.name}</span>
									<span style="color: #B7BDE2; position:absolute; z-index:100; top:15px; left:47px; background-position: center center ; font-size: 20px;"><i class="far fa-check-circle fa-3x"></i></span>
								</c:when>
								<c:otherwise>
									<span>${pempNo2.name}</span>								
								</c:otherwise>
							</c:choose>
							</c:if>
								<input type="hidden" id="pempNo2" value="${pempNo2.empNo}">
							</td>
						</tr>
						<tr>
							<td style="height: 20px; border-right: none;"><c:if test="${empty mode || modes=='임시보관함'}">
									<button type="button" class="btnLine" style="font-weight: bold; width: 20px; height: 20px; background: none;">+</button>
								</c:if> <c:if test="${not empty mode}">
									<p id="btnLine">
										<c:if test="${dto.scurrStep == 1}">
											<c:if test="${pempNo2.empNo == sessionScope.employee.empNo}">
												<button type="button" class="choiceBtn"
													style="font-weight: bold" value="ok">승인</button>
												<button type="button" class="choiceBtn"
													style="font-weight: bold" value="no">반려</button>
											</c:if>
										</c:if>
										<c:if test="${dto.scurrStep > 1 }">
											<p>결재완료</p>
										</c:if>
									</p>
								</c:if> <input type="hidden" name="lineEmp2" id="lineEmp2" value="0">
							</td>
						</tr>
					</table>
				</div>
		<div class="rightMenu" id="lineDiv1">
			<input type="hidden" value="1" name="lineDivChild">
			<table style="width: 150px;">
				<tr>
					<td rowspan="3"
						style="background: #DDDDDD; width: 70px; text-align: left;"><b>결재</b></td>
					<td class="typeTd" style="height: 17px; width: 1000px; border-right: none; text-align: center;">
					${ mode=="article" ? writer.dType : sessionScope.employee.dType } | ${ mode=="article" ? writer.pType : sessionScope.employee.pType }
					</td>
				</tr>
				<tr>
					<td class="nameTd" style="width: 210px; height: 80px; border-right: none;">${ mode=="article" ? writer.name : sessionScope.employee.name}
					</td>
				</tr>
				<tr>
					<td height="20px;" style="border-right: none;">
						<p>확인</p> <input type="hidden" name="lineEmp1" value="0">
					</td>
				</tr>
			</table>
		</div>
	</table>
	
	<div class="contentDiv">
		<table class="content">
			<tbody  id="tb">
			<tr>
				<td style="width: 100px; background: #DDDDDD; text-align: center; "><b>시행일자</b></td>
				<c:if test="${mode == 'article'}">
					<c:if test="${modes == null }">
						<td style="width: 50%;" style="padding-left: 10px;" >
							<input type="text" id="startDay" name="startDay" value="${dto.startDay}" disabled="disabled" style="outline: 0; border: none; background: none;">
						</td>
					</c:if>
					<c:if test="${modes == '임시보관함' }">
						<td style="width: 50%;" style="padding-left: 10px;" >
							<input type="text" id="startDay" name="startDay" value="${dto.startDay}" style="outline: 0; background: none;">
						</td>
					</c:if>
				</c:if>
				<c:if test="${mode != 'article'}">
					<td style="width: 50%; padding-left: 10px;" >
						<input type="date" id="startDay" name="startDay" style="outline: 0;">
					</td>
				</c:if>
				<td style="background: #DDDDDD; text-align: center;" width="100px;"><b>시행 부서</b></td>
				<td>
					<input type="text" id="sDept" value="${mode == 'article' ? writer.sdept : sessionScope.employee.dType }"
					 disabled="disabled" style="border: none; background: none;">
				</td>
			</tr>
			<tr>
				<td style="background: #DDDDDD; text-align: center;"><b>제목</b></td>
				<td colspan="3"> 
				<c:if test="${mode == 'article'}">
					<c:if test="${modes == null }">				
						<input type="text" id="sSubject" name="ssubject" value="${mode == 'article' ? dto.ssubject : ''}" disabled="disabled"
							style="width: 800px; border: none; outline: 0; background: none;">
					</c:if>	
					<c:if test="${modes == '임시보관함' }">		
						<input type="text" id="sSubject" name="ssubject" value="${mode == 'article' ? dto.ssubject : ''}" style="width: 800px; outline: 0; background: none;">
					</c:if>	
				</c:if>
				<c:if test="${mode != 'article'}">
					<input style="width: 800px; margin-left: 10px; outline: 0; background: none;" type="text" id="sSubject" name="ssubject" value="${mode == 'article' ? dto.ssubject : ''}">
				</c:if>
				</td>
			</tr>
			<tr>
				<td style="background: #DDDDDD; text-align: center; " colspan="4"><b>내용</b></td>
			</tr>
			<tr>
				<td colspan="4" style="padding-left: 30px; padding-top: 10px;">
				<c:if test="${mode == 'article'}">
					<c:if test="${modes == null }">
						<textarea rows="12"cols="50" style="outline: 0; border:none; width: 900px; height: 420px; resize: none; background: none;" id="sContent" name="scontent" disabled="disabled">${dto.scontent}</textarea>
					</c:if>
					<c:if test="${modes == '임시보관함' }">
						<textarea rows="12"cols="50" style="outline: 0; border:none; width: 900px; height: 420px; resize: none; background: none;" id="sContent" name="scontent">${dto.scontent}</textarea>
					</c:if>
				</c:if>
				<c:if test="${mode != 'article'}">
					<textarea rows="12"cols="50" style="outline: 0; width: 900px; height: 420px; resize: none; background: none;" id="sContent" name="scontent"></textarea>
				</c:if>
				</td>
			</tr>
		<c:if test="${mode != 'article'}">
			<tr>
				<td style="text-align:center; background: #DDDDDD;"><b>첨부</b></td>
				<td colspan="3" style="padding-left: 10px;">
					<input type="file" id="upload" name="upload" style="padding-top: 13px; border: none; outline: 0;" multiple="multiple">
				</td>
			</tr>
		</c:if>
		<c:if test="${modes == '임시보관함'}">
				<c:forEach var="vo" items="${listFile}">
					<tr id="f${vo.sfNum}" height="40px;" style="border-bottom: 1px solid #cccccc;">
					<td style="text-align:center; background: #DDDDDD;"><b>첨부</b></td>
						<td colspan="3" style="padding-left:10px;">
							<a href="<%=cp%>/sign/download?sfNum=${vo.sfNum}">${vo.sfOriginalFilename}</a> 
							<input type="hidden" name="originals" value="${vo.sfOriginalFilename}">
							<input type="hidden" name="saves" value="${vo.sfSaveFilename}">
						</td>
					</tr>
				</c:forEach>
		</c:if>
		<c:if test="${mode == 'article' && modes != '임시보관함'}">
				<c:forEach var="vo" items="${listFile}">
					<tr id="f${vo.sfNum}" height="40px;" style="border-bottom: 1px solid black;">
					<td style="text-align:center; background: #DDDDDD;"><b>첨부</b></td>
						<td colspan="3" style="padding-left:10px;">
							<a href="<%=cp%>/sign/download?sfNum=${vo.sfNum}">${vo.sfOriginalFilename}</a> 
						</td>
					</tr>
				</c:forEach>
		</c:if>
		</table>
	</div>
	<c:if test="${mode != 'article' }">
			<button type="button" style="float: right; height: 25px; padding: 5px; margin-top: 10px;" onclick="check();">등록하기</button>
			<button type="button" style="float: right; height: 25px; margin-right: 10px; padding: 5px; margin-top: 10px;" onclick="javascript:location.href='<%=cp%>/sign/mainList'">목록</button>
			&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" value="storage" id="sStorage" name="sStorage" style="zoom:1.25; margin-top: -1px;"><span style="margin-top: 10px; font-size: 15px; float: left;">임시보관여부</span>
	</c:if>
	<c:if test="${mode == 'article' && modes == '임시보관함'}">
			<button type="button" style="float: right; height: 25px; padding: 5px; margin-top: 10px;" onclick="check();">등록하기</button>
			<button type="button" style="float: right; height: 25px; margin-right: 10px; padding: 5px; margin-top: 10px;" onclick="javascript:location.href='<%=cp%>/sign/mainList'">목록</button>
			&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" value="storage" id="sStorage" name="sStorage" style="zoom:1.25; margin-top: -1px;"><span style="margin-top: 10px; font-size: 15px; float: left;">임시보관여부</span>
	</c:if>
</form>



<!-- 크리에이트 모달 -->
<div id="lineModal-dialog" class="lineModal">
	<div class="listDiv">
		<table id="listTable" class="listTable" style="width: 580px;">
			<tr style="background: #9565A4; color: white; font-weight: bold; height: 30px; text-align: center;">
				<td style="width: 50px;">선택</td>
				<td style="width: 140px;">부서</td>
				<td style="width: 140px;">직급</td>
				<td style="width: 250px;">이름</td>
			</tr>
			<c:forEach var="dto" items="${list}">
				<tr style="text-align: center;">
					<td><input type="checkbox" name="cb" value="${dto.empNo}"></td>
					<td><input type="hidden" name="hDType" value="${dto.dType}">${dto.dType}</td>
					<td><input type="hidden" name="hPType" value="${dto.pType}">${dto.pType}</td>
					<td><input type="hidden" name="hName" value="${dto.name}">${dto.name}</td>
				</tr>
			</c:forEach>
		</table>
		<button type="button" id="btnLineSelectOk" class="close" style="float: right; height: 30px; width: 50px; margin-top: 20px; background: #9565A4; color: white; font-weight: bold;">선택</button>
	</div>
</div>