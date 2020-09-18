<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%
	String cp = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Mamp Connect</title>

<link rel="stylesheet" href="<%=cp%>/resource/css/normalize.css" type="text/css">
<link rel="stylesheet" href="<%=cp%>/resource/css/style.css" type="text/css">
<link rel="stylesheet" href="<%=cp%>/resource/css/layout.css" type="text/css">
<link rel="stylesheet" href="<%=cp%>/resource/css/footer.css" type="text/css">
<link rel="stylesheet" href="<%=cp%>/resource/css/board.css" type="text/css">
<link rel="stylesheet" href="<%=cp%>/resource/jquery/css/smoothness/jquery-ui.min.css" type="text/css">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.10.1/css/all.css">

<script type="text/javascript" src="<%=cp%>/resource/jquery/js/jquery.min.js"></script>
<script type="text/javascript" src="<%=cp%>/resource/js/util-jquery.js"></script>
<script type="text/javascript" src="<%=cp%>/resource/js/util.js"></script>

</head>

<body>
	<div id="wrap">
		<div class="header">
			<tiles:insertAttribute name="header" />
		</div>
	
		<div class="sidebar">
			<tiles:insertAttribute name="sidebar" />
		</div>
	
		<div class="container">
			<tiles:insertAttribute name="body" />
		</div>
		
		<div class="footer">
			<tiles:insertAttribute name="footer" />
		</div>
	
	<!-- 	<div id="loadingLayout" style="display: none; position: absolute; left: 0; top: 0; width: 100%; height: 100%; z-index: 9000; background: #eeeeee;">
			<i id="loadingImage" class="fa fa-cog fa-spin fa-fw" style="font-size: 70px; color: 333;"></i>
		</div> -->
	
		<script type="text/javascript" src="<%=cp%>/resource/jquery/js/jquery-ui.min.js"></script>
		<script type="text/javascript" src="<%=cp%>/resource/jquery/js/jquery.ui.datepicker-ko.js"></script>
	</div>
	
</body>
</html>