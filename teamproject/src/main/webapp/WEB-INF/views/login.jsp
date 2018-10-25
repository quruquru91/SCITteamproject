<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>login</title>
</head>
<link rel="stylesheet" href="resources/css/login.css">
<link rel="stylesheet" href="resources/css/login_responsive.css">
<script type="text/javascript" src="resources/jquery-3.3.1.min.js"></script>
<script type="text/javascript">
$(function() {
	
	$('.head_a_word').mouseenter(function() {
		$(this).css({borderBottom : '3px solid black'})
	})		
	
	$('.head_a_word').mouseleave(function() {
		$(this).css({borderBottom : '0px solid black'})
	})
	
	$('.login_button').mouseenter(function() {
		$(this).css({backgroundColor : 'black'})
		$(this).css({color: 'white'})
	})
	
	$('.login_button').mouseleave(function() {
		$(this).css({backgroundColor : 'white'})
		$(this).css({color: 'black'})
	})
	
	$('.signup_button').mouseenter(function() {
		$(this).css({backgroundColor : 'black'})
		$(this).css({color: 'white'})
	})
	
	$('.signup_button').mouseleave(function() {
		$(this).css({backgroundColor : 'white'})
		$(this).css({color: 'black'})
	})	
	
	$('.login_button').on('click',checkLogin);
	
	$('.login_help').on('click',function() {
		$('.popup_div').css({
        	"top": (($(window).height()-$(".popup_div").outerHeight())/2+$(window).scrollTop())+"px",
       		"left": (($(window).width()-$(".popup_div").outerWidth())/2+$(window).scrollLeft())+"px"
        }); 
		$('.popup_div').css("display","block");
		$('.popup_div').show();
        var maskHeight = $(document).height();  
        var maskWidth = $(window).width();  
        $('.mask').css({'width':maskWidth,'height':maskHeight});    
        $('.mask').fadeTo("fast",0.7); 
	})
	
	$('.mask').on('click', function() {
		$(this).hide();
		$('.popup_div').hide();
	})
	
	$('.popup_div_main_closebtn').on('click', function() {
		$('.popup_div').hide();
		$('.mask').hide();
	})
	
	$(window).resize(function() {
		$('.popup_div').hide();
		$('.mask').hide();
	});

})

function checkLogin() {
	var userid = $('#userid').val();
	var password = $('#password').val();	
	if(userid.length < 3 || userid.length > 12) {
		alert("아이디는 4글자 ~ 11글자까지 허용됩니다.");
		return;
	}
	
	if(password.length < 4 || password.length > 14) {
		alert("비밀번호는 4자리 ~ 14자리로 이루어져있어야 합니다.");
		return;
	}
	
	$('.lgnForm').submit();
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
								<a href="login" class="head_a_word" id="word_login">Login</a>
							</div>
						</li>
						<li class="signup_btn">
							<div class="signup_image">
								<img src="images/signup_logo2.png">
							</div>
							<div class="signup_charater">
								<a href="signup" class="head_a_word" href="signup">Sign Up</a>
							</div>
						</li>
					</ul>
				</div>
			</div>
		</div>	
		
		<div class="login_div">
			<div class="login_main2">
				<div class="login_main2_left">
					<div class="login_main2_left_login">
						<h1>Login</h1>
					</div>
					<form class="lgnForm" action="login" method="post">
					<div>
						<div>ID</div>
						<div>
							<input id="userid" class="login_main2_left_idpwd" type="text" name="empid">
						</div>
					</div>
					<div>
						<div>Password</div>
						<div>
							<input id="password" class="login_main2_left_idpwd" type="password" name="password">
						</div>
					</div>
					</form>
					<div class="login_main2_left_loginbtn">			
						<input class="login_button" type="button" value="Login">
					</div>
					<div class="login_main2_left_signupbtn">
						<a href="signup"><input class="signup_button" type="button" value="Sign up"></a>
					</div>
					
					<div class="login_main2_left_help">
						<div class="login_main2_left_help_saveid">
							<input class="save_id" type="checkbox" value="Save id">Save id
						</div>
						<div class="login_main2_left_help_blank">
						</div>
						<div class="login_main2_left_help_find">
							<a class="login_help">Need a help?</a>
						</div>
					</div>
					
				</div>
				<div class="login_main2_right">
					<img src="images/login_background.png">
				</div>
			</div>
		</div>
	</div>
	
	<div class="popup_div">
		<div class="popup_div_main">
			<div class="popup_div_main_logo">
				<img src="images/head_logo2.png">
			</div>
			
			<div class="popup_div_main_word1">
				Find Your Account
			</div>
			
			<div class="popup_div_main_word2">
				Tell us your name and phonenumber. We'll call you as soon as possible.
			</div>
			
			<div class="popup_div_main_text">
				<input type="text" placeholder="name">
				<input type="text" placeholder="phonenumber">
			</div>
			
			<div class="popup_div_main_send">
				<input class="popup_div_main_sendbtn" type="button" value="send">
			</div>
			
			<div class="popup_div_main_close">
				<p class="popup_div_main_closebtn">close</p>
			</div>
		</div>
	</div>
	<div class="mask"></div>
</body>
</html>