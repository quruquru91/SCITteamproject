<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>signup</title>
</head>
<link rel="stylesheet" href="resources/css/signup.css">
<link rel="stylesheet" href="resources/css/signup_responsive.css">
<script type="text/javascript" src="resources/jquery-3.3.1.min.js"></script>
<script type="text/javascript">
$(function() {
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
	
	$('#emp_id').keyup(checkid);
	$('.signup_button').on('click', checkall)
	$('.signup_button').mouseenter(function() {
		$(this).css({backgroundColor : 'black'})
		$(this).css({color: 'white'})
	})
	
	$('.signup_button').mouseleave(function() {
		$(this).css({backgroundColor : 'white'})
		$(this).css({color: 'black'})
	})
})
	
function checkid() {
	var empid = $(this).val();
	
	if(empid.length < 3 || empid.length > 12 || empid.trim().length == 0){
		$('.signup_button').attr('disabled','disabled');
		$('.showId_result').html("Impossible");
		$('.showId_result').css('color','red');
		$('.signup_button').val("SIGN UP");
	}else {
		var objectData = {'empid' : empid};
		$.ajax({
			method: 'post',
			url: 'checkId',
			data: JSON.stringify(objectData),
			dataType: 'json',
			contentType: 'application/json; charset=UTF-8',
			success: function(resp) {
				if(resp == 1) {
					$('.signup_button').attr('disabled','disabled');
					$('.showId_result').html("Impossible");
					$('.showId_result').css('color','red');
					$('.signup_button').val("SIGN UP");
				}else {
					$('.signup_button').removeAttr('disabled');
					$('.showId_result').html("Possible");
					$('.showId_result').css('color','blue');
					$('.signup_button').val("SIGN UP");
				}
			}
		})
	}
}	

function checkall() {
	$('.signup_form').submit();
}
</script>
<body>
	<div class="wrapper">
		<div class="head">
			<div class="head_1">
				<div id="head_1_item1" class="head_list">
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
							src="images/head_logo2.png"></a>
					</div>
				</div>
				<div id="head_1_item3" class="head_btn1">
					<ul>
						<li class="login_btn">
							<div class="login_image">
								<img src="images/login_logo2.png">
							</div>
							<div class="login_charater">
								<a href="login" class="head_a_word" id="word_login">Login</a>
							</div>
						</li>
						<li class="signup_btn">
							<div class="signup_image">
								<img src="images/signup_logo2.png">
							</div>
							<div class="signup_charater">
								<a class="head_a_word" href="signup">Sign Up</a>
							</div>
						</li>
					</ul>
				</div>
			</div>
		</div>
		
		<div class="signup_div">
			
			<div class="signup_main">
				<div class="signup_main_left">
					<form class="signup_form" action="signup" method="post">
					<div>
						<h1>Sign Up</h1>
					</div>
					<div>
						<div>Company</div>
						<div>
							<input id="emp_company" class="signup_main_left_input" type="text" name="companyno">
						</div>
					</div>
					<div>
						<div>Name</div>
						<div>
							<input id="emp_name" class="signup_main_left_input" type="text" name="empname">
						</div>
					</div>
					<div>
						<div>Id   <span class="showId_result"></span></div>
						<div>
							<input id="emp_id" class="signup_main_left_input" type="text" name="empid">
						</div>
					</div>
					<div>
						<div>Password</div>
						<div>
							<input id="emp_password" class="signup_main_left_input" type="password" name="emppassword">
						</div>
					</div>
					<div>
						<div>Department</div>
						<div>
							<input id="emp_department" class="signup_main_left_input" type="text" name="empdept">
						</div>
					</div>
					<div>
						<div>Phone</div>
						<div>
							<input id="emp_phone" class="signup_main_left_input" type="text" name="empphone">
						</div>
					</div>
					</form>
					
					<div class="signup_main_left_btn">
						<input class="signup_button" type="button" value="Sign up">
					</div>
					
				</div>
				<div class="signup_main_right">
					<img src="images/signup_background.png">
				</div>
			</div>	
		</div>

	</div>
</body>
</html>