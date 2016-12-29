
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.utils.XenosPopupUtils;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.ncm.NcmConstants;
 
 import mx.core.UIComponent;
 import mx.events.CloseEvent;
 import mx.rpc.events.ResultEvent;
 
 	[Bindable]
    private var queryResult:XML= new XML();
    [Bindable]
    private var usrConfRefNo:String = "";

  /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    private function submitDetailQuery():void {  
    	parseUrlString();
    	var req : Object = new Object();
    	req.ncmEntryPk = entryPk;
    	req.unique= new Date().getTime()+"";
    	req.SCREEN_KEY = 466;
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
        	if (null != event && null != event.result) { //result format is e4x 
    	    queryResult = event.result as XML;    	    
    		if(XenosStringUtils.equals("failure", queryResult.pageSummary.status)){//No successfull result
                //queryResult.removeAll(); // clear previous data if any as there is no result now.
            	if(null == queryResult.Errors){ // i.e. No result but no Error found.
            	    XenosAlert.info(parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            	} else { // Must be error
            		errPage.displayError(event);
            	}
            	submit.enabled = false;            	
            }else {
                submit.enabled = true;
            	//queryResult = event.result as XML;
	        } 
        }else {
            //queryResult.removeAll();
            XenosAlert.info(parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
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
   /**
   * On clicking Back button from the Depository Cancel UI screen,
   * back to query result page.
   */
   public function backToQueryResult():void 
   {
		this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
   } 
   
   /**
   * On clicking the Submit button from the Depository Cancel UI
   * the User Confirmation Page is displayed.
   */
    private function submitToUserConfirm():void {  
    	var reqObj : Object = new Object();
    	reqObj.unique = new  Date().getTime() + "";
    	reqObj.SCREEN_KEY = 467;
    	adjustmentCancelRequest.request = reqObj;
    	adjustmentCancelRequest.send();
    } 

	/**
	 * Result event of Submit from the Depository Adjustment Cancel UI 
	 */
    public function onUserConfirmation(event:ResultEvent):void 
    {
    	var result:XML= new XML();
        if (null != event && null != event.result) { //result format is e4x 
    	    result = event.result as XML;    	    	        
    		if(XenosStringUtils.equals("failure", result.pageSummary.status)){//No successfull result                
            	if(null == result.Errors){ // i.e. No result but no Error found.
            	    XenosAlert.info(parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            	} else { // Must be error            	        
            		errPage.displayError(event);
            	}
            	//delUsrCnf.enabled = false;            	
            }else {                   	
		    	this.parentDocument.title = parentApplication.xResourceManager.getKeyValue('ncm.depository.adjustment') + " " + parentApplication.xResourceManager.getKeyValue('inf.title.cancel.user.confirmation');
		    	usrConfRefNo = result.entry.referenceNo;
		    	currentState = "userConfirm";
	        } 
        }else {            
            XenosAlert.info(parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }

        /*if (null != event && null != event.result) { //result format is e4x 
    	    queryResult = event.result as XML;    	    	        
	    	this.parentDocument.title = parentApplication.xResourceManager.getKeyValue('ncm.depository.adjustment') + " " + parentApplication.xResourceManager.getKeyValue('inf.title.cancel.user.confirmation');
	    	usrConfRefNo = queryResult.entry.referenceNo;
	    	currentState = "userConfirm";
        }*/
    }
    /**
    * On clicking the Back buttonj from the User Confirmation UI 
    * the Depository Cancel UI is displayed.
    */
    public function backToDetail():void 
    {
    	this.parentDocument.title = parentApplication.xResourceManager.getKeyValue('ncm.depository.cancel');
    	currentState = "cancelDetails";
    }
    
    /**
    * On clicking the Submit button from the User COnfirmation UI the record is Cancelled
    * and the System COnfirmation Ui is displayed
    */
    public function doSave():void 
    {
    	submit.enabled=false;
    	var reqObj : Object = new Object();
    	reqObj.unique = new  Date().getTime() + "";
    	reqObj.SCREEN_KEY = 468;
    	adjustmentSaveRequest.request = reqObj;
    	adjustmentSaveRequest.send();
    }
    /**
    * Result event of Submit from the user confirmation UI 
    */
    public function onSystemConfirmation(event:ResultEvent):void 
    {
    	submit.enabled=true;
        if (null != event && null != event.result) { //result format is e4x 
    	    queryResult = event.result as XML;    	    
    		if(XenosStringUtils.equals("failure", queryResult.pageSummary.status)){//No successfull result
                //queryResult.removeAll(); // clear previous data if any as there is no result now.
            	if(null == queryResult.Errors){ // i.e. No result but no Error found.
            	    XenosAlert.info(parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            	} else { // Must be error
            		errPage.displayError(event);
            		currentState = 'onError';
            	}    	           	
            }else {
		        this.parentDocument.title = parentApplication.xResourceManager.getKeyValue('ncm.depository.adjustment') + " " + parentApplication.xResourceManager.getKeyValue('inf.title.cancel.system.confirmation');
		        // Load User COnfirmation State
		    	currentState = "saveSuccess";
            }
        }else{
            //queryResult.removeAll();
            XenosAlert.info(parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }
    }
    
    /**
    * On Clicking the Ok button the System Confirmation UI, the Refreshed Summary Result 
    * page will be displayed  
    */
    public function doRefreshSummaryPage():void 
    {
    	currentState = "";
    	this.parentDocument.dispatchEvent(new Event("RefreshChanges"));
    	this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    }
