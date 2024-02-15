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
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script src="/js/daum_postcode.js"></script>
	<script type="module" src="/js/delivery_man/view.js"></script>
</head>
<body>
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
							<c:if test="${vo.status != 2}">
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
						    		</c:choose>
								</select>
							</c:if>
							
							<c:if test="${vo.status == 2}">
								<input type="hidden" id="status" value="2">
								<p>만료</p>
							</c:if>
							
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
								<input type="hidden" id="vo_arae1" value="${vo.area1}">
								<select id="area1" name="area1">
									<option value="">----- 시도 선택 -----</option>
								</select>
								<input type="hidden" id="vo_arae2" value="${vo.area2}">
								<select id="area2" name="area2">
									<option value="">----- 시군구 선택 -----</option>
								</select>
								<input type="hidden" id="vo_arae3" value="${vo.area3}">
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