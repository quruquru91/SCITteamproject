<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>index</title>
</head>
<link rel="stylesheet" href="resources/css/index.css">
<link rel="stylesheet" href="resources/css/index_responsive.css">
<script type="text/javascript" src="resources/jquery-3.3.1.min.js"></script>
<script type="text/javascript">
$(function() {

	$('.head_1').mouseenter(function() {
		$('.images').attr('src','images/head_logo2.png')
		$('.login_image').children().attr('src','images/login_logo2.png')
		if($('.login_check').val() == null) { 
			$('.signup_image').children().attr('src','images/signup_logo2.png')
		}else {
			$('.signup_image').children().attr('src','images/logout2.png')
		}
	})		
	
	$('.head_1').mouseleave(function() {
		$('.images').attr('src','images/head_logo1.png')
		$('.login_image').children().attr('src','images/login_logo1.png')
		if($('.login_check').val() == null) { 
			$('.signup_image').children().attr('src','images/signup_logo1.png')
		}else {
			$('.signup_image').children().attr('src','images/logout1.png')
		}
	})		
	
	$('.head_a_word').mouseenter(function() {
		$(this).css({borderBottom : '3px solid black'})
	})		
	
	$('.head_a_word').mouseleave(function() {
		$(this).css({borderBottom : '0px solid black'})
	})
	
	$('.head_menubar').on('click', showmenu)
	$('.menu_close').on('click', hidemenu)

})

function showmenu() {
	$('.menu_slide').animate ({
	left: "0px" }, 
	500, 
	function() {
		$('.menu_close').css("display","block")		
	})
}

function hidemenu() {
	$('.menu_slide').animate ({
	left: "-300%" }, 
	500, 
	function() {
		$('.menu_close').css("display","none")		
	})
}

</script>
<body background="images/main.png">
<div class="wrapper">
	<div class="menu_slide">
		<div>
			<img class="menu_close" src="images/menuclose.png">
		</div>
		<ul>
			<li><a>Product</a></li>
			<li><a>ReciPhoto</a></li>
			<li><a>Features</a></li>
			<c:if test="${sessionScope.loginId != null}">
				<li><a href="calendar">Calendar</a></li>
			</c:if>	
			<c:if test="${sessionScope.loginId == null}">
				<li><a href="login">Login</a></li>
				<li><a href="signup">Sign Up</a></li>
			</c:if>
			
			<c:if test="${sessionScope.loginId != null}">
				<c:if test="${sessionScope.empAuthorization == 'employee'}">
					<li><a href="updateEmployee" class="head_a_word" id="word_login">${sessionScope.loginName}(Employee)</a></li>
				</c:if>
				<c:if test="${sessionScope.empAuthorization == 'manager'}">
					<li><a class="head_a_word" id="word_login">${sessionScope.loginName}(Manager)</a></li>
				</c:if>
			</c:if>
			<c:if test="${sessionScope.loginId != null}">
				<li><a class="head_a_word" href="logout">Logout</a></li>
			</c:if>
		</ul>
	</div>
	
	<div class="head_container">

		<div class="head">
			<div class="head_1">
				<div id="head_1_item1" class="head_list">
					<a><img class="head_menubar" src="images/menubar.png"></a>
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
				<div id="head_1_item2" class="head_logo" >
					<div>
						<div class="head_1_item2_2">
							<a href="${pageContext.request.contextPath}"><img class="images" src="images/head_logo1.png"></a>
						</div>	
					</div>
				</div>
				<div id="head_1_item3" class="head_btn1">
					<ul>
						<li class="login_btn">
							<div class="login_image">
								<img src="images/login_logo1.png">
							</div>
							<div class="login_charater">
								<c:if test="${sessionScope.loginId == null}">
									<a href="login" class="head_a_word" id="word_login">Login</a>
								</c:if>
								<c:if test="${sessionScope.loginId != null}">
									<c:if test="${sessionScope.empAuthorization == 'employee'}">
										<a class="head_a_word" id="word_login" href="updateEmployee">${sessionScope.loginName}(Employee)</a>
									</c:if>
									<c:if test="${sessionScope.empAuthorization == 'manager'}">
										<a class="head_a_word" id="word_login" href="updateEmployee">${sessionScope.loginName}(Manager)</a>
									</c:if>
								</c:if>
								
							</div>
						</li>
						<li class="signup_btn">
							<div class="signup_image">
								<c:if test="${sessionScope.loginId == null}">
									<img src="images/signup_logo1.png">
								</c:if>
								<c:if test="${sessionScope.loginId != null}">	
									<img src="images/logout1.png">
								</c:if>	
							</div>
							<div class="signup_charater">
								<c:if test="${sessionScope.loginId == null}">
									<a class="head_a_word" href="signup">Sign Up</a>
								</c:if>
								<c:if test="${sessionScope.loginId != null}">
									<a class="head_a_word" href="logout">Logout</a>
									<input class="login_check" type="hidden" value="${sessionScope.loginId}">
								</c:if>
									
							</div>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	
</div>

</body>
</html>