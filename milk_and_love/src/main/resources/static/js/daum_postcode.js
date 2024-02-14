// 다음 우편번호 서비스(API)
function daumPostcode() {
	new daum.Postcode({
		oncomplete: function(data) {
			// 우편번호, 도로명 주소
			document.getElementById('post_code').value = data.zonecode;
			document.getElementById('road_address').value = data.roadAddress;
			
			// 상세 주소 초기화
			document.getElementById('detail_address').value = "";
			
			// 읍면
			if(data.bname1 != "") {
				document.getElementById('area3').value = data.bname1;
			
			} else { // 동
				document.getElementById('area3').value = data.bname;
			}
			
			// change 이벤트 강제 발생
			$("#post_code").trigger("change");
		}
	}).open();
}
