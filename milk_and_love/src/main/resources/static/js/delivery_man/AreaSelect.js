/**
 * 
 */
class AreaSelect {
	// 셀렉터에 옵션들 추가
	addArea1Select(callback){ 
		$.ajax({
			url: "/load_area1_list_process",
			type: "POST",
			dataType: 'json',
			success: function(data) {
				//console.log(data);
				
				let content = "<option value=''>----- 시도 선택 -----</option>";
				$.each(data, function(index, item) {
					let code = item.CODE.slice(0, 2);
					content += '<option data-code='+code+' value='+item.AREA+'>'+item.AREA+'</option>';
				});
				$("select[name=area1]").html(content);
				
				if(callback){
					callback();
				}
			}
		});
	}
		
	addArea2Select(area1_code, callback){	
		$("select[name=area3]").html("<option value=''>----- 읍면동 선택 -----</option>");
		
		$.ajax({
			url: "/load_area2_list_process",
			type: "POST",
			data: "area1_code=" + area1_code,
			dataType: 'json',
			success: function(data) {
				//console.log(data);
				
				let content = "<option value=''>----- 시군구 선택 -----</option>";
				$.each(data, function(index, item) {
					let code = item.CODE.slice(0, 4);
					content += '<option data-code='+code+' value='+item.AREA+'>'+item.AREA+'</option>';
				});
				$("select[name=area2]").html(content);
				
				if(callback){
					callback();
				}
			}
		});
	}
		
	addArea3Select(area2_code, callback){	
		$.ajax({
			url: "/load_area3_list_process",
			type: "POST",
			data: "area2_code=" + area2_code,
			dataType: 'json',
			success: function(data) {
				//console.log(data);
				
				let content = "<option value=''>----- 읍면동 선택 -----</option>";
				$.each(data, function(index, item) {
					content += '<option data-code='+item.CODE+' value='+item.AREA+'>'+item.AREA+'</option>';
				});
				$("select[name=area3]").html(content);
				
				if(callback){
					callback();
				}
			}
		});
	}
}

export default AreaSelect;
