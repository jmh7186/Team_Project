package com.milk_and_love.vo;

import java.sql.Date;

import org.springframework.data.relational.core.mapping.Column;

import lombok.Data;

@Data
public class DeliveryVO {
	String no;
	Date due_date;
	String customer_id;
	String delivery_man_id;
	@Column("status")
	String d_status;
	String customer_status;
	
	String customer_name;
	String customer_tel;
	String address;
}
