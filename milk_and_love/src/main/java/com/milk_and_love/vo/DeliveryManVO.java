package com.milk_and_love.vo;

import java.sql.Date;

import lombok.Data;

@Data
public class DeliveryManVO {
	private String id;
	private String pw;
	private Date join_date;
	private int status;
	private String name;
	private String tel;
	private String post_code;
	private String road_address;
	private String detail_address;
	private String area1;
	private String area2;
	private String area3;
	private Date expired_date;
}
