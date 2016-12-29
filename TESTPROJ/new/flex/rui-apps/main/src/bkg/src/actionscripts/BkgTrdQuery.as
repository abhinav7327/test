// ActionScript file

 // ActionScript file for Banking Trade Query
    import com.nri.rui.bkg.validators.BkgTradeQueryValidator;
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.containers.SummaryPopup;
    import com.nri.rui.core.controls.CustomizeSortOrder;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.HiddenObject;
    import com.nri.rui.core.utils.ProcessResultUtil;
    import com.nri.rui.core.utils.XenosStringUtils;
    import com.nri.rui.core.validators.XenosNumberValidator;
    import com.nri.rui.ref.popupImpl.FinInstitutePopUpHbox;
    import com.nri.rui.ref.popupImpl.StrategyPopUpHBox;
    
    import mx.collections.ArrayCollection;
    import mx.controls.TextInput;
    import mx.core.UIComponent;
    import mx.events.ResourceEvent;
    import mx.events.ValidationResultEvent;
    import mx.managers.PopUpManager;
    import mx.resources.ResourceBundle;
    import mx.rpc.events.ResultEvent;
    import mx.utils.StringUtil;
    
    
    [Bindable]
    private var initColl:ArrayCollection;
    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var queryResult:ArrayCollection= new ArrayCollection();
    private var emptyResult:ArrayCollection= new ArrayCollection();
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
    private var finInst:FinInstitutePopUpHbox = new FinInstitutePopUpHbox();
    [Bindable]
    private var strategyPopup:StrategyPopUpHBox = new StrategyPopUpHBox();
    
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var counterPartyTxtInput:TextInput = new TextInput();
    
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    
    private var  csd:CustomizeSortOrder=null;
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();    
    
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    private function initPageStart():void { 
        finInst.percentWidth = 50;
        finInst.name = "Broker";
        finInst.recContextItem = populateFinInstRole();
        counterPartyTxtInput.percentWidth = 50;
        counterPartyTxtInput.name = "Blank"; 
        counterpartyCodeBox.addChild(counterPartyTxtInput);        
        if (!initCompFlg) {    
            rndNo= Math.random(); 
            var req : Object = new Object();
            req.SCREEN_KEY = 341;
            initializeBkgTradeQuery.request = req;    
            initializeBkgTradeQuery.url = "bkg/depoLoanQueryDispatch.action?method=initialExecute&mode=query&menuType=Y&rnd=" + rndNo;                    
            initializeBkgTradeQuery.send();        
        } else
            XenosAlert.info("Already Initiated!");
         
    }
    
    /**
       * This is the method to pass the Collection of data items
       * through the context to the FinInst popup. This will be implemented as per specifdic  
       * requirement. 
       */
     private function populateFinInstRole():ArrayCollection {
    //pass the context data to the popup
     var myContextList:ArrayCollection = new ArrayCollection(); 

     var bankRoleArray : Array = new Array(4);
     bankRoleArray[0] = "Security Broker";
     bankRoleArray[1] = "Bank/Custodian";
     bankRoleArray[2] = "Stock Exchange";
     bankRoleArray[3] = "Central Depository";
     myContextList.addItem(new HiddenObject("bankRoles",bankRoleArray));

     return myContextList;
        }
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * 
    */   
    private function initPage(event: ResultEvent) : void {
        var i:int = 0;
        var selIndx:int = 0;
        
        //variables to hold the default values from the server
        //For SortField1
        var sortField1Default:String = event.result.bkgQueryActionForm.sortField1;
        //For SortField2
        var sortField2Default:String = event.result.bkgQueryActionForm.sortField2;
        //For SortField3
        var sortField3Default:String = event.result.bkgQueryActionForm.sortField3; 
        //clears the errors if any
        errPage.clearError(event); 
        
        
        //Temporary ArrayCollection for holding the data from the XML  
        //-------------Start of Population of Trade Type------------//
        //Temporary ArrayCollection acting as data provider to the DropDown Lists
        var tempColl: ArrayCollection = new ArrayCollection();
        //Addition of a blank field to the Combo for TradeType
        tempColl.addItem({label:" ", value: " "});  
        //This data is for populating TradeType Combo from the XML 
        if(event.result.bkgQueryActionForm.scrndisdata.tradeTypeList.tradeType is ArrayCollection){
            initColl = event.result.bkgQueryActionForm.scrndisdata.tradeTypeList.tradeType as ArrayCollection;
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);    
            }
        }else{
            tempColl.addItem(event.result.bkgQueryActionForm.scrndisdata.tradeTypeList.tradeType);
        }
        //Allocation of the data provider for the TradeType
        tradeType.dataProvider = tempColl;
        //-------------End of population of Trade Type-----------------------//
        
        //----------------Start of Population of counterparty code------//
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        if(event.result.bkgQueryActionForm.counterPartyTypeValues.item is ArrayCollection){
            initColl = event.result.bkgQueryActionForm.counterPartyTypeValues.item as ArrayCollection;
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);    
            }
       }
       else{
            tempColl.addItem(event.result.bkgQueryActionForm.counterPartyTypeValues.item);
       }
        counterPartyCode.dataProvider = tempColl;
        counterPartyCode.selectedItem = tempColl[0];
        
        //--------------End of population of CounterParty Code-------------------//
        //Initial Settings for populating Counterparty Code
        if(finInst!=null){
            if(finInst.finInstCode !=null){
                finInst.finInstCode.text = "";
            }
            finInst.name = "Broker";
        }
        if(counterPartyTxtInput!=null){
            counterPartyTxtInput.text = "";
            counterPartyTxtInput.name = "Blank";
        }
        onChangeCounterpartyCode();
        
        //---------------Start of populating the status--------//
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        if(event.result.bkgQueryActionForm.scrndisdata.statusList.status is ArrayCollection){
            initColl = event.result.bkgQueryActionForm.scrndisdata.statusList.status as ArrayCollection;
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);    
            }
        }else{
            tempColl.addItem(event.result.bkgQueryActionForm.scrndisdata.statusList.status);
        }
        status.dataProvider = tempColl;
        //--------End of populating the status---------//
        //-----------Start of populating outstanding or matured list------//
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        if(event.result.bkgQueryActionForm.scrndisdata.outStandList.item is ArrayCollection){
            initColl = event.result.bkgQueryActionForm.scrndisdata.outStandList.item as ArrayCollection;
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);    
            
            }
        }else{
            tempColl.addItem(event.result.bkgQueryActionForm.scrndisdata.outStandList.item);
        }
        outStand.dataProvider = tempColl;
        //-----------End of populating outstanding or matured list------//
        //Reset inventoryAccountNo
        inventoryAccountNo.accountNo.text=""; 
        
        //Reset fundCode
        fundPopUp.fundCode.text="";
        fundPopUp.setFocus();
        
        //Reset currency
        currencyCode.ccyText.text="";

        //Reset referenceNo
        referenceNo.text="";
        
        //Reset tradeDateFrom
        tradeDateFrom.text="";
        
        //Reset tradeDateTo
        tradeDateTo.text="";
        
        //Reset startDateFrom
        startDateFrom.text="";
        
        //Reset startDateTo
        startDateTo.text="";
        
        //Reset maturityDateFrom
        maturityDateFrom.text="";
        
        //Reset maturityDateTo
        maturityDateTo.text="";
        
        //Reset principalAmtFrom
        principalAmtFrom.text="";
        
        //Reset principalAmtTo
        principalAmtTo.text=""; 
        
        //Reset netAmtFrom
        netAmtFrom.text=""; 
        
        //Reset netAmtTo
        netAmtTo.text=""; 
        
        //Reset cancelReferenceNo
        cancelReferenceNo.text="";
        
        //Reset CounterParty Account Number
        accountNo.accountNo.text="";
        
        //----------Start of population of SortField1----------//
        initColl.removeAll();
        if(null != event.result.bkgQueryActionForm.sortFieldList1.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
            
            if(event.result.bkgQueryActionForm.sortFieldList1.item is ArrayCollection)
                initColl = event.result.bkgQueryActionForm.sortFieldList1.item as ArrayCollection;
            else
                initColl.addItem(event.result.bkgQueryActionForm.sortFieldList1.item);
            
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
            XenosAlert.error("Sort Order Field List 1 not Populated");
        } 
        
        //---------------End of population of SortField1-----------------------//
        
        //--------Start of population of sortField2---------//
        
         initColl.removeAll();
        if(null != event.result.bkgQueryActionForm.sortFieldList2.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
            
            if(event.result.bkgQueryActionForm.sortFieldList2.item is ArrayCollection)
                initColl = event.result.bkgQueryActionForm.sortFieldList2.item as ArrayCollection;
            else
                initColl.addItem(event.result.bkgQueryActionForm.sortFieldList2.item);
            
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
            XenosAlert.error("Sort Order Field List 2 not Populated");
        }
        
         //--------End of population of sortField2---------// 
        
         //--------Start of population of sortField3---------//
        
         initColl.removeAll();
        if(null != event.result.bkgQueryActionForm.sortFieldList3.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
            
            if(event.result.bkgQueryActionForm.sortFieldList3.item is ArrayCollection)
                initColl = event.result.bkgQueryActionForm.sortFieldList3.item as ArrayCollection;
            else
                initColl.addItem(event.result.bkgQueryActionForm.sortFieldList3.item);
            
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
            XenosAlert.error("Sort Order Field List 3 not Populated");
        } 
        
         //--------End of population of sortField3---------//
        //-------------Initializing the sortfields-------------//
        csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
        csd.init();
            
    }
    
    /**
     * Method for updating the other two sortfields after any change in the sortfield1
     */ 
     private function sortOrder1Update():void{
         csd.update(sortField1.selectedItem,0);
     }
     /**
     * Method for updating the other two sortfields after any change in the sortfield2
     */
     private function sortOrder2Update():void{      
        csd.update(sortField2.selectedItem,1);
     }
    
    
    /**
     * Method called for submit query from the banking query page
     */ 
    public function submitQuery():void{
        
        //Reset Page No
        qh.resetPageNo();       
        //Set the request parameters
         var requestObj :Object = populateRequestParams();
        
        bkgTradeQueryRequest.request = requestObj; 
         var bkgTrdModel:Object={
                            bkgTradeQuery:{
                                 tradeDateFrom:this.tradeDateFrom.text,
                                 tradeDateTo:this.tradeDateTo.text,
                                 startDateFrom:this.startDateFrom.text,
                                 startDateTo:this.startDateTo.text,
                                 maturityDateFrom:this.maturityDateFrom.text,
                                 maturityDateTo:this.maturityDateTo.text
                           }
                           }; 
        var bkgTradeQueryValidator:BkgTradeQueryValidator = new BkgTradeQueryValidator();
        bkgTradeQueryValidator.source=bkgTrdModel;
        bkgTradeQueryValidator.property="bkgTradeQuery";
        var validationResult:ValidationResultEvent =bkgTradeQueryValidator.validate();
        
        if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
        }
        else{
        bkgTradeQueryRequest.send();  
        } 
    } 
    
     
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
     private function populateRequestParams():Object {
        var reqObj : Object = new Object();
        reqObj.SCREEN_KEY = 344;
        reqObj.method = "submitQuery";
        reqObj.fundCode = this.fundPopUp.fundCode.text;
        reqObj.inventoryAccountNo = this.inventoryAccountNo.accountNo.text;
        reqObj.tradeType = this.tradeType.selectedItem != null ?  this.tradeType.selectedItem.value : "";
        reqObj.counterPartyType = this.counterPartyCode.selectedItem != null ?  this.counterPartyCode.selectedItem.value : "";
        if(counterPartyCode.selectedItem.label == "BROKER"){
             reqObj.counterPartyCode= this.finInst.finInstCode.text != null ? this.finInst.finInstCode.text : "";
        }else{
             reqObj.counterPartyCode= this.counterPartyTxtInput.text != null ? this.counterPartyTxtInput.text : "";
        }
        reqObj.referenceNo = this.referenceNo.text; 
        reqObj.status = this.status.selectedItem != null ?  this.status.selectedItem.value : "";
        reqObj.currencyCode = this.currencyCode.ccyText.text;
        reqObj.tradeDateFrom = this.tradeDateFrom.text; 
        reqObj.tradeDateTo = this.tradeDateTo.text;           
        reqObj.startDateFrom = this.startDateFrom.text; 
        reqObj.startDateTo = this.startDateTo.text;           
        reqObj.maturityDateFrom = this.maturityDateFrom.text; 
        reqObj.maturityDateTo = this.maturityDateTo.text; 
        reqObj.principalAmtFrom = this.principalAmtFrom.text; 
        reqObj.principalAmtTo = this.principalAmtTo.text;           
        reqObj.netAmtFrom = this.netAmtFrom.text; 
        reqObj.netAmtTo = this.netAmtTo.text;
        reqObj.outStand = this.outStand.selectedItem != null ?  this.outStand.selectedItem.value : "";
        reqObj.cancelReferenceNo = this.cancelReferenceNo.text;
        reqObj.accountNo = this.accountNo.accountNo.text;
        reqObj.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : Globals.EMPTY_STRING;
        reqObj.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : Globals.EMPTY_STRING;
        reqObj.sortField3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : Globals.EMPTY_STRING;
        
        reqObj.rnd = Math.random() + "";
        return reqObj;
        
    } 
    
    
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    
    private function LoadResultPage(event:ResultEvent):void {
        
    var rs:XML = XML(event.result);
    
        if (null != event) {
            if(rs.child("row").length()>0) {
                errPage.clearError(event);
                queryResult.removeAll();
                try {
                    for each ( var rec:XML in rs.row ) {
                        queryResult.addItem(rec);
                    }
                    
                    //replace null objects with empty string
                     queryResult=ProcessResultUtil.process(queryResult,bkgTradeQueryResult.columns);
                     queryResult.refresh();
                     
                     changeCurrentState();
                     qh.setOnResultVisibility();
                     qh.setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
                     qh.PopulateDefaultVisibleColumns();
                     if(queryResult.length==1){
                        displayDetailView(queryResult[0].bankingTradePk);
                     }
                    
                }catch(e:Error){
                    //XenosAlert.error(e.toString() + e.message);
                    XenosAlert.error("No result found");
                }
             } else if(rs.child("Errors").length()>0) {
                //some error found
                queryResult.removeAll(); // clear previous data if any as there is no result now.
                var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list              
                for each ( var error:XML in rs.Errors.error ) {
                   errorInfoList.addItem(error.toString());
                }
                errPage.showError(errorInfoList);//Display the error
             } else {
                XenosAlert.info("No Result Found!");
                queryResult.removeAll(); // clear previous data if any as there is no result now.
                errPage.removeError(); //clears the errors if any
             }
        }
     }

    
    
    /* public function LoadResultPage(event:ResultEvent):void {
         if (null != event) {            
            if(null == event.result.rows){
                queryResult.removeAll(); // clear previous data if any as there is no result now.
                if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
                    errPage.clearError(event); //clears the errors if any
                    XenosAlert.info("No Result Found!");
                } else { // Must be error
                    errPage.displayError(event);    
                }               
            }else {
                errPage.clearError(event);   
                if(event.result.rows.row is ArrayCollection) {
                        queryResult = event.result.rows.row as ArrayCollection;
                } else {
                        queryResult.removeAll();
                        queryResult.addItem(event.result.rows.row);
                 }
                 
                  if(queryResult[0]==null){                         
                    queryResult.removeAll();
                    XenosAlert.info("No Results Found");
                    return;
                 }
                 //replace null objects with empty string
                 queryResult=ProcessResultUtil.process(queryResult,bkgTradeQueryResult.columns);
                 //bkgTradeQueryResult.refresh();
                 
                 changeCurrentState();
                 qh.setOnResultVisibility();
                 qh.setPrevNextVisibility(Boolean(event.result.rows.prevTraversable),Boolean(event.result.rows.nextTraversable));
                 qh.PopulateDefaultVisibleColumns();
                 if(queryResult.length==1){
                    displayDetailView(queryResult[0].bankingTradePk);
                 }
            } 
        }else {
            queryResult.removeAll();
            XenosAlert.info("No Results Found");
        } 
    } */
     private function displayDetailView(bankingTrdPkStr:String):void{
            var sPopup : SummaryPopup;  
            sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
            sPopup.title = "Banking Trade Details";
            sPopup.width = 700;
            sPopup.height = 460;
            PopUpManager.centerPopUp(sPopup);       
            sPopup.moduleUrl = Globals.BKG_TRADE_DETAILS_SWF+Globals.QS_SIGN+Globals.BKG_TRADE_PK+Globals.EQUALS_SIGN+bankingTrdPkStr;      
    } 
    
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
     public function resetQuery():void{
        bkgTradeResetQueryRequest.send();
    } 
    
    /**
     * This method handles the counterpartycode and corresponding popup population
     */ 
    private function onChangeCounterpartyCode():void{
        if(counterPartyCode.selectedItem.label == "BROKER"){
            if(counterpartyCodeBox.getChildByName("Blank")){
                counterpartyCodeBox.addChild(finInst);
                counterpartyCodeBox.removeChild(counterPartyTxtInput);
            }
        }else{
            if(counterpartyCodeBox.getChildByName("Broker")){
                counterpartyCodeBox.addChild(counterPartyTxtInput);
                counterpartyCodeBox.removeChild(finInst);
            }
        }
    }
    
        /**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
        private function populateInvActContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing act type                
            var actTypeArray:Array = new Array(1);
                actTypeArray[0]="T|S|B";
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("invActTypeContext",actTypeArray));    
                      
            //passing counter party type                
            var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="INTERNAL";
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="TRADING|BOTH";
            myContextList.addItem(new HiddenObject("actContext",actStatusArray));
            return myContextList;
        }
    
        /**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
        private function populateActContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing act type                
            var actTypeArray:Array = new Array(1);
                actTypeArray[0]="T|S|B";
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("invActTypeContext",actTypeArray));    
                      
            var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="BROKER|BANK/CUSTODIAN";
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="TRADING|BOTH";
            myContextList.addItem(new HiddenObject("actContext",actStatusArray));
            return myContextList;
        }
        
        
    /**
     * This method should be called on creationComplete of the datagrid 
     */ 
      private function bindDataGrid():void {
        qh.dgrid = bkgTradeQueryResult;
    }   
   /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
        var url : String = "bkg/depoLoanQueryDispatch.action?method=generateXLS";
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
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
        var url : String = "bkg/depoLoanQueryDispatch.action?method=generatePDF";
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
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
    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
     private function doNext():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
        bkgTradeQueryRequest.request = reqObj;
        bkgTradeQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        bkgTradeQueryRequest.request = reqObj;
        bkgTradeQueryRequest.send();
    }  
    
    
    /**
     * Method to Format and validate numbers(B,M,T)
     */
     private function numberHandler(numVal:XenosNumberValidator):void{
        //The source textinput control
        var source:Object=numVal.source; 
                
        var vResult:ValidationResultEvent;
        var tmpStr:String = source.text; 
        vResult = numVal.validate();
        
        if (vResult.type==ValidationResultEvent.VALID) {
            source.text=numberFormatter.format(source.text);            
        }else{
            source.text = tmpStr;           
        }
     }
     
     