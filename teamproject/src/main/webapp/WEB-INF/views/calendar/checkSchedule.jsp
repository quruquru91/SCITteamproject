<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>일정 수정</title>
<link rel="stylesheet" href="resources/css/checkSchedule.css">
<script src='resources/js/lib/jquery.min.js'></script>
<script>
	function close_plan() {
		window.close()
	}

	$(function() {
		$("#updateSchedule").on("click", updateSchedule);
		init();
	})
	
	function init(){
		var radioVal = $(':input:radio[name=radiobutton]:checked').val();
		
		if(radioVal =="schedule"){
			var str = "<table>" ;
		}
		
		var scheduleNo = $("#scheduleNo").val();
		var imageCount = 1;
		var miniImgTag = "";
		$.ajax({
			url : "getNumberOfImages", 
			method : "post",
			data : "scheduleNo=" + scheduleNo,
			success : function(count) {
				for(var i=1; i<=count; i++) {
					miniImgTag += '<img src="/team/readImage?imageNumber=' 
						+ i + '&scheduleNo=' + scheduleNo + '" width="100" height="150" onclick="changeImage(' + i + ');">&nbsp;';
				}
				$('.right_top').html(miniImgTag);
			}
		})
	}
	
	function changeImage(imageNumber) {
		var scheduleNo = $("#scheduleNo").val();
		var bigImageTag = "";
		bigImageTag = '<img src="/team/readImage?imageNumber=' + imageNumber + '&scheduleNo=' + scheduleNo + '" width="300" height="400">';
		$('.right_bottom').html(bigImageTag);
	}
	
	function updateSchedule() {

		var businessNo = $("#businessNo").val();
		var scheduleNo = $("#scheduleNo").val();
		var scheduleTitle = $("#scheduleTitle").val();
		var scheduleDay = $("#scheduleDay").val();
		var scheduleContext = $("#scheduleContext").val();
		var schedulePlace = $("#schedulePlace").val();
		var empId = $("#empId").val();
		var schedule_Day = $("#schedule_Day").val();
		$("#scheduleDay").val(schedule_Day);
		var scheduleDay = $("#scheduleDay").val();

		var sendData = {
			"businessNo" : businessNo,
			"scheduleNo" : scheduleNo,
			"scheduleTitle" : scheduleTitle,
			"scheduleDay" : scheduleDay,
			"scheduleContext" : scheduleContext,
			"schedulePlace" : schedulePlace
		}

		var send = {
			id : scheduleNo,
			start : scheduleDay,
			title : scheduleTitle,
			description : scheduleContext
		}

		$.ajax({
			method : 'post',
			url : 'updateSchedule',
			data : JSON.stringify(sendData),
			dataType : 'text',
			contentType : 'application/json;charset=UTF-8',
			async : false,
			success : function(resp) {
				opener.render3(send);
				window.close();
			},
			error : function() {
				alert("수정 오류");
			}
		})
	}
</script>
</head>
<body>
	<h2 align="center">일정수정 및 영수증 확인</h2>

	<div class="wrapper">
		<div class="top">
			<div class="left">
			
				<div class="top_1">
					<div class="top_1_title">
						<div>
							날짜 
						</div>
					</div>
					<div class="top_1_content">
						<div>
							<input type="date" id="scheduleDay" name="scheduleDay" readonly="readonly" value="${Schedule.scheduleDay}" /> 
							<input type="hidden" id="schedule_Day" value="${Schedule.scheduleDay}" />
						</div>
					</div>
				</div>

				<div class="top_2">
					<div class="top_2_title"> 
						<div>
							일정제목
						</div>
					</div>
					<div class="top_2_content">
						<div>
					 		<input type="text" id="scheduleTitle" name="scheduleTitle" value="${Schedule.scheduleTitle}" />
					 	</div>
					</div>
				</div>

				<div class="top_3">
					<div class="top_3_title"> 
						<div>
							장소
						</div>
					</div>
					<div class="top_3_content">
						<div>
					 		<input type="text" id="schedulePlace" name="schedulePlace" value="${Schedule.schedulePlace}" />
						</div>
					</div>
				</div>


				<div class="top_4">
					<div class="top_4_title">
						<div>
							일정내용
						</div>
					</div>
					<div class="top_4_content">
						<div>
							<textarea rows="15" cols="35" id="scheduleContext" name="scheduleContext" style="resize: none;">${Schedule.scheduleContext}</textarea>
						</div>
					</div>
				</div>

				<div class="top_5">
					<input type="hidden" id="businessNo" value="${Schedule.businessNo}" />
					<input type="hidden" id="scheduleNo" value="${Schedule.scheduleNo}" />
					<input type="hidden" id="empId" value="${sessionScope.loginId}" />
				</div>

			</div>

			<div class="right">
				<div class="right_top"></div>

				<div class="right_bottom"></div>
			</div>


		</div>

		<div class="bottom">

			<input type="button" value="수정" id="updateSchedule" /> <input
				type="reset" value="취소" id="closePlan" onclick="close_plan()" />

		</div>

	</div>
</body>
</html>