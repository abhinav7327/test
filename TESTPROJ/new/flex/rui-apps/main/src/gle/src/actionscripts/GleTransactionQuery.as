
 // ActionScript file for Gle Journal Query
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.HiddenObject;
    import com.nri.rui.gle.validators.GleTransactionValidator;
    import com.nri.rui.core.utils.ProcessResultUtil;
    
    import mx.collections.ArrayCollection;
    import mx.events.ResourceEvent;
    import mx.events.ValidationResultEvent;
    import mx.resources.ResourceBundle;
    import mx.rpc.events.ResultEvent;
    import mx.controls.ComboBox;
    import mx.events.*;
    import com.nri.rui.core.controls.CustomizeSortOrder;
    import com.nri.rui.core.containers.SummaryPopup;
    import mx.core.UIComponent;
    import mx.managers.PopUpManager;
    import mx.utils.StringUtil;
    
        
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    
    private var sortFields:ArrayCollection=new ArrayCollection();

    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    
    private var  csd:CustomizeSortOrder=null;
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
   			req.SCREEN_KEY = 283;
    	    initializeGleTransactionQuery.request = req;         
            initializeGleTransactionQuery.url = "gle/journalQuery.action?method=initialExecute&rnd=" + rndNo;                    
            initializeGleTransactionQuery.send();
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
        // clear error if any 
         errPage.clearError(event);
		fundPopUp.fundCode.setFocus();         
        //initiate text fields
		bankActPopUp.accountNo.text="";
    	instPopUp.instrumentId.text="";
    	instPopUp.instrumentId.width = 120;
    	fundPopUp.fundCode.text="";
		ccyBox.ccyText.text="";
		invtActPopUp.accountNo.text="";
    	refNumber.text="";
    	cxlRefNumber.text="";
        
        //bankActPopUp.accountNo.setFocus();
        trialBalancePopUp.trialBalanceId.text ="";
        
        //0. Populating sort fields
        
        if(event.result == null || event.result.gleJournalQryActionForm == null){
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('gle.label.error.occured.initialize'));
        }        
        
        //1.Setting value of transaction DateFrom
        if(event.result.gleJournalQryActionForm.appregDateFrom!= null) {
        	dateStr=event.result.gleJournalQryActionForm.appregDateFrom;
        	transactionDateFrom.selectedDate=new Date(dateStr.substr(0,4),(Number(dateStr.substr(4,2))-1),dateStr.substr(6,2));
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('gle.error.label.date.from.initialize'));
        }
        
        //2.Setting value of transaction DateTo
        if(event.result.gleJournalQryActionForm.appregDateTo != null) {
            dateStr=event.result.gleJournalQryActionForm.appregDateTo;
            //XenosAlert.info("App Date :: " + dateStr + "date = " + dateStr.substr(0,4) + dateStr.substr(4,2) + dateStr.substr(6,2));
            if(dateStr != null)
                transactionDateTo.selectedDate = new Date(dateStr.substr(0,4),(Number(dateStr.substr(4,2))-1),dateStr.substr(6,2));
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('gle.error.label.date.to.initialize'));
        }
        
        //3. Setting values of the processtypes
        initColl.removeAll();
        if(event.result.gleJournalQryActionForm.processTypeValues.item != null) {
            if(event.result.gleJournalQryActionForm.processTypeValues.item is ArrayCollection){
                initColl = event.result.gleJournalQryActionForm.processTypeValues.item as ArrayCollection;
                initColl.addItemAt({label:" ",value:" "},0);
            }
            else
                initColl.addItem(event.result.gleJournalQryActionForm.processTypeValues.item);
        }
    
        tempColl = new ArrayCollection();
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        processType.dataProvider=tempColl;
        
        //4. Setting values of the statusTypes
        initColl.removeAll();
        if(event.result.gleJournalQryActionForm.statusTypeValues.item != null) {
            if(event.result.gleJournalQryActionForm.statusTypeValues.item is ArrayCollection)
                initColl = event.result.gleJournalQryActionForm.statusTypeValues.item as ArrayCollection;
            else
                initColl.addItem(event.result.gleJournalQryActionForm.statusTypeValues.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        statusType.dataProvider = tempColl;

	 //5.Setting the values of Transaction type
        initColl.removeAll();
        if(event.result.gleJournalQryActionForm.transactionTypeList.item != null) {
            if(event.result.gleJournalQryActionForm.transactionTypeList.item is ArrayCollection)
                initColl = event.result.gleJournalQryActionForm.transactionTypeList.item as ArrayCollection;
            else
                initColl.addItem(event.result.gleJournalQryActionForm.transactionTypeList.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        transactionType.dataProvider = tempColl;
	 
	 //6.Setting the values of TrialBalance types
        /* initColl.removeAll();
        if(event.result.gleJournalQryActionForm.trialBalanceTypes.item != null) {
            if(event.result.gleJournalQryActionForm.trialBalanceTypes.item is ArrayCollection)
                initColl = event.result.gleJournalQryActionForm.trialBalanceTypes.item as ArrayCollection;
            else
                initColl.addItem(event.result.gleJournalQryActionForm.trialBalanceTypes.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        trialBalanceId.dataProvider = tempColl; */
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
     	
     	
     	gleTransactionQueryRequest.request = requestObj;
     	
        var gleTransactionModel:Object={
                            gleTransaction:{
                            balanceEntryDate : transactionDateFrom.text,
                            balanceEntryDateTo : transactionDateTo.text
                            }
                           }; 
        var gleTransactionValidator:GleTransactionValidator = new GleTransactionValidator();
        gleTransactionValidator.source=gleTransactionModel;
        gleTransactionValidator.property="gleTransaction";
        
        var validationResult:ValidationResultEvent =gleTransactionValidator.validate();
        if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);            
        }else {
            gleTransactionQueryRequest.send();
        }
        
    }
     /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
     private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	reqObj.SCREEN_KEY = 284;
    	reqObj.method = "submitQuery";
    	reqObj.appregDateFrom=transactionDateFrom.text;
    	reqObj.appregDateTo=transactionDateTo.text;
    	reqObj.bankAccount=bankActPopUp.accountNo.text;
    	reqObj.securityCode=instPopUp.instrumentId.text;
    	reqObj.fundCode=fundPopUp.fundCode.text;
    	reqObj.transactionType=(this.transactionType.selectedItem != null ? this.transactionType.selectedItem.value : "");
    	reqObj.referenceNo=refNumber.text;
    	reqObj.processType=(this.processType.selectedItem != null ? this.processType.selectedItem.value : "");
    	reqObj.status=(this.statusType.selectedItem != null ? this.statusType.selectedItem.value : "");
    	reqObj.journalCcy=ccyBox.ccyText.text;
    	reqObj.inventoryAccount=invtActPopUp.accountNo.text;
    	reqObj.cxlReferenceNo=cxlRefNumber.text;
    	reqObj.trialBalanceId=trialBalancePopUp.trialBalanceId.text;
    	reqObj.sortField1=this.sortField1.selectedItem != null ? this.sortField1.selectedItem.value : "";
    	reqObj.sortField2=this.sortField2.selectedItem != null ? this.sortField2.selectedItem.value : "";
    	reqObj.sortField3=this.sortField3.selectedItem != null ? this.sortField3.selectedItem.value : "";
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
    	gleTransactionQueryRequest.request = reqObj;
        gleTransactionQueryRequest.send();
    }  
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
      private function doPrev():void { 
		var reqObj : Object = new Object();
    	reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
    	gleTransactionQueryRequest.request = reqObj;
        gleTransactionQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
     private function resetQuery():void { 
     	loadSortFieldItemsArray();
     	sortFieldArray[0]=sortField1;
    	sortFieldDataSet[0]=sortFields;
    	sortFieldArray[1]=sortField2;
    	sortFieldDataSet[1]=sortFields;
    	sortFieldArray[2]=sortField3;
    	sortFieldDataSet[2]=sortFields;
		sortFieldSelectedItem[0] = sortFields.getItemAt(1);
		sortFieldSelectedItem[1] = sortFields.getItemAt(2);
		sortFieldSelectedItem[2] = sortFields.getItemAt(3);
		csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
	    csd.init();
        gleTransactionResetQueryRequest.send();
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
	            	if(summaryResult.length==1){
		             	//var detailRenderer:TradeDetailRenderer =new TradeDetailRenderer();
		             	//detailRenderer.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		             	displayDetailView(summaryResult[0].transactionPk);
	             }
	             summaryResult.refresh();
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

    private function displayDetailView(transactionPkStr:String):void{
    	
			var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
			
			sPopup.title = "Journal Query Result";
			sPopup.width = 650;
    		sPopup.height = 420;
			PopUpManager.centerPopUp(sPopup);		
			//var tradePkStr : String = queryResult.tradePk;
			sPopup.moduleUrl = Globals.TRANSACTION_DETAILS_SWF + Globals.QS_SIGN + Globals.TRANSACTION_PK + Globals.EQUALS_SIGN + transactionPkStr;			
			
    }
    
    /**
	 * Loading the initial configuaration.
	 * 
	 */
	private function loadAll():void {
    	loadSortFieldItemsArray();
    	sortFieldArray[0]=sortField1;
    	sortFieldDataSet[0]=sortFields;
    	sortFieldArray[1]=sortField2;
    	sortFieldDataSet[1]=sortFields;
    	sortFieldArray[2]=sortField3;
    	sortFieldDataSet[2]=sortFields;
		sortFieldSelectedItem[0] = sortFields.getItemAt(1);
		sortFieldSelectedItem[1] = sortFields.getItemAt(2);
		sortFieldSelectedItem[2] = sortFields.getItemAt(3);
		csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
	    csd.init();
    }
       private function sortOrder1Update():void{
     	 csd.update(sortField1.selectedItem,0);
     } 
     
     private function sortOrder2Update():void{     	
     	csd.update(sortField2.selectedItem,1);
     } 
    
    private function loadSortFieldItemsArray():void{
        sortFields.addItem({label:" ",value:" "});
        sortFields.addItem({label: this.parentApplication.xResourceManager.getKeyValue('gle.transactionquery.label.fundcode'),value:"fund_code"});        
        sortFields.addItem({label: this.parentApplication.xResourceManager.getKeyValue('gle.transactionquery.label.fundaccountno'),value:"inventoryaccount"});
        sortFields.addItem({label: this.parentApplication.xResourceManager.getKeyValue('gle.transactionquery.label.ccy'),value:"securityid"});
        sortFields.addItem({label: this.parentApplication.xResourceManager.getKeyValue('gle.transactionquery.label.transactionreferenceno'),value:"reference_no"});        
        sortFields.addItem({label: this.parentApplication.xResourceManager.getKeyValue('gle.transactionquery.label.transactiontype'),value:"transaction_type"});
        sortFields.addItem({label: this.parentApplication.xResourceManager.getKeyValue('gle.transactionquery.label.processtype'),value:"process_type"});
        sortFields.addItem({label: this.parentApplication.xResourceManager.getKeyValue('gle.transactionquery.label.bankaccount'),value:"bankaccount"});
    }
  
    /**
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specifdic  
      * requriment. 
      */
    private function populateContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
      
        //passing counter party type  (BROKER|BANK/CUSTODIAN|INTERNAL)              
        var cpTypeArray:Array = new Array(1);
            //cpTypeArray[0] = "BROKER";
            //cpTypeArray[1] = "BANK/CUSTODIAN";
            cpTypeArray[0] = "INTERNAL";
            //cpTypeArray[1]="CLIENT";
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
    
        //passing account status                
        var actStatusArray:Array = new Array(1);
        actStatusArray[0]="OPEN";
        myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
        return myContextList;
    }
    /**
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specifdic  
      * requriment. 
      */
    private function populateBkContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
      
        //passing counter party type  (BROKER|BANK/CUSTODIAN|INTERNAL)              
        var cpTypeArray:Array = new Array(2);
            cpTypeArray[0] = "BROKER";
            cpTypeArray[1] = "BANK/CUSTODIAN";
            //cpTypeArray[0] = "INTERNAL";
            //cpTypeArray[1]="CLIENT";
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
    
        //passing account status                
        var actStatusArray:Array = new Array(1);
        actStatusArray[0]="OPEN";
        myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
        return myContextList;
    }
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
    	var url : String = "gle/journalQuery.action?method=generateXLS";
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
    	var url : String = "gle/journalQuery.action?method=generatePDF";
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
    } // ActionScript file
    
