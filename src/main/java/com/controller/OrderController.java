package com.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.dto.BundleDTO;
import com.dto.CartDTO;
import com.dto.MemberDTO;
import com.dto.OrderinfoDTO;
import com.service.GoodsService;
import com.service.OrderService;

@Controller
@Transactional
public class OrderController {
	/* 상품 주문에 대한 컨트롤러 */

	@Autowired
	OrderService orderService;

	@Autowired
	GoodsService goodsService;
	
	// 상품 주문 화면
	@RequestMapping(value="/orderForm")
	public ModelAndView orderForm(HttpSession session, CartDTO cDTO) {
		MemberDTO login = (MemberDTO) session.getAttribute("login");
		if (login == null)	// 비회원 구매 시 
			cDTO.setUserid("비회원");	// userid 컬럼 not null 처리 - 임시 데이터로 member 테이블에 존재하는 비회원 전용 userid 입력하기
		else if (login != null && cDTO.getUserid() == null)	// 회원 구매
			cDTO.setUserid(login.getUserid());
		
		ModelAndView mav = new ModelAndView();
		
		if (cDTO.getBcategory() != null && cDTO.getBcategory().length() > 0) {
			if (!cDTO.getBcategory().contains("단품")) {	// 도매 상품일 경우, 번들 정보를 가져옴
				BundleDTO bDTO = orderService.getBPrice(cDTO.getGcode());
				// System.out.println(bDTO);	// 확인용

				mav.addObject("bDTO", bDTO);
			}
		} else 	// 소매 상품일 경우, bcategory 컬럼을 "소매품"으로 통일 
			cDTO.setBcategory("소매품");

		System.out.println(cDTO);	// 확인용
		
		mav.addObject("cDTO", cDTO);
		mav.setViewName("order");
		
		return mav;
	}
	
	// 상품 한 개 주문하기
	@RequestMapping(value="/oneGoodsOrder")
	public String oneGoodsOrder(HttpSession session, OrderinfoDTO oiDTO) {
		// 도매 상품일 경우, 번들 정보를 가져옴
		int bundle = 1;	// 번들 묶음 단위 - 기본값 1
		if (!oiDTO.getBcategory().equals("소매품")) {
			if (!oiDTO.getBcategory().contains("단품"))
				oiDTO.setBcategory("도매품: " + oiDTO.getBcategory());
			
			BundleDTO bDTO = orderService.getBPrice(oiDTO.getGcode());
			bundle = Integer.parseInt(bDTO.getBcategory().replaceAll("[^\\d]", ""));	// 번들 정보에서 숫자만 추출해 저장
			session.setAttribute("bDTO", bDTO);
		}
		
		int goodsAmount = goodsService.goodsDetail(oiDTO.getGcode()).getGamount();
		if (goodsAmount - (oiDTO.getGamount() * bundle) < 0) {	// 재고보다 많은 수량의 상품 구매 시
			session.setAttribute("success", "상품 구매 실패 - 재고 부족");
			
			return "redirect:./";
		} else {
			MemberDTO login = (MemberDTO) session.getAttribute("login");
			if (login == null)	// 비회원 구매 시
				oiDTO.setUserid("비회원");	// userid 컬럼 not null 처리 - 임시 데이터로 member 테이블에 존재하는 비회원 전용 userid 입력하기
			else if (login != null && oiDTO.getUserid() == null)	// 회원 구매
				oiDTO.setUserid(login.getUserid());

			System.out.println(oiDTO);	// 확인용
			
			// 1. orderinfo 테이블에 레코드 추가
			int insertOrderinfo = orderService.oneGoodsOrder(oiDTO);
			System.out.println("orderinfo insert: " + insertOrderinfo);
			
			// 2. cart 테이블에 데이터가 있다면 삭제
			/*
			int deleteCart = goodsService.delete(oiDTO.getNum());
			System.out.println("cart delete: " + deleteCart);
			 */
			
			// 3. 남은 재고 계산하여 goods 테이블 업데이트
			HashMap<String, Object> oiMap = new HashMap<>();
			oiMap.put("gcode", oiDTO.getGcode());
			oiMap.put("gamount", oiDTO.getGamount() * bundle);
			int updateGoods = goodsService.updateAmount(oiMap);
			System.out.println("goods update: " + updateGoods);
			
			session.setAttribute("oiDTO", oiDTO);
			session.setAttribute("bundle", bundle);
			session.setAttribute("success", "상품 구매 성공");
			
			return "order_success";
		}
	}
	
	/**********************/
	/* 관리자 기능 */
	
	// 주문 관리 페이지로 이동
	@RequestMapping(value="/ManagerCheck/orderManagement")
	public String orderManagement(HttpSession session) {
		List<OrderinfoDTO> orderList = orderService.getOrders();
		// System.out.println(orderList);	// 확인용
		
		session.setAttribute("orderList", orderList);
		
		return "redirect:../order_management";
	}
	
	// 주문 승인
	@RequestMapping(value="/ManagerCheck/approveOrder")
	@ResponseBody
	public void approveOrder(@RequestParam("num") int num) {
		System.out.println(num);	// 확인용
		
		// orderinfo 테이블에서 승인 완료됨으로 표시
		/*
		int updatedOrder = orderService.approveOrder(num);
		System.out.println("orderinfo update: " + updatedOrder);
		 */
	}
	
	// 주문 보류(= 삭제)
	@RequestMapping(value="/ManagerCheck/deleteOrder")
	@ResponseBody
	public void deleteOrder(@RequestParam("num") int num) {
		System.out.println(num);	// 확인용
		
		// orderinfo 테이블에서 삭제
		/*
		int deletedOrder = orderService.deleteOrder(num);
		System.out.println("orderinfo delete: " + deletedOrder);
		 */
	}
	
}
