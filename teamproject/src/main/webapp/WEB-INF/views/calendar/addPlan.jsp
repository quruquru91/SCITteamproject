<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="resources/css/addPlan.css">
<title>일정 등록</title>
<script src='resources/js/lib/jquery.min.js'></script>
<script>
	function add_plan() {
		var scheduleContext = $("#scheduleContext").val();
		var scheduleTitle = $("#scheduleTitle").val();
		var schedulePlace = $("#schedulePlace").val();
		var scheduleDay = $("#scheduleDay").val();
		var empId = $("#empId").val();
		var businessWith = $("#businessWith").val();

		if (scheduleContext < 2 || schedulePlace == "") {
			alert("내용을 확인해주세요.")
		} else {
			$.ajax({
				method : "get",
				data:"businessWith="+businessWith,
				url : "selectBusinessNo",
				dataType : 'text',
				async : false,
				success : function(resp) {

						var sendData = {
							"businessNo" : resp,
							"scheduleTitle" : scheduleTitle,
							"scheduleDay" : scheduleDay,
							"schedulePlace" : schedulePlace,
							"scheduleContext" : scheduleContext
						}

						$.ajax({
							method : 'POST',
							url : 'insertPlan',
							data : JSON.stringify(sendData),
							async : false,
							contentType : 'application/json;charset=UTF-8',
							success : function(resp) {
								opener.render(sendData);
								//alert("전송완료");
							},
							error : function() {
								alert("에러_")
							}
						})//끝

						window.close();

				}
			})

		}
	}

	function close_plan() {
		window.close()
	}
</script>


</head>
<body>
<h2 align="center">일정등록</h2>
	
	<div class="wrapper">
		
		<div>		
			 <input type="hidden" id="businessWith" value="${businessWith}" /> 
	 	</div>
	 	
	 	<div class="wrapper_id">
	 		<div> 
				<input type="hidden" id="scheduleNo" readonly="readonly" /> 
			 	<input type="hidden" id="empId" value="${sessionScope.loginId}" /> 
			</div>
		</div>

		 
		 <div class="wrapper_date">
		 	 <div class="wrapper_date_title">
		 		<div>
			 		날짜 
			 	</div>
			 </div>
			 <div class="wrapper_date_content">
			 	<div>
			 		<input type="date" id="scheduleDay" readonly="readonly" value="${selectDate}" />
			 	</div>
			 </div>
		 </div>

		 <div class="wrapper_title">
		 	 <div class="wrapper_title_title">
		 		<div>
		 		 	일정제목
		 		 </div>
		 	 </div>
			 <div class="wrapper_title_content">
			 	<div>
			 		<input type="text" id="scheduleTitle" name="scheduleTitle" /> 
			 	</div>
			 </div>
		 </div>
		 
		 <div class="wrapper_place">
		 	<div class="wrapper_place_title">
		 		<div>
				 	장소
				</div>
			</div> 
			<div class="wrapper_place_content">
				<div>
				 	<input type="text" id="schedulePlace" name="schedulePlace" /> 
				</div>
			 </div>
		 </div>

		 <div class="wrapper_content">
		 	<div class="wrapper_content_title">
		 		<div>
		 			일정내용
		 		</div>
			 </div>
			 <div class="wrapper_content_content">
			 	<div> 
			 		<textarea rows="6" cols="25" id="scheduleContext" name="scheduleContext" style="resize: none;"></textarea> 
			 	</div>
			 </div>
		 </div>

		
		 <div class="wrapper_buttons">
			<div>
				<input type="button" value="등록" id="addPlan" onclick="add_plan()"> 
				<input type="reset" value="취소" id="closePlan" onclick="close_plan()"> 
			</div>
		 </div>

		 

	</div>

</body>
</html>