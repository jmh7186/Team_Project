<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>신규 배달원 등록</title>
	
	<link rel="stylesheet" href="/css/reset.css">
	<link rel="stylesheet" href="/css/style.css">
	<link rel="stylesheet" href="/css/delivery_man.css">
</head>
<body>
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
	 	
		$(document).ready(function() {
			// 전화번호 정규식
		    var phoneReg = /^010\d{8}$/;
			
		 	//한글 이름 정규식
		    var nameReg = /^[가-힣]{2,5}$/;

			// 초기화 버튼이 눌렸을때 실행
			$("#reset_btn").click(function(e) {
				$("form input, form select").each(function() {
        			$(this).val("");
        		})
			})
			
			
			// 셀렉터에 옵션들 추가
		    $.ajax({
				url: "/load_area1_list_process",
				type: "POST",
				dataType: 'json',
				success: function(data) {
					//console.log(data);
					
					let content = "<option value=''>----- 시도 선택 -----</option>";
					$.each(data, function(index, item) {
						let code = item.CODE.slice(0, 2);
						content += `<option data-code=\${code} value=\${item.AREA}>\${item.AREA}</option>`;
					});
					$("select[name=area1]").html(content);
				}
			});
			
			$("select[name=area1]").on("change", function() {
				let area1_code = $(this).find("option:selected").data("code");
				
				$("select[name=area3]").html("<option value='none'>----- 읍면동 선택 -----</option>");
				
				$.ajax({
					url: "/load_area2_list_process",
					type: "POST",
					data: "area1_code=" + area1_code,
					dataType: 'json',
					success: function(data) {
						//console.log(data);
						
						let content = "<option value=''>----- 시군구 선택 -----</option>";
						$.each(data, function(index, item) {
							let code = item.CODE.slice(0, 4);
							content += `<option data-code=\${code} value=\${item.AREA}>\${item.AREA}</option>`;
						});
						$("select[name=area2]").html(content);
					}
				});
			});
			
			$("select[name=area2]").on("change", function() {
				let area2_code = $(this).find("option:selected").data("code");
				
				$.ajax({
					url: "/load_area3_list_process",
					type: "POST",
					data: "area2_code=" + area2_code,
					dataType: 'json',
					success: function(data) {
						//console.log(data);
						
						let content = "<option value=''>----- 읍면동 선택 -----</option>";
						$.each(data, function(index, item) {
							content += `<option data-code=\${item.CODE} value=\${item.AREA}>\${item.AREA}</option>`;
						});
						$("select[name=area3]").html(content);
					}
				});
			});
			
			
			
			// 확인 버튼이 눌렸을때 실행
			$("#confirm_btn").click(function(e) {
				
				var joinDates={};
				
				//from태그 밑의 모든 input과 select의 값을 가져와 검사함
				$("form input, form select").each(function() {
					if (this.id == 'detail_address' || this.id == 'area3') {
						if ($(this).val()) {
							joinDates[this.id] = $(this).val();
						}
					} else {
						if (!$(this).val()) {
							alert("필수 입력항목이 비어있습니다.");
							$(this).focus();
							return false;
						} else {
							joinDates[this.id] = $(this).val();
						}
					}
					
			    });
				
				// 전화번호 입력란 대한 검증
				if (!phoneReg.test($('#tel').val())) {
					alert("전화번호 양식을 확인해주세요.");
		            $('#tel').focus();
		            return;
		        }
				
				// 이름 입력란에 대한 검증
		        if (!nameReg.test($('#name').val())) {
		        	alert("이름을 확인해주세요.");
		            $('#name').focus();
		            return;
		        }
				
				$.ajax({
			        url: '/new_delivery_man',
			        type: 'POST',
			        data: JSON.stringify(joinDates),
			        contentType: "application/json",
			        success: function(data) {
			        	if(data == 1){
			        		alert("추가가 완료되었습니다.");
			        		$("form input, form select").each(function() {
			        			$(this).val("");
			        		
			        		})
			        		} else{
			        		alert("서버에 문제가 생겼습니다 관리자에게 이야기해주세요.");
			        	}
			        }
				})
				
				
			})
			
			
			//다음주소API자바 스크립트
		    $("#address_btn").click(function DaumPostcode() {
		    	var guideTextBox = $("#guide");
		        new daum.Postcode({
		            oncomplete: function(data) {
		                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
		
		                // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
		                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
		                var roadAddr = data.roadAddress; // 도로명 주소 변수
		                var extraRoadAddr = ''; // 참고 항목 변수
		
		                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
		                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
		                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
		                    extraRoadAddr += data.bname;
		                }
		                // 건물명이 있고, 공동주택일 경우 추가한다.
		                if(data.buildingName !== '' && data.apartment === 'Y'){
		                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
		                }
		                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
		                if(extraRoadAddr !== ''){
		                    extraRoadAddr = ' (' + extraRoadAddr + ')';
		                }
		
		                // 우편번호와 주소 정보를 해당 필드에 넣는다.
		                $('#post_code').val(data.zonecode);
		                $("#road_address").val(roadAddr);
		                
		                var guideTextBox = document.getElementById("guide");
		                // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
		                if(data.autoRoadAddress) {
		                    var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
		                    guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
		                    guideTextBox.style.display = 'block';
		                    
		                } else {
		                    guideTextBox.innerHTML = '';
		                    guideTextBox.style.display = 'none';
		                }
		            }
		        }).open();
		    })
		})
	</script>
	
	<%@include file="/WEB-INF/header.jsp" %>
	
	<!-- 배달원 가입 -->
	<div id="delivery_man_wrap">
		<h2>신규 배달원 등록</h2>
		<hr>
		<!-- 배달원 가입 세션 -->
		<section id="delivery_man_join">
		<!-- 배달원 가입 테이블-->
		<form method="post">
				<table id="delivery_man_join_tbl">
					<tbody>
						<tr>
							<th class="cal">이름</th>
							<td class="row"><input type="text" id="name" name="name" maxlength='5'></td>
						</tr>
						<tr>
							<th class="cal">연락처</th>
							<td class="row"><input type="number" id="tel" name="tel" maxlength='11'></td>
						</tr>
						<tr>
							<th class="cal" rowspan="3">거주지</th>
							<td class="row">
								<input type="text" id="post_code" name="post_num"readonly>
								<button type="button" id="address_btn">찾기</button>
							</td>
						</tr>
						<tr>
							<td class="row">
								<input type="text" id="road_address" name="road_address" readonly>
							</td>
						</tr>
						<tr>
							<td class="row">
								<input type="text" id="detail_address" name="detail_address">
							</td>
						</tr>
						<tr>
							<th class="cal">담당지</th>
							<td class="row">
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
						</tr>
						<tr>
							<th class="cal">초기 비밀번호</th>
							<td class="row"><input type="text" id="pw" name="pw" maxlength='20'></td>
						</tr>
					</tbody>
				</table>
			</form>
			<!-- /배달원 가입 테이블 -->
			
			<!-- 배달원 가입 버튼 -->
			<div id="join_btns">
				<button type="button" id="reset_btn">초기화</button>
				<button type="button" id="confirm_btn">확인</button>
			</div>
			<!-- /배달원 가입 버튼 -->
	
		</section>
		<!-- /배달원 가입 세션 -->
	</div>
	<!-- /배달원 가입 -->
	<%@include file="/WEB-INF/footer.jsp" %>
</body>
</html>