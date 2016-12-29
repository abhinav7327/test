
 // ActionScript file for NCM Movement Query
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.CustomizeSortOrder;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.HiddenObject;
    import com.nri.rui.core.utils.ProcessResultUtil;
    import com.nri.rui.ncm.validators.MovementBalanceValidator;
    
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    
    import mx.collections.ArrayCollection;
    import mx.events.ResourceEvent;
    import mx.events.ValidationResultEvent;
    import mx.resources.ResourceBundle;
    import mx.rpc.events.ResultEvent;
    
    
    [Bindable]
    private var initColl:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var summaryResult:ArrayCollection = new ArrayCollection();
    private var emptyResult:ArrayCollection= new ArrayCollection();
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    [Bindable]
    private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    
    private var  csd:CustomizeSortOrder=null;
    
    
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
        
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    * This will fetch data to fill the initial form data to show the user.
    */
     private function initPageStart():void {            
        if (!initCompFlg) {    
            rndNo= Math.random();
            var req : Object = new Object();
            req.SCREEN_KEY = 412;      
            initializeMovementQuery.request = req;  
            initializeMovementQuery.url = "ncm/ncmMovementQueryDispatch.action?method=initialExecute&rnd=" + rndNo;                    
            initializeMovementQuery.send();        
        } else
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.initiate'));
     }
      
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * Once initial data is fetched from database to fill some form data, this method works
    * to actually show the data.
    */   
     private function initPage(event: ResultEvent) : void {
        var i:int = 0;
        var dateStr:String = null;
        var selIndx:int = 0;
        
        errPage.clearError(event); //clears the errors if any
        
        //variables to hold the default values from the server
        var sortField1Default:String = event.result.ncmMovementQueryActionForm.sortField1;
        var sortField2Default:String = event.result.ncmMovementQueryActionForm.sortField2;
        var sortField3Default:String = event.result.ncmMovementQueryActionForm.sortField3;
        var sortField4Default:String = event.result.ncmMovementQueryActionForm.sortField4;
        
        //initiate text fields
        actPopUp.accountNo.text = "";
        ccyBox.ccyText.text = "";
        instPopUp.instrumentId.text="";
        instrumentType.text = "";
        fundPopUp.fundCode.text="";
        bankPopUp.finInstCode.text="";
//        trdgAcctPopUp.accountNo.text="";
        txnRefNo.text="";
        amtQty.text="";
        //form.text = "";
        
        // populate the combo boxes
        // Movement Basis
        var tempColl: ArrayCollection = new ArrayCollection();
        //tempColl.addItem({label:" ", value: " "}); 
        initColl.removeAll();
        if (event.result.ncmMovementQueryActionForm.balanceTypes.item != null) {
            if (event.result.ncmMovementQueryActionForm.balanceTypes.item is ArrayCollection) {
                initColl = event.result.ncmMovementQueryActionForm.balanceTypes.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.ncmMovementQueryActionForm.balanceTypes.item);
            }
        }
        for(i = 0; i<initColl.length; i++) {
           tempColl.addItem(initColl[i]);            
        }
        movementBasis.dataProvider = tempColl;
        movementBasis.setFocus();
        // Form
        tempColl = new ArrayCollection();
        //tempColl.addItem({label:" ", value: " "});
        
        initColl.removeAll();
        if (event.result.ncmMovementQueryActionForm.forms.item != null) {
            if (event.result.ncmMovementQueryActionForm.forms.item is ArrayCollection) {
                initColl = event.result.ncmMovementQueryActionForm.forms.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.ncmMovementQueryActionForm.forms.item);
            }
        }
        for(i = 0; i<initColl.length; i++) {
           tempColl.addItem(initColl[i]);            
        }
        //form.dataProvider = tempColl;
        
        // Transaction Type
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        
        initColl.removeAll();
        if (event.result.ncmMovementQueryActionForm.transactionTypes.item != null) {
            if (event.result.ncmMovementQueryActionForm.transactionTypes.item is ArrayCollection) {
                initColl = event.result.ncmMovementQueryActionForm.transactionTypes.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.ncmMovementQueryActionForm.transactionTypes.item);
            }
        }
        for(i = 0; i<initColl.length; i++) {
           tempColl.addItem(initColl[i]);            
        }
        txnType.dataProvider = tempColl;     
           
        initCompFlg = true;
        
        //Setting dateFrom and dateTo
        if(event.result.ncmMovementQueryActionForm.dateFrom!= null && event.result.ncmMovementQueryActionForm.dateTo != null) {
            dateStr=event.result.ncmMovementQueryActionForm.dateFrom;
            if(dateStr != null)
                dateFrom.selectedDate = DateUtils.toDate(dateStr);

            dateStr=event.result.ncmMovementQueryActionForm.dateTo;
            if(dateStr != null)
                dateTo.selectedDate = DateUtils.toDate(dateStr);
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ncm.query.error.prompt.fromto.date'));
        }
        
        initColl.removeAll();
        if(null != event.result.ncmMovementQueryActionForm.sortFieldList1.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if (event.result.ncmMovementQueryActionForm.sortFieldList1.item is ArrayCollection) {
                initColl = event.result.ncmMovementQueryActionForm.sortFieldList1.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.ncmMovementQueryActionForm.sortFieldList1.item);
            }
            for(i = 0; i<initColl.length; i++) {
                //Get the default value object's index
                if(XenosStringUtils.equals((initColl[i].value),sortField1Default)){                    
                    selIndx = i;
                }
                tempColl.addItem(initColl[i]);            
            }
            //sortField1.dataProvider = tempColl;
            
            sortFieldArray[0]=sortField1;
            sortFieldDataSet[0]=tempColl;
            //Set the default value object
            sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ncm.error.prompt.populate.sortorder1'));
        }
        
        initColl.removeAll();
        if(null != event.result.ncmMovementQueryActionForm.sortFieldList2.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx=0;
        
            if (event.result.ncmMovementQueryActionForm.sortFieldList2.item is ArrayCollection) {
                initColl = event.result.ncmMovementQueryActionForm.sortFieldList2.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.ncmMovementQueryActionForm.sortFieldList2.item);
            }
            for(i = 0; i<initColl.length; i++) {
                //Get the default value object's index
                if(XenosStringUtils.equals((initColl[i].value),sortField2Default)){                    
                    selIndx = i;
                }
                
                tempColl.addItem(initColl[i]);            
            }
            //sortField2.dataProvider = tempColl;
            
            sortFieldArray[1]=sortField2;
            sortFieldDataSet[1]=tempColl;
            //Set the default value object
            sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ncm.error.prompt.populate.sortorder2'));
        }
        
        initColl.removeAll();
        if(null != event.result.ncmMovementQueryActionForm.sortFieldList3.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if (event.result.ncmMovementQueryActionForm.sortFieldList3.item is ArrayCollection) {
                initColl = event.result.ncmMovementQueryActionForm.sortFieldList3.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.ncmMovementQueryActionForm.sortFieldList3.item);
            }
            for(i = 0; i<initColl.length; i++) {
                //Get the default value object's index
                if(XenosStringUtils.equals((initColl[i].value),sortField3Default)){                    
                    selIndx = i;
                }
                
                tempColl.addItem(initColl[i]);            
            }
            //sortField3.dataProvider = tempColl;
            
            sortFieldArray[2]=sortField3;
            sortFieldDataSet[2]=tempColl;
            //Set the default value object
            sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx+1);
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ncm.error.prompt.populate.sortorder3'));
        }
        
        initColl.removeAll();
        if(null != event.result.ncmMovementQueryActionForm.sortFieldList4.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if (event.result.ncmMovementQueryActionForm.sortFieldList4.item is ArrayCollection) {
                initColl = event.result.ncmMovementQueryActionForm.sortFieldList4.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.ncmMovementQueryActionForm.sortFieldList4.item);
            }
            for(i = 0; i<initColl.length; i++) {
                if(XenosStringUtils.equals((initColl[i].value),sortField4Default)){                    
                    selIndx = i;
                }
                
               tempColl.addItem(initColl[i]);            
            }
            //sortField4.dataProvider = tempColl;
            
            sortFieldArray[3]=sortField4;
            sortFieldDataSet[3]=tempColl;
            //Set the default value object
            sortFieldSelectedItem[3] = tempColl.getItemAt(selIndx+1);
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ncm.error.prompt.populate.sortorder4'));
        }
        
        csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
        csd.init();
       
    }
    
    private function sortOrder1Update():void{
         csd.update(sortField1.selectedItem,0);
     }
     
     private function sortOrder2Update():void{      
        csd.update(sortField2.selectedItem,1);
     }
     
     private function sortOrder3Update():void{      
        csd.update(sortField3.selectedItem,2);
     }
    
    
    /**
           * This is the method to pass the Collection of data items
           * through the context to the FinInst popup. This will be implemented as per specifdic  
           * requirement. 
           */
         private function populateFinInstRole():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
    
        var bankRoleArray : Array = new Array(1);
        bankRoleArray[0] = "Bank/Custodian";
        myContextList.addItem(new HiddenObject("bankRoles",bankRoleArray));
    
        return myContextList;
    }
    
    /**
     * It sends/submits the query after validating the user input data.
     */     
    private function submitQuery():void 
    {  
	
		var dateLabel:String = this.parentApplication.xResourceManager.getKeyValue('ncm.movementquery.label.statementperiodfromto');
		var dateValue:String = this.dateFrom.text;
		if (!DateUtils.validateBaseDate(errPage, "NCM", dateLabel, dateValue)) {
			return;
		}	
        //Reset Page No
        qh.resetPageNo();
        var requestObj :Object = populateRequestParams();
        movementQueryRequest.request = requestObj;
        var myModel:Object={
                            movement:{
                                 movementBasis : (this.movementBasis.selectedItem != null? this.movementBasis.selectedItem.value : ""),
                                 dateFrom : this.dateFrom.text,
                                 dateTo : this.dateTo.text,
                                 instrumentType : instrumentType.itemCombo.text,
                                 currency : this.ccyBox.ccyText.text,
                                 securityCode : this.instPopUp.instrumentId.text,
                                 bankCode : this.bankPopUp.finInstCode.text,
                                 accountNo : this.actPopUp.accountNo.text,
               //                  tradingAccountNo : this.trdgAcctPopUp.accountNo.text,
                                 fundCode:this.fundPopUp.fundCode.text
                            }
                           }; 
                           
        var validator : MovementBalanceValidator = new MovementBalanceValidator();
        validator.source = myModel;
        validator.property = "movement";
        var validationResult : ValidationResultEvent = validator.validate();
    
        if (validationResult.type == ValidationResultEvent.INVALID)
        {
            var errorMsg : String = validationResult.message;
            XenosAlert.error(errorMsg);
            resultHead.text = "";
        }
        else
        {   
            resultHead.text = this.movementBasis.selectedItem.label.toUpperCase() + " " + this.parentApplication.xResourceManager.getKeyValue('ncm.movementquery.label.basemovement');
            movementQueryRequest.send();
        }                
    }
    
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        reqObj.SCREEN_KEY = 413;
        reqObj.method = "submitQuery";
        reqObj.movementBasis = this.movementBasis.selectedItem != null ? this.movementBasis.selectedItem.value : "";
        reqObj.dateFrom = this.dateFrom.text;
        reqObj.dateTo = this.dateTo.text;
        reqObj.instrumentType = this.instrumentType.itemCombo.text;
        reqObj.currency = this.ccyBox.ccyText.text;
        reqObj.securityCode = this.instPopUp.instrumentId.text;
        
        //reqObj.form = this.form.selectedItem != null ? this.form.selectedItem.value : "";
        reqObj.bankCode = this.bankPopUp.finInstCode.text;
        reqObj.accountNo = this.actPopUp.accountNo.text;
//        reqObj.tradingAccountNo = this.trdgAcctPopUp.accountNo.text;
        reqObj.amountOrQuantity = this.amtQty.text;
        reqObj.transactionRefNo = this.txnRefNo.text;
        reqObj.fundCode=this.fundPopUp.fundCode.text;
        reqObj.transactionType = this.txnType.selectedItem != null ? this.txnType.selectedItem.value : "";
        reqObj.sortField1 = this.sortField1.selectedItem != null ? this.sortField1.selectedItem.value : "";
        reqObj.sortField2 = this.sortField2.selectedItem != null ? this.sortField2.selectedItem.value : "";
        reqObj.sortField3 = this.sortField3.selectedItem != null ? this.sortField3.selectedItem.value : "";
        reqObj.sortField4 = this.sortField4.selectedItem != null ? this.sortField4.selectedItem.value : "";
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
        movementQueryRequest.request = reqObj;
        movementQueryRequest.send();
    }
    
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        movementQueryRequest.request = reqObj;
        movementQueryRequest.send();
    }   
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
     private function resetQuery():void { 
        movementResetQueryRequest.send();
    }  
    
    /**
     * This method works as the result handler of the Submit Query Http Services.
     * This also takes care of the buttons/images to be shown on teh top panel of the
     * result.
     */    
    private function loadSummaryPage(event:ResultEvent):void
    {
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
                    summaryResult=ProcessResultUtil.process(summaryResult, movementSummary.columns);
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
    
    /**
    * This is called at creationComplete of the module
    */
     private function loadAll():void {
        
     } 
    
         /**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
         
         //**************to correct counter party type code**********************
         private function populateContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing counter party type                
            var cpTypeArray:Array = new Array(1);
                //cpTypeArray[0]="BANK/CUSTODIAN";
                //cpTypeArray[1]="BROKER";
                cpTypeArray[0]="INTERNAL";
                
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
         
         //**************to correct counter party type code**********************
         private function populateBkContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing counter party type                
            var cpTypeArray:Array = new Array(2);
                cpTypeArray[0]="BANK/CUSTODIAN";
                cpTypeArray[1]="BROKER";
                //cpTypeArray[2]="INTERNAL";
                
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
            return myContextList;
        } 
        
        
                
                
        /**
          * This is the method to access the Collection of data items receive
          * through the context from the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
        public function showReturnContext(retCtxItem:ArrayCollection):void {
            /*
            This is sample implemetation
             XenosAlert.info("showReturnContext");
        
            for (var i:int = 0; i<returnContextItem.length; i++){
                
                XenosAlert.info("index :: "+ i);
                
                var itemObject:HiddenObject;
                
                itemObject = HiddenObject (returnContextItem.getItemAt(i));
                
                XenosAlert.info("hidden property :: "+ itemObject.m_propertyName );
                
                var propertyValues:Array = itemObject.m_propertyValues;
                
                for (var j:int = 0; j<propertyValues.length; j++){
                    XenosAlert.info("hidden values :: " + propertyValues[j]);
                }
            }
            */
        }
        
         public function dispReturnContext(retCtxItem:ArrayCollection):void {
            
           
            // This is sample implemetation
            XenosAlert.info("dispReturnContext NCM MOVEMENT QUERY");
        
            for (var i:int = 0; i<retCtxItem.length; i++){
                
                XenosAlert.info("index :: "+ i);
                
                var itemObject:HiddenObject;
                
                itemObject = HiddenObject (retCtxItem.getItemAt(i));
                
                XenosAlert.info("hidden property :: "+ itemObject.m_propertyName );
                
                var propertyValues:Array = itemObject.m_propertyValues;
                
                for (var j:int = 0; j<propertyValues.length; j++){
                    XenosAlert.info("hidden values :: " + propertyValues[j]);
                }
            }
            
    }
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
        var url : String = "ncm/ncmMovementQueryDispatch.action?method=generateXLS";
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
        var url : String = "ncm/ncmMovementQueryDispatch.action?method=generatePDF";
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
        printObject.frmPrintHeader.lbl.text = "ncm Movement Query";
        printObject.pDataGrid.dataProvider = movementSummary.dataProvider;
        PrintDG.printAll(printObject); */
    } 
    
     /**
     * Formatting amount
     */
     private function amountQtyHandler():void{
        
        var vResult:ValidationResultEvent;
        var tmpStr:String = amtQty.text;
        vResult = numVal.validate();
        
        if (vResult.type==ValidationResultEvent.VALID) {
            amtQty.text=numberFormatter.format(amtQty.text);            
        }else{
            amtQty.text = tmpStr;           
        }
     }
