<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 회원 정보 화면 -->

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page import="com.dto.MemberDTO" %>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
	$(function() {
		// 비밀번호 보이기/가리기
		var userPasswd = "<c:out value='${userInfo.passwd}' />";	// 비밀번호
		var mosaicPasswd = "";	// 가려진 비밀번호
		for (var i = 0; i < userPasswd.length; i++)
			mosaicPasswd += "⦁";
		$("#showPw").text(mosaicPasswd);	// 가려진게 기본

		var showPw = false;
		$("#showPwIcon").click(function() {	// 눈 모양 아이콘
			showPw = !showPw;
			
			if (showPw) {
				$("#showPw").text(userPasswd);
				$("#showPwIcon").attr("src", "images/icons/eye-close.png");
			} else {
				$("#showPw").text(mosaicPasswd);
				$("#showPwIcon").attr("src", "images/icons/eye-open.png");
			}
		});
		
		
		// 비밀번호 변경
		$("#changePasswdBtn").click(function(event) {
			event.preventDefault();
			console.log("비밀번호 변경 버튼");
			// window.open();
		});
		
		
		// 도메인 자동 입력
		$("#emailSelect").change(function() {
			$("#email2").val(this.value);
		});
		
		
		// 빈칸 검사		
		$("form").submit(function(event) {
			var inputCheck = true;
			
			$("input").each(function() {
				if (this.value.length < 1) {
					inputCheck = false;
					return false;
				}
			});
			if (!inputCheck)
				alert("모든 칸을 채워주세요.");
			
			return inputCheck;
		});
	});
</script>

<!-- 회원 정보 수정 완료 후 메세지 출력 -->
<c:if test="${not empty userInfoMsg}">
	<script type="text/javascript">alert("${userInfoMsg}")</script>
	<% session.removeAttribute("userInfoMsg"); %>
</c:if>

<!-- 회원 정보 폼 -->
<form action="userInfoUpdate" method="post">
	<div>
		<ul>
			<li>아이디</li>

			<li>
				${userInfo.userid}
				<input type="hidden" name="userid" value="${userInfo.userid}">
				<span style="margin-left:20px;">
					<c:if test="${userInfo.usercode == 10}">(관리자)</c:if>
					<c:if test="${userInfo.usercode == 20}">(일반 회원)</c:if>
					<c:if test="${userInfo.usercode == 30}">(사업자 회원)</c:if>
				</span>
			</li>

			<li>비밀번호 변경</li>
			<li>
				<span id="showPw"></span>
				<span style="float:right;">
					<img src="images/icons/eye-open.png" id="showPwIcon" alt="비밀번호 보이기/가리기">
					<button id="changePasswdBtn">변경하기</button>
				</span>
			</li>

			<li>이름</li>
			<li>
				<input type="text" name="username" id="username" placeholder="이름 " size="6" value="${userInfo.username}">
			</li>

			<li>주소</li>
			<li>
				<input type="text" name="post" id="sample4_postcode" placeholder="우편번호" size="5" maxlength="5" value="${userInfo.post}">
				<input type="button" onclick="sample4_execDaumPostcode()" value="우편번호 찾기"><br>
				<input type="text" name="addr1" id="sample4_roadAddress" placeholder="도로명주소" value="${userInfo.addr1}">
				<input type="text" name="addr2" id="sample4_jibunAddress" placeholder="지번주소" value="${userInfo.addr2}">
				<span id="guide" style="color:#999"></span>
			</li>

			<li>전화번호</li>
			<li>
				<select name="phone1" id="phone1" class="phoneNumber">
					<option value="010" <c:if test="${userInfo.phone1 == 010}">selected="selected"</c:if>>010</option>
					<option value="011" <c:if test="${userInfo.phone1 == 011}">selected="selected"</c:if>>011</option>
				</select>
				-
				<input type="text" name="phone2" id="phone2" class="phoneNumber" size="4" maxlength="4" value="${userInfo.phone2}">
				-
				<input type="text" name="phone3" id="phone3" class="phoneNumber" size="4" maxlength="4" value="${userInfo.phone3}">
			</li>

			<li>이메일</li>
			<li>
				<input type="text" name="email1" id="email1" class="emailAddress" value="${userInfo.email1}">
				@
				<input type="text" name="email2" id="email2" class="emailAddress" placeholder="도메인" value="${userInfo.email2}">
				<select id="emailSelect" class="emailAddress">
					<option value="daum.net" <c:if test="${userInfo.email2 == 'daum.net'}">selected="selected"</c:if>>daum.net</option>
					<option value="naver.com" <c:if test="${userInfo.email2 == 'naver.com'}">selected="selected"</c:if>>naver.com</option>
				</select>
			</li>
		</ul>
	</div>
	
	<div>
		<ul>
			<li>
				<input type="submit" value="정보 수정">
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