





    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    
    import mx.collections.ArrayCollection;
    import mx.rpc.events.ResultEvent;
    
    [Bindable]private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]private var queryResult:XML = new XML();
    [Bindable]private var reasonCodeList:ArrayCollection = new ArrayCollection();
    private var initCompFlg : Boolean = false;
    [Bindable]public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    
    //Items returning through context - Non display objects for accountPopup
    [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
    public var obj:Object = {};
    
    [Bindable]public var index:int;
    [Bindable]public var stlInfoPk:String = "";
    [Bindable]public var reasonCodeResult:ArrayCollection = new ArrayCollection;
    [Bindable]public var mode:String = "";
    [Bindable]private var completionArray:Array = null;
    [Bindable]private var stlInfoPkArray:Array = null;
    [Bindable]private var arrayLength:int;
    [Bindable]private var completionType:String = "";
    [Bindable]private var settleDate: String = "";
    [Bindable]public var settlementInfoPkArr:Array = new Array();
            
    public function parseUrlString():void {
        try {
            // Remove everything before the question mark, including
            // the question mark.
            var myPattern:RegExp = /.*\?/; 
            var urlStr:String = this.loaderInfo.url.toString();
            urlStr = urlStr.replace(myPattern, "");
            // Create an Array of name=value Strings.
            var params:Array = urlStr.split("&"); 
             // Print the params that are in the Array.
            var keyStr:String;
            var valueStr:String;
            var paramObj:Object = params;
          
            // Set the values of the salutation.
            for (var i:int = 0; i < params.length; i++) {
                var tempA:Array = params[i].split("=");  
                if (tempA[0] == "index") {
                    obj.index = tempA[1];
                    index = obj.index;
                }
                if (tempA[0] == "stlInfoPk") {
                    obj.stlInfoPk = tempA[1];
                    stlInfoPk = obj.stlInfoPk;
                }                                 
                if (tempA[0] == "arrayLength") {
                    obj.arrayLength = tempA[1];
                    arrayLength = obj.arrayLength;
                }                                 
                if (tempA[0] == "completionArray") {
                    completionArray = new Array(arrayLength);
                    obj.completionArray = (tempA[1] as String).split(",");
                    completionArray = obj.completionArray;
                }
                if (tempA[0] == "completionType") {
                    obj.completionType = tempA[1];
                    completionType = obj.completionType;
                }                                 
            }             
        } catch (e:Error) {
            trace(e);
        }       
    }

    /**
     * This public method fires when this page is loading. There need to load this
     * page from database value and thus need to send server side request
     */     
    public function submitQueryResult():void {
        
        parseUrlString();
        mode = this.parentDocument.owner.mode;
        var requestObj :Object = new Object();
        requestObj.selectedIndex = index;
        requestObj.stlInfoPk = stlInfoPk;
        requestObj.compType = completionType;
        
        for(var x:int=0; x < this.parentDocument.owner.queryResult.length; x++ ) {
            //trace("### "+this.parentDocument.owner.queryResult[x].settlementInfoPk);
            settlementInfoPkArr.push(this.parentDocument.owner.queryResult[x].settlementInfoPk);
        }
        
        requestObj.stlInfoPkArray = settlementInfoPkArr;
        requestObj.completionTypeArray = completionArray;        
        
        if(mode == "DELETE") {
            stlDetailPageRequest.url = "stl/stlCompletionDetailsCancel.action?method=detailPage&&index=" + index;
            stlDetailPageRequest.request = requestObj; 
            stlDetailPageRequest.method = "POST";
            stlDetailPageRequest.send();
            currentState = "remarksEntry";
        } else if(mode == "ADD" || mode == "CAX_RECEIVE_NOTICE") {
            if(mode == "CAX_RECEIVE_NOTICE") {
                stlDetailPageRequest.url = "stl/stlCompletionDetailsCAReceiveNotice.action?method=detailPage&&index=" + index;
            }else{
                stlDetailPageRequest.url = "stl/stlCompletionDetails.action?method=detailPage&&index=" + index;
            }
            stlDetailPageRequest.request = requestObj; 
            stlDetailPageRequest.method = "POST";
            stlDetailPageRequest.send();
            currentState = "completionEntry";
            settleDate = this.parentDocument.owner.queryResult[index].stlDateStr;
        }
        
        PopUpManager.centerPopUp(this);
    }

    public function closeRemarkPopup():void {
        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    }
    
    public function okRemarkPopup():void {
        var reqObj : Object = new Object();
        
        if(mode == "DELETE") {
            reqObj['selectedCompletionDetails.remarks1'] = this.remarks1.text;
            reqObj['selectedCompletionDetails.remarks2'] = this.remarks2.text;
            submitDetailInfoRequest.url="stl/stlCompletionDetailsCancel.action?method=submitDetailInfo"
            submitDetailInfoRequest.request = reqObj;
            submitDetailInfoRequest.method = "POST";
            submitDetailInfoRequest.send();
            
            var remarksIndex:int = -1;
            for(var y:int=0; y < this.parentDocument.owner.queryResult.length; y++) {
                if(this.parentDocument.owner.queryResult[y].settlementInfoPk == stlInfoPk) {
                    remarksIndex = y;
                    break;
                }
            }
            this.parentDocument.owner.queryResult[remarksIndex].remarks1 = this.remarks1.text;
            this.parentDocument.owner.queryResult[remarksIndex].remarks2 = this.remarks2.text;
            this.parentDocument.owner.queryResult[index].reasonCode = getReasonCode();
            this.parentDocument.owner.queryResult.refresh();
        } else if(mode == "ADD" || mode=="CAX_RECEIVE_NOTICE") {
            reqObj['selectedCompletionDetails.remarks1'] = this.remarks1Ent.text;
            reqObj['selectedCompletionDetails.remarks2'] = this.remarks2Ent.text;
            reqObj['selectedCompletionDetails.narrative'] = this.narrativeEnt.text;
            reqObj['selectedCompletionDetails.totalEligibleStr'] = this.eligibleBalance.text;
            reqObj['selectedCompletionDetails.taxAmountStr'] = this.taxAmount.text;
            
            if (!validateAmountQuantity()) {
                return;
            }
            if (completionType == "PARTIAL" || completionType == "PARTIAL_QUASI_COMPLETE") {
                reqObj['selectedCompletionDetails.completeAmountStr'] = this.completeAmountPartial.text;
            } else if (completionType == 'COMPLETE') {
                reqObj['selectedCompletionDetails.completeAmountStr'] = this.completeAmountComplete.text;
            }
            reqObj['selectedCompletionDetails.completeQuantityStr'] = this.completionQuantity.text;
            
            if(mode == "CAX_RECEIVE_NOTICE") {
                submitDetailInfoRequest.url="stl/stlCompletionDetailsCAReceiveNotice.action?method=submitDetailInfo"                
            }else{
                submitDetailInfoRequest.url="stl/stlCompletionDetails.action?method=submitDetailInfo"    
            }            
            submitDetailInfoRequest.request = reqObj;
            submitDetailInfoRequest.method = "POST";
            submitDetailInfoRequest.send();            
        }
    }            

    private function validateAmountQuantity():Boolean {
        var alertMsg : String = "";
        
        if (queryResult.selectedCompletionDetails.cashSidePresent == true) {
            var completeAmt:String = "";
            if (completionType == "PARTIAL") {
                completeAmt = completeAmountPartial.text;
            } else if (completionType == "COMPLETE") {
                completeAmt = completeAmountComplete.text;
            }
            if (completeAmt == "") {
                alertMsg = alertMsg + "\n"+this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.detailsentry.enter.valid.amount');
            }
            if (queryResult.selectedCompletionDetails.partialCompletionEligible == 'Y' && mode != "CAX_RECEIVE_NOTICE") {
                if (eligibleBalance.text == "") {
                 alertMsg = alertMsg+"\n"+this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.detailsentry.specify.eligiblebalance');
                }
                if (taxAmount.text == "") {
                 alertMsg = alertMsg+"\n"+this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.detailsentry.enter.taxamount');
                }
            }
        }
        if (alertMsg == "") {
            if (completionType == "COMPLETE") {
                var completionAmt:Number = changeStringToNum(this.completeAmountComplete.text);
                var outStandingAmt:Number = Math.abs(changeStringToNum(queryResult.selectedCompletionView.outstandingAmountStr));
                if (completionAmt != outStandingAmt) {
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.detailsentry.warning.amount.specified'));
                }
            }
            
        }
        if (queryResult.selectedCompletionDetails.securitySidePresent == true) {
            if (this.completionQuantity.text == "") {
                alertMsg = alertMsg + "\n"+this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.detailsentry.enter.valid.quantity');
            }
        }
        if (alertMsg != "") {
            XenosAlert.error(alertMsg);
            return false;
        }
        return true;      
    }
    
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    public function loadResultPage(event:ResultEvent):void {
        if (mode == "DELETE") {
            errPageCompRemarks.removeError();
        } else if (mode == "ADD" || mode == "CAX_RECEIVE_NOTICE") {
            errPageCompEntry.removeError();
        }        
        
        if (null != event) {            
            if(null == event.result){
                if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                } else { // Must be error
                    if (mode == "DELETE") {
                        errPageCompRemarks.displayError(event);
                    } else if (mode == "ADD" || mode == "CAX_RECEIVE_NOTICE") {
                        errPageCompEntry.displayError(event);
                    }
                }               
            } else {                
                queryResult = XML(event.result);
                
                reasonCodeList.addItem({label:" ", value: " "});
                for each (var item:XML in queryResult.reasonCodeList.item) {
                    reasonCodeList.addItem(item);
                }
                
                if (mode == "CAX_RECEIVE_NOTICE") {
                    eligibleBalance.includeInLayout = false;
                    eligibleBalance.visible = false;
                    taxAmount.includeInLayout = false;
                    taxAmount.visible = false;
                    lblEligibleBalance.includeInLayout = true;
                    lblEligibleBalance.visible = true;
                    lblTaxAmount.includeInLayout = true;
                    lblTaxAmount.visible = true;                    
                }
            } 
        } else {
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }
    }
   
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    public function submitDetailPage(event:ResultEvent):void {
        if (null != event) { 
            if(null == event.result){
                this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));        
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                if(null == event.result.XenosErrors){ 
                    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));        
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                } else {
                    if (mode == "ADD" || mode =="CAX_RECEIVE_NOTICE") {
                          errPageCompEntry.displayError(event);
                    } else {
                        errPageCompRemarks.displayError(event);
                    }
                }               
            } else {    
                var queryResult1:XML = XML(event.result);
                var arr:ArrayCollection = new ArrayCollection;
                if(queryResult1.child("Errors").length() > 0){                     
                    for each (var error:Object in queryResult1.Errors.error) {
                        arr.addItem(error);
                    }
                    if (mode == "ADD" || mode == "CAX_RECEIVE_NOTICE") {
                        errPageCompEntry.showError(arr);
                    } else {
                        errPageCompRemarks.showError(arr);
                    }
                } else {
                    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE)); 
                }               
            } 
        } else {
            this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));        
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }
    }

    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    public function setParentData(event:ResultEvent):void {
        //var xmlData:XML = new XML();
        if (null != event) {            
            if(null == event.result){
                //queryResult.removeAll(); // clear previous data if any as there is no result now.
                if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
                  //  errPage.clearError(event); //clears the errors if any
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                } else { // Must be error
                    //errPage.displayError(event);  
                }               
            } else {                
                //queryResult = XML(event.result);
            } 
        } else {
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }
    }
   
    private function addReasonCode():void {
        
        var reasonCode:String = ""; 
        var narrative:String = ""; 
        if (mode == "ADD" || mode == "CAX_RECEIVE_NOTICE") {
            if (this.reasonCodeEnt.selectedItem == null || this.reasonCodeEnt.selectedItem.value == " ") {
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.detailsentry.select.reasoncode'));
                return;
            }
            reasonCode = this.reasonCodeEnt.selectedItem.value;
            narrative = this.narrativeEnt.text;
        } else if (mode == "DELETE") {
            if (this.reasonCode.selectedItem == null || this.reasonCode.selectedItem.value == " ") {
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.detailsentry.select.reasoncode'));
                return;
            }
            reasonCode = this.reasonCode.selectedItem.value;
        }
        
        var reqObj:Object = new Object;
        var obj:Object = new Object();
        obj['reasonCode'] = reasonCode;
        obj['narrative'] = narrative;
        obj['rowNo'] = 0;
        if (mode == "ADD" || mode == "CAX_RECEIVE_NOTICE") {
            if (reasonCodeResult.contains(obj)) {
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.detailsentry.reasoncode.already.exists'));
                return;            
            }
            if(mode == "CAX_RECEIVE_NOTICE") {
                addReasonCodeService.url = "stl/stlCompletionDetailsCAReceiveNotice.action?method=addReason";                
            }else{
                addReasonCodeService.url = "stl/stlCompletionDetails.action?method=addReason";    
            }
            
            reqObj['selectedCompletionDetails.narrative'] = narrative;
        } else if (mode == "DELETE") {
            addReasonCodeService.url = "stl/stlCompletionDetailsCancel.action?method=addReason";
            reasonCodeResult.removeAll();
        }
        reasonCodeResult.addItem(obj);
        reqObj['selectedCompletionDetails.reasonCode'] = reasonCode;
        addReasonCodeService.request = reqObj;
        addReasonCodeService.send();
        this.narrativeEnt.text = "";
        this.reasonCode.selectedIndex = 0;
        this.reasonCodeEnt.selectedIndex = 0;
    }
    
    public function deleteReasonCode(index:int):void {
        
        var indx:int = index;
        var reqObj:Object = new Object;
        reasonCodeResult.removeItemAt(indx);
        if (mode == "ADD" || mode == "CAX_RECEIVE_NOTICE") {
            if(mode == "CAX_RECEIVE_NOTICE") {
                removeReasonCodeService.url = "stl/stlCompletionDetailsCAReceiveNotice.action?method=removeReason&index=" + indx;                    
            }else{
                removeReasonCodeService.url = "stl/stlCompletionDetails.action?method=removeReason&index=" + indx;    
            }
            
        } else if (mode == "DELETE") {
            removeReasonCodeService.url = "stl/stlCompletionDetailsCancel.action?method=removeReason&index=" + indx;
        }
        removeReasonCodeService.request = reqObj;
        removeReasonCodeService.send();
    } 
     
    private function getReasonCode():String {
        var reasonCode:String = "";
        for each (var item:Object in reasonCodeResult) {
            reasonCode = item['reasonCode'];
        }
        return reasonCode;
    } 
    
    private function changeStringToNum(str:String):Number {
        if(str == "") {
            return 0;
        }
        while(str.search(',') > -1) {
           str = str.replace(',', '');
        }
        return parseFloat(str);
    }
                                