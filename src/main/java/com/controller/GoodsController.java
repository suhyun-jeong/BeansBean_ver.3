package com.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.dto.BundleDTO;
import com.dto.CartDTO;
import com.dto.GoodsDTO;
import com.dto.MemberDTO;
import com.dto.VariationDTO;
import com.service.GoodsService;

@Controller
public class GoodsController {
	
	@Autowired
	GoodsService service;
	
	/*
	 * @RequestMapping("/goodsList") public ModelAndView goodsList(String gcategory)
	 * { // TODO 상품목록보기 // System.out.println(gcategory); if(gcategory == null) {
	 * 
	 * gcategory = "coffee";
	 * 
	 * }
	 */
		
		@RequestMapping("/goodsList")
		public ModelAndView goodsList(String gcategory, String keyword, String condition) {
			// TODO 상품목록보기
//			System.out.println(gcategory);
			if(gcategory == null) {

				gcategory = "coffee";
				
				GoodsDTO dto = new GoodsDTO();
				if(keyword != null) {
					if(condition.equals("gCategory")) {
					dto.setGcategory(keyword);
					}else if(condition.equals("gName")) {
					dto.setGname(keyword);
					
					}
				}
			}

		List<GoodsDTO> list = service.goodsList(gcategory);
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("goodsList", list);
//		System.out.println(list);
		mav.setViewName("main");
		return mav;
		
	}
	
	@RequestMapping("/goodsDetail")
	@ModelAttribute("goodsDetail")
	public GoodsDTO goodsDetail(String gcode) {
//		System.out.println(gcode);
		GoodsDTO dto = service.goodsDetail(gcode);
//		System.out.println(dto);
		return dto;
	}
	
	@ResponseBody
	@RequestMapping("bundleDetail")
	public List<BundleDTO> bundleDetail(String gcode) {
		//TODO BundleDTO 
		System.out.println(gcode);
		
		List<BundleDTO> list = service.bundleDetail(gcode);
		System.out.println(list);

		return list;
	}
	
	@ResponseBody
	@RequestMapping("variationDetail")
	public List<VariationDTO> variationDetail(String gcode) {
		//TODO BundleDTO 
		System.out.println(gcode);
		
		List<VariationDTO> list = service.variationDetail(gcode);
		System.out.println(list);

		return list;
	}
	
	@ResponseBody
	@RequestMapping(value = "/loginCheck/cartAdd",method = RequestMethod.POST )
	public void cartAdd(CartDTO cart) {
		service.cartAdd(cart);
	}

	@RequestMapping("/loginCheck/cartList")
	public String cartList(RedirectAttributes attr, HttpSession session) {
		MemberDTO dto= (MemberDTO)session.getAttribute("login");
		String userid=dto.getUserid();
		List<CartDTO> list =service.cartList(userid);
		attr.addFlashAttribute("cartList", list);
		return "redirect:../cartList"; //servlet-context에 등록
		
	}

	@RequestMapping(value = "/loginCheck/cartDelete")
	@ResponseBody
	public void cartDelte(@RequestParam("num") int num) {
		System.out.println(num);
		service.cartDelete(num);
	}
	
	@RequestMapping(value = "/loginCheck/delAllCart")
	public String delAllCart(@RequestParam("check") ArrayList<String> list) {
		System.out.println(list);
		service.delAllCart(list);
		return "redirect:../loginCheck/cartList";
	}
	
	@RequestMapping(value = "/loginCheck/orderAllConfirm")
	public String orderAllConfirm(@RequestParam("data") String list) {
		// System.out.println(list);
		
		
		ArrayList<CartDTO> cList = new ArrayList<CartDTO>();
		
		
		String[] carts = list.split("@@");	// 전체 리스트를 각 주문별로 쪼개기
		for (String cartString : carts) {
			String cart[] = cartString.split("&");	// 각 주문에 대해 속성별로 자르기

			CartDTO cDTO;
			 int num = 0;
			 String userid = "";
			 String gcode = "";
			 String gname = "";
			 int gprice = 0;
			 String bcategory = "";
			 String vcategory = "";
			 int  gamount = 0;
			 String gimage = "";
			
			for (String c : cart) {	// 각 속성별로 변수에 저장
				// System.out.println(c);
				
				String cc[] = c.split("=");
				
				switch (cc[0]) {
				case "num": 
					num = Integer.parseInt(cc[1]);
					break;
				case "userid": 
					userid = cc[1];
					break;
				case "gcode": 
					gcode = cc[1];
					break;
				case "gname": 
					gname = cc[1];
					break;
				case "gprice": 
					gprice = Integer.parseInt(cc[1]);
					break;
				case "bcate": 
					bcategory = cc[1];
					break;
				case "vcate": 
					vcategory = cc[1];
					break;
				case "gamount": 
					gamount = Integer.parseInt(cc[1]);
					break;
				case "image": 
					gimage = cc[1];
					break;
				}
			}
			// dto 만들기
			cDTO = new CartDTO(num, userid, gcode, gname, gprice, bcategory, vcategory, gamount, gimage);
			
			// System.out.println(cDTO);
			
			// 만든 dto 리스트에 추가
			cList.add(cDTO);
		}
		
		System.out.println(cList);
		
		
		return "redirect:../loginCheck/orderForm2";
	}
	

	@RequestMapping(value = "/loginCheck/cartUpdate")
	@ResponseBody
	public void cartUpdate(@RequestParam Map<String, String>map) {
		System.out.println(map); //
		service.cartUpdate(map);
	}
	
	
	
//	@RequestMapping(value = "/goodslist")
//	@ResponseBody
//	public List<GoodsDTO> findgoods(@RequestParam("type")String type,
//			@RequestParam("keyword") String keyword, Model model) {
////		ModelAndView mav = new ModelAndView();
////		mav.setViewName("/goodsList");
////		mav.addObject("goodsList", keyword);
//		
//		GoodsDTO goodsdto = new GoodsDTO();
//		goodsdto.setType(type);
//		goodsdto.setKeyword(keyword);
//		
//		return GoodsService.findgoods(goodsdto);
//		
//	}

}
