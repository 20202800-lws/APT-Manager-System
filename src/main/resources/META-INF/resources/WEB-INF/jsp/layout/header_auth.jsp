<!-- 홈페이지, 로그인/회원가입용 헤더 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
            <a href="#">게시판</a>
            <ul class="sub-menu">
                <li><a href="#">자유게시판</a></li>
                <li><a href="#">익명게시판</a></li>
                <li><a href="#">민원게시판</a></li>
                <li><a href="#">어린이집</a></li>
            </ul>
        </div>
        <div class="nav-column">
            <a href="#">커뮤니티 시설</a>
            <ul class="sub-menu">
                <li><a href="#">헬스장</a></li>
                <li><a href="#">수영장</a></li>
                <li><a href="#">스크린골프</a></li>
                <li><a href="#">게스트하우스</a></li>
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
            <a href="#">예약 및 관리</a>
            <ul class="sub-menu">
                <li><a href="#">시설 예약/신청</a></li>
                <li><a href="#">예약/수강 내역</a></li>
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
        <c:choose>
            <%-- 1. 로그인 했을 때 --%>
            <c:when test="${not empty sessionScope.loginMember}">
                <span style="font-weight: bold; margin-right: 10px;">
                    ${sessionScope.loginMember.dong}동 ${sessionScope.loginMember.ho}호 ${sessionScope.loginMember.realName}님 환영합니다.
                </span>
                
                <c:if test="${sessionScope.loginMember.userRole == 'ADMIN'}">
                    <a href="/admin/main">관리자 페이지</a>
                </c:if>
                <c:if test="${sessionScope.loginMember.userRole != 'ADMIN'}">
                    <a href="/member/mypage">마이페이지</a>
                </c:if>
                
                <span>|</span>
                <a href="/member/logout">로그아웃</a>
            </c:when>

            <%-- 2. 로그인 안 했을 때 (기존 코드) --%>
            <c:otherwise>
                <a href="/member/login">로그인</a>
                <span>|</span>
                <a href="/member/signup">회원가입</a>
            </c:otherwise>
        </c:choose>
    </div>
</header>