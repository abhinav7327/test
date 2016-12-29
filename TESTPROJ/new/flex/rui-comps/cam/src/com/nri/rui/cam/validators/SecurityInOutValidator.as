package com.nri.rui.cam.validators
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	public class SecurityInOutValidator extends Validator
	{
		// Define Array for the return value of doValidation().
        private var results:Array;
        private const SECURITY_ENTRY_IN:String = "I";
    	private const SECURITY_ENTRY_OUT:String = "O";
        
		public function SecurityInOutValidator()
		{	
			super();
		}
		
		/**
         * 
         * validate Security In Out form
         */      
        protected override function doValidation(value:Object):Array {
        	
        	var forGenerateBookValue:Boolean = false;
        	var forGenarateBookValueBC:Boolean=false;
        	var forGenerateAccruedIntPaid=false;
        	// Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);

            // Return if there are errors.
            if (results.length > 0)
                return results;
        	
        	//XenosAlert.info("Length="+String(StringUtil.trim(value.salesRole)).length);
        	
 /*       	if((value.officeIdList is Object) || String(StringUtil.trim(value.officeIdList)).length != 2) {
        		results.push(new ValidationResult(true,"", "officeId", "Office Id Cannot Be Blank."));
	            return results;
        	}
        	
        	if((value.salesRole is Object) || String(StringUtil.trim(value.salesRole)).length == 15) {
        		results.push(new ValidationResult(true,"", "salesId", "Sales Id Cannot Be Blank."));
	            return results;
        	}*/
        	
        	
       	if(XenosStringUtils.equals(value.calculationMode , "localBv" )) {
        		
        		
		        	if(value.validateBookValue != null || StringUtil.trim(value.validateBookValue) == "true"){
	    	    		forGenerateBookValue = true;
	        		}
	        	
	        	   if(forGenerateBookValue == true){
						if(value.accountNo == null || StringUtil.trim(value.accountNo) == ""){
			        		 results.push(new ValidationResult(true, 
				                    "fundAcNo", "fundAcNoMissing", Application.application.xResourceManager.getKeyValue('cam.label.fund.account.missing')));
			        	}        		
			        	if(value.securityCode == null || StringUtil.trim(value.securityCode) == ""){
			        		 results.push(new ValidationResult(true, 
				                    "securityCode", "securityCodeMissing", Application.application.xResourceManager.getKeyValue('cam.label.security.code.missing')));
			        	}
			        	if(value.amountStr == null || StringUtil.trim(value.amountStr) == ""){
			        		 results.push(new ValidationResult(true, 
				                    "amountStr", "amountStrMissing", Application.application.xResourceManager.getKeyValue('cam.label.quantity.missing')));
			        	}        		
	        	 }else {
			        	if(value.accountNo == null || StringUtil.trim(value.accountNo) == ""){
			        		 results.push(new ValidationResult(true, 
				                    "fundAcNo", "fundAcNoMissing", Application.application.xResourceManager.getKeyValue('cam.label.laccount.missing')));
			        	}
			        	if(value.bankCode == null || StringUtil.trim(value.bankCode) == ""){
			        		 results.push(new ValidationResult(true, 
				                    "bankCode", "bankCodeMissing", Application.application.xResourceManager.getKeyValue('cam.label.custodian.bank.missing')));
			        	}
			        	if(value.ourSettleAccountNo == null || StringUtil.trim(value.ourSettleAccountNo) == ""){
			        		 results.push(new ValidationResult(true, 
				                    "ourSettleAccountNo", "ourSettleAccountNoMissing", Application.application.xResourceManager.getKeyValue('cam.label.oursettle.account.missing')));
			        	}
			        	if(value.securityCode == null || StringUtil.trim(value.securityCode) == ""){
			        		 results.push(new ValidationResult(true, 
				                    "securityCode", "securityCodeMissing", Application.application.xResourceManager.getKeyValue('cam.label.security.code.missing')));
			        	}
			        	if(value.amountStr == null || StringUtil.trim(value.amountStr) == ""){
			        		 results.push(new ValidationResult(true, 
				                    "amountStr", "amountStrMissing", Application.application.xResourceManager.getKeyValue('cam.label.quantity.missing')));
			        	}        	
	        	  }
        	} else if(XenosStringUtils.equals(value.calculationMode , "baseBv" )){
       	  	
       	  	       if(value.validateBookValueBC != null||StringUtil.trim(value.validateBookValueBC) == "true"){
	        			forGenarateBookValueBC = true;
	        			
	        		} 
	        		
	        		if(forGenarateBookValueBC == true){
		        		/* if(value.spotCalcDate == null || StringUtil.trim(value.spotCalcDate) == ""){
		        		   results.push(new ValidationResult(true,"spotCalcDate","spotCalcDateMissing",Application.application.xResourceManager.getKeyValue('cam.label.spotcalcdate.missing')));	
		        		} */
		        		if(value.accountNo == null || StringUtil.trim(value.accountNo) == ""){
			        		 results.push(new ValidationResult(true, 
				                    "fundAcNo", "fundAcNoMissing", Application.application.xResourceManager.getKeyValue('cam.label.fund.account.missing')));
			        	}        		
			        	if(value.securityCode == null || StringUtil.trim(value.securityCode) == ""){
			        		 results.push(new ValidationResult(true, 
				                    "securityCode", "securityCodeMissing", Application.application.xResourceManager.getKeyValue('cam.label.security.code.missing')));
			        	}
	        		
       	  			}
       	  }
       	  
       	  else if(XenosStringUtils.equals(value.calculationMode , "baseAcruedInt" )){
       	      	if(value.validateAcruedIntBC != null||StringUtil.trim(value.validateAcruedIntBC) == "true"){
	        			forGenerateAccruedIntPaid = true;
	        		} 
	        		
	        	if(forGenerateAccruedIntPaid == true){
	        			/* if(value.spotCalcDate == null || StringUtil.trim(value.spotCalcDate) == ""){
		        		   results.push(new ValidationResult(true,"spotCalcDate","spotCalcDateMissing",Application.application.xResourceManager.getKeyValue('cam.label.spotcalcdate.missing')));	
		        		} */
		        		if(value.accountNo == null || StringUtil.trim(value.accountNo) == ""){
			        		 results.push(new ValidationResult(true, 
				                    "fundAcNo", "fundAcNoMissing", Application.application.xResourceManager.getKeyValue('cam.label.fund.account.missing')));
			        	}        		
			        	if(value.securityCode == null || StringUtil.trim(value.securityCode) == ""){
			        		 results.push(new ValidationResult(true, 
				                    "securityCode", "securityCodeMissing", Application.application.xResourceManager.getKeyValue('cam.label.security.code.missing')));
			        	}	
       	            }
       	  }

       	  
       	 
        	
        	var dateList:Array = [];
        	
        	if(value.inOutDateStr != ""){
	            var dateformat:CustomDateFormatter =new CustomDateFormatter();
	            //format of the date
	            dateformat.formatString="YYYYMMDD";
	            var formatData:String ="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.inOutDateStr));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.inOutDateStr))) {
	                
	                results.push(new ValidationResult(true, 
	                    "inOutDateStr", "illegalinOutDate", Application.application.xResourceManager.getKeyValue('cam.label.illegal.date.format') + value.inOutDateStr));
	                //return results;
	            }
        		
        	}else{
        		if(value.inOutType == SECURITY_ENTRY_IN){
        			results.push(new ValidationResult(true, 
	                    "inOutDateStr", "inOutDateMissing", Application.application.xResourceManager.getKeyValue('cam.label.security.in.date.missing')));
	         	}else{
	         		results.push(new ValidationResult(true, 
	                    "inOutDateStr", "inOutDateMissing", Application.application.xResourceManager.getKeyValue('cam.label.security.out.date.missing')));
	         	}
        	}
        	
        	if(XenosStringUtils.equals(value.calculationMode , "localBv" ))
        		return results;
        	
        	if(XenosStringUtils.equals(value.calculationMode , "baseBv" ))
        		return results;
        		
        		if(XenosStringUtils.equals(value.calculationMode , "baseAcruedInt"))
        		return results;
        	 
        	
        	       if(value.accountNo == null || StringUtil.trim(value.accountNo) == ""){
			    	 results.push(new ValidationResult(true, 
				                    "fundAcNo", "fundAcNoMissing", Application.application.xResourceManager.getKeyValue('cam.label.laccount.missing')));
			      	}
			     	if(value.bankCode == null || StringUtil.trim(value.bankCode) == ""){
			        		 results.push(new ValidationResult(true, 
				                    "bankCode", "bankCodeMissing", Application.application.xResourceManager.getKeyValue('cam.label.custodian.bank.missing')));
			        	}
			      	if(value.ourSettleAccountNo == null || StringUtil.trim(value.ourSettleAccountNo) == ""){
			        		 results.push(new ValidationResult(true, 
				                    "ourSettleAccountNo", "ourSettleAccountNoMissing", Application.application.xResourceManager.getKeyValue('cam.label.oursettle.account.missing')));
			        	}
			       	if(value.securityCode == null || StringUtil.trim(value.securityCode) == ""){
			        		 results.push(new ValidationResult(true, 
				                    "securityCode", "securityCodeMissing", Application.application.xResourceManager.getKeyValue('cam.label.security.code.missing')));
			        	}
			       if(value.amountStr == null || StringUtil.trim(value.amountStr) == ""){
			        		 results.push(new ValidationResult(true, 
				                    "amountStr", "amountStrMissing", Application.application.xResourceManager.getKeyValue('cam.label.quantity.missing')));
			        	}
			        	
			       if(value.reasonCode == null || StringUtil.trim(value.reasonCode) == ""){
        		              results.push(new ValidationResult(true, 
	                        "reasonCode", "reasonCodeMissing", Application.application.xResourceManager.getKeyValue('cam.label.reason.code.missing')));
                            	}
		        	if(value.bookValueStr == null || StringUtil.trim(value.bookValueStr) == ""){
        	                	 results.push(new ValidationResult(true, 
	                                 "bookValue", "bookValueMissing", Application.application.xResourceManager.getKeyValue('cam.label.book.value.missing')));
                                	}
                    		
         	
        	 if(value.spotCalcDate != null && !XenosStringUtils.equals(value.spotCalcDate, XenosStringUtils.EMPTY_STR)){
        		
        		if(value.bookValueBC==null || StringUtil.trim(value.bookValueBC) == ""){
        			
        			results.push(new ValidationResult(true, 
	                    "bookValueBcStr", "bookValueBcStrMissing", Application.application.xResourceManager.getKeyValue('cam.label.bookvaluebc.missing')));
        		}
        		/*if(value.accruedIntStr == null || StringUtil.trim(value.accruedIntStr) == ""){
        			
        			results.push(new ValidationResult(true, 
	                    "accruedIntStr", "accruedIntStrMissing", Application.application.xResourceManager.getKeyValue('cam.label.acruedintpaidbc.missing')));
        			
        		}*/
        	} 
        	     	
        	if (results.length > 0)
                return results;
        	
        	results=[];
        	var amount:Number=(value.amountStr as Number);
        	if( amount < 0 )
        		results.push(new ValidationResult(true, 
	                    "amountStr", "amountStrLessThanZero", Application.application.xResourceManager.getKeyValue('cam.label.quantity.not.less.zero')));
        	return results;
        }
		
	}
}