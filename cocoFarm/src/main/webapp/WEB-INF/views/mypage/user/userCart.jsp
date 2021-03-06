<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>장바구니 조회</title>
<link rel="stylesheet" type="text/css" href="/css/reset.css">
<link rel="stylesheet" type="text/css" href="/css/style.css">
<link rel="stylesheet" type="text/css" href="/css/board.css">
<link rel="stylesheet" type="text/css" href="/css/message.css">
<script type="text/javascript"
	src="https://code.jquery.com/jquery-2.2.4.min.js"></script>

<script type="text/javascript">

$(document).ready(function() {	
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
	
	calcTotalPrice();
	
	
	$(".return").click(function() {
		location.href = "/seller.do";
	});
	
	$(".purchase").click(function() {
		$(".option_form").attr("action", "/orderpay.do");
		$(".option_form").submit(); 
	});	
	
	/* 장바구니 옵션 변경 버튼 */
	$(".td_update").click(function() {
		var arr = [];
		var obj = {};

		// 판매 상품 idx
		var saleIdx = $(this).attr('value');
		
		// 판매 상품 옵션 idx
		var cart = "${cart[4].saleOptionIdx }";
// 		console.log(cart);

		// 판매 상품에 해당하는 옵션 idx
		
		var init = ${optionCart[0].idx };
		
		// saleIdx가 동일한 개수만 size 체크
		// product.idx === optionCart.saleIdx
		
		var size = 0;
		var count = ${optionCart.size() };
// 		for(var i=0; i<count; i++) {
			if(saleIdx === "${optionCart[0].saleIdx }" ) {
				size++;
			}
			if(saleIdx === "${optionCart[1].saleIdx }" ) {
				size++;
			}
			if(saleIdx === "${optionCart[2].saleIdx }" ) {
				size++;
			}
			if(saleIdx === "${optionCart[3].saleIdx }" ) {
				size++;
			}
			if(saleIdx === "${optionCart[4].saleIdx }" ) {
				size++;
			}
// 		}
		
// 		var size = ${optionCart.size() };
// 		for(var i=init; i<init+size; i++) {
// 				obj.count = $("#amount"+i).val();
// 				arr.push(obj);
// 				console.log(obj.count);
// 				console.log(arr);
// 				obj = {};
// 		}
		
		//==========================================================
			
			
		var result = [];
		
		<c:forEach items="${cart }" var="cart">
			var json = {};
			json.saleOptionIdx = "${cart.saleOptionIdx }";
			json.count = $("#amount"+"${cart.saleOptionIdx }").val();
			result.push(json);
		</c:forEach>
		
		console.log(JSON.stringify(result));
		
		$.ajax({
			type: "POST"
			, url: "/product/updateCart.do"
			, data: {
				cart: JSON.stringify(result)
			}
			, dataType: "json"
			, success: function(data) {
				console.log(data);	
			}
		})
	});
	
	/* 장바구니 삭제 */
	$(".basket_delete").click(function() {
		// 선택된 체크박스
		var $checkboxes
		 = $("input:checkbox[name='checkRow']:checked");
		
		var map = $checkboxes.map(function() {
			return $(this).val();
		});
		var productIdx = map.get().join(",");
		console.log("productIdx : " + productIdx);
		
		// 전송 폼
		var $form = $("<form>")
			.attr("action", "/product/deleteCart.do")
			.attr("method", "post")
			.append(
				$("<input>")
					.attr("type", "hidden")
					.attr("name", "productIdx")
					.attr("value", productIdx)
			);
		$(document.body).append($form);
		$form.submit();
	});

	/* 플러스 버튼 눌렀을때 */
	$(".option_count").on("click", ".button_plus", function() {
		// 옵션 개수 최대값
		if(Number($(this).parent().find(".pronum_text").val())==99) {
			alert("최대 99개까지 선택 가능합니다.");
			return;
		}
		
		// 옵션 개수
		var num = Number($(this).parent().find(".pronum_text").val())+1;
		Number($(this).parent().find(".pronum_text").val(num));
		
		// 옵션 가격 계산
		var option_price = Number($(this).val());
		
		// 옵션별 가격
		$(this).parent().find(".item_price").val(comma(option_price*num));
		
		calcTotalPrice();
	});

	/* 마이너스 버튼 눌렀을때 */
	$(".option_count").on("click",".button_minus", function() {
		// 옵션 개수 최소값
		if(Number($(this).parent().find(".pronum_text").val())==1) {
			alert("최소 1개부터 선택 가능합니다.");
			return;
		}
		
		// 옵션 개수
		var num = Number($(this).parent().find(".pronum_text").val())-1;
		Number($(this).parent().find(".pronum_text").val(num));
		
		// 옵션 가격 계산
		var option_price = Number($(this).val());
		
		// 옵션별 가격
		$(this).parent().find(".item_price").val(comma(option_price*num));
				
		calcTotalPrice();
	});
});

/* 상품금액 계산 */
function calcPrice() {
	let price = 0;

	// 판매 상품에 대한 옵션 금액만 합산
	// 판매 상품 saleIdx가 동일할 경우 add
	// 1 : 0, 1, 2 / 2 : 3, 4 / 3 : 5, 6, 7 /...
	price += Number($("#tr_cartItem1").find("#priceof3").val());
// 	$("#product_price0").text(price);
	
	$(".product_price").text(price);
}

/* 총 주문금액 계산  */
function calcTotalPrice() {
	let price = 0;
	
	$(".option_count .item_price").each(function(idx) {
		price += Number($("#priceof" + idx).val().replace(/,/g, ''));
	});
	
	$(".products_total").text(price);
}

//콤마찍기
function comma(str) {
    str = String(str);
    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}

function checkDelete() {
	
}

//전체 체크/해제
function checkAll() {
	// checkbox들
	var $checkboxes=$("input:checkbox[name='checkRow']");

	// checkAll 체크상태 (true:전체선택, false:전체해제)
	var check_status = $("#checkAll").is(":checked");
	
	if( check_status ) {
		// 전체 체크박스를 checked로 바꾸기
		$checkboxes.each(function() {
			this.checked = true;	
		});
	} else {
		// 전체 체크박스를 checked 해제하기
		$checkboxes.each(function() {
			this.checked = false;	
		});
	}
}

/* 숫자만 입력 */
function onlyNumber(obj){
    val=obj.value;
    re=/[^0-9]/gi;
    obj.value=val.replace(re,"");
}

(function() {
	var tableEl = document.querySelector('.tr_cartItem');
	var mainHtml = tableEl.innerHTML;
	var routerMap = {
		'' : function() {
			tableEl.innerHTML = mainHtml;
		}
	}
	
	function otherwise() {
		tableEl.innerHTML =
	    'Not Found';
	}

})

function List() {
	this.elements = {};
}

/* 장바구니 조회 연습... */
function cartItems() {
	var productSize = "${productCart.size() }";
	var optionName = "${optionCart[0].optionName }";
	var optionSaleIdx = "${optionCart[0].saleIdx }";
	var optionCart = new Array();
	console.log("optionName: " + optionName);
	console.log(optionCart);
	console.log("size: " + productSize);
	
	var str = "";
	for(var i=0; i<productSize; i++) {
		str += '<div>'
					+ '<img src="/proimg/${productCart[0].faceImg }" class="td_productImg" align="left" width="140px" height="140px" />'
					+ '<div class="td_productName">${productCart[0].title }</div>'
	}
// 	document.getElementById("productCart").innerHTML = str;
	
// 	for(var i=0; i<productSize; i++) {
// 		var productImg = "/proimg/${productCart[0].faceImg }";
// 		$(".td_productImg").attr("src", "productImg");
// 	}
// 	$(".td_productName").text("${productCart[0].title }");
	
}
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
			<jsp:include page="/WEB-INF/views/tile/mypage/userIntro.jsp" flush="false"/>
			
			
			<div class="mypage_page01">
				<div class="border">
					<h1>장바구니 조회 </h1>
					
					<div class="product_list">
					
					<table align="center">
						<tr class="tr_back">
							<th class="th_checkbox"><input type="checkbox" id="checkAll" onclick="checkAll();"></th>
							<th class="th_inform">상품정보</th>
							<th class="th_price">상품금액</th>
							<th class="th_delivery">배송비</th>
						</tr>
						
						
							
						<form class="option_form" method="post">
						
						<c:forEach items="${productCart }" var="product" varStatus="st">
						<tr class="tr_back" id="tr_cartItem${st.index }"	align="center">
							<td class="td_checkbox"><input type="checkbox" id="checkRow" name="checkRow" value="${product.idx }"></td>
							<td>
								<div id="productCart">
									<img src="/proimg/${product.faceImg }" class="td_productImg" align="left" width="140px" height="140px" />
									<div class="td_productName">${product.title }</div>
								</div><br>
							
							
								<c:forEach items="${optionCart }" var="option" varStatus="status">
								<c:if test="${option.saleIdx eq product.idx }">
								
									
										<div class="td_optionName"><span style="margin: 4px;"></span>${option.optionName } - ${option.price }원
										
											<div class="option_count">
												<button class="button_minus" value=${option.price }>-</button>
												<input type="text" name="saleOptions[${status.index }].proAmount"
															 class="pronum_text" id="amount${option.idx }"
															 value="${option.proAmount }" onkeyup="onlyNumber(this)">
												<button class="button_plus" value=${option.price }>+</button>
												<input type="hidden" name="saleOptions[${status.index }].idx" value="${option.idx }">
												<input type="hidden" class="item_price" id="priceof${status.index }" value="${option.price*option.proAmount }">
											</div>
											
										</div>
								</c:if>
								</c:forEach>
								
								<div style="float: right;"><button class="td_update" value="${product.idx }">옵션 변경</button></div>
								
							</td>
							
							<td><span class="product_price" id="product_price${st.index }"></span>원</td>
							<td class="delivery_price">무료</td>
						</tr>
						</c:forEach>
						
						</form>
						
						<tr class="tr_back"	align="center">
							<th class="th_checkbox"><input type="checkbox" id="checkAll" onclick="checkAll();"></th>
							<th style="text-align: left;"><button class="basket_delete">삭제</button></th>
							<th></th>
							<th></th>
						</tr>
						
					</table>
					<div class="warning">카트에 담긴 상품은 최대 30일까지 보관되며 종료되거나 매진될 경우 자동으로 삭제됩니다.</div>
					
					</div>
					
					<table class="payment_amount">
						<tr class="tr_payment">
							<td class="name_price">총 주문금액</td>
							<td class="name_price" id="border_payment">총 상품금액</td>
							<td class="real_price" id="border_payment"><span class="products_total">0</span>원</td>
						</tr>
						<tr class="tr_payment">
							<td id="border_payment" style="width: 440px;"></td>
							<td class="name_price" id="border_payment">배송비</td>
							<td class="real_price" id="border_payment">0원</td>
						</tr>
					</table>
					
					<table class="payment_amount">
						<tr class="tr_payment">
							<td class="name_total" id="border_payment">결제 예상금액</td>
							<td id="border_payment"></td>
							<td class="real_total" id="border_payment"><span class="products_total">0</span>원</td>
						</tr>
					</table>
					
					<div class="save_group">
						<button class="return">쇼핑 계속하기</button>
						<button class="purchase">구매하기</button>
					</div>
					
				</div>
			</div>

			</div>
	</div>
</div>	
</body>
</html>

