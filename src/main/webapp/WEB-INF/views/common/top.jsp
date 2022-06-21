<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<!-- 상단 메뉴 바 -->

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- 로그인되어있을 때 -->
<c:if test="${not empty login}">
	<nav class="gnb">
		<div class="gnb_box">
			<ul class="gnb_menu">
				<span id="span_user2">${login.username}님</span>
				<span id="span_user">(${login.userid})</span>
				<span><a href="logout">로그아웃</a></span>
				<span><a href="mypage">마이페이지</a></span>
				<span><a href="loginCheck/cartList">장바구니</a></span>
				<c:if test="${login.usercode == 10}">
					<!-- 관리자 페이지 -->
					<span><a href="ManagerCheck/CtrlGoods">상품 관리</a></span>
					<span><a href="ManagerCheck/goodsinsert">상품 등록</a></span>
					<span><a href="ManagerCheck/orderManagement">주문 관리</a></span>
				</c:if>
			</ul>
		</div>
	</nav>
</c:if>


<!-- 로그인되어있지 않을 때 -->
<c:if test="${empty login}">
	<nav class="gnb">
		<div class="gnb_box">
			<ul class="gnb_menu">
				<span><a href="loginForm">로그인</a></span>
				<span><a href="memberForm">회원가입</a></span>
			</ul>
		</div>
	</nav>
</c:if>