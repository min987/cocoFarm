<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="/css/reset.css">
<link rel="stylesheet" type="text/css" href="/css/style.css">
<script type="text/javascript"
	src="https://code.jquery.com/jquery-2.2.4.js"></script>




<script type="text/javascript">
$(".mypage_navbody").on("click", ".nav-link", function() {
	var page = $(this).children().attr("href");
	console.log(page);
	
	$(".mypage_page01").load(page);
	
	return false;
});

$(".mail_box").on("click", ".nav-link", function() {
	var page = $(this).attr("href");
	console.log(page);
	
	$(".mypage_page01").load(page);
	
	return false;
});
</script>




</head>
<body>
<div id="mypageheader">

	<!--Mypage부분 header ver3부분  -->
	<jsp:include page="/WEB-INF/views/tile/head/mypagehead.jsp" flush="false"/>
	
	<div class="container">
		<!--Mypage부분  검색 로고부분 -->
		<jsp:include page="/WEB-INF/views/tile/head/mypageSearch.jsp" flush="false"/>
	
		<div class="mypage_box">
			<!--Mypage부분  판매자 인트로부분 -->
			<jsp:include page="/WEB-INF/views/tile/mypage/adminIntro.jsp" flush="false"/>
			
			
			
			<div class="mypage_page01">
				<div class="border">
					<h1>전체 경매 상품 조회</h1>
					<div class="border_save">
					
					<table style="border-collapse: collapse; border:2px solid; border-color: #9e9e9e;">
					<thead>
						<tr>
						<th style="width:30px; border:1px solid; border-color: #9e9e9e;">번호</th>
						<th style="width:200px; border:1px solid; border-color: #9e9e9e;">등록 품목</th>
						<th style="width:110px; border:1px solid; border-color: #9e9e9e;">경매 시작가</th>
						<th style="width:110px; border:1px solid; border-color: #9e9e9e;">현재 입찰가</th>
						<th style="width:80px; border:1px solid; border-color: #9e9e9e;">등록 일자</th>
						<th style="width:80px; border:1px solid; border-color: #9e9e9e;">종료 일자</th>
						<th style="width:180px; border:1px solid; border-color: #9e9e9e;">경매 상태</th>
						</tr>
					</thead>
					
					
					<tbody>
					
						<c:forEach items="${list}" var="auctionList" varStatus="status">
						<tr>
							<td style="padding: 1px; border:1px solid; text-align: center; border-color: #9e9e9e;">${status.count}</td>
							<td style="padding: 1px; border:1px solid; text-align: center; border-color: #9e9e9e;">${auctionList.title }</td>
							<td style="padding: 1px; border:1px solid; text-align: center; border-color: #9e9e9e;"><fmt:formatNumber type="number" value="${auctionList.start_price }"/> 원</td>
							<td style="padding: 1px; border:1px solid; text-align: center; border-color: #9e9e9e;"><fmt:formatNumber type="number" value="${auctionList.highest_bid }"/> 원<br>(+<fmt:formatNumber type="number" value="${auctionList.highest_bid - auctionList.start_price}"/> 원)</td>
							<td style="padding: 1px; border:1px solid; text-align: center; border-color: #9e9e9e;"><fmt:formatDate value="${auctionList.reg_time }" pattern="yyyy-MM-dd"/><br><fmt:formatDate value="${auctionList.reg_time }" pattern="aa HH:mm"/></td>							
							<c:choose>
							<c:when test="${auctionList.state_code == 9}">
							<td style="padding: 1px; border:1px solid; text-align: center; border-color: #9e9e9e;"></td>							
							</c:when>
							<c:otherwise>
							<td style="padding: 1px; border:1px solid; text-align: center; border-color: #9e9e9e;"><fmt:formatDate value="${auctionList.time_window }" pattern="yyyy-MM-dd"/><br><fmt:formatDate value="${auctionList.time_window }" pattern="aa HH:mm"/></td>							
							</c:otherwise>
							</c:choose>
							<c:if test="${auctionList.state_code == 1}">
							<td style="padding: 1px; border:1px solid; text-align: center; border-color: #9e9e9e;"><font color="black" style="font-weight: bold;">진행중</font></td>
							</c:if>
							<c:if test="${auctionList.state_code == 2}">
							<td style="padding: 1px; border:1px solid; text-align: center; border-color: #9e9e9e;"><font color="red" style="font-weight: bold;">경매 취소</font></td>
							</c:if>
							<c:if test="${auctionList.state_code == 4}">
							<td style="padding: 1px; border:1px solid; text-align: center; border-color: #9e9e9e;"><font color="orange" style="font-weight: bold;">경매 만료(입찰자 없음)</font></td>
							</c:if>
							<c:if test="${auctionList.state_code == 5}">
							<td style="padding: 1px; border:1px solid; text-align: center; border-color: #9e9e9e;"><font color="blue" style="font-weight: bold;">낙찰 완료(입금 대기)</font></td>
							</c:if>
							<c:if test="${auctionList.state_code == 6}">
							<td style="padding: 1px; border:1px solid; text-align: center; border-color: #9e9e9e;"><font color="green" style="font-weight: bold;">차등 낙찰진행중</font></td>
							</c:if>
							<c:if test="${auctionList.state_code == 7}">
							<td style="padding: 1px; border:1px solid; text-align: center; border-color: #9e9e9e;"><font color="red" style="font-weight: bold;">경매 만료(낙찰자 거래 거부)</font></td>
							</c:if>
							<c:if test="${auctionList.state_code == 8}">
							<td style="padding: 1px; border:1px solid; text-align: center; border-color: #9e9e9e;"><font color="red" style="font-weight: bold;">경매 취소(경매자 취소)</font></td>
							</c:if>
							<c:if test="${auctionList.state_code == 9}">
							<td style="padding: 1px; border:1px solid; text-align: center; border-color: #9e9e9e;"><font color="blue" style="font-weight: bold;">낙찰 완료(거래 완료)</font></td>
							</c:if>
						</tr>
						</c:forEach>
					</tbody>
					</table>
					
						<div class="pageing_num">
						<jsp:include page="/WEB-INF/views/auction/admin_paging.jsp" />
						<%-- <jsp:include page="../util/paging.jsp" /> --%>
						</div>

					</div>
			
			
				</div>
			
			
			
			
			
			</div>
			
			
			
			
		</div>
	
	</div>
	
	
</div>	


</body>
</html>