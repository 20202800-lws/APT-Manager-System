<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    /* 어린이집 아코디언 전용 모던 UI 스타일 */
    .kids-toggle-btn {
        padding: 12px 15px;
        color: #64748b;
        font-weight: 600;
        cursor: pointer;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-radius: 8px;
        transition: all 0.2s;
    }

    .kids-toggle-btn:hover {
        background-color: #f1f5f9;
        color: #1a0b2e;
    }

    .kids-sub-menu {
        list-style: none;
        padding-left: 0;
        margin-top: 5px;
        margin-bottom: 10px;
    }

    /* 겹침 해결 & 여백 확보 */
    .kids-sub-item {
        padding: 12px 15px 12px 45px !important;
        color: #888;
        font-size: 0.95rem;
        cursor: pointer;
        border-radius: 8px;
        transition: all 0.2s;
        position: relative;
        margin-bottom: 4px;
        display: block;
    }

	/* 우아한 세로선 위치 조정 */
	    .kids-sub-item::before {
	        content: "";
	        position: absolute;
	        left: 24px;
	        top: 0;
	        bottom: 0;
	        width: 2px;
	        background-color: #e2e8f0;
	        transition: background-color 0.2s;
	    }

	    /* 1. 마우스 오버 상태 (밝은 배경 + 남색 글씨) */
	    .kids-sub-item:hover {
	        color: #1a0b2e !important;
	        font-weight: 700;
	        background-color: #f8fafc !important;
	    }

	    /* 2. ★ 활성화 상태 (남색 배경 + 하얀색 글씨로 구출!) */
	    .kids-sub-item.active {
	        color: #ffffff !important; 
	        font-weight: 700;
	        background-color: #1a0b2e !important; 
	        border-radius: 8px;
	    }

	    /* 3. 마우스 오버 시 세로선 포인트 컬러 */
	    .kids-sub-item:hover::before {
	        background-color: #1a0b2e;
	    }

	    /* 4. 활성화 시 세로선 숨김 (배경이 남색이므로 선이 안 보여도 됨) */
	    .kids-sub-item.active::before {
	        background-color: transparent !important; 
	    }
</style>

<aside class="sidebar">
    <h2>게시판</h2>
    <ul class="lnb">
        <li class="${param.activeMenu == 'free' ? 'active' : ''}" onclick="location.href='<c:url value="/board/free"/>'">자유게시판</li>

        <li class="${param.activeMenu == 'anon' ? 'active' : ''}" onclick="location.href='<c:url value="/board/anon"/>'">익명게시판</li>

        <li class="${param.activeMenu == 'comp' ? 'active' : ''}" onclick="location.href='<c:url value="/board/comp"/>'">민원게시판</li>

        <c:set var="isKidsMenu" value="${param.activeMenu == 'daycare_notice' || param.activeMenu == 'daycare_gallery' || param.activeMenu == 'daycare_parent'}" />

        <li style="margin-top:10px; padding:0; background:none; border:none;">
            <div class="kids-toggle-btn" onclick="toggleKidsMenu()">
                어린이집
                <span id="kidsArrow" style="font-size:12px; transition: transform 0.3s ease; display: inline-block; transform: ${isKidsMenu ? 'rotate(180deg)' : 'rotate(0deg)'};">▼</span>
            </div>

            <ul id="kidsSubMenu" class="kids-sub-menu" style="display: ${isKidsMenu ? 'block' : 'none'};">
                <li class="kids-sub-item ${param.activeMenu == 'daycare_notice' ? 'active' : ''}" onclick="location.href='<c:url value="/daycare/notice"/>'">
                    공지사항
                </li>

                <li class="kids-sub-item ${param.activeMenu == 'daycare_gallery' ? 'active' : ''}" onclick="location.href='<c:url value="/daycare/gallery"/>'">
                    활동갤러리
                </li>

                <li class="kids-sub-item ${param.activeMenu == 'daycare_parent' ? 'active' : ''}" onclick="location.href='<c:url value="/daycare/parent"/>'">
                    학부모의견란
                </li>
            </ul>
        </li>
    </ul>
</aside>

<script>
    function toggleKidsMenu() {
        var subMenu = document.getElementById('kidsSubMenu');
        var arrow = document.getElementById('kidsArrow');

        if (subMenu.style.display === 'none' || subMenu.style.display === '') {
            subMenu.style.display = 'block';
            arrow.style.transform = 'rotate(180deg)';
        } else {
            subMenu.style.display = 'none';
            arrow.style.transform = 'rotate(0deg)';
        }
    }
</script>