<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- 주문 세부사항 화면 -->

<!DOCTYPE html>
<html>
<head>
<link href="css/init.css" rel="stylesheet">
<link href="css/main.css" rel="stylesheet">
<meta charset="UTF-8">
<title>Management - Order</title>
</head>
<body>
	<header id="header">
		<!-- gnb/ 로그인정보관련 -->
		<jsp:include page="common/top.jsp" flush="true" />
		
		<!-- 로고 -->
		<div class="logo">주문 관리 화면입니다</div>
		
		<!-- lnb/ 메뉴바 -->
		<jsp:include page="common/menu.jsp" flush="true"/>

	</header>
	
	<!-- ------------------------------------------------- -->
	<jsp:include page="order/order_detail.jsp" flush="true" />
</body>
</html>