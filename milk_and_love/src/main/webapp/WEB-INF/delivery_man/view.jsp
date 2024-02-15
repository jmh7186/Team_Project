<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>배달원 정보 확인 및 수정</title>
	
	<link rel="stylesheet" href="/css/reset.css">
	<link rel="stylesheet" href="/css/style.css">
	<link rel="stylesheet" href="/css/delivery_man.css">
</head>
<body>
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script src="/js/daum_postcode.js"></script>
	
	<script>
		$(document).ready(function() {
			// 전화번호 정규식
		    var phoneReg = /^010\d{8}$/;
			
		 	//한글 이름 정규식
		    var nameReg = /^[가-힣]{2,5}$/;
			
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
				
				$("select[name=area3]").html("<option value=''>----- 읍면동 선택 -----</option>");
				
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
						
						let content = "<option value='none'>----- 읍면동 선택 -----</option>";
						$.each(data, function(index, item) {
							content += `<option data-code=\${item.CODE} value=\${item.AREA}>\${item.AREA}</option>`;
						});
						$("select[name=area3]").html(content);
					}
				});
			});
			
			// 각 필드의 초기 상태를 저장
			var orginalStates = {};
			$("form input, form select").each(function() {
				orginalStates[this.id] = $(this).val();
			});
						
			//수정 버튼이 눌렸을데 실행하는 스크립튼
			$("#modify_btn").click(function(e) {
			    var isChanged = false;
				var changedStates={};
			    
				// 전화번호 입력란 대한 검증
				if (!phoneReg.test($('#tel_input').val())) {
					alert("전화번호 양식을 확인해주세요.");
		            $('#tel').focus();
		            return;
		        }
				
				// 이름 입력란에 대한 검증
		        if (!nameReg.test($('#name_input').val())) {
		        	alert("이름을 확인해주세요.");
		            $('#name').focus();
		            return;
		        }
				
			    // 각 필드의 현재 상태를 확인하고 초기 상태와 비교
			    $("form input, form select").each(function() {
			        if (orginalStates[this.id] !== $(this).val()) {
			            isChanged = true;
			            changedStates[this.id] = $(this).val();
			        }
			    });
    
			    // 하나 이상의 필드가 변경되지 않았다면 폼 전송을 막기
			    if (!isChanged) {
			        e.preventDefault();
			        alert("하나 이상 변경해야합니다.");
			        
			    } else {
			    	
			    	changedStates['id']= $("#id").text();
			    	$.ajax({
				        url: '/modify_delivery_man',
				        type: 'POST',
				        data: JSON.stringify(changedStates),
				        contentType: "application/json",
				        success: function(data) {
				        	if(data == 1){
				        		alert("변경이 완료되었습니다.");
				        	} else{
				        		alert("서버에 문제가 생겼습니다 관리자에게 이야기해주세요.");
				        	}
				        }
					})
			    }
			});
			
			// 목록 버튼 스크립트
			$("#list_btn").click(function(){
				window.location = "/delivery_man/list";
			})
			
		})
	</script>
	
	<%@include file="/WEB-INF/header.jsp" %>
	<!-- 배달원 정보 -->
	<div id="delivery_man_wrap">
		<h2>배달원 정보 확인 및 수정</h2>
		<hr>
		<!-- 배달원 정보 세션 -->
		<section id="delivery_man_info">
		<!-- 배달원 정보 테이블-->
		<form action="/delivery_man_modify" method="post">
				<table id="delivery_man_info_tbl" border="1">
					<tbody>
						<tr>
							<th class="cal">아이디</th>
							<td class="row"><p id="id">${vo.id}</p></td>
						</tr>
						<tr>
							<th class="cal">상태</th>
							<td class="row">
								<select id="status_select" name="status">
									<c:choose>
						        		<c:when test="${vo.status == 0}">
						        			<option value="0" selected="selected">대기</option>
						        			<option value="1">유효</option>
						        			<option value="2">만료</option>
						        		</c:when>
						   
						        		<c:when test="${vo.status == 1}">
						        			<option value="0">대기</option>
						        			<option value="1" selected="selected">유효</option>
						        			<option value="2">만료</option>
						        		</c:when>	
						        							   
						        		<c:when test="${vo.status == 2}">
						        			<option value="0">대기</option>
						        			<option value="1">유효</option>
						        			<option value="2" selected="selected">만료</option>
						        		</c:when>
						    		</c:choose>
								</select>

							</td>
						</tr>
						<tr>
							<th class="cal">이름</th>
							<td class="row"><input type="text" id="name_input" name="name" value="${vo.name}"></td>
						</tr>
						<tr>
							<th class="cal">연락처</th>
							<td class="row"><input type="text" id="tel_input" name="tel" value="${vo.tel}"></td>
						</tr>
						<tr>
							<th class="cal" rowspan="3">거주지</th>
							<td class="row">
								<input type="text" id="post_code" name="post_code" value="${vo.post_code}" readonly>
								<button type="button" id="address_btn" onclick="daumPostcode()">찾기</button>
							</td>
						
						<tr>
							<td>
								<input type="text" id="road_address" name="road_address" value="${vo.road_address}" readonly>
							</td>
						</tr>
						
						<tr>
							<td>
								<input type="text" id="detail_address" name="detail_address" value="${vo.detail_address}">
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
							<th class="cal">비밀번호 초기화</th>
							<td class="row"><input type="text" id="pw" name="pw"></td>
						</tr>
					</tbody>
				</table>
				
			</form>
			<!-- /배달원 정보 테이블 -->
			
			<!-- 배달원 수정 버튼 -->
			<div id="join_btns">
				<button type="button" id="list_btn">목록</button>
				<button type="button" id="modify_btn">수정</button>
			</div>
			<!-- /배달원 수정 버튼 -->
			
		</section>
		<!-- /배달원 정보 세션 -->

	</div>
	<!-- /배달원 정보 -->
	<%@include file="/WEB-INF/footer.jsp" %>
</body>
</html>