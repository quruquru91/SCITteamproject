<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<link rel="stylesheet" href="resources/css/statisticChoice.css">
<script type="text/javascript" src="resources/jquery-3.3.1.min.js"></script>
<script type="text/javascript">


</script>
<style>
.wrapper {
	width: 100%;
	height: 650px;
	border: 1px solid red;
	display: flex;
	flex-direction: column;
}

.wrapper .wrapper_up {
	width: 100%;
	height: 50%;
	border: 1px solid black;
	display: flex;
	flex-direction: row;
}

.wrapper_up .wrapper_up_left {
	width: 50%;
	height: 100%;
	border: 1px solid red;
}

.wrapper_up .wrapper_up_right {
	width: 50%;
	height: 100%;
	border: 1px solid red;
}

.wrapper .wrapper_down {
	width: 100%;
	height: 50%;
	border: 1px solid black;
}




</style>

<body>
	<div class="wrapper">
		<div class="wrapper_up">
			<div class="wrapper_up_left">
			</div>
			<div class="wrapper_up_right">
			</div>
		</div>
		<div class="wrapper_down">
		</div>
	</div>
</body>
</html>