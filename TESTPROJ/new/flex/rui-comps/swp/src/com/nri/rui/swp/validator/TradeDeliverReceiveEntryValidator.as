package com.nri.rui.swp.validator {    
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.NumberUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.core.Application;
    import mx.utils.ObjectUtil;
    import mx.utils.StringUtil;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;

	public class TradeDeliverReceiveEntryValidator extends Validator {
		public var results:Array=[];
		
		public function TradeDeliverReceiveEntryValidator() {
			super();
		}
		
		protected override function doValidation(value:Object):Array {
			
			if(value == null) {
				XenosAlert.info("value object is null");
				return null;
			} else {
				// Clear results Array.
	            results = [];
	            // Call base class's doValidation().
	            results = super.doValidation(value);
	            // Return if there are errors.
	            if (results.length > 0){
	            	return results;
	            }
				
				var accrualBasis:String 			= "";
			    var accruedAdjustmentFlag:String 	= "";
			    //var considerLeapYearFlag:String 	= "";
			    var dayConvention:String 			= "";
			    var firstValueDateStr:String 		= "";
			    var lastRegularValueDateStr:String 	= "";
			    var notionalAmount:String 		= "";
			    var paymentCcy:String 			= "";
			    var paymentFrequency:String 		= "";
			    var roundingPolicy:String 			= "";
			    var fixedFloatingType:String 		= "";
			   	var fixedInterestRate:String 	= "";
		    	var interestRateTypes:String 		= "";
		    	var spread:String 					= "";
		    	var resetDateOffset:String 			= "";
		    	var businessCenterLength:int 		= value['businessCenterLength'];
    			var paymentScheduleLength:int 		= value['paymentScheduleLength'];
    			var vdBasisPresent:String 			= value['vdBasisPresent'];
		    	
		    	var delOrRecTab:String = value['srcTabNo'];
		    	
		    	if(XenosStringUtils.equals(delOrRecTab,"2")){
		    		accrualBasis 			= value['deliverySideStreamObj.streamObj.dayCountFractionBasis'];
				    accruedAdjustmentFlag 	= value['deliverySideStreamObj.streamObj.accruedAdjustmentFlag'];
				    //considerLeapYearFlag 	= value['deliverySideStreamObj.streamObj.considerLeapYearFlag'];
				    dayConvention 			= value['deliverySideStreamObj.streamObj.dayConvention'];
				    firstValueDateStr 		= value['deliverySideStreamObj.streamObj.firstValueDateStr'];
				    lastRegularValueDateStr = value['deliverySideStreamObj.streamObj.lastRegularValueDateStr'];
				    notionalAmount 			= value['deliverySideStreamObj.streamObj.notionalAmountStr'];
				    paymentCcy 				= value['deliverySideStreamObj.streamObj.paymentCcyStr'];
				    paymentFrequency 		= value['deliverySideStreamObj.streamObj.paymentFrequency'];
				    roundingPolicy 			= value['deliverySideStreamObj.streamObj.roundingPolicy'];
				    fixedFloatingType 		= value['deliverySideStreamObj.streamObj.fixedFloatingType'];
				   	fixedInterestRate 		= value['deliverySideStreamObj.streamObj.fixedInterestRateVal'];
			    	interestRateTypes 		= value['deliverySideStreamObj.streamObj.interestRateTypes'];
			    	spread 					= value['deliverySideStreamObj.streamObj.spreadVal'];
			    	resetDateOffset 		= value['deliverySideStreamObj.streamObj.resetDateOffsetStr'];
			    	
		    	}else if(XenosStringUtils.equals(delOrRecTab,"3")){
		    		accrualBasis 			= value['receiveSideStreamObj.streamObj.dayCountFractionBasis'];
				    accruedAdjustmentFlag 	= value['receiveSideStreamObj.streamObj.accruedAdjustmentFlag'];
				    //considerLeapYearFlag 	= value['receiveSideStreamObj.streamObj.considerLeapYearFlag'];
				    dayConvention 			= value['receiveSideStreamObj.streamObj.dayConvention'];
				    firstValueDateStr 		= value['receiveSideStreamObj.streamObj.firstValueDateStr'];
				    lastRegularValueDateStr = value['receiveSideStreamObj.streamObj.lastRegularValueDateStr'];
				    notionalAmount 			= value['receiveSideStreamObj.streamObj.notionalAmountStr'];
				    paymentCcy 				= value['receiveSideStreamObj.streamObj.paymentCcyStr'];
				    paymentFrequency 		= value['receiveSideStreamObj.streamObj.paymentFrequency'];
				    roundingPolicy 			= value['receiveSideStreamObj.streamObj.roundingPolicy'];
				    fixedFloatingType 		= value['receiveSideStreamObj.streamObj.fixedFloatingType'];
				   	fixedInterestRate 		= value['receiveSideStreamObj.streamObj.fixedInterestRateVal'];
			    	interestRateTypes 		= value['receiveSideStreamObj.streamObj.interestRateTypes'];
			    	spread 					= value['receiveSideStreamObj.streamObj.spreadVal'];
			    	resetDateOffset 		= value['receiveSideStreamObj.streamObj.resetDateOffsetStr'];
		    	}

				//mandatory check	-----------------------------------------------			
				if (XenosStringUtils.isBlank(StringUtil.trim(notionalAmount))) {
	            	results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.notionalAmount')));
				}
				if (XenosStringUtils.isBlank(StringUtil.trim(accrualBasis))) {
	            	results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.accrualBasis')));
				}
				if (XenosStringUtils.isBlank(StringUtil.trim(accruedAdjustmentFlag))) {
	            	results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.accruedAdjustmentFlag')));
				}
				if (XenosStringUtils.isBlank(StringUtil.trim(dayConvention))) {
	            	results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.dayConvention')));
				}
				if (XenosStringUtils.isBlank(StringUtil.trim(paymentFrequency))) {
	            	results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.paymentFrequency')));
				}
				if (XenosStringUtils.isBlank(StringUtil.trim(paymentCcy))) {
	            	results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.paymentCcy')));
				}
				if (XenosStringUtils.isBlank(StringUtil.trim(roundingPolicy))) {
	            	results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.roundingPolicy')));
				}
				/* if (XenosStringUtils.isBlank(StringUtil.trim(considerLeapYearFlag))) {
	            	results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.considerLeapYearFlag')));
				} */
				
				
				if (XenosStringUtils.isBlank(StringUtil.trim(fixedFloatingType))) {
	            	results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.fixedFloatingType')));
				}else {
					if(XenosStringUtils.equals(fixedFloatingType,Globals.FIXED_TYPE)){
						if (XenosStringUtils.isBlank(StringUtil.trim(fixedInterestRate))) {
			            	results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.fixedInterestRate')));
						}else {
							if(!NumberUtils.checkValidNumber(fixedInterestRate)){
								results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.invalidinteger')+" "+fixedInterestRate));
							}else{
								/* if(int(fixedInterestRate) > 100){
									results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.invalidfixedInterestRate')));
								} */
								if(Number(fixedInterestRate) == 0){
									results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.zerofixedInterestRate')));
								}
							}
						}
					}else if(XenosStringUtils.equals(fixedFloatingType,Globals.FLOATING_TYPE)){
						if (XenosStringUtils.isBlank(StringUtil.trim(interestRateTypes))) {
			            	results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.interestRateTypes')));
						}
						if(!XenosStringUtils.isBlank(StringUtil.trim(spread))){
							if(!NumberUtils.checkValidNegativeNumber(spread)){
								results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.invalidinteger')+" "+spread));
							}else{
								/* if(int(spread) > 100){
									results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.invalidspread')));
								} */ 
							}
						}
					}
				}
				
				if(businessCenterLength == 0){
					results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.buscenterlength')));
				}else{
					if(XenosStringUtils.equals(vdBasisPresent,"false")){
						results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.vdbasis')));
					}
				}
				if(paymentScheduleLength == 0){
					results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.pslength')));
				}else {
					//No of payment Schedule should match with payment frequency
					var paymentFreq:int = int(paymentFrequency);
					if((paymentFreq == 1) && (paymentScheduleLength != 1)){
						results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.yearly')));
					}else if((paymentFreq == 2) && (paymentScheduleLength != 2)){
						results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.semiannual')));
					}else if((paymentFreq == 4) && (paymentScheduleLength != 4)){
						results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.quarterly')));
					}else if((paymentFreq == 12) && (paymentScheduleLength != 12)){
						results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.monthly')));
					}
				}
				
				//Date validation and first-VD < last-regular-VD ---------------------------------
				var validDate:Boolean = false;
				var fvDt:Date = null;
				var lrvDt:Date = null;
				
				var dateformat:CustomDateFormatter = new CustomDateFormatter();
				dateformat.formatString="YYYYMMDD";
				
				if(firstValueDateStr != ""){
		            validDate = DateUtils.isValidDate(firstValueDateStr) ;            
		            if(!validDate) {
		                results.push(new ValidationResult(true, "", "", Application.application.xResourceManager.getKeyValue('swp.alert.validator.illegaldate')+" " + firstValueDateStr));
		            }else{
		            	fvDt = dateformat.toDate(CustomDateFormatter.customizedInputDateString(firstValueDateStr));
		            }
	            }
	        	
	        	if(lastRegularValueDateStr != ""){ 
		            validDate = DateUtils.isValidDate(lastRegularValueDateStr) ;            
		            if(!validDate) {
		                results.push(new ValidationResult(true, "tradeObj.effectiveDateStr'", "illegaleffectiveDateStr", Application.application.xResourceManager.getKeyValue('swp.alert.validator.illegaldate')+" " + lastRegularValueDateStr));
		            }else{
		            	lrvDt = dateformat.toDate(CustomDateFormatter.customizedInputDateString(lastRegularValueDateStr));
		            }
	            }
	            
	            if((fvDt != null) && (lrvDt != null)) {
					if(ObjectUtil.dateCompare(lrvDt,fvDt) != 1){
		        		results.push(new ValidationResult(true, 
		                    "", "fvDtLessThanLrvDt",  Application.application.xResourceManager.getKeyValue('swp.alert.valdate.fvDtLessThanLrvDt')));
		        	}
				}
				
				return results;
			}
		}
	}
}