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

<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="module" src="/js/board_QnA/list.js"></script>
</head>
<body>
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
		<section id="qna_borad_section">
			<table id="qna_tbl" border="1">
				<tbody>
					<tr>
						<th class="qna_th">번호</th>
						<th class="qna_th">제목</th>
						<th class="qna_th">작성일</th>
						<th class="qna_th">작성자</th>
						<th class="qna_th">답변 여부</th>
						<th class="qna_th">답변자</th>
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