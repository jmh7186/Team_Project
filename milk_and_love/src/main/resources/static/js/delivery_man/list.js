/**
 * 
 */
import DeliveryManTable from './dlivery_man_table.js';
import AreaSelect from './AreaSelect.js';

$(document).ready(function() {
	// 오늘 날짜 변수
	var today = new Date().toISOString().substring(0, 10);
	
    //체크된 id를 담을 변수
 	var chaekedIds = [];
    
    // 현재 페이지 변수
    var page = $("#page_input").val();
	
    // 최대 페이지 변수
    var totalPages = $('#totalPages').text().trim();
    
    // 검색할 키워드들을 담은 변수
    var searchParams = {};
    
    // 내용을 추가할 테이블 id 변수
    var tableId = '#deliveryman_tbl';
    
    // 현재 페이지명 변수
    var pageName = 'delivery_man';
    
    // 테이블 생성 클래스
    let tableBuilder = new DeliveryManTable(pageName,tableId);
    
    // 지역 선택 인풋 박스 생성 클래스
    let areaSelect = new AreaSelect();
    
    //console.log(page)
    //console.log(totalPages)
    
    tableBuilder.showPage(page);
     
    // 셀렉터 옵션 비동기로으로 추가
    areaSelect.addArea1Select();
    
    $("select[name=area1]").on("change", function() {
    	let area1_code = $(this).find("option:selected").data("code");
    	//console.log(area1_code);
    	areaSelect.addArea2Select(area1_code);
    });
    
    $("select[name=area2]").on("change", function() {
    	let area2_code = $(this).find("option:selected").data("code");
    	areaSelect.addArea3Select(area2_code);
    });
    
    
    // 달력을 오늘 날짜로 설정하고 오늘날짜 이후로 설정 모하게 하는 스크립트
	// 달력을 오늘 날짜로 수정
    $('#start_day').val(today);
    $('#end_day').val(today);
    
    // max 속성을 오늘로 추가
    $('#start_day').attr('max', today);
    $('#end_day').attr('max', today);
    
    $('.day_btn').click(function() {
    	// 누른 버튼의 아이디 가져오기
        var id = $(this).attr('id');
        var date;
		
        // ID에 따라 날짜를 설정
        if (id === "today") {
            $('#start_day').val(today);
        } else if (id === "oneWeek") {
        	// 일주일 전 설정
            date = new Date();
            date.setDate(date.getDate() - 7); 
            var oneWeek = date.toISOString().substring(0, 10);
            $('#start_day').val(oneWeek);
            
        } else if (id === "oneMonth") {
        	// 한 달 전 설정
            date = new Date();
            date.setMonth(date.getMonth() - 1); 
            var oneMonth = date.toISOString().substring(0, 10);
            $('#start_day').val(oneMonth);
        }
    });
    
    // 조회 버튼 펑션
    $('#search_btn').click(function(){
    	// 객체 초기화
    	searchParams = {};
    	
        $('#search_tbl input, #search_tbl select').each(function() {
            var id = $(this).attr('id');
            var value = $(this).val();
            
            // 라디오 버튼일때 체크된거 하나만 저장
            if ($(this).attr('type') === 'radio') {
            	if ($(this).is(':checked')) {
            		if (value.trim() !== '') {
                        searchParams['status'] = value;
                    }
	            	return;
				} else{
					return;
				}
			}
            
         	// 값이 공백이 아닌 경우에만 저장.
            if (value.trim() !== '') {
                searchParams[id] = value;
            }
        });
        
        //console.log(searchParams);
        
        page = 1;
        
        tableBuilder.srech(searchParams,page);
        
        $.ajax({
	        url: '/delivery_man_maxpage',
	        type: 'POST',
	        dataType: "json",
	        data: JSON.stringify(searchParams),
            contentType: "application/json",
	        success: function(data) {
	        	totalPages = data;
	        	if(totalPages == 0){
        			totalPages = 1;
	        	};
	        	
	        	$('#totalPages').text(totalPages);
	        	$('#page_input').val(page);
	        }
        })
        
    });
    
    
    // 체크박스 전체 선택 해제 펑션
    $('#all_check, .checkboxs').click(function(){
		var checked = $('#all_check').is(':checked');
		
		if(checked){
			$('.checkboxs').prop('checked',true);
		} else{
			$('.checkboxs').prop('checked',false);
		}
	});
    
    // 승인,해지 버튼 펑션
    $(document).on('click', '#approve_btn, #refuse_btn', function() {
        var status = $(this).val();
        var id = $(this).closest("tr").find(".id_td a").text();
        
        //console.log(id)
        //console.log(status)
        if (confirm("해당 배달원의 상태를 변경하시겠습니까?")) {
        	$.ajax({
	            type: "POST",
	            url: "/delivery_man_status_modfiy",
	            dataType: "json",
	            data: JSON.stringify({ id: id, status: status }),
	            contentType: "application/json",
	            success: function(data) {
	                if (data === 1) {
	                    alert("변경이 완료되었습니다.");
	                    
	                    if(Object.keys(searchParams).length == 0){
	                    	showPage(page,tableId);;
	                    } else{
	                    	srech(searchParams,page,tableId)	
	                    }
	                    
	                } else {
	                    alert("서버에 문제가 생겼습니다. 관리자에게 이야기해주세요.");
	                }
	            },
	            error: function(xhr, textStatus, errorThrown) {
	                console.error("에러:", errorThrown);
          		}
    		});
        }
    });
    
    // 선택 승인,해지버튼 펑션
    $('#select_approve_btn, #select_refuse_btn').click(function() {
        var status = $(this).val();
        var checkedIds = []; // checkedIds 변수를 정의하고 빈 배열로 초기화합니다.
		var isChecked = false;
        
        // 체크된 체크박스를 가져옵니다.
        $(".checkboxs:checked").each(function() {
            // 체크된 체크박스의 아이디 값을 가져와 배열에 추가합니다.
            var id = $(this).closest("tr").find(".id_td a").text();
            checkedIds.push(id);
            isChecked = true;
        });

        //console.log(checkedIds);
        
        if (isChecked) {
        	if (confirm("해당 배달원들의 상태를 변경하시겠습니까?")) {
				
	        	$.ajax({
		            type: "POST",
		            url: "/delivery_man_select_status_modfiy",
		            dataType: "json",
		            data: JSON.stringify({ ids: checkedIds, status: status }),
		            contentType: "application/json",
		            success: function(data) {
		                if (data === 1) {
		                    alert("변경이 완료되었습니다.");
		                    if(Object.keys(searchParams).length == 0){
		                    	tableBuilder.showPage(page,tableId);;
		                    } else{
		                    	tableBuilder.srech(searchParams,page,tableId)	
		                    }

		                } else {
		                    alert("서버에 문제가 생겼습니다. 관리자에게 이야기해주세요.");
		                }
		            },
		            error: function(xhr, textStatus, errorThrown) {
		                console.error("에러:", errorThrown);
		            }
		        });	
        	}
		}
        
    });
    
	// 페이지 버튼 펑션들
	
    // 첫번째 페이지 평선
    $('#first_page_btn').click(function() {
    	page = tableBuilder.firstPage(page,searchParams);
    });
    
    // 이전 페이지 펑션
    $('#previous_page_btn').click(function() {
    	page = tableBuilder.previousPage(page,searchParams);
    });
    
    // 다음 페이지 펑션
    $('#next_page_btn').click(function() {
    	page = tableBuilder.nextPage(page,totalPages,searchParams);
    });
    
    // 마지막 페이지 펑션
    $('#last_page_btn').click(function() {
    	page = tableBuilder.lastPage(page,totalPages,searchParams);
    	
    });
    
});