<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<section class="goods">

	<!-- 반복시작 -->
	<c:forEach var="dto" items="${goodsList}" varStatus="status">
			<ul class="goods_line">
				<!-- img 처리 -->
				<c:forTokens var="token" items="${dto.gimage}" delims="."
					varStatus="status2">
					<c:if test="${status2.last}">
						<%-- ${token}, ${dto.gimage} --%>
						<c:choose>
							<c:when
								test="${token eq 'jpg' || token eq 'gif' || token eq 'png' || token eq 'bmp'}">
								<li>
									<a href="goodsDetail?gcode=${dto.gcode}">
									<img src="images/${dto.gimage}"></a>
								</li>
							</c:when>
							<c:otherwise>
								<li>
									<a href="goodsDetail?gcode=${dto.gcode}">
									<img src="images/${dto.gimage}.jpg"></a>
								</li>
							</c:otherwise>
						</c:choose>
					</c:if>
				</c:forTokens>
			
				<!-- goods 부가내용 -->
				<li>
					<a class="a_black" href="goodsDetail?gcode=${dto.gcode}"> ${dto.gname}</a>
				</li>
				<li>${dto.gamount}EA</li>
				<li>${dto.gprice}원</li>
			
			<!-- 한 줄에4개씩 -->
			<c:if test="${status.count%4 ==0 }">
				<div class="space"></div>
			
			</c:if>
			<!-- 반복끝-->
			</ul>
	</c:forEach>
</section>