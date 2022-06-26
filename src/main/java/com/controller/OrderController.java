package com.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import com.dto.OrderstateDTO;
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

			// 1. orderinfo 테이블에 레코드 추가
			int insertOrderinfo = orderService.oneGoodsOrder(oiDTO);
			System.out.println("orderinfo insert: " + insertOrderinfo);
			
			System.out.println(oiDTO);	// 확인용
			
			// 2-1. 해당 주문의 처리 상태에 대한 객체 생성
			OrderstateDTO osDTO = new OrderstateDTO();
			osDTO.setNum(oiDTO.getNum());
			String tempPost = String.valueOf(oiDTO.getPost());
			if (tempPost.length() < 5)	// 우편번호가 네자릿수라면 앞에 생략된 0을 추가
				tempPost = "0" + tempPost;
			osDTO.setPost(tempPost);
			osDTO.setAddr1(oiDTO.getAddr1());
			osDTO.setAddr2(oiDTO.getAddr2());
			
			System.out.println(osDTO);	// 확인용
			
			// 2-2. orderstate 테이블에 레코드 추가
			int insertOrderstate = orderService.oneOrderState(osDTO);
			System.out.println("orderstate insert: " + insertOrderstate);
			
			// 3. cart 테이블에 데이터가 있다면 삭제
			/*
			int deleteCart = goodsService.delete(oiDTO.getNum());
			System.out.println("cart delete: " + deleteCart);
			 */
			
			// 4. 남은 재고 계산하여 goods 테이블 업데이트
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
		List<OrderinfoDTO> oiList = orderService.getOrders();
		System.out.println(oiList);	// 확인용
		List<OrderstateDTO> osList = orderService.getOrderStates();
		System.out.println(osList);	// 확인용
		
		session.setAttribute("oiList", oiList);
		session.setAttribute("osList", osList);
		
		return "redirect:../order_management";
	}
	
	// 주문 상세 보기 화면으로 이동
	@RequestMapping(value="/ManagerCheck/orderDetail")
	public String orderDetail(HttpSession session, @RequestParam int num) {
		// System.out.println(num);	// 확인용
		
		OrderinfoDTO oiDTO = orderService.getOrderByNum(num);
		session.setAttribute("oiDTO", oiDTO);
		OrderstateDTO osDTO = orderService.getOrderstateByNum(num);
		session.setAttribute("osDTO", osDTO);
		
		return "redirect:../order_management_detail";
	}
	
	// 주문 처리 상태 변경
	@RequestMapping(value="/ManagerCheck/changeOrderstate")
	@ResponseBody
	public List<OrderstateDTO> changeOrderstate(@RequestParam Map<String, Object> map) {
		// System.out.println(map.get("num") + "\t" + map.get("o_state"));	// 확인용
		
		// orderinfo 테이블의 o_state 컬럼 업데이트
		int updatedOrderstate = orderService.changeOrderstate(map);
		System.out.println("orderstate update: " + updatedOrderstate);
		
		List<OrderstateDTO> osList = orderService.getOrderStates();
		return osList;
	}
	
	// 주문 반려 사유 업데이트
	@RequestMapping(value="/ManagerCheck/updateReIssue")
	@ResponseBody
	public void updateReIssue(@RequestParam Map<String, Object> map) {
		// System.out.println(map.get("num") + "\t" + map.get("re_issue"));	// 확인용
		
		// orderstate 테이블의 re_issue 컬럼 업데이트
		int updatedOrderstate = orderService.updateReIssue(map);
		System.out.println("orderstate update: " + updatedOrderstate);
	}
	
}
