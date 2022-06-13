<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
	$(document).ready(function () {
		$("#ingreADD").click(function() {//번들 input 추가
			 event.preventDefault();
			if ($("#Ingrement").children("#emptyIngre").length != 0) {	
				$("#Ingrement").children("#emptyIngre").remove();
			}									
				$("#Ingrement").append("<div class='ING'>재료:<input type='text' name='ingre'> 용량:<input type='text' name='capacity'><button class='ingreDelete'}>삭제</button><br></div>");
			}); 			
			$(".ingreDelete").click(function() {
				event.preventDefault();
				var ingreno = $(this).attr("data-ingreno");
				var ingredel = "#ING"+ingreno;
				$("#Ingrement").children(ingredel).remove();
				
				if ($("#Ingrement").children().length == 0) {	
					$("#Ingrement").append("<span id='emptyIngre'>재료정보없음</span>");
				}
			});			
			$(".ingreDel").click(function() {
				event.preventDefault();				
				$("#Ingrement").children(ingredel).remove();				
				if ($("#Ingrement").children().length == 0) {	
					$("#Ingrement").append("<span id='emptyIngre'>재료정보없음</span>");
				}
			});		
		$("#btnSave").click(function () {			
			var title = $("#title").val();
			var content = $("#content").val();							
			if(title.length < 1 || content.length <1 ){
				event.preventDefault();
				alert("제목과 내용을 확인해주세요");
				document.form1.title.focus();
			}			
			else{
				ingredel();
				ingrementModify();
				cook_BRD_modify(); 
				alert("게시물 저장이 완료되었습니다.");
				document.form1.submit();
			}		
		})
	});// ready end
	function ingredel() {
		$.ajax({
			url:"ingredel",
			type: "get",
			async:false,
			data: {num: "${cdto.num}"},
			dataType: "text"
		});//end ajax
	}	
	 function cook_BRD_modify(){//보드에 db추가
	    	var queryString = $("form[name=form1]").serialize();
	 		
	    	$.ajax({
	    		type : 'post', 
	    		url : 'Cook_BRD_modify', 
	    		data : queryString, 
	    		dataType : 'json' ,
	    		async:false
	    		});	  
	    }	
	 function ingrementModify() {//ingre 저장
			$(".ING").each(function(i, element) {
				var ingre = $(this).children("input[name=ingre]").val();
				var capacity = $(this).children("input[name=capacity]").val();
				var num = $("#num").attr("value");
				
				$.ajax({
					url:"ingrementModify",
					type: "get",
					async:false,
					data: {num:num, ingre:ingre, capacity:capacity}, 
					dataType: "text"
				});//end ajax
			});//each end
		}//insertBundle end
	
</script>
<%-- ${login.usercode } >>10!=이면 공지라디오버튼 안보이고 요리디폴트 --%>
<h2>래시피 게시판 게시글 수정</h2>
<form name="form1" method="post" action="Cook_BRD">
	<input type="hidden" name="userid" value="${login.userid}">
	<input type ="hidden" name="num" id="num" value="${cdto.num}">
	<div>작성자 :${login.userid}</div>
	<div>
		제목  <input name="title" id="title" size="80" value="${cdto.title}">
	</div>
	<div>
		내용<textarea name="content" id="content" rows="50" cols="200" >${cdto.content}</textarea>
	</div>


	<div id="Ingrement">
	<c:forEach items="${iList}" var="iList">
		<div class='ING' id="ING${iList.ingreno}">
			재료:<input type='text' name='ingre' value="${iList.ingre}" >
			용량:<input type='text' name='capacity' value="${iList.capacity}">
			<button class="ingreDelete" data-ingreno="${iList.ingreno}">삭제</button>
		</div>
	</c:forEach>
	</div>
	<button id="ingreADD">재료정보추가</button><br>

	<div>
		주제 
		<c:if test="${ cdto.type_num =='10'}">
		<input type="radio" id="type_num" name="type_num"  value="10" checked/>공지
		</c:if>
		<c:if test="${ cdto.type_num =='20'}">
		<input type="radio" id="type_num" name="type_num"  value="20" checked/>요리
		</c:if>
	</div>
	<div style="width:650px; text-align: left;">

		<button type="button" id="btnSave">수정</button>
		<button type="button" onclick="history.back()">뒤로가기</button>
	</div>









</form> 