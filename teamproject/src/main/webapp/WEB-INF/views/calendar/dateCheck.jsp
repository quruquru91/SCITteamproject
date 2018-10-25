<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
	<title>Home</title>
	
<link rel='stylesheet' href='resources/js/fullcalendar.css' />
<script src='resources/js/lib/jquery.min.js'></script>
<script src='resources/js/lib/moment.min.js'></script>
<script src='resources/js/fullcalendar.js'></script>
<script type='text/javascript' src='resources/js/gcal.js'></script>


<script src="resources/js/jquery.bpopup.min.js"></script>


<script type='text/javascript'>




var events = [];
var selectDate = new Date(); 
 $(function() {
	
	  $('#calendar').fullCalendar({
	    selectable: true,
	    defaultDate: '2018-08-06'  ,
	    header: {
	      left: 'prev,next today',
	      center: 'title',
	      right: 'month,agendaWeek,agendaDay'
	    },

	    editable: true,
	    eventLimit: true, // when too many events in a day, show the popover
 		 //등록된 일정
	  
	    		
	    dayClick: function(date) {
	      //alert('clicked ' + date.format());

	    selectDate = date;
	    selectDate = selectDate.format();
	      	
	    },//하루만 클릭했을 때
	    
	    select: function(startDate, endDate) {
	    	
	    	
	    		
	    	var endDate = new Date(endDate);
			endDate.setDate(endDate.getDate()-1);
			endDate = getFormatDate(endDate);
			
			
			$("#start").val(startDate.format())
			$("#end").val(endDate); 
			
			
	    	}
	    
	    

	   }); 
	});//끝
 

	
	function getFormatDate(endDate){ // endDate >YYYY-MM-DD로 포맷
		var year = endDate.getFullYear();                                 
		var month = (1 + endDate.getMonth());                     
		month = month >= 10 ? month : '0' + month;    
		var day = endDate.getDate();                                       
		day = day >= 10 ? day : '0' + day;                           
		return  year + '-' + month + '-' + day;
	}
	
	
	
</script>

	

	
</head>
<body>

<h1> 출장 일정을 선택해주세요</h1>
<div id="calendar"></div>

<div>
startDate : <input type="date" name="startDate" id="start" value="2018-08-10">
endDate : <input type="date" name="endDate" id="end"value="2018-08-10">
<a href="planCheck"> next </a>
</div>

</body>
</html>
