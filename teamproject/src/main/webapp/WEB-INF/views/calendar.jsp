<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>calendar</title>
</head>
<link rel="stylesheet" href="resources/css/calendar.css">
<link rel="stylesheet" href="resources/css/calendar_responsive.css">
<script type="text/javascript" src="resources/jquery-3.3.1.min.js"></script>
<link rel='stylesheet' href='resources/js/fullcalendar.css' />
<script src='resources/js/lib/moment.min.js'></script>
<script src='resources/js/fullcalendar.js'></script>
<script type="text/javascript">
	var businessWith = "";

	$(function() {
		$("#insert_schedule").on("click", insert_schedule);
		$("#select_business").on("click", select_business);
		$("#delete_business").on("click", delete_business);
		$("#reciphoto").on("click", validateCheck);

		var author = $('.authorization').val();
		if (author == 'manager') {
			$('.head_1_item1_ul_li').css({
				marginLeft : '20px'
			})
			$('.head_1_item1_ul_li').css({
				marginRight : '20px'
			})
		}

		$('.head_a_word').mouseenter(function() {
			$(this).css({
				borderBottom : '3px solid black'
			})
		})

		$('.head_a_word').mouseleave(function() {
			$(this).css({
				borderBottom : '0px solid black'
			})
		})

		$('.head_a_word_emp').mouseenter(function() {
			$(this).css({
				borderBottom : '3px solid black'
			})
		})

		$('.head_a_word_emp').mouseleave(function() {
			$(this).css({
				borderBottom : '0px solid black'
			})
		})

		$('#calendar').fullCalendar({
			displayEventTime :false,
			selectable : true,
			header : {
				left : 'prev,next today',
				center : 'title',
				right : 'month,agendaWeek,agendaDay,listMonth'
			},
			eventLimit : true,
			views : {
				agenda : {
					eventLimit : 3
				// adjust to 6 only for agendaWeek/agendaDay
				}
			},
			events : add_plan(), //기존플랜불러오기
			
			eventClick : function(calEvent, jsEvent, view) {
  				$(this).on('dblclick', function() {
					var Eventid = "";
					if (calEvent.id != "") {
						Eventid = calEvent.id; // 18/09/15 여기까지 event id값을 받아와야댐
					} else {
						Eventid = scheduleNoMax;
					}
						ondblclick_event(Eventid);
				}) 

				if ($(this).css('border-color') != "rgb(255, 0, 0)") {
					$('td').children().css('border-color',"rgb(58, 135, 173)");
					$(this).css('border-color', 'red');

					clicked_borderColor = $(this).css('border-color');
					clicked_scheduleNo = calEvent.id;
					$("#scheduleNo").val(clicked_scheduleNo)
				} else {
					$(this).css('border-color', "rgb(58, 135, 173)");
					clicked_borderColor = $(this).css('border-color');
				}
			},//eventClick

			dayClick : function(date) {
				//alert('clicked ' + date.format());
				selectDate = date;
				selectDate = selectDate.format();

				$.ajax({
					method : 'get',
					url : 'selectbusinessWithNo',
					data : "selectDate=" + selectDate,
					success : function(resp) {
						businessWith = resp;
					}
				})
			},//하루만 클릭했을 때

			select : function(startDate, endDate) {
				var startDate = new Date(startDate)
				var endDate = new Date(endDate);
				endDate.setDate(endDate.getDate() - 1);
				startDate = getFormatDate(startDate);
				endDate = getFormatDate(endDate);

				$("#start").val(startDate);
				$("#end").val(endDate);
			}
		})//끝

	})

	//-------------------------------------------------------------------------------------------	
	var clicked_borderColor = ""; // 논클릭 , 클릭 색상의 임의값; 
	var clicked_scheduleNo = "";// 일정 시퀀스 번호

	// 일정 추가 버튼 클릭시 일정 등록 , 팝업
	function getFormatDate(endDate) { // endDate >YYYY-MM-DD로 포맷
		var year = endDate.getFullYear();
		var month = (1 + endDate.getMonth());
		month = month >= 10 ? month : '0' + month;
		var day = endDate.getDate();
		day = day >= 10 ? day : '0' + day;
		return year + '-' + month + '-' + day;
	}

	function insert_schedule() {
		$.ajax({
			method : 'get',
			url : 'checkBusiness',
			data : 'selectDate=' + selectDate,
			success : function(response) {
				if (response != 0) {
					$.ajax({
						method : "get",
						url : "checkRepresent",
						data : "businessWith=" + businessWith,
						dataType : 'text',
						success : function(resp) {
							var empId = $("#empid").val();
							var start = $("#start").val();
							var end = $("#end").val();
							if (resp == empId && start == end) {
								window.open("addPlan?selectDate="+ selectDate	+ "&businessWith="+ businessWith,"insert_schedule","top=200,left=300,width=400,height=400");
							} 
							else {
								alert("권한이 없습니다.")
							}
						}
					})//end
				} 
				else {
					alert("등록된 출장이 없습니다. 출장을 먼저 등록해주세요.")
				}//end
			}
		})
	}

	var box = [];
	function add_plan() {
		$.ajax({
			method : "get",
			url : "selectMySchedule",
			contentType : "application/json;charset=utf-8",
			async : false,
			success : function(resp) {

				for (var i = 0; i < resp.length; i++) {
					var sendData = {}

					$.extend(sendData, {
						id : resp[i].scheduleNo,
						title : resp[i].scheduleTitle,
						start : resp[i].scheduleDay,
						description : resp[i].scheduleContext
					})
					box.push(sendData)
				}
			},//success
			error : function() {
				alert("오류임")
			}
		})

		$.ajax({
			method : "GET",
			url : "businessMy",
			contentType : "application/json;charset=utf-8",
			async : false,
			success : function(resp) {
				for (var i = 0; i < resp.length; i++) {
					var sendData = {}
					var start = new Date(resp[i].businessStart);
					var end = new Date(resp[i].businessEnd);
					var color = resp[i].businessColor;
					var businessNo = resp[i].businessNo;
					end.setDate(end.getDate() + 1);
					start = getFormatDate(start);
					end = getFormatDate(end);

					$.extend(sendData, {
						id : businessNo,
						start : start,
						end : end,
						overlap : false,
						rendering : 'background',
						color : color
					})
					box.push(sendData)
				}
			},
			error : function() {
				alert(" 실패 ")
			}
		})
		return box;
	}//add_plan끝

	function select_business(startDate, endDate) {
		var startDate = $("#start").val();
		var endDate = $("#end").val();
		$.ajax({
			method : 'get',
			url : 'alreadyBusiness',
			data : "startDate=" + startDate + "&endDate=" + endDate,
			contentType : 'application/json;charset=uft-8',
			success : function(resp) {
				if (resp) {
					window.open("addBusiness?startDate=" + startDate
							+ "&endDate=" + endDate, "addBusiness",
							"top=200,left=300,width=400,height=400");
				} else {
					alert("지정된 출장이 있습니다.")
				}
			}
		})
	}

	function keydown(event) {

		if (clicked_borderColor == "rgb(255, 0, 0)" && event.keyCode == "8") {
			$.ajax({
				method : "get",
				url : "deleteSchedule",
				data : "scheduleNo=" + clicked_scheduleNo,
				contentType : "application/json;charset=utf-8",
				success : function(resp) {
					if (resp) {
						$('#calendar').fullCalendar('removeEvents', clicked_scheduleNo); // 새로고침
					} else {
						alert("권한이 없습니다.")
					}
				},
				error : function() {
					alert("실패임요")
				}
			})
		} 
		else {
			return;
		}
	}

	var scheduleNoMax = "";
	function render(sendData) { // 일정 ,스케줄 인잇
		$.ajax({
			method : 'get',
			url : 'checkScheduleNo',
			data : "selectDay=" + sendData.scheduleDay,
			dataType : 'text',
			context : 'application/json;charset=utf-8',
			success : function(resp) {
				scheduleNoMax = resp;
				clicked_scheduleNo = scheduleNoMax;
				$('#calendar').fullCalendar('renderEvent', {
					id : scheduleNoMax,
					title : sendData.scheduleTitle,
					start : sendData.scheduleDay,
					allDay : true
				});
			}
		})
	}

	function render2(send) { // 방금 등록한 비즈니스 인잇
		var End = new Date(send.businessEnd);
		End.setDate(End.getDate() + 1);
		End = DateFormat(End);
		var businessNo = "";
		$.ajax({
			method : 'get',
			url : 'seleteBusinessNo',
			data : "selectDate=" + send.businessEnd,
			dataType : 'text',
			contentType : 'application/json;charset=UTF-8',
			success : function(resp) {
				$('#calendar').fullCalendar('renderEvent', {
					id : resp,
					title : send.businessName,
					start : send.businessStart,
					end : End,
					overlap : false,
					color : send.businessColor,
					rendering : 'background',
					allDay : true
				});
			}
		})
	}

	function render3(send) {
		$('#calendar').fullCalendar('removeEvents', send.id)
		$('#calendar').fullCalendar('renderEvent', {
			id : send.id,
			start : send.start,
			title : send.title,
			description : send.description,
			allDay : true
		});
	}

	function DateFormat(End) {
		var year = End.getFullYear();
		var month = (1 + End.getMonth());
		month = month >= 10 ? month : '0' + month;
		var day = End.getDate();
		day = day >= 10 ? day : '0' + day;
		return year + '-' + month + '-' + day;
	}

	function delete_business() {
		var Event_No = "";
		$.ajax({
			method : 'get',
			url : 'seleteBusinessNo',
			data : 'selectDate=' + selectDate,
			success : function(resp) {
				Event_No = resp;
			}
		})

		var schList = [];
		$.ajax({
			method : 'get',
			url : 'selectScheduleDelete',
			data : "businessWith=" + businessWith,
			success : function(response) {
				schList = response;
			}
		})

		$.ajax({
			method : 'get',
			url : 'deleteBusiness',
			data : 'selectDate=' + selectDate,
			contentType : "application/json;charset=utf-8",
			success : function(resp) {
				if (resp) {
					alert("출장이 삭제되었습니다.");
					$('#calendar').fullCalendar('removeEvents', Event_No);
					for (var i = 0; i < schList.length; i++) {
						$('#calendar').fullCalendar('removeEvents', schList[i]);
					}
				} 
				else {
					alert("권한이없습니다.");
				}
			},
			error : function() {
				alert("출장을 다시 선택해주세요.")
			}
		})
	}

	function ondblclick_event(Eventid) {
		var empid = $("#empid").val();
		$.ajax({
			method : 'get',
			url : 'updateCheck',
			data : 'scheduleNo=' + Eventid,
			dataType : 'text',
			contentType : 'application/json;charset=utf-8',
			success : function(resp) {
				if (resp == empid) {
					window.open("checkSchedule?scheduleNo=" + Eventid, "CheckSchedule",
							"top=100,left=300,width=800,height=600");
				}
			}
		})
	}
	
	function validateCheck(){
		var empId = $("#empid").val();
		$.ajax({
			method:"get",
			url : "checkRepresenter",
			data : "scheduleNo=" + clicked_scheduleNo,
			success :function(resp){
				
					if(clicked_borderColor != "rgb(255, 0, 0)"){
						alert("권한이 없습니다.")
					}else{
						if(resp == empId){
						document.getElementById('reci').submit();
						}else{
							alert("권한이 없습니다.")
						}
					}
			},
			error:function(){
				alert("권한이 없습니다.")
			}
				
		})
		

	}
</script>

<body id="select_schedule" onkeydown="keydown(event)">
	<div class="wrapper">
		<input class="authorization" type="hidden"
			value="${sessionScope.empAuthorization}">
		<div class="head">
			<div class="head_1">
				<div id="head_1_item1" class="head_list">
					<input class="authority_check" type="hidden"
						value="${sessionScope.empAuthorization}">
					<ul class="head_1_item1_ul">
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
		<div class="calendar_main">
			<div id="calendar">
			</div>
			<div class="calendar_btn">
				<form id = "reci" action="insert_reciphoto" method ="get">
				<input type="hidden" name="startDate" id="start"> 
				<input type="hidden" name="endDate" id="end">
				<input type="hidden" id="companyNo" value="${sessionScope.companyNo}"> 
				<input type="hidden" value="${sessionScope.loginId}" id="empid"> 
				<input type="button" value="출장 선택" id="select_business"> 
				<input type="button" value="출장 삭제" id="delete_business">
				<input type="button" value="영수증 등록" id="reciphoto">
				<input type="button" value="일정 등록" id="insert_schedule">
				<input type="hidden" name="scheduleNo"id="scheduleNo">
				</form>
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
	</div>
</body>
</html>