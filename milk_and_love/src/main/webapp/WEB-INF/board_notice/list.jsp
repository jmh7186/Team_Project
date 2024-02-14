<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>공지사항 목록</title>
	
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
			<h2>공지사항 목록</h2>
		
			<!-- 검색 -->
			<div class="search_wrap">
				<form id="frm_search" action="/notice/load_list_process" method="post" onsubmit="return false;">
					<table>
						<tbody>
							<tr>
								<th>제목</th>
								<td><input type="text" name="keyword"></td>
							</tr>
						</tbody>
					</table>
					
					<input type="submit" value="검색">
				</form>
			</div>
			<!-- // 검색 -->
			
			<!-- 검색 결과 -->
			<div class="list_wrap">
				<div class="guide">
					제목을 클릭하면 공지사항 확인 및 수정 페이지로 이동합니다.
				</div>
				
				<form id="frm_list" method="post" onsubmit="return false;">
					<!-- 목록 -->
					<div class="list">
						<table>
							<thead>
								<tr>
									<th><input type="checkbox" id="select_all"></th>
									<th>No</th>
									<th></th>
									<th>번호</th>
									<th>제목</th>
									<th>작성일자</th>
									<th>작성자</th>
									<th>조회수</th>
									<th>상태</th>
									<th></th>
								</tr>
							</thead>
							<tbody>
								<c:if test="${empty list}">
									<tr>
										<td colspan="10">데이터가 없습니다.</td>
									</tr>
								</c:if>
								
								<c:forEach var="item" items="${list}" varStatus="status">
									<tr>
										<td>
											<input type="checkbox" name="no" value="${item.no}">
										</td>
										<td>${status.count}</td>
										<td>
											<span class="pin <c:if test='${item.is_pinned eq 1}'>pinned</c:if>">
												📌
											</span>
										</td>
										<td>${item.no}</td>
										<td><a href="/notice/view?no=${item.no}">${item.title}</a></td>
										<td>${item.post_date}</td>
										<td>${item.author}</td>
										<td>${item.views}</td>
										<td>
											<c:choose>
												<c:when test="${item.is_hidden eq 0}">
													표시
												</c:when>
												<c:otherwise>
													숨김
												</c:otherwise>
											</c:choose>
										</td>
										<td>
											<c:choose>
												<c:when test="${item.is_pinned eq 0}">
													<input type="button" id="single_pin" value="고정" data-no="${item.no}">
												</c:when>
												<c:otherwise>
													<input type="button" id="single_unpin" value="고정 해제" data-no="${item.no}">
												</c:otherwise>
											</c:choose>
											
											<c:choose>
												<c:when test="${item.is_hidden eq 0}">
													<input type="button" id="single_hide" value="숨김" data-no="${item.no}">
												</c:when>
												<c:otherwise>
													<input type="button" id="single_display" value="숨김 해제" data-no="${item.no}">
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
					<!-- // 목록 -->

					<!-- 버튼 -->
					<div class="btns">
						<input type="button" id="select_pin" value="선택 고정">
						<input type="button" id="select_unpin" value="선택 고정 해제">
						<input type="button" id="select_hide" value="선택 숨김">
						<input type="button" id="select_display" value="선택 숨김 해제">
					</div>
					<!-- // 버튼 -->

					<!-- 페이지 -->
					<div class="pagination">
						<input type="button" class="move_page before" id="first_page" value="<<">
						<input type="button" class="move_page before" id="prev_page" value="<">
						<input type="number" value="1">/<span>${totalPageCount}</span>
						<input type="button" class="move_page after" id="next_page" value=">">
						<input type="button" class="move_page after" id="last_page" value=">>">
					</div>
					<!-- // 페이지 -->
				</form>
			</div>
			<!-- // 검색 결과 -->
		</div>
		<!-- // 컨테이너 -->
	
		<%@include file="/WEB-INF/footer.jsp" %>
	</div>
	
	<script>
	$(document).ready(function() {
		let isFormChanged = false;		// 검색 조건 변경 여부
		let currentPageNum = Number($("div.pagination > input[type=number]").val());	// 현재 페이지
		
		checkPageMoveButton();
		
		// 검색 폼에 변경 이벤트가 발생한 경우
		$("#frm_search").on("change", function() {
			isFormChanged = true;
		});
		
		// 검색 버튼 클릭
		$("#frm_search input[type=submit]").on("click", function() {
			currentPageNum = 1;
			loadList(1);
			isFormChanged = false;
		});
		
		// 전체 선택
		$("#select_all").on("change", function() {
			// 전체 선택된 상태
			if($(this).prop("checked")) {
				$("div.list table tbody input[type=checkbox]").prop("checked", true);	// 모든 체크박스에 체크
			
			} else { // 전체 선택 해제
				$("div.list table tbody input[type=checkbox]").prop("checked", false);	// 모든 체크박스에 체크 해제
			}
		});
		
		// 선택 체크
		$(document).on("change", "div.list table tbody input[type=checkbox]", function() {
			let totalCount = $("div.list table tbody input[type=checkbox]").length;
			let checkedCount = $("div.list table tbody input[type=checkbox]:checked").length;
			
			// 모든 항목에 체크된 경우
			if(totalCount == checkedCount) {
				$("#select_all").prop("checked", true);		// 전체 선택 체크
			
			} else {
				$("#select_all").prop("checked", false);	// 전체 선택 체크 해제
			}
			
		});
		
		// 선택 작업 클릭
		$("div.btns > input[type=button]").on("click", function() {
			let checkedCount = $("div.list table tbody input[type=checkbox]:checked").length;
			
			// 체크된 항목이 0개인 경우
			if(checkedCount == 0) {
				return;
			}
			
			let type = $(this).attr("id").replace("select_", "");
			let sendData = "type=" + type + "&" + $("#frm_list").serialize();
			
			updateStatusProcess(sendData);
		});
		
		// 단일 작업 클릭
		$(document).on("click", "#frm_list td input[type=button]", function() {
			let type = $(this).attr("id").replace("single_", "");
			let sendData = "type=" + type + "&no=" + $(this).data("no");
			
			updateStatusProcess(sendData);
		});
		
		// 상태 변경 프로세스
		function updateStatusProcess(sendData) {
			$.ajax({
				url: "/notice/update_status_process",
				type: "POST",
				data: sendData,
				success: function(data) {
					// 요청에 성공한 경우
					if(data != 0) {
						alert("요청이 완료되었습니다.");
						loadList(currentPageNum);
						
					} else { // 요청에 실패한 경우
						alert("요청에 실패하였습니다.");
					}
				}
			});
		}
		
		// 페이지 이동 버튼
		$("div.pagination > .move_page").on("click", function() {
			// 검색 조건이 변경된 경우 -> 페이지 이동 제한
			if(isFormChanged) {
				alert("검색 조건이 변경되었습니다. 검색 후 진행해 주세요.")
				return;
			}
			
			let pageNum;
			
			// 첫번째 페이지로 이동
			if($(this).attr("id") == "first_page") {
				pageNum = 1;
			
			} else if($(this).attr("id") == "prev_page"){ // 이전 페이지로 이동
				pageNum = currentPageNum - 1;
				
			} else if($(this).attr("id") == "next_page") { // 다음 페이지로 이동
				pageNum = currentPageNum + 1;
			
			} else if($(this).attr("id") == "last_page") { // 마지막 페이지로 이동
				pageNum = $("div.pagination > span").text();
			}
			
			currentPageNum = pageNum;
			loadList(pageNum);
		});
		
		// 페이지 입력란에서 Enter키 클릭
		$("div.pagination > input[type=number]").on("keydown", function(event) {
			if(event.keyCode === 13) {
				// 검색 조건이 변경된 경우 -> 페이지 이동 제한
				if(isFormChanged) {
					alert("검색 조건이 변경되었습니다. 검색 후 진행해 주세요.")
					return;
				}
				
				let pageNum = Number($(this).val());
				let totalPageCount = Number($("div.pagination > span").text());
				
				// 이동 가능한 페이지 범위인 경우
				if(pageNum >= 1 && pageNum <= totalPageCount) {
					currentPageNum = pageNum;
					loadList(pageNum);
				}
				
			}
		});
		
		// 리스트 불러오기
		function loadList(pageNum) {
			$.ajax({
				url: "/notice/load_list_process",
				type: "POST",
				data: $("#frm_search").serialize() + "&page_num=" + pageNum,
				dataType: 'json',
				success: function(data) {
					//console.log(data);
					
					let content = "";
					
					if(data.list.length == 0) {
						content = "<tr><td colspan='10'>데이터가 없습니다.</td></tr>";
					}
					
					$.each(data.list, function(index, item) { // 데이터 = item
						content += "<tr>"
									+ "<td><input type='checkbox' name='no' value=" + item.no + "></td>"
									+ "<td>" + (data.startRow + index)  + "</td>"
									+ "<td><span class='pin ";
						
						if(item.is_pinned == 1) content += "pinned";
						
						content += "'>📌</span></td>"
									+ "<td>" + item.no  + "</td>"
									+ "<td><a href='/notice/view?no=" + item.no + "'>" + item.title  + "</td>"
									+ "<td>" + item.post_date  + "</td>"
									+ "<td>" + item.author  + "</td>"
									+ "<td>" + item.views  + "</td>"
									+ "<td>";
									
						if(item.is_hidden == 0) content += "표시";
						else content += "숨김";
						
						content += "</td>"
									+ "<td><input type='button' ";
						
						if(item.is_pinned == 0) content += "id='single_pin' value='고정' ";
						else content += "id='single_unpin' value='고정 해제' ";
						
						content += "data-no=" + item.no + ">"
									+ "<input type='button' ";
						
						if(item.is_hidden == 0) content += "id='single_hide' value='숨김' ";
						else content += "id='single_display' value='숨김 해제' ";
						
						content += "data-no=" + item.no + ">"
									+ "</td>"
									+ "</tr>";
					});
					
					$("div.list > table > tbody").html(content);
					$("div.pagination > input[type=number]").val(data.pageNum);	// 현재 페이지
					$("div.pagination > span").text(data.totalPageCount);		// 전체 페이지 수
					$("#select_all").prop("checked", false);					// 전체 선택 체크 해제
					
					checkPageMoveButton();
				}
			});
			
		}
		
		// 페이지네이션 버튼 처리
		function checkPageMoveButton() {
			let currentPageNum = Number($("div.pagination > input[type=number]").val());
			let totalPageCount = Number($("div.pagination > span").text());
			
			// 1페이지를 보고 있는 경우 이전 페이지로 이동하는 버튼 비활성화
			if(currentPageNum == 1) {
				$("div.pagination > .before").attr("disabled", true);
				
			} else {
				$("div.pagination > .before").attr("disabled", false);
			}
			
			// 마지막 페이지를 보고 있는 경우 다음 페이지로 이동하는 버튼 비활성화
			if(currentPageNum == totalPageCount) {
				$("div.pagination > .after").attr("disabled", true);
			
			} else {
				$("div.pagination > .after").attr("disabled", false);
			}
		}
	});
	</script>
</body>
</html>