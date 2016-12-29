
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.utils.DateUtils;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.ncm.NcmConstants;
 import com.nri.rui.ncm.validators.ForexAdjustmentValidator;
 
 import flash.events.Event;
 import flash.events.IEventDispatcher;
 
 import mx.collections.ArrayCollection;
 import mx.events.ResourceEvent;
 import mx.events.ValidationResultEvent;
 import mx.resources.ResourceBundle;
 import mx.rpc.events.ResultEvent;
 
    private var rndNo:Number = 0;
    private var initCompFlag:Boolean = false;
    private var previousFund:String;
    [Bindable]
    private var rs:XML = new XML();
    [Bindable]
    private var confirmResult:Object= new Object();
    [Bindable]
    public var returnInFinContext:ArrayCollection = new ArrayCollection();
    [Bindable]
    public var returnOutFinContext:ArrayCollection = new ArrayCollection();
    [Bindable]
    public var returnInContextItem:ArrayCollection = new ArrayCollection();
    [Bindable]
    public var returnOutContextItem:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var inFinContextList:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var outFinContextList:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var inStlAccForFundContextList:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var outStlAccForFundContextList:ArrayCollection = new ArrayCollection();
 
    /**
     * This is called at creationComplete of the module.
     */
    private function loadAll():void {

    }
    
    /**
     * This method will be called at the time of the loading Forex Adjustment Entry
     * and pressing the reset button.
     */
    private function initPageStart():void {
        if (!initCompFlag) {
            rndNo = Math.random();
            var req : Object = new Object();
            req.SCREEN_KEY = 11069;
            initForexAdjustmentEntry.request = req;           
            initForexAdjustmentEntry.url = "ncm/forexAdjustmentDispatchAction.action?method=initEntry&rnd=" + rndNo;
            initForexAdjustmentEntry.send();
        } else {
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.initiate'));
        }
    }
    
    /**
     * This method works as the result handler of the Initialization/Reset Http Services.
     */
    private function initPage(event:ResultEvent):void {
        
        var i:int = 0;
        var dateStr:String = null;
        var initColl:ArrayCollection = new ArrayCollection();
        var tempColl:ArrayCollection;
        
        //clears the errors if any
        errPage.clearError(event);
        //initiate text fields
        fundPopUp.fundCode.text = "";
        inCcyBox.ccyText.text = "";
        outCcyBox.ccyText.text = "";
        inAmount.text = "";
        outAmount.text = "";
        inFinInstPopUp.bankCode.text = "";
        outFinInstPopUp.bankCode.text = "";
        inStlAccForFundPopUp.stlAccNo.text = "";
        outStlAccForFundPopUp.stlAccNo.text = "";
        adjustmentdate.text = "";
        adjustmentdate.selectedDate = null;
        remarks.text = "";
        fundPopUp.fundCode.setFocus();
        
        if (event.result == null || event.result.forexAdjustmentActionForm == null) {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ncm.query.error.prompt.initialization.fail'));
        }
        //1. Setting value for Adjustment Date
        if (event.result.forexAdjustmentActionForm.adjustmentDateStr != null) {
            dateStr = event.result.forexAdjustmentActionForm.adjustmentDateStr;
            if (dateStr != null) {
                adjustmentdate.selectedDate = DateUtils.toDate(dateStr);
                adjustmentdate.text = dateStr; 
            }
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ncm.query.error.prompt.adjdate'));
        }
        //2. Setting values of the Gle Ledger Code List
        if (event.result.forexAdjustmentActionForm.gleLedgerCodeList.item != null) {
            if (event.result.forexAdjustmentActionForm.gleLedgerCodeList.item is ArrayCollection) {
                initColl = event.result.forexAdjustmentActionForm.gleLedgerCodeList.item as ArrayCollection;
            } else {
                initColl.addItem(event.result.forexAdjustmentActionForm.gleLedgerCodeList.item);
            }
        }
        tempColl = new ArrayCollection();
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        gleledger.dataProvider = tempColl;
        //3. Setting values of the Adjustment Reason
        initColl.removeAll();
        if(event.result.forexAdjustmentActionForm.reasonCodeList.item != null) {
            if(event.result.forexAdjustmentActionForm.reasonCodeList.item is ArrayCollection)
                initColl = event.result.forexAdjustmentActionForm.reasonCodeList.item as ArrayCollection;
            else
                initColl.addItem(event.result.forexAdjustmentActionForm.reasonCodeList.item);
        }
        tempColl = new ArrayCollection();
        //tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        adjustmentreason.dataProvider = tempColl;
        
        currentState = '';
        initCompFlag = true;
        inputFundHandler();
    }
    
    /**
     * This is the focusOut handler of the Fund Code.
     */
    private function inputFundHandler():void {
        var fundStr:String = fundPopUp.fundCode.text;
        if (XenosStringUtils.isBlank(fundStr) || !XenosStringUtils.equals(previousFund, fundStr)) {
            previousState(false);
        }
        previousFund = fundStr;
    }
    
    /** 
     * This is the focusOut handler of the Ccy.
     */
    private function inputCcyHandler(inOutFlg:String):void {
        var ccyStr:String;
        if(XenosStringUtils.equals(inOutFlg, NcmConstants.IN)) {
            ccyStr = inCcyBox.ccyText.text;
        } else {
            ccyStr = outCcyBox.ccyText.text;
        }
        var fundStr:String = fundPopUp.fundCode.text;
        if(!XenosStringUtils.isBlank(fundStr) && !XenosStringUtils.isBlank(ccyStr)) {
            var req :Object = new Object();
            req['fundCode'] = fundStr;
            if(XenosStringUtils.equals(inOutFlg, NcmConstants.IN)) {
                req['inCurrency'] = ccyStr;
                req['inOut'] = NcmConstants.IN;
            } else {
                req['outCurrency'] = ccyStr;
                req['inOut'] = NcmConstants.OUT;
            }
            loadBankAndBankAccountForFund.request = req;
            loadBankAndBankAccountForFund.send();
        } else {
            // Remove the Fund code should remove Bank Code and Bank Account No
            finInstClearState(inOutFlg);
            accountClearState(inOutFlg);
        }
    }

    /** 
     * This method will populate Bank and Bank Account No once a Fund Code and Ccy is chosen.
     * If multiple Banks are associated with the fundCode, then user has to select one from
     * the bank popup correspoding the Fund Code. 
     * If a single bank is associated with the Fund and Ccy, the bank is auto populated.
     * If it has a single account, account is auto populated.
     * If multiple accounts are present, user has to choose one from the Account popup.
     */
    private function populateBankAndBankAccount(event:ResultEvent):void{
        rs = XML(event.result);
        
        if (null != event) {
            if(rs.child("Errors").length() > 0){
                //Must be error, display it
                var errorInfoList : ArrayCollection = new ArrayCollection();
                //Populate the error info list              
                for each ( var error:XML in rs.Errors.error ) {
                    errorInfoList.addItem(error.toString());
                }
                //Display the error
                errPage.showError(errorInfoList);
            } else {
                //Clear the error
                errPage.removeError();
                if(rs.multipleBankPresent == true || rs.pageLoading == true) {
                    finInstClearState(rs.inOut);
                }
                if(rs.multipleBankPresent == false && rs.pageLoading == false) {
                    if (XenosStringUtils.equals(rs.inOut, NcmConstants.IN)) {
                        inFinInstPopUp.bankCode.text = rs.inBankCode;
                    } else {
                        outFinInstPopUp.bankCode.text = rs.outBankCode;
                    }
                } 
                if(rs.multipleBankAccountPresent == true || rs.pageLoading == true) {
                    accountClearState(rs.inOut);
                }
                if(rs.multipleBankAccountPresent == false && rs.pageLoading == false) {
                    if (XenosStringUtils.equals(rs.inOut, NcmConstants.IN)) {
                        inStlAccForFundPopUp.stlAccNo.text = rs.inAccountNo;
                    } else {
                        outStlAccForFundPopUp.stlAccNo.text = rs.outAccountNo;
                    }
                }
                var fundArray:Array = new Array(1);
                fundArray[0] = fundPopUp.fundCode.text;
                var brokerRoles:Array = new Array(1);
                brokerRoles[0] = "Bank/Custodian";
                var ccyArray:Array = new Array(1);
                var cpTypeArray1:Array = new Array(1);
                if (XenosStringUtils.equals(rs.inOut, NcmConstants.IN)) {
                    inFinContextList.removeAll();
                    inFinContextList.addItem(new HiddenObject("fundCodeContext", fundArray));
                    inFinContextList.addItem(new HiddenObject("brokerRoles", brokerRoles));
                    ccyArray[0] = inCcyBox.ccyText.text;
                    inFinContextList.addItem(new HiddenObject("ccy", ccyArray));
                    inStlAccForFundContextList.removeAll();
                    inStlAccForFundContextList.addItem(new HiddenObject("stlFundCodeContext", fundArray));
                    cpTypeArray1[0] = inFinInstPopUp.bankCode.text;
                    inStlAccForFundContextList.addItem(new HiddenObject("stlBankCodeContext", cpTypeArray1));
                    inStlAccForFundContextList.addItem(new HiddenObject("ccy", ccyArray));
                } else {
                    outFinContextList.removeAll();
                    outFinContextList.addItem(new HiddenObject("fundCodeContext", fundArray));
                    outFinContextList.addItem(new HiddenObject("brokerRoles", brokerRoles));
                    ccyArray[0] = outCcyBox.ccyText.text;
                    outFinContextList.addItem(new HiddenObject("ccy", ccyArray));
                    outStlAccForFundContextList.removeAll();
                    outStlAccForFundContextList.addItem(new HiddenObject("stlFundCodeContext", fundArray));
                    cpTypeArray1[0] = outFinInstPopUp.bankCode.text;
                    outStlAccForFundContextList.addItem(new HiddenObject("stlBankCodeContext", cpTypeArray1));
                    outStlAccForFundContextList.addItem(new HiddenObject("ccy", ccyArray));
                }
            }            
        } else {
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ncm.query.error.prompt.event.null'));
        }
    }
    
    /**
     * This is the focus out handler of the Bank Code
     */
    private function bankOutHandler(inOutFlg:String):void{
        var bankCode:String;
        var ccyStr:String;
        if (XenosStringUtils.equals(inOutFlg, NcmConstants.IN)) {
            bankCode = inFinInstPopUp.bankCode.text;
            ccyStr = inCcyBox.ccyText.text;
        } else {
            bankCode = outFinInstPopUp.bankCode.text;
            ccyStr = outCcyBox.ccyText.text;
        }
        if(!XenosStringUtils.isBlank(bankCode) && !XenosStringUtils.isBlank(ccyStr)){
            var req:Object = new Object();
            req['fundCode'] = fundPopUp.fundCode.text;
            if (XenosStringUtils.equals(inOutFlg, NcmConstants.IN)) {
                req['inBankCode'] = bankCode;
                req['inCurrency'] = ccyStr;
                req['inOut'] = NcmConstants.IN;
            } else {
                req['outBankCode'] = bankCode;
                req['outCurrency'] = ccyStr;
                req['inOut'] = NcmConstants.OUT;
            }
            loadBankAccount.request = req;
            loadBankAccount.send();
        } else {
            //Remove the Bank code should remove Bank Account No
            accountClearState(inOutFlg);
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
                //Must be error, display it
                var errorInfoList : ArrayCollection = new ArrayCollection();
                //Populate the error info list              
                for each ( var error:XML in rs.Errors.error ) {
                    errorInfoList.addItem(error.toString());
                }
                //Display the error
                errPage.showError(errorInfoList);
            } else {
                // Clear the error
                errPage.removeError();
                if(rs.multipleBankAccountPresent == true || rs.pageLoading == true){
                    accountClearState(rs.inOut);
                }
                if(rs.multipleBankAccountPresent == false && rs.pageLoading == false){
                    if (XenosStringUtils.equals(rs.inOut, NcmConstants.IN)) {
                        inStlAccForFundPopUp.stlAccNo.text = rs.inAccountNo;
                    } else {
                        outStlAccForFundPopUp.stlAccNo.text = rs.outAccountNo;
                    }
                }
                var cpTypeArray:Array = new Array(1);
                cpTypeArray[0] = this.fundPopUp.fundCode.text;
                var cpTypeArray1:Array = new Array(1);
                var ccyArray : Array = new Array(1);
                if (XenosStringUtils.equals(rs.inOut, NcmConstants.IN)) {
                    inStlAccForFundContextList.removeAll();
                    inStlAccForFundContextList.addItem(new HiddenObject("stlFundCodeContext",cpTypeArray));
                    cpTypeArray1[0] = inFinInstPopUp.bankCode.text;
                    inStlAccForFundContextList.addItem(new HiddenObject("stlBankCodeContext",cpTypeArray1));  
                    ccyArray[0] = inCcyBox.ccyText.text;
                    inStlAccForFundContextList.addItem(new HiddenObject("ccy",ccyArray));
                } else {
                    outStlAccForFundContextList.removeAll();
                    outStlAccForFundContextList.addItem(new HiddenObject("stlFundCodeContext",cpTypeArray));
                    cpTypeArray1[0] = outFinInstPopUp.bankCode.text;
                    outStlAccForFundContextList.addItem(new HiddenObject("stlBankCodeContext",cpTypeArray1));  
                    ccyArray[0] = outCcyBox.ccyText.text;
                    outStlAccForFundContextList.addItem(new HiddenObject("ccy",ccyArray));
                }
            }            
        } else {
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ncm.query.error.prompt.event.null'));
        }
    }
    
    /**
     * This will clear the Bank Code Control.
     */
    private function finInstClearState(inOut:String):void {
        if (XenosStringUtils.equals(inOut, NcmConstants.IN)) {
            inFinInstPopUp.bankCode.text = "";
            populateFinContext(NcmConstants.IN);
        } else {
            outFinInstPopUp.bankCode.text = "";
            populateFinContext(NcmConstants.OUT);
        }
    }
    
    /**
     * This will clear the Account No Control.
     */
    private function accountClearState(inOut:String):void {
        if (XenosStringUtils.equals(inOut, NcmConstants.IN)) {
            inStlAccForFundPopUp.stlAccNo.text = "";
            populateStlAcctContext(NcmConstants.IN);
        } else {
            outStlAccForFundPopUp.stlAccNo.text = "";
            populateStlAcctContext(NcmConstants.OUT);
        }
    }

    /**
     * Formatter for the Amount.
     */
    private function amountHandler(inOut:String):void {
        var vResult:ValidationResultEvent;
        if (XenosStringUtils.equals(inOut, NcmConstants.IN)) {
            vResult = inNumberValidator.validate();
        } else {
            vResult = outNumberValidator.validate();
        }
        if (vResult.type == ValidationResultEvent.VALID) {
            if (XenosStringUtils.equals(inOut, NcmConstants.IN)) {
                inAmount.text = numberFormatter.format(inAmount.text);
            } else {
                outAmount.text = numberFormatter.format(outAmount.text);
            }       
        } 
    }
    
    /**
     * It Submits the entry form. 
     */
    private function doSubmit():void {
        //Set the request parameters
        var requestObj:Object = populateRequestParams();
        forexAdjustmentEntryConfirm.request = requestObj;
        var validatorModel:Object = { forexAdjustment : {
                                    fundCode : this.fundPopUp.fundCode.text,
                                    inCcy    : this.inCcyBox.ccyText.text,
                                    outCcy   : this.outCcyBox.ccyText.text,
                                    inAmount : this.inAmount.text,
                                    outAmount: this.outAmount.text,
                                    inBank   : this.inFinInstPopUp.bankCode.text,
                                    outBank  : this.outFinInstPopUp.bankCode.text,
                                    inAccountNo : this.inStlAccForFundPopUp.stlAccNo.text,
                                    outAccountNo : this.outStlAccForFundPopUp.stlAccNo.text,
                                    adjustmentDate : this.adjustmentdate.text,
                                    inNumValidator : inNumberValidator,
                                    outNumValidator : outNumberValidator
                                }
                            };
        var forexValidator:ForexAdjustmentValidator = new ForexAdjustmentValidator();
        forexValidator.source = validatorModel;
        forexValidator.property = "forexAdjustment";
        var validationResult:ValidationResultEvent = forexValidator.validate();

        if(validationResult.type==ValidationResultEvent.INVALID) {
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
        } else {
            rndNo= Math.random(); 
            forexAdjustmentEntryConfirm.url = forexAdjustmentEntryConfirm.url + "&rnd=" + rndNo;
            forexAdjustmentEntryConfirm.send();
        }
    }
     
    /**
     * This method will populate the request parameters for the doSubmit
     * call and bind the parameters with the HTTPService object.
     */
    private function populateRequestParams():Object {
        var reqObj:Object = new Object();
        reqObj.SCREEN_KEY = 11070;
        reqObj['fundCode'] = this.fundPopUp.fundCode.text;
        reqObj['inCurrency'] = this.inCcyBox.ccyText.text;
        reqObj['outCurrency'] = this.outCcyBox.ccyText.text;
        reqObj['inAmountStr'] = this.inAmount.text;
        reqObj['outAmountStr'] = this.outAmount.text;
        reqObj['inBankCode'] = this.inFinInstPopUp.bankCode.text;
        reqObj['outBankCode'] = this.outFinInstPopUp.bankCode.text;
        reqObj['inAccountNo'] = this.inStlAccForFundPopUp.stlAccNo.text;
        reqObj['outAccountNo'] = this.outStlAccForFundPopUp.stlAccNo.text;
        reqObj['adjustmentDateStr'] = this.adjustmentdate.text;
        reqObj['gleLedgerCode'] = this.gleledger.selectedItem.value;
        reqObj['adjustmentReason'] = this.adjustmentreason.selectedItem != null ?  this.adjustmentreason.selectedItem.value : "" ;
        reqObj['remarks'] = this.remarks.text;
        
        return reqObj;
    }
    
    /**
     * This method is the resultHandler for confirm action. This is required for the 
     * User Confirmation Screen to show the values in non editable form.
     */
    private function validateResult(event:ResultEvent):void {
        rs = XML(event.result);
        if (null != event) {
            if(rs.child("Errors").length() > 0) {
                //Must be error, display it
                var errorInfoList : ArrayCollection = new ArrayCollection();
                //Populate the error info list              
                for each ( var error:XML in rs.Errors.error ) {
                    errorInfoList.addItem(error.toString());
                }
                //Display the error
                errPage.showError(errorInfoList);
            } else {
                errPage.removeError();
                if(errPage1 != null) {
                    errPage1.removeError();
                }
                confirmResult = rs;
                forexAdjEntry.selectedChild = forexAdjustConfirm;
            }
        } else {
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ncm.query.error.prompt.event.null'));
        }
    }
    
    /**
     * Sending the http service for SAVE operation.
     */
    private function doSave(event:Event):void {
        ok.enabled=false;
        var req : Object = new Object();
        req.SCREEN_KEY = 11071;
        forexAdjustmentSystemConfirm.request = req;  
        forexAdjustmentSystemConfirm.url = "ncm/forexAdjustmentDispatchAction.action?method=doSave&unique="+new Date().getTime();
        forexAdjustmentSystemConfirm.send();         
    }
    
    /**
     * This method is the resultHandler for confirm action. This is required for the
     * User Confirmation Screen to show the values in non editable form.
     */
    private function validateConfirmResult(event:ResultEvent):void {
        ok.enabled=true;
        rs = XML(event.result);
        if (null != event) {
            if(rs.child("Errors").length() > 0) {
                //Must be error, display it
                var errorInfoList : ArrayCollection = new ArrayCollection();
                //Populate the error info list              
                for each ( var error:XML in rs.Errors.error ) {
                    errorInfoList.addItem(error.toString());
                }
                //Display the error
                errPage1.showError(errorInfoList);
            } else {
                //Clear the error
                errPage1.removeError();
                confirmResult = rs;
                if(XenosStringUtils.isBlank(rs.inEntryPage.referenceNo.toString()) &&
                                    XenosStringUtils.isBlank(rs.outEntryPage.referenceNo.toString())) {
                    changeToConfirmState(false);
                }else{
                    changeToConfirmState(true);
                }
            }   
        } else {
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ncm.query.error.prompt.event.null'));
        }
    }

    /** 
     * This will determine whether the transaction Number should be shown
     * with OK button or it will be the User Confirmation page.
     */
    private function changeToConfirmState(showRefNo:Boolean):void {
        if(showRefNo){
            //Show the Reference Number
            currentState = "confirm"; 
        }
    }
    
    /**
     * Sends back to entry page.
     */
    private function previousState(back:Boolean):void {
        if(!back){
            finInstClearState(NcmConstants.IN);
            finInstClearState(NcmConstants.OUT);
            accountClearState(NcmConstants.IN);
            accountClearState(NcmConstants.OUT);
        }
        forexAdjEntry.selectedChild = forexAdjustEntry;
    }
    
    /**
     * This method sends the HttpService for reset operation.
     */
    private function resetEntry():void {
        initCompFlag = false;
        initPageStart();
    }
    
    /**
     * This is the method to pass the Collection of data
     * items through the context to the bank popup.
     */
    private function populateFinContext(inOut:String):void {
        //pass the context data to the popup
        var fundCode:Array = new Array(1);
        fundCode[0] = fundPopUp.fundCode.text;
        var brokerRoles:Array = new Array(1);
        brokerRoles[0]= "Bank/Custodian";
        if (XenosStringUtils.equals(inOut, NcmConstants.IN)) {
            inFinContextList.removeAll();
            inFinContextList.addItem(new HiddenObject("stlFundCodeContext",fundCode));
            inFinContextList.addItem(new HiddenObject("brokerRoles", brokerRoles));
        } else {
            outFinContextList.removeAll();
            outFinContextList.addItem(new HiddenObject("stlFundCodeContext",fundCode));
            outFinContextList.addItem(new HiddenObject("brokerRoles", brokerRoles));
        }
    }
    
    /**
     * This is the method to pass the Collection of data
     * items through the context to the account popup.
     */
    private function populateStlAcctContext(inOut:String):void {
        //pass the context data to the popup
        var fundCode:Array = new Array(1);
        fundCode[0] = fundPopUp.fundCode.text;
        var ccyArray:Array = new Array(1);
        if (XenosStringUtils.equals(inOut, NcmConstants.IN)) {
            inStlAccForFundContextList.removeAll();
            inStlAccForFundContextList.addItem(new HiddenObject("stlFundCodeContext",fundCode));
            ccyArray[0] = inCcyBox.ccyText.text;
            inStlAccForFundContextList.addItem(new HiddenObject("ccy",ccyArray));
        } else {
            outStlAccForFundContextList.removeAll();
            outStlAccForFundContextList.addItem(new HiddenObject("stlFundCodeContext",fundCode));
            ccyArray[0] = outCcyBox.ccyText.text;
            outStlAccForFundContextList.addItem(new HiddenObject("ccy",ccyArray));
        }
    }
    