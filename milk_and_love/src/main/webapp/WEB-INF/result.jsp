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
	
	if(${kind=="listnull"}) {
		alert('정보를 찾을 수 없습니다.');
		history.back();
	}
	
	if(${kind=="mgrupdate"}) {
		if(${result==0}) {
			alert('수정에 실패했습니다.');
			history.back();
		}else if(${result==1}) {
			location.href='/mypage';
		}
	}
	
	if(${kind=="updatepw"}) {
		if(${result==0}) {
			alert('수정에 실패했습니다.');
			history.back();
		}else if(${result==1}) {
			alert('비밀번호 변경을 완료했습니다.');
			opener.parent.location.reload();
			window.close();
		}else if(${result==2}) {
			alert('현재 비밀번호가 맞지 않습니다.');
			history.back();
		}
	}
</script>
</head>
</html>