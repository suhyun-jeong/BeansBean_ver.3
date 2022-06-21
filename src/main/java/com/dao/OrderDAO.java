package com.dao;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.dto.BundleDTO;
import com.dto.OrderinfoDTO;

@Repository
public class OrderDAO {

	@Autowired
	SqlSessionTemplate session;

	// 상품 한 개 주문하기
	public int oneGoodsOrder(OrderinfoDTO oiDTO) {
		return session.insert("OrderMapper.oneGoodsOrder", oiDTO);
	}

	// 도매 상품의 가격 가져오기
	public BundleDTO getBPrice(String gcode) {
		return session.selectOne("OrderMapper.getBPrice", gcode);
	}

	/**********************/
	/* 관리자 기능 */
	
	// 모든 주문 내역 가져오기
	public List<OrderinfoDTO> getOrders() {
		return session.selectList("OrderMapper.getOrders");
	}
	
}
