<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<link href="css/init.css" rel="stylesheet">
<link href="css/main.css" rel="stylesheet">
<link href="css/goods.css" rel="stylesheet">
<meta charset="UTF-8">
<title>MAIN</title>
<c:if test="${not empty success }">
	<script type="text/javascript">
		alert("${success}")
	
	</script>
	<%
		session.removeAttribute("success");
	%>
</c:if>
</head>


<body>
	<header id="header">
		<!-- gnb/ 로그인정보관련 -->
		<jsp:include page="common/top.jsp" flush="true" />
		
		<!-- 로고 -->
		<div class="logo">메인 화면입니다</div>
		
		<!-- lnb/ 메뉴바 -->
		<jsp:include page="common/menu.jsp" flush="true"/>

	</header>
	
	<!-- ------------------------------------------------- -->
	<div id="content">
		<div class="main_visual">
			<img src="images/banner/main_banner.png">
		</div>
		
		<jsp:include page="goods/goodsList.jsp" flush="true"/>
	</div>
	
	<footer id="footer">
		<div class="footer_border">
	        <ul class="foot_menu">
	            <li>회사 소개</li>
	            <li class="small"> | </li>
	            <li>회원 약관</li>
	            <li class="small"> | </li>
	            <li>멤버십 이용</li>
	            <li class="small"> | </li>
	            <li>약관 멤버십 안내</li>
	            <li class="small"> | </li>
	            <li>개인 정보 처리 방침</li>
	        </ul>
	    </div>
	    
	    <div class="foot_bot">
	    	<div class="foot_logo">
	        </div>
	        
	        <ul class="copyright">
	        	<li><span>주소:</span> 서울특별시 서초구 서초대로 38길 12 <span>대표:</span> team3</li>
	            <li><span>사업자 등록 번호:</span> 119-19-xxxxx 통신 판매 신고 번호: 제 2022-00xxx호</li>
	            <li><span>개인 정보 보호 책임자:</span> 홍길동</li>
	            <li><span>문의 전화:</span> 080-xxx-1234 FAX: 02-xxxx-1234</li>
	            <li><span>메일:</span> cs@team3.co.kr / wedmaster@team3.co.kr</li>
	            <li>COPYRIGHTⓒ 2022 TEAM3 ALL RIGHTS RESERVED.</li>
	        </ul>
	        
	    </div>
	</footer>
</body>
</html>