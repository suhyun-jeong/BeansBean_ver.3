<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 로그인 폼 -->

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!-- 스타일시트 -->
<style type="text/css">
	span {
		display:inline-block;
	}
	
	div {
		clear: both;
	}

	ul {
		clear: both;
		list-style: none;
	}
	
	li {
		float: left;
	}
	
	.label {
		display:inline-block;
		width: 70px;
	}
</style>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
	$(function() {
		var input_id = $("#userid");
		var input_pw = $("#passwd");
		
		input_id.focus();
		
		// 빈칸 검사 및 ID/PW 체크
		$("form").submit(function(event) {
			if (input_id.val().length < 1) {
				event.preventDefault();
				alert("아이디를 입력해주세요.");
				input_id.focus();
			} else if (input_pw.val().length < 1) {
				event.preventDefault();
				alert("비밀번호를 입력해주세요.");
				input_id.focus();
			} else {	// ID/PW 체크
				if (!idpwCheck) {
					event.preventDefault();
					alert("아이디 혹은 비밀번호를 확인해주세요.");					
				}
			}
		});
	});
</script>

<!-- 아이디 혹은 비밀번호가 일치하지 않을 때 -->
<c:if test="${not empty loginMsg}">
	<script type="text/javascript">alert("${loginMsg}");</script>
	<% session.removeAttribute("loginMsg"); %>
</c:if>

<!-- 로그인 폼 -->
<form action="login" method="post">
		<div>
			<ul>
				<li>
					<span class="label">아이디: </span> 
					<input type="text" name="userid" id="userid" class="loginInput"><br>
					<span class="label">비밀번호: </span>
					<input type="text" name="passwd" id="passwd" class="loginInput">
				</li>
				<li>
					<input type="submit" value="로그인" style="width:60px;height:50px;">
				</li>
			</ul>
		</div>
		
		<div>
			<ul>
				<li>
					<span>
						<a href="">아이디 찾기</a>
					</span>
					<span>
						<a href="">비밀번호 찾기</a>
					</span>
				</li>
			</ul>
		</div>
</form>
