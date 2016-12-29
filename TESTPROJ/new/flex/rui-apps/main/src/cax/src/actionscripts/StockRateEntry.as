// ActionScript file


import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.cax.validator.StockRateEntryValidator;
import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;
import mx.events.ResourceEvent;
import mx.resources.ResourceBundle;

    [Bindable]
    private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
    private var mode : String = "rateentry";
    [Bindable]
    private var rightsConditionPk : String = "";
    [Bindable]
    private var cashStockSelectionList:ArrayCollection= new ArrayCollection();
    [Bindable]
    private var instrumentPk : String = "";
    [Bindable]
    private var allottedInstrumentPk : String = "";
    [Bindable]
    private var corporateActionId : String = "";
    private var keylist:ArrayCollection = new ArrayCollection();
      
    private function changeCurrentState():void{
        vstack.selectedChild = rslt;
    }
    
    public function loadAll():void{
        parseUrlString();
        super.setXenosEntryControl(new XenosEntry());
        
        this.dispatchEvent(new Event('amendEntryInit'));
        vstack.selectedChild = qry;
    }
    
    /**
     * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
     * 
     */ 
    public function parseUrlString():void {
        try {
            // Remove everything before the question mark, including
            // the question mark.
            var myPattern:RegExp = /.*\?/; 
            var s:String = this.loaderInfo.url.toString();
            //XenosAlert.info("Load Url : "+ this.loaderInfo.url.toString());
            s = s.replace(myPattern, "");
            // Create an Array of name=value Strings.
            var params:Array = s.split(Globals.AND_SIGN); 
            // Print the params that are in the Array.
            var keyStr:String;
            var valueStr:String;
            var paramObj:Object = params;
                  
            // Set the values of the salutation.
            if(params != null) {
                for (var i:int = 0; i < params.length; i++) {
                    var tempA:Array = params[i].split("=");  
                    if (tempA[0] == "mode") {
                        mode = tempA[1];
                    } else if(tempA[0] == "rightsConditionPk") {
                        this.rightsConditionPk = tempA[1];
                    } else if(tempA[0] == "corporateActionId") {
                        this.corporateActionId = tempA[1];
                    }
                }                       
            } else {
                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('cax.failed.to.load.mode'));
            }                 
        } catch (e:Error) {
            trace(e);
        }               
    }
            
    override public function preAmendInit():void {              
        var rndNo:Number= Math.random(); 
        
        if(mode == "rateentry") 
        	super.getInitHttpService().url = "cax/StockRateEntryDispatch.action?";
        else
        	super.getInitHttpService().url = "cax/StockRateCancelDispatch.action?";
        var reqObject:Object = new Object();
        reqObject.rnd = rndNo;
        reqObject.method= "detailViewForStockRateEntry";
        reqObject.rightsConditionPk = this.rightsConditionPk;
        super.getInitHttpService().request = reqObject;
    }
    
    private function addCommonKeys():void {         
        keylist = new ArrayCollection();
        keylist.addItem("conditionRefrenceNo");
        keylist.addItem("subEventTypeDescription");
        keylist.addItem("conditionStatus");
        keylist.addItem("instrumentCode");
        keylist.addItem("instrumentName");
        keylist.addItem("allottedCurrency");
        keylist.addItem("allotedCcyName");
        keylist.addItem("recordDateStr");
        keylist.addItem("exDateStr");
        keylist.addItem("paymentDateStr");
        keylist.addItem("bookClosingDateStr");
        keylist.addItem("allotmentAmountStr");
        keylist.addItem("perShareStr");
        keylist.addItem("splAllotementAmountStr");
        keylist.addItem("allotmentPercentageStr");
        keylist.addItem("faceValueStr");
        keylist.addItem("splAllotmentPercentageStr");
        keylist.addItem("splPerShareStr");
        keylist.addItem("deadLineDateStr");
        keylist.addItem("rightsExpiryDateStr");
        keylist.addItem("announcementDate");
        keylist.addItem("protectExpirationDate");
        keylist.addItem("externalReferenceNo");
        keylist.addItem("instrumentPk");
        keylist.addItem("allottedInstrumentPk");
    }
            
    override public function preAmendResultInit():Object {
        addCommonKeys();
        if(mode == "ratedelete") {
            keylist.addItem("stockRateStr");
        } 
        return keylist;
    }
       
    private function commonInit(mapObj:Object):void {
        conditionRefrenceNo.text = mapObj[keylist.getItemAt(0)].toString();
        subEventTypeDescription.text = mapObj[keylist.getItemAt(1)].toString();
        conditionStatus.text = mapObj[keylist.getItemAt(2)].toString();
        instrumentCode.text = mapObj[keylist.getItemAt(3)].toString();
        instrumentName.text = mapObj[keylist.getItemAt(4)].toString();
        allottedCurrency.text = mapObj[keylist.getItemAt(5)].toString();
        allotedCcyName.text = mapObj[keylist.getItemAt(6)].toString();
        recordDateStr.text = mapObj[keylist.getItemAt(7)].toString();
        exDateStr.text = mapObj[keylist.getItemAt(8)].toString();
        paymentDateStr.text = mapObj[keylist.getItemAt(9)].toString();
        bookClosingDateStr.text = mapObj[keylist.getItemAt(10)].toString();
        allotmentAmountStr.text = mapObj[keylist.getItemAt(11)].toString();
        perShareStr.text = mapObj[keylist.getItemAt(12)].toString();
        splAllotementAmountStr.text = mapObj[keylist.getItemAt(13)].toString();
        allotmentPercentageStr.text = mapObj[keylist.getItemAt(14)].toString();
        faceValueStr.text = mapObj[keylist.getItemAt(15)].toString();
        splAllotmentPercentageStr.text = mapObj[keylist.getItemAt(16)].toString();
        splPerShareStr.text = mapObj[keylist.getItemAt(17)].toString();
        deadLineDateStr.text = mapObj[keylist.getItemAt(18)].toString();
        rightsExpiryDateStr.text = mapObj[keylist.getItemAt(19)].toString();
        announcementDate.text = mapObj[keylist.getItemAt(20)].toString();
        protectExpirationDate.text = mapObj[keylist.getItemAt(21)].toString();
        externalReferenceNo.text = mapObj[keylist.getItemAt(22)].toString();
        instrumentPk = mapObj[keylist.getItemAt(23)].toString();
        allottedInstrumentPk = mapObj[keylist.getItemAt(24)].toString();
        
        if(mode == "rateentry") {
            stockRateEntryStr.text = "";
            stockRateEntryStr.setFocus();
            stockRateEntry.includeInLayout = true;
            stockRateEntry.visible = true;
            stockRateCancel.includeInLayout = false;
            stockRateCancel.visible = false;
            submit.label = this.parentApplication.xResourceManager.getKeyValue('inf.form.button.label.submit');
            
            if(corporateActionId == "OPTIONAL_STOCK_DIV")
                initLabel.text = "Stock Div. Rate Entry";
            else
                initLabel.text = "Re-investment Price Entry";
        } else {
            stockRateCancelStr.text = mapObj[keylist.getItemAt(25)].toString();
            stockRateEntry.includeInLayout = false;
            stockRateEntry.visible = false;
            stockRateCancel.includeInLayout = true;
            stockRateCancel.visible = true;
            submit.label = this.parentApplication.xResourceManager.getKeyValue('inf.form.button.label.delete');
        
            if(corporateActionId == "OPTIONAL_STOCK_DIV")
                initLabel.text = "Stock Div. Rate Cancel";
            else
                initLabel.text = "Re-investment Price Cancel";
        }
        
        if(corporateActionId == "OPTIONAL_STOCK_DIV") {
            stockRateLabel.text = this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.opstockrate');
            stockRateCxlLabel.text = this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.opstockrate');
        } else {
            stockRateLabel.text = this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.drstockrate');
            stockRateCxlLabel.text = this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.drstockrate');
        }
    }
       
    override public function postAmendResultInit(mapObj:Object): void{
        app.submitButtonInstance = submit;
        commonInit(mapObj);
    }
    
    override public function preResetAmend():void {
        var rndNo:Number= Math.random();
        if(mode == "rateentry") {
            super.getResetHttpService().url = "cax/StockRateEntryDispatch.action?method=resetRightsConditionEntry&rnd=" + rndNo;
        } else {
            super.getResetHttpService().url = "cax/StockRateCancelDispatch.action?method=doResetCancelStockPrice&rnd=" + rndNo;
        } 
    }
    
    override public function preAmend():void {
        setValidator();
        if(mode == "rateentry")
            super.getSaveHttpService().url = "cax/StockRateEntryDispatch.action?";
        else
            super.getSaveHttpService().url = "cax/StockRateCancelDispatch.action?";
        super.getSaveHttpService().request = populateRequestParams();
    }
    
    /**
     * This method will populate the request parameters for the
     * submitQuery call and bind the parameters with the HTTPService
     * object.
     */
    private function populateRequestParams():Object {
        var reqObj : Object = new Object();
        
        if(mode == "rateentry") {
            reqObj.method= "submitStockPrice";
            reqObj.stockRateStr = stockRateEntryStr.text;
        } else {
            reqObj.method= "doCancelStockPrice";
            reqObj.stockRateStr = stockRateCancelStr.text;
        }
        
        
        return reqObj;
    }
    
    private function setValidator():void{
        
        var validateModel:Object={
                    stockRateEntry:{
                        stockRate:this.mode == "rateentry" ? this.stockRateEntryStr.text: this.stockRateCancelStr.text,
                        mode:this.mode
                    }
                }; 
        super._validator = new StockRateEntryValidator();
        super._validator.source = validateModel ;
        super._validator.property = "stockRateEntry";
        //super._validator = null;
    }
    
    private function onClickResetButton():void {
        if(mode == "rateentry") {
            stockRateEntryStr.text = "";
        } else {
            this.dispatchEvent(new Event('amendEntryReset'));
        }
    }
    
    private function imgDeleteHandler():void {
        stockRateCancelStr.text = "";
    }
    
    override public function preAmendResultHandler():Object {
        addCommonResultKeys();
        return keylist;
    }
    
    private function addCommonResultKeys():void{
        keylist = new ArrayCollection();
        keylist.addItem("conditionRefrenceNo");
        keylist.addItem("subEventTypeDescription");
        keylist.addItem("conditionStatus");
        keylist.addItem("instrumentCode");
        keylist.addItem("instrumentName");
        keylist.addItem("allottedCurrency");
        keylist.addItem("allotedCcyName");
        keylist.addItem("recordDateStr");
        keylist.addItem("exDateStr");
        keylist.addItem("paymentDateStr");
        keylist.addItem("bookClosingDateStr");
        keylist.addItem("allotmentAmountStr");
        keylist.addItem("perShareStr");
        keylist.addItem("splAllotementAmountStr");
        keylist.addItem("allotmentPercentageStr");
        keylist.addItem("faceValueStr");
        keylist.addItem("splAllotmentPercentageStr");
        keylist.addItem("splPerShareStr");
        keylist.addItem("deadLineDateStr");
        keylist.addItem("rightsExpiryDateStr");
        keylist.addItem("announcementDate");
        keylist.addItem("protectExpirationDate");
        keylist.addItem("externalReferenceNo");
        keylist.addItem("instrumentPk");
        keylist.addItem("allottedInstrumentPk");
        keylist.addItem("stockRateStr");
        keylist.addItem("cashStockSelectionList.cashStockSelectionList");
    }
    
    override public function postAmendResultHandler(mapObj:Object):void {
        commonResult(mapObj);
        app.submitButtonInstance = uConfSubmit;
        if(mode == "rateentry") {
            if(corporateActionId == "OPTIONAL_STOCK_DIV")
                uConfLabel.text = "Stock Div. Rate Entry - User Confirmation";
            else
                uConfLabel.text = "Re-investment Price Entry - User Confirmation";
                
            cashStockSelectionListTable.includeInLayout = true;
            cashStockSelectionListTable.visible = true;
        } else {
            if(corporateActionId == "OPTIONAL_STOCK_DIV")
                uConfLabel.text = "Stock Div. Rate Cancel - User Confirmation";
            else
                uConfLabel.text = "Re-investment Price Cancel - User Confirmation";
                
            cashStockSelectionListTable.includeInLayout = false;
            cashStockSelectionListTable.visible = false;
        }
    }
    
    private function commonResult(mapObj:Object):void{
        //XenosAlert.info("commonResult ");
        if(mapObj!=null){           
            if(mapObj["errorFlag"].toString() == "error") {
                errPage.showError(mapObj["errorMsg"]);
                //result = mapObj["errorMsg"] .toString();
                /*if(mode != "DELETE") {
                    errPage.showError(mapObj["errorMsg"]);                      
                } else {
                    XenosAlert.error(mapObj["errorMsg"] + "Error......");
                }*/
            } else if(mapObj["errorFlag"].toString() == "noError") {
                errPage.clearError(super.getSaveResultEvent());                         
                commonResultPart(mapObj);
                changeCurrentState();
                app.submitButtonInstance = uConfSubmit; 
            } else {
                errPage.removeError();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cax.data.not.found'));
            }           
        }
    }
    
    private function commonResultPart(mapObj:Object):void{
        //XenosAlert.info("Data :: " + mapObj[keylist.getItemAt(0)]);
        uConfConditionRefrenceNo.text = mapObj[keylist.getItemAt(0)].toString();
        uConfSubEventTypeDescription.text = mapObj[keylist.getItemAt(1)].toString();
        uConfConditionStatus.text = mapObj[keylist.getItemAt(2)].toString();
        uConfInstrumentCode.text = mapObj[keylist.getItemAt(3)].toString();
        uConfInstrumentName.text = mapObj[keylist.getItemAt(4)].toString();
        uConfAllottedCurrency.text = mapObj[keylist.getItemAt(5)].toString();
        uConfAllotedCcyName.text = mapObj[keylist.getItemAt(6)].toString();
        uConfRecordDateStr.text = mapObj[keylist.getItemAt(7)].toString();
        uConfExDateStr.text = mapObj[keylist.getItemAt(8)].toString();
        uConfPaymentDateStr.text = mapObj[keylist.getItemAt(9)].toString();
        uConfBookClosingDateStr.text = mapObj[keylist.getItemAt(10)].toString();
        uConfAllotmentAmountStr.text = mapObj[keylist.getItemAt(11)].toString();
        uConfPerShareStr.text = mapObj[keylist.getItemAt(12)].toString();
        uConfSplAllotementAmountStr.text = mapObj[keylist.getItemAt(13)].toString();
        uConfAllotmentPercentageStr.text = mapObj[keylist.getItemAt(14)].toString();
        uConfFaceValueStr.text = mapObj[keylist.getItemAt(15)].toString();
        uConfSplAllotmentPercentageStr.text = mapObj[keylist.getItemAt(16)].toString();
        uConfSplPerShareStr.text = mapObj[keylist.getItemAt(17)].toString();
        uConfDeadLineDateStr.text = mapObj[keylist.getItemAt(18)].toString();
        uConfRightsExpiryDateStr.text = mapObj[keylist.getItemAt(19)].toString();
        uConfAnnouncementDate.text = mapObj[keylist.getItemAt(20)].toString();
        uConfProtectExpirationDate.text = mapObj[keylist.getItemAt(21)].toString();
        uConfExternalReferenceNo.text = mapObj[keylist.getItemAt(22)].toString();
        instrumentPk = mapObj[keylist.getItemAt(23)].toString();
        allottedInstrumentPk = mapObj[keylist.getItemAt(24)].toString();
        uConfStockRateEntryStr.text = mapObj[keylist.getItemAt(25)].toString();
        //XenosAlert.info("**" + mapObj[keylist.getItemAt(25)].toString() + "**" + uConfStockRateEntryStr.text);
        
        if(corporateActionId == "OPTIONAL_STOCK_DIV")
            uConfStockRateLabel.text = this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.opstockrate');
        else
            uConfStockRateLabel.text = this.parentApplication.xResourceManager.getKeyValue('cax.rightscondition.label.drstockrate');
    
        if(mode == "rateentry")
            uConfSubmit.label = this.parentApplication.xResourceManager.getKeyValue('inf.form.button.label.generaterightsdetail');
        else
            uConfSubmit.label = this.parentApplication.xResourceManager.getKeyValue('inf.form.button.label.ok');
        
        if(mode == "rateentry")
            cashStockSelectionList=mapObj[keylist.getItemAt(26)];
    }
    
    override public function doAmendSystemConfirm(e:Event):void {
        //this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    }
    
    private function doBack():void {
        app.submitButtonInstance = submit;
        vstack.selectedChild = qry;
        
        if(this.mode == "rateentry") {
            stockRateEntryStr.setFocus();
        }
    }
    
    override public function preAmendConfirm():void {
        var reqObj :Object = new Object();
        if(mode == "rateentry") {
            super.getConfHttpService().url = "cax/StockRateEntryDispatch.action?";
            reqObj.method= "commitStockPrice";
        } else {
            super.getConfHttpService().url = "cax/StockRateCancelDispatch.action?";
            reqObj.method= "doCommitCancelStockPrice";
        }
        
        super.getConfHttpService().request  =reqObj;
    }
    
    // -----------------------------------
    override public function preConfirmAmendResultHandler():Object {
        keylist = new ArrayCollection();
        keylist.addItem("conditionRefrenceNo");
        
        return keylist;
    }
    
    override public function postConfirmAmendResultHandler(mapObj:Object):void {
        //XenosAlert.info("Outside");
        if(submitUserConfResult(mapObj)) {
            if(mode == "rateentry") {
                if(corporateActionId == "OPTIONAL_STOCK_DIV")
                    sConfLabel.text = "Stock Div. Rate Entry - System Confirmation";
                else
                    sConfLabel.text = "Re-investment Price Entry - System Confirmation";
            } else {
                if(corporateActionId == "OPTIONAL_STOCK_DIV")
                    sConfLabel.text = "Stock Div. Rate Cancel - System Confirmation";
                else
                    sConfLabel.text = "Re-investment Price Cancel - System Confirmation";
            }
            sTxn.includeInLayout = true;
            sTxn.visible = true;
            //XenosAlert.info("Transaction Completed. Reference No ");
            //XenosAlert.info(mapObj[keylist.getItemAt(0)].toString());
            stxnMsg.text = "Transaction Completed. Reference No " + mapObj[keylist.getItemAt(0)].toString();
        }
    }
        
    private function submitUserConfResult(mapObj:Object):Boolean {
        //var mapObj:Object = mkt.userConfResultEvent(event);
        if(mapObj!=null) {    
            //XenosAlert.info("object status : "+mapObj["errorFlag"].toString());       
            if(mapObj["errorFlag"].toString() == "error") {
                XenosAlert.error(mapObj["errorMsg"].toString());
            } else if(mapObj["errorFlag"].toString() == "noError") {
                //if(mode!="DELETE")
                errPage.clearError(super.getConfResultEvent());
                this.back.includeInLayout = false;
                this.back.visible = false;
                uConfSubmit.enabled = true; 
                uConfLabel.includeInLayout = false;
                uConfLabel.visible = false;
                uConfSubmit.includeInLayout = false;
                uConfSubmit.visible = false;
                sConfHBox.includeInLayout = true;
                sConfHBox.visible = true;
                sConfSubmit.includeInLayout = true;
                sConfSubmit.visible = true;
                cashStockSelectionListTable.includeInLayout = false;
                cashStockSelectionListTable.visible = false;
                app.submitButtonInstance = sConfSubmit;
                return true;
            } else {
                errPage.removeError();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred'));
            }           
        }
        return false;
    }       