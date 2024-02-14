<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>배달 정보</title>
<link rel="stylesheet" href="/css/reset.css">
<link rel="stylesheet" href="/css/style.css">
</head>
<body>
	<%@include file="/WEB-INF/header.jsp" %>
	<h1>배달 정보</h1>
	<form action="/deliverymgr/update" method="POST">
	<table border="1" style="width: 800px; height: 300px; margin: auto;">
		<tr>
			<th>번호</th>
			<td>${vo.no}
				<input id="no" name="no" type="text" value="${vo.no}" hidden="true">
			</td>
			<th>배달일</th>
			<td><span id="olddata1">${vo.due_date}</span>
				<input id="due_date" type="date" name="due_date" hidden="true" value="${vo.due_date}">
			</td>
			<th>배달 상태</th>
			<td colspan="3"><span id="olddata2">${vo.d_status}</span>
				<select id="d_status" name="d_status" hidden="true">
    				<option value="">배달 상태</option>
    				<option value="0">미완료</option>
    				<option value="1">완료</option>
				</select>
			</td>
		</tr>
		<tr>
			<th>고객 아이디</th>
			<td>${vo.customer_id}
				<input id="customer_id" name="customer_id" type="text" value="${vo.customer_id}" hidden="true">
			</td>
			<th>고객 이름</th>
			<td>${vo.customer_name}</td>
			<th>고객 연락처</th>
			<td>${vo.customer_tel}</td>
			<th>고객 상태</th>
			<td><span id="olddata3">${vo.customer_status}</span>
				<select id="customer_status" name="customer_status" hidden="true">
    				<option value="">고객 상태</option>
    				<option value="0">양호</option>
    				<option value="1">주의</option>
    				<option value="2">위험</option>
				</select>
			</td>
		</tr>
		<tr>
			<th>담당자 아이디</th>
			<td>${vo.delivery_man_id}
				<input id="delivery_man_id" name="delivery_man_id" type="text" value="${vo.delivery_man_id}" hidden="true">
			</td>
			<th>배송지</th>
			<td colspan="5">${vo.address}</td>
		</tr>
	</table>
	<br>
	<div style="text-align: center;">
		<input type="button" id="backbtn" onclick="history.back()" value='뒤로'>
		<input type="button" id="cancelbtn" onclick="location.reload()" hidden="true" value='취소'>
		<input type="button" id="updatebtn" onclick="update()" value='수정'>
		<input type="submit" id="submitbtn" hidden="true" value='저장'>
	</div>
	</form>
	<%@include file="/WEB-INF/footer.jsp" %>
</body>
<script>
	function update() {
		document.getElementById('due_date').hidden=false;
		document.getElementById('d_status').hidden=false;
		document.getElementById('customer_status').hidden=false;
		document.getElementById('backbtn').hidden=true;
		document.getElementById('updatebtn').hidden=true;
		document.getElementById('cancelbtn').hidden=false;
		document.getElementById('submitbtn').hidden=false;
		document.getElementById('olddata1').innerHTML='';
		document.getElementById('olddata2').innerHTML='';
		document.getElementById('olddata3').innerHTML='';
	}
</script>
</html>