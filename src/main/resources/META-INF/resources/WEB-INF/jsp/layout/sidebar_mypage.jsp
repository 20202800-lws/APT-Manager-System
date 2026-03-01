<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="sidebar">
    <h2>마이페이지</h2>
    <ul class="lnb">
        <li class="${param.activeMenu == 'info_view' ? 'active' : ''}" onclick="location.href='<c:url value="/mypage/info_view"/>'">
            <i class="fa-solid fa-user-gear"></i> 내 정보
        </li>
        <li class="${param.activeMenu == 'info_edit' ? 'active' : ''}" onclick="location.href='<c:url value="/mypage/info_edit"/>'">
            <i class="fa-solid fa-user-pen"></i> 정보 수정
        </li>
        <li class="${param.activeMenu == 'fee_view' ? 'active' : ''}" onclick="location.href='<c:url value="/mypage/fee_view"/>'">
            <i class="fa-solid fa-file-invoice-dollar"></i> 관리비 조회
        </li>
        
        <c:set var="isActMenu" value="${param.activeMenu == 'act_reply' || param.activeMenu == 'act_posts'}" />
        
        <li style="margin-top:10px; padding:0; background:none; border:none;">
            <div class="sub-toggle-btn" onclick="toggleActMenu()">
                <span><i class="fa-solid fa-clock-rotate-left"></i> 활동 내역</span>
                <span id="actArrow" style="font-size:12px; transition: transform 0.3s ease; display: inline-block; transform: ${isActMenu ? 'rotate(180deg)' : 'rotate(0deg)'};">▼</span>
            </div>

            <ul id="actSubMenu" class="sub-menu-list" style="display: ${isActMenu ? 'block' : 'none'};">
                <li class="sub-menu-item ${param.activeMenu == 'act_reply' ? 'active' : ''}" onclick="location.href='<c:url value="/mypage/act_reply"/>'">내가 쓴 댓글</li>
                <li class="sub-menu-item ${param.activeMenu == 'act_posts' ? 'active' : ''}" onclick="location.href='<c:url value="/mypage/act_posts"/>'">내가 쓴 게시물</li>
            </ul>
        </li>
    </ul>
</aside>

<script>
    function toggleActMenu() {
        var subMenu = document.getElementById('actSubMenu');
        var arrow = document.getElementById('actArrow');
        if (subMenu.style.display === 'none' || subMenu.style.display === '') {
            subMenu.style.display = 'block';
            arrow.style.transform = 'rotate(180deg)';
        } else {
            subMenu.style.display = 'none';
            arrow.style.transform = 'rotate(0deg)';
        }
    }
</script>