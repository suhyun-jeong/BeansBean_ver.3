package com.controller;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


import com.dto.MemberDTO;
import com.service.MemberService;

@Controller
public class MemberController {
	@Autowired
	MemberService service;
	
//	//에러처리
//			@ExceptionHandler({Exception.class})
//			public String errorPage() {
//				return "error/error";
//			}
			
	@RequestMapping(value = "/memberAdd")
	public String memberAdd(MemberDTO m, Model model) throws Exception{
		//System.out.println(m);
		System.out.println(m);
		int n = service.memberAdd(m);
		System.out.println("insert 갯수: "+n);
		model.addAttribute("success","회원가입 성공!");
		return "main";
	}
	

	// 아이디 중복 체크
	@RequestMapping(value="/idDuplicateCheck")
	@ResponseBody
	public String idDuplicateCheck(@RequestParam("inputId") String inputId) {
		int duplicated = service.idDuplicateCheck(inputId);
		if (duplicated == 0)
			return "OK";
		else
			return "NO";
	}
	

	// 로그인
	@RequestMapping(value="/login")
	public String login(HttpSession session, @RequestParam Map<String, String> map) {
		//System.out.println(map.get("userid") + "\t" + map.get("passwd"));
		
		MemberDTO mDTO = service.idpwCheck(map);
		if (mDTO != null) {
			session.setAttribute("login", mDTO);
		
			return "redirect:./";

		} else {
			session.setAttribute("loginMsg", "아이디와 비밀번호를 확인해주세요.");
			
			return "redirect:loginForm";
		}
	}
	
	
	// 로그아웃
	@RequestMapping(value="/logout")
	public String logout(HttpSession session) {
		if (session.getAttribute("login") != null)
			session.removeAttribute("login");
	
		return "redirect:./";
	}
}
