<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 상품 주문 완료 화면 뷰 -->

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style type="text/css">
	table {
		width:100%;
		border-spacing:5px;
		border-collapse:separate;
		cursor:default;
	}
	
	#goodsInfo #goodsValues td {
		padding:0 20px;
		text-align:center;
	}
	
	#payInfo th {
		padding-left:30px;
		text-align:left;
	}

	#payInfo td {
		text-align:right;
	}
</style>

<div style="cursor:default;">
	<div style="text-align:center;">
		<h3><b>주문 완료</b></h3>
		
		<c:if test="${oiDTO.userid ne '비회원'}">	<!-- 비회원 주문의 경우, 아이디를 출력하지 않음 -->
			<b>${oiDTO.userid}</b> 님의 
		</c:if>
		주문이 안전하게 처리되었습니다.
	</div>
	
	<br>
	
	<div>
		<h3>상품 및 배송 정보</h3>
	
		<table id="goodsInfo">
			<!-- 구분선 -->
			<tr><td colspan="4"><hr></td></tr>
			
			<tr>
				<th>상품 정보</th>
				<th>판매가</th>
				<th>수량</th>
				<th>합계</th>
			</tr>
			
			<!-- 구분선 -->
			<tr><td colspan="4"><hr></td></tr>
			
			<tr id="goodsValues">
				<td style="text-align:left;">
					${oiDTO.gname} 
					<c:if test="${not empty oiDTO.vcategory}">	<!-- 상품 옵션 정보가 없을 경우 -->
						(${oiDTO.vcategory})
					</c:if>
					<c:if test="${oiDTO.bcategory ne '소매품'}">	<!-- 도매품일 경우, 묶음 정보 표시 -->
						<br>
						${bDTO.bcategory}
					</c:if>
				</td>
				<td>${oiDTO.gprice}</td>
				<td>${oiDTO.gamount}</td>
				<td id="totalPrice1">
					<c:if test="${oiDTO.bcategory ne '소매품'}">	<!-- 도매품일 경우의 가격 총합 -->
						${bDTO.bprice * oiDTO.gamount}원
					</c:if>
					<c:if test="${oiDTO.bcategory eq '소매품'}">	<!-- 소매품일 경우의 가격 총합 -->
						${oiDTO.gprice * oiDTO.gamount}원
					</c:if>
				</td>
			</tr>
			
			<tr><td colspan="4"><hr></td></tr>
		</table>
		
		<br>
		
		<table id="placeInfo">
			<tr><td colspan="2"><hr></td></tr>
			
			<tr>
				<th>수취인</th>
				<td>${oiDTO.ordername}</td>
			</tr>
			
			<tr><td colspan="2"><hr></td></tr>
			
			<tr>
				<th>배송지</th>
				<td>
					${oiDTO.addr1}<br>${oiDTO.addr2} (${oiDTO.post})
				</td>
			</tr>
			
			<tr><td colspan="2"><hr></td></tr>
			
			<tr>
				<th>연락처</th>
				<td>
					${oiDTO.phone1}-${oiDTO.phone2}-${oiDTO.phone3}
				</td>
			</tr>
			
			<tr><td colspan="2"><hr></td></tr>
		</table>
	</div>
	
	<br>
	
	<div>
		<h3>결제 정보</h3>
		
		<table id="payInfo">
			<!-- 구분선 -->
			<tr><td colspan="2"><hr></td></tr>
			
			<tr>
				<th>결제 금액</th>
				<td style="padding-right:30px;">
					<c:if test="${oiDTO.bcategory ne '소매품'}">	<!-- 도매품일 경우의 가격 총합 -->
						${bDTO.bprice * oiDTO.gamount}원
					</c:if>
					<c:if test="${oiDTO.bcategory eq '소매품'}">	<!-- 소매품일 경우의 가격 총합 -->
						${oiDTO.gprice * oiDTO.gamount}원
					</c:if>
				</td>
			</tr>
			
			<tr><td colspan="2"><hr></td></tr>
			
			<tr>
				<th>결제 수단</th>
				<td style="padding-right:30px;">${oiDTO.paymethod}</td>
			</tr>
			
			<!-- 구분선 -->
			<tr><td colspan="2"><hr></td></tr>
		</table>
	</div>
	
	<p style="margin:30px auto;text-align:center;"><a href="goodsList?gcategory=coffee">메인으로 돌아가기</a></p>
</div>