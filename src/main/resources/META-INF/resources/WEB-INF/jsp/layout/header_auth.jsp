<!-- 홈페이지, 로그인/회원가입용 헤더 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<header id="mainHeader">
    <div class="logo" onclick="location.href='/'">APARTNERS</div>
    
    <nav class="nav-container">
        <div class="nav-column">
            <a href="#intro">아파트 소개</a>
            <ul class="sub-menu">
                <li><a href="#intro">단지배치도</a></li>
                <li><a href="#guide">세대안내</a></li>
                <li><a href="#plan">평면도</a></li>
            </ul>
        </div>
        <div class="nav-column">
            <a href="#board">게시판</a>
            <ul class="sub-menu">
                <li><a href="/board/free_list">자유게시판</a></li>
                <li><a href="/board/anon_list">익명게시판</a></li>
                <li><a href="/board/comp_list">민원게시판</a></li>
                <li><a href="/board/report_pop">어린이집</a></li>
            </ul>
        </div>
        <div class="nav-column">
            <a href="#facility">커뮤니티 시설</a>
            <ul class="sub-menu">
                <li><a href="/facility/info_gym">헬스장</a></li>
                <li><a href="/facility/info_poll">수영장</a></li>
                <li><a href="/facility/info_golf">스크린골프</a></li>
                <li><a href="/facility/info_guest">게스트하우스</a></li>
            </ul>
        </div>
        <div class="nav-column">
            <a href="#">주차시설</a>
            <ul class="sub-menu">
                <li><a href="#">세대차량 등록</a></li>
                <li><a href="#">방문차량 등록</a></li>
            </ul>
        </div>
        <div class="nav-column">
            <a href="#reservation">예약 및 관리</a>
            <ul class="sub-menu">
                <li><a href="/reservation/fac_book">시설 예약/신청</a></li>
                <li><a href="/reservation/my_list">예약/수강 내역</a></li>
            </ul>
        </div>
        <div class="nav-column">
            <a href="#">소식</a>
            <ul class="sub-menu">
                <li><a href="#">공지사항</a></li>
             </ul>
        </div>
    </nav>

	<div class="nav-right">
	    <a href="/member/login">로그인</a>
	    <span>|</span>
	    <a href="/member/signup">회원가입</a>
	</div>
</header>