<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js">
</script>

<script type="text/javascript">
	$(function() {
		// 아이디 중복 검사
		$("#idDuplicateCheck").click(function(event) {
			event.preventDefault();
			
			$("#idCheckResult").text("");
			
			if ($("#userid").val().length > 0) {
				$.ajax({
					type:"get", 
					url:"idDuplicateCheck", 
					dataType:"text", 
					data:{
						inputId:$("#userid").val()
					}, 
					success:function(data, status, xhr) {
						if (data == "OK") {
							$("#idCheckResult").css("color", "green");
							$("#idCheckResult").text("사용 가능한 아이디입니다.");
						} else {
							$("#idCheckResult").css("color", "red");
							$("#idCheckResult").text("중복된 아이디입니다.");
						}
					}, 
					error:function(xhr, status, error) {
						console.log(error);
					}
				});
			} else
				$("#userid").focus();
		});
		$("#userid").keyup(function() {	// 새로 입력하면 중복 체크 결과 초기화
			$("#idCheckResult").text("");
		});
		$("#userid").bind("paste", function(event) {	// 붙여넣기하면 중복 체크 결과 초기화
			$("#idCheckResult").text("");
		});
		
		// 도메인 자동 입력
		$("#emailSelect").change(function() {
			$("#email2").val(this.value);
		});

		
		$("form").submit(function(event) {
			var inputCheck = true;
			
			
			$("input").each(function() {
				if (this.value.length < 1) {
					inputCheck = false;
					return false;
				}
			});
			
			
			if (!inputCheck) {
				alert("모든 칸을 채워주세요.");
			} else if ($("#idCheckResult").text().length < 1) {
				alert("아이디 중복확인을 해주세요.");
				$("#userid").focus();
				
				inputCheck = false;
			} else if ($("#idCheckResult").text() == "중복된 아이디입니다.") {
				alert("\"" + $("#userid").val() + "\"은/는 사용 불가능한 아이디입니다.\n다른 아이디를 입력해주세요.");
				
				inputCheck = false;
			}
			
			return inputCheck;
		});
		
		
	});
	
	
	// 취소 시 바로 종료
	$(function() {
		$('#cancel').click(function () {
			
			location.href = "./";
		});
	});
</script>

<form action="memberAdd" method="get">
<div>
<ul>
<li>*아이디: <span><input type="text" name="userid" id="userid"></span> <button id="idDuplicateCheck">중복확인</button>
<span id="idCheckResult" style="margin-left:10px; font-size:12px; cursor:default;"></span> </li>
<li>*비밀번호: <span><input type="text" name="passwd" id="passwd"></span></li> 
<!-- 비빌번호확인:<input type="text" name="passwd2" id="passwd2">
<span id="result2"></span> 
<br> -->
<li>이름: <span><input type="text" name="username" size="6"></span></li>
<li>유저코드: 
<input type="radio" class="usercode" name="usercode" value="20" checked="checked">일반 회원
<input type="radio" class="usercode" name="usercode" value="30">사업자 회원</li>
<li>
<input type="text" name="post" id="sample4_postcode" placeholder="우편번호" size="5" maxlength="5">
<input type="button" onclick="sample4_execDaumPostcode()" value="우편번호 찾기"></li>
<li><input type="text" name="addr1" id="sample4_roadAddress" placeholder="도로명주소">
<input type="text" name="addr2" id="sample4_jibunAddress" placeholder="지번주소">
<span id="guide" style="color:#999"></span>
<li>

<li>
전화번호: <select name="phone1">
  <option value="010">010</option>
  <option value="011">011</option>
</select>-
<input type="text" name="phone2" size="4" maxlength="4">-<input type="text" name="phone3" size="4" maxlength="4">
</li>

<li>
이메일:<input type="text" name="email1" id="email1">@
       <input type="text" name="email2" id="email2" placeholder="직접입력">
       <select  id="emailSelect">
        <option value="daum.net">daum.net</option>
        <option value="naver.com">naver.com</option>
       </select>
</li>
<li>
<input type="submit" value="회원가입">
<input type="reset" value="다시입력" >
</li>
</ul>
</div>
</form>
<hr>
<button id="cancel">취소</button>


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