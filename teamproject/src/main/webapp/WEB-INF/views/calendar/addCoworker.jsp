<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    
<!DOCTYPE html> 
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<script src='resources/js/lib/jquery.min.js'></script>

<script>
var list = [];

$(function() {
	init();
	$("#search").on('click',search_emp);
	$("#add_btn").on('click',add_btn);
});

function init() {
	var companyNo = $("#companyNo").val();
	//ajax 로 전체 데이터를 끌어옴
	$.ajax({
		method : 'get',
		url : 'selectCompanyCoworker',
		data: "companyNo="+companyNo,
		dataType:'json',
		success : function(resp){
			//alert(resp);
			output(resp);
			
		}, 
		error: function(){
			alert("에러")
		}
	});
}
function output(resp) {
	//alert(JSON.stringify(resp));
	var result='';	
	$.each(resp,function(index,item){
		result += '<p> '+item.empdept+ "   ";
		result += item.empname + "     ";
		result += '<input class="plusCoworker" data-id="'+item.empid+'" data-name="'+item.empname+'" type="button" value="추가"></p>';
	
	})
	$("#result").html(result); 
	$(".plusCoworker").on('click',plusCoworker);


}

function plusCoworker(){
	var empname = $(this).attr("data-name"); 
	var empid  = $(this).attr("data-id"); 
	$(this).remove();
	
	var sendData = {
			"empid" : empid
			,"empname" :empname
	};
	
		
		list.push(sendData);
		
		var result='';	
		result += '<p> '+empname+ "   ";
		result += empid + "     ";
		result += '</p>';
		
	$("#result_1").append(result); 
	
}
	
	function add_btn(){
	opener.add_Business(list);	
	opener.CoworkerList(list);
	window.close();
		
	}

	function search_emp(){
		var empname = $("#empname").val();
		var companyNo = $("#companyNo").val();

		$.ajax({
			method : 'get',
			data: "empname="+empname+"&companyNo="+companyNo,
			dataType:'json',
			url : 'searchName',
			success : function(resp){
				//alert(resp);
				output(resp);
				
		var search='';	
		$.each(resp,function(index,item){
			search += '<p> '+item.empdept+ "   ";
			search += item.empname + "     ";
			search += '<input class="plusCoworker" data-id="'+item.empid+'" data-name="'+item.empname+'" type="button" value="추가"></p>';
		})
		$("#result").html(search); 
		$(".plusCoworker").click(plusCoworker);

			}, 
			error: function(){
				alert("에러")
			}
		});

	}
	

	

</script>


</head>
<body>

		<div>
			<input id="empname" type="text" placeholder="사원이름"> 
			<input id="search" type="button" value="검색">
		</div>

		<div id="result"></div>
		<p> 동행할직원 목록</p>
		<div id="result_1"></div>

<input type="hidden" id="companyNo" value="${sessionScope.companyNo}">

<input type="button" id="add_btn" value="완료">


</body>
</html>