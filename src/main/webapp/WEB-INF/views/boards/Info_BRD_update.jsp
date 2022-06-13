<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
	$(document).ready(function () {
		$("#btnSave").click(function () {
			var title = $("#title").val();
			var content = $("#content").val();
			if(title.length < 1 || content.length <1 ){
				event.preventDefault();
				alert("제목과 내용을 확인해주세요");
				document.form1.title.focus();
			}			
			else{
				info_BRD_modify(); 
				alert("게시물 저장이 완료되었습니다.");
				document.form1.submit();
			}			
		})
	});// ready end	
	
	 function info_BRD_modify(){//보드에 db추가
	    	var queryString = $("form[name=form1]").serialize();
	 			 		
	    	$.ajax({
	    		type : 'post', 
	    		url : 'Info_BRD_modify', 
	    		data : queryString, 
	    		dataType : 'json' ,
	    		async:false
	    		});
	     }
</script>
<%-- ${login.usercode } >>10!=이면 공지라디오버튼 안보이고 요리디폴트 --%>
<h2>사업자 게시판 게시글 수정</h2>
<form name="form1" method="post" action="Info_BRD">
	<input type="hidden" name="userid" value="${login.userid}">
	<input type ="hidden" name="num" id="num" value="${idto.num}">
	<div>작성자 :${login.userid}</div>
	<div>
		제목  <input name="title" id="title" size="80" value="${idto.title}">
	</div>
	<div>
		내용<textarea name="content" id="content" rows="50" cols="200" >${idto.content}</textarea>
	</div>

	<div>
		주제 
		<c:if test="${ idto.type_num =='10'}">
		<input type="radio" id="type_num" name="type_num"  value="10" checked/>공지
		</c:if>
		<c:if test="${ idto.type_num =='20'}">
		<input type="radio" id="type_num" name="type_num"  value="20" checked/>사업
		</c:if>
	</div>
	<div style="width:650px; text-align: left;">

		<button type="button" id="btnSave">수정</button>
		<button type="button" onclick="history.back()">뒤로가기</button>
	</div>	
</form> 