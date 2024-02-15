<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 정보</title>
<link rel="stylesheet" href="/css/reset.css">
<link rel="stylesheet" href="/css/style.css">
</head>
<body>
	<%@include file="/WEB-INF/header.jsp" %>
	<h1>관리자 정보</h1><hr>
	<form action="/mypage/update" method="POST">
	<table border="1" style="margin: auto; width: 600px; height: 400px;">
		<tr>
			<th>아이디<br><sup style="color: red">*변경불가</sup></th>
			<td>
				<input type="text" value="${vo.id}" style="border: 0; background-color: white;" disabled="disabled">
				<input type="text" name="id" value="${vo.id}" hidden="true">
			</td>
		</tr>
		<tr>
			<th>이름</th>
			<td><input id="name" name="name" type="text" value="${vo.name}" style="border: 0; background-color: white;" disabled="disabled"></td>
		</tr>
		<tr>
			<th>연락처</th>
			<td><input id="tel" name="tel" type="text" value="${vo.tel}" style="border: 0; background-color: white;" disabled="disabled"></td>
		</tr>
		<tr>
			<th>현재 비밀번호</th>
			<td>
				<input id="pw" name="pw" type="password" value="${vo.pw}" style="border: 0; background-color: white;" disabled="disabled"><br>
				<input type="button" value="비밀번호 변경" onclick="updatepw()">
			</td>
		</tr>
	</table>
	<br>
	<div style="text-align: center;">
		<input id="backbtn" type="button" value="뒤로" onclick="history.back()">
		<input id="cancelbtn" type="button" value="취소" hidden="true" onclick="location.reload()">
		<input id="updatebtn" type="button" value="수정" onclick="update()">
		<input id="savebtn" type="submit" value="저장" hidden="true">
	</div>
	</form>
	<%@include file="/WEB-INF/footer.jsp" %>
</body>
<script>
	function update() {
		document.getElementById('name').disabled=false;
		document.getElementById('tel').disabled=false;
		document.getElementById('name').style='';
		document.getElementById('tel').style='';
		
		document.getElementById('backbtn').hidden=true;
		document.getElementById('updatebtn').hidden=true;
		document.getElementById('cancelbtn').hidden=false;
		document.getElementById('savebtn').hidden=false;
	}
	
	function updatepw() {
		popup = window.open("/updatepw", "pop", "width=700,height=400,history=no,resizable=no,status=no,scrollbars=yes,menubar=no,location=no");
	}
</script>
</html>