<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link href="/css/login.css" rel="stylesheet" type="text/css" />
<meta charset="UTF-8">
<title>관리자 페이지 로그인</title>
</head>
<body>
	<form id="loginform" action="/loginproc" method="POST" onsubmit="return loginsubmit()">
		<img src="/img/logo.png"><br>
		<ul>
			<li><input id="id" name="id" type="text" value="${rememberid}"></li>
			<li><input id="pw" name="pw" type="password"></li>
			<li><button>로그인</button></li>
			<li id="checkbox"><input id="rememberid" name="rememberid" type="checkbox"><span>아이디 저장</span></li>
		</ul>
	</form>
</body>
<script>
	if(${not empty rememberid}) {
		document.getElementById('rememberid').checked=true;
	}
	
	function loginsubmit() {
		id = document.getElementById('id').value;
		pw = document.getElementById('pw').value;
		
		if(!(id==""||pw=="")) {
			return true;
		}
		alert("아이디/비밀번호를 입력하세요.");
		return false;
	}
</script>
</html>