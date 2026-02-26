<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<% String currentUri=request.getRequestURI(); %>
		<aside class="sidebar">
			<h2>커뮤니티 시설</h2>
			<ul class="lnb">
				<li class="<%= currentUri.contains(" info_gym") ? "active" : "" %>"
					onclick="location.href='/facility/info_gym'">
					<i class="fa-solid fa-dumbbell"></i> 헬스장
				</li>
				<li class="<%= currentUri.contains(" info_pool") ? "active" : "" %>"
					onclick="location.href='/facility/info_pool'">
					<i class="fa-solid fa-person-swimming"></i> 수영장
				</li>
				<li class="<%= currentUri.contains(" info_golf") ? "active" : "" %>"
					onclick="location.href='/facility/info_golf'">
					<i class="fa-solid fa-golf-ball-tee"></i> 스크린골프
				</li>
				<li class="<%= currentUri.contains(" info_guest") ? "active" : "" %>"
					onclick="location.href='/facility/info_guest'">
					<i class="fa-solid fa-bed"></i> 게스트하우스
				</li>
			</ul>
		</aside>