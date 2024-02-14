<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>배달원 조회</title>
	
	<link rel="stylesheet" href="/css/reset.css">
	<link rel="stylesheet" href="/css/style.css">
	<link rel="stylesheet" href="/css/delivery_man.css">
</head>
<body>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<script>
		// 테이블에 페이지를 추가하는 펑션
		function showPage(page) {
			
			var pageNo = parseInt(page)*50-50+1;
			
			var row;
			
			$.ajax({
		        url: '/delivery_man_page',
		        type: 'POST',
		        dataType: "json",
		        data: JSON.stringify({'page': page}),
	            contentType: "application/json",
		        success: function(data) {
		        	//console.log('성공');
		        	$("#deliveryman_tbl tbody tr:not(:first)").remove();
		        	console.log(data);
		        	
		        	if(data.length > 0){
		        		$.each(data, function(index, item) {
			        	    row = $("<tr>");
			        	    
			        	    // 체크박스 필드
			        	    var checkboxCell = $("<td>").attr("class", "checkbox_td");
			        	    if (item.status!=2) {
			        	    	var checkbox = $("<input>").attr("type", "checkbox").attr("class", "checkboxs").attr("name", "delivery_man_checked");
			        	    	checkboxCell.append(checkbox);
							}
			        	    row.append(checkboxCell);

			        	    // '번호' 필드
			        	    row.append($("<td>").attr("class", "no_td").text(pageNo + index));

			        	    // 'ID' 필드
			        	    var idCell = $("<td>").attr("class", "id_td");
			        	    var idLink = $("<a>").attr("href", "/delivery_man/view?id=" + item.id).text(item.id);
			        	    idCell.append(idLink);
			        	    row.append(idCell);

			        	    // '등록일' 필드
			        	    row.append($("<td>").attr("class", "pw_td").text(item.join_date));

			        	    // '이름' 필드
			        	    row.append($("<td>").attr("class", "name_td").text(item.name));

			        	    // '연락처' 필드
			        	    row.append($("<td>").attr("class", "tel_td").text(item.tel));
							
			        	    // '주소' 필드
			        	    var area = "";
			        	    if (item.area3 != null) {
			        	    	row.append($("<td>").attr("class", "area_td").text(item.area1+" "+item.area2+" "+item.area3));
							} else {
								row.append($("<td>").attr("class", "area_td").text(item.area1+" "+item.area2));
							}
			        	    
			        	    
			        	 	// '상태' 필드
			        	    var statusCell = $("<td>").attr("class","status_td");
			        	    if (item.status == 0) {
			        	        statusCell.text('대기');
			        	    } else if (item.status == 1) {
			        	        statusCell.text('유효');
			        	    } else {
			        	        statusCell.text('만료');
			        	    }
			        	    row.append(statusCell);

			        	    // '상태 버튼 필드'
			        	    var approveCell = $("<td>").attr("class", "approve_td");
			        	    if (item.status == 0) {
			        	        var approveButton = $("<button>").attr("type", "button").attr("id", "approve_btn").attr("value", "1").text("승인");
			        	        var refuseButton = $("<button>").attr("type", "button").attr("id", "refuse_btn").attr("value", "2").text("해지");
			        	        approveCell.append(approveButton);
			        	        approveCell.append(refuseButton);
			        	    } else if (item.status == 1) {
			        	        var refuseButton = $("<button>").attr("type", "button").attr("id", "refuse_btn").attr("value", "2").text("해지");
			        	        approveCell.append(refuseButton);
			        	    }
			        	    
			        	    row.append(approveCell);
			        	    
			        	 	// 모든 데이터를 테이블에 추가
			        	    $("#deliveryman_tbl tbody").append(row);  
		        		});
			        	 	
			        	
		        	} else {
		        	    // 데이터 행 추가
		        	    row = $("<tr>");
		        	    row.append($("<td>").attr("id", "no_date_td").attr("rowspan", 10).attr("colspan", 9).text('조회된 데이터가 없습니다.'));
		        	    $("#deliveryman_tbl tbody").append(row);
		        	}
			
				}
			});
		}
		
		// 검색기능 펑션
		function srech(keyWords,page) {
			
			var pageNo = parseInt(page);
			
			keyWords['page'] = pageNo;
			
			$.ajax({
		        url: '/delivery_man_srech',
		        type: 'POST',
		        dataType: "json",
		        data: JSON.stringify(keyWords),
	            contentType: "application/json",
		        success: function(data) {
		        	console.log('성공');
		        	$("#deliveryman_tbl tbody tr:not(:first)").remove();
		        	
		        	pageNo = parseInt(page)*50-50+1;
		        	if(data.length > 0){
			        	$.each(data, function(index, item) {
			        	    var row = $("<tr>");
							
			        	    // 체크박스 필드
			        	    var checkboxCell = $("<td>").attr("class", "checkbox_td");
			        	    if (item.status!=2) {
			        	    	var checkbox = $("<input>").attr("type", "checkbox").attr("class", "checkboxs").attr("name", "delivery_man_checked");
			        	    	checkboxCell.append(checkbox);
							}
			        	    row.append(checkboxCell);
	
			        	    // '번호' 필드
			        	    row.append($("<td>").attr("class", "no_td").text(pageNo + index));
	
			        	    // 'ID' 필드
			        	    var idCell = $("<td>").attr("class", "id_td");
			        	    var idLink = $("<a>").attr("href", "/delivery_man/view?id=" + item.id).text(item.id);
			        	    idCell.append(idLink);
			        	    row.append(idCell);
	
			        	    // '등록일' 필드
			        	    row.append($("<td>").attr("class", "pw_td").text(item.join_date));
	
			        	    // '이름' 필드
			        	    row.append($("<td>").attr("class", "name_td").text(item.name));
	
			        	    // '연락처' 필드
			        	    row.append($("<td>").attr("class", "tel_td").text(item.tel));
							
			        	    // '주소' 필드
			        	    var area = "";
			        	    if (item.area3 != null) {
			        	    	row.append($("<td>").attr("class", "area_td").text(item.area1+" "+item.area2+" "+item.area3));
							} else {
								row.append($("<td>").attr("class", "area_td").text(item.area1+" "+item.area2));
							}
			        	    
			        	    
			        	 	// '상태' 필드
			        	    var statusCell = $("<td>").attr("class","status_td");
			        	    if (item.status == 0) {
			        	        statusCell.text('대기');
			        	    } else if (item.status == 1) {
			        	        statusCell.text('유효');
			        	    } else {
			        	        statusCell.text('만료');
			        	    }
			        	    row.append(statusCell);
	
			        	    // '상태 버튼 필드'
			        	    var approveCell = $("<td>").attr("class", "approve_td");
			        	    if (item.status == 0) {
			        	        var approveButton = $("<button>").attr("type", "button").attr("id", "approve_btn").attr("value", "1").text("승인");
			        	        var refuseButton = $("<button>").attr("type", "button").attr("id", "refuse_btn").attr("value", "2").text("해지");
			        	        approveCell.append(approveButton);
			        	        approveCell.append(refuseButton);
			        	    } else if (item.status == 1) {
			        	        var refuseButton = $("<button>").attr("type", "button").attr("id", "refuse_btn").attr("value", "2").text("해지");
			        	        approveCell.append(refuseButton);
			        	    }
			        	    
			        	    row.append(approveCell);
			        	    
			        	    // 모든 데이터를 테이블에 추가
			        	    $("#deliveryman_tbl tbody").append(row);
			        	});
			        } else {
		        	    // 데이터 행 추가
		        	    row = $("<tr>");
		        	    row.append($("<td>").attr("id", "no_date_td").attr("rowspan", 10).attr("colspan", 9).text('조회된 데이터가 없습니다.'));
		        	    $("#deliveryman_tbl tbody").append(row);
		        	}
		        	
				}
			});
		}
		
		
		
		$(document).ready(function() {
			// 오늘 날짜 변수
			var today = new Date().toISOString().substring(0, 10);
		    
		    //체크된 id를 담을 변수
		 	var chaekedIds = [];
		    
		    // 현재 페이지 변수
		    var page = $("#page_input").val();
			
		    // 최대 페이지 변수
		    var totalPages = $('#totalPages').text().trim();;
		    
		    //
		    var searchParams = {};
		    
			// 셀렉터에 옵션들 추가
		    $.ajax({
				url: "/load_area1_list_process",
				type: "POST",
				dataType: 'json',
				success: function(data) {
					//console.log(data);
					
					let content = "<option value=''>----- 시도 선택 -----</option>";
					$.each(data, function(index, item) {
						let code = item.CODE.slice(0, 2);
						content += `<option data-code=\${code} value=\${item.AREA}>\${item.AREA}</option>`;
					});
					$("select[name=area1]").html(content);
				}
			});
			
		    //console.log(page)
		    //console.log(totalPages)
		    
		    showPage(page);
		    
		    // 달력을 오늘 날짜로 설정하고 오늘날짜 이후로 설정 모하게 하는 스크립트
			// 달력을 오늘 날짜로 수정
		    $('#start_day').val(today);
		    $('#end_day').val(today);
		    
		    // max 속성을 오늘로 추가
		    $('#start_day').attr('max', today);
		    $('#end_day').attr('max', today);
		    
		    $('.day_btn').click(function() {
		    	// 누른 버튼의 아이디 가져오기
		        var id = $(this).attr('id');
		        var date;

		        // ID에 따라 날짜를 설정
		        if (id === "today") {
		            $('#start_day').val(today);
		        } else if (id === "oneWeek") {
		        	// 일주일 전 설정
		            date = new Date();
		            date.setDate(date.getDate() - 7); 
		            var oneWeek = date.toISOString().substring(0, 10);
		            $('#start_day').val(oneWeek);
		            
		        } else if (id === "oneMonth") {
		        	// 한 달 전 설정
		            date = new Date();
		            date.setMonth(date.getMonth() - 1); 
		            var oneMonth = date.toISOString().substring(0, 10);
		            $('#start_day').val(oneMonth);
		        }
	        });
		    
		    // 조회 버튼 펑션
		    $('#search_btn').click(function(){
		    	
		        $('#search_tbl input, #search_tbl select').each(function() {
		            var id = $(this).attr('id');
		            var value = $(this).val();
		            
		            // 라디오 버튼일때 체크된거 하나만 저장
		            if ($(this).attr('type') === 'radio') {
		            	if ($(this).is(':checked')) {
		            		if (value.trim() !== '') {
		                        searchParams['status'] = value;
		                    }
			            	return;
						} else{
							return;
						}
					}
		            
		         	// 값이 공백이 아닌 경우에만 저장.
	                if (value.trim() !== '') {
	                    searchParams[id] = value;
	                }
		        });
		        //console.log(searchParams);
		        page = 1;
		        
		        srech(searchParams,page);
		        
		        $.ajax({
			        url: '/delivery_man_maxpage',
			        type: 'POST',
			        dataType: "json",
			        data: JSON.stringify(searchParams),
		            contentType: "application/json",
			        success: function(data) {
			        	totalPages = data;
			        	if(totalPages == 0){
			        		$('#totalPages').text(1);
			        	} else{
			        		$('#totalPages').text(totalPages);
			        	}
			        	$('#page_input').val(page);
			        }
		        })
		        
		    });
		    
		    
		    // 체크박스 전체 선택 해제 펑션
		    $('#all_check').click(function(){
				var checked = $('#all_check').is(':checked');
				
				if(checked){
					$('.checkboxs').prop('checked',true);
				} else{
					$('.checkboxs').prop('checked',false);
				}
			});
		    
		    // 승인,해지 버튼 펑션
		    $(document).on('click', '#approve_btn, #refuse_btn', function() {
		        var status = $(this).val();
		        var id = $(this).closest("tr").find(".id_td a").text();
		        
		        //console.log(id)
		        //console.log(status)
		        if (confirm("해당 배달원의 상태를 변경하시겠습니까?")) {
		        	$.ajax({
			            type: "POST",
			            url: "/delivery_man_status_modfiy",
			            dataType: "json",
			            data: JSON.stringify({ id: id, status: status }),
			            contentType: "application/json",
			            success: function(data) {
			                if (data === 1) {
			                    alert("변경이 완료되었습니다.");
			                    
			                    if(Object.keys(searchParams).length == 0){
			    		    		showPage(page);
			                    } else{
			                    	srech(searchParams,page)	
			                    }
			                    
			                } else {
			                    alert("서버에 문제가 생겼습니다. 관리자에게 이야기해주세요.");
			                }
			            },
			            error: function(xhr, textStatus, errorThrown) {
			                console.error("에러:", errorThrown);
		          		}
		    		});
		        }
		    });
		    
		    // 선택 승인,해지버튼 펑션
		    $('#select_approve_btn, #select_refuse_btn').click(function() {
		        var status = $(this).val();
		        var checkedIds = []; // checkedIds 변수를 정의하고 빈 배열로 초기화합니다.
				var isChecked = false;
		        
		        // 체크된 체크박스를 가져옵니다.
		        $(".checkboxs:checked").each(function() {
		            // 체크된 체크박스의 아이디 값을 가져와 배열에 추가합니다.
		            var id = $(this).closest("tr").find(".id_td a").text();
		            checkedIds.push(id);
		            isChecked = true;
		        });

		        console.log(checkedIds);
		        if (isChecked) {
		        	if (confirm("해당 배달원들의 상태를 변경하시겠습니까?")) {
						
			        	$.ajax({
				            type: "POST",
				            url: "/delivery_man_select_status_modfiy",
				            dataType: "json",
				            data: JSON.stringify({ ids: checkedIds, status: status }),
				            contentType: "application/json",
				            success: function(data) {
				                if (data === 1) {
				                    alert("변경이 완료되었습니다.");
				                    if(Object.keys(searchParams).length == 0){
				    		    		showPage(page);
				                    } else{
				                    	srech(searchParams,page)	
				                    }

				                } else {
				                    alert("서버에 문제가 생겼습니다. 관리자에게 이야기해주세요.");
				                }
				            },
				            error: function(xhr, textStatus, errorThrown) {
				                console.error("에러:", errorThrown);
				            }
				        });	
		        	}
				}
		        
		    });
		    
		    // 페이징 버튼 펑션들
		    
		    // 첫번째 페이지 평선
		    $('#first_page_btn').click(function() {
		    	page = 1;
		    	console.log(page);
		    	console.log(searchParams);
		    	$('#page_input').val(page);
		    	
		    	if(Object.keys(searchParams).length == 0){
		    		showPage(page);
                } else{
                	srech(searchParams,page)	
                }
		    });
		    
		    // 이전 페이지 펑션
		    $('#previous_page_btn').click(function() {
		    	if (parseInt(page) != 1) {
		    		page = parseInt(page)-1;
				}
		    	console.log(page);
		    	console.log(searchParams);
		    	$('#page_input').val(page);
		    	
		    	if(Object.keys(searchParams).length == 0){
		    		showPage(page);
                } else{
                	srech(searchParams,page)	
                }
		    });
		    
		    // 다음 페이지 펑션
		    $('#next_page_btn').click(function() {
		    	if (parseInt(page) != parseInt(totalPages)) {
		    		page = parseInt(page)+1;
				}
		    	console.log(page);
		    	console.log(searchParams);
		    	$('#page_input').val(page);
		    	
		    	if(Object.keys(searchParams).length == 0){
		    		showPage(page);
                } else{
                	srech(searchParams,page)	
                }
		    });
		    
		    // 마지막 페이지 펑션
		    $('#last_page_btn').click(function() {
		    	page = totalPages;
		    	
		    	console.log(page);
		    	console.log(searchParams);
		    	$('#page_input').val(page);
		    	
		    	if(Object.keys(searchParams).length !== 0){
                	srech(searchParams,page)
                } else{
                	showPage(page);
                }
		    	
		    });
		    
		    
		    
		    
		});
	</script>

	<%@include file="/WEB-INF/header.jsp" %>
	<!-- 배달원 정보 부분 -->
	<div id="deliveryman_wrap">
		<h2>배달원 조회</h2>
		<hr>
		<!-- 배달원 검색 세션 -->
		<section id="search_section">
			<!-- 배달원 검색 테이블 -->
			<table id="search_tbl" border="1">
				<tbody>
					<tr>
					  <th class="search_th">아이디</th>
					  <td><input type="text" id="id" name="id"></td>
  					  <th class="search_th">이름</th>
					  <td><input type="text" id="name" name="name"></td>
  					  <th class="search_th">연락처</th>
					  <td><input type="text" id="tel" name="tel"></td>
					</tr>
					
					<tr>
					  <th class="search_th">등록일</th>
					  <td colspan="5">
					    <input type="date" id="start_day"  name="start_day">
					    <input type="date" id="end_day" name="end_day">
						<button type="button" class="day_btn" id="today">당일</button>
						<button type="button" class="day_btn" id="oneWeek">일주일</button>
						<button type="button" class="day_btn" id="oneMonth">한 달</button>
						
					  </td>

					</tr>
					<tr>
					  <th class="search_th">담당지</th>
					  
					  <td>
			  			<select id="area1" name="area1">
							<option value="">----- 시도 선택 -----</option>
						</select>
						<select id="area2" name="area2">
							<option value="">----- 시군구 선택 -----</option>
						</select>
						<select id="area3" name="area3">
							<option value="">----- 읍면동 선택 -----</option>
						</select>
					  </td>
					  
  					  <th class="search_th">상태</th>
					  <td>
					  	<input type="radio" id="status_all" name="status" value="" checked="checked">
						<label class="status_labels" for='status_all'>전체</label>
						<input type="radio" id="status_valid" name="status" value="1">
						<label class="status_labels" for='status_valid'>유효</label>
						<input type="radio" id="status_waiting" name="status" value="0">
						<label class="status_labels" for='status_waiting'>대기</label>
						<input type="radio" id="status_expiration" name="status" value="2">
						<label class="status_labels" for='status_expiration'>만료</label>
					  </td>
					</tr>
				</tbody>
			</table>
			<!-- /배달원 검색 테이블 -->
			
			<!-- 검색 버튼 -->
			<button id="search_btn">조회</button>
			<!-- /검색 버튼 -->
			
		</section>
		<!-- /배달원 검색 세션 -->
		
		<!-- 배달원 정보 출력 세션 -->
		<section id="deliveryman_info">
			<table id="deliveryman_tbl" border="1">
				<tbody>
					<tr>
						<th class="delivetyman_th"><input type="checkbox" id="all_check"></th>
						<th class="delivetyman_th">No</th>
						<th class="delivetyman_th">ID</th>
						<th class="delivetyman_th">등록일</th>
						<th class="delivetyman_th">이름</th>
						<th class="delivetyman_th">연락처</th>
						<th class="delivetyman_th">담당지</th>
						<th class="delivetyman_th">상태</th>
						<th class="delivetyman_th"></th>
					</tr>
					
				</tbody>
			</table>
		</section>
		
		<!-- 선택 버튼 div -->
		<div id="approve_btns">
			<button type="button" id="select_approve_btn" value="1">선택 승인</button>
			<button type="button" id="select_refuse_btn" value="2">선택 거절</button>
		</div>
		<!-- / 선택 버튼 div -->
		<!-- 페이징 세션 -->
		<section id="page_section">
			<button id="first_page_btn">&lt;&lt;</button>
			<button id="previous_page_btn">&lt;</button>
			<div id="pgae_div">
				<input type="number" id="page_input" value="${page}" min="1" max="${totalPages}">
				<p>/</p>
				<p id="totalPages">
				<c:if test="${totalPages != 0}">
					<c:out value="${totalPages}" />
				</c:if>
				<c:if test="${totalPages == 0}">
					1
				</c:if>
				</p>
			</div>
			<button id="next_page_btn">&gt;</button>
			<button id="last_page_btn">&gt;&gt;</button>
		</section>
		<!-- /페이징 세션 -->
	</div>
	<!-- /배달원 정보 출력 세션 -->
	<%@include file="/WEB-INF/footer.jsp" %>
	
</body>
</html>