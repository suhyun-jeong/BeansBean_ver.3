package com.dto;

import java.sql.Date;

import org.apache.ibatis.type.Alias;

@Alias("ReplyDTO")
public class Item_ReplyDTO {
	private	int replyid;
	private String gcode;
	private String userid;
	private Date regdate;
	private String content;
	private double rating;
	
	public Item_ReplyDTO() {
		super();
		// TODO Auto-generated constructor stub
	}

	public Item_ReplyDTO(int replyid, String gcode, String userid, Date regdate, String content, double rating) {
		super();
		this.replyid = replyid;
		this.gcode = gcode;
		this.userid = userid;
		this.regdate = regdate;
		this.content = content;
		this.rating = rating;
	}

	public int getReplyid() {
		return replyid;
	}

	public void setReplyid(int replyid) {
		this.replyid = replyid;
	}

	public String getGcode() {
		return gcode;
	}

	public void setGcode(String gcode) {
		this.gcode = gcode;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public Date getRegdate() {
		return regdate;
	}

	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public double getRating() {
		return rating;
	}

	public void setRating(double rating) {
		this.rating = rating;
	}

	@Override
	public String toString() {
		return "Item_ReplyDTO [replyid=" + replyid + ", gcode=" + gcode + ", userid=" + userid + ", regdate=" + regdate
				+ ", content=" + content + ", rating=" + rating + "]";
	}
	
}
