<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 주문 관리 - 주문 내역 자세히보기 -->

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- 스타일시트 -->
<style>
	span {
		padding-right: 30px;
	}
	
	#orderinfo li {
		list-style: none;
		padding: 5px;
	}
	
	.subTitle {
		margin: 15px 0;
	}
	
	.glabel {
		display:inline-block;
		width: 70px; height:100%;
	}
	
	#reisUpdate {
		margin-top: 5px;
		width: 70px; height: 35px;
	}
	
	.gcodeArea {
		font-weight: bold;
		color: #603B1E;
	}
</style>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
	$(function() {
		// 라디오 버튼 선택에 따라 자세한 반려 사유 입력창 활성화/비활성화
		$("input:radio").each(function(idx, ele) {
			$(ele).click(function() {
				if (this.value == "null") {	// 직접 입력할 경우
					$("#re_issue_detail").val("");
					$("#re_issue_detail").removeAttr("readonly");
				} else {	// 그 외
					$("#re_issue_detail").val(this.value);
					$("#re_issue_detail").attr("readonly", "readonly");
				}
			});
		});
		
		// 반려 사유 업데이트
		$("#reisUpdate").click(function() {
			var num = $("#num").val();
			var re_issue = $(".re_issue:checked").val();
			if (re_issue == "null")	// 직접 입력했을 경우 해당 입력값을 가져옴
				re_issue = $("#re_issue_detail").val();
			// console.log(num, re_issue);	// 확인용
			
			$.ajax({
				type:"post", 
				url:"ManagerCheck/updateReIssue", 
				dataType:"text", 
				data:{
					"num":num, 
					"re_issue":re_issue
				}, 
				success:function(data, status, xhr) {
					console.log("success");
				}, 
				error:function(xhr, status, error) {
					console.log(error);
				}
			});
		});
	});
</script>

<!-- 주문 세부사항 -->
<div>
	<p>주문 세부사항</p>
	
	<div id="orderinfo">
		<div style="width:80%">
			<!-- 주문 번호, 주문자, 주문 일자 -->
			<div style="margin-left:15px;width:80%;border-bottom:solid 1px #cecece">
				<h2 style="color:#603B1E;">
					주문 ${oiDTO.num}
				</h2>
				<input type="hidden" id="num" value="${oiDTO.num}">
			</div>
			<div style="float:right;margin-right:200px;">
				${oiDTO.orderday}
			</div>
			<c:if test="${oiDTO.userid != '비회원'}">
				<div style="margin:10px 15px;border:1px black;">
					주문자 ID: ${oiDTO.userid}
				</div>
			</c:if>

			<!-- 주문 상태 -->
			<div style="margin-left:25px;">
				<h4 class="subTitle">주문 상태 ┃</h4>
				
				<ul>
					<li>
						<p style="font:20px bold;color:#603B1E;">
							<c:choose>
								<c:when test="${empty osDTO.o_state}">
									미승인
								</c:when>
								<c:when test="${osDTO.o_state == 'pass'}">
									승인
								</c:when>
								<c:when test="${osDTO.o_state == 'return'}">
									반려
								</c:when>
								<c:when test="${osDTO.o_state == 'deliver'}">
									배송중
								</c:when>
								<c:when test="${osDTO.o_state == 'complete'}">
									배송완료
								</c:when>
							</c:choose>
						</p>
					</li>
					<li>
						<span class="glabel" style="position:relative;top:-50px;">
							반려 사유
							<button id="reisUpdate">저장</button>
						</span>
						<span style="display:inline-block;margin-right:-20px;">
							<input type="radio" class="re_issue" name="re_issue" value="재고부족"> 재고부족<br>
							<input type="radio" class="re_issue" name="re_issue" value="주문취소"> 주문취소<br>
							<input type="radio" class="re_issue" name="re_issue" value="회원탈퇴"> 회원탈퇴<br>
							<input type="radio" class="re_issue" name="re_issue" value="주소지 이상"> 주소지 이상<br>
							<input type="radio" class="re_issue" name="re_issue" value="null" checked="checked"> 직접입력: 
						</span>
						<span style="display:inline-block;">
							<textarea id="re_issue_detail" placeholder="200자 이내" maxlength="200" style="resize:none;width:360px;height:90px;padding:5px;">${osDTO.re_issue}</textarea>
						</span>
						<%--
						<span>
							<textarea id="" placeholder="주문 반려 사유 (200자 이내)" maxlength="200" style="resize:none;padding:5px;"></textarea>
						</span>
						--%>
					</li>
				</ul>
			</div>

			<!-- 주문 정보 -->
			<div style="padding:20px;float:left;width:30%;">
				<!-- 이미지 처리 -->
				<c:forTokens var="token" items="${oiDTO.gimage}" delims="." varStatus="status">
					<c:if test="${status.last}">
						<c:choose>
							<c:when test="${token eq 'jpg' || token eq 'gif' || token eq 'png' || token eq 'bmp'}">
								<li><img src="images/${oiDTO.gimage}" border="0" align="center" width="300" /></li>
							</c:when>
							<c:otherwise>
								<li><img src="images/${oiDTO.gimage}.jpg" border="0" align="center" width="300" /></li>
							</c:otherwise>
						</c:choose>
					</c:if>
				</c:forTokens>
			</div>
			<div style="width:50%;float:left;">
				<h4 class="subTitle">주문 상품 ┃</h4>
				
				<ul>
					<li>
						<span class="glabel">상품코드</span>
						<span class="gcodeArea">
							${oiDTO.gcode}
						</span>
					</li>
					<li>
						<span class="glabel">상품명</span>
						<span>
							${oiDTO.gname}
						</span>
					</li>
					<li>
						<span class="glabel">가격</span>
						<span>
							${oiDTO.gprice}
						</span>
					</li>
					<li>
						<span class="glabel">배송비</span>
						<span>무료배송</span>
						<%-- <span style="font-size: 0.8em;"> (도서 산간지역 별도 배송비 추가)</span> --%>
					</li>
					<li>
						<span class="glabel">상품옵션</span>
						<span>
							${oiDTO.vcategory}
						</span>
					</li>
					<li>
						<span class="glabel">번들</span>
						<span>
							${oiDTO.bcategory}
						</span>
					</li>
					<li>
						<span class="glabel">전체 수량</span>
						<span>
							<c:choose>
								<c:when test="${fn:contains(oiDTO.bcategory, '도매')}">
									<c:set var="bcat" value="${oiDTO.bcategory}" />	<!-- 도매품의 전체 수량 -->
									<%
										String bcat = (String) pageContext.getAttribute("bcat");
										int totalAmount = Integer.parseInt(bcat.replaceAll("[\\D]", ""));
										pageContext.setAttribute("totalAmount", totalAmount);
									%>
									${oiDTO.gamount * totalAmount}
									<span style="font-size:12px;">(${totalAmount} × ${oiDTO.gamount})</span>
								</c:when>
								<c:otherwise>	<!-- 소매품 수량 -->
									<span style="color:#603B1E;">
										${oiDTO.gamount}
									</span>
								</c:otherwise>
							</c:choose>
						</span>
					</li>
					<li>
						<span class="glabel">가격 총합</span>
						<span>
							${oiDTO.gprice * oiDTO.gamount}원
						</span>
					</li>
					<li>
						<span class="glabel">결제 방식</span>
						<span>
							${oiDTO.paymethod}
						</span>
					</li>
				</ul>
			</div>
			
			<!-- 배송 정보 -->
			<div style="margin-left:25px;">
				<h4 class="subTitle" style="clear:both;border-top:#603B1E 1px;">배송 정보 ┃</h4>
				
				<ul>
					<li>
						<span class="glabel">수령인</span>
						<span>
							${oiDTO.ordername}
						</span>
					</li>
					<li>
						<span class="glabel" style="position: relative;top:-42px;">배송지</span>
						<span style="display:inline-block;">
							(${osDTO.post})<br>
							${osDTO.addr1}<br>
							${osDTO.addr2}
						</span>
					</li>
					<li>
						<span class="glabel">연락처</span>
						<span>
							0${oiDTO.phone1}-${oiDTO.phone2}-${oiDTO.phone3}
						</span>
					</li>
					<li>
						<span class="glabel">배송업체</span>
						<span>
							우체국택배
							<%-- ${osDTO.delivery_co} --%>
						</span>
					</li>
				</ul>
				
				<div style="margin:30px 0;text-decoration:underline;cursor:pointer;">
					<a onclick="history.back();">뒤로가기</a>
				</div>
			</div>
		</div>
	</div>
</div>