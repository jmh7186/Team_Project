package com.milk_and_love.vo;

import lombok.Data;

@Data
public class CustomerVO {
	private String id;					// 고객 ID
	private java.sql.Date join_date;	// 가입일자
	private int status;				// 상태 (0: 정상, 1: 해지)
	private String name;				// 이름
	private String tel;					// 연락처 (하이픈(-) 제외)
	private String post_code;			// 우편번호
	private String road_address;		// 도로명 주소
	private String detail_address;		// 상세 주소
	private String area3;				// 읍면동
	private String delivery_man_id;		// 배달 담당자 ID
	private java.sql.Date leave_date;	// 해지일자
}
