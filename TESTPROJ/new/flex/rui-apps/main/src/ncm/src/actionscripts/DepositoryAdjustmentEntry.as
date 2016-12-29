
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.utils.DateUtils;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.ncm.validators.DepositoryAdjustmentEntryValidator;
 import com.nri.rui.core.utils.OnDataChangeUtil;
 
 import flash.events.Event;
 
 import mx.collections.ArrayCollection;
 import mx.events.ResourceEvent;
 import mx.events.ValidationResultEvent;
 import mx.resources.ResourceBundle;
 import mx.rpc.events.ResultEvent;
 import mx.utils.StringUtil;
 import mx.events.FlexEvent;
        
    private var rndNo:Number = 0;   
    private var initCompFlg : Boolean = false;
    
    [Bindable]
    private var queryResult:Object= new Object();
    [Bindable]
    public var returnFinContext:ArrayCollection = new ArrayCollection();
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    [Bindable]
    public var returnTradingContextItem:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var finContextList:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var stlAccForFundContextList:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var rs:XML = new XML();
    [Bindable]
    private var prevFundCode:String;

    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    private function initPageStart():void { 
        if (!initCompFlg) {  
            rndNo= Math.random();
            var req : Object = new Object();
            req.SCREEN_KEY = 463;
            initDepositoryAdjustmentEntry.request = req;           
            initDepositoryAdjustmentEntry.url = "ncm/depositoryAdjustmentDispatchAction.action?method=initEntry&rnd=" + rndNo;                    
            initDepositoryAdjustmentEntry.send();  
        } else
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.initiate'));
    }
 
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * 
    */   
    private function initPage(event: ResultEvent) : void {
        var i :int = 0;
        var dateStr:String = null;
        var initColl:ArrayCollection = new ArrayCollection();
        var tempColl: ArrayCollection;
         
        errPage.clearError(event); //clears the errors if any 
        //removeWarnings();
        //AC actPopUp.accountNo.text = "";
        fundPopUp.fundCode.text = "";
        fundName.text = "";
        fininstPopUp.bankCode.text = "";
        fininstName.text = "";
        stlAccForFundPopUp.stlAccNo.text = "";
        stlAccName.text = "";
        instPopUp.instrumentId.text = "";
        securityName.text = "";
        quantity.text ="";
        adjustmentdate.text = "";
        adjustmentdate.selectedDate = null;
        tradingactPopUp.accountNo.text = "";
        tradindAccName.text = "";
        remarks.text = "";
        fundPopUp.fundCode.setFocus();
        
        fundPopUp.fundCode.addEventListener(FlexEvent.VALUE_COMMIT, onChangeFundCode);
        fininstPopUp.bankCode.addEventListener(FlexEvent.VALUE_COMMIT, onChangeBankCode);
        stlAccForFundPopUp.stlAccNo.addEventListener(FlexEvent.VALUE_COMMIT, onChangeStlAccNo);
        tradingactPopUp.accountNo.addEventListener(FlexEvent.VALUE_COMMIT, onChangeTradingAccountNo);
        instPopUp.instrumentId.addEventListener(FlexEvent.VALUE_COMMIT, onChangeSecurityCode);
        if(event.result == null || event.result.depositoryAdjustmentActionForm == null){
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ncm.query.error.prompt.initialization.fail'));
        } 
        //1.Setting value of adjustmentDate
         if(event.result.depositoryAdjustmentActionForm.entry.inOutDateStr!= null) {
            dateStr=event.result.depositoryAdjustmentActionForm.entry.inOutDateStr;
            if(dateStr != null){
                adjustmentdate.selectedDate = DateUtils.toDate(dateStr);
                adjustmentdate.text = dateStr;
            }
         }else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ncm.query.error.prompt.adjdate'));
        }
        
        //2. Setting values of the Adjustment Type
        if(event.result.depositoryAdjustmentActionForm.actionFormList.adjustmentTypeList.item != null) {
            if(event.result.depositoryAdjustmentActionForm.actionFormList.adjustmentTypeList.item is ArrayCollection)
               initColl = event.result.depositoryAdjustmentActionForm.actionFormList.adjustmentTypeList.item as ArrayCollection;
            else
                initColl.addItem(event.result.depositoryAdjustmentActionForm.actionFormList.adjustmentTypeList.item);
        }
        tempColl = new ArrayCollection();
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        adjustmenttype.dataProvider = tempColl;
        
        //3. Setting values of the Adjustment Reason
        initColl.removeAll();
        if(event.result.depositoryAdjustmentActionForm.actionFormList.reasonCodeList.item != null) {
            if(event.result.depositoryAdjustmentActionForm.actionFormList.reasonCodeList.item is ArrayCollection)
                initColl = event.result.depositoryAdjustmentActionForm.actionFormList.reasonCodeList.item as ArrayCollection;
            else
                initColl.addItem(event.result.depositoryAdjustmentActionForm.actionFormList.reasonCodeList.item);
        }
        tempColl = new ArrayCollection();
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        adjustmentreason.dataProvider = tempColl;
        
        //4. Setting values of the Form
        /*
        initColl.removeAll();
        if(event.result.depositoryAdjustmentActionForm.actionFormList.form.item != null) {
            if(event.result.depositoryAdjustmentActionForm.actionFormList.form.item is ArrayCollection)
                initColl = event.result.depositoryAdjustmentActionForm.actionFormList.form.item as ArrayCollection;
            else
                initColl.addItem(event.result.depositoryAdjustmentActionForm.actionFormList.form.item);
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        formList.dataProvider = tempColl;
        
        */
        
         //5. Setting values of the Ledger
        initColl.removeAll();
        if(event.result.depositoryAdjustmentActionForm.actionFormList.ledgerList.ledger != null) {
            if(event.result.depositoryAdjustmentActionForm.actionFormList.ledgerList.ledger is ArrayCollection)
                initColl = event.result.depositoryAdjustmentActionForm.actionFormList.ledgerList.ledger as ArrayCollection;
            else
                initColl.addItem(event.result.depositoryAdjustmentActionForm.actionFormList.ledgerList.ledger);
        }
        tempColl = new ArrayCollection(); 
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        ledgerList.dataProvider = tempColl;
        //Set the focus to the first field
        // actPopUp.accountNo.setFocus();
        fundPopUp.fundCode.setFocus();
            
        initCompFlg = true;
        previousState(false);
        //submit.enabled = false;
        //fininstPopUp.enabled = false;
        //stlAccForFundPopUp.enabled = false;
   
    }
    
 
    /**
    * This is called at creationComplete of the module
    */
     private function loadAll():void {

     } 
     
     /*
     private function removeWarnings():void
     {
        warnMultipleBank.visible = false;
        warnMultipleBank.includeInLayout = false; 
        warnMultipleBankAcc.visible = false;
        warnMultipleBankAcc.includeInLayout = false;
     } 
     */

    /**
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specifdic  
      * requriment. 
      */
    private function populateContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
      
        //Bank Code
        var bankCode:Array = new Array(1);
        bankCode[0] = this.fininstPopUp.bankCode.text;
        myContextList.addItem(new HiddenObject("stlBankCodeContext",bankCode)); 
        //Fund Code
        var fundCode:Array = new Array(1);
        fundCode[0] = this.fundPopUp.fundCode.text;
        myContextList.addItem(new HiddenObject("stlFundCodeContext",fundCode));
        //CCY
        var ccyArray:Array = new Array(1);
        ccyArray[0] = "";
        myContextList.addItem(new HiddenObject("ccy",ccyArray));
         //CASH/SECURITY FLAG
        
        /*var cashSecFlag:Array = new Array(1);
        cashSecFlag[0] ="SECURITY"
        myContextList.addItem(new HiddenObject("cashSecFlag",cashSecFlag));
        */
        return myContextList;
        
    }
   
    /**
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specifdic  
      * requriment. 
      */
    private function populateTradingContext():ArrayCollection {
        
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
      
        //passing counter party type                
        var cpTypeArray:Array = new Array(3);
            cpTypeArray[0]="BANK/CUSTODIAN";
            cpTypeArray[1]="BROKER";
            cpTypeArray[2]="INTERNAL";
        myContextList.addItem(new HiddenObject("cpTypeContext",cpTypeArray));
    
        //passing account status 
        var actStatus:Array = new Array(1);
        actStatus[0]="OPEN";
        myContextList.addItem(new HiddenObject("statusContext",actStatus));
                       
       /* var actStatusArray:Array = new Array(1);
        actStatusArray[0]="T";
        myContextList.addItem(new HiddenObject("actTypeContext",actStatusArray));*/
        
        return myContextList;
        
    }
    /**
    * It sends/submits the entry form. 
    * 
    */
    private function submitQuery():void 
    {  
        prevFundCode =  this.fundPopUp.fundCode.text;
        //Set the request parameters
        var requestObj :Object = populateRequestParams();
        
        depositoryAdjustmentEntry.request = requestObj;
        var myModel:Object = { depositoryAdjustmententry : {
                                    fundCode : this.fundPopUp.fundCode.text,
                                    bankCode : this.fininstPopUp.bankCode.text,
                                    accountNo : this.stlAccForFundPopUp.stlAccNo.text,
                                    instrumentId : this.instPopUp.instrumentId.text,
                                    quantity : this.quantity.text,
                                    adjustmentDate : this.adjustmentdate.text,
                                    adjustmentType : (this.adjustmenttype.selectedItem != null ?  this.adjustmenttype.selectedItem.value : ""),
                                    adjustmentReason :(this.adjustmentreason.selectedItem != null ?  this.adjustmentreason.selectedItem.value : "")
                                    }
                                };
         var adjustmentValidate : DepositoryAdjustmentEntryValidator = new DepositoryAdjustmentEntryValidator();
         adjustmentValidate.source = myModel;
         adjustmentValidate.property = "depositoryAdjustmententry";
         var validationResult:ValidationResultEvent = adjustmentValidate.validate();
         
         if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
                       
          }else {
             //Set the button disabled to prevent multiple submissions
             //submit.enabled = false; 
             rndNo= Math.random(); 
             depositoryAdjustmentEntry.url = depositoryAdjustmentEntry.url+"&rnd=" + rndNo;
             depositoryAdjustmentEntry.send();  
          }    
                                            
    }
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        var reqObj : Object = new Object();
        reqObj.SCREEN_KEY = 464;
        reqObj['entry.fundCode'] = this.fundPopUp.fundCode.text;
        reqObj['entry.fundName'] = this.fundName.text;
        reqObj['entry.bankCode'] = this.fininstPopUp.bankCode.text;
        reqObj['entry.bankAccountNo'] = this.stlAccForFundPopUp.stlAccNo.text;
        reqObj['entry.accountShortName'] = this.stlAccName.text;
        reqObj['entry.securityCode'] = this.instPopUp.instrumentId.text; 
        reqObj['entry.securityName'] = this.securityName.text;
        reqObj['entry.amountStr'] = this.quantity.text; // amountStr is the quantity
        reqObj['entry.inOutDateStr'] = this.adjustmentdate.text;
        reqObj['entry.adjustmentType'] = this.adjustmenttype.selectedItem != null ?  this.adjustmenttype.selectedItem.value : "" ;
        reqObj['entry.reasonCode'] = this.adjustmentreason.selectedItem != null ?  this.adjustmentreason.selectedItem.value : "" ;
        reqObj['entry.tradingAccountNo'] = this.tradingactPopUp.accountNo.text;
        reqObj['entry.tradingAccountShortName'] = this.tradindAccName.text;
        reqObj['entry.remarks'] = this.remarks.text;
        //reqObj['entry.form'] = this.formList.selectedItem != null ?  this.formList.selectedItem.value : "" ;
        reqObj['entry.ledger'] = (this.ledgerList.selectedItem != null )?  this.ledgerList.selectedItem.value : "" ;

        return reqObj;
    }
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
    private function resetQuery():void { 
        
        //removeWarnings();
        initCompFlg = false;
        initPageStart();
        currentState = '';
        
    }
    /**
    * This method is the resultHandler for confirm action. This is required for the 
    * User Confirmation Screen to show the values in non editable form.
    */
     private function validateResult(event:ResultEvent):void
     {
        //removeWarnings();
        rs = XML(event.result);
        if (null != event) {
            if(!rs.child("entry").length()>0){ 
                if(rs.child("Errors").length()>0){ // i.e. Must be error, display it .
                       var errorInfoList : ArrayCollection = new ArrayCollection();
                       //populate the error info list               
                       for each ( var error:XML in rs.Errors.error ) {
                           errorInfoList.addItem(error.toString());
                       }
                       errPage.showError(errorInfoList);//Display the error
                     }
                else{ // Clear the error
                     errPage.removeError();
                }
          }else {
                errPage.removeError();
                if(errPage1 != null){
                    errPage1.removeError();
                }
                queryResult = rs;
                adjustmentEntry.selectedChild = depositoryAdjustConfirm;

               /* 
               loadBankAndBankAccount(rs);
                if(rs.entry.multipleBankPresent == false && rs.entry.multipleBankAccountPresent == false) {
                    queryResult = rs;
                    adjustmentEntry.selectedChild = depositoryAdjustConfirm;
                }
               */
            }            
        }else {
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ncm.query.error.prompt.event.null'));
        }
     }
    
    
    /**
    * This method is the resultHandler for confirm action. This is required for the 
    * User Confirmation Screen to show the values in non editable form.
    */
     private function validateConfirmResult(event:ResultEvent):void
     {
        ok.enabled=true;
        rs = XML(event.result);
        if (null != event) {
            if(!rs.child("entry").length()>0){ 
                if(rs.child("Errors").length()>0){ // i.e. Must be error, display it .
                       var errorInfoList : ArrayCollection = new ArrayCollection();
                       //populate the error info list               
                       for each ( var error:XML in rs.Errors.error ) {
                           errorInfoList.addItem(error.toString());
                       }
                       errPage1.showError(errorInfoList);//Display the error
                     }
                else{ // Clear the error
                     errPage1.removeError();
                }
          }else {
                errPage1.removeError();
                queryResult = rs;
                if(XenosStringUtils.isBlank(rs.entry.referenceNo.toString())){
                    changeToConfirmState(false);
                }else{
                    changeToConfirmState(true);
                }
            }            
        }else {
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ncm.query.error.prompt.event.null'));
        }
     }
     
     /** 
     * This will determine whether the transaction Number should be shown
     * with OK button or it will be the User Confirmation page.
     */
     private function changeToConfirmState(showRefNo : Boolean):void {
          if(showRefNo){
            //Show the Reference Number
            currentState = "confirm"; 
          }
          
     }
     /**
     * Previous State
     */
     private function previousState(back :Boolean):void{
        //removeWarnings();
        if(!back){
            finInstClearState();
            accountClearState();
        }
        adjustmentEntry.selectedChild = depositoryAdjustEntry;
     }
     /**
     * Sending the http service for SAVE operation
     */
     private function  doSave(event : Event) :void{
        ok.enabled=false;
        var req : Object = new Object();
        req.SCREEN_KEY = 465;
        depositoryAdjustmentConfirm.request = req;          
        depositoryAdjustmentConfirm.url = "ncm/depositoryAdjustmentDispatchAction.action?method=doSave&unique="+new Date().getTime();
        depositoryAdjustmentConfirm.send(); 
     }
    
    /**
     * Formatting Quantity
     */
     private function quantityHandler():void{
        
        var vResult:ValidationResultEvent;
        vResult = numVal.validate();
        
        if (vResult.type==ValidationResultEvent.VALID) {
            quantity.text=numberFormatter.format(quantity.text);
        }else{
            quantity.text = XenosStringUtils.EMPTY_STR;
        }
     }
     
    /** 
    * This is the focusOut handler of the Fund Code.
    */
    private function inputHandler():void {
        
        var fundStr:String = fundPopUp.fundCode.text;
        if(!XenosStringUtils.isBlank(fundStr)){
            var req :Object = new Object();
            req['entry.fundCode'] = fundStr;
            loadBankAndBankAccountForFund.request = req;
            loadBankAndBankAccountForFund.send();
        }else {
            // Remove the fund code should remove bank Code and Bank Account No
            if(errPage.isError()){
                //disableBankAndFinInst();
            }
            else{
                finInstClearState();
                accountClearState();
            }
            //fininstPopUp.fundCodeCheck = false;
            //stlAccForFundPopUp.fundCodeCheck = false;
            //submit.enabled = false;
            finContextList.removeAll();
            var fundArray : Array = new Array(1);
            fundArray[0] = fundPopUp.fundCode.text;
            finContextList.addItem(new HiddenObject("fundCodeContext",fundArray));
            var brokerRoles:Array = new Array(1);
            brokerRoles[0]= "Bank/Custodian";
            finContextList.addItem(new HiddenObject("brokerRoles",brokerRoles));
           // fininstPopUp.bankCode.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT));
        	//stlAccForFundPopUp.stlAccNo.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT));
        }
    }
        
     private function disableBankAndFinInst():void
     {
        fininstPopUp.bankCode.editable = false;
        fininstPopUp.finInstFundPopup.visible=false;
        fininstPopUp.bankCode.text = "";
        stlAccForFundPopUp.stlAccNo.editable = false;
        stlAccForFundPopUp.stlAccPopup.visible = false;
        stlAccForFundPopUp.stlAccNo.text = "";
    }
    
     /**
     * This will clear the Bank Code Control and 
     * make it editable again
     */
    private function finInstClearState():void
    {
        finContextList.removeAll();
        fininstPopUp.bankCode.text = "";
        fininstPopUp.bankCode.editable = true;
        fininstPopUp.finInstFundPopup.visible=true;
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
        stlAccForFundPopUp.stlAccNo.editable = true;
        stlAccForFundPopUp.stlAccPopup.visible = true;
    }
    
  private function stlAccountCheck():void
  {
        var alerStr:String = null;
        
        if(StringUtil.trim(fundPopUp.fundCode.text) == XenosStringUtils.EMPTY_STR)
            alerStr = this.parentApplication.xResourceManager.getKeyValue('ncm.entry.prompt.fundcode');
        
        if(StringUtil.trim(fininstPopUp.bankCode.text) == XenosStringUtils.EMPTY_STR)
            //alerStr = alerStr + " and Bank Code";
            alerStr = this.parentApplication.xResourceManager.getKeyValue('ncm.entry.prompt.bankcode');
        
        if(alerStr != null){
            //stlAccForFundPopUp.fundCodeCheck = false;
            XenosAlert.info(alerStr);
        }
   }
   
   private function finInstCheck():void
   {
        if(StringUtil.trim(fundPopUp.fundCode.text) == XenosStringUtils.EMPTY_STR){
            //fininstPopUp.fundCodeCheck = false;
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ncm.entry.prompt.fundcode'));
            }
   }  
   
    /**
     * This is the focus out handler of the bank Code
     */
    private function bankOutHandler():void{
        var bankCode : String = fininstPopUp.bankCode.text;
        if(!XenosStringUtils.isBlank(bankCode)){
            if(fininstPopUp.bankCode.editable == true){
                ////submit.enabled = false;
                var req :Object = new Object();
                req.fundCode = "";
                req['entry.bankCode'] = bankCode;
                loadBankAccount.request = req;
                loadBankAccount.send();
            }
        }else {
            // Remove the bank code should remove Bank Account No
            if(errPage.isError()){
                //disableBankAndFinInst();
            }
            else{
                //finInstClearState();
                accountClearState();
            }
            //stlAccForFundPopUp.fundCodeCheck = false;
        }
        
    }
    
    
    /** 
     * This method will populate Bank and bank Account once a Fund Code is chosen.
     * If multiple Banks are associated witha fundCode, then user has to select one
     * from the bank popup correspoding the Fund Code. If a single bank is associated
     * with a Fund, the bank is shown and made non-editable. If it has a single account,
     * account is shown and made non-editable. If multiple accounts are present, 
     * user has to choose one from the Account popup.
     */
    private function populateBankAndBankAccount(event:ResultEvent):void
    {
        finInstClearState();
        accountClearState();
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
                       //disableBankAndFinInst();
                       //submit.enabled = false;
          }else {
                 // Clear the error
                 errPage.removeError();
                
                 if(rs.entry.multipleBankPresent==true || rs.entry.pageLoading == true){
                    
                    finInstClearState();
                    fininstPopUp.fundCodeCheck = true;
                }
                if(rs.entry.multipleBankPresent==false && rs.entry.pageLoading == false){
                    
                    fininstPopUp.bankCode.text = rs.entry.bankCode;
                    //fininstPopUp.bankCode.editable = false;
                    //fininstPopUp.finInstFundPopup.visible=false;
                    focusManager.setFocus(instPopUp.instrumentId);
                    //fininstPopUp.fundCodeCheck = true;
                } 
                if(rs.entry.multipleBankAccountPresent==true || rs.entry.pageLoading == true){
                    accountClearState();
                    stlAccForFundPopUp.fundCodeCheck = true;
                    
                }
                
                if(rs.entry.multipleBankAccountPresent==false && rs.entry.pageLoading == false){
                    
                    stlAccForFundPopUp.stlAccNo.text = rs.entry.bankAccountNo;
                    //stlAccForFundPopUp.stlAccNo.editable = false;
                    //stlAccForFundPopUp.stlAccPopup.visible = false;
                    //stlAccForFundPopUp.fundCodeCheck = true;
                }
                finContextList.removeAll();
                var fundArray : Array = new Array(1);
                fundArray[0] = fundPopUp.fundCode.text;
                finContextList.addItem(new HiddenObject("fundCodeContext",fundArray));
                var brokerRoles:Array = new Array(1);
                brokerRoles[0]= "Bank/Custodian";
                finContextList.addItem(new HiddenObject("brokerRoles",brokerRoles));
                var ccyArray : Array = new Array(1);
                ccyArray[0] = "";
                finContextList.addItem(new HiddenObject("ccy",ccyArray));
                /*
                var cashSecFlag : Array = new Array(1);
                cashSecFlag[0] = "SECURITY";
                finContextList.addItem(new HiddenObject("cashSecFlag",cashSecFlag));
                */
                stlAccForFundContextList.removeAll();
                var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]=this.fundPopUp.fundCode.text;
                stlAccForFundContextList.addItem(new HiddenObject("stlFundCodeContext",cpTypeArray));
                var cpTypeArray1:Array = new Array(1);
                cpTypeArray1[0]=this.fininstPopUp.bankCode.text;
                stlAccForFundContextList.addItem(new HiddenObject("stlBankCodeContext",cpTypeArray1));
                stlAccForFundContextList.addItem(new HiddenObject("ccy",ccyArray));
                //stlAccForFundContextList.addItem(new HiddenObject("cashSecFlag",cashSecFlag));
                ////submit.enabled = true;
                //fininstPopUp.bankCode.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT));
        		//stlAccForFundPopUp.stlAccNo.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT));
            }            
        }else {
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ncm.query.error.prompt.event.null'));
        }
    }
    
    /**
     * If a bank is given, search is done for the bank accounts.
     * If single account is found, populate it.
     * If multiple accounts are present, user has to choose one from the Account popup.
     */
    private function populateBankAccount(event:ResultEvent):void{
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
                       //disableBankAndFinInst();
                       //submit.enabled = false;
           }else {
                 // Clear the error
                errPage.removeError();
                //queryResult = event.result.depositoryAdjustmentActionForm as Object;
                queryResult = rs;
                if(rs.entry.multipleBankAccountPresent==true || rs.entry.pageLoading == true){
                    accountClearState();
                    stlAccForFundPopUp.fundCodeCheck = true;
                }
                
                
                if(rs.entry.multipleBankAccountPresent==false && rs.entry.pageLoading == false){
                    
                    stlAccForFundPopUp.stlAccNo.text = rs.entry.bankAccountNo;
                    //stlAccForFundPopUp.stlAccNo.editable = false;
                    //stlAccForFundPopUp.stlAccPopup.visible = false;
                }
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
                ////submit.enabled = true;
            }            
        }else {
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ncm.query.error.prompt.event.null'));
        }
    }
    
    private function onChangeFundCode(event:Event):void{
		OnDataChangeUtil.onChangeFundCode(fundName,fundPopUp.fundCode.text);
    }
    
    private function onChangeBankCode(event:Event):void{
		OnDataChangeUtil.onChangeBankCode(fininstName,fininstPopUp.bankCode.text);
    }
    
    private function onChangeStlAccNo(event:Event):void{
		OnDataChangeUtil.onChangeAccountNo(stlAccName,stlAccForFundPopUp.stlAccNo.text);
    }
    
    private function onChangeTradingAccountNo(event:Event):void{
		OnDataChangeUtil.onChangeAccountNo(tradindAccName,tradingactPopUp.accountNo.text);
    }
    
    private function onChangeSecurityCode(event:Event):void{
		OnDataChangeUtil.onChangeSecurityCode(securityName,instPopUp.instrumentId.text);
    }
    
    /* ----------------------------------------------------
        Auto populate on focus out has been re-introduced
      -----------------------------------------------------
     private function loadBankAndBankAccount(rs:XML):void{

                if (rs.entry.multipleBankPresent==true) {
                    fininstPopUp.enabled = true;
                    warnMultipleBank.visible = true;
                    warnMultipleBank.includeInLayout = true;
                    warnMultipleBankAcc.visible = false;
                    warnMultipleBankAcc.includeInLayout = false;
                } else if (rs.entry.multipleBankAccountPresent==true) {
                    stlAccForFundPopUp.enabled = true;
                    warnMultipleBank.visible = false;
                    warnMultipleBank.includeInLayout = false;
                    warnMultipleBankAcc.visible = true;
                    warnMultipleBankAcc.includeInLayout = true;
                }
            
                if(rs.entry.multipleBankPresent==true || rs.entry.pageLoading == true){
                    finInstClearState();
                    //accountClearState();
                    fininstPopUp.fundCodeCheck = true;
                    //stlAccForFundPopUp.fundCodeCheck = true;
                    //fininstPopUp.enabled = true;
                }
                
                
                if(rs.entry.multipleBankPresent==false && rs.entry.pageLoading == false){
                    fininstPopUp.bankCode.text = rs.entry.bankCode;
                } 
                
                
                if(rs.entry.multipleBankAccountPresent==true || rs.entry.pageLoading == true){
                    accountClearState();
                    stlAccForFundPopUp.fundCodeCheck = true;
                }
                
                
                if(rs.entry.multipleBankAccountPresent==false && rs.entry.pageLoading == false){
                    stlAccForFundPopUp.stlAccNo.text = rs.entry.bankAccountNo;
                }
                
                finContextList.removeAll();
                //fininstPopUp.bankCode.text = rs.bankCode;
                //actPopUp.accountNo.text = rs.bankAccountNo;
                var fundArray : Array = new Array(1);
                fundArray[0] = fundPopUp.fundCode.text;
                finContextList.addItem(new HiddenObject("fundCodeContext",fundArray));
                var brokerRoles:Array = new Array(1);
                brokerRoles[0]= "Bank/Custodian";
                finContextList.addItem(new HiddenObject("brokerRoles",brokerRoles));
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
                ////submit.enabled = true;
    }
   */
    /*
    private function clearBankAndBankAccount():void {
        if (!(StringUtil.trim(fundPopUp.fundCode.text) == prevFundCode)) {
            finInstClearState();
            accountClearState();
            fininstPopUp.enabled = false;
            stlAccForFundPopUp.enabled = false;
            removeWarnings();
        }
     }
    */ 
    /*
     private function clearBankAccount():void {
        accountClearState();
        //fininstPopUp.enabled = false;
        stlAccForFundPopUp.enabled = false;
        removeWarnings();
     }
    */ 