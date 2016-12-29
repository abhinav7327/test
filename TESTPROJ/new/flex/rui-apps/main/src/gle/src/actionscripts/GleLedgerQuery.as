
 // ActionScript file for Gle Journal Query
 
    
    import com.nri.rui.gle.renderers.LedgerDetailsRenderer;
    
    import flash.events.MouseEvent;
    
    import com.nri.rui.core.Globals;
	import com.nri.rui.core.containers.SummaryPopup;
	import com.nri.rui.gle.GleConstraints;
    import com.nri.rui.core.startup.XenosApplication;
    import mx.collections.ArrayCollection;
    import mx.events.ModuleEvent;
    import mx.events.ResourceEvent;
    import mx.resources.ResourceBundle;
    import mx.rpc.events.ResultEvent;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
    import com.nri.rui.core.utils.ProcessResultUtil;
    	
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    /**
	 * This method should be called on creationComplete of the datagrid 
	 */ 
	 private function bindDataGrid():void {
		qh.dgrid = resultSummary;
	} 
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    private function initPageStart():void {            
        if (!initCompFlg) {    
            rndNo= Math.random();
            var req : Object = new Object();
   			req.SCREEN_KEY = 292;
    	    initializeGleLedger.request = req;         
            initializeGleLedger.url = "gle/gleLedgerQueryDispatchAction.action?method=initialExecute&mode=query&rnd=" + rndNo;                    
            initializeGleLedger.send();        
        } else
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.initiate'));
    }
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * 
    */   
    private function initPage(event: ResultEvent) : void {
        var i:int = 0;
        var dateStr:String = null;
        var initColl:ArrayCollection = new ArrayCollection();
        var tempColl: ArrayCollection;
        var date:Date = null;
        
        errPage.clearError(event); //clears the errors if any 
        //initiate text fields
        
        lCode.text = "";
        //ltype.text = "";
        sName.text = "";        
        lName.text = "";
       /* balanceEntryDate.text = ""; 
        ledgerCodeFrom.gleCode.setFocus();
        balanceEntryDateTo.text = "";*/
        
        if(event.result == null || event.result.gleLedgerEntryActionForm == null){
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('gle.label.error.occured.initialize'));
        }       
        
        
        //3. Setting values of the balanceTypes
        initColl.removeAll();
        if(event.result.gleLedgerEntryActionForm.ledgerTypeValuesList.item != null) {
            if(event.result.gleLedgerEntryActionForm.ledgerTypeValuesList.item is ArrayCollection)
                initColl = event.result.gleLedgerEntryActionForm.ledgerTypeValuesList.item as ArrayCollection;
            else
                initColl.addItem(event.result.gleLedgerEntryActionForm.ledgerTypeValuesList.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        ltype.dataProvider = tempColl;
        
        
        initColl.removeAll();
        if(event.result.gleLedgerEntryActionForm.statusValuesList.item != null) {
            if(event.result.gleLedgerEntryActionForm.statusValuesList.item is ArrayCollection)
                initColl = event.result.gleLedgerEntryActionForm.statusValuesList.item as ArrayCollection;
            else
                initColl.addItem(event.result.gleLedgerEntryActionForm.statusValuesList.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        status.dataProvider = tempColl;
        
        
        initColl.removeAll();
        if(event.result.gleLedgerEntryActionForm.subCodeTypeValuesList.item != null) {
            if(event.result.gleLedgerEntryActionForm.subCodeTypeValuesList.item is ArrayCollection)
                initColl = event.result.gleLedgerEntryActionForm.subCodeTypeValuesList.item as ArrayCollection;
            else
                initColl.addItem(event.result.gleLedgerEntryActionForm.subCodeTypeValuesList.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        sCodeType.dataProvider = tempColl;       
    
    }
    /**
    * It sends/submits the query. 
    * 
    */
    private function submitQuery():void 
    {  
        //Reset Page No
    	qh.resetPageNo();
        //Set the request parameters
     	var requestObj :Object = populateRequestParams();
     	
     	gleLedgerQueryRequest.request = requestObj; 
                
            //send the submit request 
            gleLedgerQueryRequest.send();
    }
    /**
     * This method will populate the request parameters for the
     * submitQuery call and bind the parameters with the HTTPService
     * object.
     */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	reqObj.SCREEN_KEY = 779;
    	reqObj.method = "submitQuery";
    	reqObj.ledgerCode = this.lCode.text;
    	reqObj.ledgerType = this.ltype.selectedItem !=null ? this.ltype.selectedItem.value :"";
    	reqObj.shortName = this.sName.text;
    	reqObj.subcodeType = this.sCodeType.selectedItem !=null ? this.sCodeType.selectedItem.value :"";
    	reqObj.longName = this.lName.text;
    	reqObj.status = this.status.selectedItem !=null ? this.status.selectedItem.value :"";
    	
    	reqObj.rnd = Math.random() + "";
    	return reqObj;
    }
    /**
     * This method sends the HttpService for Next Set of results operation.
     * This is actually server side pagination for the next set of results.
     */ 
     private function doNext():void { 
        var reqObj : Object = new Object();
    	reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
    	gleLedgerQueryRequest.request = reqObj;
        gleLedgerQueryRequest.send();
    } 
    /**
     * This method sends the HttpService for Previous Set of results operation.
     * This is actually server side pagination for the previous set of results.
     */ 
     private function doPrev():void { 
		var reqObj : Object = new Object();
    	reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
    	gleLedgerQueryRequest.request = reqObj;
        gleLedgerQueryRequest.send();
    }
    /**
     * This method sends the HttpService for reset operation.
     * 
     */
    private function resetQuery():void { 
    	var obj:Object=new Object();
    	obj.method="initialExecute";
    	obj.mode="query";
    	gleLedgerResetQueryRequest.request=obj;
        gleLedgerResetQueryRequest.send();
    }
    /**
     * This method works as the result handler of the Submit Query Http Services.
     * 
     */
     private function loadSummaryPage(event:ResultEvent):void {
    	
     	//changeColumnOrder(event);
		var rs:XML = XML(event.result);
	
		if (null != event) {
			if(rs.child("row").length()>0) {
				errPage.clearError(event);
	            summaryResult.removeAll();
				try {
				    for each ( var rec:XML in rs.row ) {
	 				    summaryResult.addItem(rec);
				    }
				    
				    changeCurrentState();
		            qh.setOnResultVisibility();
		            
		            qh.setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
		            qh.PopulateDefaultVisibleColumns();
	     	        //replace null objects in datagrid with empty string
	            	summaryResult=ProcessResultUtil.process(summaryResult,resultSummary.columns);
	             	summaryResult.refresh();
	             	if(summaryResult!=null && summaryResult.length == 1 && (summaryResult[0].ledgerPkStr!=null || StringUtil.trim(summaryResult[0].ledgerPkStr)!="")){
        					displayLedgerDetail(summaryResult[0].ledgerPkStr);
        			}
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
			 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			 	summaryResult.removeAll(); // clear previous data if any as there is no result now.
			 	errPage.removeError(); //clears the errors if any
			 }
		
        }
     }
    
    public function displayLedgerDetail(ledgerPkStr:String):void {
			
			var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
			
			sPopup.title = "Gle Ledger Details";
			sPopup.width = this.parentApplication.width - 100;
    		sPopup.height = 420;
			PopUpManager.centerPopUp(sPopup);		
			sPopup.moduleUrl = GleConstraints.GLE_LEDGER_DETAILS_SWF+Globals.QS_SIGN+GleConstraints.LEDGER_PK+Globals.EQUALS_SIGN+ledgerPkStr;
			
		}
    
	/**
	 * Loading the initial configuaration.
	 * 
	 */
	private function loadAll():void {
    }
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
    	var url : String = "gle/gleLedgerQueryDispatchAction.action?method=generateXLS";
    	var request:URLRequest = new URLRequest(url);
    	request.method = URLRequestMethod.POST;
    	// set menu pk in the request
      	var variables:URLVariables = new URLVariables();
      	variables.menuPk = this.parentApplication.mdiCanvas.getwindowKey();
      	request.data = variables;
    	 try {
                navigateToURL(request,"_blank");
            }
            catch (e:Error) {
                // handle error here
                trace(e);
            }
    } 
    /**
    * This will generate the Pdf report for the entire query result set 
    * and will open in a separate window.
    */
     private function generatePdf():void {
    	var url : String = "gle/gleLedgerQueryDispatchAction.action?method=generatePDF";
    	var request:URLRequest = new URLRequest(url);
    	request.method = URLRequestMethod.POST;
    	// set menu pk in the request
      	var variables:URLVariables = new URLVariables();
      	variables.menuPk = this.parentApplication.mdiCanvas.getwindowKey();
      	request.data = variables;
    	 try {
                navigateToURL(request,"_blank");
            }
            catch (e:Error) {
                // handle error here
                trace(e);
            }
    } 
    /**
    * This is for the Print button which at a  time will print all the data 
    * in the dataprovider of the Datagrid object
    */
     private function doPrint():void{
    	/* var printObject:XenosPrintView = new XenosPrintView();
    	printObject.frmPrintHeader.lbl.text = "Cam Movement Query";
    	printObject.pDataGrid.dataProvider = movementSummary.dataProvider;
	    PrintDG.printAll(printObject); */
    } 
    
   public function getStatus(item:Object, column:DataGridColumn):String{
   	if(item=="CANCEL"){
   		return "CXL"
   	}
   	return " ";
   	
   }