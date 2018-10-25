<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>statistic</title>
</head>

<link rel="stylesheet" href="resources/css/statisticManager.css">
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript" src="resources/jquery-3.3.1.min.js"></script>
<script type="text/javascript">
	var statisticData = [];
	var statisticData2 = [];
	var businessWithall = "";
	var locationData = [];
	var days = "";
	var days2 = "";
	$(function() {
		$('#company').on('click', function() {
			var radioVal = $(':input:radio[name=radiobutton]:checked').val();
			if(radioVal == 'company') {
				$(location).attr('href', 'statisticCompany');
			}
		})	
		
		$('#employee').on('click', function() {
			var radioVal = $(':input:radio[name=radiobutton]:checked').val();
			if(radioVal == 'employee') {
				$(location).attr('href', 'statisticManager');
			}
		})	
		
		google.charts.load('current', {
			'packages' : [ 'corechart' ]
		});
		google.charts.setOnLoadCallback(chartAll);
		

		
		var author = $('.authorization').val()
		if (author == 'manager') {
			$('.head_1_item1_ul_li').css({
				marginLeft : '20px'
			})
			$('.head_1_item1_ul_li').css({
				marginRight : '20px'
			})
		}

		
		$.ajax({
			url: 'bringEmployees',
			type: 'GET',
			success: function(datas){
				$.each(datas, function(index,item) {
					var employeeData = '<div class="sc_maindown_left2_scrolldiv_content" data-rno=' + item.empid  + '>'
						employeeData += '	<div class="sc_maindown_left2_scrolldiv_content_id">'
						employeeData += '		<div>'	
						employeeData += 			item.empid
						employeeData += '		</div>'
						employeeData += '	</div>'
						employeeData += '	<div class="sc_maindown_left2_scrolldiv_content_name">'
						employeeData += '		<div>'	
						employeeData += 			item.empname
						employeeData += '		</div>'	
						employeeData += '	</div>'
						employeeData += '	<div class="sc_maindown_left2_scrolldiv_content_dept">'
						employeeData += '		<div>'	
						employeeData += 			item.empdept
						employeeData += '		</div>'	
						employeeData += '	</div>'
						employeeData += '</div>'
						
						$('.sc_maindown_left2_scrolldiv').append(employeeData)
				})
				$('.sc_maindown_left2_scrolldiv_content').on('click', clickEmployees)
				var employees =	datas
				$('.sc_mainup_left1_right_display').html(datas.length)
			}
		})
		

		
	})
	
	//-------------------------------------------------------------------------------------------------------------------------
	
	function clickEmployees() {
		$(this).siblings().css('background-color','white')
		$(this).css('background-color','rgb(200,200,200)')
		var empid = $(this).attr('data-rno')
		$.ajax({
			url: 'bringTrip',
			method: 'GET',
			data: 'empid=' + empid,
			contentType: 'application/json; charset=UTF-8',
			success: function(Trips) {
				$('.sc_maindown_left4_scrolldiv').html('');
				$.each(Trips, function(index,item) {
					var putDate = '';
					var ConvDate = new Date(item["BUSINESSSTART"])
					var month = ConvDate.getMonth() + 1
					if (month < 10) {
						month = "0" + month
					}
					var day = ConvDate.getDate()
					if (day < 10) {
						day = "0" + day
					}
					putDate = ConvDate.getFullYear() + "-" + month + "-" + day
					
					var putDateEnd = '';
					var ConvDateEnd = new Date(item["BUSINESSEND"])
					var monthEnd = ConvDateEnd.getMonth() + 1
					if (monthEnd < 10) {
						monthEnd = "0" + monthEnd
					}
					var dayEnd = ConvDateEnd.getDate()
					if (dayEnd < 10) {
						dayEnd = "0" + dayEnd
					}
					putDateEnd = ConvDate.getFullYear() + "-" + monthEnd + "-" + dayEnd
					
					var tripData = '<div class="sc_maindown_left4_scrolldiv_content">'
						tripData += '	<div class="sc_maindown_left4_scrolldiv_content_name">'
						tripData += '		<div>'	
						tripData += 			item["BUSINESSNAME"]
						tripData += '			<input class="mainInfo" type="hidden" value="' + item["BUSINESSWITH"] + '"> '
						tripData += '			<input class="mainLocation" type="hidden" value="' + item["BUSINESSLOCATIONMAIN"] + '"> '
						tripData += '		</div>'
						tripData += '	</div>'
						tripData += '	<div class="sc_maindown_left4_scrolldiv_content_start">'
						tripData += '		<div>'	
						tripData += 			putDate
						tripData += '		</div>'	
						tripData += '	</div>'
						tripData += '	<div class="sc_maindown_left4_scrolldiv_content_end">'
						tripData += '		<div>'	
						tripData += 			putDateEnd
						tripData += '		</div>'	
						tripData += '	</div>'
						tripData += '</div>'
						
						$('.sc_maindown_left4_scrolldiv').append(tripData)
				})
				$('.sc_maindown_left4_scrolldiv_content').on('click', clickTrips)
				$('.sc_mainup_left3_right_display').html(Trips.length)
			}
		})
	}
	
	//-------------------------------------------------------------------------------------------------------------------------
	
	function clickTrips() {
		google.charts.load('current', {
			'packages' : [ 'corechart' ]
		});
		google.charts.setOnLoadCallback(chartLeft);
		google.charts.setOnLoadCallback(chartRight);
		google.charts.setOnLoadCallback(chartDown);
		$(this).siblings().css('background-color','white')
		$(this).css('background-color','rgb(200,200,200)')
		var businessWith = $(this).children().children().children('.mainInfo').val()
		var locationMain = $(this).children().children().children('.mainLocation').val()
		
		var privateSt  = '<div class="sc_maindown_right2_content_up">'
		    privateSt += '	<div class="sc_maindown_right2_content_up_left">'
		    privateSt += '		<div class="sc_maindown_right2_content_up_leftGraph">'
		    privateSt += '			<div class="leftGraph_title">'
			privateSt += '				<div class="leftGraph_title_image">'
			privateSt += '					<div>'
			privateSt += '						<img src="images/graph.png">'
			privateSt += '					</div>'
			privateSt += '				</div>'
			privateSt += '				<div class="leftGraph_title_title">'
			privateSt += '					<div>'
			privateSt += '						Day Expense'
			privateSt += '					</div>'
			privateSt += '				</div>'
			privateSt += '				<div class="leftGraph_title_select">'
			privateSt += '					<select class="leftGraph_title_select_select">'
			privateSt += '					</select>'
			privateSt += '				</div>'
		    privateSt += '			</div>'
			privateSt += '			<div class="leftGraph_content">'
		    privateSt += '			</div>'
		    privateSt += '		</div>'
			privateSt += '	</div>'
			privateSt += '	<div class="sc_maindown_right2_content_up_right">'
			privateSt += '		<div class="sc_maindown_right2_content_up_rightGraph">'
		    privateSt += '			<div class="rightGraph_title">'
			privateSt += '				<div class="rightGraph_title_image">'
			privateSt += '					<div>'
			privateSt += '						<img src="images/graph.png">'
			privateSt += '					</div>'
			privateSt += '				</div>'
			privateSt += '				<div class="rightGraph_title_title">'
			privateSt += '					<div>'
			privateSt += '						Ranking'
			privateSt += '					</div>'
			privateSt += '				</div>'
			privateSt += '			</div>'
			privateSt += '			<div class="rightGraph_content">'
			privateSt += '			</div>'
			privateSt += '		</div>'
			privateSt += '	</div>'
		    privateSt += '</div>'
			privateSt += '<div class="sc_maindown_right2_content_down">'
			privateSt += '	<div class="sc_maindown_right2_content_down_content">'
			privateSt += '		<div class="downGraph_title">'
			privateSt += '				<div class="downGraph_title_image">'
			privateSt += '					<div>'
			privateSt += '						<img src="images/graph.png">'
			privateSt += '					</div>'
			privateSt += '				</div>'
			privateSt += '				<div class="downGraph_title_title">'
			privateSt += '					<div>'
			privateSt += '						Total Expense'
			privateSt += '					</div>'
			privateSt += '				</div>'
			privateSt += '		</div>'
			privateSt += '		<div class="downGraph_content">'
			privateSt += '		</div>'
			privateSt += '	</div>'
			privateSt += '</div>'
			
			
		$('.sc_maindown_right2_content').html(privateSt)
		$('.sc_maindown_right1_image').css('visibility','visible')
		$('.comparison').on('click', clickComparison)
		
		$.ajax({
			url : 'sendManagerBw',
			type : 'GET',
			data : 'businessWith=' + businessWith + '&locationMain=' + locationMain,
			dataType : 'json',
			contentType : 'application/json; charset=UTF-8',
			success : function(datas) {
				
				var plusData = '';
				var selectData = datas.dates
				statisticData = datas.schedules
				statisticData2 = datas.schedules2
				locationData = datas.locationItems
				days = datas.days
				days2 = datas.days2
					plusData += '<option>날짜선택 </option>'
				$.each(selectData, function(index, item) {
					plusData += '<option value="'+ item +'">' + item
						+ '</option>'
				})
				$('.leftGraph_title_select_select').html(plusData)
				businessWithall = businessWith
				chartRight(statisticData)
				chartDown(statisticData2)
				
				$('.leftGraph_title_select_select').on('change', function() {
					var businessWith = businessWithall
					var date = $(this).val()
					$.ajax({
						url : 'sendManagerSc',
						type : 'GET',
						data : 'businessWith=' + businessWith + '&date=' + date,
						dataType : 'json',
						contentType : 'application/json; charset=UTF-8',
						success : function(datas) {
							chartLeft(datas)
							extendDatas = datas
						}
					})	
				})
				var sumMoney = 0
				$.each(statisticData2, function(index,item) {
					sumMoney += item["FINALPRICE"]
				})
				$('.sc_mainup_right_total_right_content').html(sumMoney)
			}
		})
	}
	
	//------------------------------------------------------------------------------------------------------------------------

	function clickComparison() {
		google.charts.load('current', {
			'packages' : [ 'corechart' ]
		});
		

		var comparison  = '<div class="sc_maindown_right2_content_comUp">'
			comparison += '		<div class="sc_maindown_right2_content_comUp_title">'
			comparison += '			<div class="sc_maindown_right2_content_comUp_title_image">'
			comparison += '				<img src="images/graph.png">'
			comparison += '			</div>'
			comparison += '			<div class="sc_maindown_right2_content_comUp_title_title">'
			comparison += '				<div>지역별 카테고리 금액비율 그래프</div>'
			comparison += '			</div>'
			comparison += '		</div>'
			comparison += '		<div class="sc_maindown_right2_content_comUp_content">'
			comparison += '			<div class="comparison_proportion_left">'
			comparison += '			</div>'
			comparison += '			<div class="comparison_proportion_right">'
			comparison += '			</div>'
			comparison += '		</div>'
			comparison += '</div>'
			
			comparison += '<div class="sc_maindown_right2_content_comDown">'
			comparison += '		<div class="sc_maindown_right2_content_comDown_title">'
			comparison += '			<div class="sc_maindown_right2_content_comDown_title_image">'
			comparison += '				<img src="images/graph.png">'
			comparison += '			</div>'
			comparison += '			<div class="sc_maindown_right2_content_comDown_title_title">'
			comparison += '				<div>지역별 카테고리 금액비교 그래프</div>'
			comparison += '			</div>'
			comparison += '		</div>'
			comparison += '		<div class="sc_maindown_right2_content_comDown_content">'
			comparison += '			<div class="sc_maindown_right2_content_comDown_content_graph">'
			comparison += '			</div>'
			comparison += '		</div>'
			comparison += '</div>'
			
			$('.sc_maindown_right2_content').html(comparison)
			$('.backPrivate').css('visibility','visible')
			google.charts.setOnLoadCallback(chartComparison);
			google.charts.setOnLoadCallback(chartComparisonCom);
			google.charts.setOnLoadCallback(chartComparisonDown);
	}
	
	//------------------------------------------------------------------------------------------------------------------------
	
	function chartAll() {
		var companyNo = $('.companyNo').val()
		$.ajax({
			url: 'bringCompanyItems',
			type: 'GET',
			data: 'companyNo=' + companyNo,
			dataType: 'json',
			contentType: 'application/json; charset:UTF-8',
			success: function(allData){
				var food = 0;
				var oil = 0;
				var home = 0;
				var sale = 0;
				var bus = 0;
				var etc = 0;

				$.each(allData, function(index, item) {
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
							fontSize : 12
						}
					},
				};

				var chart = new google.visualization.PieChart(document
						.querySelector('.sc_maindown_right2_content'));

				chart.draw(data, options);
			}
		})
	
	}
	
	//------------------------------------------------------------------------------------------------------------------------
	
		function chartLeft(datas) {
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
					left : '5%',
					top : '5%',
					width : '90%',
					height : '90%'
				},
				legend : {
					position : 'labeled',
					textStyle : {
						color : 'black',
						fontSize : 12
					}
				},
			};

			var chart = new google.visualization.PieChart(document
					.querySelector('.leftGraph_content'));

			chart.draw(data, options);
	}
	
   //------------------------------------------------------------------------------------------------------------------------
	
   function chartRight() {
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
				left : '15%',
				top : '15%',
				width : '70%',
				height : '70%'
			},
			legend : {
				position : "none"
			},
			bar : {
				groupWidth : "65%"
			}
		};
		var chart = new google.visualization.BarChart(document
				.querySelector('.rightGraph_content'));
		chart.draw(view, options);
	}
   
   //------------------------------------------------------------------------------------------------------------------------	
   
   
	function chartDown() {
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
				left : '15%',
				top : '15%',
				width : '70%',
				height : '70%'
			}
		};
		var chart = new google.visualization.ColumnChart(document
				.querySelector('.downGraph_content'));
		chart.draw(view, options);
	}
   
	   
	//------------------------------------------------------------------------------------------------------------------------	
	   
	function chartComparison() {
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


		var data = google.visualization.arrayToDataTable([
			[ 'BusinessTrip', 'Money' ], [ '식비', food ], [ '유류비', oil ],
			[ '접대비', sale ], [ '교통비', bus ], [ '숙박비', home ],
			[ '기타', etc ], ]);

	var options = {
		title: '[Employee]',
		titleTextStyle: { 
			fontSize: 16
		},
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
				fontSize : 13
			}
		},
	};

	var chart = new google.visualization.PieChart(document
			.querySelector('.comparison_proportion_left'));

	chart.draw(data, options);

	}
 
	//------------------------------------------------------------------------------------------------------------------------
	
	function chartComparisonCom() {
		var food = 0;
		var oil = 0;
		var home = 0;
		var sale = 0;
		var bus = 0;
		var etc = 0;

		$.each(locationData, function(index, item) {
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
			title: '[Company]',
			titleTextStyle: { 
				fontSize: 16
			},
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
					fontSize : 13
				}
			},
		};
	
		var chart = new google.visualization.PieChart(document
				.querySelector('.comparison_proportion_right'));
	
		chart.draw(data, options);
	}
	
	//------------------------------------------------------------------------------------------------------------------------
	
	function chartComparisonDown() {
		var food = 0;
		var oil = 0;
		var home = 0;
		var sale = 0;
		var bus = 0;
		var etc = 0;
		
		$.each(locationData, function(index, item) {
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
		
		var foodMean = food/days
		var oilMean = oil/days
		var homeMean = home/days
		var saleMean = sale/days
		var busMean = bus/days
		var etcMean = etc/days
		
		food = 0;
		oil = 0;
		home = 0;
		sale = 0;
		bus = 0;
		etc = 0;
		
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
		
		var foodMean2 = food/days2
		var oilMean2 = oil/days2
		var homeMean2 = home/days2
		var saleMean2 = sale/days2
		var busMean2 = bus/days2
		var etcMean2 = etc/days2

		var graphData = [ 
			["Category","평균 출장비(1일)","실제 출장비(1일)"],
			[ "교통비",Math.round(oilMean),Math.round(oilMean2)],
			[ "기타",Math.round(etcMean),Math.round(etcMean2)],
			[ "숙박비",Math.round(homeMean),Math.round(homeMean2)],
			[ "식비",Math.round(foodMean),Math.round(foodMean2)],
			[ "유류비",Math.round(oilMean),Math.round(oilMean2)],
			[ "접대비",Math.round(saleMean),Math.round(saleMean2)]
		]
		

		var data = google.visualization.arrayToDataTable(graphData);

		var view = new google.visualization.DataView(data);

		var options = {
			series: [
				{color: 'black', visibleInLegend: true}, 
				{color: 'red', visibleInLegend: true},	
			],
			animation : {
				"startup" : true,
				duration : 1000,
				easing : 'out'
			},
			chartArea : {
				left : '10%',
				top : '15%',
				width : '70%',
				height : '70%'
			},
			legend : {
				position : 'labeled',
				textStyle : {
					color : 'black',
					fontSize : 11
				}
			}
		};
		var chart = new google.visualization.ColumnChart(document
				.querySelector('.sc_maindown_right2_content_comDown_content_graph'));
		chart.draw(view, options);

	}
		
</script>


<body>
	<div class="wrapper">
		<input class="companyNo" type="hidden" value="${sessionScope.companyNo}">
		<input class="authorization" type="hidden" value="${sessionScope.empAuthorization}">
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
		

		<div class="statisticManager">
			<div class="sc_menu">

			</div>
			
			<div class="sc_main">
				<div class="sc_mainup">
					<div class="sc_mainup_left">
						<div class="sc_mainup_left1">
							<div class="sc_mainup_left1_left">
								<div>
									<img src="images/peoples.png">
								</div>
							</div>
							<div class="sc_mainup_left1_right">
								<input type="hidden" class="sc_mainup_left1_right_employee" value="${employees}">
								<div class="sc_mainup_left1_right_display">
									
								</div>
							</div>
						</div>
						<div class="sc_mainup_left2">
						</div>
						<div class="sc_mainup_left3">
							<div class="sc_mainup_left3_left">
								<div>
									<img src="images/businesstrip.png">
								</div>
							</div>
							<div class="sc_mainup_left3_right">
								<div class="sc_mainup_left3_right_display">
								</div>
							</div>
						</div>
					</div>
					<div class="sc_mainup_right">
						<div class="sc_mainup_right_total">
							<div class="sc_mainup_right_total_left">
								<div>
									<img src="images/money.png">
								</div>	
							</div>
							<div class="sc_mainup_right_total_right">
								<div class="sc_mainup_right_total_right_content">
								</div>
							</div>
						</div>
					</div>	
				</div>
				<div class="sc_maindown">
					<div class="sc_maindown_left">
						<div class="sc_maindown_left1">
							<div>Employee</div>
						</div>
						<div class="sc_maindown_left2">
							<div class="sc_maindown_left2_title">
								<div>
									<a>Id</a>
								</div>
								<div>
									<a>Name</a>
								</div>
								<div>
									<a>department</a>
								</div>
							</div>
							<div class="sc_maindown_left2_scrolldiv">
							</div>
						</div>
						<div class="sc_maindown_left3">
							<div>Business Trip</div>
						</div>
						<div class="sc_maindown_left4">
							<div class="sc_maindown_left4_title">
								<div>
									<a>TripName</a>
								</div>
								<div>
									<a>Start Date</a>
								</div>
								<div>
									<a>End Date</a>
								</div>
							</div>
							<div class="sc_maindown_left4_scrolldiv">
							</div>
						</div>
					</div>
					<div class="sc_maindown_right">
						<div class="sc_maindown_right1">
							<div class="sc_maindown_right1_blank">
								<div>
									<a class="backPrivate"></a>
								</div>
							</div>
							<div class="sc_maindown_right1_title">
								<div>
									Statistic
								</div>
							</div>
							<div class="sc_maindown_right1_image">
								<div>
									<a class="comparison">
										<img src="images/company.png">
									</a>
								</div>
							</div>
						</div>
						<div class="sc_maindown_right2">
							<div class="sc_maindown_right2_content">
							</div>	
						</div>
					</div>
				</div>
			</div>
			
			<div class="sc_blank">
			
			</div>
		</div>
	</div>
	<div class="radioDiv">
		<div>
            <input type="radio" id="employee" name="radiobutton" value="employee" checked/>
            <label for="employee">Employee</label>
        </div>

        <div>
           	<input type="radio" id="company" name="radiobutton" value="company" />
            <label for="company">Company</label>
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
</body>
</html>