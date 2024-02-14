<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>고객 정보 확인 및 수정</title>
	
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
			<h2>고객 정보 확인 및 수정</h2>
			
			<!-- 정보 -->
			<div class="info_wrap">
				<form id="frm_edit" action="/customer/edit_process" method="post" onsubmit="return false;">
					<table>
						<tbody>
							<tr>
								<th>ID</th>
								<td><input type="text" name="id" value=${vo.id} readonly></td>
							</tr>
							<tr>
								<th>계약일자</th>
								<td>${vo.join_date}</td>
							</tr>
							<tr>
								<th>상태</th>
								<td>
									<c:choose>
										<c:when test="${vo.status eq 0}">
											<input type="radio" name="status" value="0" checked>정상
											<input type="radio" name="status" value="1">해지
										</c:when>
										<c:otherwise>
											<input type="radio" name="status" value="0" disabled>정상
											<input type="radio" name="status" value="1" checked disabled>해지
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
							<c:if test="${vo.status ne 0}">
								<tr>
									<th>해지일자</th>
									<td>${vo.leave_date}</td>
								</tr>
							</c:if>
							<tr>
								<th>이름</th>
								<td><input type="text" name="name" maxlength="5" value="${vo.name}"></td>
							</tr>
							<tr>
								<th>연락처</th>
								<td><input type="number" name="tel" maxlength="11" value="${vo.tel}" oninput="numberMaxLength(this);"></td>	
							</tr>
							<tr>
								<th>주소</th>
								<td>
									<input type="text" name="post_code" id="post_code" value="${vo.post_code}" placeholder="우편번호" readonly>
									<a href="javascript:void(0);" id="search_address" role="button" onclick="daumPostcode()">검색</a>
									<br>
					  				<input type="text" name="road_address" id="road_address" value="${vo.road_address}" placeholder="도로명주소" readonly>
					  				<br>
					  				<input type="text" name="detail_address" id="detail_address" maxlength=30 value="${vo.detail_address}" placeholder="상세주소(최대 30자리)">
					  				<input type="text" name="area3" id="area3" value="${vo.area3}" readonly>
								</td>
							</tr>
							<tr>
								<th>배달 담당자</th>
								<td>
									<select name="delivery_man_id">
										<option value="none">----- 배달 담당자 선택 -----</option>
										<c:forEach var="item" items="${delivery_man_list}" varStatus="status">
											<option value='${item.ID}'<c:if test="${item.ID eq vo.delivery_man_id}">selected</c:if>>
												${item.ID} (${item.AREA})
											</option>
										</c:forEach>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
					
					<!-- 버튼 -->
					<div class="btns">
						<input type="button" value="취소" onclick="location.href='/customer/list'">
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
	
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script src="/js/daum_postcode.js"></script>
	<script src="/js/input_len_constraints.js"></script>
	<script>
	$(document).ready(function() {
		var phoneReg = /^010\d{8}$/;	// 연락처 정규표현식
		
		// 우편번호(주소) 변경 이벤트 시
		$("#post_code").on("change", function() {
			let area = $("#road_address").val().split(" ").slice(0, 2).join(" ");
			let area3 = $("#area3").val()
			
			$.ajax({
				url: "/customer/load_delivery_man_list_process",
				type: "POST",
				data: "area=" + area + "&area3=" + area3,
				dataType: 'json',
				success: function(data) {
					//console.log(data);
					
					let content = "<option value='none'>----- 배달 담당자 선택 -----</option>";
					$.each(data, function(index, item) {
						content += `<option value=\${item.ID}>\${item.ID} (\${item.AREA})</option>`;
					});
					
					$("select[name=delivery_man_id]").html(content);
				}
			});
		});
		
		// 수정 버튼 클릭 시
		$("#frm_edit input[type=submit]").on("click", function() {
			let name = $("#frm_edit input[name=name]");
			let tel = $("#frm_edit input[name=tel]");
			let post_code = $("#post_code");
			let delivery_man_id = $("#frm_edit select[name=delivery_man_id]");
			
			// 이름을 입력하지 않았을 때
			if(!name.val()) {
				alert("이름을 입력해 주세요.");
				name.focus();
				return;
			}
			
			// 연락처를 입력하지 않았을 때
			if(!tel.val()) {
				alert("연락처를 입력해 주세요.");
				tel.focus();
				return;
				
			} else if(!phoneReg.test(tel.val())) {
				alert("연락처를 올바르게 입력해 주세요.")
				tel.focus();
				return;
			}
			
			// 주소를 입력하지 않았을 때
			if(!post_code.val()) {
				alert("주소를 입력해 주세요.");
				post_code.focus();
				return;
			}
			
			// 배달원을 선택하지 않았을 때
			if(delivery_man_id.find("option:selected").val() === 'none') {
				alert("배달원을 선택해 주세요.");
				delivery_man_id.focus();
				return;
			}
			
			$.ajax({
				url: "/customer/edit_process",
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