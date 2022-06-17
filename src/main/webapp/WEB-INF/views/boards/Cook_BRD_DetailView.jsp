<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
	
	$(document).ready(function () {
		$("#btnDelete").click(function () {
			document.form1.submit();
		}) 
		 $("#btnModify").click(function () {
			 var num = $("#btnModify").attr("data-num");
			 location.href ="Cook_BRD_update?num="+num;
		}) 
	})
	
</script>
<h2>래시피 게시글 자세히 보기</h2>
<form name="form1" id="form1" method="post" action="Cook_BRD_delete" >
	<input type="hidden" name="num" value="${dto.num}"/>
	<div>작성자 : ${dto.userid}</div>
	<div>
		<c:choose>
			<c:when test="${dto.type_num =='10'}">
				주제 - 공지
			</c:when>
			<c:otherwise>
				주제 - 요리
			</c:otherwise>
		</c:choose>
	</div>
	<div>
		제목 <input name="title" id="title" size="80" value="${dto.title }"
			readonly>
	</div>
	<div>
		내용
		<textarea name="content" id="content" rows="50" cols="200" readonly>${dto.content}</textarea>
	</div>

	<c:forEach items="${iList}" var="iList">
		<div class='ING'>
			재료:<input type='text' name='ingre' value="${iList.ingre }" readonly>
			용량:<input type='text' name='capacity' value="${iList.capacity }"
				readonly><br>
		</div>
	</c:forEach>

	<div style="width: 650px; text-align: left;">
		<button type="button" onclick="history.back()">뒤로가기</button>
		<c:if test="${login.userid == dto.userid }">

			<button type="button" id="btnModify" data-num="${dto.num}">수정</button>
			<button type="button" id="btnDelete">삭제</button>
		</c:if>
	</div>
</form>
