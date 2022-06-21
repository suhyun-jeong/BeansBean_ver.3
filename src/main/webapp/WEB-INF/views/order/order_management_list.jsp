<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 주문 관리 - 주문 내역 리스트 뷰 -->

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

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
	
	.orderInfo li {
		float: left;
		margin: 10px 5px;
		
		text-align: center;
		width: 80px;
	}
	
	.gcodeArea {
		color: purple;
	}
	.bundleOrNot {
		display: none;	
	}
</style>

<!-- 리스트 -->
<div>
	<p>주문 내역 리스트</p>
	
	<div class="orderInfo">
		<!-- 표 헤더 -->
		<ul>
			<li>
				<input type="checkbox" id="checkAll">
				선택
			</li>
			<li>주문 번호</li>
			<li>주문자</li>
			<li style="width:240px;">상품 정보</li>
			<li>번들</li>
			<li>옵션</li>
			<li>판매가</li>
			<li>수량</li>
			<li>전체 수량</li>
			<li>총합</li>
			<li>승인/보류</li>
		</ul>

		<!-- 주문 내역 -->
		<c:forEach var="oDTO" items="${orderList}" varStatus="status">
			<ul id="order-${oDTO.num}">
				<li>
					<input type="checkbox" class="ckb" id="cb-${oDTO.num}">
				</li>
				<li>
					${oDTO.num}
				</li>
				<li>
					${oDTO.userid}
				</li>
				<li style="width:240px;">
					<span class="gcodeArea">${oDTO.gcode}</span><br>
					${oDTO.gname}
				</li>
				<li>
					${oDTO.bcategory}
					<span class="bundleOrNot">
						<c:choose>
							<c:when test="${fn:contains(oDTO.bcategory, '도매')}">	<!-- 도매품 -->
								bundle
							</c:when>
							<c:otherwise>	<!-- 소매품 -->
								not bundle
							</c:otherwise>
						</c:choose>
					</span>
				</li>
				<li>
					${oDTO.vcategory}
				</li>
				<li>
					${oDTO.gprice}
				</li>
				<li>
					${oDTO.gamount}
				</li>
				<li>
					<%-- ${oDTO.gamount} --%>
					전체수량
				</li>
				<li>
					${oDTO.gprice * oDTO.gamount}
				</li>
				<li>
					<button id="pass-${oDTO.num}">승인</button>
					<button id="defer-${oDTO.num}">보류</button>
				</li>
			</ul>
		</c:forEach>
	</div>
</div>