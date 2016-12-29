// ActionScript file


package com.nri.rui.trd.validator
{
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.core.Application;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
   
    /**
     * Custom Validator for Banking Trade Entry Implementation.
     * 
     */
	public class TradeEntryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function TradeEntryValidator() {
			super();
		}
		
		/**
         * validate banking trade entry form
         */ 
        protected override function doValidation(value:Object):Array {
        	
        	// Clear results Array.
            results = [];
            var formatData:String ="";
            var dateformat:CustomDateFormatter = new CustomDateFormatter();

            // Call base class's doValidation().
            results = super.doValidation(value);

            // Return if there are errors.
            if (results.length > 0)
                return results;
        	
        	/**
        	 * Do validation for Spcila Amend
        	 */
        	if( value.hasOwnProperty("isSpecialAmend") ){
        		/**
	        	 * Write validation Here
	        	 */
	        	 if( XenosStringUtils.isBlank(value.originalDataSource) ){
	        	 	results.push(new ValidationResult(true, 
	                    "originalDataSource",
	                    "originalDataSourceMissing",
	                    Application.application.xResourceManager.getKeyValue('trd.originaldatasource.missing')));
        		 }
        		 return results;
        	}
        	
        	var tradeDateDt:Date = null;
        	if(value.tradeDate != ""){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString="YYYYMMDD";
	            formatData="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.tradeDate));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.tradeDate))) {
	                
	                results.push(new ValidationResult(true, 
	                    "tradeDate", "illegalTradeDate", Application.application.xResourceManager.getKeyValue('trd.trddate.illegal')  + value.tradeDate));
	            }else{
	            	tradeDateDt = dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.tradeDate));
	            }
        	}else{
        		 results.push(new ValidationResult(true, 
	                    "tradeDate", "tradeDateMissing", Application.application.xResourceManager.getKeyValue('trd.trddate.missing')));
        	}
        	var valueDateDt:Date = null;
        	if(value.valueDate != ""){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString="YYYYMMDD";
	            formatData="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.valueDate));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.valueDate))) {
	                results.push(new ValidationResult(true, 
	                    "valueDate", "illegalValueDate", Application.application.xResourceManager.getKeyValue('trd.valdate.illegal')  + value.valueDate));
	            }else{
	            	valueDateDt = dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.valueDate));
	            }
        	}
        	var comDate:int = 0;
        	if(valueDateDt != null && tradeDateDt != null){
        		if(ObjectUtil.dateCompare(tradeDateDt,valueDateDt) == 1){
	        		results.push(new ValidationResult(true, 
	                    "", "valueDateLessThanTradeDate",  Application.application.xResourceManager.getKeyValue('trd.trddate.valdate.compare')));
	        	}
        	}
        	
        	
        	if(value.buySell == null || StringUtil.trim(value.buySell) == ""){
        		 results.push(new ValidationResult(true, 
	                    "buySell", "buySellMissing",  Application.application.xResourceManager.getKeyValue('trd.buysell.missing')));
        	}
        	
        	if(value.fundAccNo == null || StringUtil.trim(value.fundAccNo) == ""){
        		 results.push(new ValidationResult(true, 
	                    "fundAccNo", "fundAccNoMissing",  Application.application.xResourceManager.getKeyValue('trd.fundaccount.missing')));
        	}
        	
        	if(value.brokerAccNo == null || StringUtil.trim(value.brokerAccNo) == ""){
        		 results.push(new ValidationResult(true, 
	                    "brokerAccNo", "brokerAccNoMissing",  Application.application.xResourceManager.getKeyValue('trd.brokeraccount.missing')));
        	}
        	
        	if(value.securityCode == null || StringUtil.trim(value.securityCode) == ""){
        		 results.push(new ValidationResult(true, 
	                    "securityCode", "securityCodeMissing",  Application.application.xResourceManager.getKeyValue('trd.seccode.missing')));
        	}
        	
        	if(value.quantity == null || StringUtil.trim(value.quantity) == ""){
        		 results.push(new ValidationResult(true, 
	                    "quantity", "quantityMissing",  Application.application.xResourceManager.getKeyValue('trd.quantity.missing')));
        	}
        	
        	if(value.inputPrice == null || StringUtil.trim(value.inputPrice) == ""){
        		 results.push(new ValidationResult(true, 
	                    "inputPrice", "inputPriceMissing",  Application.application.xResourceManager.getKeyValue('trd.inputprice.missing')));
        	}
        	if(value.grossNetType == null || StringUtil.trim(value.grossNetType) == ""){
        		 results.push(new ValidationResult(true, 
	                    "grossNetType", "grossNetTypeMissing",  Application.application.xResourceManager.getKeyValue('trd.grossnettype.missing')));
        	}
        	if(value.inputPriceFormat == null || StringUtil.trim(value.inputPriceFormat) == ""){
        		 results.push(new ValidationResult(true, 
	                    "inputPriceFormat", "inputPriceFormatMissing",  Application.application.xResourceManager.getKeyValue('trd.inputpriceformat.missing')));
        	}
        	
        	if(value.isInFirstEntryPage == "false"){
	        	//if(value.isAmend == "true"){
	        		// check for whether remark is set from list
	        		if(value.isRemarksList == "true"){
	        			if(value.remarksFromList == null || StringUtil.trim(value.remarksFromList) == ""){
        		         results.push(new ValidationResult(true, 
			                    "remarks", "remarksMissing",  Application.application.xResourceManager.getKeyValue('trd.remarks.missing')));
        				}
	        		}
	        		else{
	        			if(value.remarks == null || StringUtil.trim(value.remarks) == ""){
		        		 results.push(new ValidationResult(true, 
			                    "remarks", "remarksMissing",  Application.application.xResourceManager.getKeyValue('trd.remarks.missing')));
		        	}
	        		}
	        		
	        	//}
        	}
        	return results;
        }
		
	}
}