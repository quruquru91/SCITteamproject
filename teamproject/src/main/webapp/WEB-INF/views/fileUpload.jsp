<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<title>Home</title>
<link rel="stylesheet" href="resources/css/fileUpload.css">
<script type="text/javascript" src="resources/jquery-3.3.1.min.js"></script>
<script type="text/javascript">
$(function() {
	var objDragAndDrop = $(".dragAndDropDiv"); 
	$('#Progress_Loading').hide();
	
	$('.btn_plus').click(function() {
		var addStr = "";
		addStr += '	<div class="right_4_div">';
		addStr += '		<div class="right_4_1">';
		addStr += '			<div class="right_productname">';
		addStr += '				<input class="productname" type="text">';
		addStr += '			</div>';
		addStr += '		</div>';
		addStr += '		<div class="right_4_2">';
		addStr += '			<div class="right_quantity">';
		addStr += '				<input class="quantity" type="text">';
		addStr += '			</div>';
		addStr += '		</div>';
		addStr += '		<div class="right_4_3">';
		addStr += '			<div class="right_unitprice">';
		addStr += '				<input class="unitprice" type="text">';
		addStr += '			</div>';
		addStr += '		</div>';
		addStr += '		<div class="right_4_4">';
		addStr += '			<div><input type="button" class="btn_minus" value="-"></div>';
		addStr += '		</div>';
		addStr += '	</div>';
		$('.right_4').append(addStr);
		$('.btn_minus').off('click');
		$('.btn_minus').on('click', function() {
			$(this).parent().parent().parent().remove();
		})
		$('input[type=text]').off('keyup');
		$('input[type=text]').on('keyup', function(){
		    calcSum();
		});
	})

	$(document).on("dragenter", ".dragAndDropDiv", function(e) {
		e.stopPropagation();
		e.preventDefault();
		$(this).css('border', '2px solid #0B85A1');
	});
	$(document).on("dragover", ".dragAndDropDiv", function(e) {
		e.stopPropagation();
		e.preventDefault();
	});
	$(document).on("drop", ".dragAndDropDiv", function(e) {
		$(this).css('border', '2px dotted #0B85A1');
		e.preventDefault();
		var files = e.originalEvent.dataTransfer.files;
		if (files.length > 1) {
			alert('하나의 그림만 올려주세요.');
			return;
		}
		if (files[0].type.match(/image.*/)) {
			$(e.target).css({"background-image" : "url(" + window.URL.createObjectURL(files[0])
							+ ")", "outline" : "none", "background-size" : "100% 100%"});
		} 
		else {
			alert('이미지파일이 아닙니다.');
			return;
		}
		handleFileUpload(files, objDragAndDrop);
	});
	$(document).on('dragenter', function(e) {
		e.stopPropagation();
		e.preventDefault();
	});
	$(document).on('dragover', function(e) {
		e.stopPropagation();
		e.preventDefault();
		objDragAndDrop.css('border', '2px dotted #0B85A1');
	});
	$(document).on('drop', function(e) {
		e.stopPropagation();
		e.preventDefault();
	});

	function handleFileUpload(files, obj) {
		for (var i = 0; i < files.length; i++) {
			var fd = new FormData();
			fd.append('file', files[i]);

			var status = new createStatusbar(obj); //Using this we can set progress.
			status.setFileNameSize(files[i].name, files[i].size);
			sendFileToServer(fd, status);
		}
	}
	var rowCount = 0; 
	function createStatusbar(obj) {
		rowCount++;
		var row = "odd";
		if (rowCount % 2 == 0)
			row = "even";
		this.setFileNameSize = function(name, size) {
			var sizeStr = "";
			var sizeKB = size / 1024;
			if (parseInt(sizeKB) > 1024) {
				var sizeMB = sizeKB / 1024;
				sizeStr = sizeMB.toFixed(2) + " MB";
			} else {
				sizeStr = sizeKB.toFixed(2) + " KB";
			}
		}
	}
	
	function calcSum() {
		var result = 0;
		var length_q = $(".quantity");
		var oneQuantity = document.getElementsByClassName("quantity");
		var oneUnitprice = document.getElementsByClassName("unitprice");
		for(var i=0; i<length_q.length; i++) {
			result += oneQuantity[i].value * oneUnitprice[i].value;
		}
		$('#total').val(result);
		return result;
	}
	
	function sendFileToServer(formData, status) {
		var tagStr = "";
		$.ajax({
			url : "deleteUseless",
			type : "get",
			async : false,
			success : function() {
				var randomId = new Date().getTime();
				var jqXHR = $.ajax({
					xhr : function() {
						var xhrobj = $.ajaxSettings.xhr();
						if (xhrobj.upload) {
							xhrobj.upload.addEventListener('progress', function(event) {
								var percent = 0;
								var position = event.loaded || event.position;
								var total = event.total;
								if (event.lengthComputable) {
									percent = Math.ceil(position / total * 100);
								}
								$('#Progress_Loading').show();
							}, false);
						}
						return xhrobj;
					},
					url : "recognize",
					type : "POST",
					contentType : false,
					processData : false,
					cache : false,
					data : formData,
					success : function(resp) {
						alert("인식이 완료되었습니다.");
						$('#Progress_Loading').hide();
						$('.dragAndDropDiv').css({"background-image" : "url(/team/readResultImage?random=" + randomId + ")", 
							 "outline" : "none", "background-size" : "100% 100%"});
						$('#storename').val(resp.storename);
						$('#date').val(resp.buydate);
						$.each(resp.orderlist, function(index, item) {
							tagStr += '	<div class="right_4_div">';
							tagStr += '		<div class="right_4_1">';
							tagStr += '			<div class="right_productname"><input type="text" class="productname" value="' + item.productname + '"></div>';
							tagStr += '		</div>';
							tagStr += '		<div class="right_4_2">';
							tagStr += '			<div class="right_quantity"><input type="text" class="quantity" value="' + item.quantity + '"></div>';
							tagStr += '		</div>';
							tagStr += '		<div class="right_4_3">';
							tagStr += '			<div class="right_unitprice"><input type="text" class="unitprice" value="' + item.unitprice + '"></div>';
							tagStr += '		</div>';
							tagStr += '		<div class="right_4_4">';
							tagStr += '			<div><input type="button" class="btn_minus" value="-"></div>';
							tagStr += '		</div>';
							tagStr += '	</div>';
						});
						
						$('.right_4').html(tagStr);

						$('.btn_minus').on('click', function() {
							$(this).parent().parent().parent().remove();
						})
						$('input[type=text]').on('keyup', function(){
						    calcSum();
						});
						calcSum();
					}
				});
			}
		})
	}
});

function submitBtnClicked() {
	var receiptNo;
	var validateCheck;
	

	

	
	// 유효성 검사
	validateCheck = checkValidate();
	if(validateCheck == false) {
		alert("내용을 다시 확인 해주세요.");
		return false;
	}
	// 영수증 정보 등록하고 고유번호 받아오기
	var rec_scheduleNo = $('#scheduleNo').val();
	var rec_receiptDay = $('#date').val();
	var rec_receiptPlace = $('#storename').val();
	var rec_receiptPay = $('input[name=payment]:checked', '#form1').val();
	var rec_receiptMemo = $('#memo').val();
	var receiptData = { 
			"scheduleNo":rec_scheduleNo, 
			"recipeNo":"0", 
			"recipeDay":rec_receiptDay, 
			"recipePlace":rec_receiptPlace,
			"recipePay":rec_receiptPay, 
			"recipeMemo":rec_receiptMemo };
	$.ajax({
		url : 'insertReceiptInfo'
		, method : 'POST'		
		, data : JSON.stringify(receiptData)
		, dataType : 'text'
		, async : false
		, contentType : 'application/json; charset=UTF-8'
		, success : function (resp) {
			receiptNo = resp;
		}
	})
	
	// 받아온 영수증 고유번호로 상품목록 등록하기
	var rec_itemCategory = $('#category option:selected').val();
	var itemData = [];
	var childCount = $('.right_4_div').length;
	for(var i=0; i<childCount; i++) {
		var field_productname = $('.productname:eq('+ i +')').val();
		var field_quantity = $('.quantity:eq('+ i +')').val();
		var field_price = $('.unitprice:eq('+ i +')').val();
		var oneItem = {
				"recipeNo":receiptNo,
				"itemNo":rec_scheduleNo,
				"itemCategory":rec_itemCategory,
				"itemName":field_productname,
				"itemCount":field_quantity,
				"itemPrice":field_price
		};
		itemData.push(oneItem);
	}
	
	$.ajax({
		url : 'insertItemInfo'
		, method : 'post'
		, data : JSON.stringify(itemData)
		, dataType : 'json'
		, contentType : 'application/json; charset=UTF-8'
		, success : function (resp) {
		}
	})
	alert("등록이 완료되었습니다.");
	form1.submit();
}

function checkValidate() {
	var result = true;
	var field_date = $('#date').val();
	var field_storename = $('#storename').val();
	var field_memo = $('#memo').val();
	var childCount = $('.right_4_div').length;
	
	for(var i=0; i<childCount; i++) {
		var field_productname = $('.productname:eq('+ i +')').val();
		var field_quantity = $('.quantity:eq('+ i +')').val();
		var field_price = $('.unitprice:eq('+ i +')').val();
		if(field_productname.length == 0 || field_quantity.length == 0 || field_price.length == 0) {
			result = false; 
		}
		
		if(field_productname == 0 || field_quantity == 0 || field_price ==0){
			result = false;
		}
		
		
		
	}
	if(field_date.length == 0 || field_storename.length == 0 || field_memo.length == 0 || childCount == 0) {
		result = false;
	}
	return result;
}

function goBackBtnClicked() {
	form1.submit();
}
</script>
</head>
<body>
	<form id="form1" action="goBack" method="post">
	<input type="hidden" id="scheduleNo" value="${scheduleNo}">
		<div class="wrapper">
			<div class="head">
				<div class="head_1">
					<div id="head_1_item1" class="head_list">
						<input class="authority_check" type="hidden" value="${sessionScope.empAuthorization}">
						<ul>
							<li>
								<c:if test="${sessionScope.empAuthorization == 'employee'}">
									<a href="statistic" class="head_a_word">Statistic</a>
								</c:if>
								<c:if test="${sessionScope.empAuthorization == 'manager'}">
									<a href="statisticManager" class="head_a_word">Statistic</a>
								</c:if>
							</li>
							<c:if test="${sessionScope.loginId != null}">
								<li>
									<a href="calendar" class="head_a_word">Calendar</a>
								</li>
							</c:if>
							<li>
								<c:if test="${sessionScope.empAuthorization == null}">
									<a class="head_a_word">Statistic</a>
								</c:if>
							</li>
							<c:if test="${sessionScope.loginId == null}">
								<li>
									<a class="head_a_word">Calendar</a>
								</li>
							</c:if>	
							<li>
								<a class="head_a_word">ReciPhoto</a>
							</li>
						</ul>
					</div>
					<div id="head_1_item2" class="head_logo">
						<div>
							<a href="${pageContext.request.contextPath}"><img
								class="images" src="images/head_logo2.png"></a>
						</div>
					</div>
					<div id="head_1_item3" class="head_btn1">
						<ul>
							<li class="login_btn">
								<div class="login_image">
									<img src="images/login_logo2.png">
								</div>
								<div class="login_charater">
									<c:if test="${sessionScope.empAuthorization == 'employee'}">
										<a href="updateEmployee" class="head_a_word" id="word_login">${sessionScope.loginName}(Employee)</a>
									</c:if>
									<c:if test="${sessionScope.empAuthorization == 'manager'}">
										<a href="updateEmployee" class="head_a_word" id="word_login">${sessionScope.loginName}(Manager)</a>
									</c:if>
	
								</div>
							</li>
							<li class="signup_btn">
								<div class="signup_image">
									<c:if test="${sessionScope.loginId == null}">
										<img src="images/signup_logo1.png">
									</c:if>
									<c:if test="${sessionScope.loginId != null}">
										<img src="images/logout2.png">
									</c:if>
								</div>
								<div class="signup_charater">
									<a class="head_a_word" href="logout">Logout</a>
								</div>
							</li>
						</ul>
					</div>
				</div>
			</div>
			
		<div class="wrapper_container">
			<div class="wrapper_bottom">
				<div class="left-box">
					<div id="fileUpload" class="dragAndDropDiv">
						<div id="Progress_Loading">
							<img id="imagebox1" src="images\\Progress_Loading.gif" />
						</div>
					</div>
				</div>
				<div class="right-box">
					<div class="right_1">
						<div class="right_1_title">
							<div>
								날짜
							</div>
						</div>
						<div class="right_1_content">
							<div>
								<input type="date" id="date" readonly="readonly" value="${startDate}">
							</div>
						</div>
					</div>
	
					<div class="right_2">
						<div class="right_2_left">
							<div class="right_2_left_title">
								<div>
									사용처
								</div>	
							</div>
							<div class="right_2_left_content">
								<div>
									<input type="text" id="storename">
								</div>
							</div>
						</div>
						
						<div class="right_2_right">
							<div class="right_2_right_title">
								<div>
									카테고리
								</div>	
							</div>
							<div class="right_2_right_content">
								<div>
									<select id="category" name="category">
										<option value="식비">식비</option>
										<option value="교통비">교통비</option>
										<option value="숙박비">숙박비</option>
										<option value="접대비">접대비</option>
										<option value="유류비">유류비</option>
										<option value="기타">기타</option>
									</select>
								</div>
							</div>
						</div>
					</div>
	
					<div class="right_3">
						<div class="right3_1">
							<p>이름</p>
						</div>
						<div class="right3_2">
							<p>수량</p>
						</div>
						<div class="right3_3">
							<p>가격</p>
						</div>
					</div>
	
					<div class="right_4">
						
					</div>
					
					<div class="right_4_plus">
						<input class="btn_plus" type="button" class="btn_plus" value="목록추가">
					</div>
	
					<div class="right_5">
						<div class="right_5_title">
							<div>
								합계
							</div>
						</div>
						<div class="right_5_content">
							<div>
								<input type="text" id="total" readonly>
							</div>
						</div>
					</div>
	
					<div class="right_6">
						<div class="right_6_title">
							<div>
								결제 
							</div>
						</div>
						<div class="right_6_content">
							<div>
								<input type="radio" name="payment" value="Card" checked>Card
								<input type="radio" name="payment" value="Cash">Cash
							</div>
						</div>
					</div>
	
					<div class="right_7">
						<div class="right_7_title">
							<div>
								 메모
							</div>
						</div>
						<div class="right_7_content">
							<div> 
								<textarea rows="4" cols="40" id="memo"></textarea>
							</div>
						</div>
					</div>
	
					<div class="right_8">
						<div>
							<input type="button" value="등 록" id="btn_sendReceiptInfo" onclick="submitBtnClicked();"> 
							<input type="reset" value="취 소" id="btn_cancel">
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="foot">
		<div class="foot_up">
			<div>
				ⓒ 2018 Team-Reciphoto. All Rights Reserved
			</div>
		</div>
		<div class="foot_down">
			<div class="foot_down_left">
				<div>
					<p>Made By Team Reciphoto</p>
					<p>Layout 및 통계담당 : 하광석 | 영수증 인식 기능담당 : 이병권 </p>
					<p>DB 및 총괄담당 : 이규성 | Schedule 기능담당 : 송용규 </p>
					<p>전화문의 010-7179-5492</p>
					<p>E-mail : laneli1@naver.com</p>
				</div>
			</div>
			<div class="foot_down_right">
				<div>
					<p>해당 사이트의 모든 저작권은 Team Reciphoto에 있습니다.</p>
					<p>본 프로그램은 Team Reciphoto의 출장관리 시스템입니다.</p>	
				</div>
			</div>
		</div>
	</div>
	</form>
</body>
