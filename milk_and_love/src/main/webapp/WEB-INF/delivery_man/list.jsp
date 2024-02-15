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
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script src="/js/tableBuilder.js"></script>
	<script src="/js/delivery_man/list.js"></script>
	<script src="/js/delivery_man/AreaSelect.js"></script>
</head>
<body>
	
	<script>
		$(document).ready(function() {
			// 오늘 날짜 변수
			var today = new Date().toISOString().substring(0, 10);
			
		    //체크된 id를 담을 변수
		 	var chaekedIds = [];
		    
		    // 현재 페이지 변수
		    var page = $("#page_input").val();
			
		    // 최대 페이지 변수
		    var totalPages = $('#totalPages').text().trim();
		    
		    // 검색할 키워드들을 담은 변수
		    var searchParams = {};
		    
		    var tableName = '#deliveryman_tbl';
		    var pageName = 'delivery_man';
		    
		    var tableBuilder = new DeliveryManTable(pageName,tableName);
		    
		     //console.log(page)
		    //console.log(totalPages)
		    
		    tableBuilder.showPage(page);
		     
		    // 셀렉터 추가
		    addArea1Select();
		    
		    $("select[name=area1]").on("change", function() {
		    	let area1_code = $(this).find("option:selected").data("code");
		    	//console.log(area1_code);
		    	addArea2Select(area1_code);
		    });
		    
		    $("select[name=area2]").on("change", function() {
		    	let area2_code = $(this).find("option:selected").data("code");
		    	addArea3Select(area2_code);
		    });
		    
		    
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
		        tableBuilder.timeSet(id,today);
	        });
		    
		    // 조회 버튼 펑션
		    $('#search_btn').click(function(){
		    	// 객체 초기화
		    	searchParams = {};
		    	
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
		        
		        tableBuilder.srech(searchParams,page);
		        
		        $.ajax({
			        url: '/delivery_man_maxpage',
			        type: 'POST',
			        dataType: "json",
			        data: JSON.stringify(searchParams),
		            contentType: "application/json",
			        success: function(data) {
			        	totalPages = data;
			        	if(totalPages == 0){
		        			totalPages = 1;
			        	};
			        	
			        	$('#totalPages').text(totalPages);
			        	$('#page_input').val(page);
			        }
		        })
		        
		    });
		    
		    
		    // 체크박스 전체 선택 해제 펑션
		    $('#all_check, .checkboxs').click(function(){
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
			                    	showPage(page,tableName);;
			                    } else{
			                    	srech(searchParams,page,tableName)	
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

		        //console.log(checkedIds);
		        
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
				                    	tableBuilder.showPage(page,tableName);;
				                    } else{
				                    	tableBuilder.srech(searchParams,page,tableName)	
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
		    
			// 페이지 버튼 펑션들
			
		    // 첫번째 페이지 평선
		    $('#first_page_btn').click(function() {
		    	page = tableBuilder.firstPage(page,searchParams);
		    });
		    
		    // 이전 페이지 펑션
		    $('#previous_page_btn').click(function() {
		    	page = tableBuilder.previousPage(page,searchParams);
		    });
		    
		    // 다음 페이지 펑션
		    $('#next_page_btn').click(function() {
		    	page = tableBuilder.nextPage(page,totalPages,searchParams);
		    });
		    
		    // 마지막 페이지 펑션
		    $('#last_page_btn').click(function() {
		    	page = tableBuilder.lastPage(page,totalPages,searchParams);
		    	
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
			<div id="page_div">
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