<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import= "java.net.URLEncoder"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>

<script>
function totalXXX() {
	var totalSum=0;
	$(".sum").each(function (idx, data) {
		totalSum += Number.parseInt($(data).text());
	});	
	$("#totalSum").text(totalSum);
}
$(function() {
	totalXXX();
	
	//주문하기
	$(".orderBtn").on("click",function(){
		var num= $(this).attr("data-num");
		location.href="loginCheck/orderConfirm?num="+num;		
	});
	
	//전체삭제
	$("#delAllCart").on("click", function() {
		$("form").attr("action", "loginCheck/delAllCart");
		$("form").submit();
	})
	
	//전체주문
	$("#orderAllConfirm").on("click", function() {
		
		var forms = $("form");
		//console.log(forms);
		
		names = [];
		
		
		
		
		for (f of forms) {
			var ff = $(f);
			var formName = ff.attr("id");
			// console.log(formName);
			names.push(formName);
		}
		console.log(names);
		

		var params = $("#" + names[0]).serialize();
		for (var idx in names) {
			if (idx == 0)
				continue;
			
			params += "@@" + $("#" + names[idx]).serialize();
			// console.log(names[idx]);
		}
		console.log(params);
		console.log(typeof params);
		
		StringtxtEnc=URLEncoder.encod(parmas,"UTF-8");
			
			$.ajax({
				url: "loginCheck/orderAllConfirm",
				type:"get",
				data: {"data":params},
				datatype: "text",
				success: function(data, status, xhr) {
					console.log("success");
					
				},
				error: function(xhr, status, error) {
					console.log(error);
				}			
			});//end ajax
			
	});
	
	//전체선택
	$("#allCheck").on("click", function() {
		var result= this.checked;
		$(".check").each(function(idx, data) {
			this.checked= result;
		});
	});
	
	//삭제버튼 이벤트처리
	$(".deleteBtn").on("click", function () {
		console.log("삭제버튼 클릭 ");
		var num= $(this).attr("data-num");
		var xxx= $(this);
		$.ajax({
			url: "loginCheck/cartDelete",
			type:"get",
			dataType: "text",
			data: {
				num: num
			},
			success: function(data, status, xhr) {
				console.log("success");
				//dom삭제 
				xxx.parents().filter("tr").remove();
				totalXXX();
			},
			error: function(xhr, status, error) {
				console.log(error);
			}			
		});//end ajax
	});//end event
	
	
	//수정버튼이벤트 처리 
	$(".updateBtn").on("click", function() {
		console.log("수정버튼 실행됨");
		var num=$(this).attr("data-num");
		var gamount= $("#cartAmount"+num).val();
		var gPrice =  $(this).attr("data-price");
		console.log(num, gPrice, gamount);
		$.ajax({
			url: "loginCheck/cartUpdate",
			type: "get",
			dataType: "text",
			data: {
				num: num,
				gamount: gamount //dto 변수명과 일치시켜주세요
			},
			success: function (data, status, xhr) {
				console.log("성공")
				var total= parseInt(gamount)*parseInt(gPrice);
				$("#sum"+num).text(total);
				totalXXX();
			},
			error: function (xhr, status,error) {
				console.log(error);
			}//end error			
		});//end ajax
	}); //end click
});//end ready
 
</script>

 	<div style = height:100px; align="center"> 
		<font size="6"><b>- 장바구니-</b></font>
			<hr size="2" color="CCCCCC">	
	</div>

	 <div style = height:50px; >
		<span><input type="checkbox" name="allCheck" id="allCheck"> <strong>전체선택</strong></span>	
		<span><strong>주문번호</strong></span>
		<span><strong>상품정보</strong></span>
		<span><strong>판매가</strong></span>
		<span><strong>수량</strong></span>
		<span><strong>합계</strong></span>			
		<hr>	
	</div> 
	
	
	<div>
	<forEach> 
		<ul>
			<c:forEach var="x" items="${cartList}">
	<form id="myForm-${x.num}">
			
				<input type="hidden" name="num" value="${x.num}">
				<input type="hidden" name="userid" value="${x.userid}">
				<input type="hidden" name="gcode" value="${x.gcode}">
				<input type="hidden" name="gname" value="${x.gname}">
				<input type="hidden" name="gprice" value="${x.gprice}">
				<input type="hidden" name="bcate" value="${x.bcategory}">
				<input type="hidden" name="vcate" value="${x.vcategory}">
				<input type="hidden" name="gamount" value="${x.gamount}">
				<input type="hidden" name="image" value="${x.gimage}">
			
				 <input type="checkbox" name="check"
					id="check81" class="check" value="${x.num}"/>
					
					<!-- 이미지 -->
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
					
					
					
				<li class="td_default" width="300" style='padding-left: 30px'>
					${x.gname} <br> <font size="2" color="#665b5f">[옵션 :
						소매옵션(${x.vcategory}) , 도매옵션(${x.bcategory})] </font>
				</li>
				
				<li class="td_default" align="center" width="110"><span
					id="gPrice${x.num}">${x.gprice}</span></li>
					
				<li class="td_default" align="center" width="90">
				<input
					class="input_default" type="text" name="cartAmount"
					id="cartAmount${x.num}" style="text-align: right" maxlength="3"
					size="2" value="${x.gamount}"></input>
					</li>
					
					
				<li><input type="button" value="수정" class="updateBtn"
					data-num="${x.num}" data-price="${x.gprice}" ></li>
					
				<li class="td_default" align="center" width="80"
					style='padding-left: 5px'><span id="sum${x.num}" class="sum">
						${x.gprice * x.gamount} </span></li>
						
				<li><input type="button" value="주문" class="orderBtn"
					data-num="${x.num}"></li>
					
				<li class="td_default" align="center" width="30"
					style='padding-left: 10px'><input type="button" value="삭제"
					class="deleteBtn" data-num="${x.num}"></li>
				<li height="10"></li>
				<hr>
	</form>
				</c:forEach>
				
				
			</ul>

		
		
	</div>
	
		<div style="display">
		<hr size="1" color="CCCCCC">
		총합 : <span id="totalSum"></span>
		<hr size="1" color="CCCCCC">
		</div>
	
	

		<div style = height:10px;>
			<button id="orderAllConfirm">전체 주문하기</button>
			<button id="delAllCart">전체 삭제하기</button> 
			<a class="a_black" href="goodsList?gCategory=">계속 쇼핑하기 </a>&nbsp;&nbsp;&nbsp;&nbsp;
		</div>