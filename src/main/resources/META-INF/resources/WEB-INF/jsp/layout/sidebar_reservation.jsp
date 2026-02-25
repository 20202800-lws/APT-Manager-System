<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String currentUri = request.getRequestURI();
%>
<aside class="sidebar">
    <h2>예약 및 관리</h2>
    <ul class="lnb">
        <li class="<%= currentUri.contains("fac_book") ? "active" : "" %>"
            onclick="location.href='/reservation/fac_book'">
            <i class="fa-regular fa-calendar-check"></i> 시설 예약
        </li>
        <li class="<%= currentUri.contains("prog_book") ? "active" : "" %>"
            onclick="location.href='/reservation/prog_book'">
            <i class="fa-solid fa-person-running"></i> 프로그램 신청
        </li>
        <li class="<%= currentUri.contains("my_list") ? "active" : "" %>"
            onclick="location.href='/reservation/my_list'">
            <i class="fa-solid fa-list-check"></i> 예약/수강 내역
        </li>
    </ul>
</aside>