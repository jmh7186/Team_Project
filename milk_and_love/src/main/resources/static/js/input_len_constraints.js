// input[type=number] 요소 최대 자릿수 제한
function numberMaxLength(e){
	if(e.value.length > e.maxLength){
		e.value = e.value.slice(0, e.maxLength);
	}
}

