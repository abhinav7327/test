//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $




function validateEmpPassword()
{
	var msgStr="";
	
	if (!validateCurrentPassword()) {
		msgStr+= "o Current Password Can Not Be Empty.\n";	
	}
	
	if(!validateUpdatePassword()){		
		msgStr+= "o New Password/ Confirm Password Combination Not Valid .\n";		
	}
	
	if (trim(msgStr).length>0)
	{
		alert(msgStr);
		return false;
	}
	return true;
}

/*
* validate defaultOffice
*/
function validateOfficeId()
{
	if (trim(document.getElementById('emppage.defaultOfficeStr').value).length==0 )
	{		
		return false;
	}else{
		return true;
	}
}

$(function(){
	xenos.ns.empChangePassword = {
		xenos$handler$empChangePassword: xenos$Handler$function({
			get: {
				requestType: xenos$Handler$default.requestType.asynchronous,
				target: function(e) {
					return $('#content');
				}
			},
			settings: {
				beforeSend: function(request) {
					request.setRequestHeader('Accept', 'text/html;type=ajax');
				},
				success: function (data) {
					window.location.reload(true);
				},
				type: 'POST'
			}
		}),
	
		okhandler : function(e){
			var context = $(e.target).closest('#formActionArea');
			xenos.ns.empChangePassword.xenos$handler$empChangePassword.generic(e, {
				requestUri: xenos.context.path + '/resources/j_spring_security_logout',
			});
		}
	}
});