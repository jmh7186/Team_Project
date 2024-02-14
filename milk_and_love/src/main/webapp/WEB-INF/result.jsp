<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결과 전송 중</title>
<script>
	if(${kind=='로그인'}) {
		if(${result==0}) {
			alert('로그인에 실패했습니다.');
			location.href='/';
		}else if(${result==1}) {
			location.href='/delivery_man/list';
		}
	}
	
	if(${kind=="배달수정"}) {
		if(${result==0}) {
			alert('수정 실패');
			history.back();
		}else if(${result==1}) {
			alert('수정 성공');
			location.href='/deliverymgr';
		}
	}
</script>
</head>
</html>