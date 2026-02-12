<!-- 관리자용 좌측 메뉴 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* =========================================
       1. 사이드바 전용 CSS
       ========================================= */
    :root {
        --sidebar-bg: #262148;       /* 짙은 보라색 배경 */
        --sidebar-hover: #3D375E;    /* 호버 색상 */
        --sidebar-active: #7C4DFF;   /* 활성화(포인트) 색상 */
        --text-color: #E0E0E0;       /* 기본 텍스트 색상 */
        --sidebar-width: 260px;      /* 너비 고정 */
    }

    .sidebar {
        width: var(--sidebar-width);
        height: 100vh;
        background-color: var(--sidebar-bg);
        color: var(--text-color);
        display: flex;
        flex-direction: column;
        position: fixed; /* 좌측 고정 */
        top: 0;
        left: 0;
        z-index: 1000;
        box-shadow: 4px 0 10px rgba(0,0,0,0.1);
        transition: 0.3s;
        overflow-y: auto; /* 세로 내용 넘칠 시 스크롤 */
    }

    /* 로고 영역 */
    .sidebar-header {
        padding: 20px;
        border-bottom: 1px solid rgba(255,255,255,0.1);
        display: flex;
        align-items: center;
        gap: px;
    }
    .admin-logo { width: 35px; height: 35px; object-fit: contain; }
    .brand-name { font-size: 1.2rem; font-weight: 800; color: #fff; letter-spacing: 1px; }

    /* 메뉴 리스트 */
    .menu-list {
        flex: 1; /* 남은 공간 차지 */
        padding: 20px 10px;
        list-style: none;
        margin: 0;
    }
    .menu-item { margin-bottom: 5px; }

    /* 링크 스타일 */
    .menu-link {
        display: flex;
        align-items: center;
        padding: 12px 20px;
        color: #aaa;
        text-decoration: none;
        font-size: 0.95rem;
        border-radius: 8px;
        transition: all 0.2s ease;
        gap: 12px; /* 아이콘과 텍스트 간격 */
    }
    
    .menu-link i { width: 20px; text-align: center; } /* 아이콘 너비 고정 */

    /* 호버 효과 */
    .menu-link:hover {
        background-color: var(--sidebar-hover);
        color: #fff;
        transform: translateX(5px);
    }

    /* ★ 현재 페이지 활성화 상태 (JS로 제어) ★ */
    .menu-link.active {
        background-color: var(--sidebar-active);
        color: #fff;
        font-weight: 600;
        box-shadow: 0 4px 15px rgba(124, 77, 255, 0.4);
    }

    /* 하단 푸터 (프로필 & 로그아웃) */
    .sidebar-footer {
        padding: 25px;
        background-color: #1E1A38;
        border-top: 1px solid rgba(255,255,255,0.1);
    }
    .admin-profile { margin-bottom: 15px; }
    .role-badge { font-size: 0.75rem; color: var(--sidebar-active); font-weight: 700; display: block; margin-bottom: 3px; }
    .admin-name { color: #fff; font-weight: 600; font-size: 1rem; }

    /* 하단 버튼 그룹 */
    .btn-sidebar {
        width: 100%;
        padding: 10px;
        border: 1px solid #555;
        background: transparent;
        color: #ccc;
        border-radius: 6px;
        font-size: 0.85rem;
        cursor: pointer;
        transition: 0.2s;
        display: flex; justify-content: center; align-items: center; gap: 8px;
        margin-bottom: 8px;
    }
    .btn-logout:hover { border-color: #ff5252; color: #ff5252; background: rgba(255,82,82,0.1); }
    .btn-home:hover { border-color: #448AFF; color: #448AFF; background: rgba(68,138,255,0.1); }
</style>

<nav class="sidebar">
    <div class="sidebar-header">
        <i class="fa-solid fa-building-user" style="font-size:1.8rem; color:var(--sidebar-active);"></i>
        <span class="brand-name">APARTNERS</span>
    </div>
    
    <ul class="menu-list">
        <li class="menu-item">
            <a href="<c:url value='/admin/dashboard'/>" class="menu-link">
                <i class="fa-solid fa-chart-pie"></i> <span>대시보드</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="<c:url value='/admin/member/list'/>" class="menu-link">
                <i class="fa-solid fa-users"></i> <span>회원 관리</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="<c:url value='/admin/fee/list'/>" class="menu-link">
                <i class="fa-solid fa-file-invoice-dollar"></i> <span>관리비 조회</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="<c:url value='/admin/parking/list'/>" class="menu-link">
                <i class="fa-solid fa-car"></i> <span>주차 관리</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="<c:url value='/admin/notice/list'/>" class="menu-link">
                <i class="fa-solid fa-bullhorn"></i> <span>공지사항</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="<c:url value='/admin/board/list'/>" class="menu-link">
                <i class="fa-solid fa-comments"></i> <span>게시판 통합</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="<c:url value='/admin/minwon/list'/>" class="menu-link">
                <i class="fa-solid fa-clipboard-check"></i> <span>민원 현황</span>
            </a>
        </li>
    </ul>

    <div class="sidebar-footer">
        <div class="admin-profile">
            <span class="role-badge">SUPER ADMIN</span>
            <div class="admin-name">관리자 님</div>
        </div>
        
        <button class="btn-sidebar btn-home" onclick="location.href='/'">
            <i class="fa-solid fa-house"></i> 홈페이지
        </button>
        <button class="btn-sidebar btn-logout" onclick="location.href='/logout'">
            <i class="fa-solid fa-power-off"></i> 로그아웃
        </button>
    </div>
</nav>

<script>
    /* =========================================
       2. 메뉴 자동 활성화 (Auto Active Logic)
       ========================================= */
    document.addEventListener("DOMContentLoaded", function() {
        // 현재 브라우저의 URL 경로 가져오기
        const currentPath = window.location.pathname;
        
        // 모든 메뉴 링크를 조회
        const menuLinks = document.querySelectorAll('.menu-link');

        menuLinks.forEach(link => {
            // 링크의 href 속성 값 가져오기
            const linkPath = link.getAttribute('href');

            // 1. 정확히 일치하거나 (Dashboard 등)
            // 2. 해당 경로로 시작하는 경우 (예: /admin/member/list 에서 /admin/member 포함 시)
            //    단, 대시보드(/admin/dashboard)와 같은 루트 경로는 중복 방지를 위해 정확히 일치할 때만.
            
            if (linkPath === currentPath) {
                link.classList.add('active');
            } else if (linkPath !== '/admin/dashboard' && currentPath.includes(linkPath)) {
                // 서브 페이지(상세, 등록 등)에 들어가도 메뉴 활성화 유지
                link.classList.add('active');
            }
        });
    });
</script>
