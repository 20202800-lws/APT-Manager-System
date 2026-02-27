<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${not empty msg}">
    <script>
        // 페이지가 열리자마자 바로 알림창을 띄웁니다.
        alert('${msg}');
    </script>
</c:if>

<header id="mainHeader">
    <div class="logo" onclick="location.href='/'">
        <img src="/images/logo/text_logo.png" alt="APARTNERS 로고">
    </div>

    <nav class="nav-container">
        <div class="nav-column">
            <a href="/intro/layout">아파트 소개</a>
            <ul class="sub-menu">
                <li><a href="/intro/layout">단지배치도</a></li>
                <li><a href="/intro/guide">단지안내</a></li>
                <li><a href="/intro/floor_plan">평면도</a></li>
            </ul>
        </div>
        
        <div class="nav-column">
            <a href="/board/free">게시판</a>
            <ul class="sub-menu">
                <li><a href="/board/free">자유게시판</a></li>
                <li><a href="/board/anon">익명게시판</a></li>
                <li><a href="/board/comp">민원게시판</a></li>
                <li><a href="/daycare/notice">어린이집</a></li>
            </ul>
        </div>
        
        <div class="nav-column">
            <a href="/facility/info_gym">커뮤니티 시설</a>
            <ul class="sub-menu">
                <li><a href="/facility/info_gym">헬스장</a></li>
                <li><a href="/facility/info_pool">수영장</a></li>
                <li><a href="/facility/info_golf">스크린골프</a></li>
                <li><a href="/facility/info_guest">게스트하우스</a></li>
            </ul>
        </div>
        
        <div class="nav-column">
            <a href="/parking/my_car">주차시설</a>
            <ul class="sub-menu">
                <li><a href="/parking/my_car">세대차량 등록</a></li>
                <li><a href="/parking/visit_car">방문차량 등록</a></li>
            </ul>
        </div>
        
        <div class="nav-column">
            <a href="/reservation/fac_book">예약 및 관리</a>
            <ul class="sub-menu">
                <li><a href="/reservation/fac_book">시설 예약/신청</a></li>
                <li><a href="/reservation/my_list">예약/수강 내역</a></li>
            </ul>
        </div>
        
        <div class="nav-column">
            <a href="/notice/notice_list">소식</a>
            <ul class="sub-menu">
                <li><a href="/notice/notice_list">공지사항</a></li>
            </ul>
        </div>
    </nav>

    <div class="nav-right">
        <c:choose>
            <%-- 1. 로그인 했을 때 --%>
            <c:when test="${not empty sessionScope.loginMember}">
                <span style="font-weight: bold; margin-right: 10px;">
                    ${sessionScope.loginMember.dong}동 ${sessionScope.loginMember.ho}호
                    ${sessionScope.loginMember.realName}님 환영합니다.
                </span>

                <c:if test="${sessionScope.loginMember.userRole == 'ADMIN'}">
                    <a href="/admin/main">관리자 페이지</a>
                </c:if>
                <c:if test="${sessionScope.loginMember.userRole != 'ADMIN'}">
                    <a href="/mypage/info_view">마이페이지</a>
                </c:if>

                <span>|</span>
                <a href="/member/logout">로그아웃</a>
            </c:when>

            <%-- 2. 로그인 안 했을 때 --%>
            <c:otherwise>
                <a href="/member/login">로그인</a>
                <span>|</span>
                <a href="/member/signup">회원가입</a>
            </c:otherwise>
        </c:choose>
    </div>
</header>