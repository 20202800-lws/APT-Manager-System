<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* =========================================
       1. 사이드바 전용 CSS (기존 완벽한 스타일 유지)
       ========================================= */
    :root {
        --sidebar-bg: #262148;       
        --sidebar-hover: #3D375E;    
        --sidebar-active: #7C4DFF;   
        --text-color: #E0E0E0;       
        --sidebar-width: 260px;      
    }

    .sidebar {
        width: var(--sidebar-width);
        height: 100vh;
        background-color: var(--sidebar-bg);
        color: var(--text-color);
        display: flex;
        flex-direction: column;
        position: fixed; 
        top: 0;
        left: 0;
        z-index: 1000;
        box-shadow: 4px 0 10px rgba(0,0,0,0.1);
        transition: 0.3s;
        overflow-y: auto; 
    }

    .sidebar-header {
        padding: 20px;
        border-bottom: 1px solid rgba(255,255,255,0.1);
        display: flex;
        align-items: center;
        gap: 10px; /* px 단위 누락되어 수정함 */
    }
    .admin-logo { width: 35px; height: 35px; object-fit: contain; }
    .brand-name { font-size: 1.2rem; font-weight: 800; color: #fff; letter-spacing: 1px; }

    .menu-list {
        flex: 1; 
        padding: 20px 10px;
        list-style: none;
        margin: 0;
    }
    .menu-item { margin-bottom: 5px; }

    .menu-link {
        display: flex;
        align-items: center;
        padding: 12px 20px;
        color: #aaa;
        text-decoration: none;
        font-size: 0.95rem;
        border-radius: 8px;
        transition: all 0.2s ease;
        gap: 12px; 
    }
    
    .menu-link i { width: 20px; text-align: center; } 

    .menu-link:hover {
        background-color: var(--sidebar-hover);
        color: #fff;
        transform: translateX(5px);
    }

    .menu-link.active {
        background-color: var(--sidebar-active);
        color: #fff;
        font-weight: 600;
        box-shadow: 0 4px 15px rgba(124, 77, 255, 0.4);
    }

    .sidebar-footer {
        padding: 25px;
        background-color: #1E1A38;
        border-top: 1px solid rgba(255,255,255,0.1);
    }
    .admin-profile { margin-bottom: 15px; }
    .role-badge { font-size: 0.75rem; color: var(--sidebar-active); font-weight: 700; display: block; margin-bottom: 3px; }
    .admin-name { color: #fff; font-weight: 600; font-size: 1rem; }

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
            <a href="<c:url value='/admin/main'/>" class="menu-link">
                <i class="fa-solid fa-chart-pie"></i> <span>대시보드</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="<c:url value='/admin/member_list'/>" class="menu-link">
                <i class="fa-solid fa-users"></i> <span>회원 관리</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="<c:url value='/admin/fee_manage'/>" class="menu-link">
                <i class="fa-solid fa-file-invoice-dollar"></i> <span>관리비 관리</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="<c:url value='/admin/parking_manage'/>" class="menu-link">
                <i class="fa-solid fa-car"></i> <span>주차 관리</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="<c:url value='/admin/notice_manage'/>" class="menu-link">
                <i class="fa-solid fa-bullhorn"></i> <span>공지사항 관리</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="<c:url value='/admin/board_manage'/>" class="menu-link">
                <i class="fa-solid fa-comments"></i> <span>일반 게시판 관리</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="<c:url value='/admin/comp_manage'/>" class="menu-link">
                <i class="fa-solid fa-clipboard-check"></i> <span>민원 현황 관리</span>
            </a>
        </li>
    </ul>

    <div class="sidebar-footer">
        <div class="admin-profile">
            <span class="role-badge">SUPER ADMIN</span>
            <div class="admin-name">${sessionScope.loginMember.realName != null ? sessionScope.loginMember.realName : '관리자'} 님</div>
        </div>
        
        <button class="btn-sidebar btn-home" onclick="location.href='/'">
            <i class="fa-solid fa-house"></i> 홈페이지
        </button>
        <button class="btn-sidebar btn-logout" onclick="location.href='/member/logout'">
            <i class="fa-solid fa-power-off"></i> 로그아웃
        </button>
    </div>
</nav>

<script>
    /* =========================================
       2. 메뉴 자동 활성화 (Auto Active Logic)
       ========================================= */
    document.addEventListener("DOMContentLoaded", function() {
        const currentPath = window.location.pathname;
        const menuLinks = document.querySelectorAll('.menu-link');

        menuLinks.forEach(link => {
            const linkPath = link.getAttribute('href');

            // ★ 자바스크립트 비교 대상도 /admin/main 으로 수정
            if (linkPath === currentPath) {
                link.classList.add('active');
            } else if (linkPath !== '/admin/main' && currentPath.includes(linkPath)) {
                link.classList.add('active');
            }
        });
    });
</script>