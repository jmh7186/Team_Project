<%@page import="java.time.LocalDate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<c:set var="today" value="<%=LocalDate.now().toString() %>" />

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>고객 조회</title>
	
	<link rel="stylesheet" href="/css/reset.css">
	<link rel="stylesheet" href="/css/style.css">
	<link rel="stylesheet" href="/css/customer.css">
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
</head>
<body>
	<div id="wrap">
		<%@include file="/WEB-INF/header.jsp" %>
		
		<!-- 컨테이너 -->
		<div id="container">
			<h2>고객 조회</h2>
			
			<!-- 검색 -->
			<div class="search_wrap">
				<form id="frm_search" action="/customer/load_list_process" method="post" onsubmit="return false;">
					<table>
						<tbody>
							<tr>
								<th>아이디</th>
								<td><input type="text" name="id" maxlength="10"></td>
								<th>이름</th>
								<td><input type="text" name="name" maxlength="5"></td>
								<th>연락처</th>
								<td><input type="number" name="tel" maxlength="11"></td>
							</tr>
							 
							<tr>
								<th>계약일자</th>
								<td colspan="3">
									<input type="date" name="start_date" value="${today}">
									~
									<input type="date" name="end_date" value="${today}">
									<input type="button" class="period" id="period_today" value="당일">
									<input type="button" class="period" id="period_week" value="일주일">
									<input type="button" class="period" id="period_month" value="1개월">
								</td>
								<th>상태</th>
								<td>
									<input type="radio" name="c_status" value=-1 checked>전체
									<input type="radio" name="c_status" value=0>정상
									<input type="radio" name="c_status" value=1>해지
								</td>
							</tr>
							
							<tr>
								<th>담당자 ID</th>
								<td><input type="text" name="delivery_man_id" maxlength="10"></td>
								<th>주소</th>
								<td colspan="3"><input name="address" type="text"></td>
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
					고객 ID를 클릭하면 고객 정보 확인 및 수정 페이지로 이동합니다.
				</div>
			
				<form id="frm_list" action="/customer/leave_process" method="post" onsubmit="return false;">
					<!-- 목록 -->
					<div class="list">
						<table>
							<thead>
								<tr>
									<th><input type="checkbox" id="select_all"></th>
									<th>No</th>
									<th>ID</th>
									<th>계약일자</th>
									<th>상태</th>
									<th>이름</th>
									<th>연락처</th>
									<th>담당자 ID</th>
									<th>해지일자</th>
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
											<c:if test="${item.status eq 0}">
												<input type="checkbox" name="id" value="${item.id}">
											</c:if>
										</td>
										<td>${status.count}</td>
										<td><a href="/customer/view?id=${item.id}">${item.id}</a></td>
										<td>${item.join_date}</td>
										<td>
											<c:choose>
												<c:when test="${item.status eq 0}">
													정상
												</c:when>
												<c:otherwise>
													해지
												</c:otherwise>
											</c:choose>
										</td>
										<td>${item.name}</td>
										<td>${item.tel}</td>
										<td>${item.delivery_man_id}</td>
										<td>${item.leave_date}</td>
										<td>
											<c:if test="${item.status eq 0}">
												<input type="button" id="single_leave" value="해지" data-id="${item.id}">
											</c:if>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
					<!-- // 목록 -->
					
					<!-- 버튼 -->
					<div class="btns">
						<input type="button" id="select_leave" value="선택 해지">
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
		
		// 계약일자 검색을 위한 요소에 변경 이벤트가 발생한 경우
		$("#frm_search input[type=date]").on("change", function() {
			isFormChanged = true;
		});
		
		// 계약일자 - 편의성 버튼 클릭
		$("#frm_search input.period").on("click", function() {
			isFormChanged = true;
			
			let day = new Date();
			
			// 일주일
			if($(this).attr("id") == "period_week") {
				day = new Date(day.getTime() - (7 * 24 * 60 * 60 * 1000));
			
			} else if($(this).attr("id") == "period_month") {	// 한달전
				day = new Date(day.getFullYear(), day.getMonth() - 1, day.getDate());
			}

			let start_day = day.getFullYear() + "-" + ('0' + (day.getMonth() + 1)).slice(-2) + "-" + ('0' + day.getDate()).slice(-2);
			//alert(start_day);
			
			$("#frm_search input[name=start_date]").val(start_day);
			
		});
		
		// 검색 버튼 클릭
		$("#frm_search input[type=submit]").on("click", function() {
			// 시작일자가 없으면
			if(!$("input[name=start_date]").val()) {
				alert("시작일자를 입력해 주세요.");
				$("input[name=start_date]").focus();
				return;
			}
			
			// 종료일자가 없으면
			if(!$("input[name=end_date]").val()) {
				alert("종료일자를 입력해 주세요.");
				$("input[name=end_date]").focus();
				return;
			}
			
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
		$("#select_all").on("change", function() {
			// 전체 선택된 상태
			if($(this).prop("checked")) {
				$("div.list table tbody input[type=checkbox]").prop("checked", true);	// 모든 체크박스에 체크
			
			} else { // 전체 선택 해제
				$("div.list table tbody input[type=checkbox]").prop("checked", false);	// 모든 체크박스에 체크 해제
			}
		});
		
		// 선택 해지 클릭
		$("div.btns > #select_leave").on("click", function() {	
			let checkedCount = $("div.list table tbody input[type=checkbox]:checked").length;
			
			// 체크된 항목이 0개인 경우
			if(checkedCount == 0) {
				return;
			}
			
			// 체크된 항목이 있는 경우
			leaveProcess($("#frm_list").serialize());
		});
		
		// 단일 해지 클릭
		$(document).on("click", "#single_leave", function() {
			let sendData = "id=" + $(this).data("id");
			leaveProcess(sendData);
		});
		
		// 해지 처리
		function leaveProcess(sendData) {
			$.ajax({
				url: "/customer/leave_process",
				type: "POST",
				data: sendData,
				success: function(data) {
					// 해지에 성공한 경우
					if(data != 0) {
						alert("해지 요청이 완료되었습니다.");
						loadList(currentPageNum);
						
					} else { // 해지에 실패한 경우
						alert("해지 요청에 실패하였습니다.");
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
				url: "/customer/load_list_process",
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
									+ "<td>";
						
						if(item.status == 0) content += "<input type='checkbox' name='id' value=" + item.id + ">";
						
						content += "</td>"
									+ "<td>" + (data.startRow + index)  + "</td>"
									+ "<td><a href='/customer/view?id=" + item.id + "'>" + item.id + "</a></td>"
									+ "<td>" + item.join_date + "</td>"
									+ "<td>";
						
						if(item.status == 0) content += "정상";
						else content += "해지";
						
						content += "</td>"
									+ "<td>" + item.name + "</td>"
									+ "<td>" + item.tel + "</td>"
									+ "<td>" + item.delivery_man_id + "</td>"
									+ "<td>";
									
						if(item.leave_date != null) content += item.leave_date
						
						content += "</td>"
									+ "<td>";
									
						if(item.status == 0) content += "<input type='button' id='single_leave' value='해지' data-id=" + item.id + ">"
						
						content += "</td>"
									+ "</tr>";
						
									
					});
					//console.log(content);
					
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
