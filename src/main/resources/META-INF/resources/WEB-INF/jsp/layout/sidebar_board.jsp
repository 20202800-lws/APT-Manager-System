<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="sidebar">
    <h2>게시판</h2>
    <ul class="lnb">
        <li class="${param.activeMenu == 'free' ? 'active' : ''}" onclick="location.href='<c:url value="/board/free"/>'">
            <i class="fa-solid fa-comments"></i> 자유게시판
        </li>
        <li class="${param.activeMenu == 'anon' ? 'active' : ''}" onclick="location.href='<c:url value="/board/anon"/>'">
            <i class="fa-solid fa-user-secret"></i> 익명게시판
        </li>
        <li class="${param.activeMenu == 'comp' ? 'active' : ''}" onclick="location.href='<c:url value="/board/comp"/>'">
            <i class="fa-solid fa-circle-exclamation"></i> 민원게시판
        </li>

        <c:set var="isKidsMenu" value="${param.activeMenu == 'daycare_notice' || param.activeMenu == 'daycare_gallery' || param.activeMenu == 'daycare_parent'}" />

        <li style="margin-top:10px; padding:0; background:none; border:none;">
            <div class="sub-toggle-btn" onclick="toggleKidsMenu()">
                <span><i class="fa-solid fa-children"></i> 어린이집</span>
                <span id="kidsArrow" style="font-size:12px; transition: transform 0.3s ease; display: inline-block; transform: ${isKidsMenu ? 'rotate(180deg)' : 'rotate(0deg)'};">▼</span>
            </div>

            <ul id="kidsSubMenu" class="sub-menu-list" style="display: ${isKidsMenu ? 'block' : 'none'};">
                <li class="sub-menu-item ${param.activeMenu == 'daycare_notice' ? 'active' : ''}" onclick="location.href='<c:url value="/daycare/notice"/>'">공지사항</li>
                <li class="sub-menu-item ${param.activeMenu == 'daycare_gallery' ? 'active' : ''}" onclick="location.href='<c:url value="/daycare/gallery"/>'">활동갤러리</li>
                <li class="sub-menu-item ${param.activeMenu == 'daycare_parent' ? 'active' : ''}" onclick="location.href='<c:url value="/daycare/parent"/>'">학부모의견란</li>
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