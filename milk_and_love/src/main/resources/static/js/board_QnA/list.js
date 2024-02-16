import BoardQnATable from "./board_QnA.js";


$(document).ready(function() {
	
	// 현재 페이지 변수
    var page = $("#page_input").val();
	
    // 최대 페이지 변수
    var totalPages = $('#totalPages').text().trim();
	
	// 검색 데이터 저장 변수
    var searchParams = {};
	
	// 내용을 추가할 테이블 id 변수
    var tableId = '#qna_tbl';
    
    // 현재 페이지명 변수
    var pageName = 'QnA';
	
	// 테이블 생성 클래스
	let tableBuilder = new BoardQnATable(pageName,tableId);
	
	// 페이지를 동적으로 추가
	tableBuilder.showPage(page);
	
	//console.log(page);
	
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
        //console.log(page);
        page = 1;
        
        tableBuilder.srech(searchParams,page);
        
        $.ajax({
	        url: '/QNA_srech_maxpage',
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
	
	
	// 페이징 버튼 펑션들
	
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
		console.log(searchParams);
    	page = tableBuilder.nextPage(page,totalPages,searchParams);
    });
    
    // 마지막 페이지 펑션
    $('#last_page_btn').click(function() {
    	page = tableBuilder.lastPage(page,totalPages,searchParams);
    });
	
});