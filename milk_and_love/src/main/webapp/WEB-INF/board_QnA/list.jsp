<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1문의</title>
<link rel="stylesheet" href="/css/reset.css">
<link rel="stylesheet" href="/css/style.css">
</head>
<body>
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script>
	
		function showPage(page) {
			
			var row;
			
			$.ajax({
		        url: '/QnA_list',
		        type: 'POST',
		        dataType: "json",
		        data: JSON.stringify({'page': page}),
	            contentType: "application/json",
		        success: function(data) {
		        	//console.log('성공');
		        	
		        	// 기존 테이블 행들을 삭제
		        	$("#qna_tbl tbody tr:not(:first)").remove();
		        	console.log(data);
		        	
		        	if(data.length > 0){
		        		$.each(data, function(index, item) {
		        			if (item.is_deleted == 1) {
								return;
							}
		        			
		        			// 행 설정
			        	    row = $("<tr>");
	
			        	    // '번호' 필드
			        	    row.append($("<td>").attr("class", "no_td").text(item.no));
			        	    
							// '제목' 필드
							var titleCell = $("<td>").attr("class", "title_td");
			        	    var titleLink = $("<a>").attr("href", "/QnA/view?no=" + item.no).text(item.title);
			        	    titleCell.append(titleLink);
			        	    row.append(titleCell);
			        	    
			        	    // '작성일' 필드
			        	    row.append($("<td>").attr("class", "date_td").text(item.q_date));
			        	    
			        		// '작성자' 필드
			        	    row.append($("<td>").attr("class", "author_td").text(item.q_author));
	
			        	    
			        	 	// '상태' 필드
			        	    var statusCell = $("<td>").attr("class","status_td");
			        	    if (item.status == 0) {
			        	        statusCell.text('대기');
			        	    } else {
			        	        statusCell.text('완료');
			        	    }
			        	    
			        	    row.append(statusCell);
			        	    
			        	 	// 모든 데이터를 테이블에 추가
			        	    $("#qna_tbl tbody").append(row);  
		        		});
			        	 	
			        	
		        	} else {
		        	    // 데이터 행 추가
		        	    row = $("<tr>");
		        	    row.append($("<td>").attr("id", "no_date_td").attr("rowspan", 10).attr("colspan", 9).text('문의가 없습니다.'));
		        	    $("#qna_tbl tbody").append(row);
		        	}
			
				}
			});
		}
		
		
		
		// 검색기능 펑션
		function srech(keyWords,page) {
			
			var pageNo = parseInt(page);
			
			keyWords['page'] = pageNo;
			
			$.ajax({
		        url: '/QNA_srech',
		        type: 'POST',
		        dataType: "json",
		        data: JSON.stringify(keyWords),
	            contentType: "application/json",
		        success: function(data) {
		        	console.log('성공');
		        	
		        	// 기존 테이블 행들을 삭제
		        	$("#qna_tbl tbody tr:not(:first)").remove();
		        	
		        	pageNo = parseInt(page)*50-50+1;
		        	if(data.length > 0){
			        	$.each(data, function(index, item) {
			        		if (item.is_deleted == 1) {
								return;
							}
			        		
		        			// 행 설정
			        	    row = $("<tr>");
	
			        	    // '번호' 필드
			        	    row.append($("<td>").attr("class", "no_td").text(item.no));
	
			        	    
			        	 	// '제목' 필드
							var titleCell = $("<td>").attr("class", "title_td");
			        	    var titleLink = $("<a>").attr("href", "/QnA/view?no=" + item.no).text(item.title);
			        	    titleCell.append(titleLink);
			        	    row.append(titleCell);
			        	    
			        	    // '작성일' 필드
			        	    row.append($("<td>").attr("class", "date_td").text(item.q_date));
			        	    
			        		// '작성자' 필드
			        	    row.append($("<td>").attr("class", "author_td").text(item.q_author));
	
			        	    
			        	 	// '상태' 필드
			        	    var statusCell = $("<td>").attr("class","status_td");
			        	    if (item.status == 0) {
			        	        statusCell.text('대기');
			        	    } else {
			        	        statusCell.text('완료');
			        	    }
			        	    
			        	    row.append(statusCell);
			        	    
			        	 	// 모든 데이터를 테이블에 추가
			        	    $("#qna_tbl tbody").append(row);  
		        		});
		        	 	
		        	
	        		} else {
		        	    // 데이터 행 추가
		        	    row = $("<tr>");
		        	    row.append($("<td>").attr("id", "no_date_td").attr("rowspan", 10).attr("colspan", 9).text('문의가 없습니다.'));
		        	    $("#qna_tbl tbody").append(row);
	        		}
		        }
			});
		}
		
		
		$(document).ready(function() {
			
			// 현재 페이지 변수
		    var page = $("#page_input").val();
			
		    // 최대 페이지 변수
		    var totalPages = $('#totalPages').text().trim();
			
			// 검색 데이터 저장 변수
		    var searchParams = {};
			
			// 페이지를 동적으로 추가
			showPage(page);
			
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
		        console.log(searchParams);
		        
		        page = 1;
		        
		        srech(searchParams,page);
		        
		        $.ajax({
			        url: '/QNA_srech_maxpage',
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
	<!-- qna 게시판 wrap -->
	<div id="qna_wrap">
		<h2>1:1문의</h2>
		<hr>
		<!-- 검색 세션 -->
		<section id="search_section">
			<!-- 검색 테이블 -->
			<table id="search_tbl" border="1">
				<tbody>
					<tr>
					  <th class="search_th">제목</th>
					  <td><input type="text" id="title" name="title"></td>
  					  <th class="search_th">작성자</th>
					  <td><input type="text" id="q_author" name="q_author"></td>
  					  <th class="search_th">상태</th>
					  <td>
					  	<input type="radio" id="status_all" name="status" value="" checked="checked">
					  	<label class="status_labels" for='status_all' >전체</label>
						<input type="radio" id="status_waiting" name="status" value="0">
						<label class="status_labels" for='status_waiting'>대기</label>
						<input type="radio" id="status_complete" name="status" value="1">
						<label class="status_labels" for='status_complete'>완료</label>
					  </td>
					</tr>
				</tbody>
			</table>
			<!-- /검색 테이블 -->
			
			<!-- 검색 버튼 -->
			<button id="search_btn">조회</button>
			<!-- /검색 버튼 -->
			
		</section>
		<!-- /검색 세션 -->
		
		<!-- qna게시판 -->
		<section id="qna_borad">
			<table id="qna_tbl" border="1">
				<tbody>
					<tr>
						<th class="qna_th">번호</th>
						<th class="qna_th">제목</th>
						<th class="qna_th">작성일</th>
						<th class="qna_th">작성자</th>
						<th class="qna_th">답변 여부</th>
					</tr>
					
				</tbody>
			</table>
		</section>
		<!-- /qna게시판 -->
		
		
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
	<!-- /qna 게시판 wrap -->
	<%@include file="/WEB-INF/footer.jsp" %>
</body>
</html>