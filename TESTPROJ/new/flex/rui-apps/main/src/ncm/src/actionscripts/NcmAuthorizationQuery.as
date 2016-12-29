
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.containers.SummaryPopup;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.DateUtils;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.ncm.validators.AuthorizationQueryValidator;
 
 import flash.net.URLRequest;
 import flash.net.URLRequestMethod;
 
 import mx.collections.ArrayCollection;
 import mx.core.UIComponent;
 import mx.events.ResourceEvent;
 import mx.events.ValidationResultEvent;
 import mx.managers.PopUpManager;
 import mx.resources.ResourceBundle;
 import mx.rpc.events.ResultEvent;
 import mx.utils.StringUtil;
 

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
    private var selectedResults:ArrayCollection=new ArrayCollection(); 
    [Bindable]
    public var conformSelectedResults : ArrayCollection = new ArrayCollection(); 
    [Bindable]
    public var selectifAny:Boolean=false;
    [Bindable]
    public var authRejectValue : ArrayCollection;
    [Bindable]
    private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
    private var loggedOnUser:String;
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
        qh.dgrid = authorizationSummary;
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
            req.SCREEN_KEY = 11006;
            initNcmAuthorizationQuery.request = req;            
            initNcmAuthorizationQuery.url = "ncm/ncmAuthQueryDispatch.action?method=initialExecute&rnd=" + rndNo;                    
            initNcmAuthorizationQuery.send();        
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
        var sortField1Default:String = event.result.ncmAuthorizationQueryActionForm.sortField1;
        var sortField2Default:String = event.result.ncmAuthorizationQueryActionForm.sortField2;
        var sortField3Default:String = event.result.ncmAuthorizationQueryActionForm.sortField3;
        
        errPage.clearError(event); //clears the errors if any 
        //initiate text fields
        refno.text = "";
        
        fininstPopUp.bankCode.text = "";
        stlAccForFundPopUp.stlAccNo.text = "";
        ccyBox.ccyText.text = "";
        instPopUp.instrumentId.text = "";
        fundPopUp.fundCode.text = "";
        //gleledger.gleCode.text = "";
        dateFrom.setFocus();
         
        if(event.result == null || event.result.ncmAuthorizationQueryActionForm ==null){
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ncm.query.error.prompt.initialization.fail'));
        }
        //Setting logged on user
        loggedOnUser = event.result.ncmAuthorizationQueryActionForm.loggedOnUser;
        //Setting dateFrom and dateTo
        if(event.result.ncmAuthorizationQueryActionForm.dateFrom!= null && event.result.ncmAuthorizationQueryActionForm.dateTo != null) {
            dateStr=event.result.ncmAuthorizationQueryActionForm.dateFrom;
            if(dateStr != null)
                dateFrom.selectedDate = DateUtils.toDate(dateStr);

            dateStr=event.result.ncmAuthorizationQueryActionForm.dateTo;
            if(dateStr != null)
                dateTo.selectedDate = DateUtils.toDate(dateStr);
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ncm.query.error.prompt.fromto.date'));
        }
        
        //1.Setting values of the Adjustment Type
        if(event.result.ncmAuthorizationQueryActionForm.adjustmentTypeList.item != null) {
            if(event.result.ncmAuthorizationQueryActionForm.adjustmentTypeList.item is ArrayCollection)
               initColl = event.result.ncmAuthorizationQueryActionForm.adjustmentTypeList.item as ArrayCollection;
            else
                initColl.addItem(event.result.ncmAuthorizationQueryActionForm.adjustmentTypeList.item);
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        adjustmenttype.dataProvider = tempColl;
        
         // Setting values of the GLE Ledger Code
        initColl.removeAll();
        if(event.result.ncmAuthorizationQueryActionForm.actionFormList.gleLedgerList.item != null) {
            if(event.result.ncmAuthorizationQueryActionForm.actionFormList.gleLedgerList.item is ArrayCollection)
                initColl = event.result.ncmAuthorizationQueryActionForm.actionFormList.gleLedgerList.item as ArrayCollection;
            else
                initColl.addItem(event.result.ncmAuthorizationQueryActionForm.actionFormList.gleLedgerList.item);
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        gleledger.dataProvider = tempColl;
        
        //2. Setting values of the Adjustment Reason
        initColl.removeAll();
        if(event.result.ncmAuthorizationQueryActionForm.actionFormList !=null){
                if(event.result.ncmAuthorizationQueryActionForm.actionFormList.reasonCodeList.item != null) {
                    if(event.result.ncmAuthorizationQueryActionForm.actionFormList.reasonCodeList.item is ArrayCollection)
                        initColl = event.result.ncmAuthorizationQueryActionForm.actionFormList.reasonCodeList.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.ncmAuthorizationQueryActionForm.actionFormList.reasonCodeList.item);
                }
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        adjustmentreason.dataProvider = tempColl;
        
        initCompFlg = true;
        //4. Setting values of the SortField1
        initColl.removeAll();
        if(null != event.result.ncmAuthorizationQueryActionForm.sortFieldList1.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
            
            if(event.result.ncmAuthorizationQueryActionForm.sortFieldList1.item is ArrayCollection)
                initColl = event.result.ncmAuthorizationQueryActionForm.sortFieldList1.item as ArrayCollection;
            else
                initColl.addItem(event.result.ncmAuthorizationQueryActionForm.sortFieldList1.item);
            
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
        if(null != event.result.ncmAuthorizationQueryActionForm.sortFieldList2.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.ncmAuthorizationQueryActionForm.sortFieldList2.item is ArrayCollection)
                initColl = event.result.ncmAuthorizationQueryActionForm.sortFieldList2.item as ArrayCollection;
            else
                initColl.addItem(event.result.ncmAuthorizationQueryActionForm.sortFieldList2.item);
                
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
        if(null != event.result.ncmAuthorizationQueryActionForm.sortFieldList3.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.ncmAuthorizationQueryActionForm.sortFieldList3.item is ArrayCollection)
                initColl = event.result.ncmAuthorizationQueryActionForm.sortFieldList3.item as ArrayCollection;
            else
                initColl.addItem(event.result.ncmAuthorizationQueryActionForm.sortFieldList3.item);
                
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
        
        // 
        initColl.removeAll();
        initColl = event.result.ncmAuthorizationQueryActionForm.authRejectList.authReject as ArrayCollection;
        authRejectValue = new ArrayCollection();
        authRejectValue.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            authRejectValue.addItem(initColl[i]);    
        }
		app.submitButtonInstance = submit;

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
    private function accountClearState():void {
        stlAccForFundPopUp.stlAccNo.text = "";
        stlAccForFundContextList.removeAll();
        stlAccForFundContextList = populateContext();
    }
     /** 
    * This is the focusOut handler of the Fund Code.
    */
    /*private function inputHandler():void {
        
        var fundStr:String = fundPopUp.fundCode.text;
        if(!XenosStringUtils.isBlank(fundStr)){
            submit.enabled = false;
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
                stlAccForFundContextList.removeAll();
                var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]=this.fundPopUp.fundCode.text;
                stlAccForFundContextList.addItem(new HiddenObject("stlFundCodeContext",cpTypeArray));
                var cpTypeArray1:Array = new Array(1);
                cpTypeArray1[0]=this.fininstPopUp.bankCode.text;
                stlAccForFundContextList.addItem(new HiddenObject("stlBankCodeContext",cpTypeArray1));
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
        
        stlAccForFundContextList.removeAll();
        var cpTypeArray:Array = new Array(1);
        cpTypeArray[0]=this.fundPopUp.fundCode.text;
        stlAccForFundContextList.addItem(new HiddenObject("stlFundCodeContext",cpTypeArray));
        var cpTypeArray1:Array = new Array(1);
        cpTypeArray1[0]=this.fininstPopUp.bankCode.text;
        stlAccForFundContextList.addItem(new HiddenObject("stlBankCodeContext",cpTypeArray1));
    }

    /**
     * This is the focus out handler of the bank Code
     */
    /*private function bankOutHandler():void{
        
        var bankCode : String = fininstPopUp.bankCode.text;
        if(!XenosStringUtils.isBlank(bankCode)){
            submit.enabled = false;
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
                stlAccForFundPopUp.stlAccNo.text = rs.bankAccountNo;        
                stlAccForFundContextList.removeAll();
                var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]=this.fundPopUp.fundCode.text;
                stlAccForFundContextList.addItem(new HiddenObject("stlFundCodeContext",cpTypeArray));
                var cpTypeArray1:Array = new Array(1);
                cpTypeArray1[0]=this.fininstPopUp.bankCode.text;
                stlAccForFundContextList.addItem(new HiddenObject("stlBankCodeContext",cpTypeArray1));  
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
        return myContextList;
    }
    /**
      * This is the method to pass the Collection of data items
      * through the context to the fininst popup. This will be implemented as per specifdic  
      * requriment. 
      */
    private function populateFinInstCtx():void {
        //pass the context data to the popup
         var transferAgentRolesArray:Array = new Array(5);
         transferAgentRolesArray[0] = "Bank/Custodian";
         transferAgentRolesArray[1] = "Central Depository";
         transferAgentRolesArray[2] = "Security Broker";
         transferAgentRolesArray[3] = "Stock Exchange";
         transferAgentRolesArray[4] = "Clearing Corporation";
         
         var fundArray : Array = new Array(1);
         fundArray[0]= fundPopUp.fundCode.text;

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
                    summaryResult=ProcessResultUtil.process(summaryResult, authorizationSummary.columns);
                    
                    conformSelectedResults.removeAll();
                    for(var i:int = 0; i < summaryResult.length; i++){
                        summaryResult[i].selectedValue = '';
                        summaryResult[i].rowNumInt = i;
                        summaryResult[i].indexValue = 0;
                        if (summaryResult[i].updatedBy == loggedOnUser) {
                            summaryResult[i].viewEnable = 0;
                            summaryResult[i].showTip = this.parentApplication.xResourceManager.getKeyValue('ncm.authorization.entry.tooltip');
                        } else {
                            summaryResult[i].viewEnable = 1;
                        }
                    }
                    changeCurrentState();
                    qh.setOnResultVisibility();
                    
                    qh.setPrevNextVisibility((rs.previousTraversable1 == "true")?true:false,(rs.nextTraversable1 == "true")?true:false );
                    qh.PopulateDefaultVisibleColumns();
                    //replace null objects in datagrid with empty string
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
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
     private function doNext():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
        reqObj.listIndex = "0";
        ncmAuthorizationQuery.request = reqObj;
        ncmAuthorizationQuery.send();
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
        ncmAuthorizationQuery.request = reqObj;
        ncmAuthorizationQuery.send();
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
        
        ncmAuthorizationQuery.request = requestObj; 
        var myModel:Object = { adjustment : {
                                            toDate:this.dateTo.text, 
                                            fromDate:this.dateFrom.text,
                                            ccyCode : this.ccyBox.ccyText.text,
                                            instrumentId : this.instPopUp.instrumentId.text
                                            }
                             };
         var authorizationValidate : AuthorizationQueryValidator = new AuthorizationQueryValidator();
         authorizationValidate.source = myModel;
         authorizationValidate.property = "adjustment";
         var validationResult:ValidationResultEvent = authorizationValidate.validate();
         
        if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
                       
        } else {
            ncmAuthorizationQuery.send();   
        }    
    }
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        reqObj.SCREEN_KEY = 11007;
        reqObj.fromPage = "query";
        reqObj.traversableIndex = "1";
        reqObj.method = "submitQuery";
        reqObj.referenceNo = this.refno.text;
        
        reqObj.fundCode = this.fundPopUp.fundCode.text;
        reqObj.bankCode = fininstPopUp.bankCode.text;
        reqObj.bankAccountNo = this.stlAccForFundPopUp.stlAccNo.text;
        reqObj.currency = this.ccyBox.ccyText.text;
        reqObj.securityCode = this.instPopUp.instrumentId.text;         
        reqObj.adjustmentDateFrom = this.dateFrom.text;
        reqObj.adjustmentDateTo = this.dateTo.text;
        reqObj.adjustmentType = this.adjustmenttype.selectedItem != null ?  this.adjustmenttype.selectedItem.value : "" ;
        reqObj.reasonCode = this.adjustmentreason.selectedItem != null ?  this.adjustmentreason.selectedItem.value : "" ;
        reqObj.gleLedgerCode = this.gleledger.selectedItem != null ? this.gleledger.selectedItem.value : "";

        reqObj.sortOrder1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.sortOrder2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.sortOrder3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : XenosStringUtils.EMPTY_STR;

        reqObj.rnd = Math.random() + "";
        return reqObj;
    }
     
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
    private function resetQuery():void { 
        finInstClearState();
        ncmAuthorizationResetQuery.send();
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
        var url : String = "ncm/ncmAuthQueryDispatch.action?method=generateXLS";
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
        var url : String = "ncm/ncmAuthQueryDispatch.action?method=generatePDF";
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
     * Add the selected to authorize.
     */
     public function checkSelectToModify(item:Object):void {
        var tempArray:Array = new Array();
        var addSelected:Boolean = true;
        if(!XenosStringUtils.isBlank(item.selectedValue)) { // needs to insert  
            for(var i:int = 0; i < selectedResults.length; i++) {
                if(selectedResults[i].rowNumInt == item.rowNumInt) {
                    addSelected = false;
                }
            }
            if (addSelected) {
                selectedResults.addItem(item);
            }
        } else { //needs to pop
            tempArray=selectedResults.toArray();
            selectedResults.removeAll();
            for(i=0; i < tempArray.length; i++){
                if(tempArray[i].rowNumInt != item.rowNumInt){
                    selectedResults.addItem(tempArray[i]);
                }
            }
        } 
        conformSelectedResults= selectedResults;
    }
    
    /**
     * Show the authorization confirmation page.
     */
     public function showResult():void {
        var i:Number;
        var obj:Object=new Object();
        var groupIdArray:Array = new Array();
        var authRejectArray:Array = new Array();
        var pkArray:Array = new Array();
        
        if(conformSelectedResults.length > 0 ) {
            selectifAny = true;
            obj.fromPage = "queryResult";
            obj.traversableIndex = "2";
            obj.method="doPreConfirmAuthorize";
            
            for(i=0; i<conformSelectedResults.length; i++){
                groupIdArray[i] = conformSelectedResults[i].groupId;
                authRejectArray[i] = conformSelectedResults[i].selectedValue;
                pkArray[i] = conformSelectedResults[i].ncmEntryPk;
            }
            obj.selectedGroupIdArray = null;
            obj.selectedGroupIdArray = groupIdArray;
            obj.selectedAuthRejectArray = null;
            obj.selectedAuthRejectArray = authRejectArray;
            obj.selectedNcmEntryPkArray = null;
            obj.selectedNcmEntryPkArray = pkArray;
        } else {
            selectifAny = false;
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ncm.authorization.entry.prompt.select'));
        }
        if(selectifAny){
            obj.unique= new Date().getTime() + "";
            ncmAuthorizationConfirmRequest.request=obj;
            ncmAuthorizationConfirmRequest.send();
        }
     }  

    /**
     * Load the selected to authorization confirmation page.
     * 
     */
     public function loadConfirmationQueryPage(event:ResultEvent):void {
        
        var sPopup : SummaryPopup;  
        var parentApp :UIComponent = UIComponent(this.parentApplication);
        sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
        sPopup.addEventListener("RefreshChanges",handleRefreshChanges);
        sPopup.addEventListener("EnterKeyEnable",enableEnterKeyOnReturn);
        sPopup.title = this.parentApplication.xResourceManager.getKeyValue('ncm.authorization.entry.header.user.conf');
        sPopup.width = 620;
        sPopup.height = 530;
        sPopup.owner=this;
        sPopup.showCloseButton=false;
        
        PopUpManager.centerPopUp(sPopup);
        sPopup.moduleUrl = "assets/appl/ncm/NcmAuthConfirmationPopup.swf";
        
     }
     
     public function handleRefreshChanges(event:Event):void {
        this.submitQuery();
    }
    
    /**
     * Method to enable enter key when back button is pressed 
     * from authorization entry popup.
     */
     public function enableEnterKeyOnReturn(event:Event):void {
        app.submitButtonInstance = submit1;
    }
