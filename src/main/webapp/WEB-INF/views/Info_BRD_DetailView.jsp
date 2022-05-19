<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link href="css/init.css" rel="stylesheet">
<link href="css/main.css" rel="stylesheet">
<meta charset="UTF-8">
<title>Info_BRD_DetailView</title>
</head>
<body>
<h1>사업자 게시판 자세히보기</h1>
	<hr>

	<header id="header">
		<!-- gnb/ 로그인정보관련 -->
		<jsp:include page="common/top.jsp" flush="true" />
		
		<!-- 로고 -->
		<div class="logo">사업자게시판 자세히보기 화면입니다</div>
		
		<!-- lnb/ 메뉴바 -->
		<jsp:include page="common/menu.jsp" flush="true"/>

	</header>
	
	<!-- ------------------------------------------------- -->
	<jsp:include page="boards/Info_BRD_DetailView.jsp" flush="true"></jsp:include><br>
	
</body>
</html>