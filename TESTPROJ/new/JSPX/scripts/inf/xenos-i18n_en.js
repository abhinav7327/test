//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos.i18n = {
  title: {
    legacy: 'xenos Legacy',
    preferences: 'Preferences',
    passwordChange : 'Change Password'
  },
  message: {
    access_denied: 'Oops, you do not have permission.',
    reset_your_preference : 'Are you sure you want to clear the screen preference?',
    preference_reset_message : 'Screen preference has been cleared',
	preference_reset_error : 'Screen preference cannot be cleared',
    your_session_expired: 'Oops, your session has expired. You will be taken to the login page.',
	// xenos session expires and redirects to error page in case of CA integration
	xenos_error_page: 'Oops, your session has expired. You will be redirected to xenos error page.<br/>You have to relogin through CA Application to access xenos again.',
    save_your_change: 'You have modified data on this page. If you navigate away from this page without saving your change, the modified data will be lost. Save your change?',

    no_record_found_message: 'No Records Found',
    preference_save_message: 'Preference has been saved successfully and all the page open will get reloaded',
    new_user_login:'New user has logged in. Page will be reloaded.',
    preference_save_error: 'Preference could not be saved, Please try again.',
    no_associated_role: 'You do not have any role associate with this result page.',
    feature_not_implemented: 'This feature is not implemented yet.',
    query_saved: 'Query Saved Successfully',
    invalid_namelength: 'Saved Query Criteria name should not exceed {0} characters',
    invalid_amend: 'Selected record cannot be amended',
    invalid_amend_reason: 'Selected record cannot be amended as {0}',
    invalid_cancel: 'Selected record cannot be cancelled',
    invalid_cancel_reason: 'Selected record cannot be cancelled as {0}',
    invalid_reopen: 'Selected record cannot be reopened',
    invalid_reopen_reason: 'Selected record cannot be reopened as {0}',
	invalid_copy: 'Selected record cannot be copied',
    invalid_copy_reason: 'Selected record cannot be copied as {0}',
    invalid_values : 'Please enter a valid value for {0}',
	window_not_supported : 'This window is not supported in this browser.',
	popup_limit_reached : 'Maximum Popup Limit Reached, try closing few popups.',
    xenos_detail_dialog_load_fail : 'Failed to load the data.',
    unsaved_data_alert : 'Some modified data has not yet been saved, Do you want to continue?',
    invalid_entry: 'Selected record is not eligible for entry operation',
	bad_request: 'System doen\'t allow this request, Please contact system administrator',
	reuest_timeout:'Server Too busy. Please try again later.',
	selection_discard: 'Your selection(s) will be discarded. Do you want to continue?',
	password_update:'Please login with your new password',
	network_error: 'Network connection error.',
	excel_preference_save_message: 'Excel Report Prefs saved.',
	excel_preference_reset_message: 'Excel Report Prefs cleared.',
	excel_preference_save_error: 'Preference could not be saved, Please try again.',
	excel_preference_reset_error: 'Preference could not be reset, Please try again.',
	excel_preference_reset_confirm: 'Are you sure, you want to reset excel preference?',
	excel_preference_retrieve_error: 'Could not retrieve excel preference, please try again'
  },
	batchReportQuery:{
		fileunavailable:"Requested file is unavailable at the moment. Please try again after some time.",
		nofilename:"No File Name"
	},
	
	datevalidationmessage :{
			valid_number : 'Enter valid number after',
			valid_date1 : 'The date format should be : MM/DD/YYYY',
			valid_date2 : 'The date format should be : YYYY/DD/MM',
			valid_date3 : 'The date format should be : DD/MM/YYYY',
			valid_date4 : 'The date format should be : YYYY/MM/DD',
			valid_date5 : 'The date format should be : DD-MON-YYYY',
			valid_date6 : 'The date format should be : YYYYMMDD',
			
			incorrect_dateFormat : 'Incorrect date format. Enter as ',
			
			incorrect_dateFormat_month : 'Invalid Month. Enter as ',
			incorrect_dateFormat_day : 'Invalid day. Enter as ',
			incorrect_dateFormat_year : 'Please enter a valid 4 digit year between ',
			incorrect_dateFormat_yearrange : 'Please enter a valid 4 digit year between {0} and {1} . Enter as {2} ',
			incorrect_date   : 'Illegal date format {0}'
	},
	
	
	utilcommonvalidationmessage :{
	
			trade_date: 'TRADE To date must occur after the TRADE from date.',
			value_date: 'VALUE To date must occur after the VALUE from date.',
			non_valid_num: 'Not a valid number.Please try again.',
			obj_not_found : 'Object Not Found : ',
			provide_criteria: 'Please provide Criteria Name',
			duplicate_sort_criteria: 'Duplicate sort criteria specified',
			mandatoryfield_empty:'{0} cannot be empty',
			minimum_item: 'At least one item should remain in the block.',
			principal_amount  :'Prinipal Amount',
			net_amount        :'Net Amount',
			amount            :'Amount',
			rate              :'Rate',
			quantity          :'Quantity',
			exchange_rate     :'Exchange Rate',
			tax_fee_amount    :'Tax/Fee Amount',
			accrued_interest_amount:'Accrued Interest Amount',
			commission_amount : 'Commission Amount',
			price 			  : 'Price' 
	},
	
	utilvalidatormessage :{
	
			null_obj: 'VALIDATOR:isNullObjectValue() : Undefined parameter\n'
	},
	
	accessvalidationmessage :{
			application_closed : 'Online application closed for Module',
			access_restricted : 'Online access restriction validation fails for Module: '
	},
		
	confirmlabel : {
		okButton : '&nbsp;Save&nbsp;',
		cancelButton : '&nbsp;Do not save&nbsp;',
		updateButton : 'Update'
	},
	
	error : {
		not_object 					: 'Not an object',
		invalid_decimalfraction		: '{0} digits are allowed after decimal point',
		invalid_numbersize			: '{0} digits are allowed before decimal point',
		missing_account_no			: 'Account Number is mandatory',
		missing_localAccount_no		: 'Local Account Number is mandatory',
		report_generation 			: 'Sorry, unable to generate report. Refer to the log for detail.',
		generic						: 'Sorry, unable to process request. Refer to the log for detail.',
	
		input_price 		        : 'The number entered in {0} field is too large.',
		decimal_dot_count 	        : 'The decimal separator can occur only once in {0} field.',
		invalid_BMT 			    : 'One of the formatting parameters in {0} field is invalid.',
		invalid_char                : 'The {0} field contains invalid characters.',
		negative_value		        : 'The {0} field may not be negative.',
		invalid_decfraction         : '{0} digits are allowed after decimal point in {1} field',
		invalid_numsize		        : '{0} digits are allowed before decimal point in {1} field'		
	},
	changePassword : {
		missing_current_pass : 'Current Password is mandatory',
		missing_new_pass : 'New Password is mandatory',
		missing_con_pass : 'Confirm Password is mandatory',
		con_pass_equal_new_pass : 'New Password must match with Confirm Password',
		password_update : 'Your password is going to be changed.After that you will be returned to login screen to re-login with the new password',
		current_pass_equal_new_pass : 'New Password cannot be the Current Password'
	}
};
