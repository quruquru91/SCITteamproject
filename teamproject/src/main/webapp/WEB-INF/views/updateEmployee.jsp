<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>updateEmployee</title>
</head>
<link rel="stylesheet" href="resources/css/updateEmployee.css">
<link rel="stylesheet" href="resources/css/updateEmployee_responsive.css">
<script type="text/javascript" src="resources/jquery-3.3.1.min.js"></script>
<script type="text/javascript">
$(function() {

		$('.head_a_word').mouseenter(function() {
			$(this).css({borderBottom : '3px solid black'})
		})		
		
		$('.head_a_word').mouseleave(function() {
			$(this).css({borderBottom : '0px solid black'})
		})
		$('.head_a_word_emp').mouseenter(function() {
			$(this).css({borderBottom : '3px solid black'})
		})		
		
		$('.head_a_word_emp').mouseleave(function() {
			$(this).css({borderBottom : '0px solid black'})
		})
		
		$('.update_button').on('click',sendUpdate);
})	

function sendUpdate(){
	$('.update_form').submit();
}
</script>
<body>
	<div class="wrapper">
	<input class="authorization" type="hidden" value="${sessionScope.empAuthorization}">
		<div class="head">
			<div class="head_1">
				<div id="head_1_item1" class="head_list">
				<input class="authority_check" type="hidden" value="${sessionScope.empAuthorization}">
					<ul>
						<li>
							<c:if test="${sessionScope.empAuthorization == 'employee'}">
								<a href="statistic" class="head_a_word_emp">Statistic</a>
							</c:if>
							<c:if test="${sessionScope.empAuthorization == 'manager'}">
								<a href="statisticManager" class="head_a_word_emp">Statistic</a>
							</c:if>
						</li>
						<c:if test="${sessionScope.loginId != null}">
							<li>
								<a href="calendar" class="head_a_word">Calendar</a>
							</li>
						</c:if>
						<li>
							<c:if test="${sessionScope.empAuthorization == null}">
								<a class="head_a_word_emp">Statistic</a>
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
				<div id="head_1_item2" class="head_logo" >
					<div>
						<a href="${pageContext.request.contextPath}"><img class="images" src="images/head_logo2.png"></a>
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
									<a class="head_a_word" id="word_login">${sessionScope.loginName}(Employee)</a>
								</c:if>	
								<c:if test="${sessionScope.empAuthorization == 'manager'}">
									<a class="head_a_word" id="word_login">${sessionScope.loginName}(Manager)</a>
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
		
		<div class="update_div">
			<div class="update_main">
				<div class="update_main_left">
					<form class="update_form" action="updateEmployee" method="post">
					<div>
						<h1>Update Info</h1>
					</div>
					<div>
						<div>Company</div>
						<div>
							<input id="emp_company" class="update_main_left_input" type="text" name="companyno" value="${employee.companyno}">
						</div>
					</div>
					<div>
						<div>Name</div>
						<div>
							<input id="emp_name" class="update_main_left_input" type="text" name="empname" readonly="readonly" value="${employee.empname}">
						</div>
					</div>
					<div>
						<div>Id</div>
						<div>
							<input id="emp_id" class="update_main_left_input" type="text" name="empid" readonly="readonly" value="${employee.empid}">
						</div>
					</div>
					<div>
						<div>Password</div>
						<div>
							<input id="emp_password" class="update_main_left_input" type="password" name="emppassword" value="${employee.emppassword}">
						</div>
					</div>
					<div>
						<div>Department</div>
						<div>
							<input id="emp_department" class="update_main_left_input" type="text" name="empdept" value="${employee.empdept}">
						</div>
					</div>
					<div>
						<div>Phone</div>
						<div>
							<input id="emp_phone" class="update_main_left_input" type="text" name="empphone" value="${employee.empphone}">
						</div>
					</div>
					</form>
					
					<div class="update_main_left_btn">
						<input class="update_button" type="button" value="Update Info">
					</div>
					
				</div>
				<div class="update_main_right">
					<img src="images/signup_background.png">
				</div>
			</div>	
		</div>
		
		
		
		
	</div>
</body>
</html>