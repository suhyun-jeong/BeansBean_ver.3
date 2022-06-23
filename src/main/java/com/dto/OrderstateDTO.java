package com.dto;

import org.apache.ibatis.type.Alias;

@Alias("OrderstateDTO")
public class OrderstateDTO {
	
	private int num;
	private String o_state;
	private String re_issue;
	private String post;
	private String addr1;
	private String addr2;
	private String delivery_co;
	
	public OrderstateDTO() {
		super();
	}
	public OrderstateDTO(int num, String o_state, String re_issue, String post, String addr1, String addr2,
			String delivery_co) {
		super();
		this.num = num;
		this.o_state = o_state;
		this.re_issue = re_issue;
		this.post = post;
		this.addr1 = addr1;
		this.addr2 = addr2;
		this.delivery_co = delivery_co;
	}

	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public String getO_state() {
		return o_state;
	}
	public void setO_state(String o_state) {
		this.o_state = o_state;
	}
	public String getRe_issue() {
		return re_issue;
	}
	public void setRe_issue(String re_issue) {
		this.re_issue = re_issue;
	}
	public String getPost() {
		return post;
	}
	public void setPost(String post) {
		this.post = post;
	}
	public String getAddr1() {
		return addr1;
	}
	public void setAddr1(String addr1) {
		this.addr1 = addr1;
	}
	public String getAddr2() {
		return addr2;
	}
	public void setAddr2(String addr2) {
		this.addr2 = addr2;
	}
	public String getDelivery_co() {
		return delivery_co;
	}
	public void setDelivery_co(String delivery_co) {
		this.delivery_co = delivery_co;
	}

	@Override
	public String toString() {
		return "OrderstateDTO [num=" + num + ", o_state=" + o_state + ", re_issue=" + re_issue + ", "
				+ "post=" + post + ", addr1=" + addr1 + ", addr2=" + addr2 + ", "
				+ "delivery_co=" + delivery_co + "]";
	}
}
