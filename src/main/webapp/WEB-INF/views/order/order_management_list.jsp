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
		/* clear: both; */
		overflow: hidden;
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
		font-weight: bold;
		color: #603B1E;
	}
	.bundleOrNot {
		display: none;	
	}
</style>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
	$(function() {
		// 전체 선택
		$("#checkAll").click(function() {
			var chk = this.checked;
			$(".ckb").each(function(idx, data) {
				this.checked = chk;
			});
		});
		
		// 승인 버튼
		$("button[id^='pass']").click(function() {
			var num = this.id.replace("pass-", "");	// 해당하는 주문 번호
			
			// 테이블에 열 추가하여 승인됨으로 표시
			$.ajax({
				type:"post", 
				url:"ManagerCheck/changeOrderstate", 
				dataType:"text", 
				data:{
					"num":num, 
					"o_state":"pass"
				}, 
				success:function(data, status, xhr) {
					console.log("success")
					
					// $(this).parents().filter("ul").css("background-color", "#FCDD09");	// 배경색 변경

					// 체크박스 및 버튼 비활성화
					console.log($(this).parent().siblings().get(0));
				}, 
				error:function(xhr, status, error) {
					console.log(error);
				}
			});
		});
		
		// 보류 버튼
		$("button[id^='return']").click(function() {
			var num = this.id.replace("return-", "");	// 해당하는 주문 번호
			
			// 테이블에서 삭제
			$.ajax({
				type:"post", 
				url:"ManagerCheck/changeOrderstate", 
				dataType:"text", 
				data:{
					"num":num, 
					"o_state":"return"
				}, 
				success:function(data, status, xhr) {
					console.log("success")
					
					// $(this).parents().filter("ul").remove();	// 화면에서도 삭제
				}, 
				error:function(xhr, status, error) {
					console.log(error);
				}
			});
		});
	});
</script>

<!-- 리스트 -->
<div>
	<p>주문 내역 리스트</p>
	
	<div class="orderInfo">
		<!-- 표 헤더 -->
		<ul>
			<li style="width:40px;">
				<input type="checkbox" id="checkAll">
			</li>
			<li>주문 번호</li>
			<li>주문자</li>
			<li style="width:240px;">상품 정보</li>
			<li style="width:120px;">번들</li>
			<li>옵션</li>
			<li>수량</li>
			<li>전체 수량</li>
			<li style="width:120px;">가격 총합</li>
			<li>승인/보류</li>
		</ul>

		<!-- 주문 내역 -->
		<div style="overflow:auto;height:500px;">
			<!-- 반복 시작 -->
			<c:forEach var="oiDTO" items="${oList}" varStatus="status">
				<ul id="order-${oiDTO.num}" style="border-top:lightgray 1px solid;">
					<li style="width:40px;">
						<input type="checkbox" class="ckb" id="cb-${oiDTO.num}">
					</li>
					<li>
						${oiDTO.num}
					</li>
					<li>
						${oiDTO.userid}
					</li>
					<li style="width:240px;">
						<span class="gcodeArea">${oiDTO.gcode}</span><br>
						${oiDTO.gname}
					</li>
					<li style="width:120px;">
						${oiDTO.bcategory}
						<span class="bundleOrNot">
							<c:choose>
								<c:when test="${fn:contains(oiDTO.bcategory, '도매')}">	<!-- 도매품 -->
									bundle
								</c:when>
								<c:otherwise>	<!-- 소매품 -->
									not bundle
								</c:otherwise>
							</c:choose>
						</span>
					</li>
					<li>
						${oiDTO.vcategory}
					</li>
					<li>
						${oiDTO.gamount}
					</li>
					<li>
						<c:choose>
							<c:when test="${fn:contains(oiDTO.bcategory, '도매')}">
								<c:set var="bcat" value="${oiDTO.bcategory}" />	<!-- 도매품의 전체 수량 -->
								<%
									String bcat = (String) pageContext.getAttribute("bcat");
									int totalAmount = Integer.parseInt(bcat.replaceAll("[\\D]", ""));
									pageContext.setAttribute("totalAmount", totalAmount);
								%>
								${oiDTO.gamount * totalAmount}
							</c:when>
							<c:otherwise>	<!-- 소매품 수량 -->
								<span style="color:lightgray;">〃</span>
							</c:otherwise>
						</c:choose>
					</li>
					<li style="width:120px;">
						${oiDTO.gprice * oiDTO.gamount}
					</li>
					<li>
						<%-- 드롭박스로 바꾸고 승인 여부에 따라 옵션 선택 --%>
						${osList[status.index].o_state}<br>
						<button id="pass-${oiDTO.num}">승인</button>
						<button id="return-${oiDTO.num}">보류</button>
					</li>
				</ul>
			</c:forEach>
			<!-- 반복 끝 -->
		</div>
	</div>
	
	<div>
		<button id="">모두 승인</button>
		<button id="">모두 보류</button>
	</div>
</div>