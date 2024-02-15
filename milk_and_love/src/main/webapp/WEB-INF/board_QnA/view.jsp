<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>QnA상세</title>

	<link rel="stylesheet" href="/css/reset.css">
	<link rel="stylesheet" href="/css/style.css">
	<link rel="stylesheet" href="/css/delivery_man.css">
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>

</head>
<body>	
	<%@include file="/WEB-INF/header.jsp" %>
	<!-- qna 상세페이지 -->
	<div id="qna_wrap">
		<!-- qna 상세페이지 세션 -->
		<section id="qna_view_tbls">
			<input type="hidden" id="no" value="${vo.no}">
			<table id="inquiry_tbl" border="1">
				<tr>
					<th>작성일</th>
					<td><input type="text" value="${vo.q_date}" readonly></td>
					<th>작성자</th>
					<td><input type="text" value="${vo.q_author}" readonly></td>
				</tr>
				<tr>
					<th>제목</th>
					<td colspan="3"><input type="text" value="${vo.title}" readonly></td>
				</tr>
				<tr>
					<th rowspan="1">문의</th>
					<td colspan="4"><input type="text" value="${vo.q_content}" readonly></td>
				</tr>
				<tr>
					<th rowspan="3">답변</th>
					<c:if test="${vo.a_content != null }">
						<td colspan="4"><input type="text" id="a_content" value="${vo.a_content}"></td>
					</c:if>
					<c:if test="${vo.a_content == null }">
						<td colspan="4"><input type="text" id="a_content"></td>
					</c:if>
				</tr>
			</table>
			
		</section>
		<!-- /qna 상세페이지 세션 -->
		<!-- qna 상세 부분 버튼들 -->
		<div id="qna_view_btns">
		<c:if test="${vo.status == 0}">
			<button id="cancel_btn">취소</button>
			<button id="registration_btn">등록</button>
			<button id="delete_btn">삭제</button>
		</c:if>
		<c:if test="${vo.status == 1}">
			<button id="cancel_btn">취소</button>
			<button id="registration_btn">답변수정</button>
			<button id="delete_btn">삭제</button>
		</c:if>
		</div>
		<!-- /qna 상세 부분 버튼들 -->
	</div>
	<!-- /qna 상세페이지 -->
	<%@include file="/WEB-INF/footer.jsp" %>
</body>
</html>