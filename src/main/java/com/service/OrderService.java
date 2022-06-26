package com.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dao.OrderDAO;
import com.dto.BundleDTO;
import com.dto.OrderinfoDTO;
import com.dto.OrderstateDTO;

@Service
public class OrderService {
	
	@Autowired
	OrderDAO dao;
	
	// 상품 한 개 주문하기 - orderinfo 테이블에 레코드 추가
	public int oneGoodsOrder(OrderinfoDTO oiDTO) {
		return dao.oneGoodsOrder(oiDTO);
	}

	// 도매 상품의 가격 가져오기
	public BundleDTO getBPrice(String gcode) {
		return dao.getBPrice(gcode);
	}
	
	/**********************/
	/* 관리자 기능 */
	
	// 상품 한 개 주문하기 - orderstate 테이블에 레코드 추가
	public int oneOrderState(OrderstateDTO osDTO) {
		return dao.oneOrderState(osDTO);
	}
	
	// 모든 주문 내역 가져오기
	public List<OrderinfoDTO> getOrders() {
		return dao.getOrders();
	}
	
	// 모든 주문 관리 내역 가져오기
	public List<OrderstateDTO> getOrderStates() {
		return dao.getOrderStates();
	}

	// 주문 처리 상태 변경
	public int changeOrderstate(Map<String, Object> map) {
		return dao.changeOrderstate(map);
	}

	// 주문 번호로 주문 내역 검색
	public OrderinfoDTO getOrderByNum(int num) {
		return dao.getOrderByNum(num);
	}

	// 주문 번호로 주문 처리 상태 검색
	public OrderstateDTO getOrderstateByNum(int num) {
		return dao.getOrderstateByNum(num);
	}

	// 주문 반려 사유 업데이트
	public int updateReIssue(Map<String, Object> map) {
		return dao.updateReIssue(map);
	}
	
}
