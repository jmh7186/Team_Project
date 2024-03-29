/*
	페이지 전체 출력,조회시 페이지 출력,페이지 이동 버튼 메소드가 있는 클래스
	파라매터 해당 페이지 이름,요소를 추가할 테이블 id
	자식 DeliveryManTable, BoardQnATable
*/

class TableBuilder{
	// 생성자
	constructor(pageName,tblId){
		this.pageName = pageName;
		this.tblId = tblId+' tbody';
    }
    
    // 오버라이딩용 행 메소드
    rowContent(pageNo,index, item){};
    
	// 기본 페이지 메소드
	showPage(page) {
				
		var pageNo = parseInt(page)*50-50+1;
		
		var url;
		
		var row;
		
		switch(this.pageName){
			case 'delivery_man':
				url='/delivery_man_page';
				break;
			case 'QnA' :
				url='/QnA_list';
				break;
		}
		
		$.ajax({
	        url: url,
	        type: 'POST',
	        dataType: "json",
	        data: JSON.stringify({'page': page}),
	        contentType: "application/json",
	        success: (data) =>  {
	        	//console.log('성공');
	        	$(this.tblId +" tr:not(:first)").remove();
	        	
	        	//console.log(data);
	        	
	        	if(data.length > 0){
	                $.each(data, (index, item) => {
	                    row = this.rowContent(pageNo, index, item);
		        	    
		        	 	// 모든 데이터를 테이블에 추가
						 $(this.tblId).append(row);
	        		});
		        	 	
		        	
	        	} else {
	        	    // 데이터 행 추가
	        	    row = $("<tr>");
	        	    row.append($("<td>").attr("id", "no_date_td").attr("rowspan", 10).attr("colspan", 9).text('조회된 데이터가 없습니다.'));
	        	    $(this.tblId).append(this.row);
	        	}
		
			}
		});
	}
	
	// 검색기능 메소드
	srech(keyWords,page) {
		
		var pageNo = parseInt(page)*50-50+1;
		
		keyWords['page'] = pageNo;
		
		var url;
		
		var row;
		
		switch(this.pageName){
			case 'delivery_man':
				url='/delivery_man_srech';
				break;
			case 'QnA' :
				url='/QNA_srech';
				break;
		}
		
		$.ajax({
	        url: url,
	        type: 'POST',
	        dataType: "json",
	        data: JSON.stringify(keyWords),
	        contentType: "application/json",
	        success: (data) =>  {
	        	//console.log('성공');
	        	$(this.tblId +" tr:not(:first)").remove();
	        	//console.log(data);
	        	
	        	if(data.length > 0){
	        		$.each(data, (index, item) => {
						//console.log(item);
		        	    row = this.rowContent(pageNo, index, item);
		        	    
		        	 	// 모든 데이터를 테이블에 추가
						$(this.tblId).append(row);
	        		});
		        	 	   	
	        	} else {
	        	    // 데이터 행 추가
	        	    row = $("<tr>");
	        	    row.append($("<td>").attr("id", "no_date_td").attr("rowspan", 10).attr("colspan", 9).text('조회된 데이터가 없습니다.'));
	        	    $(this.tblId).append(row);
	        	}
	        	
			}
		});
	}
	
	// 페이지 이동 메소드
	// 첫번째 페이지 메소드
	
	firstPage(page,searchParams){
		// 페이지를 첫번째 페이지(1)로 설정
		page = 1;
		
		//console.log(page);
		//console.log(searchParams);
		
		$('#page_input').val(page);
		
		if(Object.keys(searchParams).length == 0){
			this.showPage(page);
	    } else{
	    	this.srech(searchParams,page)	
	    }
	    
	    return page;
	};
	
	// 이전 페이지 메소드
	previousPage(page,searchParams) {
		
		if (parseInt(page) != 1) {
			page = parseInt(page)-1;
		}
		//console.log(page);
		//console.log(searchParams);
		$('#page_input').val(page);
		
		if(Object.keys(searchParams).length == 0){
			this.showPage(page);
	    } else{
	    	this.srech(searchParams,page)	
	    }
	    
	    return page;
	};
	
	// 다음 페이지 메소드
	nextPage(page,totalPages,searchParams) {
		
		if (parseInt(page) != parseInt(totalPages)) {
			page = parseInt(page)+1;
		}
		
		//console.log(page);
		//console.log(searchParams);
		
		$('#page_input').val(page);
		
		if(Object.keys(searchParams).length == 0){
			this.showPage(page);
	    } else{
	    	this.srech(searchParams,page)	
	    }
	    
	    return page;
	}
	
	// 마지막 페이지 메소드
	lastPage(page,totalPages,searchParams) {
		page = totalPages;
		
		//console.log(page);
		//console.log(searchParams);
		
		$('#page_input').val(page);
		
		if(Object.keys(searchParams).length == 0){
			this.showPage(page);
	    } else{
	    	this.srech(searchParams,page)
	    }
		
		return page;
	}
    
} 

export default TableBuilder;