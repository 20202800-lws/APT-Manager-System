package com.apt.membermanager.config;

import com.apt.membermanager.entity.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import java.io.PrintWriter;

@Component
public class DaycareInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        User loginMember = (User) session.getAttribute("loginMember");

        // 비로그인 상태이거나 권한이 없는 경우 접근 차단
        if (loginMember == null || 
           (!loginMember.getUserRole().equals("ADMIN") && 
            !loginMember.getUserRole().equals("TEACHER") && 
            !loginMember.getUserRole().equals("PARENT"))) {
            
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('어린이집 관계자(학부모, 선생님, 관리자)만 접근할 수 있습니다.'); history.back();</script>");
            out.flush();
            return false; // 컨트롤러로 넘어가지 않고 여기서 요청 종료
        }
        return true;
    }
}