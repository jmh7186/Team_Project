<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>신규 고객 등록</title>
	
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
			<h2>신규 고객 등록</h2>
			
			<!-- 등록 -->
			<div class="join_wrap">
				<form id="frm_join" action="/customer/join_process" method="post" onsubmit="return false;">
					<table>
						<tbody>
							<tr>
								<th>이름</th>
								<td><input type="text" name="name" maxlength="5"></td>	
							</tr>
							<tr>
								<th>연락처</th>
								<td><input type="number" name="tel" maxlength="11" oninput="numberMaxLength(this);"></td>	
							</tr>
							<tr>
								<th>주소</th>
								<td>
									<input type="text" name="post_code" id="post_code" placeholder="우편번호" readonly>
									<a href="javascript:void(0);" id="search_address" role="button" onclick="daumPostcode()">검색</a>
									<br>
					  				<input type="text" name="road_address" id="road_address" placeholder="도로명주소" readonly>
					  				<br>
					  				<input type="text" name="detail_address" id="detail_address" maxlength=30 placeholder="상세주소(최대 30자리)">
					  				<input type="text" name="area3" id="area3" readonly>
								</td>
							</tr>
							<tr>
								<th>배달 담당자</th>
								<td>
									<select name="delivery_man_id">
										<option value="none">----- 배달 담당자 선택 -----</option>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
					
					<!-- 버튼 -->
					<div class="btns">
						<input type="button" value="취소" onclick="location.href='/customer/list'">
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
		
		// 초기화 버튼 클릭 시
		$("#frm_join input[type=reset]").on("click", function() {
			let content = "<option value='none'>----- 배달 담당자 선택 -----</option>";
			$("select[name=delivery_man_id]").html(content);
		});
		
		// 등록 버튼 클릭 시
		$("#frm_join input[type=submit]").on("click", function() {
			let name = $("#frm_join input[name=name]");
			let tel = $("#frm_join input[name=tel]");
			let post_code = $("#post_code");
			let delivery_man_id = $("#frm_join select[name=delivery_man_id]");
			
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
				url: "/customer/join_process",
				type: "POST",
				data: $("#frm_join").serialize(),
				success: function(data) {
					// 등록 성공 시
					if(data != 0){
						alert("등록이 완료되었습니다.");
						location.href="/customer/list";
						
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