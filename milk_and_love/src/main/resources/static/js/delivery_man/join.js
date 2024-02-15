/**
 * 
 */
import AreaSelect from './AreaSelect.js';

$(document).ready(function() {
	// 전화번호 정규식
    var phoneReg = /^010\d{8}$/;
	
 	//한글 이름 정규식
    var nameReg = /^[가-힣]{2,5}$/;
	
	// 지역 선택 인풋 박스 생성 클래스 파일
    let areaSelect = new AreaSelect();
    
	// 초기화 버튼이 눌렸을때 실행
	$("#reset_btn").click(function(e) {
		$("form input, form select").each(function() {
			$(this).val("");
		})
	})
	
	
	// 셀렉터 옵션 비동기로으로 추가
    areaSelect.addArea1Select();
    
	// 시도 셀렉트 박스가 변경되었을때 시군을 해당 시도의 시군으로 변경 하는 펑션
	$("select[name=area1]").on("change", function() {
		let area1_code = $(this).find("option:selected").data("code");
		areaSelect.addArea2Select(area1_code);
	});
	
	// 시군 셀렉트 박스가 변경되었을때 읍,동을 해당 시군의 읍,동으로 변경 하는 펑션
	$("select[name=area2]").on("change", function() {
		let area2_code = $(this).find("option:selected").data("code");
		areaSelect.addArea3Select(area2_code);
	});
	
	// 확인 버튼이 눌렸을때 실행
	$("#confirm_btn").click(function(e) {
		
		var joinDates={};
		
		//from태그 밑의 모든 input과 select의 값을 가져와 검사함
		$("form input, form select").each(function() {
			if (this.id == 'detail_address' || this.id == 'area3') {
				if ($(this).val()) {
					joinDates[this.id] = $(this).val();
				}
			} else {
				if (!$(this).val()) {
					alert("필수 입력항목이 비어있습니다.");
					$(this).focus();
					return false;
				} else {
					joinDates[this.id] = $(this).val();
				}
			}
			
	    });
		
		// 전화번호 입력란 대한 검증
		if (!phoneReg.test($('#tel').val())) {
			alert("전화번호 양식을 확인해주세요.");
            $('#tel').focus();
            return;
        }
		
		// 이름 입력란에 대한 검증
        if (!nameReg.test($('#name').val())) {
        	alert("이름을 확인해주세요.");
            $('#name').focus();
            return;
        }
		
		$.ajax({
	        url: '/new_delivery_man',
	        type: 'POST',
	        data: JSON.stringify(joinDates),
	        contentType: "application/json",
	        success: function(data) {
	        	if(data == 1){
	        		alert("추가가 완료되었습니다.");
	        		$("form input, form select").each(function() {
	        			$(this).val("");
	        		
	        		})
	        		} else{
	        		alert("서버에 문제가 생겼습니다 관리자에게 이야기해주세요.");
	        	}
	        }
		})
		
		
	})
})