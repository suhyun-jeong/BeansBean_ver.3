package com.dto;

import org.apache.ibatis.type.Alias;

@Alias("GoodsDTO")
public class GoodsDTO {
	private String gcode;
	private String gcategory;
	private String gname;
	private int gprice;
	private int gamount;
	private String gimage;
	
	private String condition;
	private String keyword;
	
	
	

	public GoodsDTO() {
		super();
		// TODO Auto-generated constructor stub
	}

	public GoodsDTO(String gcode, String gcategory, String gname, int gprice, int gamount, String gimage, String condition,
			String keyword) {
		super();
		this.gcode = gcode;
		this.gcategory = gcategory;
		this.gname = gname;
		this.gprice = gprice;
		this.gamount = gamount;
		this.gimage = gimage;
		this.condition = condition;
		this.keyword = keyword;
	}
	@Override
	public String toString() {
		return "GoodsDTO [gcode=" + gcode + ", gcategory=" + gcategory + ", gname=" + gname + ", gprice=" + gprice
				+ ", gamount=" + gamount + ", gimage=" + gimage + "]";
	}
	public String getGcode() {
		return gcode;
	}
	public void setGcode(String gcode) {
		this.gcode = gcode;
	}
	public String getGcategory() {
		return gcategory;
	}
	public void setGcategory(String gcategory) {
		this.gcategory = gcategory;
	}
	public String getGname() {
		return gname;
	}
	public void setGname(String gname) {
		this.gname = gname;
	}
	public int getGprice() {
		return gprice;
	}
	public void setGprice(int gprice) {
		this.gprice = gprice;
	}
	public int getGamount() {
		return gamount;
	}
	public void setGamount(int gamount) {
		this.gamount = gamount;
	}
	public String getGimage() {
		return gimage;
	}
	public void setGimage(String gimage) {
		this.gimage = gimage;
	}

	public String getcondition() {
		return condition;
	}

	public void setcondition(String type) {
		this.condition = type;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	
	
	
	
}
