<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 상품 주문 완료 페이지 -->

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<link href="css/init.css" rel="stylesheet">
<link href="css/main.css" rel="stylesheet">
<meta charset="UTF-8">
<title>Insert title here</title>

<c:if test="${not empty success}">
	<script type="text/javascript">alert("${success}")</script>
	<% session.removeAttribute("success"); %>
</c:if>

</head>
<body>
	<header id="header">
		<!-- gnb/ 로그인정보관련 -->
		<jsp:include page="common/top.jsp" flush="true" />
		
		<!-- 로고 -->
		<div class="logo">주문완료 화면입니다</div>
		
		<!-- lnb/ 메뉴바 -->
		<jsp:include page="common/menu.jsp" flush="true"/>

	</header>
	
	<!-- ------------------------------------------------- -->
	<jsp:include page="order/order_success_view.jsp" flush="true" />
</body>
</html>