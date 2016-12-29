




 // ActionScript file for Cash Refer Raw File Query
 	import com.nri.rui.core.Globals;
 	import com.nri.rui.core.controls.XenosAlert;
 	import com.nri.rui.core.startup.XenosApplication;
 	import com.nri.rui.core.utils.HiddenObject;
 	import com.nri.rui.core.utils.ProcessResultUtil;
 	
 	import mx.collections.ArrayCollection;
 	import mx.events.ResourceEvent;
 	import mx.resources.ResourceBundle;
 	import mx.rpc.events.ResultEvent;
    
    
    [Bindable]
    private var initColl:ArrayCollection;
    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    private var emptyResult:ArrayCollection= new ArrayCollection();
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    
    private var tempColl:ArrayCollection;
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    
    [Bindable]
    public var trnRefNo:String;
    
    [Bindable]
    public var intfPk:String;
    
    private var okLabel:String = "OK";
    
    public var o:Object = {};
    
    public var objIntf:Object = {};
    
    public function parseUrlString():void {
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
                if (tempA[0] == "trnRefNo") {
                    o.trnRefNo = tempA[1];
                    trnRefNo = o.trnRefNo;
                }
                //XenosAlert.info(trnRefNo);
            }
        } catch (e:Error) {
            trace(e);
        }
    }
    
    public function parseUrlStringForIntfPk():void {
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
                if (tempA[0] == "intfPk") {
                    objIntf.intfPk = tempA[1];
                    intfPk = objIntf.intfPk;
                }
                //XenosAlert.info(intfPk);
            }
        } catch (e:Error) {
            trace(e);
        }
    }
    
    
    /**
     * This method should be called on creationComplete of the datagrid 
     */ 
    private function bindDataGrid():void {
    	qh.resultHeader.text = "";
    	qh.pdf.visible = false;
        qh.xls.visible = false;
    	qh.dgrid = resultSummary;
    } 
    
    /**
     * Loading the initial configuaration.
     * 
     */
    private function loadAll():void {
    }
    
    
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    private function initPageStart():void {            
        
        //errPage.clearError(event);
        
        if (!initCompFlg) {
        	
        	var requestObj :Object = populateRequestParams();
         	initializeUserConfCashRawQuery.request = requestObj; 
        	  
            rndNo= Math.random();      
            initializeUserConfCashRawQuery.url = "rec/cashReferRawCancelDispatch.action?method=viewUserConfirmation&rnd=" + rndNo;                    
            initializeUserConfCashRawQuery.send();
        } else
            XenosAlert.info("Already Initiated!");
    }
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * 
    */   
    private function initPage(event: ResultEvent) : void {
        
		
        errPage.clearError(event); //clears the errors if any 
        
       
        
    }
    
    
    /**
    * It sends/submits the query. 
    * 
    */
    private function submitQuery():void {  
        submit.enabled=false;
	    var requestObj :Object = populateRequestParamsForCancellation();
	    cashUserConfRawQueryRequest.request = requestObj;
	    cashUserConfRawQueryRequest.send();
	    
    }
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
     private function populateRequestParamsForCancellation():Object {
        parseUrlStringForIntfPk();
        
        var reqObj : Object = new Object();
        reqObj.method = "doCancelAfterUserConf";
       	reqObj.intfPk = intfPk;
       	reqObj.SCREEN_KEY = 11026;
        return reqObj;
    }
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
     private function populateRequestParams():Object {
        parseUrlString();
        parseUrlStringForIntfPk();
        
        var reqObj : Object = new Object();
       	reqObj.trnRefNo = trnRefNo;
       	reqObj.intfPk = intfPk;
       	reqObj.SCREEN_KEY = 11025;
        return reqObj;
    }
    
    /**
    * This method closes the Pop-Up
    * 
    */
    private function close(event:Event):void {
    	if(backButton.label==okLabel) {
    		this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
            //this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    	}
    	this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    	//PopUpManager.removePopUp(UIComponent(this.parent.parent));
    }
    
   
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
     /*public function loadSummaryPage(event:ResultEvent):void {
        if (null != event) {            
            if(null == event.result.cashRawFileActionForm.usrConfCashList){
                queryResult.removeAll(); // clear previous data if any as there is no result now.
            	if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
            	    errPage.clearError(event); //clears the errors if any
            		XenosAlert.info("No Result Found!");
            	} else { // Must be error
            		errPage.displayError(event);	
            	}            	
            }else {
            	errPage.clearError(event);
            	queryResult.removeAll();
            	if(event.result.cashRawFileActionForm.usrConfCashList != null){
    	            if(event.result.cashRawFileActionForm.usrConfCashList.listRecCashRawFileQueryView is ArrayCollection) {
    	                queryResult = event.result.cashRawFileActionForm.usrConfCashList.listRecCashRawFileQueryView as ArrayCollection;
    	            } else {
    	                queryResult.removeAll();
    	                queryResult.addItem(event.result.cashRawFileActionForm.usrConfCashList.listRecCashRawFileQueryView);
                    }
                    var i:int;
	                for(i=0;i<queryResult.length;++i) {
	                	objIntf.intfPk = queryResult.getItemAt(i,0).intfPk;
	                	//XenosAlert.info("&&&&&&&&&"+objIntf.intfPk);
	                }
                    changeCurrentState();
    	        }else{                    
                    XenosAlert.info("No Results Found");
                } 
	             
	             //changeCurrentState();
	             qh.setOnResultVisibility();
                 qh.pdf.visible = false;
                 qh.xls.visible = false;
	             //qh.setPrevNextVisibility(Boolean(event.result.cashRawFileActionForm.usrConfCashList.prevTraversable),Boolean(event.result.cashRawFileActionForm.usrConfCashList.nextTraversable));
	             qh.PopulateDefaultVisibleColumns();
            }
            //refresh the results.
            queryResult.refresh(); 
        }else {
            queryResult.removeAll();
            XenosAlert.info("No Results Found");
        }
               
    }*/
    
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    public function loadSummaryPage(event:ResultEvent):void {
    	
    	var rs:XML = XML(event.result);
    	if (null != event) {
			
			if (rs.child("usrConfCashList").child("listRecCashRawFileQueryView").length()>0) {
				errPage.clearError(event);
	            summaryResult.removeAll();
				try {
				    for each ( var rec:XML in rs.usrConfCashList.listRecCashRawFileQueryView ) {
	 				    //XenosAlert.info("Hello: "+rec);
	 				    summaryResult.addItem(rec);
				    }
				    
				    changeCurrentState();
		            qh.setOnResultVisibility();
		           
		            qh.setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
		            qh.PopulateDefaultVisibleColumns();
	     	        //replace null objects in datagrid with empty string
	            	summaryResult=ProcessResultUtil.process(summaryResult, resultSummary.columns);
	            	summaryResult.refresh();
				} catch(e:Error) {
				    //XenosAlert.error(e.toString() + e.message);
				    XenosAlert.error("No result found");
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
			 	XenosAlert.info("No Result Found!");
			 	summaryResult.removeAll(); // clear previous data if any as there is no result now.
			 	errPage.removeError(); //clears the errors if any
			 }
			 
        }
    	
    }
    
    
    /**
    * 
    * 
    */
    public function requestCancel(event:ResultEvent):void {
    	 submit.enabled=true;
    	if(null != event.result.XenosErrors) {
	    	errPage.displayError(event);
	    } else {
	    	this.resultHead.visible = true;
	    	this.parentDocument.title = "System Confirmation";
	    	this.submit.visible = false;
        	this.backButton.label = okLabel;
	    }
    }
    /**
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specifdic  
      * requriment. 
      */
    private function populateContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
      
        //passing counter party type                
        var cpTypeArray:Array = new Array(1);
            cpTypeArray[0]="BANK/CUSTODIAN";
        myContextList.addItem(new HiddenObject("cpTypeContext",cpTypeArray));
    
        //passing account status 
        var actStatus:Array = new Array(1);
        actStatus[0]="OPEN";
        myContextList.addItem(new HiddenObject("statusContext",actStatus));
                       
        var actStatusArray:Array = new Array(2);
        actStatusArray[0]="S";
        actStatusArray[1]="B";
         myContextList.addItem(new HiddenObject("actTypeContext",actStatusArray));
        return myContextList;
    }
    
   
    /**
    * This is for the Print button which at a  time will print all the data 
    * in the dataprovider of the Datagrid object
    */
     private function doPrint():void{
       	/*var printObject:XenosPrintView = new XenosPrintView();
        printObject.frmPrintHeader.lbl.text = "Cam Movement Query";
        printObject.pDataGrid.dataProvider = movementSummary.dataProvider;
        PrintDG.printAll(printObject); */
    }
    
    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
      private function doNext():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
        initializeUserConfCashRawQuery.request = reqObj;
        initializeUserConfCashRawQuery.send();
    }  
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
      private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        initializeUserConfCashRawQuery.request = reqObj;
        initializeUserConfCashRawQuery.send();
    }   