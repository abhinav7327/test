//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos.ns.views.closeoutCancel.validateSubmit = function(){

	var validationMessages = [];
	var selected_value = 0;
		
	$("input:checkbox[name=cancelSelector]:checked").each(function(){
				selected_value++;
			});

    if(selected_value==0){
		validationMessages.push('Please select a closeout trade from list');
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
		return false;}
	else{
		$('.formHeader').find('.formTabErrorIco').css('display', 'none');
		} 
	return true;
}