package com.nri.rui.swp.validator
{
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	
	import mx.core.Application;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	public class CashflowQueryValidator extends Validator
	{
		public var results:Array=[];
		
		public function CashflowQueryValidator()
		{
			super();
		}
		
		protected override function doValidation(queryModel:Object):Array
		{
			results = super.doValidation(queryModel);            
            if (results.length > 0)
            {
                return results;             
            }
            
            var dateList:Array = [];
            var dateObj:Array = [];
            
            var dateformat:CustomDateFormatter = new CustomDateFormatter();
            dateformat.formatString="YYYYMMDD";
            var formatData:String = "";
            
            var resetDateFrom:String =  queryModel.resetDateFrom;
            var resetDateTo:String =  queryModel.resetDateTo; 
            var valueDateFrom:String =  queryModel.valueDateFrom;
            var valueDateTo:String =  queryModel.valueDateTo; 
            var accrualStartDateFrom:String =  queryModel.accrualStartDateFrom;
            var accrualStartDateTo:String =  queryModel.accrualStartDateTo;
            var accrualEndDateFrom:String =  queryModel.accrualEndDateFrom;
            var accrualEndDateTo:String =  queryModel.accrualEndDateTo;
            var tradeDateFrom:String =  queryModel.tradeDateFrom;
            var tradeDateTo:String =  queryModel.tradeDateTo;
            var maturityDateFrom:String =  queryModel.maturityDateFrom;
            var maturityDateTo:String =  queryModel.maturityDateTo;
            var terminationDateFrom:String =  queryModel.terminationDateFrom;
            var terminationDateTo:String =  queryModel.terminationDateTo;
            
            if(resetDateFrom != ""){
                dateList.push(resetDateFrom);
                var objResetDateFrom:Date = dateformat.toDate(CustomDateFormatter.customizedInputDateString(resetDateFrom)); 
            }
            if(resetDateTo != ""){
                dateList.push(resetDateTo);
                var objResetDateTo:Date = dateformat.toDate(CustomDateFormatter.customizedInputDateString(resetDateTo));
            }            
            if(valueDateFrom != ""){
                dateList.push(valueDateFrom);
                var objValueDateFrom:Date = dateformat.toDate(CustomDateFormatter.customizedInputDateString(valueDateFrom));
            }
            if(valueDateTo != ""){
                dateList.push(valueDateTo);
                var objValueDateTo:Date = dateformat.toDate(CustomDateFormatter.customizedInputDateString(valueDateTo));
            }
            if(accrualStartDateFrom != ""){
                dateList.push(accrualStartDateFrom);
                var objAccrualStartDateFrom:Date = dateformat.toDate(CustomDateFormatter.customizedInputDateString(accrualStartDateFrom));
            }
            if(accrualStartDateTo != ""){
                dateList.push(accrualStartDateTo);
                var objAccrualStartDateTo:Date = dateformat.toDate(CustomDateFormatter.customizedInputDateString(accrualStartDateTo));
            }
            if(accrualEndDateFrom != ""){
                dateList.push(accrualEndDateFrom);
                var objAccrualEndDateFrom:Date = dateformat.toDate(CustomDateFormatter.customizedInputDateString(accrualEndDateFrom));
            }
            if(accrualEndDateTo != ""){
                dateList.push(accrualEndDateTo);
                var objAccrualEndDateTo:Date = dateformat.toDate(CustomDateFormatter.customizedInputDateString(accrualEndDateTo));
            }
            if(tradeDateFrom != "")
                dateList.push(tradeDateFrom);
            if(tradeDateTo != "")
                dateList.push(tradeDateTo);
            if(maturityDateFrom != "")
                dateList.push(maturityDateFrom);
            if(maturityDateTo != "")
                dateList.push(maturityDateTo);
            if(terminationDateFrom != "")
                dateList.push(terminationDateFrom);
            if(terminationDateTo != "")
                dateList.push(terminationDateTo);
                            
            for(var iterator:int=0; iterator<dateList.length; iterator++){
                formatData = dateformat.format(CustomDateFormatter.customizedInputDateString(dateList[iterator]));                
                if(DateUtils.isValidDate(StringUtil.trim(dateList[iterator]))){
                    dateObj[iterator] = dateformat.toDate(CustomDateFormatter.customizedInputDateString(dateList[iterator]));                 
                }else{                    
                    results.push(new ValidationResult(true,"toDate", "illegaltoDate",  Application.application.xResourceManager.getKeyValue('swp.cashflow.validator.illegalDateFormat') + dateList[iterator]));
                    return results;
                }            
            }
            
            for(var itr:int=0; itr<dateObj.length; itr+=2){
                var comDate:int = ObjectUtil.dateCompare(dateObj[itr],dateObj[itr+1]);
                // check Form Date not less than To Date
                if (comDate==1) {
                    results.push(new ValidationResult(true,"", "fromDateLessThantoDate",  Application.application.xResourceManager.getKeyValue('swp.cashflow.validator.fromtodate')));
                }
            }
             
            // Validate that Execution date is after Reset Date 
            if(resetDateFrom != "" && valueDateFrom != ""){
                var comDate1:int = ObjectUtil.dateCompare(objResetDateFrom, objValueDateFrom); // Compare between 'resetDateFrom' and 'valueDateFrom'	
            }            
            if(resetDateTo != "" && valueDateTo != ""){
                var comDate2:int = ObjectUtil.dateCompare(objResetDateTo, objValueDateTo); // Compare between 'resetDateTo' and 'valueDateTo'	
            }
            if(comDate1==1 || comDate2==1)
            {
            	results.push(new ValidationResult(true,"", "illegalExecutionDate",  Application.application.xResourceManager.getKeyValue('swp.cashflow.validator.illegalExecutionDate')));
            }
            
            
            // Validate that accrual end date is after accrual start date
            if(accrualStartDateFrom != "" && accrualEndDateFrom != ""){            
                var comDate3:int = ObjectUtil.dateCompare(objAccrualStartDateFrom, objAccrualEndDateFrom); // Compare between 'accrualStartDateFrom' and 'accrualEndDateFrom'
            }
            if(accrualStartDateTo != "" && accrualEndDateTo != ""){            
                var comDate4:int = ObjectUtil.dateCompare(objAccrualStartDateTo, objAccrualEndDateTo); // Compare between 'accrualStartDateTo' and 'accrualEndDateTo'
            }
            if(comDate3==1 || comDate4==1)
            {
                results.push(new ValidationResult(true,"", "illegalAccrualDate",  Application.application.xResourceManager.getKeyValue('swp.cashflow.validator.accrualEndLessThanStart')));
            }
                       
                        
            return results;
		}
		
	}
}