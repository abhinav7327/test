
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.containers.SummaryPopup;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.DateUtils;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.ncm.NcmConstants;
 import com.nri.rui.ncm.validators.AdjustmentQueryValidator;
 
 import flash.net.URLRequest;
 import flash.net.URLRequestMethod;
 
 import mx.collections.ArrayCollection;
 import mx.core.UIComponent;
 import mx.events.ResourceEvent;
 import mx.events.ValidationResultEvent;
 import mx.managers.PopUpManager;
 import mx.resources.ResourceBundle;
 import mx.rpc.events.ResultEvent;
 
 
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    [Bindable]
    public var returnFinContext:ArrayCollection = new ArrayCollection();
    [Bindable]
    public var returnEmpContextItem:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    [Bindable]
    private var queryResult:Object= new Object();
    [Bindable]
    private var finContextList:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var stlAccForFundContextList:ArrayCollection = populateContext();
    [Bindable]
    private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
    private var rs:XML = new XML();
    
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    
    private var  csd:CustomizeSortOrder=null;
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();

    /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
        qh.dgrid = adjustmentSummary;
    }  
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    * This will fetch data to fill the initial form data to show the user.
    */
     private function initPageStart():void {            
        if (!initCompFlg) {
            rndNo= Math.random();
            var req : Object = new Object();
            req.SCREEN_KEY = 469;
            initDepositoryAdjustmentQuery.request = req;
            initDepositoryAdjustmentQuery.url = "ncm/depositoryQueryDispatchAction.action?method=initialExecute&rnd=" + rndNo;                    
            initDepositoryAdjustmentQuery.send();
        } else
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.initiate'));
     } 
    /**
    * This is called at creationComplete of the module
    */
     private function loadAll():void {

     } 

    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * Once initial data is fetched from database to fill some form data, this method works
    * to actually show the data.
    */   
     private function initPage(event: ResultEvent) : void {
        var i:int = 0;
        var dateStr:String = null;
        var initColl:ArrayCollection = new ArrayCollection();
        var tempColl: ArrayCollection;
        var selIndx:int = 0;
        
        //variables to hold the default values from the server
        var sortField1Default:String = event.result.depositoryActionForm.sortField1;
        var sortField2Default:String = event.result.depositoryActionForm.sortField2;
        var sortField3Default:String = event.result.depositoryActionForm.sortField3;
        
        errPage.clearError(event); //clears the errors if any 
        //initiate text fields
        refno.text = "";
        
        fininstPopUp.bankCode.text = "";
        stlAccForFundPopUp.stlAccNo.text = "";
        fundPopUp.fundCode.text = "";
        //actPopUp.accountNo.text = "";
        //gleledger.gleCode.text = "";
        entryby.employeeText.text = "";
        instPopUp.instrumentId.text = "";
        updateby.employeeText.text = "";
        dateFrom.setFocus();
        entryDateFrom.text= "";
        entryDateTo.text = "";
        updateDateFrom.text = "";
        updateDateTo.text = "";
        /* finInstClearState();
        accountClearState(); */ 
        
         
        if(event.result == null || event.result.depositoryActionForm ==null){
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ncm.query.error.prompt.initialization.fail'));
        }
        //Setting dateFrom and dateTo
        if(event.result.depositoryActionForm.dateFrom!= null && event.result.depositoryActionForm.dateTo != null) {
            dateStr=event.result.depositoryActionForm.dateFrom;
            if(dateStr != null)
                dateFrom.selectedDate = DateUtils.toDate(dateStr);

            dateStr=event.result.depositoryActionForm.dateTo;
            if(dateStr != null)
                dateTo.selectedDate = DateUtils.toDate(dateStr);
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ncm.query.error.prompt.fromto.date'));
        }
        
        //1.Setting values of the Adjustment Type
        if(event.result.depositoryActionForm.adjustmentTypeList.item != null) {
            if(event.result.depositoryActionForm.adjustmentTypeList.item is ArrayCollection)
               initColl = event.result.depositoryActionForm.adjustmentTypeList.item as ArrayCollection;
            else
                initColl.addItem(event.result.depositoryActionForm.adjustmentTypeList.item);
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        adjustmenttype.dataProvider = tempColl;
        
        //2. Setting values of the Adjustment Reason
        initColl.removeAll();
        if(event.result.depositoryActionForm.actionFormList !=null){
                if(event.result.depositoryActionForm.actionFormList.reasonCodeList.item != null) {
                    if(event.result.depositoryActionForm.actionFormList.reasonCodeList.item is ArrayCollection)
                        initColl = event.result.depositoryActionForm.actionFormList.reasonCodeList.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.depositoryActionForm.actionFormList.reasonCodeList.item);
                }
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        adjustmentreason.dataProvider = tempColl;
        
            
        //3. Setting values of the Status 
        initColl.removeAll();
        initColl = event.result.depositoryActionForm.statusList.status as ArrayCollection;
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        status.dataProvider = tempColl;
        
        initCompFlg = true;
        //4. Setting values of the SortField1
        initColl.removeAll();
        if(null != event.result.depositoryActionForm.sortFieldList1.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
            
            if(event.result.depositoryActionForm.sortFieldList1.item is ArrayCollection)
                initColl = event.result.depositoryActionForm.sortFieldList1.item as ArrayCollection;
            else
                initColl.addItem(event.result.depositoryActionForm.sortFieldList1.item);
            
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
        //5. Setting values of the SortField2 
        initColl.removeAll();
        if(null != event.result.depositoryActionForm.sortFieldList2.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.depositoryActionForm.sortFieldList2.item is ArrayCollection)
                initColl = event.result.depositoryActionForm.sortFieldList2.item as ArrayCollection;
            else
                initColl.addItem(event.result.depositoryActionForm.sortFieldList2.item);
                
            for(i = 0; i<initColl.length; i++) {
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
        //6. Setting values of the SortField3
        initColl.removeAll();
        if(null != event.result.depositoryActionForm.sortFieldList3.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.depositoryActionForm.sortFieldList3.item is ArrayCollection)
                initColl = event.result.depositoryActionForm.sortFieldList3.item as ArrayCollection;
            else
                initColl.addItem(event.result.depositoryActionForm.sortFieldList3.item);
                
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
        
        csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
        csd.init();
        
        
        //7. Setting values of the Ledger
        if(event.result.depositoryActionForm.ledgerList.ledger != null) {
            if(event.result.depositoryActionForm.ledgerList.ledger is ArrayCollection)
               initColl = event.result.depositoryActionForm.ledgerList.ledger as ArrayCollection;
            else
                initColl.addItem(event.result.depositoryActionForm.ledgerList.ledger);
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]); 
        }
        ldgr.dataProvider = tempColl;
       
     }
     
     private function sortOrder1Update():void{
         csd.update(sortField1.selectedItem,0);
     }
     
     private function sortOrder2Update():void{      
        csd.update(sortField2.selectedItem,1);
     }
     
     /**
     * This will clear the Bank Code Control and 
     * make it editable again
     */
    private function finInstClearState():void {
        
        fininstPopUp.bankCode.text = "";
        fininstPopUp.bankCode.editable = true;
        fininstPopUp.bankCode.visible=true;
        finContextList.removeAll();
    }
    /**
     * This will clear the Account No Control and
     * make it editable again.
     */
    private function accountClearState():void 
    {
        stlAccForFundPopUp.stlAccNo.text = "";
        stlAccForFundContextList.removeAll();
        stlAccForFundContextList = populateContext();
        //stlAccForFundPopUp.stlAccNo.editable = true;
        //stlAccForFundPopUp.stlAccPopup.visible = true;
    }
    
   /** 
    * This is the focusOut handler of the Fund Code.
    */
    /*private function inputHandler():void {
        
        var fundStr:String = fundPopUp.fundCode.text;
        if(!XenosStringUtils.isBlank(fundStr)){
            submit.enabled = true;
            var req :Object = new Object();
            req.fundCode = fundStr;
            loadBankAndBankAccountForFund.request = req;
            loadBankAndBankAccountForFund.send();
        }else {
            // Remove the fund code should remove bank Code and Bank Account No
            finInstClearState();
            accountClearState();
            submit.enabled = true;
        }
    }*/
    
    /** 
     * This method will populate Bank and bank Account once a Fund Code is chosen.
     * If multiple Banks are associated witha fundCode, then user has to select one
     * from the bank popup correspoding the Fund Code. If a single bank is associated
     * with a Fund, the bank is shown and made non-editable. If it has a single account,
     * account is shown and made non-editable. If multiple accounts are present, 
     * user has to choose one from the Account popup.
     */
    /*private function populateBankAndBankAccount(event:ResultEvent):void{
        
        rs = XML(event.result);
        if (null != event) {
            if(rs.child("Errors").length()>0){ 
                // i.e. Must be error, display it .
                var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list              
                for each ( var error:XML in rs.Errors.error ) {
                    errorInfoList.addItem(error.toString());
                }
                errPage.showError(errorInfoList);//Display the error
            }else {
                errPage.removeError();              

                finContextList.removeAll();
                fininstPopUp.bankCode.text = rs.bankCode;
                stlAccForFundPopUp.stlAccNo.text = rs.bankAccountNo;
                var fundArray : Array = new Array(1);
                fundArray[0] = fundPopUp.fundCode.text;
                finContextList.addItem(new HiddenObject("fundCodeContext",fundArray));
                var cashSecFlag : Array = new Array(1);
                cashSecFlag[0] = "SECURITY";
                finContextList.addItem(new HiddenObject("cashSecFlag",cashSecFlag));
                stlAccForFundContextList.removeAll();
                var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]=this.fundPopUp.fundCode.text;
                stlAccForFundContextList.addItem(new HiddenObject("stlFundCodeContext",cpTypeArray));
                var cpTypeArray1:Array = new Array(1);
                cpTypeArray1[0]=this.fininstPopUp.bankCode.text;
                stlAccForFundContextList.addItem(new HiddenObject("stlBankCodeContext",cpTypeArray1));
                stlAccForFundContextList.addItem(new HiddenObject("cashSecFlag",cashSecFlag));
                submit.enabled = true;
            }            
        }else {
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ncm.query.error.prompt.event.null'));
        }
    }*/

    /**
     * Populate Fund Code internally to FinInstPopUp.
     */
    private function populateFundToFinInstPopUp():void {
        finContextList.removeAll();
        var fundArray : Array = new Array(1);
        fundArray[0] = fundPopUp.fundCode.text;
        finContextList.addItem(new HiddenObject("fundCodeContext",fundArray));
        var ccyArray : Array = new Array(1);
        ccyArray[0] = "";
        finContextList.addItem(new HiddenObject("ccy",ccyArray));
        
        stlAccForFundContextList.removeAll();
        var cpTypeArray:Array = new Array(1);
        cpTypeArray[0]=this.fundPopUp.fundCode.text;
        stlAccForFundContextList.addItem(new HiddenObject("stlFundCodeContext",cpTypeArray));
        var cpTypeArray1:Array = new Array(1);
        cpTypeArray1[0]=this.fininstPopUp.bankCode.text;
        stlAccForFundContextList.addItem(new HiddenObject("stlBankCodeContext",cpTypeArray1));
        stlAccForFundContextList.addItem(new HiddenObject("ccy",ccyArray));
    }

    /**
     * This is the focus out handler of the bank Code
     */
    /*private function bankOutHandler():void{
        
        var bankCode : String = fininstPopUp.bankCode.text;
        if(!XenosStringUtils.isBlank(bankCode)){
            submit.enabled = true;
            var req :Object = new Object();
            req.fundCode = fundPopUp.fundCode.text;
            req.bankCode = bankCode;
            loadBankAccount.request = req;
            loadBankAccount.send();
        }else {
            // Remove the bank code should remove Bank Account No
            accountClearState();
            submit.enabled = true;
        }
    }*/
    
    /**
     * If a bank is given, search is done for the bank accounts.
     * If single account is found, populate it.
     * If multiple accounts are present, user has to choose one from the Account popup.
     */
    /*private function populateBankAccount(event:ResultEvent):void{
        
        rs = XML(event.result);
        if (null != event) {
            if(rs.child("Errors").length()>0){ 
                // i.e. Must be error, display it .
                var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list              
                for each ( var error:XML in rs.Errors.error ) {
                    errorInfoList.addItem(error.toString());
                }
                errPage.showError(errorInfoList);//Display the error
            }else {
                errPage.removeError();              

                stlAccForFundContextList.removeAll();
                //fininstPopUp.bankCode.text = rs.bankCode;
                stlAccForFundPopUp.stlAccNo.text = rs.bankAccountNo;
                var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]=this.fundPopUp.fundCode.text;
                stlAccForFundContextList.addItem(new HiddenObject("stlFundCodeContext",cpTypeArray));
                var cpTypeArray1:Array = new Array(1);
                cpTypeArray1[0]=this.fininstPopUp.bankCode.text;
                stlAccForFundContextList.addItem(new HiddenObject("stlBankCodeContext",cpTypeArray1));
                
                var cashSecFlag : Array = new Array(1);
                cashSecFlag[0] = "SECURITY";
                stlAccForFundContextList.addItem(new HiddenObject("cashSecFlag",cashSecFlag));
                submit.enabled = true;
            }            
        }else {
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ncm.query.error.prompt.event.null'));
        }
    }*/
    
    /**
     * Populate Fund Code and Bank Code internally to SettleAccPopUp.
     */
    private function populateFundAndBankToSettleAccPopUp():void {
        stlAccForFundContextList.removeAll();
        var cpTypeArray:Array = new Array(1);
        cpTypeArray[0]=this.fundPopUp.fundCode.text;
        stlAccForFundContextList.addItem(new HiddenObject("stlFundCodeContext",cpTypeArray));
        var cpTypeArray1:Array = new Array(1);
        cpTypeArray1[0]=this.fininstPopUp.bankCode.text;
        stlAccForFundContextList.addItem(new HiddenObject("stlBankCodeContext",cpTypeArray1));  
        var ccyArray : Array = new Array(1);
        ccyArray[0] = "";
        stlAccForFundContextList.addItem(new HiddenObject("ccy",ccyArray));
    }

     /**
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specifdic  
      * requriment. 
      */
    private function populateContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
        var cpTypeArray:Array = new Array(1);
        cpTypeArray[0]="";
        myContextList.addItem(new HiddenObject("stlFundCodeContext",cpTypeArray));
        var cpTypeArray1:Array = new Array(1);
        cpTypeArray1[0]="";
        myContextList.addItem(new HiddenObject("stlBankCodeContext",cpTypeArray1));
        var ccyArray : Array = new Array(1);
        ccyArray[0] = "";
        myContextList.addItem(new HiddenObject("ccy",ccyArray));
        return myContextList;
    }
    /**
      * This is the method to pass the Collection of data items
      * through the context to the fininst popup. This will be implemented as per specifdic  
      * requriment. 
      */
    private function populateFinInstCtx():void {
        //pass the context data to the popup
        //var finContextList:ArrayCollection = new ArrayCollection(); 
        
         var transferAgentRolesArray:Array = new Array(5);
         transferAgentRolesArray[0] = "Bank/Custodian";
         transferAgentRolesArray[1] = "Central Depository";
         transferAgentRolesArray[2] = "Security Broker";
         transferAgentRolesArray[3] = "Stock Exchange";
         transferAgentRolesArray[4] = "Clearing Corporation";
         
         var fundArray : Array = new Array(1);
         //fundArray[0]= fundPopUp.fundCode.text;
         //myContextList.addItem(new HiddenObject("transferAgentRoles",transferAgentRolesArray));
         /* myContextList.addItem(new HiddenObject("fundCode",fundArray)); */
         
         //XenosAlert.info("fund :"+ fundArray[0]);
        // return myContextList;
    }
    
   /**
    * This method works as the result handler of the Submit Query Http Services.
    * This also takes care of the buttons/images to be shown on teh top panel of the
    * result .
    */
    private function loadSummaryPage(event:ResultEvent):void
    {
        rs = XML(event.result);
        if (null != event) {
            if(rs.child("resultView1List").resultView1.length()>0) {
                errPage.clearError(event);
                summaryResult.removeAll();
                try {
                    for each ( var rec:XML in rs.resultView1List.resultView1) {
                        summaryResult.addItem(rec);
                    }
                 
                    changeCurrentState();
                   
                    qh.setOnResultVisibility();
                    
                    qh.setPrevNextVisibility((rs.previousTraversable1 == "true")?true:false,(rs.nextTraversable1 == "true")?true:false );
                    qh.PopulateDefaultVisibleColumns();
                    //replace null objects in datagrid with empty string
                    summaryResult=ProcessResultUtil.process(summaryResult, adjustmentSummary.columns);
                    summaryResult.refresh();
                    if(summaryResult.length==1){
                        displayDetailView(summaryResult[0].ncmEntryPk);
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
     
     private function displayDetailView(ncmEntryPk:String):void{
            var sPopup : SummaryPopup;  
            sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
            
            sPopup.title = this.parentApplication.xResourceManager.getKeyValue('ncm.depository.detail.header');
            sPopup.width = 720;
            sPopup.height = 340;
            PopUpManager.centerPopUp(sPopup);       
            sPopup.moduleUrl = NcmConstants.ADJUSTMENET_QRY_DETAILS_SWF+Globals.QS_SIGN+NcmConstants.NCM_ENTRY_PK+Globals.EQUALS_SIGN+ncmEntryPk;           
    }
    
    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
     private function doNext():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
        reqObj.listIndex = "0";
        depositoryAdjustmentQuery.request = reqObj;
        depositoryAdjustmentQuery.send();
     }
     
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        reqObj.listIndex = "0";
        depositoryAdjustmentQuery.request = reqObj;
        depositoryAdjustmentQuery.send();
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
        
        depositoryAdjustmentQuery.request = requestObj; 
        var myModel:Object = { adjustment : { toDate:this.dateTo.text,
                                              fromDate:this.dateFrom.text,
                                              entryDateTo:this.entryDateTo.text,
                                              entryDateFrom:this.entryDateFrom.text,
                                              updateDateTo:this.updateDateTo.text,
                                              updateDateFrom:this.updateDateFrom.text
                                            }
                             };
         var adjustmentValidate : AdjustmentQueryValidator = new AdjustmentQueryValidator();
         adjustmentValidate.source = myModel;
         adjustmentValidate.property = "adjustment";
         var validationResult:ValidationResultEvent = adjustmentValidate.validate();
         
         if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
            
        }else {
            depositoryAdjustmentQuery.send();
        }
    }
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        reqObj.SCREEN_KEY = 470;
        reqObj.fromPage = "query";
        reqObj.traversableIndex = "1";
        reqObj.method = "submitQuery";
        reqObj.modeOfOperation = "";
        reqObj.referenceNo = this.refno.text;
        reqObj.bankCode = this.fininstPopUp.bankCode.text;
        
        reqObj.fundCode = this.fundPopUp.fundCode.text;
        reqObj.bankAccountNo = this.stlAccForFundPopUp.stlAccNo.text;
        
        //reqObj.accountNo = this.actPopUp.accountNo.text;
        reqObj.securityCode = this.instPopUp.instrumentId.text;
        reqObj.adjustmentDateFrom = this.dateFrom.text;
        reqObj.adjustmentDateTo = this.dateTo.text;
        reqObj.adjustmentType = this.adjustmenttype.selectedItem != null ?  this.adjustmenttype.selectedItem.value : "" ;
        reqObj.reasonCode = this.adjustmentreason.selectedItem != null ?  this.adjustmentreason.selectedItem.value : "" ;
        reqObj.ledger = this.ldgr.selectedItem != null ?  this.ldgr.selectedItem.value : "" ;
        
        reqObj.status = (this.status.selectedItem != null ? this.status.selectedItem.value : "");
        reqObj.entryBy = this.entryby.employeeText.text;
        reqObj.appRegiDateFrom = this.entryDateFrom.text;
        reqObj.appRegiDateTo = this.entryDateTo.text;
        reqObj.updateBy = this.updateby.employeeText.text;
        reqObj.updateDateFrom = this.updateDateFrom.text;
        reqObj.updateDateTo = this.updateDateTo.text;
        
        reqObj.sortOrder1 = String(this.sortField1.selectedItem.value).length >1 ? this.sortField1.selectedItem.value : XenosStringUtils.EMPTY_STR;
        reqObj.sortOrder2 = String(this.sortField2.selectedItem.value).length >1 ? this.sortField2.selectedItem.value : XenosStringUtils.EMPTY_STR;
        reqObj.sortOrder3 = String(this.sortField3.selectedItem.value).length >1 ? this.sortField3.selectedItem.value : XenosStringUtils.EMPTY_STR;
        
        reqObj.rnd = Math.random() + "";
        return reqObj;
    }
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
    private function resetQuery():void { 
        finInstClearState();
        depositoryAdjustmentResetQuery.send();
    }
    /**
    * This is for the Print button which at a  time will print all the data 
    * in the dataprovider of the Datagrid object
    */
     private function doPrint():void{
        
     } 
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
        var url : String = "ncm/depositoryQueryDispatchAction.action?method=generateXLS";
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
        var url : String = "ncm/depositoryQueryDispatchAction.action?method=generatePDF";
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