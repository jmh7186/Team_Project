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
	<script type="module" src="/js/delivery_man/list.js"></script>
</head>

<body>
	
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