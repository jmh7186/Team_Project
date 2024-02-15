<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 변경</title>
<link rel="stylesheet" href="/css/reset.css">
<link rel="stylesheet" href="/css/style.css">
</head>
<body>
	<form action="/updatepw" method="POST" onsubmit="return newpwconfirm()">
	<table border="1" style="margin: auto; width: 400px; height: 300px;">
		<tr >
			<th style="width: 150px;">현재 비밀번호</th>
			<td>
				<input type="password" id="oldpw" name="oldpw" value="">
			</td>
		</tr>
		<tr style="height: 150px;">
			<th>새로운 비밀번호</th>
			<td>
				<input type="password" id="newpw" name="newpw" value="" onmouseleave="newpwconfirm()">
				<span id="newpwalert" hidden="true"><br><sup style="color: red; font-size: 11px">8~20자 이내의 영문 대소문자, 숫자, 특수문자(!@#$*)가 모두 포함된 비밀번호여야 합니다.</sup></span>
			</td>
		</tr>
		<tr style="height: 120px;">
			<th>비밀번호 확인</th>
			<td>
				<input type="password" id="conpw" value="" onmouseleave="pwconfirm()">
				<span id="conpwalert" hidden="true"><br><sup style="color: red; font-size: 11px">비밀번호가 일치하지 않습니다.</sup></span>
			</td>
		</tr>
	</table>
	<div>
		<input type="submit" value="저장">
	</div>
	</form>
</body>
<script>
	var passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,20}$/;
	
	function newpwconfirm() {
		newpw = document.getElementById('newpw').value;
		if(!(passwordRegex.test(newpw))) {
			document.getElementById('newpwalert').hidden=false; //비밀번호 정책 위반
			return false;
		}else {
			document.getElementById('newpwalert').hidden=true
			return pwconfirm();
		}
			return false;
	}
	
	function pwconfirm() {
		newpw = document.getElementById('newpw').value;
		conpw = document.getElementById('conpw').value;
		if(newpw!=conpw) {
			document.getElementById('conpwalert').hidden=false; //비밀번호 확인 실패
			return false;
		}else {
			document.getElementById('conpwalert').hidden=true; //비밀번호 확인 실패
			return true;
		}
		return false;
	}
</script>
</html>