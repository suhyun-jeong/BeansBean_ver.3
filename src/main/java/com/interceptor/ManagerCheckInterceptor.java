package com.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.dto.MemberDTO;

public class ManagerCheckInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		System.out.println("preHandle");
		
		HttpSession session = request.getSession();
		if(session.getAttribute("login")==null) {
			response.sendRedirect("../loginForm");
			return false;
		}else {
			MemberDTO mdto = (MemberDTO)session.getAttribute("login");
			if(mdto.getUsercode() != 10) {
				session.setAttribute("success", "관리자만 접근가능합니다.");
				response.sendRedirect("../");
				return false;
			}else {
				return true;
			}//mdto != 10 end
		}// session == null end
		
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		System.out.println("postHandle");
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		System.out.println("afterCompletion");
	}

}
