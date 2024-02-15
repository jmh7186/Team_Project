import TableBuilder from "../tableBuilder";

/*
	1대1 문의 페이지의 문의 내역 테이블을 비동기 방식으로 생성하는 클래스
	부모 TableBuilder
*/

class BoardQnATable extends TableBuilder{
	// 생성자
	constructor(pageName,tblId){
		super(pageName,tblId);
	}
	
	// 문의내역 행의 내용을 생성함(오버라이딩)
	rowContent(pageNo,index, item){
		
		var row = $("<tr>");
				
		// 만약 삭제된 답변이면 해당 답변은 출력하지않음
		if (item.is_deleted == 1) {
			return;
		}
		
		// 행 설정
	    row = $("<tr>");

	    // '번호' 필드
	    row.append($("<td>").attr("class", "no_td").text(pageNo + index));

	    
	 	// '제목' 필드
		var titleCell = $("<td>").attr("class", "title_td");
	    var titleLink = $("<a>").attr("href", "/QnA/view?no=" + item.no).text(item.title);
	    titleCell.append(titleLink);
	    row.append(titleCell);
	    
	    // '작성일' 필드
	    row.append($("<td>").attr("class", "date_td").text(item.q_date));
	    
		// '작성자' 필드
	    row.append($("<td>").attr("class", "author_td").text(item.q_author));

	    
	 	// '상태' 필드
	    var statusCell = $("<td>").attr("class","status_td");
	    if (item.status == 0) {
	        statusCell.text('대기');
	    } else {
	        statusCell.text('완료');
	    }
	    
	    row.append(statusCell);
	    
	    
	 	// '답변자' 필드
	    var answererCell = $("<td>").attr("class","answerer_td");
	    if (item.a_author != null) {
	    	answererCell.text(item.a_author)
		} else {
			answererCell.text(' ')
		}
	    
	    row.append(answererCell); 
	    
	    return row;
	    
	};
}

export default BoardQnATable;