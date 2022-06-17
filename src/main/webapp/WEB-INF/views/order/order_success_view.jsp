<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 상품 주문 완료 화면 뷰 -->

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page import="com.dto.OrderinfoDTO" %>

<!-- 회원/비회원 및 도/소매 여부 체크 -->
<%
	int usercode = 0;	// 0: 비회원, 20: 일반 회원, 30: 사업자-소매, 35: 사업자-도매
	boolean bundle = false;	// false: 소매, true: 도매
	int bundleAmount = Integer.parseInt(session.getAttribute("bundle").toString());	// 도매 묶음 개수

	// 로그인 여부
	if (session.getAttribute("login") != null) {
		usercode = 20;

		// 사업자 회원의 도/소매 여부
		OrderinfoDTO oiDTO = (OrderinfoDTO) session.getAttribute("oiDTO");
		if (!oiDTO.getBcategory().equals("소매품")) {
			if (!oiDTO.getBcategory().contains("단품")) {	// 도매
				bundle = true;
			
				usercode = 35;
			} else	// 소매
				usercode = 30;
		}
	}
%>
<c:set var="usercode" value="<%= usercode %>" />
<c:set var="bundle" value="<%= bundle %>" />
<c:set var="bundleAmount" value="<%= bundleAmount %>" />

<%-- 확인용 --%>
<%-- 
<c:choose>
	<c:when test="${usercode == 0}">
		<p>비회원</p>
	</c:when>
	<c:when test="${usercode == 20}">
		<p>일반 회원</p>
	</c:when>
	<c:when test="${usercode == 30}">
		<p>사업자 회원 - 소매</p>
	</c:when>
	<c:when test="${usercode == 35}">
		<p>사업자 회원 - 도매</p>
	</c:when>
</c:choose>
 --%>

<!-- 스타일시트 -->
<style type="text/css">
	div {
		clear: both;
	}

	ul {
		clear: both;
		list-style: none;
	}
	
	li {
		float: left;
		margin: 0 10px;
	}
	
	.goodsInfo li {
		float: left;
		margin: 10px 5px;
		
		text-align: center;
		width: 100px;
	}
</style>

<div>
	<ul><li>주문 완료</li></ul>
	
	<ul>
		<li>
			<c:if test="${usercode != 0}">	<!-- 비회원 주문의 경우, 아이디를 출력하지 않음 -->
				<b>${oiDTO.userid}</b> 님의 
			</c:if>
			주문이 안전하게 처리되었습니다.
		</li>
	</ul>
</div>
<br>
	
<div style="width:50%;"><hr></div>	<!-- 구분선 -->
	
<div><ul><li>상품 및 배송 정보</li></ul></div>
	
<div class="goodsInfo">
	<ul>
		<li style="width:300px;">상품 정보</li>
		<li>판매가</li>
		<li>수량</li>
		<li>합계</li>
	</ul>
	
	<ul>
		<li style="width:300px;">
			${oiDTO.gname} 
			<c:if test="${not empty oiDTO.vcategory}">	<!-- 상품 옵션 정보가 없을 경우, 옵션 정보를 출력하지 않음 -->
				(${oiDTO.vcategory})
			</c:if>
			<c:if test="${usercode == 35}">	<!-- 도매품일 경우, 묶음 정보 표시 -->
				<br>
				${bDTO.bcategory}
			</c:if>
		</li>
		<li>
			${oiDTO.gprice}
		</li>
		<li>
			${oiDTO.gamount}
		</li>
		<li>
			<c:choose>
				<c:when test="${usercode == 35}">	<!-- 도매품일 경우의 가격 총합 -->
					${bDTO.bprice * bundleAmount * oiDTO.gamount}원						
				</c:when>
				<c:otherwise>	<!-- 그 외 가격 총합 -->
					${oiDTO.gprice * oiDTO.gamount}원
				</c:otherwise>
			</c:choose>
		</li>
	</ul>
</div>
<br>

<div style="width:50%;"><hr></div>	<!-- 구분선 -->

<!-- 배송지 및 연락처 -->
<div>
	<ul>
		<li>수취인</li>
		<li>
			${oiDTO.ordername}
		</li>
	</ul>

	<ul>
		<li>배송지</li>
		<li>
			${oiDTO.addr1}<br>${oiDTO.addr2} (${oiDTO.post})
		</li>
	</ul>

	<ul>
		<li>연락처</li>
		<li>
			${oiDTO.phone1}-${oiDTO.phone2}-${oiDTO.phone3}
		</li>
	</ul>
</div>
<br>
	
<div style="width:50%;"><hr></div>	<!-- 구분선 -->
	
<div><ul><li>결제 정보</li></ul></div>
	
<div>
	<ul>
		<li>결제 금액</li>
		<li>
			<c:choose>
				<c:when test="${usercode == 35}">	<!-- 도매품일 경우의 가격 총합 -->
					${bDTO.bprice * bundleAmount * oiDTO.gamount}원 (묶음 가격)
				</c:when>
				<c:otherwise>	<!-- 그 외 가격 총합 -->
					${oiDTO.gprice * oiDTO.gamount}원
				</c:otherwise>
			</c:choose>
		</li>
	</ul>

	<ul>
		<li>결제 수단</li>
		<li>
			${oiDTO.paymethod}
		</li>
	</ul>
</div>
	
<div style="width:50%;"><hr></div>	<!-- 구분선 -->

<p style="margin:30px auto;"><a href="goodsList?gcategory=coffee">[ 메인으로 돌아가기 ]</a></p>
