import TableBuilder from '../tableBuilder.js';

/*
	배달원 조회 페이지의 배달원 출력 테이블을 비동기 방식으로 생성하는 클래스
	부모 TableBuilder
*/

class DeliveryManTable extends TableBuilder{
	// 생성자
	constructor(pageName,tblId){
		super(pageName,tblId);
	}
	
	// 배달원의 행의 내용을 생성함(오버라이딩)
	rowContent(pageNo,index,item){
		//console.log(pageNo);
		
		var row = $("<tr>");
		
		// 체크박스 필드
	    var checkboxCell = $("<td>").attr("class", "checkbox_td");
	    if (item.status!=2) {
	    	var checkbox = $("<input>").attr("type", "checkbox").attr("class", "checkboxs").attr("name", "delivery_man_checked");
	    	checkboxCell.append(checkbox);
		}
	    row.append(checkboxCell);
	
	    // '번호' 필드
	    row.append($("<td>").attr("class", "no_td").text((pageNo - 1) * 50 + 1 + index));
	
	    // 'ID' 필드
	    var idCell = $("<td>").attr("class", "id_td");
	    var idLink = $("<a>").attr("href", "/delivery_man/view?id=" + item.id).text(item.id);
	    idCell.append(idLink);
	    row.append(idCell);
	    
		//console.log(item.id);
		
	    // '등록일' 필드
	    row.append($("<td>").attr("class", "pw_td").text(item.join_date));
	
	    // '이름' 필드
	    row.append($("<td>").attr("class", "name_td").text(item.name));
	
	    // '연락처' 필드
	    row.append($("<td>").attr("class", "tel_td").text(item.tel));
		
	    // '주소' 필드
	    if (item.area3 != null) {
	    	row.append($("<td>").attr("class", "area_td").text(item.area1+" "+item.area2+" "+item.area3));
		} else {
			row.append($("<td>").attr("class", "area_td").text(item.area1+" "+item.area2));
		}
	    
	    
	 	// '상태' 필드
	    var statusCell = $("<td>").attr("class","status_td");
	    if (item.status == 0) {
	        statusCell.text('대기');
	    } else if (item.status == 1) {
	        statusCell.text('유효');
	    } else {
	        statusCell.text('만료');
	    }
	    row.append(statusCell);
	
	    // '상태 버튼 필드'
	    var approveCell = $("<td>").attr("class", "approve_td");
	    if (item.status == 0) {
	        var approveButton = $("<button>").attr("type", "button").attr("id", "approve_btn").attr("value", "1").text("승인");
	        var refuseButton = $("<button>").attr("type", "button").attr("id", "refuse_btn").attr("value", "2").text("해지");
	        approveCell.append(approveButton);
	        approveCell.append(refuseButton);
	    } else if (item.status == 1) {
	        var refuseButton = $("<button>").attr("type", "button").attr("id", "refuse_btn").attr("value", "2").text("해지");
	        approveCell.append(refuseButton);
	    }
	    
	    row.append(approveCell); 
	    
	    return row;
	}
	
}
export default DeliveryManTable;