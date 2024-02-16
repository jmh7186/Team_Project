<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>배달 관리</title>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<link rel="stylesheet" href="/css/reset.css">
<link rel="stylesheet" href="/css/style.css">
</head>
<body>
	<%@include file="/WEB-INF/header.jsp" %>
	<h1>배달 조회</h1><hr>
	<form id="form" action="/deliverymgr" method="POST">
	<table border="1" style="margin: auto">
		<tr>
			<th>번호</th><td><input type="text" name="no" value="${searchdetail.no}"></td>
			<th>배달 상태</th><td><select id="d_status" name="d_status">
    								<option value="">전체</option>
    								<option value="0">미완료</option>
    								<option value="1">완료</option>
								</select></td>
			<th>고객 상태</th><td><select id="customer_status" name="customer_status">
    								<option value="">전체</option>
    								<option value="0">양호</option>
    								<option value="1">주의</option>
    								<option value="2">위험</option>
								</select></td>
		</tr>
		<tr >
			<th>배달일</th><td colspan="5"><input id="startdate" type="date" name="startdate"> ~ <input id="enddate" type="date" name="enddate">
			<input type="button" onclick="today()" value="당일">
			<input type="button" onclick="week()" value="일주일">
			<input type="button" onclick="month()" value="1개월">
			</td>
		</tr>
		<tr>
			<th>고객 아이디</th><td><input type="text" name="customer_id" value="${searchdetail.customer_id}"></td>
			<th>고객 이름</th><td><input type="text" name="customer_name" value="${searchdetail.customer_name}"></td>
			<th>고객 연락처</th><td><input type="text" name="customer_tel" value="${searchdetail.customer_tel}"></td>
		</tr>
		<tr>
			<th>담당자 아이디</th><td><input type="text" name="delivery_man_id" value="${searchdetail.delivery_man_id}"></td>
			<th>배송지</th><td colspan="3"><input type="text" name="address" value="${searchdetail.address}"></td>
		</tr>
	</table>
	<div style="text-align:center;">
		<input type="text" hidden="true" id="page" name="page" value="${curpage}">
		<input type="button" onclick="movetopage(1)" style="display: inline-block;" value="조회">
	</div>
	</form>
	<hr>
	<table border="1" style="margin: auto" id="dTable">
		<tr>
			<th>No</th>
			<th>번호</th>
			<th>배달일</th>
			<th>배달 상태</th>
			<th>고객 상태</th>
			<th>고객 아이디</th>
			<th>고객 이름</th>
			<th>고객 연락처</th>
			<th>담당자 아이디</th>
		</tr>
		<c:forEach var="list" items="${dlvlist}" varStatus="s">
			<tr>
				<td>${50*(curpage-1)+s.count}</td>
				<td><a href="/deliverymgr/detail/${list.no}">${list.no}</a></td>
				<td>${list.due_date}</td>
				<td>${list.d_status}</td>
				<td>${list.customer_status}</td>
				<td>${list.customer_id}</td>
				<td>${list.customer_name}</td>
				<td>${list.customer_tel}</td>
				<td>${list.delivery_man_id}</td>
			</tr>
		</c:forEach>
		<c:if test="${empty dlvlist}">
			<tr>
				<td colspan="9">
					검색 결과가 없습니다.
				</td>
			</tr>
		</c:if>
	</table>
	<c:if test="${not empty dlvlist}">
	<div style="text-align: center">
		<c:if test="${curpage>1}">
			<button onclick="movetopage(1)">&lt;&lt;</button>
			<button onclick="movetopage(${curpage-1})">&lt;</button>
		</c:if>
		<span><input id="typepage" type="number" value="${curpage}" style="width: 40px; text-align: center;"> / <span id="maxpage">${maxpage}</span></span>
		<c:if test="${curpage<maxpage}">
			<button onclick="movetopage(${curpage+1})">&gt;</button>
			<button onclick="movetopage(${maxpage})">&gt;&gt;</button>
		</c:if>
	</div>
	</c:if>
	<%@include file="/WEB-INF/footer.jsp" %>
</body>
<script>
	if(${not empty startdate}) {
		document.getElementById('startdate').value = '${startdate}';
	}
	if(${not empty enddate}) {
		document.getElementById('enddate').value = '${enddate}';
	}
	
 	typepage = document.getElementById('typepage');
 	if(typepage) {
 		typepage.addEventListener("keyup",(event)=> {
 			if(event.keyCode==13) {
 				movetopage(typepage.value);
 			}
 		});
	}

 	if(${not empty searchdetail.customer_status}) {
 		customer_status = document.getElementById('customer_status');
 		for(i=0; i<customer_status.options.length; i++) {
 			if(customer_status.options[i].value == '${searchdetail.customer_status}') {
 				customer_status.options[i].selected = true;
 			}
 		}
 	}
 	
 	if(${not empty searchdetail.d_status}) {
 		d_status = document.getElementById('d_status');
 		for(i=0; i<d_status.options.length; i++) {
 			if(d_status.options[i].value == '${searchdetail.d_status}') {
 				d_status.options[i].selected = true;
 			}
 		}
 	}
	
 	function movetopage(topage) {
 		document.getElementById('page').value = topage;
 		document.getElementById('form').submit();
 	}
 	
	function today() {
		document.getElementById('startdate').value = new Date().toISOString().substring(0, 10);
		document.getElementById('enddate').value = new Date().toISOString().substring(0, 10);
	}
	
	function week() {
		date = new Date();
		document.getElementById('enddate').value = date.toISOString().substring(0, 10);
		
		date.setDate(date.getDate() - 7);
		document.getElementById('startdate').value = date.toISOString().substring(0, 10);
	}
	
	function month() {
		date = new Date();
		document.getElementById('enddate').value = date.toISOString().substring(0, 10);
		
		date.setMonth(date.getMonth() - 1);
		document.getElementById('startdate').value = date.toISOString().substring(0, 10);
	}
</script>
</html>