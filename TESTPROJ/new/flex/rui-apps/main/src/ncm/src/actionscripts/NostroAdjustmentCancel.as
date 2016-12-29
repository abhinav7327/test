// ActionScript file

 
    import com.nri.rui.core.controls.CustomizeSortOrder;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.utils.XenosPopupUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    import com.nri.rui.ncm.NcmConstants;
    import com.nri.rui.core.utils.ProcessResultUtil;
    import flash.events.MouseEvent;
    
    import mx.collections.ArrayCollection;
    import mx.core.UIComponent;
    import mx.events.CloseEvent;
    import mx.rpc.events.ResultEvent;

    [Bindable]
    private var queryResult:XML= new XML();
    [Bindable]
    private var usrConfMsg:String = "";
     [Bindable]
    private var usrConfRefNo:String = "";
    private var rndNo:Number = 0;
	[Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    [Bindable]
    private var pkArrayColl:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var pkArray:Array = new Array();
    [Bindable]
 	private var rs:XML = new XML();
 	
 	private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    private var  csd:CustomizeSortOrder=null;
   /**
    * This method finds the details of the cancellable record.
    * 
    */
    private function getCancellableRecord():void {  
    	parseUrlString();
    	rndNo= Math.random();
    	var req : Object = new Object();
    	req.ncmEntryPk = entryPk;
    	req.SCREEN_KEY = 458;
		req.fromPage = "queryResult";
    	req.traversableIndex = "2";
    	nostroAdjustmentCxlDetailRequest.url =nostroAdjustmentCxlDetailRequest.url +"&rnd=" + rndNo
    	nostroAdjustmentCxlDetailRequest.request = req;
    	nostroAdjustmentCxlDetailRequest.send();
    }
    /**
     * Parses the url to find the supplied entry pk 
     */ 
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
    * This also takes care of the buttons/images to be shown on teh top panel of the
    * result .
    */
	private function onResult(event:ResultEvent):void
	{
		rs = XML(event.result);
		//XenosAlert.info(rs);
		if (null != event) {
			if(rs.child("resultView2List").resultView2.length()>0) {
				errPage.clearError(event);
	            summaryResult.removeAll();
				try {
				    for each ( var rec:XML in rs.resultView2List.resultView2) {
	 				    summaryResult.addItem(rec);
	 				    pkArrayColl.addItem(rec.ncmEntryPk);
				    }
				    //XenosAlert.info(pkArrayColl.toString());
		            
	     	        //replace null objects in datagrid with empty string
	            	summaryResult=ProcessResultUtil.process(summaryResult, adjustmentSummary.columns);
	            	summaryResult.refresh();
		            /*
		            if(summaryResult.length==1 && !XenosStringUtils.equals(Globals.MODE_DELETE,mode)){
		            	displayDetailView(summaryResult[0].ncmEntryPk);
		            }
		            */
	            	
				}catch(e:Error){
				    //XenosAlert.error(e.toString() + e.message);
				    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			    }
			} else if(rs.child("Errors").length()>0) {
                //some error found
			 	summaryResult.removeAll(); // clear previous data if any as there is no result now.
			 	var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list 			 	
			 	for each ( var error:XML in rs.Errors.error ) {
	 			   errorInfoList.addItem(error.toString());
				}
			 	errPage.showError(errorInfoList);//Display the error
			} else {
			 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ncm.nostrodelete.prompt.record.modified'));
			 	summaryResult.removeAll(); // clear previous data if any as there is no result now.
			 	errPage.removeError(); //clears the errors if any
			 	backToInitPage();
			}
        }
     } 
    /**
     * Go to the previous window.
     */ 
    private function doBack(event:MouseEvent):void{
        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    }
    /**
     * User confirmation for deletion.
     */ 
    private function doDeleteConfirm(event:MouseEvent):void{
    	pkArray = pkArrayColl.toArray();
    	var reqObj : Object = new Object();
    	reqObj.unique = new  Date().getTime() + "";
    	reqObj.SCREEN_KEY = 459; 
    	reqObj.ncmEntryPkList = pkArray;
    	nostroAdjustmentDeleteConfirm.request = reqObj;
        nostroAdjustmentDeleteConfirm.send();
    }
    /**
     * This method works as the result handler of the nostroAdjustmentDeleteConfirm Http Service.
     * 
     */
    public function confirmResult(event:ResultEvent):void {
        if (null != event && null != event.result) { //result format is e4x 
    	    queryResult = event.result as XML;    	    	        
    		if(XenosStringUtils.equals("failure", queryResult.pageSummary.status)){//No successfull result                
            	if(null == queryResult.Errors){ // i.e. No result but no Error found.
            	    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            	} else { // Must be error            	        
            		errPage.displayError(event);
            		ajdDelete.includeInLayout = false;
                	ajdDelete.visible = false;
            		ajdDeleteUsrConfrm.includeInLayout = true;
            		ajdDeleteUsrConfrm.visible = true;
            		backDeletePage.includeInLayout = false;
            		backDeletePage.visible = false;
            		backToSummary.includeInLayout = true;
            		backToSummary.visible = true;
            		delUsrCnf.enabled = false;
            	}
            	            	
            }else {                   	
                this.parentDocument.title = parentApplication.xResourceManager.getKeyValue('ncm.nostro.adjustment') + " " + parentApplication.xResourceManager.getKeyValue('inf.title.cancel.user.confirmation');
                //adjustmentCancel.selectedChild = adjDeleteUsrCnf;
            	//queryResult = event.result as XML;
            	//usrConfMsg = parentApplication.xResourceManager.getKeyValue('ncm.nostrodelete.confirmation.message'); 
            	//usrConfRefNo = parentApplication.xResourceManager.getKeyValue('ncm.nostro.referenceno') + " : "+ queryResult.entry.referenceNo;
                
                //delUsrCnf.enabled = true;    
                userConfirmhb.includeInLayout = true;
                userConfirmhb.visible = true;
                ajdDelete.includeInLayout = false;
                ajdDelete.visible = false;
                ajdDeleteUsrConfrm.includeInLayout = true;
                ajdDeleteUsrConfrm.visible = true; 	                    
	        } 
        }else {            
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }
    }
    /**
     *  Go back to delete page 
     */ 
    private function backToDeletePage(event:MouseEvent):void {
        this.parentDocument.title = parentApplication.xResourceManager.getKeyValue('ncm.nostro.adjustment') + " " + parentApplication.xResourceManager.getKeyValue('inf.title.cancel');
        //adjustmentCancel.selectedChild = adjDeleteDtl;
        userConfirmhb.includeInLayout = false;
        userConfirmhb.visible = false;
        ajdDelete.includeInLayout = true;
        ajdDelete.visible = true;
        ajdDeleteUsrConfrm.includeInLayout = false;
        ajdDeleteUsrConfrm.visible = false; 	
    }
    /**
     * Perform the Save operation.
     */ 
    private function doSave(event:MouseEvent):void{
    	delUsrCnf.enabled=false;
    	var reqObj : Object = new Object();
    	reqObj.unique = new  Date().getTime() + "";
    	reqObj.SCREEN_KEY = 460; 
    	nostroAdjustmentDeleteSysConfirm.request = reqObj;
        nostroAdjustmentDeleteSysConfirm.send();
    }
    /**
     * This method works as the result handler of the nostroAdjustmentDeleteSysConfirm Http Service.
     * 
     */
    public function sysConfirmResult(event:ResultEvent):void {
    	delUsrCnf.enabled=true;
        if (null != event && null != event.result) { //result format is e4x 
    	    queryResult = event.result as XML;    	    
    		if(XenosStringUtils.equals("failure", queryResult.pageSummary.status)){//No successfull result
                //queryResult.removeAll(); // clear previous data if any as there is no result now.
            	if(null == queryResult.Errors){ // i.e. No result but no Error found.
            	    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            	} else { // Must be error
            		ajdDeleteUsrConfrm.includeInLayout = true;
            		ajdDeleteUsrConfrm.visible = true;
            		userConfirmhb.includeInLayout = false;
            		userConfirmhb.visible = false;
            		errPage.displayError(event);
            		backDeletePage.includeInLayout = false;
            		backDeletePage.visible = false;
            		backToSummary.includeInLayout = true;
            		backToSummary.visible = true;
            		delUsrCnf.enabled = false;
            	}    	           	
            }else {
                this.parentDocument.title = parentApplication.xResourceManager.getKeyValue('ncm.nostro.adjustment') + " " + parentApplication.xResourceManager.getKeyValue('inf.title.cancel.system.confirmation');
                //adjustmentCancel.selectedChild = adjDeleteSysCnf;
            	//queryResult = event.result as XML;
            	userConfirmhb.includeInLayout = false;
                userConfirmhb.visible = false;
                //ajdDelete.includeInLayout = false;
                //ajdDelete.visible = false;
                ajdDeleteUsrConfrm.includeInLayout = false;
                ajdDeleteUsrConfrm.visible = false;
                sysConfirmhb.includeInLayout = true;
                sysConfirmhb.visible= true;
                ajdDeleteSysConfrm.includeInLayout = true;
                ajdDeleteSysConfrm.visible = true; 	 

	        } 
        }else {
            //queryResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }
    }
    /**
     * Go to the Initial Cancel Query Result page.
     */ 
    private function backToInitPage():void{        
        this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
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
  