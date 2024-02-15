/**
 * 
 */
import AreaSelect from './AreaSelect.js';

$(document).ready(function() {
	// 전화번호 정규식
    var phoneReg = /^010\d{8}$/;
	
 	//한글 이름 정규식
    var nameReg = /^[가-힣]{2,5}$/;
	
	// 지역 선택 인풋 박스 생성 클래스
    let areaSelect = new AreaSelect();
	
	// 불러온 배달원의 담당지 변수들
	var area1 = $("#vo_arae1").val().trim();
	var area2 = $("#vo_arae2").val().trim();
	var area3 = $("#vo_arae3").val().trim();
	
    // 셀렉터에 옵션들 추가 후 저장된 데이터로 설정
    areaSelect.addArea1Select(function() {
		
    	$('#area1').val(area1);
    	
    	areaSelect.addArea2Select($('#area1 option:selected').data('code'), function() {
			
    		$('#area2').val(area2);
    		
    		areaSelect.addArea3Select($('#area2 option:selected').data('code'),function() {
				
	    		if(area3){
					$('#area3').val(area3);
				}
			
			});
		});
	});
	
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
	
	// 각 필드의 초기 상태를 저장
	var orginalStates = {};
	$("form input, form select").each(function() {
		orginalStates[this.id] = $(this).val();
	});
				
	//수정 버튼이 눌렸을데 실행하는 스크립튼
	$("#modify_btn").click(function(e) {
	    var isChanged = false;
		var changedStates={};
	    
		// 전화번호 입력란 대한 검증
		if (!phoneReg.test($('#tel_input').val())) {
			alert("전화번호 양식을 확인해주세요.");
            $('#tel').focus();
            return;
        }
		
		// 이름 입력란에 대한 검증
        if (!nameReg.test($('#name_input').val())) {
        	alert("이름을 확인해주세요.");
            $('#name').focus();
            return;
        }
		
	    // 각 필드의 현재 상태를 확인하고 초기 상태와 비교
	    $("form input, form select").each(function() {
	        if (orginalStates[this.id] !== $(this).val()) {
	            isChanged = true;
	            changedStates[this.id] = $(this).val();
	        }
	    });

	    // 하나 이상의 필드가 변경되지 않았다면 폼 전송을 막기
	    if (!isChanged) {
	        e.preventDefault();
	        alert("하나 이상 변경해야합니다.");
	        
	    } else {
	    	
	    	changedStates['id']= $("#id").text();
	    	$.ajax({
		        url: '/modify_delivery_man',
		        type: 'POST',
		        data: JSON.stringify(changedStates),
		        contentType: "application/json",
		        success: function(data) {
		        	if(data == 1){
		        		alert("변경이 완료되었습니다.");
		        	} else{
		        		alert("서버에 문제가 생겼습니다 관리자에게 이야기해주세요.");
		        	}
		        }
			})
	    }
	});
	
	// 목록 버튼 스크립트
	$("#list_btn").click(function(){
		window.location = "/delivery_man/list";
	})
	
})