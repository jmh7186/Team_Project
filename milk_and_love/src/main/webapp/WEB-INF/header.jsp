<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!-- header -->


<div id="header">
	<!-- 로고 -->
	<h1 id="logo"></h1>
	<!-- // 로고 -->
	
	<!-- GNB -->
	<div class="gnb_wrap">
		<ul>
			<li>${sessionScope.id}님</li>
			<li><a href="/logout">로그아웃</a></li>
		</ul>
	</div>
	<!-- // GNB -->
	
	<!-- SUB GNB -->
	<div class="sub_gnb_wrap">
		<ul>
			<li>
				배달원 관리
				<ul>
					<li><a href="/delivery_man/list">배달원 조회</a></li>
					<li><a href="/delivery_man/join">신규 배달원 등록</a></li>
				</ul>
			</li>
			<li>
				배달 관리
				<ul>
					<li><a href="/deliverymgr">배달 조회</a></li>
				</ul>
			</li>
			<li>
				고객 관리
				<ul>
					<li><a href="/customer/list">고객 조회</a></li>
					<li><a href="/customer/join">신규 고객 등록</a></li>
				</ul>
			</li>
			<li>1:1 문의</li>
			<li>
				공지사항
				<ul>
					<li><a href="/notice/list">공지사항 목록</a></li>
					<li><a href="/notice/post">공지사항 작성</a></li>
				</ul>
			</li>
		</ul>
	</div>
	<!-- // SUB GNB -->
</div>
<!-- // header -->