//$Id$
//$Author: avisheka $
//$Date: 2016-12-23 15:49:02 $
$(document).ready(function() {
	var onChangeOfficeIdHandler = function(e) {
		var url = xenos.context.path + $('form').attr('action') + '/applRoleList.json?commandFormId='+ $('[name=commandFormId]').val()
		$.ajax({
			type: "POST",
			url: url,
			data : {officeId:$('#officeId').val()},
			beforeSend: function (req) {
				req.setRequestHeader("Accept", "application/json;type=ajax");
			},
			success: function (data) {
					var applRolesList = data.value[0].applRoleNames;
					var officeId = $('#officeId').val();
					$('#selectedApplRoles option').remove();
					var $option = $('<option/>');
					if (!($.trim($('#officeId').val()) == "" || $.trim($('#officeId').val()) == null)){
						$option = $('<option/>');
						$option.attr('value', "").attr('selected','selected').text("");
						$('#selectedApplRoles').append($option);
					}
					$.each(applRolesList, function(index, item){
						$option = $('<option/>');
						$option.attr('value', item.value).text(item.label);
						$('#selectedApplRoles').append($option);
					});
			}
        });
	}
	
	$('#officeId').unbind('change').bind('change', onChangeOfficeIdHandler).trigger('change');
});