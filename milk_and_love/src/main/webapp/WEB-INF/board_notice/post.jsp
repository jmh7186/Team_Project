<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>공지사항 등록</title>
	
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
			<h2>공지사항 등록</h2>
			
			<!-- 등록 -->
			<div class="post_wrap">
				<form id="frm_post" action="/notice/post_process" method="post" onsubmit="return false;">
					<table>
						<tbody>
							<tr>
								<th>제목</th>
								<td><input type="text" name="title" maxlength="50"></td>
							</tr>
							<tr>
								<th>내용</th>
								<td><textarea name="content"></textarea></td>
							</tr>
						</tbody>
					</table>
					
					<!-- 버튼 -->
					<div class="btns">
						<input type="button" value="취소" onclick="location.href='/notice/list'">
						<input type="reset" value="초기화">
						<input type="submit" value="등록">
					</div>
					<!-- // 버튼 -->
				</form>
			</div>
			<!-- // 등록 -->
		</div>
		<!-- // 컨테이너 -->
		
		<%@include file="/WEB-INF/footer.jsp" %>
	</div>
	
	<script>
	$(document).ready(function() {
		// 등록 버튼 클릭 시
		$("#frm_post input[type=submit]").on("click", function() {
			let title = $("#frm_post input[name=title]");
			let content = $("#frm_post textarea[name=content]");
			
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
				url: "/notice/post_process",
				type: "POST",
				data: $("#frm_post").serialize(),
				success: function(data) {
					// 등록 성공 시
					if(data != 0){
						alert("등록이 완료되었습니다.");
						location.href="/notice/list";
						
					} else { // 등록 실패 시
						alert("등록에 실패하였습니다.");
					}
				}
			});
		});
		
	});
	</script>
</body>
</html>