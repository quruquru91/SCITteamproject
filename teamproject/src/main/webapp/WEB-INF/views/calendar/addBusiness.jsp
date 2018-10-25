<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출장 일정 등록</title>
<link rel="stylesheet" href="resources/css/addBusiness.css">
<script src='resources/js/lib/jquery.min.js'></script>

<script>
	var coworkerList = [];
	var BusinessList = [];
	var send = {};

	$(function() {
		var startDate = $("#startDate").val();
		$("#start_date").val(startDate);

		var endDate = $("#endDate").val();
		$("#end_date").val(endDate);

		$("#add").on('click', add_coworker);
		$('#addBusiness').on('click', add_Business);
		$('#closePlan').on('click', close_plan);
		$("#btn_click").on('click', sendBusiness)

	})

	function add_Business(list) {
		var BusinessName = $("#BusinessName").val();
		var business_memo = $("#business_memo").val();
		var Main = $("#Main").val();
		var Sub = $("#Sub").val();
		var start_date = $("#start_date").val();
		var end_date = $("#end_date").val();
		var color = $("#color").val();
		
		send = {
			"businessName" : BusinessName,
			"businessStart" : start_date,
			"businessEnd" : end_date,
			"businessMemo" : business_memo,
			"businessColor" : color
		}
		

		$.each(list, function(index, item) {

			var empid = item.empid;
			var sendData = {
				"businessName" : BusinessName,
				"businessMemo" : business_memo,
				"businessStart" : start_date,
				"businessEnd" : end_date,
				"businessLocationMain" : Main,
				"businessLocationSub" : Sub,
				"businessColor" : color,
				"empId" : empid
			}
			BusinessList.push(sendData);
			
		})
	}

	function sendBusiness() {
		
		var BusinessName = $("#BusinessName").val();
		var business_memo = $("#business_memo").val();
		var Main = $("#Main").val();
		var Sub = $("#Sub").val();
		var start_date = $("#start_date").val();
		var end_date = $("#end_date").val();
		var color = $("#color").val();
		
	
		var sendData = { //로그인된 아이디 혼자 저장할때 + 본인 출장
				"businessName" : BusinessName,
				"businessMemo" : business_memo,
				"businessStart" : start_date,
				"businessEnd" : end_date,
				"businessLocationMain" : Main,
				"businessLocationSub" : Sub,
				"businessColor" : color,
				"empId" : $("#loginId").val()
			}
			BusinessList.push(sendData);
		
			send = {
				"businessName" : BusinessName,
				"businessStart" : start_date,
				"businessEnd" : end_date,
				"businessMemo" : business_memo,
				"businessColor" : color
			}
		
		
		
		$.ajax({
			method : 'POST',
			url : 'insertBusiness',
			dataType : 'json',
			data : JSON.stringify(BusinessList),
			contentType : 'application/json;charset=UTF-8',
			success : function(resp) {
				opener.render2(send)
				window.close();
			},
			error : function() {
				alert("insertBusinessError");
			}
		});
	}

	function close_plan() {
		window.close()
	}

	function add_coworker() {
		var companyNo = $("#companyNo").val();
		window.open("addCoworker?companyNo=" + companyNo, "ADDPLAN_1",
				"top=200,left=200,width=500,height=200");
	}

	function CoworkerList(list) {
		var result = '';
		for ( var i in list) {
			result += '<div class="content">';
			result += '	<div>' + list[i].empname + '</div>';
			result += '</div>';
		}

		$("#result_2").html(result);

	}
</script>


</head>
<body>
	<h2 align="center">출장 일정 등록</h2>
		<div class="wrapper">
			<div class="wrapper_content">
			
				<div class="wrapper_title">
					<div class="wrapper_title_title">
						<div>
							출장 제목
						</div>
					</div>
					<div class="wrapper_title_content">
						<div>
							<input type="text" id="BusinessName" name="BusinessName" />
						</div>	
					</div>
				</div>
	
				<div class="wrapper_date">
					<div class="wrapper_date_title">
						<div>
							Start
						</div>
					</div>
						
					<div class="wrapper_date_content">
						<div>
							<input type="date" id="start_date" value="2018-08-08" name="start_date" readonly="readonly" /> 
							<input type="hidden" id="startDate" value="${startDate}" readonly="readonly" />
						</div>
					</div>
				</div>
				
	
				<div class="wrapper_date2">
					<div class="wrapper_date2_title">
						<div>
							End
						</div>
					</div>
					<div class="wrapper_date2_content">
						<div>	
							<input type="date" id="end_date" value="2018-08-08" name="end_date" readonly="readonly" /> 
							<input type="hidden" id="endDate" value="${endDate}" readonly="readonly" />
						</div>
					</div>
				</div>
	
				<div class="wrapper_place">
					<div class="wrapper_place_title">
						<div>
							지역선택
						</div>
					</div>
					<div class="wrapper_place_content">
						<div>
							<select id="Main" name="Main" >
								<option value="서울특별시">서울특별시</option>
								<option value="부산광역시">부산광역시</option>
								<option value="대구광역시">대구광역시</option>
								<option value="인천광역시">인천광역시</option>
								<option value="광주광역시">광주광역시</option>
								<option value="대전광역시">대전광역시</option>
								<option value="울산광역시">울산광역시</option>
								<option value="세종특별자치시">세종특별자치시</option>
								<option value="경기도">경기도</option>
								<option value="강원도">강원도</option>
								<option value="충청북도">충청북도</option>
								<option value="충청남도">충청남도</option>
								<option value="전라북도">전라북도</option>
								<option value="전라남도">전라남도</option>
								<option value="경상북도">경상북도</option>
								<option value="경상남도">경상남도</option>
								<option value="제주특별자치도">제주특별자치도</option>
							</select>
						</div>
					</div>
				</div>
	
				<div class="wrapper_place2">
					<div class="wrapper_place2_title">
						<div>
							세부지역선택
						</div>	
					</div>
					<div class="wrapper_place2_content">
						<div>
							<input type="text" id="Sub" name="Sub" />
						</div>
					</div>
				</div>
				
				<div class="wrapper_color">
					<div class="wrapper_color_title">
						<div>
							색상 선택
						</div>
					</div>
					<div class="wrapper_color_content">
						<div>
							<select id="color" name="color">
								<option value="#ff9f89">빨강</option>
								<option value="#FFFF00">노랑</option>
								<option value="#04B404">초록</option>
							</select>
						</div>
					</div>
				</div>
				
				<div class="wrapper_memo">
					<div class="wrapper_memo_title">
						<div>
							출장메모
						</div>	
					</div>
					<div class="wrapper_memo_content">
						<div>
							<input type="text" id="business_memo">
						</div>
					</div>
				</div>
				
				<div class="wrapper_company">
					<div class="wrapper_company_title">
						<div>
							동료선택
						</div>	
					</div>
					<div class="wrapper_company_content">
						<div>
							<input type="button" id="add" value=" 동료선택 + " />
						</div>
					</div>
				</div>
	
	
	
				<div class="wrapper_company2"> 
					<div class="wrapper_company2_title">
						<div>
							동행자 목록
						</div>
					</div>
					<div class="wrapper_company2_content">
						<div id="result_2">
						</div>
					</div>
				</div>
				<input type="hidden" id="loginId" value="${sessionScope.loginId}" />
	
	
				<div class="wrapper_buttons">
					<div class="wrapper_buttons_content">
						<input type="button" value="등록" id="btn_click">
						<input type="reset" value="취소" id="closePlan">
					</div>
					<div class="result"></div>
				</div>
	
			<input type="hidden" id="companyNo" value="${sessionScope.companyNo}">
		</div>
	</div>

</body>
</html>