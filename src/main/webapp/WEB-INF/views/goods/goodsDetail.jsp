
<%@page import="com.dto.MemberDTO"%>
<%@page import="java.util.ArrayList"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>

<style>
	li {list-style: none;
		padding: 5px;}
	span {padding-right: 30px;}
</style>

<script>

	
	//bundle, variation
	$(document).ready(function() {
				
				$("#bcategory").change(function() {
					var price = $(this).children("option:selected").attr("data-xxx");
					var amount = $("#gamount").val();
					$("input[name=gprice]").val(price);
					console.log(price);
					$("#changePrice").text(price*amount+"원");
				});
				
				$("#up").on("click", function() {
					var count = $("#gamount").val();
					var price = $("#oneprice").text();
					
					result = parseInt(count)+1;
					total = parseInt(price*result);
					
					$("#gamount").val(result);
					$("#changePrice").text(total + "원");
					
				});//up
				
				
				$("#down").click(function() {
					var count = $("#gamount").val();
					var price = $("#oneprice").text();
					var sum = $("#changePrice").val();
					
					if (count != 1){
						result = parseInt(count)-1;
						total = parseInt(price*result);
					}			
					
					$("#gamount").val(result);
					//$("#changePrice").text(total);
					
				})//down 
				
				
				/* 
				$(".vcategory").click(function() {
					var price = $("#selprice").text();
					var amount = $("#gamount").val();
					console.log(price);
					$("#changePrice").text(price*amount+"원");
				}); */
				
				//bundle 값, option에 push		
				$.ajax({
					url: "bundleDetail",
					type: "get",
					data: {gcode: $("#findgcode").text()},
					success: function (data) {
						console.log("b성공");
						
						$(data).each(function (index, value) {
							//console.log(index);
							$('#bcategory').append("<option value='" + data[index]['bcategory']+"' data-xxx ='"+data[index]['bprice']+"'>"
								+ data[index]['bcategory'] + " : " + data[index]['bprice'] + "원" + "</option>");
							console.log(data[0]);
						})
					},
					error: function(xhr,status,error) {
						console.log(error);
					}
				});  //end ajax
				
				
				//variation 값, option에 push		
				$.ajax({
					url: "variationDetail",
					type: "get",
					data: {gcode: $("#findgcode").text()},
					success: function (data) {
						console.log("v성공");
						$(data).each(function (index, value) {
							//console.log(index);
							//console.log(data[index]['num']);
							$('#vcategory').append("<option value='" + data[index]['vcategory']+"'>"
								+ data[index]['vcategory'] + "</option>");
							//console.log(data[0]);
						})
					},
					error: function(xhr,status,error) {
						console.log(error);
					}
				});  //end ajax
				
				//cart 클릭이벤트
				$("#cart").on("click", function() {
					/* $("form").attr("action", "loginCheck/cartAdd"); */
					var formData = $("form").serialize();
					$.ajax({
			            cache : false,
			            url : "loginCheck/cartAdd", // 요기에
			            type : 'POST', 
			            data : formData, 
			            success : function(data) {
			               console.log("성공")
			            }, // success 
			    
			            error : function(xhr, status) {
			                alert(xhr + " : " + status);
			            }
			        }); // $.ajax */
				 	var answer;
					answer = confirm("상품을 장바구니에 담았습니다. 장바구니로 이동하시겠습니까?");
					if(answer == true){
						console.log("확인")
						/* location = "loginCheck/cartList"  */
						$("form").attr("action", "loginCheck/cartList");
					} 
				});//end clickevent
				
				
				// 구매 버튼 클릭 시 구매 페이지로 이동
				$("#orderBtn").click(function() {
					$("form").attr("action", "orderForm");
				});
	
				
				// 리뷰
				$(".reply_btn").on("click", function () {
						
				})
				
	});//end ready
		
	
		
		
		
</script>

${goodsDetail}
<FORM name="goodDetailForm" method="GET" action="#"><!--action을 막음 --><!-- hidden data -->
	    <input type="hidden" name="gimage" value="${goodsDetail.gimage}"> 
	    <input type="hidden" name="gcode" value="${goodsDetail.gcode}">
	    <input type="hidden" name="gname" value="${goodsDetail.gname}"> 
	    <input type="hidden" name="gprice" value="${goodsDetail.gprice}">
		<input type="hidden" name="userid" value="${login.userid}">

<% 
	MemberDTO login = (MemberDTO)session.getAttribute("login");
	if(login != null){
		System.out.println("로그인중");
	}
%>

<%-- ${goodsDetail.gname} --%>
	<div>
		<div style='width:80%'>
				<div style='border-bottom:solid 1px #cecece'>
					<h2>${goodsDetail.gname}</h2>
				</div>
					
					<div style='padding: 20px; float: left; width:30%;'>
						<c:forTokens var="token" items="${goodsDetail.gimage}" delims="." varStatus="status">
							<c:if test="${status.last}">
								<c:choose>
									<c:when test="${token eq 'jpg' || token eq 'gif' || token eq 'png' || token eq 'bmp'}">
										<li><img src="images/${goodsDetail.gimage}"
											border="0" align="center" width="300"/></li>
									</c:when>
									<c:otherwise>
										<li><img src="images/${goodsDetail.gimage}.jpg"
										border="0" align="center" width="300"/></li>
									</c:otherwise>
								</c:choose>
							</c:if>
						</c:forTokens>
					</div>
						<div style='width:50%; float:left;'>
						<ul>

							<li class="td_title"><span>상품코드</span><span id=findgcode>${goodsDetail.gcode }</span></li>

						<%-- 	<li class="td_default" style='padding-left: 30px'>
								${goodsDetail.gcode }
							</li> --%>

							<li><span>상품명</span><span>${goodsDetail.gname}</span></li>
							<li><span>단품 가격</span><span style="color: red; font-weight: bolder;" id="oneprice" >${goodsDetail.gprice}</span></li>

							<li class="td_red" style='padding-left: 30px'>
								
							</li>
							<li class="td_title"><span>배송비</span><span style="padding-right:0px; color: #2e56a9; font-weight: bolder">무료배송</span><span style="font-size: 0.8em;"> (도서
									산간지역 별도 배송비 추가)</span></li>
							<li class="td_title" rowspan="2">상품옵션</li>
							
							<!-- 회원일 때 10(관리자)/20(일반)/30(사업자) -->
							<c:if test="${not empty login}">
							<c:choose>	
								<c:when test="${login.usercode eq '20'}">
									<!-- vcategory -->
									<li style='padding-left: 30px'>
									<select	class="vactegory" name="vcategory" id="vcategory" style="width: 300px">
											<option selected>variation</option>
											
									</select></li>
								</c:when>
								<c:otherwise>
									<!-- vcategory -->
									<li style='padding-left: 30px'>
									<select	class="vactegory" name="vcategory" id="vcategory" style="width: 300px">
											<option selected>variation</option>
											
									</select></li>
							
									<!-- bcategory -->
									<li style='padding-left: 30px'>
									<select	class="select_change" name="bcategory" id="bcategory" style="width: 300px">
										<option selected data-xxx="${goodsDetail.gprice}">단품: ${goodsDetail.gprice}</option>
										
									</select></li>
								</c:otherwise>
							</c:choose>
							</c:if>
							
							<!-- 비로그인 회원처리  -->
							<c:if test="${empty login}">
								<!-- vcategory -->
								<li style='padding-left: 30px'>
								<select	class="vactegory" name="vcategory" id="vcategory" style="width: 300px">
										<option selected>variation</option>
											
								</select></li>
							</c:if>
							<li class="td_title">주문수량</li>
							<span><input type="text"
								name="gamount" value="1" id="gamount"
								style="text-align: right; height: 18px;"> <img
								src="images/up.png" id="up" > <img src="images/down.png"
								id="down" ></span>
							
							<li class="td_title"><span>최종 가격</span><span style="color: red; font-weight: bolder;" id="changePrice">${goodsDetail.gprice}원</span></li>
						</ul>
					</div>

		</div>
	</div>
	<div style='width:100%; float:left;'>
		<br> <button id="orderBtn">구매</button>
		&nbsp;&nbsp;
		<button class="test" id="cart" onclick="test()">장바구니</button>
		
		<div class="reply_wrab">
			<div class="reply">
				<h2>리뷰</h2>
			</div>
			
			<c:if test="${not empty login}">
				<div class="reply_btn">
					<button>리뷰쓰기</button>
				</div>
			</c:if>
		</div>
	</div>
	

</FORM>
