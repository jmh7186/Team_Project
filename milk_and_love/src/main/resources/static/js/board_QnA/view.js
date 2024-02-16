$(document).ready(function() {
	
	var a_content = $('#a_content').val();
	
	// 취소 버튼 스크립트
	$("#cancel_btn").click(function(){
		window.location = "/QnA";
	});
	
	
	// 답변 등록 스크립트
	$("#registration_btn").click(function(){
		if (confirm('답변을 등록 하시겠습니까?')) {
			if($('#a_content').val().trim() != "" || $('#a_content').val() != a_content){
			
		
				var anserParams = {};
				
				var no = $('#no').val();
				
				// 관리자 아이디를 저장 하는 부분이 없기에 임시로 admin으로 설정함
				//var managerId = ${admin_id};
				var managerId = 'admin'; // 임시 매니저 아이디
				
				var content = $("#a_content").val();
				
				anserParams['a_author']  = managerId;
				anserParams['a_content'] = content
				anserParams['no'] = no;
				
				$.ajax({
			        url: '/QNA_answer',
			        type: 'POST',
			        dataType: "json",
			        data: JSON.stringify(anserParams),
		            contentType: "application/json",
			        success: function(data) {
			        	if(data == 1) {
			        		alert("답변이 등록 되었습니다.");
			        		location.reload(true);
						} else{
							alert("서버에 오류가 발생하였습니다.");
						}
			        	
			        }
				})
			} else {
				if ($('#a_content').val().trim() == "") {
					alert("답변을 작성 후 등록버튼을 눌러주세요.");
				} else{
					alert("답변을 수정 후 등록버튼을 눌러주세요.")
				}
				
			}
		}
	});
	
	// 문의 삭제 버튼 스크립트
	$("#delete_btn").click(function(){
		if (confirm('정말 삭제 하시겠습니까?')) {
			var no = $('#no').val();
			$.ajax({
		        url: '/QNA_delete',
		        type: 'POST',
		        dataType: "json",
		        data: JSON.stringify({'no': no}),
	            contentType: "application/json",
		        success: function(data) {
		        	if(data == 1) {
		        		alert("삭제가 완료 되었습니다.");
		        		window.location = "/QnA";
					} else{
						alert("서버에 오류가 발생하였습니다.");
					}
		        	
		        }
			})
		}
	});
	

});