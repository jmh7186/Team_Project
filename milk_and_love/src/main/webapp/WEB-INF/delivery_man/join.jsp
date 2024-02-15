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
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script src="/js/daum_postcode.js"></script>
	<script type="module" src="/js/delivery_man/join.js"></script>
	
</head>
<body>
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
								<button type="button" id="address_btn" onclick="daumPostcode()">찾기</button>
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