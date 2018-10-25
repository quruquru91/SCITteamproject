<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>statistic</title>
</head>

<link rel="stylesheet" href="resources/css/statistic.css">
<script type="text/javascript"
	src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript" src="resources/jquery-3.3.1.min.js"></script>
<script type="text/javascript">
	var extendDatas = []; 
	var statisticData = [];
	var statisticData2 = [];
	var businessWithall = "";
	$(function() {
		var author = $('.authorization').val();
		if (author == 'manager') {
			$('.head_1_item1_ul_li').css({
				marginLeft : '20px'
			})
			$('.head_1_item1_ul_li').css({
				marginRight : '20px'
			})
		}
		$('.extend_graph1').on('click', extend_graph1);
		$('.extend_graph2').on('click', extend_graph2);
		$('.extend_graph3').on('click', extend_graph3);
		$('.extend_graph4').on('click', extend_graph4);
		google.charts.load('current', {
			'packages' : [ 'corechart' ]
		});
		google.charts.setOnLoadCallback(drawChart1);
		if (statisticData2.length > 0) {
			google.charts.setOnLoadCallback(drawChart2);
			google.charts.setOnLoadCallback(drawChart3);
		}
		$('.graph_select').change(function() {
			var selected = jQuery('.graph_select').val();
			showGraph(selected);
		})
		$('.mask').on('click', function() {
			$(this).hide();
			$('.popup1_div').hide();
			$('.popup2_div').hide();
			$('.popup3_div').hide();
			$('.popup4_div').hide();
		})
		$('.extend_graph_select').change(function() {
			var selected = jQuery('.extend_graph_select').val();
			showExtendGraph(selected);
		})
		$('.trip_select').on('change', sendBw)
		
		
		$('.graph_select').on('change', function() {
			var businessWith = businessWithall
			var date = $(this).val()
			$.ajax({
				url : 'sendSc',
				type : 'GET',
				data : 'businessWith=' + businessWith + '&date=' + date,
				dataType : 'json',
				contentType : 'application/json; charset=UTF-8',
				success : function(datas) {
					drawChart1(datas)
					extendDatas = datas
				}
			})
			
		})
	})
	
	//------------------------------------------------------------------------------------------------------------------------
	function sendBw() {
		$('#day_expense').html('')
		var businessWith = $(this).val()
		$.ajax({
			url : 'sendBw',
			type : 'GET',
			data : 'businessWith=' + businessWith,
			dataType : 'json',
			contentType : 'application/json; charset=UTF-8',
			success : function(datas) {
				var plusData = '';
				var selectData = datas.dates
				statisticData = datas.schedules
			    statisticData2 = datas.schedules2
			    	plusData += '<option>날짜선택 </option>'
				$.each(selectData, function(index, item) {
					plusData += '<option value="'+ item +'">' + item
							+ '</option>'
				})
				$('.graph_select').html(plusData)
				businessWithall = businessWith
				drawChart2(statisticData)
				drawChart3(statisticData2)
				var sumMoney = 0;
				$.each(statisticData2, function(index,item) {
					sumMoney += item["FINALPRICE"]
				})
				$('.sc_mainup_3_total').html(sumMoney)
				
				
				
				var showList  = '';
				showList += '<div class="receipt">'
				showList += '	<div class="receipt_date">'
				showList += '		<div>'	
				showList += 			'날짜'
				showList += '		</div>'
				showList += '	</div>'
				showList += '	<div class="receipt_place">'
				showList += '		<div>'
				showList += 			'장소'
				showList += '		</div>'
				showList += '	</div>'
				showList += '	<div class="receipt_name">'
				showList += '		<div>'
				showList += 			'품목'
				showList += '		</div>'
				showList += '	</div>'
				showList += '	<div class="receipt_money">'
				showList += '		<div>'
				showList += 			'금액'
				showList += '		</div>'
				showList += '	</div>'
				showList += '</div>'	
				$.each(statisticData,function(index,item) {
					var putDate = '';
					var ConvDate = new Date(item["RECIPEDAY"])
					var month = ConvDate.getMonth() + 1
					if (month < 10) {
						month = "0" + month
					}
					var day = ConvDate.getDate()
					if (day < 10) {
						day = "0" + day
					}
					putDate = ConvDate.getFullYear() + "-" + month + "-" + day
					showList += '<div class="receipt">'
					showList += '	<div class="receipt_date">'
					showList += '		<div>'	
					showList += 			putDate
					showList += '		</div>'
					showList += '	</div>'
					showList += '	<div class="receipt_place">'
					showList += '		<div>'
					showList += 			item["RECIPEPLACE"]
					showList += '		</div>'
					showList += '	</div>'
					showList += '	<div class="receipt_name">'
					showList += '		<div>'
					showList += 			item["ITEMNAME"]
					showList += '		</div>'
					showList += '	</div>'
					showList += '	<div class="receipt_money">'
					showList += '		<div>'
					showList += 			item["ITEMPRICE"] * item["ITEMCOUNT"]
					showList += '		</div>'
					showList += '	</div>'
					showList += '</div>'
				})
					
				$('.sc_maindown_right_scroll_content_forput').html(showList)
			}
		})
	}

	//------------------------------------------------------------------------------------------------------------------------

	function drawChart1(datas) {
		var food = 0;
		var oil = 0;
		var home = 0;
		var sale = 0;
		var bus = 0;
		var etc = 0;

		$.each(datas, function(index, item) {
			if (item["ITEMCATEGORY"] == "식비") {
				food += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "유류비") {
				oil += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "숙박비") {
				home += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "접대비") {
				sale += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "교통비") {
				bus += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "기타") {
				etc += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

		})

		var data = google.visualization.arrayToDataTable([
				[ 'BusinessTrip', 'Money' ], [ '식비', food ], [ '유류비', oil ],
				[ '접대비', sale ], [ '교통비', bus ], [ '숙박비', home ],
				[ '기타', etc ], ]);

		var options = {
			slices : {
				0 : {
					color : 'dc3f76'
				},
				1 : {
					color : '2e9ca6'
				},
				2 : {
					color : '7446b9'
				},
				3 : {
					color : '9fb328'
				},
				4 : {
					color : 'f96232'
				},
				5 : {
					color : 'silver'
				}
			},
			is3D : true,
			chartArea : {
				left : '10%',
				top : '10%',
				width : '80%',
				height : '80%'
			},
			legend : {
				position : 'labeled',
				textStyle : {
					color : 'black',
					fontSize : 14
				}
			},
		};

		var chart = new google.visualization.PieChart(document
				.querySelector('#day_expense'));

		chart.draw(data, options);
	}

	//------------------------------------------------------------------------------------------------------------------------

	function drawChart2(statisticData) {
		var food = 0;
		var oil = 0;
		var home = 0;
		var sale = 0;
		var bus = 0;
		var etc = 0;

		$.each(statisticData, function(index, item) {
			if (item["ITEMCATEGORY"] == "식비") {
				food += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "유류비") {
				oil += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "숙박비") {
				home += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "접대비") {
				sale += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "교통비") {
				bus += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "기타") {
				etc += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

		})

		var foodObject = [ "식비", food * 1, "dc3f76" ]
		var oilObject = [ "유류비", oil * 1, "2e9ca6" ]
		var saleObject = [ "접대비", sale * 1, "7446b9" ]
		var busObject = [ "교통비", bus * 1, "9fb328" ]
		var homeObject = [ "숙박비", home * 1, "f96232" ]
		var etcObject = [ "기타", etc * 1, "silver" ]

		var alldata = []
		alldata.push(foodObject);
		alldata.push(oilObject);
		alldata.push(saleObject);
		alldata.push(busObject);
		alldata.push(homeObject);
		alldata.push(etcObject);

		for (var i = 0; i < alldata.length; i++) {
			for (var j = 0; j < alldata.length - 1 - i; j++) {
				if (alldata[j][1] < alldata[j + 1][1]) {
					var temp = alldata[j]
					alldata[j] = alldata[j + 1]
					alldata[j + 1] = temp
				}
			}
		}

		var data = google.visualization.arrayToDataTable([
				[ "Element", "Density", {
					role : "style"
				} ], alldata[0], alldata[1], alldata[2], alldata[3],
				alldata[4], alldata[5] ])

		var view = new google.visualization.DataView(data);
		view.setColumns([ 0, 1, {
			calc : "stringify",
			sourceColumn : 1,
			type : "string",
			role : "annotation"
		}, 2 ]);

		var options = {
			animation : {
				"startup" : true,
				duration : 1000,
				easing : 'out'
			},
			animation : {
				"startup" : true,
				duration : 1000,
				easing : 'out'
			},
			chartArea : {
				left : '10%',
				top : '10%',
				width : '80%',
				height : '80%'
			},
			legend : {
				position : "none"
			},
			bar : {
				groupWidth : "65%"
			}
		};
		var chart = new google.visualization.BarChart(document
				.querySelector('#ranking'));
		chart.draw(view, options);
	}

	//------------------------------------------------------------------------------------------------------------------------

	function drawChart3(statisticData2) {
		
		var checkDates = []
		var dates = []
		var uniqueDates = []
		$.each(statisticData2, function(index, item) {
			checkDates.push(item["RECIPEDAY"])
		})

		$.each(checkDates, function(index, item) {
			if ($.inArray(item, dates) === -1)
				dates.push(item);
		});

		$.each(dates, function(index, item) {
			var ConvDate = new Date(item)
			var month = ConvDate.getMonth() + 1
			if (month < 10) {
				month = "0" + month
			}
			var day = ConvDate.getDate()
			if (day < 10) {
				day = "0" + day
			}
			uniqueDates.push(ConvDate.getFullYear() + "-" + month + "-" + day)
		})

		var categories = [ '교통비', '기타', '숙박비', '식비', '유류비', '접대비' ]
		var graphData = [ [ "Day", '교통비', '기타', '숙박비', '식비', '유류비', '접대비' ] ]

		var pivot = 0;
		// i = 날짜별로 5번
		for (var i = 0; i < dates.length; i++) {
			var rowData = [ dates[i] ];
			// j = 지출카테고리별로 6번
			for (var j = 0; j < categories.length; j++) {
				if (statisticData2[pivot]['RECIPEDAY'] == dates[i]
						&& statisticData2[pivot]['ITEMCATEGORY'] == categories[j]) {
					rowData.push(statisticData2[pivot]['FINALPRICE']);
					if(pivot != statisticData2.length-1) {
						pivot++;
					}
				} else {
					rowData.push(0);
				}
			}
			graphData.push(rowData);
		}

		var data = google.visualization.arrayToDataTable(graphData);

		var view = new google.visualization.DataView(data);

		var options = {
				series: [
					{color: '9fb328', visibleInLegend: true}, 
					{color: 'silver', visibleInLegend: true},
					{color: 'f96232', visibleInLegend: true}, 
					{color: 'dc3f76', visibleInLegend: true},
					{color: '2e9ca6', visibleInLegend: true}, 
					{color: '7446b9', visibleInLegend: true}	
				],
				legend : {
					position : 'labeled',
					textStyle : {
						color : 'black',
						fontSize : 11
					}
				},
			animation : {
				"startup" : true,
				duration : 1000,
				easing : 'out'
			},
			chartArea : {
				left : '10%',
				top : '10%',
				width : '80%',
				height : '80%'
			}
		};
		var chart = new google.visualization.ColumnChart(document
				.querySelector('#total_expense'));
		chart.draw(view, options);
	}

	//------------------------------------------------------------------------------------------------------------------------

	function showGraph(selected) {
		if (selected == '2') {
			var data = google.visualization.arrayToDataTable([
					[ 'Task', 'Hours per Day' ], [ 'Work', 1 ], [ 'Eat', 10 ],
					[ 'Commute', 5 ], [ 'Watch TV', 1 ], [ 'Sleep', 7 ] ]);

			var options = {
				is3D : true,
				chartArea : {
					left : '10%',
					top : '10%',
					width : '80%',
					height : '80%'
				},
				legend : {
					position : 'labeled',
					textStyle : {
						color : 'black',
						fontSize : 12
					}
				}
			};

			var chart = new google.visualization.PieChart(document
					.querySelector('#day_expense'));

			chart.draw(data, options);
		}

		if (selected == '1') {
			drawChart1(datas);
		}
	}

	//------------------------------------------------------------------------------------------------------------------------
	function extend_graph1() {
		$('.popup1_div').css(
				{
					"top" : (($(window).height() - $(".popup1_div")
							.outerHeight()) / 2 + $(window).scrollTop())
							+ "px",
					"left" : (($(window).width() - $(".popup1_div")
							.outerWidth()) / 2 + $(window).scrollLeft())
							+ "px"
				});
		$('.popup1_div').css("display", "block");
		$('.popup1_div').show();
		var maskHeight = $(document).height();
		var maskWidth = $(window).width();
		$('.mask').css({
			'width' : maskWidth,
			'height' : maskHeight
		});
		$('.mask').fadeTo("fast", 0.7);

		var food = 0;
		var oil = 0;
		var home = 0;
		var sale = 0;
		var bus = 0;
		var etc = 0;

		$.each(extendDatas, function(index, item) {
			if (item["ITEMCATEGORY"] == "식비") {
				food += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "유류비") {
				oil += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "숙박비") {
				home += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "접대비") {
				sale += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "교통비") {
				bus += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "기타") {
				etc += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

		})

		var data = google.visualization.arrayToDataTable([
				[ 'BusinessTrip', 'Money' ], [ '식비', food ], [ '유류비', oil ],
				[ '접대비', sale ], [ '교통비', bus ], [ '숙박비', home ],
				[ '기타', etc ], ]);

		var options = {
			slices : {
				0 : {
					color : 'dc3f76'
				},
				1 : {
					color : '2e9ca6'
				},
				2 : {
					color : '7446b9'
				},
				3 : {
					color : '9fb328'
				},
				4 : {
					color : 'f96232'
				},
				5 : {
					color : 'silver'
				}
			},
			is3D : true,
			chartArea : {
				left : '5%',
				top : '5%',
				width : '90%',
				height : '90%'
			},
			legend : {
				position : 'labeled',
				textStyle : {
					color : 'black',
					fontSize : 24
				}
			},
		};

		var chart = new google.visualization.PieChart(document
				.querySelector('.popup1_div_main_content_image'));

		chart.draw(data, options);

		$(window).resize(function() {
			$('.popup1_div').hide();
			$('.mask').hide();
		});
	}
	
	//------------------------------------------------------------------------------------------------------------------------

	function extend_graph2() {
		$('.popup2_div').css(
				{
					"top" : (($(window).height() - $(".popup2_div")
							.outerHeight()) / 2 + $(window).scrollTop())
							+ "px",
					"left" : (($(window).width() - $(".popup2_div")
							.outerWidth()) / 2 + $(window).scrollLeft())
							+ "px"
				});
		$('.popup2_div').css("display", "block");
		$('.popup2_div').show();
		var maskHeight = $(document).height();
		var maskWidth = $(window).width();
		$('.mask').css({
			'width' : maskWidth,
			'height' : maskHeight
		});
		$('.mask').fadeTo("fast", 0.7);

		var food = 0;
		var oil = 0;
		var home = 0;
		var sale = 0;
		var bus = 0;
		var etc = 0;

		$.each(statisticData, function(index, item) {
			if (item["ITEMCATEGORY"] == "식비") {
				food += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "유류비") {
				oil += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "숙박비") {
				home += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "접대비") {
				sale += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "교통비") {
				bus += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

			if (item["ITEMCATEGORY"] == "기타") {
				etc += item["ITEMPRICE"] * item["ITEMCOUNT"];
			}

		})

		var foodObject = [ "식비", food * 1, "dc3f76"]
		var oilObject = [ "유류비", oil * 1, "2e9ca6"]
		var saleObject = [ "접대비", sale * 1, "7446b9"]
		var busObject = [ "교통비", bus * 1, "9fb328" ]
		var homeObject = [ "숙박비", home * 1, "f96232"]
		var etcObject = [ "기타", etc * 1, "silver" ]

		var alldata = []
		alldata.push(foodObject);
		alldata.push(oilObject);
		alldata.push(saleObject);
		alldata.push(busObject);
		alldata.push(homeObject);
		alldata.push(etcObject);

		for (var i = 0; i < alldata.length; i++) {
			for (var j = 0; j < alldata.length - 1 - i; j++) {
				if (alldata[j][1] < alldata[j + 1][1]) {
					var temp = alldata[j]
					alldata[j] = alldata[j + 1]
					alldata[j + 1] = temp
				}
			}
		}

		var data = google.visualization.arrayToDataTable([
				[ "Element", "Density", {
					role : "style"
				} ], alldata[0], alldata[1], alldata[2], alldata[3],
				alldata[4], alldata[5] ])

		var view = new google.visualization.DataView(data);
		view.setColumns([ 0, 1, {
			calc : "stringify",
			sourceColumn : 1,
			type : "string",
			role : "annotation"
		}, 2 ]);

		var options = {
			animation : {
				"startup" : true,
				duration : 1000,
				easing : 'out'
			},
			animation : {
				"startup" : true,
				duration : 1000,
				easing : 'out'
			},
			chartArea : {
				left : '10%',
				top : '10%',
				width : '80%',
				height : '80%'
			},
			legend : {
				position : "none"
			},
			bar : {
				groupWidth : "65%"
			}
		};
		var chart = new google.visualization.BarChart(document
				.querySelector('.popup2_div_main_content_image'));
		chart.draw(view, options);
	
		$(window).resize(function() {
			$('.popup2_div').hide();
			$('.mask').hide();
		});
	}

	//------------------------------------------------------------------------------------------------------------------------

	function extend_graph3() {
		$('.popup3_div').css(
				{
					"top" : (($(window).height() - $(".popup3_div")
							.outerHeight()) / 2 + $(window).scrollTop())
							+ "px",
					"left" : (($(window).width() - $(".popup3_div")
							.outerWidth()) / 2 + $(window).scrollLeft())
							+ "px"
				});
		$('.popup3_div').css("display", "block");
		$('.popup3_div').show();
		var maskHeight = $(document).height();
		var maskWidth = $(window).width();
		$('.mask').css({
			'width' : maskWidth,
			'height' : maskHeight
		});
		$('.mask').fadeTo("fast", 0.7);

		
		var checkDates = []
		var dates = []
		var uniqueDates = []
		$.each(statisticData2, function(index, item) {
			checkDates.push(item["RECIPEDAY"])
		})

		$.each(checkDates, function(index, item) {
			if ($.inArray(item, dates) === -1)
				dates.push(item);
		});

		$.each(dates, function(index, item) {
			var ConvDate = new Date(item)
			var month = ConvDate.getMonth() + 1
			if (month < 10) {
				month = "0" + month
			}
			var day = ConvDate.getDate()
			if (day < 10) {
				day = "0" + day
			}
			uniqueDates.push(ConvDate.getFullYear() + "-" + month + "-" + day)
		})

		var categories = [ '교통비', '기타', '숙박비', '식비', '유류비', '접대비' ]
		var graphData = [ [ "Day", '교통비', '기타', '숙박비', '식비', '유류비', '접대비' ] ]

		var pivot = 0;
		// i = 날짜별로 5번
		for (var i = 0; i < dates.length; i++) {
			var rowData = [ dates[i] ];
			// j = 지출카테고리별로 6번
			for (var j = 0; j < categories.length; j++) {
				if (statisticData2[pivot]['RECIPEDAY'] == dates[i]
						&& statisticData2[pivot]['ITEMCATEGORY'] == categories[j]) {
					rowData.push(statisticData2[pivot]['FINALPRICE']);
					if(pivot != statisticData2.length-1) {
						pivot++;
					}
				} else {
					rowData.push(0);
				}
			}
			graphData.push(rowData);
		}

		var data = google.visualization.arrayToDataTable(graphData);

		var view = new google.visualization.DataView(data);

		var options = {
			series: [
				{color: '9fb328', visibleInLegend: true}, 
				{color: 'silver', visibleInLegend: true},
				{color: 'f96232', visibleInLegend: true}, 
				{color: 'dc3f76', visibleInLegend: true},
				{color: '2e9ca6', visibleInLegend: true}, 
				{color: '7446b9', visibleInLegend: true}	
			],
			animation : {
				"startup" : true,
				duration : 1000,
				easing : 'out'
			},
			chartArea : {
				left : '10%',
				top : '5%',
				width : '80%',
				height : '80%'
			}
		};
		var chart = new google.visualization.ColumnChart(document
				.querySelector('.popup3_div_main_content_image'));
		chart.draw(view, options);

		$(window).resize(function() {
			$('.popup3_div').hide();
			$('.mask').hide();
		});
	}
	
	function extend_graph4() {
		$('.popup4_div').css(
				{
					"top" : (($(window).height() - $(".popup4_div")
							.outerHeight()) / 2 + $(window).scrollTop())
							+ "px",
					"left" : (($(window).width() - $(".popup4_div")
							.outerWidth()) / 2 + $(window).scrollLeft())
							+ "px"
				});
		$('.popup4_div').css("display", "block");
		$('.popup4_div').show();
		var maskHeight = $(document).height();
		var maskWidth = $(window).width();
		$('.mask').css({
			'width' : maskWidth,
			'height' : maskHeight
		});
		$('.mask').fadeTo("fast", 0.7);
		
		var showList  = '';
		showList += '<div class="receipt">'
		showList += '	<div class="receipt_date">'
		showList += '		<div>'	
		showList += 			'날짜'
		showList += '		</div>'
		showList += '	</div>'
		showList += '	<div class="receipt_place">'
		showList += '		<div>'
		showList += 			'장소'
		showList += '		</div>'
		showList += '	</div>'
		showList += '	<div class="receipt_name">'
		showList += '		<div>'
		showList += 			'품목'
		showList += '		</div>'
		showList += '	</div>'
		showList += '	<div class="receipt_money">'
		showList += '		<div>'
		showList += 			'금액'
		showList += '		</div>'
		showList += '	</div>'
		showList += '</div>'		
		$.each(statisticData,function(index,item) {
			var putDate = '';
			var ConvDate = new Date(item["RECIPEDAY"])
			var month = ConvDate.getMonth() + 1
			if (month < 10) {
				month = "0" + month
			}
			var day = ConvDate.getDate()
			if (day < 10) {
				day = "0" + day
			}
			putDate = ConvDate.getFullYear() + "-" + month + "-" + day
			showList += '<div class="receipt">'
			showList += '	<div class="receipt_date">'
			showList += '		<div>'	
			showList += 			putDate
			showList += '		</div>'
			showList += '	</div>'
			showList += '	<div class="receipt_place">'
			showList += '		<div>'
			showList += 			item["RECIPEPLACE"]
			showList += '		</div>'
			showList += '	</div>'
			showList += '	<div class="receipt_name">'
			showList += '		<div>'
			showList += 			item["ITEMNAME"]
			showList += '		</div>'
			showList += '	</div>'
			showList += '	<div class="receipt_money">'
			showList += '		<div>'
			showList += 			item["ITEMPRICE"] * item["ITEMCOUNT"]
			showList += '		</div>'
			showList += '	</div>'
			showList += '</div>'
		})
		
		$('.popup4_div_main_content_image').html(showList)
	}
</script>


<body>
	<div class="wrapper">
		<input class="authorization" type="hidden"
			value="${sessionScope.empAuthorization}">
		<div class="head">
			<div class="head_1">
				<div id="head_1_item1" class="head_list">
					<input class="authority_check" type="hidden"
						value="${sessionScope.empAuthorization}">
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


		<div class="statistic">
			<div class="sc_main">
				<div class="sc_mainup">
					<div class="sc_mainup_left">
						<div class="sc_mainup_1">
							<div class="sc_mainup_1_title">
								<div>Business Trip</div>
							</div>
							<div class="sc_mainup_1_select">
								<select class="trip_select">
									<option class="businessWithOption">출장선택</option>
									<c:forEach items="${businessTrips}" var="trip">
										<option class="businessWith" value=${trip["BUSINESSWITH"]}>${trip["BUSINESSNAME"]}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div class="sc_mainup_2">
							<div class="sc_mainup_2_left">Count</div>
							<div class="sc_mainup_2_count">${fn:length(businessTrips)}</div>
						</div>
					</div>
					<div class="sc_mainup_right">
						<div class="sc_mainup_3">
							<div class="sc_mainup_3_left">Total</div>
							<div class="sc_mainup_3_total">0</div>
						</div>
					</div>
				</div>
				<div class="sc_maindown">
					<div class="sc_maindown_left">
						<div class="sc_maindown_leftup">
							<div class="sc_maindown_leftup_left">
								<div class="sc_maindown_leftup_left_content">
									<div class="sc_maindown_leftup_left_content_title">
										<div class="sc_maindown_leftup_left_content_title_image">
											<img class="extend_graph1" src="images/graph.png">
										</div>
										<div class="sc_maindown_leftup_left_content_title_title">
											Day Expense</div>
										<div class="sc_maindown_leftup_left_content_title_select">
											<select class="graph_select">
											</select>
										</div>
									</div>
									<div class="sc_maindown_leftup_left_content_graph">
										<div id="day_expense"></div>
									</div>
								</div>
							</div>
							<div class="sc_maindown_leftup_right">
								<div class="sc_maindown_leftup_right_content">
									<div class="sc_maindown_leftup_right_content_title">
										<div class="sc_maindown_leftup_right_content_title_image">
											<img class="extend_graph2" src="images/graph.png">
										</div>
										<div class="sc_maindown_leftup_right_content_title_title">
											Ranking</div>
									</div>
									<div class="sc_maindown_leftup_right_content_content">
										<div id="ranking"></div>
									</div>
								</div>
							</div>
						</div>
						<div class="sc_maindown_leftdown">
							<div class="sc_maindown_leftdown_content">
								<div class="sc_maindown_leftdown_content_title">
									<div class="sc_maindown_leftdown_content_title_image">
										<img class="extend_graph3" src="images/graph.png">
									</div>
									<div class="sc_maindown_leftdown_content_title_title">
										<div>Total Expense</div>
									</div>
								</div>
								<div class="sc_maindown_leftdown_content_grpah">
									<div id="total_expense"></div>
								</div>
							</div>
						</div>
					</div>
					<div class="sc_maindown_right">
						<div class="sc_maindown_right_scrolldiv">
							<div class="sc_maindown_right_scroll">
								<div class="sc_maindown_right_scroll_title">
									<div class="sc_maindown_right_scroll_title_image">
										<img class="extend_graph4" src="images/graph.png">
									</div>
									<div class="sc_maindown_right_scroll_title_title">
										Receipt
									</div>
								</div>
								<div class="sc_maindown_right_scroll_content">
									<div class="sc_maindown_right_scroll_content_forput">
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<div class="popup1_div">
			<div class="popup1_div_main">
				<div class="popup1_div_main_title">
					<div class="popup1_div_main_title_image">
						<img src="images/extend_graph.png">
					</div>
					<div class="popup1_div_main_title_title">
						Day Expense
					</div>
				</div>
				<div class="popup1_div_main_content">
					<div class="popup1_div_main_content_image"></div>
				</div>
			</div>
		</div>

		<div class="popup2_div">
			<div class="popup2_div_main">
				<div class="popup2_div_main_title">
					<div class="popup2_div_main_title_image">
						<img src="images/extend_graph.png">
					</div>
					<div class="popup2_div_main_title_title">Ranking</div>
				</div>
				<div class="popup2_div_main_content">
					<div class="popup2_div_main_content_image"></div>
				</div>
			</div>
		</div>

		<div class="popup3_div">
			<div class="popup3_div_main">
				<div class="popup3_div_main_title">
					<div class="popup3_div_main_title_image">
						<img src="images/extend_graph.png">
					</div>
					<div class="popup3_div_main_title_title">Total Expense</div>
				</div>
				<div class="popup3_div_main_content">
					<div class="popup3_div_main_content_image"></div>
				</div>
			</div>
		</div>
		
		<div class="popup4_div">
			<div class="popup4_div_main">
				<div class="popup4_div_main_title">
					<div class="popup4_div_main_title_image">
						<img src="images/extend_graph.png">
					</div>
					<div class="popup4_div_main_title_title">Receipt</div>
				</div>
				<div class="popup4_div_main_content">
					<div class="popup4_div_main_content_image">
					</div>
				</div>
			</div>
		</div>

		<div class="mask">
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