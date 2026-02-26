<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<aside class="sidebar">
    <h2>아파트 소개</h2>
    <ul class="lnb">
        <li class="${param.activeMenu == 'layout' ? 'active' : ''}" onclick="location.href='/intro/layout'">단지배치도</li>
        <li class="${param.activeMenu == 'guide' ? 'active' : ''}" onclick="location.href='/intro/guide'">단지안내</li>
        <li class="${param.activeMenu == 'floor_plan' ? 'active' : ''}" onclick="location.href='/intro/floor_plan'">평면도</li>
    </ul>
</aside>