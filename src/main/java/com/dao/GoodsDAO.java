package com.dao;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import java.util.List;


import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;


import com.dto.BundleDTO;
import com.dto.CartDTO;
import com.dto.GoodsDTO;
import com.dto.VariationDTO;

import com.dto.GoodsDTO;


@Repository
public class GoodsDAO {
	@Autowired
	SqlSessionTemplate session;

	public List<GoodsDTO> goodsList(String gcategory) {
		// TODO 상품목록 보기
		List<GoodsDTO> list = session.selectList("GoodsMapper.goodsList", gcategory);
//		System.out.println(list);
		return list;
	}

	public GoodsDTO goodsDetail(String gcode) {
		// TODO GoodsDTO
		GoodsDTO dto = session.selectOne("GoodsMapper.goodsDetail", gcode);
		return dto;
	}

	public List<BundleDTO> bundleDetail(String gcode) {
		// TODO BundleDTO
		List<BundleDTO> list = session.selectList("GoodsMapper.bundleDetail", gcode);
		return list;
	}

	
	public List<VariationDTO> variationDetail(String gcode) {
		// TODO VariationDTO
		List<VariationDTO> list = session.selectList("GoodsMapper.variationDetail", gcode);
		return list;
	}
	
	public void cartAdd(CartDTO cart) {
		int n = session.insert("GoodsMapper.cartAdd", cart);	
		System.out.println(n);
	}
	
	public void cartUpdate(Map<String, String> map) {
		int n = session.update("GoodsMapper.cartUpdate", map);
		
	}
	public void cartDelete(int num) {
		int n= session.delete("GoodsMapper.cartDel", num);
		
	}
	public void delAllCart(ArrayList<String> list) {
		int n = session.delete("GoodsMapper.cartAllDel", list);
		
	}

	public List<CartDTO> cartList(String userid) {
		List<CartDTO> list = session.selectList("GoodsMapper.cartList", userid);
		return list;
	}

	// 남은 재고 계산하여 goods 테이블 업데이트
	public int updateAmount(HashMap<String, Object> oiMap) {
		return session.update("GoodsMapper.updateAmount", oiMap);
	}

	public List<GoodsDTO> findgoods(GoodsDTO goodsdto) {
		
		return session.selectList("GoodsMapper.findgoods", goodsdto);
	}

	
}
