<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 현재 접속 중인 페이지 주소를 가져와서 탭 활성화에 사용합니다.
    String currentUri = request.getRequestURI();
%>
<aside class="sidebar">
    <h2>주차시설</h2>
    <ul class="lnb">
        <li class="<%= currentUri.contains("my_car") ? "active" : "" %>"
            onclick="location.href='/parking/my_car'">
            <i class="fa-solid fa-house-user"></i> 세대 차량 관리
        </li>
        <li class="<%= currentUri.contains("visit_car") ? "active" : "" %>"
            onclick="location.href='/parking/visit_car'">
            <i class="fa-solid fa-user-plus"></i> 방문 차량 관리
        </li>
    </ul>
</aside>