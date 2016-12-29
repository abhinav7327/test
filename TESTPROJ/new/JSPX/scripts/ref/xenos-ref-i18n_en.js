//$Id$
//$Author: himanshum $
//$Date: 2016-12-26 22:38:44 $

xenos$REF$i18n = {
  dashboard:{
	  no_record_found						: 'No record selected for rejection.',
	  no_record_for_rejection				: 'Rejected record(s) cannot be rejected again.'  
  },
  required_fields_empty_alert 			: 'Some modified data has not yet been saved, Do you want to continue?',
  authorization: {
	  common : {
		  empty_record					:	'No record selected for authorization',
		  rejected_record				:	'Rejected record(s) cannot be authorized.',
		  authorized_records            :   'Authorized record(s) cannot be further authorized.',
		  no_record_for_authorization   :   'Authorized record(s) cannot be rejected.'
	  }
  },
  account: {
		common : {
			accountno_empty 			: 'Account No can not be empty',
			addressid_empty 			: 'Address Id can not be empty',
			calculation_method_empty	: 'Calculation Method cannot be empty.',
			issue_country_empty 		: 'Issue Country cannot be empty.',
			instrument_type_empty		: 'Instrument Type cannot be empty.',
			security_type_empty         : 'Security Type can not be empty.',
			buy_sell_empty 				: 'Buy/Sell cannot be empty.',
			start_date_empty 			: 'Start Date cannot be empty.',
			rate_empty 					: 'Rate cannot be empty.',
			rate_type_empty 			: 'Rate Type cannot be empty.',
			amount_empty				: 'Amount cannot be empty.',
			unit_empty 					: 'Unit cannot be empty.',
			table_id_slidingid_empty	: 'TableId for Sliding cannot be empty.',
			table_id_slidingprc_empty	: 'TableId for Sliding Price cannot be empty.',
			start_date_after_end_date	: 'End Date cannot occur before Start Date.',
			one_field_required 			: 'Please enter at least one field except Address Id.',
            one_field_required_except_addressid_and_returned_status         : 'Please enter at least one field except Address Id and Returned Status.',
			repid_grpid_reqd 			: 'Either Report Name or Group Report Name is mandatory.',
			command_id_empty			: 'Query Screen Command Id missing.',
			close_reason_cannot_empty	: 'Close Reason can not be blank.',
			reopen_reason_cannot_empty  : 'Reopen Reason can not be blank.',
			table_id_slidingpa_empty	: 'TableId for Sliding Principal Amount cannot be empty.',
			fund_code_blank				: 'Fund Code cannot be empty.',
			fund_name_blank 			: 'Fund Name cannot be empty.',
			lm_office_blank 			: 'Office(LM) cannot be empty.',
			fund_category				: 'Fund Category cannot be empty.',
			base_curr_blank 			: 'Base Currency cannot be empty.',
			lm_position_custody			: 'LM Position Custody cannot be empty.',
			icon_reqd_blank				: 'Icon Required cannot be empty.',
			cash_viewer_blank 			: 'Cash Viewer Required cannot be empty.',
			gems_required				: 'Gems Required cannot be empty.',
			form_required 				: 'Forma Required cannot be empty',
			short_name_reqd				: 'Short Name cannot be empty.',
			office_name_reqd			: 'Official Name 1st line cannot be empty.',
			fin_inst_reqd				: 'Fin Inst Code cannot be empty.',
			stl_curr_empty				: 'Settlement Currency can not be empty',
			forex_curr_empty			: 'Forex Currency can not be empty',
			fin_inst_code				: 'ID can not be empty',
			rcv_BIC_length				: 'Receiver BIC Code should be 11 digits',
			copy_inst_type 				: 'Copy Instruction Type should be specified as long as Receiver BIC is specified',
			account_no_empty			: 'Account No. cannot be empty',
			user_id_empty				: 'User Id cannot be empty.',
			charSet_code_empty			: 'Charset code cannot be empty',
            serviceoffice_empty         : 'Please specify Service Office first and then add Broker Og code info',
            brokerogcode_empty          : 'Broker Og Code cannot be empty',
            start_date_invalid          : 'Invalid Rule Start Date specified',
            end_date_invalid            : 'Invalid Rule End Date specified',
			taxFee_incl_empty			: 'TaxFee Inclusion cannot be empty.',
			fbif_empty					: 'FBP IF Required cannot be empty.',
			receivebiccopy				: 'Receiver BIC should be specified as long as Copy Instruction Type is specified',
			invalid_start_end_date		: 'Invalid Start-Close Date Range Specified',
			service_office_empty		: 'Service Office cannot be empty.',
			fund_code_empty				: 'Fund Code cannot be empty.',
			broker_code_blank			: 'For FUND, broker code must be empty',
			long_short_empty			: 'For FUND Account, Long/Short Flag cannot be empty',
			prime_broker_empty			: 'Prime Broker Account No cannot be empty for Long/Short Flag "Short".',
			broker_code_empty			: 'Broker code cannot be empty'
		},
		commission : {
			commissionid_empty : 'Commission Id/Name cannot be empty.'			
		},
		restriction : {
			restrictionid_empty : 'Restriction ID/Name cannot be empty.',
			restrictionflag_empty : 'Restriction Status cannot be empty.'
		},
		withholdtax : {
			taxid_empty : 'Tax ID/Name cannot be empty.'
		},
		address :{
			addresstype_empty : 'Address Type can not be empty.',
			contactnumber_empty     : 'Contact Number cannot be empty for a given Contact Type',
			contactnumber_numeric   : 'Invalid Contact Number specified',
			automanualflag_empty 		: 'Auto Manual Flag can not be empty.'
		},
		eadderess : {
			automanualflag_empty : 'Auto Manual Flag can not be empty.',
			swiftcodelen_req     : 'Swift Code length should be 11',
			swiftcodealpha_req   : 'Swift Code should be alphanumeric' 
		},
		docinfo : {
			servicename_empty   : 'Service Id can not be empty',
			servicestatus_empty : 'Service Status can not be empty',
            greatterFileSize 	: 'The file size cannot be larger than 2 MB',
            invalidFileType 	: 'Only PDF or a image file can be uploaded',
            emptyDocRefNo 		: 'The Document Ref No can not be empty if file is selected',
            emptyDocFile 		: 'File must be selected to upload if Document Ref No is given'
		},
		xrefinfo : {			
			shortname_empty				: 'Account Name (short) can not be empty.',
			officialname_empty			: 'Official Name 1st Line can not be empty.',
			beneficiaryname_empty       : 'Benificiary name can not be empty.',
			charsetcode_empty			: 'Language Code can not be empty.',
			accountnotype_empty			: 'Account No Type can not be empty',
			salesoffice_empty			: 'Sales Office can not be empty.',
			salescode_empty				: 'Sales Code can not be empty.',
			salesrole_empty				: 'Sales Role can not be empty.',
			marginAccountFlag_yes	    : 'Market For Margin A/C should not be empty while Is Margin A/C is Yes.',
			marginAccountFlag_no		: 'Market For Margin A/C should be empty while Is Margin A/C is Blank/No.',
			dir_name					: 'Name in Authorised Person Details cannot be empty.',
			uid_type_no					: 'UID Type - No. in Authorised Person Details cannot be empty.',
			address_id					: 'Address Id in Authorised Person Details cannot be empty.',
			agent_code_empty			: 'Agent Code can not be empty.'
			
		},
		generalinfo : {
			groupaccount_empty			: 'Group Account Flag can not be empty.',
			bankAccountType_empty       : 'Bank Account Type can not be empty.', 
			residentcountry_empty		: 'Resident Country can not be empty.',
			contractcountry_empty		: 'Contract Country can not be empty.',
			nationality_empty			: 'Nationality can not be empty.',
			taxid_reqd                  : 'Tax id allows only 0-9',
			short_name                  : 'Short Name in Joint Holder Det. cannot be empty.',
			official_name               : 'Official Name in Joint Holder Det. cannot be empty.',
			address_id					: 'Address Id in Joint Holder Det. cannot be empty.',
			joint_holder_no				: 'Joint Holder No. cannot be empty',
			uid_type_without_no			: 'UID Type and UID-No. both are required together.',
			invalid_joint_acc_no		: 'Joint A/c No allows only 01 to 99'
		},
		verifierDetail : {
			verifierDetails_notEmpty	: 'Verifier Details should be empty for Non Client Account'
		},
        broker : {
            serviceoffice_empty         : 'Please specify Service Office first and then add Broker Og code info',
            brokerogcode_empty          : 'Broker Og Code cannot be empty'
        },
        close : {
        	error_empty_reasoncode : 'Reason Code can not be empty.'
        }
	},
	customer: {
			common : {
				customercode_empty 			: 'Customer Code cannot be empty',
				addressid_empty 			: 'Address Id cannot be empty',
				calculation_method_empty	: 'Calculation Method cannot be empty.',
				issue_country_empty 		: 'Issue Country cannot be empty.',
				instrument_type_empty		: 'Instrument Type cannot be empty.',
				buy_sell_empty 				: 'Buy/Sell cannot be empty.',
				start_date_empty 			: 'Start Date cannot be empty.',
				rate_empty 					: 'Rate cannot be empty.',
				rate_type_empty 			: 'Rate Type cannot be empty.',
				amount_empty				: 'Amount cannot be empty.',
				unit_empty 					: 'Unit cannot be empty.',
				table_id_slidingid_empty	: 'TableId for Sliding cannot be empty.',
				table_id_slidingprc_empty	: 'TableId for Sliding Price cannot be empty.',
				start_date_after_end_date	: 'End Date cannot occur before Start Date.',
				one_field_required 			: 'Please enter at least one field except Address Id.',
				repid_grpid_reqd 			: 'Either Report Name or Group Report Name is mandatory.'
			},
			restriction : {
				restrictionid_empty   		: 'Restriction Id/Name cannot be empty.',
				restrictionflag_empty 		: 'Restriction Status cannot be empty.'
			},
			address :{
				addresstype_empty 			: 'Address Type cannot be empty.',
				telecontactnumber_empty     : 'Contact Number cannot be empty for a given Contact Type',
				telecontactnumber_numeric   : 'Invalid Contact Number specified',
				automanualflag_empty 		: 'Auto Manual Flag can not be empty.'
				
			},
			eadderess : {
				automanualflag_empty 		: 'Auto Manual Flag cannot be empty.',
				swiftcodelen_req     		: 'Swift Code length should be 11',
				swiftcodealpha_req   		: 'Swift Code should be alphanumeric' 
			},
			docinfo : {
				servicename_empty   		: 'Service Name/Id cannot be empty',
				servicestatus_empty 		: 'Service Status cannot be empty',
            	greatterFileSize 			: 'The file size cannot be larger than 2 MB',
            	invalidFileType 			: 'Only PDF or a image file can be uploaded',
            	emptyDocRefNo 				: 'The Document Ref No can not be empty if file is selected',
            	emptyDocFile 				: 'File must be selected to upload if Document Ref No is given'
			},
			xrefinfo : {			
				shortname_empty				: 'Customer Name (short) cannot be empty.',
				officialname_empty			: 'Official Name cannot be empty',
				charsetcode_empty			: 'Language Code cannot be empty.',
				customercodetype_empty		: 'Customer Code Type cannot be empty'
			},
			generalinfo : {
				groupaccount_empty						: 'Group Account Flag cannot be empty.',
				residentcountry_empty					: 'Resident Country cannot be empty.',
				contractcountry_empty					: 'Contract Country cannot be empty.',
				nationality_empty						: 'Nationality cannot be empty.',
				uidno_empty								: 'UID No. cannot be empty.',
				taxid_reqd                  			: 'Tax id allows only 0-9',
                residentcountry_us_tax_id_type          : 'For US/USA based client Tax Id Type and Tax Id must not be empty',
				taxid_taxidtype_occurrence              : 'Tax Id and Tax Id Type should come Simultaneously',
				taxid_lenth_9char                       : 'Tax Id should be of 9 characters',
				brk_info_empty				            : 'Blank Value for All Fields can not be added',
				brk_info_notallowed                     : 'Broker Information cannot be added or updated when Registered with Other Broker is "No" ',
				brk_flag_blank                     		: 'Broker Information cannot be added or updated when Registered with Other Broker is Blank '
			},
			dirinfo:
			{
				dir_uidno_empty						: 'UID Type and UID No. can not be Blank in Director Info',
				address_id							: 'Address Id in Director Info cannot be empty.'
			}
	},
	fininst : {
		common : {
			eaddress_eligible : 'Only required when Firm maintains account.'
		},
		general:{
			finInstCodeType_empty 		: 'Code Type can not be empty.',
			finInstCode_empty 			: 'Please enter Financial Institution Code',
			finInstCode_numeric 		: 'Code should be numeric',
			finInstCode_alphanumeric 	: 'Code should be alphanumeric',
			finInstCode_9_length 		: 'Code should be of 9 digit',
			finInstCode_7_length		: 'Code should be of 7 digit.',
			finInstCode_11_length 		: 'Code should be of 11 digit',
			shortname_empty				: 'Please enter Short Name.',
			officialname_empty			: 'Please enter Official Name1. ',
			charsetcode_empty			: 'Please enter Charset Code',
			institution_role_empty		: 'Please enter at least one Role Definition.',
			country_code_empty			: 'Please enter Country Code.',
			parent_role_code_empty		: 'Parent role code can not be empty .',
			default_official_name_1_empty : 'Please enter Default Official Name1.',
			default_short_name_empty : 'Please enter Default Short Name.'
		},
		eadderess:{
			addressid_empty 			: 'Address Id can not be empty',
			one_field_required 			: 'Please fillup at least one Electronic address entry field.',
			automanualflag_empty 		: 'Auto Manual Flag can not be empty',
			swiftcodelen_req     		: 'Swift Code length should be 11',
			swiftcodealpha_req			: 'Swift Code should be alphanumeric.',
			repid_grpid_reqd 			: 'Either Report Id or Group Report Id is mandatory',
			addresstype_empty 			: 'Address Type can not be empty'
		},
		query : {
			date_from_to_check : 'From Date should be less than To Date.',
			date_format_of_to_date_check : 'Invalid To Date.',
			date_format_of_from_date_check : 'Invalid From Date.'
		}
	},	
	accountDocumentQuery : {
		validation : {
			compulsary_field : 'Document status can not be empty.'
		}	
	},	
	accountQuery:  {
	      transaction_limit  : 'Transaction Limit',
	      date_format_of_from_date_check : 'Illegal date format ',
	      date_format_of_to_date_check : 'Illegal date format ',
	      date_from_to_check : 'From Date should be less than To Date.'
		  },
	country :{
		countryGeneral :{
			countryOfficialName_empty    : 'Country official name can not be empty'
		},
		countryCodeInfo:{
			countryCodeType_empty       : 'Country code type can not be empty',
			countryCode_empty           : 'Country code can not be empty'
			
		},
		countryStateInfo:{
			countryStateCode_empty       : 'Country state code  can not be empty',
			countryOfficialName_empty    : 'State official name can not be empty'
			
		}
	},
	employee : {
		
		officeid_empty 			: 'Office Id can not be empty',
		approles_empty 			: 'Application Roles can not be empty',
		defaultOffice_empty		: 'Default Office Cannot Be Empty',
		userId_empty			: 'User Id is Missing',
		firstName_empty			: 'First Name is Missing',
		lastName_empty			: 'Last Name is Missing',
		startdate_empty			: 'Start date is Missing',
		password_empty			: 'Initial Password is Missing',
		passwordcurrent_empty	: 'Current Password can not be empty',
		passwordnew_empty		: 'New Password can not be empty',
		confirmPassword_empty	: 'Re - Type Initial Password is Missing',
		matchPassword			: 'Password/Confirm Password Combination Not Valid',
		strategyCode_empty		: 'Strategy Code can not be empty',
		matchPassword			: 'New Password and Confirm Password did not match',
		emp_close_reason_cannot_empty : 'Close Reason can not be blank.',
		acRestriction_empty		:  'A/C Restriction can not be empty.',
		officeGrid_empty		:  'Please add at least one office in Office ID.',
		illegal_start_date      :  'Illegal date format {0}'
	},
	
	employeeQuery:  {
	      default_office_empty  : 'Please select Default Office.',
		  illegal_startdate_fromat : 'Illegal Start Date format',
		  illegal_lastaccessdate_fromat : 'Illegal Last Access Date format'
	},	
	
	grouping :{
	    groupCodeInfo :{
	        groupCodeType_empty          :  'Group Code Type Can Not Be Empty',
	        groupCode_empty              :  'Group Code Can Not Be Empty'  
	     
	    },
	    customerInfo :{
	        customerCode_empty			 :  'Customer Code Can Not Be Empty'
	   
	   },
	  accountInfo    :{ 
	        accountNo_empty				 :  'Account No Can Not Be Empty'
	  
	  },
	  defaultGroupNameInfo  :{
	        groupName_empty				 :  'Group Name Can Not Be Empty',
			roleDef_empty				 :  'Role Definition Can Not Be Empty',
			groupCodeInfo_empty			 :	'The Group Code Info Can Not Be Empty',
			actNo_custCode_empty		 :	'The Account Info and Customer Info Both Can Not Be Empty'
	     
	  }
	   
	   
	    	
	},
	instrument: {
		
		date_from_to_check : 'From Date should be less than To Date.',		
		date_format_check : 'Illegal date format {0}',		
		category_values : 'Only one of categoryType and categoryId can\'t be set. It should be both or none.',
		
		common: {
			invalid_number		: 'Please Enter a Valid number',
			invalid_component	: 'Invalid component ID [{0}] is specified.',
			invalid_decimalfraction		: '{0} digits are allowed after decimal point',
			invalid_numbersize	:	'{0} digits are allowed before decimal point'
		},
		generalinfo: {
			instrumentcode_empty		:	'Please enter a valid Instrument Code',
			instrumentcodetype_empty	:	'Instrument type cannot be empty',
			categorytype_empty			:	'Please enter a valid Category Type',
			categoryid_empty			:	'Please enter a valid Category Id',
			shortname_empty				:	'Please enter a valid Instrument Short Name',
			officialname_empty			:	'Please enter a valid Instrument official Name',
			instrumentcodetype_required	:	'Please enter an Instrument Type',
			defaultshortname_required	:	'Instrument Short Name cannot be empty.',
			defaultofficialname_required:	'Instrument Official Name cannot be empty.',
			one_instrument_code_required:	'Please enter at least one Instrument Code',
			contract_size               :   'Contract Size',
			contractsizeempty           :   'Contract Size cannot be empty',
			countrycodeempty            :   'Country Code cannot be empty',
			investmentcountrycodeempty  :   'Investment Country Code can not be empty',
			issuecurrenceempty          :   'Issue Currency cannot be empty',
			displaysequenceempty        :   'Display Sequence cannot be empty',
			minimumtradeunitempty       :   'Minimum Trading Unit cannot be empty',
			listidempty                 :   'Listed Id cannot be empty',
			pricetypeempty              :   'Price Type cannot be empty',
			instrumentshortnameempty    :   'Instrument Short Name cannot be empty',
			officialintrumentnameempty  :   'Official Instrument Name cannot be empty',
			instrumenttypeempty         :   'Instrument Type cannot be empty',
			mtu                         :   'Minimum Trading Unit',
			lang_code_blank				:	'Please enter language code',
			listed_date_error			:	'Please enter a valid Listed Date',
			delisted_date_error			:	'Please enter a valid Delisted Date',
			auction_date_error			:	'Please enter a valid Auction Date'
		},
		other:{
			settlingmonth_empty			:	'Please enter a valid record month (settling month).',
			settlingday_empty			:	'Settling Day not entered. \nNULL Settling Day means last day of {0} {1}/{2}',
			market_empty				:	'Please enter a valid Market',
			markettype_empty			:	'Please enter a valid Market Type',
			csd_empty					:	'Please enter a valid CSD',
			setlprohibiteddate_empty	:	'Please enter a valid settlement prohibited date',
			ratingagency_empty			:	'Please enter a valid Rating Agency',
			rating_empty				:	'Please enter a valid Rating',
			callstartdate_empty			:	'Please enter a valid Call Start date',
			call_end_date				:	'Please enter a valid Call End date',
			callenddate_empty			:	'Call End Date cannot be empty',
			callprice_empty				:	'Call Price cannot be empty',
			compliance_empty			:	'Please enter a valid Compliance',
			underwriter_empty			:	'Please enter a valid UnderWriter',
			reopen_date_error			:	'Please enter a valid Re-open Date',
			IPOpayment_date_error		:	'Please enter a valid IPO Payment Date',
			publicofficestart_date_error:	'Please enter a valid Public Office Start Date',
			publicofficeend_date_error	:	'Please enter a valid Public Office End Date'
		},
		bonddetails:{
			paymentmonth_empty						:	'Please enter a valid payment month.',
			paymentday_empty						:	'Payment Day cannot be empty',
			effstartdate_empty						:	'Please enter a valid effective start date',
			recorddate_empty						:	'Record Date cannot be empty',
			rate_empty							:	'Please enter a valid coupon rate',
			issuedate_required						:	'Please enter Issue Date',
			maturitydate_required					:	'Please enter Maturity Date',
			couponpaymentFreq_required				:	'Please enter Coupon Payment Frequency',	
			couponccy_required						:	'Please enter Coupon Ccy',
			accruedinterestinitdate_required		:	'Please enter Accrued Interest Init Date',
			accruedinterestcalctype_required		:	'Please enter Accrued Interest Calc Type',
			floatingfixflag_required				:	'Please enter Rate type',
			discountratetype_error					:	'Cannot enter Rate Type for Bond Type other than COUPON',
			couponpaymentFreq_first  				:   'Please Select Coupon Payment Frequency First.',
			paydown_change    						: 	'Cannot change Pay Down Flag to N or blank if Payment Schedule is present or Principal Payment Freq is present',
			paySchedule_change 						:  	'Cannot enter Payment Schedule for selected Coupon Frequency',
			paySchedule_empty  						:  	'Cannot enter as many Payment Schedule for selected Coupon Frequency',
			bondType_change   						: 	'Cannot enter Coupon Payment Frequency for Bond Type other than COUPON',
			principalPayment_empty  				: 	'Principle Payment Frequency Cannot be empty',
			paymentschedule_frequency_mismatch 		:	'Cannot enter more than {0} Payment Schedule Records\n as Coupon Payment Freq = \"{1}\"\n',
			invalid_payment_month  					: 	'Please enter a valid payment month',
			effstartdateissueDate_empty				: 	'Eff Start Date and Issue Date both can not be empty',
			issue_price								:	'Issue Price',
			redemption_price						:	'Redemption Price',
			fixedcoupon_rate                        :   'FixedCouponRate',
			floatingcoupon_rate                     :   'FloatingCouponRate',
			coupon_currency							:	'Cannot enter Coupon Currency for Bond Type other than COUPON',
			accrued_intr_init_date					:	'Cannot enter Accrued Interest Init Date for Bond Type other than COUPON',
			accrued_intr_calculation_type			:	'Cannot enter Accrued Interest Calculation Type for Bond Type other than COUPON',
			initial_coupon_type						:	'Cannot enter Initial Coupon Type for Bond Type other than COUPON',
			initial_coupon_date						:	'Cannot enter Initial Coupon Date for Bond Type other than COUPON',
			final_coupon_type						:	'Cannot enter Final Coupon Type for Bond Type other than COUPON',
			fixed_coupon_rate						:	'Fixed Coupon Rate should be empty for Rate type FLOAT',
			blank_fixed_coupon						:	'Fixed Coupon Rate should be empty for Rate type other FIX',
			float_base_rate							:	'Floating Base rate should be blank for rate type FIX',
			blank_float_base						:	'Floating Base rate should be blank for rate type other than FLOAT',
			floatingBaseRate_not_for_fix			:	'Cannot enter Floating Base Rate for Rate Type FIX',
			fixedCouponRate_for_fix 				: 	'Please enter Fixed Coupon Rate for Rate Type FIX.',
			couponFrequency_Not_for_Non_Coupon		:	'Cannot enter Coupon Payment Frequency for Bond Type other than COUPON.',
			couponCcy_Not_for_Non_Coupon			:	'Cannot enter Coupon Currency for Bond Type other than COUPON.',
			accIntStartDate_Not_for_Non_Coupon		:	'Cannot enter Accrued Interest Init Date for Bond Type other than COUPON.',
			accIntCalType_Not_for_Non_Coupon		:	'Cannot enter Accrued Interest Calculation Type for Bond Type other than COUPON.',
			rateType_Not_for_Non_Coupon				:	'Cannot enter Rate Type for Bond Type other than COUPON.',
			initialCouponType_Not_for_Non_Coupon	:	'Cannot enter Initial Coupon Type for Bond Type other than COUPON.',
			initialCouponDate_Not_for_Non_Coupon	:	'Cannot enter Initial Coupon Date for Bond Type other than COUPON.',
			finalCouponType_Not_for_Non_Coupon		:	'Cannot enter Final Coupon Type for Bond Type other than COUPON.',
			principalpaymentfreq_empty				:	'Principal Payment Freq is empty.',
			floatbaserateforfix						:	'Floating Base rate should be blank for rate type FIX',
			couponresetdateforfix					:   'Coupon Reset Date should be blank for rate type FIX',
			fixrateforfloat							:	'Fixed Coupon Rate should be empty for Rate type FLOAT',
			fixrateforothers						:	'Fixed Coupon Rate should be empty for Rate type other FIX',
			floatbaserateforothers 					: 	'Floating Base rate should be blank for rate type other than FLOAT',
			couponresetdatefornotfloat				:	'Coupon Reset Date should be blank for rate type other FLOAT',
			previousdate 							: 	'Please provide a valid previous coupon date',
			issue_date_error						:	'Please enter a valid value for Issue Date',
			maturity_date_error						:	'Please enter a valid value for Maturity Date',
			accrued_interest_init_date_error		:	'Please enter a valid value for Acc Int Start Date',
			initial_coupon_date_error				:	'Please enter a valid value for Intitial Coupon Date',
			coupon_reset_date_error					:	'Please enter a valid value for Coupon Reset Date',
			prev_coupon_date_error					:	'Please enter a valid value for Previous Coupon Date',
			next_coupon_date_error					:	'Please enter a valid value for Fixed Coupon Date'
		},
		mbs:{
			cmotype_empty				:	'Please enter a valid Cmo Type',
			pool_reset_error			:	'Please enter a valid value for Pool Reset Date',
			datefrom_empty				:	'Please enter a valid value for Effective Start Date',
			record_date_error			:	'Please enter a valid value for Record Date',
			poolfactor_error			:	'Please enter a valid value for PoolFactor',
			poolbalance_error			:	'Please enter a valid value for PoolBalance',
			poolfactor                  :   'Pool Factor',
			poolbalance                 :   'Pool Balance',
			date_compare				:	'Effective Start Date cannot occur after Record Date.'
		},
		restriction:{
			restriction_empty			:	'Please select a Restriction',
			start_date_empty			:	'Please enter a valid Start Date',
			end_date_empty				:	'Please enter a valid End Date',
			date_compare				:	'End Date cannot occur before Start Date.',
			memo_empty					:	'Please select a Memo'		
		},
		derivatives:{
			contract_startdate_error	:	'Please enter a valid value for Contract Start Date',
			contract_enddate_error		:	'Please enter a valid value for Contract Expiry Date'
		},
		warrent:{
			conversion_startdate_error		:	'Please enter a valid value for Conversion Start Date',
			conversion_enddate_error		:	'Please enter a valid value for Conversion End Date',
			conversion_datecompare_error	:	'Conversion Start Date cannot occur after Conversion End Date'
		}
	},
	
	strategyentry:{
		basicinfo:{
		        strategyCode_empty          :  'Strategy Code connot be empty',
		        ShortName_empty             :  'Short Name cannot be empty',
		        strategyParentCode_empty    :  'Strategy ParentCode cannot be empty'
		}
	}
	,
	holidyentry: {
        general:    {
		   holiday_name_empty           :   'Holiday Name cannot be empty',
		   holiday_date_empty           :   'Holiday Date cannot be empty',
		   calendar_id_empty            :   'Calendar Id cannot be empty'
		 }
	},
	applicationrole: {
		titles: {
			root_menu						:   'Menu'
		},
		common: {
			menuname_empty          		:   'Menu Name cannot be empty',
			menuaccesstype_empty     		:   'Menu Access Type cannot be empty',
			reportId_empty     				:   'Report ID cannot be empty',
			exceptionmonitorrule_empty   	:   'Exception Monitor Rule cannot be empty',		   
			exceptionmonitoraccesstype_empty  :   'Exception Monitor Access Type cannot be empty',
			feedname_empty  				:   'Feed Name cannot be empty',
			disable_select					:   'Select at least one from Disable to add',
			enable_select  					:   'Select at least one from Enable to remove'
		},
		basicinfo: {
			applicationRoleName_empty  		:   'Application Role Name is Missing',
			accountAccessRestrFlag_empty 	:   'A/C Restriction is Missing',
			officeId_empty  				:   'Office Id is Missing'
		}
	},
	exchangerate: {
		basicinfo: {
			exchangeRateType_empty : 'Exchange Rate Type cannot be empty',
			baseDate_empty			: 'Base Date cannot be empty',
			calculationType_empty	: 'Calculation Type cannot be empty',
			againstCcy_empty		: 'Against Ccy cannot be empty',
			rate_empty				: 'Rate cannot be empty',
			rate_invalid			: 'Invalid Exchange Rate'
		},
		query:{
			date_format_of_from_date_check : 'Illegal date format ',
			date_format_of_to_date_check : 'Illegal date format ',
			date_from_to_check : 'From Date should be less than To Date'
		}
	
	},
	crossexchangerate: {
		basicinfo: {
			exchangeRateType_empty  : 'Exchange Rate Type cannot be empty',
			baseDate_empty			: 'Base Date cannot be empty',
			calculationType_empty	: 'Calculation Type cannot be empty',
			localCcy_empty		    : 'Local Ccy cannot be empty',
			baseCcy_empty		    : 'Base Ccy cannot be empty',
			rate_empty				: 'Rate cannot be empty',
			rate_invalid			: 'Invalid Exchange Rate'
		},
		query:{
			date_format_of_from_date_check : 'Illegal date format ',
			date_format_of_to_date_check : 'Illegal date format ',
			date_from_to_check : 'From Date should be less than To Date'
		}
	},
	accountDocumentAction:{
		basicinfo:{
		        actiondate_empty    : 'Agreement Action Date cannot be empty'
		}
	},
	marketprice:{
		inputprice:{
			inputPrice_empty: 'Input Price cannot be empty',
			baseDate_empty	: 'Base Date cannot be empty',
			security_empty: 'Security Code cannot be empty',
			inputPrice_length: '9 digits are allowed before decimal point for Input Price',
			inputPrice_pointLength: '9 digits are allowed after decimal point for Input Price',
			inputprice_invalid	  :'Please enter a valid value for Price',
			invalid_BMT : 'One of the formatting parameters is invalid.',
			decimal_dot_count : 'The decimal separator can occur only once.',
			invalid_char : 'The input contains invalid characters.',
			negative_value : 'The amount may not be negative.',
			input_price : 'The number entered is too large.',
			price_decimal : '{0} digits are allowed after decimal point',
			input_price_decimal : 'The amount entered has too many digits beyond the decimal point.'
		
		}
	},
	cpsssiupload:{
		validation:{
			cannotbeblank:"CP SSI File cannot be blank.",
			invalidfiletype:"Invalid file type. Try uploading .xls or .xlsx"
		}
	},
	sssiupload:{
		validation:{
			cannotbeblank:"SSI File cannot be blank.",
			invalidfiletype:"Invalid file type. Try uploading .xls or .xlsx"
		}
	},
	personalization:{
		validation:{
			cannotbeblank:"Personalization File cannot be blank.",
			invalidfiletype:"Invalid file type. Try uploading xml file"
		},
		otherexport:{
			missingExportType:"Export Type is mandatory.",
			missingUserId:"User Id cannot be blank when Export Type is USER."
		}
	},
	ssientry:{
		validation:{
			compulsoryfields_required	:  'Either Counterparty Code or Trading Account or Local Account is required',	
			settlementfor_required		:	'Settlement For cannot be empty',
			cashsecurityflag_required	:	'Cash/Security cannot be empty',
			settlementtype_required		:	'Settlement Type cannot be empty',
			priority_required			:   'Priority cannot be empty',
			settlementmode_required		:	'Settlement Mode cannot be empty',
			secglobalcust_required		:   'Security Global Custodian cannot be empty',
			cashglobalcust_required		:	'Global Cash Custodian cannot be empty',
			bojSettleTimeType_required	:   'BOJ Settle Time Type cannot be empty when Instruction Format ID is BOJ and DVP Eligible is N',
			accountnocrossref_required  :   'Our Bank No cannot be empty',
			
			benificiaryName_required    :   'Beneficiary Name is Required when Settlement Mode is EXTERNAL and Layout is Japanese',
			cashBenificiaryName_required:	'Beneficiary Name for Cash is Required when Cash Settlement Mode is EXTERNAL and Cash SSI Layout is Japanese',
			custodianBank_required      :   'Custodian Bank is Required when Settlement Mode is EXTERNAL and Layout is Japanese',
			cashCustodianBank_required  :	'Cash side Custodian Bank is Required when Cash Settlement Mode is EXTERNAL and Cash SSI Layout is Japanese',
			settlementAcc_required      :   'Settlement Account is Mandatory when Settlement Mode is External and DVP Eligible is N and Layout is Japanese',
			cashSettlementAcc_required  :	'Cash side Settlement Account is Mandatory when Cash Settlement Mode is External, DVP Eligible is N and Cash SSI Layout is Japanese',
			bankAccType_required        :   'Bank Account Type is Mandatory when Settlement Mode is External and DVP Eligible is N and Layout is Japanese',
			cashBankAccType_required    :	'Cash side Bank Account Type is Mandatory when Cash Settlement Mode is External, DVP Eligible is N and Cash SSI Layout is Japanese',
			wayOfPayment_required       :   'Way Of Payment is Required when Settlement Mode is EXTERNAL and Layout is Japanese',
			wayOfPayment_for_diffCash_required : 'Way Of Payment is Required when Cash Settlement Mode is EXTERNAL and Cash SSI Layout is Japanese',
			instructFormatId_required   :   'Instruction Format Id is Mandatory when Settlement Mode is External and DVP Eligible is N and Layout is Japanese',
			instructFormatId_for_diffCash_required : 'Instruction Format Id is Mandatory when Cash Settlement Mode is External, DVP Eligible is N and Cash SSI Layout is Japanese',
			transferType_required       :   'Transfer Type is Required for Settlement Mode is External and DVP Eligible is N and Way Of Payment is BANK_TRANSFER and Layout is Japanese',
			transferType_for_diffCash_required : 'Transfer Type is Required when Cash Settlement Mode is External, DVP Eligible is N, Way Of Payment is BANK_TRANSFER and Cash SSI Layout is Japanese',
			dvpEligible_required        :   'DVP Eligible is Mandatory when SSI Layout is JAPANESE',
			clearingParty_required        : 'Clearing Party should be JGBCC or NON-JGBCC when Instrument Type is GB',
			not_permissible_clearingParty : 'Clearing Party should not be JGBCC or NON-JGBCC when Instrument Type is other than GB',
		    bojNarrativeRemarks1_required : 'BOJ Narrative Remarks 1 is mandatory when Instruction Format Id is BOJ and Transfer Type is 10-TRANS_REQ_REM',
		    not_permissible_bojSettleTimeType : 'BOJ Settle Time Type should only be {0} {1}',
			contraId_required           :   'Contra Id cannot be empty',
		    fullDeliveryInx_required    :   'Delivery Instruction cannot be empty',
			dtcParticipantId_required   :   'DTC Participant Number cannot be empty', 
			dtcParticipantId_length     :   'DTC Participant Number must be of length 4',
			brokerBic_length            :   'Broker Bic must be of length either 8 or 11',
			dtcInstitutionId_required   :   'DTC Institution ID cannot be empty', 
			invalid_dtc_cash_free_rule  :   'SSI Layout Cannot be DTC for Cash Free rule',
			invalid_bony_cash_free_rule :   'SSI Layout Cannot be BONY for Cash Free rule',
			transferType_03_DEBT_REQUEST :   '03-DEBT_REQUEST is allowed only when Payment/Receipt is PAYMENT',
			transferType_13_DEBT_NOTICE :   '13-DEBT_NOTICE is allowed only when Payment/Receipt is RECEIPT',
			bojtransferreqremarks		:	'BOJ Transfer Request Remarks not allowed when Transfer Type other than [{0}], [{1}] and [{2}]',
			bojtransferreqremarks_notboj :	'BOJ Transfer Request Remarks Not allowed when Instruction Format Id other than BOJ',
			bojnarrativebankname		:	'BOJ Narrative Bank Name Not allowed when Transfer Type other than 02-TRNS_REQ_MEM',
			bojnarrativebankname_notboj	:	'BOJ Narrative Bank Name Not allowed when Instruction Format Id other than BOJ',
			bojnarrativebankaccno		:	'BOJ Narrative Bank Account Number Not allowed when Transfer Type other than 02-TRNS_REQ_MEM',
			bojnarrativebankaccno_notboj : 	'BOJ Narrative Bank Account Number Not allowed when Instruction Format Id other than BOJ',
			bojnarrativebenificiaryname	:	'BOJ Narrative Beneficiary Name Not allowed when Transfer Type other than 02-TRNS_REQ_MEM',
			bojnarrativebenificiaryname_notboj : 'BOJ Narrative Beneficiary Name Not allowed when Instruction Format Id other than BOJ',
			bojnarrativeourname			:	'BOJ Narrative Our Name Not allowed when Transfer Type other than 02-TRNS_REQ_MEM',
			bojnarrativeourname_notboj	: 	'BOJ Narrative Our Name Not allowed when Instruction Format Id other than BOJ',
			bojnarrativeremarks1		:	'BOJ Narrative Remarks1 not allowed when Transfer Type is other than [{0}] and [{1}]',
			bojnarrativeremarks1_notboj :	'BOJ Narrative Remarks1 Not allowed when Instruction Format Id other than BOJ',
			bojnarrativeremarks1_mandatory : 'BOJ Narrative Remarks1 is Mandatory when Transfer Type is 10-TRANS_REQ_REM',
			bojnarrativeremarks1_datalength : 'BOJ Narrative Remarks1 should not have more than [{0}] characters',
			bojnarrativeremarks2		:	'BOJ Narrative Remarks2 not allowed when Transfer Type is other than [{0}]',
			bojnarrativeremarks2_notboj :	'BOJ Narrative Remarks2 Not allowed Instruction Format Id other than BOJ',
			bojdebitdequestremarks		:	'BOJ Debit Request Remarks not allowed when Transfer Type is other than [{0}]',
			bojdebitdequestremarks_notboj :	'BOJ Debit Request Remarks Not allowed when Instruction Format Id other than BOJ',
			bojdebitdequestremarks_mandatory :	'BOJ Debit Request Remarks is Mandatory when Transfer Type is 03-DEBT_REQUEST',
			transferType_eight_LETTER_OF_TRANS_permissible : 'REALTIME/0900/1300/1500/1700',
			transferType_eight_LETTER_OF_TRANS_condition : 'when Way Of Payment is CHEQUE or Transfer Type is 8-LETTER_OF_TRANS',
			transferType_one_TRNS_REQUEST_permissiblevalue:'REALTIME',
			transferType_one_TRNS_REQUEST_conditionvalue:'when Transfer Type is other than [{0}]',
			transferType_three_DEBT_REQUEST_permissiblevalue:' REALTIME/1500',
			transferType_three_DEBT_REQUEST_conditionvalue:' when Transfer Type is 03-DEBT_REQUEST',
			transferType_five_REQ_SB_SETTLE_permissiblevalue:'1500',
			transferType_five_REQ_SB_SETTLE_conditionvalue:' when Transfer Type is 05-REQ_SB_SETTLE',
			transferType_six_JPY_FOREX_permissiblevalue:'REALTIME/1430',
			transferType_six_JPY_FOREX_conditionvalue:'when Transfer Type is 06-JPY_FORE' 
		}
	},
	ssiquery:{
		validation:{
			counterPartyCode_required	    :  'Counter Party Code can not be Empty'
		}
	},
	ownssientry:{
		validation:{
			settlement_for              : 'Settlement For cannot be empty',
			cash_security_flag			: 'Cash Security Flag cannot be empty',
			cash_security_flag_invalid  : 'Cash/Security[SECURITY] is not allowed for selected Settlement For {0}',
			settlement_mode				: 'Settlement Mode cannot be empty',
			settlement_bank				: 'Settlement Bank cannot be empty',
			settlement_account			: 'Settlement Account cannot be empty',
			cash_settlement_mode		: 'Cash Settlement Mode cannot be empty',
			cash_settlement_bank	 	: 'Cash Settlement Bank cannot be empty',
			cash_settlement_account		: 'Cash Settlement Account cannot be empty',
			counterparty_code 			: 'Please Enter a valid counter party code',
			counterpartycode_diff_cash  :'The Counterparty Code of the Broker must be specified to specify a Diff Cash INTERNAL rule.'	
		}
	},
	custRestCntrl:{
			no_record_selected	    :  'No Record Selected. Please select at least One Record.'
	},
	accountRestCntrl:{
			no_record_selected	    :  'No Record Selected. Please select at least One Record.'
	},
	actUpload:{
		validation:{
			cannotbeblank:"Account File cannot be blank.",
			invalidfiletype:"Invalid file type. Try uploading .xls or .xlsx"
		}
	},
	assetMgmtQuery:{
		validation:{
			counterPartyCode_required:'Please enter a valid counter party code'
		}
	},
	assetMgmtEntry:{
		validation:{
			custodianBank_required:'Please enter Custodian Bank',
			assetMgmtAc_required:'Please enter Ast. Mgmt. A/C',
			custodianBank_empty:'No Custodian Bank has been specified.'
		}
	},
	businessRelationEntry:{
		validation:{
			institutionCode_required:'Please specify an Institution Code',
			market_required:'Please specify a Market',
			accountNo_required:'Please specify an Account Number'
		}
	},
	agent:{
		xrefinfo :{
			registrationauthority_empty : "Registration Authority cannot be empty",
			dateofregistration_empty : "Date Of Registration cannot be empty",
			registrationno_empty : "Registration No cannot be empty",
			charsetcode_empty : "charset Code cannot be empty",
			shortname_empty : "short Name cannot be empty",
			officialname_empty : "Official Name cannot be empty",
			agentcodetype_empty : "Agent Code Type cannot be empty",
			agentcode_empty : "Agent Code cannot be empty"
		},
		restriction : {
			restrictionid_empty   		: 'Restriction Id/Name cannot be empty.',
			restrictionflag_empty 		: 'Restriction Status cannot be empty.'
			},
		common :{
			start_date_empty 			: 'Start Date cannot be empty.',
			start_date_after_end_date	: 'End Date cannot occur before Start Date.',
			agentcode_empty             : "Agent Code cannot be empty",
			addressid_empty 			: 'Address Id cannot be empty',
			repid_grpid_reqd 			: 'Either Report Name or Group Report Name is mandatory.',
			one_field_required 			: 'Please enter at least one field except Address Id.',
			addressid_empty 			: 'Address Id can not be empty',
			calculation_method_empty	: 'Calculation Method cannot be empty.',
			issue_country_empty 		: 'Issue Country cannot be empty.',
			instrument_type_empty		: 'Instrument Type cannot be empty.',
			buy_sell_empty 				: 'Buy/Sell cannot be empty.',
			start_date_empty 			: 'Start Date cannot be empty.',
			rate_empty 					: 'Rate cannot be empty.',
			rate_type_empty 			: 'Rate Type cannot be empty.',
			amount_empty				: 'Amount cannot be empty.',
			unit_empty 					: 'Unit cannot be empty.',
			table_id_slidingid_empty	: 'TableId for Sliding cannot be empty.',
			table_id_slidingprc_empty	: 'TableId for Sliding Price cannot be empty.',
			start_date_after_end_date	: 'End Date cannot occur before Start Date.',
			one_field_required 			: 'Please enter at least one field except Address Id.',
			command_id_empty			: 'Query Screen Command Id missing.',
			close_reason_cannot_empty	: 'Close Reason can not be blank.',
			reopen_reason_cannot_empty  : 'Reopen Reason can not be blank.',
			maxLength					: '15 digits are allowed before decimal point for Max',
			maxDecLength				: '3 digits are allowed after decimal point for Max',
			minLength				    : '15 digits are allowed before decimal point for Min',
			minDecLength				: '3 digits are allowed after decimal point for Min'
			},
		commission : {
			commissionid_empty : 'Commission Id/Name cannot be empty.',
			calculationperiod_empty	: 'Calculation Period can not be empty',
			calculationbasis_empty : 'Calculation Basis can not be empty'
			},
		generalinfo:{
			residentcountry_empty : "Resident Country cannot be empty",
			contractcountry_empty : "Contract Country cannot be empty",
			nationality_empty     : "Nationality cannot be empty"
			},
		address :{
			addresstype_empty 			: 'Address Type cannot be empty.',
			automanualFlag_empty        : 'Auto Manual Flag can not be empty.',
			contactnumber_numeric  		:'Contact Number must be numeric',
			emailtype_blank				: 'TO/CC/BCC cannot be blank',
			email_address				: 'Address cannot be blank'
			},
		docinfo : {
			servicename_empty   : 'Service Name/Id can not be empty',
			servicestatus_empty : 'Service Status can not be empty'
			}
	},
    collateral : {
        upload : {
            blankFile : 'Upload File cannot be blank',
            invalidFileType : 'Only xls or xlsx file can be uploaded',
            blankUploadType : 'Upload Type cannot be blank'
        }
    },
	webClient : {
		validation : {
			accountNoEmpty		: 'Please enter Account No.',
			accessStatusEmpty	: 'Please enter Access Status',
			emailIdEmpty		: 'Please enter Email Id',
			expiryDateStrEmpty	: 'Please enter Expiry Date',
			listEmpty			: 'Please add at least one Client User Info'
		}
	},
    emailNotificationSendResend : {
		fileNotExistForSelectedRow : 'Report for the selected record(s) does not exist. So file cannot be Resent.',
		noRecordSelected : 'No records selected for Send / Resend'
	},
	localAccount:{
		common:{
			accountnotype_empty : 'Account No Type can not be empty',
			accountno_empty : 'Account No can not be empty'
		}
	},
	MarketStatistics:{
		validation:{
			basedate_empty: 'Base Date cannot be empty.'
		}
	},
	ccassUpload:{
		validation:{
			cannotbeblank:"CCASS File cannot be blank.",
			invalidfiletype:"Invalid file type. Try uploading .txt"
		}
	},
	accessLog:{
		query : {
			date_from_to_check : 'From Date should be less than To Date.',
			date_format_check : 'Illegal date format '
		}
	},
	marketPriceExcelUpload:{
		validation: {
			cannotbeblank: 'Market Price File cannot be blank.',
			invalidfiletype: 'Invalid file type. Try uploading .xls or .xlsx.',
			maxfilesize: 'Selected File Size is Over Allowed Limit ({0} bytes). Please select Another File!'
		}
	},
	cpSSIQuery:{
		validation: {
			validcounterparty: 'Please Enter a valid Counterparty Code.',
			cporlocal: 'Please enter either the Counter Party Account or the Local Account.'
		}
	},

	cpSSIEntry:{
		validation: {
			emptyGlobalSecCustodian: 'Global Security Custodian cannot be empty.',
			custBankLength: 'Length of Custodian Bank can not be more than 35 character.',
			custBankLengthBic: 'Custodian Bank length Should be 11 for Bank Code Type BIC.',
			emptyGlobalCashCustodian: 'Global Cash Custodian cannot be empty.',
			emptyCounterpartyCode: 'Please Enter a valid Counterparty Code.',
			emptyCounterpartyAccount: 'Please Enter Counterparty Account.'
		}
	},
	ref:{
		ownssirule:{
			msg:{
				info:{
					multiplestlacc : 'Multiple settlement account exists for settlement bank [{0}].\nPlease select one from the settlement account popup.'
				}
			}
		},
		ownsettlestanding:{
			alert:{
				validator:{
					entry:{
						fundcode : 'Fund Code is Missing',
						settlementfor : 'Settlement For is Missing',
						cashsecurityflag : 'Cash Security Flag is Missing',
						settlebank : 'Settlement Bank is Missing',
						settleaccount : 'Settlement Account is Missing',
						settlemode : 'Settlement Mode is Missing', 
						cashsettlebank : 'Cash Settlement Bank is Missing',
						cashsettleaccount : 'Cash Settlement Account is Missing',
						cashsettlemode : 'Cash Settlement Mode is Missing'
					}
				}
			}
		}
	},
	batch:{
		execution:{
			specifybatchid : 'Please specify  BatchId',
			modeproblem : '{0} can not be run in LM mode.',
			brrtrefnomtchbatch : 'Borrow Return Reference Number Matching Batch can not be run in LM mode.',
			officeloadingproblem : 'Failed to populate Office Id',
			dateformat : 'Illegal date format',
			dateproblem : 'Base Date should not be greater than Value Date'
		}
	},
	batchStatusQuery:{
		illegal_date_format : 'Illegal date format'
	},	
	onlineReportExecStatusQuery:{
		illegal_date_format:'Illegal Date Format'
	}
 };