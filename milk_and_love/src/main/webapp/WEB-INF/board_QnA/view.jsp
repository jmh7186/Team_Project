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
	
	<script>
	
	$(document).ready(function() {
		var a_content = $('#a_content').val();
		
		// 취소 버튼 스크립트
		$("#cancel_btn").click(function(){
			window.location = "/QnA";
		});
		
		
		// 답변 등록 스크립트
		$("#registration_btn").click(function(){
			if (confirm('답변을 등록 하시겠습니까?')) {
				if($('#a_content').val().trim() != "" || $('#a_content').val() != a_content){
				
			
					var anserParams = {};
					
					var no = ${vo.no}
					
					// 관리자 아이디를 저장 하는 부분이 없기에 임시로 admin으로 설정함
					//var managerId = ${admin_id};
					var managerId = 'admin'; // 임시 매니저 아이디
					
					var content = $("#a_content").val();
					
					anserParams['a_author']  = managerId;
					anserParams['a_content'] = content
					anserParams['no'] = no;
					
					$.ajax({
				        url: '/QNA_answer',
				        type: 'POST',
				        dataType: "json",
				        data: JSON.stringify(anserParams),
			            contentType: "application/json",
				        success: function(data) {
				        	if(data == 1) {
				        		alert("답변이 등록 되었습니다.");
				        		location.reload(true);
							} else{
								alert("서버에 오류가 발생하였습니다.");
							}
				        	
				        }
					})
				} else {
					if ($('#a_content').val().trim() == "") {
						alert("답변을 작성 후 등록버튼을 눌러주세요.");
					} else{
						alert("답변을 수정 후 등록버튼을 눌러주세요.")
					}
					
				}
			}
		});
		
		// 문의 삭제 버튼 스크립트
		$("#delete_btn").click(function(){
			if (confirm('정말 삭제 하시겠습니까?')) {
				var no = ${vo.no}
				$.ajax({
			        url: '/QNA_delete',
			        type: 'POST',
			        dataType: "json",
			        data: JSON.stringify({'no': no}),
		            contentType: "application/json",
			        success: function(data) {
			        	if(data == 1) {
			        		alert("삭제가 완료 되었습니다.");
			        		window.location = "/QnA";
						} else{
							alert("서버에 오류가 발생하였습니다.");
						}
			        	
			        }
				})
			}
		});
		

	});
		
	</script>
	
	<%@include file="/WEB-INF/header.jsp" %>
	<!-- qna 상세페이지 -->
	<div id="qna_wrap">
		<!-- qna 상세페이지 세션 -->
		<section id="qna_view_tbls">
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