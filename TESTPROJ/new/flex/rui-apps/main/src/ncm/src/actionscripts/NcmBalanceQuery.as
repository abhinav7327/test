
 // ActionScript file for NCM Balance Query
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.CustomizeSortOrder;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.HiddenObject;
    import com.nri.rui.core.utils.ProcessResultUtil;
    import com.nri.rui.ncm.validators.NcmBalanceValidator;
    
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    
    import mx.collections.ArrayCollection;
    import mx.events.ValidationResultEvent;
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
    
    public var baseDateItemRndr:String = ""; // Nedded to hold value at submit time to pass in the ItemRenderer
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    
    private var  csd:CustomizeSortOrder=null;
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    * This will fetch data to fill the initial form data to show the user.
    */
     private function initPageStart():void {            
        if (!initCompFlg) {    
            rndNo= Math.random();
            var req : Object = new Object();
            req.SCREEN_KEY = 410;      
            initializeBalanceQuery.request = req;         
            initializeBalanceQuery.url = "ncm/ncmBalanceQueryDispatch.action?method=initialExecute&rnd=" + rndNo;                    
            initializeBalanceQuery.send();        
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
        var selIndx:int = 0;
        var dateStr:String = null;
        
        errPage.clearError(event); //clears the errors if any 
        //initiate text fields
        actPopUp.accountNo.text = "";
        ccyBox.ccyText.text = "";
        instPopUp.instrumentId.text="";
        instrumentType.text = "";
        //form.text = "";
        fundPopUp.fundCode.text="";
        bankPopUp.finInstCode.text="";
        
        var sortField1Default:String = event.result.ncmBalanceQueryActionForm.sortField1;
        var sortField2Default:String = event.result.ncmBalanceQueryActionForm.sortField2;
        var sortField3Default:String = event.result.ncmBalanceQueryActionForm.sortField3;
        
        // populate the combo boxes
        // Movement Basis
        var tempColl: ArrayCollection = new ArrayCollection();
        //tempColl.addItem({label:" ", value: " "}); 
        
        initColl.removeAll();
        if (event.result.ncmBalanceQueryActionForm.ListBalanceBasis.item != null) {
            if (event.result.ncmBalanceQueryActionForm.ListBalanceBasis.item is ArrayCollection) {
                initColl = event.result.ncmBalanceQueryActionForm.ListBalanceBasis.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.ncmBalanceQueryActionForm.ListBalanceBasis.item);
            }
        }
        for(i = 0; i<initColl.length; i++) {
           tempColl.addItem(initColl[i]); 
        }
        balanceBasis.dataProvider = tempColl;
        balanceBasis.setFocus();
        
        // Form
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        
        initColl = event.result.ncmBalanceQueryActionForm.listForm.item as ArrayCollection;
        for(i = 0; i<initColl.length; i++) {
           tempColl.addItem(initColl[i]);            
        }
        //form.dataProvider = tempColl;
        
         
        dateStr=event.result.ncmBalanceQueryActionForm.baseDate;   
        if(dateStr != null)
            date.selectedDate = DateUtils.toDate(dateStr);
               // date.selectedDate = new Date(dateStr.substr(0,4),dateStr.substr(4,2),dateStr.substr(6,2));
        
        date.setFocus();
        
        initCompFlg = true;
        
        // Zero balance display  
        tempColl = new ArrayCollection();
        initColl.removeAll();
        if (event.result.ncmBalanceQueryActionForm.displayZeroBalanceList.item != null) {
            if (event.result.ncmBalanceQueryActionForm.displayZeroBalanceList.item is ArrayCollection) {
                initColl = event.result.ncmBalanceQueryActionForm.displayZeroBalanceList.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.ncmBalanceQueryActionForm.displayZeroBalanceList.item);
            }
        }

        for(i = 0; i<initColl.length; i++) {
           tempColl.addItem(initColl[i]);            
        }
        displayZeroBalance.dataProvider = tempColl;
        // Form
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        
        initColl = event.result.ncmBalanceQueryActionForm.listForm.item as ArrayCollection;
        for(i = 0; i<initColl.length; i++) {
           tempColl.addItem(initColl[i]);            
        }
        //form.dataProvider = tempColl;

        //Set sortField1
        initColl.removeAll();
        if(null != event.result.ncmBalanceQueryActionForm.sortFieldList1.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
            
            if(event.result.ncmBalanceQueryActionForm.sortFieldList1.item is ArrayCollection)
                initColl = event.result.ncmBalanceQueryActionForm.sortFieldList1.item as ArrayCollection;
            else
                initColl.addItem(event.result.ncmBalanceQueryActionForm.sortFieldList1.item);
            
            for(i = 0; i<initColl.length; i++) {
                //Get the default value object's index
                if(XenosStringUtils.equals((initColl[i].value),sortField1Default)){                    
                    selIndx = i;
                }
                
               tempColl.addItem(initColl[i]);            
            }
            
            sortFieldArray[0]=sortField1;
            sortFieldDataSet[0]=tempColl;
            //Set the default value object
            sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ncm.error.prompt.populate.sortorder1'));
        }

        //sortField2
        
        initColl.removeAll();
        if(null != event.result.ncmBalanceQueryActionForm.sortFieldList2.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
            
            if(event.result.ncmBalanceQueryActionForm.sortFieldList2.item is ArrayCollection)
                initColl = event.result.ncmBalanceQueryActionForm.sortFieldList2.item as ArrayCollection;
            else
                initColl.addItem(event.result.ncmBalanceQueryActionForm.sortFieldList2.item);
            
            for(i = 0; i<initColl.length; i++) {
                //Get the default value object's index
                if(XenosStringUtils.equals((initColl[i].value),sortField2Default)){                    
                    selIndx = i;
                }
                
               tempColl.addItem(initColl[i]);            
            }
            
            sortFieldArray[1]=sortField2;
            sortFieldDataSet[1]=tempColl;
            //Set the default value object
            sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ncm.error.prompt.populate.sortorder2'));
        }
        
        //sortField3
        
        initColl.removeAll();
        if(null != event.result.ncmBalanceQueryActionForm.sortFieldList3.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
            
            if(event.result.ncmBalanceQueryActionForm.sortFieldList3.item is ArrayCollection)
                initColl = event.result.ncmBalanceQueryActionForm.sortFieldList3.item as ArrayCollection;
            else
                initColl.addItem(event.result.ncmBalanceQueryActionForm.sortFieldList3.item);
            
            for(i = 0; i<initColl.length; i++) {
                //Get the default value object's index
                if(XenosStringUtils.equals((initColl[i].value),sortField3Default)){                    
                    selIndx = i;
                }
                
               tempColl.addItem(initColl[i]);            
            }
            
            sortFieldArray[2]=sortField3;
            sortFieldDataSet[2]=tempColl;
            //Set the default value object
            sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx+1);
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ncm.error.prompt.populate.sortorder3'));
        }
        
        csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
        csd.init();
    } 
    
     private function sortOrder1Update():void{
         csd.update(sortField1.selectedItem,0);
     } 
     
     private function sortOrder2Update():void{      
        csd.update(sortField2.selectedItem,1);
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
        //Reset Page No
         qh.resetPageNo();
        var requestObj :Object = populateRequestParams();
        balanceQueryRequest.request = requestObj;
        
         var myModel:Object={
                            balance:{
                                 balanceBasis : (this.balanceBasis.selectedItem != null? this.balanceBasis.selectedItem.value : ""),
                                 date : this.date.text,
                                 currency : this.ccyBox.ccyText.text,
                                 securityCode : this.instPopUp.instrumentId.text,
                                 fundCode:this.fundPopUp.fundCode.text,
                                 displayZeroBalance : this.displayZeroBalance.selectedItem.value,
                                 instrumentType : instrumentType.itemCombo.text
                                 
                            }
                           }; 
                           
        var validator : NcmBalanceValidator = new NcmBalanceValidator();
        validator.source = myModel;
        validator.property = "balance";
        var validationResult : ValidationResultEvent = validator.validate(); 
    
         if (validationResult.type == ValidationResultEvent.INVALID)
        {
            var errorMsg : String = validationResult.message;
            XenosAlert.error(errorMsg);
            resultHead.text = "";
        } 
        else
        {
            baseDateItemRndr = date.text;
            resultHead.text = this.balanceBasis.selectedItem.label.toUpperCase() + " " + this.parentApplication.xResourceManager.getKeyValue('ncm.balance.summary.label.balancebasis') + " " + baseDateItemRndr ;
            balanceQueryRequest.send();
        }                
    }
    
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        reqObj.SCREEN_KEY = 411;
        reqObj.method = "submitQuery";
        reqObj.balanceBasis = this.balanceBasis.selectedItem != null ? this.balanceBasis.selectedItem.value : "";
        reqObj.baseDate = this.date.text;
        reqObj.instrumentType = this.instrumentType.itemCombo.text;
        reqObj.currencyCode = this.ccyBox.ccyText.text;
        reqObj.securityCode = this.instPopUp.instrumentId.text;
        //reqObj.form = this.form.selectedItem != null ? this.form.selectedItem.value : "";
        reqObj.bank = this.bankPopUp.finInstCode.text;
        reqObj.accountNo = this.actPopUp.accountNo.text;
        reqObj.fundCode = this.fundPopUp.fundCode.text;
        reqObj.displayZeroBalance = this.displayZeroBalance.selectedItem.value;
        reqObj.sortField1 = this.sortField1.selectedItem != null ? this.sortField1.selectedItem.value : "";
        reqObj.sortField2 = this.sortField2.selectedItem != null ? this.sortField2.selectedItem.value : "";
        reqObj.sortField3 = this.sortField3.selectedItem != null ? this.sortField3.selectedItem.value : "";
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
        balanceQueryRequest.request = reqObj;
        balanceQueryRequest.send();
    }
    
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        balanceQueryRequest.request = reqObj;
        balanceQueryRequest.send();
    }   
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
     private function resetQuery():void { 
        balanceResetQueryRequest.send();
    }  
    
    /**
     * This method works as the result handler of the Submit Query Http Services.
     * This also takes care of the buttons/images to be shown on teh top panel of the
     * result.
     */    
    public function loadSummaryPage(event : ResultEvent) : void 
    {
        var showNext : Boolean;
        var showPrev : Boolean;
        
        if (event != null) 
        {            
            if (event.result.rows == null)
            {
                summaryResult.removeAll();
                if (event.result.XenosErrors == null)
                {
                    errPage.clearError(event);
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                } 
                else 
                {
                    errPage.displayError(event);    
                }               
            }
            else 
            {
                errPage.clearError(event); 
                summaryResult.removeAll();
                if(event.result.rows.row != null){    
                    if (event.result.rows.row is ArrayCollection) 
                    {
                        summaryResult = event.result.rows.row as ArrayCollection;
                    } 
                    else 
                    {
                        summaryResult.removeAll();
                        summaryResult.addItem(event.result.rows.row);
                    }
                    changeCurrentState();
					qh.setOnResultVisibility();
                }else{                	                    
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                }    
                
                //changeCurrentState();
                //replace null objects with empty string
                summaryResult=ProcessResultUtil.process(summaryResult,balanceSummary.columns);                
                qh.setPrevNextVisibility(Boolean(event.result.rows.prevTraversable), Boolean(event.result.rows.nextTraversable));
                qh.PopulateDefaultVisibleColumns();
            } 
        }
        else 
        {
            summaryResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
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
        private function populateContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing counter party type                
            var cpTypeArray:Array = new Array(2);
            cpTypeArray[0]="BANK/CUSTODIAN";
            cpTypeArray[1]="BROKER";
            
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
        var url : String = "ncm/ncmBalanceQueryDispatch.action?method=generateXLS&screenId=NCMBQ";
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
	
        var variables:URLVariables = new URLVariables();
        trace("Menu Pk in XLS using parent application: " + this.parentApplication.mdiCanvas.getwindowKey());
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
        var url : String = "ncm/ncmBalanceQueryDispatch.action?method=generatePDF";
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
        var variables:URLVariables = new URLVariables();
        trace("Menu Pk in PDF using parent application: " + this.parentApplication.mdiCanvas.getwindowKey());
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
