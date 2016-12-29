package com.nri.rui.swp.validator
{    
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.core.Application;
    import mx.utils.ObjectUtil;
    import mx.utils.StringUtil;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;

	public class TradeGeneralEntryValidator extends Validator {
		public var results:Array=[];
		
		public function TradeGeneralEntryValidator() {
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
				
				var termiantionMode : String = value["TERMINATION_MODE"];
				
				if (termiantionMode == "true") {
					
					var terminationDateStr:String = StringUtil.trim(value['tradeObj.terminationDateStr']);
					
					if (XenosStringUtils.isBlank(StringUtil.trim(terminationDateStr))) {
		            	results.push(new ValidationResult(true, "tradeObj.terminationDateStr", "tradeObj.terminationDateStr", Application.application.xResourceManager.getKeyValue('swp.alert.validator.terminationDate')));
					} else {
					
						//Date field validation and date compare 
						var effectiveDateStr:String = StringUtil.trim(value['tradeObj.effectiveDateStr']);
						var maturityDateStr:String = StringUtil.trim(value['tradeObj.maturityDateStr']);
						
						//var validDate:Boolean = false;
						
						var df:CustomDateFormatter = new CustomDateFormatter();
						df.formatString="YYYYMMDD";
						
						var terminationDate : Date = null ;
						var effectiveDate:Date = df.toDate(CustomDateFormatter.customizedInputDateString(effectiveDateStr));
						var maturityDate:Date = df.toDate(CustomDateFormatter.customizedInputDateString(maturityDateStr));
						
						
						
						if(terminationDateStr != ""){
				            if(!DateUtils.isValidDate(terminationDateStr)) {
				                results.push(new ValidationResult(true, "tradeObj.terminationDateStr'", "illegaltradeDateStr", Application.application.xResourceManager.getKeyValue('swp.alert.validator.illegaldate')+ " " + terminationDateStr));
				            }else{
				            	terminationDate = df.toDate(CustomDateFormatter.customizedInputDateString(terminationDateStr));
				            }
			            }
			        	
			        	
						
						if((effectiveDate != null) && (terminationDate  != null)) {
							if(ObjectUtil.dateCompare(terminationDate,effectiveDate) == -1){
				        		results.push(new ValidationResult(true, 
				                    "", "effectiveDateLessThanTermination",  Application.application.xResourceManager.getKeyValue('swp.alert.valdate.terminationDtLessThanEffDt')));
				        	}
						}
		
						if((terminationDate != null) && (maturityDate != null)){
			        		if(ObjectUtil.dateCompare(maturityDate,terminationDate) != 1){
				        		results.push(new ValidationResult(true, 
				                    "", "terminationDtLessThanMatDt",  Application.application.xResourceManager.getKeyValue('swp.alert.valdate.terminationDtLessThanMatDt')));
				        	}
			        	}
						
					}
		        	
				} else {
					
					if (XenosStringUtils.isBlank(StringUtil.trim(value['tradeObj.fundAccountNoStr']))) {
		            	results.push(new ValidationResult(true, "tradeObj.fundAccountNoStr", "tradeObj.fundAccountNoStr", Application.application.xResourceManager.getKeyValue('swp.alert.validator.fundacc')));
					}
					if (XenosStringUtils.isBlank(StringUtil.trim(value['tradeObj.accountNoStr']))) {
		            	results.push(new ValidationResult(true, "tradeObj.accountNoStr", "tradeObj.accountNoStr", Application.application.xResourceManager.getKeyValue('swp.alert.validator.acc')));
					}
					if (XenosStringUtils.isBlank(StringUtil.trim(value['tradeObj.productTypeLbl']))) {
		            	results.push(new ValidationResult(true, "tradeObj.productTypeLbl", "tradeObj.productTypeLbl", Application.application.xResourceManager.getKeyValue('swp.alert.validator.prodtype')));
					}
					if (XenosStringUtils.isBlank(StringUtil.trim(value['tradeObj.notionalExchangeFlag']))) {
		            	results.push(new ValidationResult(true, "tradeObj.notionalExchangeFlag", "tradeObj.notionalExchangeFlag", Application.application.xResourceManager.getKeyValue('swp.alert.validator.notexchg')));
					}
					/* if (XenosStringUtils.isBlank(StringUtil.trim(value['tradeObj.dataSource']))) {
		            	results.push(new ValidationResult(true, "tradeObj.dataSource", "tradeObj.dataSource", Application.application.xResourceManager.getKeyValue('swp.alert.validator.datasrc')));
					} */
					if (XenosStringUtils.isBlank(StringUtil.trim(value['tradeObj.tradeDateStr']))) {
		            	results.push(new ValidationResult(true, "tradeObj.tradeDateStr", "tradeObj.tradeDateStr", Application.application.xResourceManager.getKeyValue('swp.alert.validator.trddt')));
					}
					if (XenosStringUtils.isBlank(StringUtil.trim(value['tradeObj.effectiveDateStr']))) {
		            	results.push(new ValidationResult(true, "tradeObj.effectiveDateStr", "tradeObj.effectiveDateStr", Application.application.xResourceManager.getKeyValue('swp.alert.validator.effdt')));
					}
					if (XenosStringUtils.isBlank(StringUtil.trim(value['tradeObj.maturityDateStr']))) {
		            	results.push(new ValidationResult(true, "tradeObj.maturityDateStr", "tradeObj.maturityDateStr", Application.application.xResourceManager.getKeyValue('swp.alert.validator.maturityDate')));
					}
					//Date field validation and date compare 
					var tradeDtStr:String = StringUtil.trim(value['tradeObj.tradeDateStr']);
					var effDtStr:String = StringUtil.trim(value['tradeObj.effectiveDateStr']);
					var matDtStr:String = StringUtil.trim(value['tradeObj.maturityDateStr']);
					var validDate:Boolean = false;
					var tradeDt:Date = null;
					var effDt:Date = null;
					var matDt:Date = null;
					
					var dateformat:CustomDateFormatter = new CustomDateFormatter();
					dateformat.formatString="YYYYMMDD";
					
					if(tradeDtStr != ""){
			            validDate = DateUtils.isValidDate(tradeDtStr) ;            
			            if(!validDate) {
			                results.push(new ValidationResult(true, "tradeObj.tradeDateStr'", "illegaltradeDateStr", Application.application.xResourceManager.getKeyValue('swp.alert.validator.illegaldate')+" " + tradeDtStr));
			            }else{
			            	tradeDt = dateformat.toDate(CustomDateFormatter.customizedInputDateString(tradeDtStr));
			            }
		            }
		        	
		        	if(effDtStr != ""){ 
			            validDate = DateUtils.isValidDate(effDtStr) ;            
			            if(!validDate) {
			                results.push(new ValidationResult(true, "tradeObj.effectiveDateStr'", "illegaleffectiveDateStr", Application.application.xResourceManager.getKeyValue('swp.alert.validator.illegaldate')+" " + effDtStr));
			            }else{
			            	effDt = dateformat.toDate(CustomDateFormatter.customizedInputDateString(effDtStr));
			            }
		            }
		        	 
					if(matDtStr != ""){
						validDate = DateUtils.isValidDate(matDtStr) ;            
						if(!validDate) {
							results.push(new ValidationResult(true, "tradeObj.maturityDateStr'", "illegalmaturityDateStr", Application.application.xResourceManager.getKeyValue('swp.alert.validator.illegaldate')+" " + matDtStr));
						}else{
							matDt = dateformat.toDate(CustomDateFormatter.customizedInputDateString(matDtStr));
						}
					}
					
					if((tradeDt != null) && (effDt != null)) {
						if(ObjectUtil.dateCompare(effDt,tradeDt) == -1){
			        		results.push(new ValidationResult(true, 
			                    "", "tradeDtLessThanEffDt",  Application.application.xResourceManager.getKeyValue('swp.alert.valdate.tradeDtLessThanEffDt')));
			        	}
					}
	
					if((effDt != null) && (matDt != null)){
		        		if(ObjectUtil.dateCompare(matDt,effDt) != 1){
			        		results.push(new ValidationResult(true, 
			                    "", "effDtLessThanMatDt",  Application.application.xResourceManager.getKeyValue('swp.alert.valdate.effDtLessThanMatDt')));
			        	}
		        	}
					
					//for product type = Interest Rate Swap,notinal exchange flag = No
					var productType:String = StringUtil.trim(value['tradeObj.productTypeLbl']);
					var notExchgFlg:String = StringUtil.trim(value['tradeObj.notionalExchangeFlag']);
					
					if(XenosStringUtils.equals(productType, Globals.IRS_LABEL) 
						&& XenosStringUtils.equals(notExchgFlg, Globals.DATABASE_YES)){
							results.push(new ValidationResult(
								true, "tradeObj.notionalExchangeFlag'", "invalidnotionalExchange", 
								Application.application.xResourceManager.getKeyValue('swp.alert.validator.invalidnotexchg')));
					}
				
				}
				
				
				
				return results;
			}
		}
	}
}