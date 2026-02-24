<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="sidebar">
    <h2>마이페이지</h2>
    <ul class="lnb">
        <li class="${param.activeMenu == 'info_view' ? 'active' : ''}" 
            onclick="location.href='<c:url value="/mypage/info"/>'">내 정보</li>
            
        <li class="${param.activeMenu == 'info_edit' ? 'active' : ''}" 
            onclick="location.href='<c:url value="/mypage/edit"/>'">정보 수정</li>
            
        <li class="${param.activeMenu == 'fee_view' ? 'active' : ''}" 
            onclick="location.href='<c:url value="/mypage/fee"/>'">관리비</li>
        
        <li style="font-weight:700; color:#555; margin-top:20px; border-top:1px dashed #ccc; padding-top:15px; cursor:default; pointer-events:none;">활동 내역</li>
        
        <li class="${param.activeMenu == 'act_reply' ? 'active' : ''}" 
            onclick="location.href='<c:url value="/mypage/act/reply"/>'"
            style="padding-left: 25px; font-size: 0.95em; position:relative;">
            <span style="color:#aaa; position:absolute; left:10px;">└</span> 내가 쓴 댓글
        </li>
            
        <li class="${param.activeMenu == 'act_posts' ? 'active' : ''}" 
            onclick="location.href='<c:url value="/mypage/act/posts"/>'"
            style="padding-left: 25px; font-size: 0.95em; position:relative;">
            <span style="color:#aaa; position:absolute; left:10px;">└</span> 내가 쓴 게시물
        </li>
    </ul>
</aside>