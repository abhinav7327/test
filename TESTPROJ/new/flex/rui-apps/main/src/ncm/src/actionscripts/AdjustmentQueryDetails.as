
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.utils.XenosPopupUtils;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.ncm.NcmConstants;
 
 import mx.core.UIComponent;
 import mx.rpc.events.ResultEvent;
 import mx.utils.StringUtil;
 
 	[Bindable]
    private var queryResult:XML= new XML();
  /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    private function submitDetailQuery():void {  
    	parseUrlString();
    	var req : Object = new Object();
    	req.ncmEntryPk = entryPk;
    	
    	adjustmentDetailRequest.request = req;
    	adjustmentDetailRequest.send();
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
                if (tempA[0] == NcmConstants.NCM_ENTRY_PK) {
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
            	  XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            	} else { // Must be error
            		
            	}            	
            }else {
            	queryResult = event.result as XML;
            	setLabel();
	        } 
        }else {
            //queryResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }
    }
  /**
   * This method is used for loading FinInstPopUp module 
   * 
   */  
   public function showFinInstDetail():void{
		
			var finInstPkStr : String = queryResult.entry.bankPk;
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			XenosPopupUtils.showFinInstDetails(finInstPkStr,parentApp);
	}
   
   /**
   * This method is used for loading Account Details popup module
   * 
   */  
   public function showAccountDetail():void{
   			var accPkStr : String = queryResult.entry.accountPk;
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			XenosPopupUtils.showAccountSummary(accPkStr,parentApp);
   }
   
   /**
   * This method is used for loading Fund Details popup module
   * 
   */  
   public function showFundDetail():void{
   			var fundPkStr : String = queryResult.entry.fundPk;
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			XenosPopupUtils.showFundCodeDetails(fundPkStr,parentApp);
   }
   public function showSeccurityDetail():void{
   			var securityPkStr : String = queryResult.entry.instrumentPk;
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			XenosPopupUtils.showInstrumentDetails(securityPkStr,parentApp);
			
   }
      
    private function setLabel():void{
    	var secCode:String = queryResult.entry.securityCode;
    	
    	if(secCode!= null){
		   	if(StringUtil.trim(secCode) != XenosStringUtils.EMPTY_STR){
		   		sec.visible = true;
		  		sec.includeInLayout = true;
		  		ccy1.visible = true; 
		  		ccy1.includeInLayout = true;
		  		altsec.visible = true;
		  		altsec.includeInLayout = true;		
		   	}else{		   		
     	   		sec.visible = false;
		  		sec.includeInLayout = false;
		  		altsec.visible = false;
		  		altsec.includeInLayout = false;
		  	    ccy2.visible = true; 
		  		ccy2.includeInLayout = true;  
		   	}
    	}
   } 