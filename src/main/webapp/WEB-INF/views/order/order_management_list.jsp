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
	}
	
	.orderInfo li {
		float: left;
		margin: 10px 5px;
		
		text-align: center;
		width: 80px;
	}
	
	.order_row:hover {
		background: #FCDD09;
	}
	
	.noHref {
		padding: 15px 0;
	}
	
	.ckb {
		weidth: 50px; height: 50px;
	}
	
	.gcodeArea {
		font-weight: bold;
		color: #603B1E;
	}
	
	.bundleOrNot {
		display: none;	
	}
	
	.re_issue_isNull {
		display: none;
		/* width: 15px; height: 15px; */
		color: red;
		font-weight: bold;
	}
	
	.o_state_select {
		height: 30px;
	}
</style>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
	$(function() {
		// 주문 상태 이슈 표시(*) 보이기/가리기
		$(".re_issue_isNull").each(function(idx, ele) {
			var num = ele.id.replace("reisnull-", "");
			var o_state = $("#o_state-" + num + " option:selected").val();
			var re_issue = $("#reis-" + num).val();
			
			showHideIssue(ele, o_state, re_issue);
		});
		
		/************/
		
		// 전체 선택
		$("#checkAll").click(function() {
			var chk = this.checked;
			$(".ckb").each(function(idx, ele) {
				this.checked = chk;
			});
		});
		
		// 화면 이동 방지
		$(".noHref").click(function(event) {
			event.preventDefault();
		});
		
		// 주문 상태 변경 버튼
		$("button[id^='staup']").click(function() {
			var num = this.id.replace("staup-", "");	// 해당하는 주문 번호
			var o_state = $("#o_state-" + num + " option:selected").val();
			// console.log(num, "-", o_state)	// 확인용
			
			
			// 테이블에 열 추가하여 승인됨으로 표시
			$.ajax({
				type:"post", 
				url:"ManagerCheck/changeOrderstate", 
				dataType:"text", 
				data:{
					"num":num, 
					"o_state":o_state
				}, 
				success:function(data, status, xhr) {
					console.log("success:", num, o_state);
					
					sessionStorage.setItem("osList", data);
					$("#o_state-" + num + " option").each(function(idx, ele) {
						if (ele.value == o_state) 
							ele.setAttribute("selected", "selected");
						else
							ele.removeAttribute("selected");
					});
					
					// 상태 이슈 표시(*) 보이기/가리기
					showHideIssue(document.getElementById("reisnull-" + num), 
							o_state, 
							$("#reis-" + num).val());
					
					// 배송까지 완료 시, 드롭박스 및 상태 변경 버튼 비활성화
					if (o_state == "complete") {
						$("#o_state-" + num).attr("disabled", "disabled");
						$("#staup-" + num).attr("disabled", "disabled");
					}
				}, 
				error:function(xhr, status, error) {
					console.log(error);
				}
			});
		});
		
		// 선택한 주문 모두 승인하기
		$("#passAll").click(function() {
			
		});
		
		// 선택한 주문 모두 반려하기
		$("#returnAll").click(function() {
			
		});
		
		// 선택한 주문 내역 삭제하기
		$("#deleteSelectedOrder").click(function() {
			
		});
		
		/************/
		
		// 주문 상태 이슈 표시 (*) 보이기/가리기
		function showHideIssue(icon_ele, o_state, re_issue) {
			// console.log(icon_ele, o_state, re_issue);	// 확인용
			
			switch (o_state) {
				// 보일 때: 미승인 및 사유 없는 반려
				case "null": 
					icon_ele.setAttribute("style", "display:inline;");
					break;
				case "return":
					if (re_issue.length < 1)
						icon_ele.setAttribute("style", "display:inline;");
					break;
				// 가릴 때: 그 외
				case "pass": 
				case "deliver": 
				case "complete": 
				default: 
					icon_ele.setAttribute("style", "display:none;");
					break;
			}
		}
	});
</script>

<!-- 리스트 -->
<div>
	<p>주문 내역 리스트</p>
	
	<%--
	<div>
		<ul>
			<li style="float:right;">
				<button id="passAll">모두 승인</button>
				<button id="returnAll">모두 반려</button><br>
			</li>
		</ul>
	</div>
	--%>
	
	<div class="orderInfo">
		<!-- 표 헤더 -->
		<ul>
			<li style="width:30px;">
				<input type="checkbox" id="checkAll">
			</li>
			<li>주문 번호</li>
			<li>주문자</li>
			<li>주문일자</li>
			<li style="width:240px;">상품 정보</li>
			<li style="width:160px;">번들</li>
			<li>옵션</li>
			<li>전체 수량</li>
			<li style="width:160px;">가격 총합</li>
			<li style="width:160px;">상태</li>
		</ul>

		<!-- 주문 내역 -->
		<div style="overflow:auto;height:500px;">
			<!-- 반복 시작 -->
			<c:forEach var="oiDTO" items="${oiList}" varStatus="status">
				<a href="ManagerCheck/orderDetail?num=${oiDTO.num}" class="order_row">
					<ul id="order-${oiDTO.num}" title="주문 상세 보기" style="border-top:#cecece 1px solid;">
						<li style="width:30px;">
							<input type="checkbox" id="cb-${oiDTO.num}" class="ckb">
						</li>
						<li>
							${oiDTO.num}
						</li>
						<li>
							${oiDTO.userid}
						</li>
						<li>
							<span style="font-size:12px;">${oiDTO.orderday}</span>
						</li>
						<li style="width:240px;">
							<span class="gcodeArea">${oiDTO.gcode}</span><br>
							${oiDTO.gname}
						</li>
						<li style="width:160px;">
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
									${oiDTO.gamount}
								</c:otherwise>
							</c:choose>
						</li>
						<li style="width:160px;">
							${oiDTO.gprice * oiDTO.gamount}
						</li>
						<li class="noHref" style="width:160px;">
							<span id="reisnull-${oiDTO.num}" class="re_issue_isNull">*</span>
							<input type="hidden" id="reis-${oiDTO.num}" value="${osList[status.index].re_issue}">	<!-- 반려 사유 -->
							<select id="o_state-${oiDTO.num}" class="o_state_select">
								<option value="null" <c:if test="${osList[status.index].o_state == ''}">selected="selected"</c:if>>미승인</option>
								<option value="pass" <c:if test="${osList[status.index].o_state == 'pass'}">selected="selected"</c:if>>승인</option>
								<option value="return" <c:if test="${osList[status.index].o_state == 'return'}">selected="selected"</c:if>>반려</option>
								<option value="deliver" <c:if test="${osList[status.index].o_state == 'deliver'}">selected="selected"</c:if>>배송중</option>
								<option value="complete" <c:if test="${osList[status.index].o_state == 'complete'}">selected="selected"</c:if>>배송완료</option>
							</select>
							<button id="staup-${oiDTO.num}" <c:if test="${osList[status.index].o_state == 'complete'}">disabled="disabled"</c:if>>변경</button>
						</li>
					</ul>
				</a>
			</c:forEach>
			<!-- 반복 끝 -->
		</div>
	</div>
	
	<%--
	<div>
		<button id="deleteSelectedOrder">주문 내역 삭제</button>
	</div>
	--%>
</div>