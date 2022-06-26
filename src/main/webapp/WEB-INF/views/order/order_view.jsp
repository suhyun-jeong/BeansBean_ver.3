<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 상품 한 개 주문 뷰 -->

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page import="com.dto.CartDTO" %>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<!-- 회원/비회원 및 도/소매 여부 체크 -->
<%
	int usercode = 0;	// 0: 비회원, 20: 일반 회원, 30: 사업자-소매, 35: 사업자-도매
	boolean bundle = false;	// false: 소매, true: 도매

	// 로그인 여부
	if (session.getAttribute("login") != null) {
		usercode = 20;
	
		// 사업자 회원의 도/소매 여부
		CartDTO cDTO = (CartDTO) request.getAttribute("cDTO");
		if (!cDTO.getBcategory().equals("소매품")) {
			if (!cDTO.getBcategory().contains("단품")) {	// 도매
				bundle = true;
				usercode = 35;
			} else	// 소매
				usercode = 30;
		}
	}
%>
<c:set var="usercode" value="<%= usercode %>" />
<c:set var="bundle" value="<%= bundle %>" />

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

<script type="text/javascript">
	$(function() {
		var bCategory = "<c:out value='${cDTO.bcategory}' />";	// 도매 묶음 (= 번들)
		var gPrice = parseInt($("#price").text());	// 상품 가격: 도매 가격 or 소매 가격
		var gAmount = parseInt($("#gamount").val());	// 상품 수량
		var bundleInt = 1;	// 번들 수량 기본값 1
		
		console.log(bCategory)	// 확인용
		
		// 번들에서 숫자 및 단위 추출
		if (!bCategory.includes("소매품") && !bCategory.includes("단품")) {	// 도매 품목일 경우
			bCategory = "<c:out value='${bDTO.bcategory}' />"
			// console.log(bCategory)	// 확인용
			
			bundleInt = parseInt(bCategory.replaceAll("[^\\d]", ""));	// 번들에서 숫자만 추출
			var bundleUnit = bCategory.replace(bundleInt.toString(), "").trim();	// 번들에서 단위 추출
			
			$("#bUnit").text("(" + bundleUnit + ")");	// 번들 단위 화면에 출력
		}
		$("#bTotal").text(gAmount * bundleInt);	// 전체 수량 화면에 출력	
		$("#totalPrice").text(gPrice * gAmount);	// 총합 출력
		
		
		// 수량 입력창에 숫자만 받기
		$("#gamount").keyup(function(event) {	// 숫자 외의 값을 입력하면 입력창 초기화
			if (!((event.keyCode >= 48 && event.keyCode <= 57)	// 0~9가 아닐 경우
					|| (event.keyCode >= 96 && event.keyCode <= 105))) {	// Num Lock 키패드 0~9가 아닐 경우
				if (event.keyCode == 8 || event.keyCode == 46) {	//  backspace or delete
					if ($("#gamount").val().length < 1) {	// 입력창이 비었을 경우 출력 초기화
						$("#bTotal").text(0);
						$("#totalPrice").text(0);
					}
				} else if (event.keyCode == 13	// enter
						|| (event.keyCode >= 37 && event.keyCode <= 40))	// 방향키
					return true;
				else	// 그 외
					$("#gamount").val(0);	// 입력창 초기화
			}
			
			if ($("#gamount").val().length > 0) {
				$("#bTotal").text(parseInt(this.value) * bundleInt);	// 전체 수량 화면에 출력
				$("#totalPrice").text(gPrice * $("#gamount").val());	// 총합 출력
			}
		});
		
		
		// 계정에 저장된 배송지 정보 사용하기
		$("#same1").click(function() {
			var checked = this.checked;
			
			if (checked) {	// 체크되었을 때
				$(".userAddress").each(function(idx, ele) {
					var input = $(".inputPlace").get(idx);
					input.value = this.value;
					input.setAttribute("readonly", "readonly");
				});
				$("#postBtn").attr("disabled", "disabled");
			} else {	// 체크 해제
				$(".inputPlace").each(function(idx, ele) {
					this.value = "";
					this.removeAttribute("readonly");
				});
				$("#postBtn").removeAttr("disabled");
			}
		});
		
		// 계정에 저장된 연락처 정보 사용하기
		$("#same2").click(function() {
			var checked = this.checked;
			
			if (checked) {	// 체크되었을 때
				$(".userPhone").each(function(idx, ele) {
					if (idx == 0) {	// select
						$("#phone1").val(this.value).prop("selected", true);
						$("#phone1").attr("readonly", "readonly");
					} else {	// input text
						var input = $(".inputPhone").get(idx);
						input.value = this.value;
						input.setAttribute("readonly", "readonly");
					}
				});
			} else {	// 체크 해제
				$(".inputPhone").each(function(idx, ele) {
					this.value = "";
					this.removeAttribute("readonly");
				});
			}
		});
		
		
		// 빈칸 검사
		$("form").submit(function(event) {
			// 상품 수량 입력란 확인
			if ($("#gamount").val().length < 1 || $("#gamount").val() == 0 || isNaN($("#gamount").val())) {
				alert("상품 수량을 확인해주세요.");
				$("#gamount").focus();
				return false;
			}
			
			// 배송지 및 연락처 입력란 확인
			var inputCheck = true;
			$("input[class^=input]").each(function(idx, ele) {
				if (this.value.length < 1)
					inputCheck = false;
			});
			if ($("#phone1").val() == null)
				inputCheck = false;
			
			// 경고창 표시
			if (!inputCheck)
				alert("모든 칸을 채워주세요.");

			return inputCheck;
		});
	});
</script>

<form action="oneGoodsOrder" method="post">
	<!-- hidden data -->
	<input type="hidden" name="num" value="${cDTO.num}">
	<input type="hidden" name="userid" value="${cDTO.userid}">
	<input type="hidden" name="gcode" value="${cDTO.gcode}">
	<input type="hidden" name="gname" value="${cDTO.gname}">
	<input type="hidden" name="bcategory" value="${cDTO.bcategory}">
	<input type="hidden" name="vcategory" value="${cDTO.vcategory}">
	<input type="hidden" id="gprice" name="gprice" value="<c:choose>
		<c:when test="${usercode == 35}">${bDTO.bprice}</c:when>
		<c:otherwise>${cDTO.gprice}</c:otherwise>
	</c:choose>">
	<input type="hidden" name="gimage" value="${cDTO.gimage}">


	<div><ul><li>주문 상품 확인</li></ul></div>
	
	<!-- 사업자 회원 - 도매 -->
	<c:if test="${usercode == 35}">
		<div class="goodsInfo">
			<ul>
				<li>주문 번호</li>
				<li style="width:300px;">상품 정보</li>
				<li>번들</li>
				<li>옵션</li>
				<li>판매가</li>
				<li>수량</li>
				<li>전체 수량</li>
			</ul>
		
			<ul>
				<li>
					${cDTO.num}
				</li>
				<li style="display:flex;align-items:center;width:300px;">
					<!-- 이미지 처리 -->
					<c:forTokens var="token" items="${cDTO.gimage}" delims="." varStatus="status">
						<c:if test="${status.last}">
							<c:choose>
								<c:when test="${token eq 'jpg' || token eq 'gif' || token eq 'png' || token eq 'bmp'}">
									<img src="images/${cDTO.gimage}" border="0" width="80" alt="상품 이미지" />
								</c:when>
								<c:otherwise>
									<img src="images/${cDTO.gimage}.jpg" border="0" width="80" alt="상품 이미지" />
								</c:otherwise>
							</c:choose>
						</c:if>
					</c:forTokens>
					<span style="margin-left:20px;">
						${cDTO.gname}
					</span>
				</li>
				<li>
					${bDTO.bcategory}
				</li>
				<li>
					${cDTO.vcategory}
				</li>
				<li id="price">
					${bDTO.bprice}
				</li>
				<li>
					<input type="text" id="gamount" name="gamount" value="${cDTO.gamount}" size="2">
				</li>
				<li>
					<span id="bTotal"></span><br>
					<span id="bUnit"></span>
				</li>
			</ul>
		</div>
	</c:if>
	
	<!-- 비회원, 일반 회원, 사업자 회원 - 소매 -->
	<c:if test="${usercode != 35}">
		<div class="goodsInfo">
			<ul>
				<li>주문 번호</li>
				<li style="width:300px;">상품 정보</li>
				<li>옵션</li>
				<li>판매가</li>
				<li>수량</li>
			</ul>
			
			<ul>
				<li>
					${cDTO.num}</li>
				<li style="display:flex;align-items:center;width:300px;">
					<!-- 이미지 처리 -->
					<c:forTokens var="token" items="${cDTO.gimage}" delims="." varStatus="status">
						<c:if test="${status.last}">
							<c:choose>
								<c:when test="${token eq 'jpg' || token eq 'gif' || token eq 'png' || token eq 'bmp'}">
									<img src="images/${cDTO.gimage}" border="0" width="80" alt="상품 이미지" />
								</c:when>
								<c:otherwise>
									<img src="images/${cDTO.gimage}.jpg" border="0" width="80" alt="상품 이미지" />
								</c:otherwise>
							</c:choose>
						</c:if>
					</c:forTokens>
					<span style="margin-left:20px;">
						${cDTO.gname}
					</span>
				</li>
				<li>
					${cDTO.vcategory}
				</li>
				<li id="price">
					${cDTO.gprice}
				</li>
				<li>
					<input type="text" id="gamount" name="gamount" value="${cDTO.gamount}" size="2">
				</li>
			</ul>
		</div>
	</c:if>
	
	<div>
		<ul>
			<li>
				총 결제 금액: <span id="totalPrice"></span>원
				<c:if test="${usercode == 35}">(묶음 가격)</c:if>
			</li>
		</ul>
	</div>
	<br>
	
	<div style="width:75%;"><hr></div>	<!-- 구분선 -->
	
	<div><ul><li>배송지 정보</li></ul></div>
	
	<c:if test="${not empty login}">	<!-- 로그인되어있을 때 -->
		<!-- 유저 정보에서 가져온 배송지 -->
		<div>
			<ul>
				<li>이름</li>
				<li>
					<input type="text" size="6" value="${login.username}" readonly>
				</li>
			</ul>
				
			<ul>
				<li>주소</li>
				<li>
					<input type="text" class="userAddress" size="5" maxlength="5" value="${login.post}" readonly>
					<!-- <input type="button" onclick="" value="우편번호 찾기"> -->
					<br>
					<input type="text" class="userAddress" value="${login.addr1}" readonly>
					<input type="text" class="userAddress" value="${login.addr2}" readonly>
					<!-- <span id="guide" style="color:#999"></span> -->
				</li>
			</ul>
				
			<ul>	
				<li>전화번호</li>
				<li>
					<input type="text" class="userPhone" size="3" maxlength="3" value="0${login.phone1}" readonly>
					-
					<input type="text" class="userPhone" size="4" maxlength="4" value="${login.phone2}" readonly>
					-
					<input type="text" class="userPhone" size="4" maxlength="4" value="${login.phone3}" readonly>
				</li>
			</ul>
		</div>
	
		<!-- 유저 정보와 동일한 배송지 및 연락처 사용하기 -->
		<div style="margin:0 50px;">
			<ul>
				<li>
					<input type="checkbox" id="same1"> 계정에 저장된 배송지를 사용합니다.<br>
					<input type="checkbox" id="same2"> 계정에 저장된 연락처를 사용합니다.
				</li>
			</ul>
		</div>
	</c:if>
	
	<!-- 새로 입력할 배송지 -->
	<div>
		<ul>
			<li>수취인</li>
			<li>
				<input type="text" id="ordername" class="inputName" name="ordername" size="6">
			</li>
		</ul>
				
		<ul>
			<li>배송지</li>
			<li>
				<input type="text" name="post" id="sample4_postcode" class="inputPlace" placeholder="우편번호" size="5" maxlength="5" value="${userInfo.post}">
				<input type="button" id="postBtn" onclick="sample4_execDaumPostcode()" value="우편번호 찾기"><br>
				<input type="text" name="addr1" id="sample4_roadAddress" class="inputPlace" placeholder="도로명주소" value="${userInfo.addr1}">
				<input type="text" name="addr2" id="sample4_jibunAddress" class="inputPlace" placeholder="지번주소" value="${userInfo.addr2}">
				<span id="guide" style="color:#999"></span>
			</li>
		</ul>
				
		<ul>
			<li>연락처</li>
			<li>
				<select name="phone1" id="phone1" class="inputPhone">
					<option value="010" <c:if test="${userInfo.phone1 == 010}">selected="selected"</c:if>>010</option>
					<option value="011" <c:if test="${userInfo.phone1 == 011}">selected="selected"</c:if>>011</option>
				</select>
				-
				<input type="text" name="phone2" id="phone2" class="inputPhone" size="4" maxlength="4" value="${userInfo.phone2}">
				-
				<input type="text" name="phone3" id="phone3" class="inputPhone" size="4" maxlength="4" value="${userInfo.phone3}">
			</li>
		</ul>
	</div>
	<br>
	
	<div style="width:50%;"><hr></div>	<!-- 구분선 -->
	
	<div><ul><li>결제 수단</li></ul></div>
	
	<div>
		<ul>
			<li>
				<input type="radio" name="paymethod" value="신용카드" checked="checked">신용카드
			</li>
			<li>
				<input type="radio" name="paymethod" value="계좌이체">계좌이체
			</li>
			<li>
				<input type="radio" name="paymethod" value="무통장입금">무통장입금
			</li>
			<li>
				<input type="radio" name="paymethod" value="카카오페이">카카오페이
			</li>
		</ul>
	</div>
	<br>
	
	<div>
		<ul>
			<li>
				<input type="submit" value="상품 구매">
			</li>
		</ul>
	</div>
</form>

<!-- 주소 검색 - 다음 API -->
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
    //본 예제에서는 도로명 주소 표기 방식에 대한 법령에 따라, 내려오는 데이터를 조합하여 올바른 주소를 구성하는 방법을 설명합니다.
    function sample4_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
                var extraRoadAddr = ''; // 도로명 조합형 주소 변수

                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraRoadAddr !== ''){
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }
                // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
                if(fullRoadAddr !== ''){
                    fullRoadAddr += extraRoadAddr;
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('sample4_postcode').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('sample4_roadAddress').value = fullRoadAddr;
                document.getElementById('sample4_jibunAddress').value = data.jibunAddress;

                // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
                if(data.autoRoadAddress) {
                    //예상되는 도로명 주소에 조합형 주소를 추가한다.
                    var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                    document.getElementById('guide').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';

                } else if(data.autoJibunAddress) {
                    var expJibunAddr = data.autoJibunAddress;
                    document.getElementById('guide').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';

                } else {
                    document.getElementById('guide').innerHTML = '';
                }
            }
        }).open();
    }
</script>