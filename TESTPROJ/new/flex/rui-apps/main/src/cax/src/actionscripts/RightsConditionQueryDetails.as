
 import com.nri.rui.core.controls.XenosAlert;
 
 import mx.rpc.events.ResultEvent;
 
 	[Bindable]
    private var queryResult:XML= new XML();
  /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    private function submitDetailQuery():void {
    	loadTitleText();  
    	parseUrlString();   	
    	
		var req : Object = new Object();
		req.rightsConditionPk=entryPk;
		rightsConditionDetailsRequest.request=req;
		
    	rightsConditionDetailsRequest.send();
    }
    
    public function loadTitleText():void{
      	stockMergerPart3.instrumentcodelbl=this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.instrumentcode');
		stockMergerPart3.securitynamelbl=this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.securityname');
		stockMergerPart3.persharelbl=this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.pershare');
		stockMergerPart3.allotmentquantitylbl=this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.allotmentquantity');
		stockMergerPart3.ccycashdividendlbl=this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.ccycashdividend');
		stockMergerPart3.allotmentamountlbl=this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.allotmentamount');
		stockMergerPart3.persharecashdividendlbl=this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.persharecashdividend');
		stockMergerPart3.payOutcurrencylbl=this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.payoutccy');
		stockMergerPart3.payoutpricelbl=this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.payoutprice');
      } 
    
    private function parseUrlString():void {
        try {
            // Remove everything before the question mark, including
            // the question mark.
            var myPattern:RegExp = /.*\?/; 
            var s:String = this.loaderInfo.url.toString();
            s = s.replace(myPattern, "");
            // Create an Array of name=value Strings.
            var params:Array = s.split("&"); 
             // Print the params that are in the Array.
            var keyStr:String;
            var valueStr:String;
            var paramObj:Object = params;
          
            // Set the values of the salutation.
            for (var i:int = 0; i < params.length; i++) {
                var tempA:Array = params[i].split("=");  
                if (tempA[0] == "rightsConditionPk") {
                    entryPk = tempA[1];
                } 
            }                    
			
        } catch (e:Error) {
            trace(e);
        }
       
    }
 /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    public function onResult(event:ResultEvent):void {
    	if (null != event) {      
    		if(null == event.result){
                //queryResult.removeAll(); // clear previous data if any as there is no result now.
            	if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
            	  XenosAlert.info("No Result Found!");
            	} else { // Must be error
            		
            	}            	
            }else {
            	queryResult = event.result as XML;
            	stateChangeHandler();
	        } 
        }else {
            //queryResult.removeAll();
            XenosAlert.info("No Results Found");
        }
    }
