<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>공지사항 확인 및 수정</title>
	
	<link rel="stylesheet" href="/css/reset.css">
	<link rel="stylesheet" href="/css/style.css">
	<link rel="stylesheet" href="/css/notice.css">
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
</head>
<body>
	<div id="wrap">
		<%@include file="/WEB-INF/header.jsp" %>
	
		<!-- 컨테이너 -->
		<div id="container">
			<h2>공지사항 확인 및 수정</h2>
			
			<!-- 정보 -->
			<div class="info_wrap">
				<form id="frm_edit" action="/notice/edit_process" method="post" onsubmit="return false;">
					<input type="hidden" name="no" value="${vo.no}">
					<table>
						<tbody>
							<tr>
								<th>작성자</th>
								<td>${vo.author}</td>
								<th>작성일자</th>
								<td>${vo.post_date}</td>
							</tr>
							<tr>
								<th>제목</th>
								<td colspan="3">
									<input type="text" name="title" maxlength="50" value="${vo.title}">
								</td>
							</tr>
							<tr>
								<th>내용</th>
								<td colspan="3">
									<textarea name="content">${vo.content}</textarea>
								</td>
							</tr>
							<tr>
								<th>숨김 설정</th>
								<td colspan="3">
									<input type="radio" name="is_hidden" value="0" <c:if test="${vo.is_hidden eq 0}"> checked </c:if>>표시
									<input type="radio" name="is_hidden" value="1" <c:if test="${vo.is_hidden eq 1}"> checked </c:if>>숨김
								</td>
							</tr>
						</tbody>
					</table>
					
					<!-- 버튼 -->
					<div class="btns">
						<input type="button" value="취소" onclick="location.href='/notice/list'">
						<input type="submit" value="수정">
					</div>
					<!-- // 버튼 -->
				</form>
			</div>
			<!-- // 정보 -->
		</div>
		<!-- // 컨테이너 -->
		
		<%@include file="/WEB-INF/footer.jsp" %>
	</div>
	
	<script>
	$(document).ready(function() {
		// 수정 버튼 클릭 시
		$("#frm_edit input[type=submit]").on("click", function() {
			let title = $("#frm_edit input[name=title]");
			let content = $("#frm_edit textarea[name=content]");
			
			// 제목을 입력하지 않았을 때
			if(!title.val()) {
				alert("제목을 입력해 주세요.");
				title.focus();
				return;
			}
			
			// 내용을 입력하지 않았을 때
			if(!content.val()) {
				alert("내용을 입력해 주세요.");
				content.focus();
				return;
			}
			
			$.ajax({
				url: "/notice/edit_process",
				type: "POST",
				data: $("#frm_edit").serialize(),
				success: function(data) {
					// 수정 성공 시
					if(data != 0) {
						alert("수정이 완료되었습니다.")
						location.reload();
						
					} else { // 수정 실패 시
						alert("수정에 실패하였습니다.");
					}
				}
			});
		});
		
	});
	</script>
</body>
</html>
