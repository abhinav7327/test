// ActionScript file
// ActionScript file

 // ActionScript file for Trade Query
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.controls.XenosEntry;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.ProcessResultUtil;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import flash.events.MouseEvent;
    
    import mx.collections.ArrayCollection;
    import mx.events.CloseEvent;
    
    [Bindable]
    private var mode:String = "";
    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var dkViewListColl:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var xmlSource:XML= new XML();
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    
    public const MODE_MARK_AS_MATCH:String = "MARK_AS_MATCH";
    public const MODE_CXL_MARK_AS_MATCH:String = "CXL_MARK_AS_MATCH";
    private var keylist:ArrayCollection = new ArrayCollection();
    
    public var o:Object = {};
    
    [Bindable]
    private var receivedCompNoticeInfoPk:String;
    private var instrumentPkforDetail:String;
    	   
    public function loadAll():void{
        parseUrlString();
        super.setXenosEntryControl(new XenosEntry());
        if(this.mode == ""){
            this.mode = "view";
        }
//        XenosAlert.info("mode : "+mode);
        if(this.mode == this.MODE_MARK_AS_MATCH || this.mode == this.MODE_CXL_MARK_AS_MATCH || this.mode== "view"){
            this.dispatchEvent(new Event('entryInit'));
        } else { 
            //Nothig to do...
        }                    
    }
            
    public function parseUrlString():void {
        try {
            // Remove everything before the question mark, including
            // the question mark.
            var myPattern:RegExp = /.*\?/; 
            var s:String = this.loaderInfo.url.toString();
            s = s.replace(myPattern, "");
            // Create an Array of name=value Strings.
            var params:Array = s.split("&"); 
             // Print the params that are in the Array.
            var keyStr:String;
            var valueStr:String;
            var paramObj:Object = params;
 
            // Set the values of the salutation.
            if(params != null){
                for (var i:int = 0; i < params.length; i++) {                    
                    var tempA:Array = params[i].split("=");  
                    if (tempA[0] == "mode") {                        
                        this.mode = tempA[1];
                    }else if(tempA[0] == Globals.RECEIVED_COMP_NOTICE_INFO_PK){                        
                        this.receivedCompNoticeInfoPk = tempA[1];
                    } 
                }                        
            }else{
                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.opmodenotspecified'));
            } 
        } catch (e:Error) {
            trace(e);
        }
       
    }
    override public function preEntryInit():void{ 
        super.getInitHttpService().url = "stl/caxReceiveNoticeDispatch.action?rnd=" + Math.random();      

        super.getInitHttpService().request = populateRequestParams();
    } 
    override public function preEntryResultInit():Object{
        addCommonResultKes();             
        return keylist;
    }
    private function addCommonResultKes():void{
        keylist = new ArrayCollection();
        
        keylist.addItem("receiveNoticeView.senderReferenceNo");
        keylist.addItem("receiveNoticeView.settlementReferenceNo");
        keylist.addItem("receiveNoticeView.valueDateStr");
        keylist.addItem("receiveNoticeView.rcvdCompNoticeRefNo");
        keylist.addItem("receiveNoticeView.reasonCode");
        keylist.addItem("receiveNoticeView.messageStatus");
        keylist.addItem("receiveNoticeView.price");
        keylist.addItem("receiveNoticeView.dataSource");
        keylist.addItem("receiveNoticeView.settlementType");
        keylist.addItem("receiveNoticeView.settlementDateStr");
        keylist.addItem("receiveNoticeView.createdBy");
        keylist.addItem("receiveNoticeView.creationDate");//11
        keylist.addItem("receiveNoticeView.updatedBy");
        keylist.addItem("receiveNoticeView.updateDate");
        keylist.addItem("receiveNoticeView.errorDescription");
        
        
        keylist.addItem("receiveNoticeView.secCpBank");
        keylist.addItem("receiveNoticeView.secCpBankAccount");
        keylist.addItem("receiveNoticeView.secOurBank");
        keylist.addItem("receiveNoticeView.secOurBankAccount");
        
        keylist.addItem("receiveNoticeView.extSecurityDisplayStr");
        keylist.addItem("isSecurityRegistered");
        keylist.addItem("isDuplicateSecurity");//21
        keylist.addItem("receiveNoticeView.quantityStr");
        keylist.addItem("instrumentPk");
        keylist.addItem("receiveNoticeView.securityId");
        keylist.addItem("receiveNoticeView.amountStr");
        
        keylist.addItem("receiveNoticeView.deliverReceiveDisplay");
        keylist.addItem("receiveNoticeView.remarks");
        
        keylist.addItem("receiveNoticeView.cashCpBank");
        keylist.addItem("receiveNoticeView.cashCpBankAccount");
        keylist.addItem("receiveNoticeView.cashOurBank");        
        keylist.addItem("receiveNoticeView.cashOurBankAccount");//31
        keylist.addItem("receiveNoticeView.cashDeliverReceiveDisplay");
        keylist.addItem("receiveNoticeView.totalEligibleStr");
        keylist.addItem("receiveNoticeView.taxAmountStr");
        keylist.addItem("receiveNoticeView.cashRemarks");
        keylist.addItem("receiveNoticeView.ccyCode");
        keylist.addItem("receiveNoticeView.creationDateStr");
        keylist.addItem("receiveNoticeView.updateDateStr");
        
                   

    }
    override public function postEntryResultInit(mapObj:Object): void{
            
        commonResultPart(mapObj);
        
        if(this.mode == this.MODE_MARK_AS_MATCH){
            this.parentDocument.title =this.parentApplication.xResourceManager.getKeyValue('stl.receivenoticepopup.title.carcvdnoticemarkasmatch');
            confirmSubmit.includeInLayout = true;
            confirmSubmit.visible = true;
         }else if(this.mode == this.MODE_CXL_MARK_AS_MATCH){
            this.parentDocument.title =this.parentApplication.xResourceManager.getKeyValue('stl.receivenoticepopup.title.cxlcarcvdnoticemarkasmatch');
            confirmSubmit.includeInLayout = true;
            confirmSubmit.visible = true;
         }else if(this.mode == "view"){
            
         }       

    }
    private function commonResultPart(mapObj:Object):void{
        
        this.senderReferenceNo.text = mapObj[keylist.getItemAt(0)].toString(); 
        this.settlementReferenceNo.text = mapObj[keylist.getItemAt(1)].toString(); 
        this.valueDateStr.text = mapObj[keylist.getItemAt(2)].toString(); 
        this.rcvdCompNoticeRefNo.text = mapObj[keylist.getItemAt(3)].toString(); 
        this.reasonCode.text = mapObj[keylist.getItemAt(4)].toString(); 
        this.messageStatus.text = mapObj[keylist.getItemAt(5)].toString(); 
        this.price.text = mapObj[keylist.getItemAt(6)].toString(); 
        
        this.dataSource.text = mapObj[keylist.getItemAt(7)].toString(); 
        this.settlementType.text = mapObj[keylist.getItemAt(8)].toString(); 
        this.settlementDateStr.text = mapObj[keylist.getItemAt(9)].toString(); 
        this.createdBy.text = mapObj[keylist.getItemAt(10)].toString(); 
        this.creationDate.text = mapObj[keylist.getItemAt(37)].toString(); 
        this.updatedBy.text = mapObj[keylist.getItemAt(12)].toString(); 
        this.updateDate.text = mapObj[keylist.getItemAt(38)].toString(); 
        this.errorDescription.text = mapObj[keylist.getItemAt(14)].toString();
         
        this.secCpBank.text = mapObj[keylist.getItemAt(15)].toString(); 
        this.secCpBankAccount.text = mapObj[keylist.getItemAt(16)].toString(); 
        this.secOurBank.text = mapObj[keylist.getItemAt(17)].toString(); 
        this.secOurBankAccount.text = mapObj[keylist.getItemAt(18)].toString(); 
        this.deliverReceiveDisplay.text = mapObj[keylist.getItemAt(26)].toString(); 
        this.quantityStr.text = mapObj[keylist.getItemAt(22)].toString();
        this.remarks.text = mapObj[keylist.getItemAt(27)].toString();
        
        this.cashCpBank.text = mapObj[keylist.getItemAt(28)].toString();
        this.cashCpBankAccount.text = mapObj[keylist.getItemAt(29)].toString();
        this.cashOurBank.text = mapObj[keylist.getItemAt(30)].toString();
        this.cashOurBankAccount.text = mapObj[keylist.getItemAt(31)].toString();
        this.cashDeliverReceiveDisplay.text = mapObj[keylist.getItemAt(32)].toString();
        this.ccyCode.text = mapObj[keylist.getItemAt(36)].toString();
        this.amountStr.text = mapObj[keylist.getItemAt(25)].toString();
        this.totalEligibleStr.text = mapObj[keylist.getItemAt(33)].toString();
        this.taxAmountStr.text = mapObj[keylist.getItemAt(34)].toString();
        this.amountStr2.text = mapObj[keylist.getItemAt(25)].toString();
        this.cashRemarks.text = mapObj[keylist.getItemAt(35)].toString();
        
        var settleType:String = mapObj[keylist.getItemAt(8)].toString();
        var extSecurityDisplayStr:String = mapObj[keylist.getItemAt(19)].toString();
        var isSecurityRegistered:String = mapObj[keylist.getItemAt(20)].toString();
        var isDuplicateSecurity:String = mapObj[keylist.getItemAt(21)].toString();
        var instrumentPk:String = mapObj[keylist.getItemAt(23)].toString();
       
       //For security Side details
		if(XenosStringUtils.equals(settleType, "AGAINST") || !XenosStringUtils.isBlank(quantityStr.text) ){
		    ws2.includeInLayout = true;
		    ws2.visible = true;
		    
		    if(!XenosStringUtils.isBlank(extSecurityDisplayStr) && isSecurityRegistered == "Y" && isDuplicateSecurity != "Y"){
		        secSideSecurity.useHandCursor = true;
			    secSideSecurity.styleName = "TextLink";
			    secSideSecurity.buttonMode=true;
			    secSideSecurity.mouseChildren = false;
			    
			    secSideSecurity.text = extSecurityDisplayStr;
			    instrumentPkforDetail = instrumentPk;
			    
			    secSideSecurity.addEventListener(MouseEvent.CLICK,showInstrumentDetail);    				    
		    }else if(!XenosStringUtils.isBlank(extSecurityDisplayStr)){
		        secSideSecurity.text = extSecurityDisplayStr;
		    }else if(isSecurityRegistered == "Y" && isDuplicateSecurity != "Y"){
		        secSideSecurity.useHandCursor = true;
			    secSideSecurity.styleName = "TextLink";
			    secSideSecurity.buttonMode=true;
			    secSideSecurity.mouseChildren = false;
			    
			    secSideSecurity.text = mapObj[keylist.getItemAt(24)].toString();
			    instrumentPkforDetail = instrumentPk;
			    
			    secSideSecurity.addEventListener(MouseEvent.CLICK,showInstrumentDetail);
		    }else{
		        secSideSecurity.text = mapObj[keylist.getItemAt(24)].toString();
		    }
		    
		    
		}else{
		    ws2.includeInLayout = false;
		    ws2.visible = false;
		}
		//For Cash side details
		if(settleType == "AGAINST" || !XenosStringUtils.isBlank(amountStr.text) ){
		    ws3.includeInLayout = true;
		    ws3.visible = true;
		    
		    if(settleType == "FREE"){
		        cashAmtRow.includeInLayout = false;
		        cashAmtRow.visible = false;
		    }else{
		        cashAmtbalRow.includeInLayout = false;
		        cashAmtbalRow.visible = false;
		        cashTaxAmtRow.includeInLayout = false;
		        cashTaxAmtRow.visible = false;
		    }
		    
		}else{
		    ws3.includeInLayout = false;
		    ws3.visible = false;
		}
 
    } 
    override public function preEntry():void{
         //setValidator();  Not required
         var requestObj :Object = populateRequestParamsConfirm();
         
         if(this.mode == this.MODE_MARK_AS_MATCH){
            super.getSaveHttpService().url = "stl/caxReceiveNoticeDispatch.action?rnd=" + Math.random();  
         }else if(this.mode == this.MODE_CXL_MARK_AS_MATCH){
            super.getSaveHttpService().url = "stl/caxReceiveNoticeDispatch.action?rnd=" + Math.random();  
         }else{
             XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.unabletodetermineopmode'));
         }                     
         
        super.getSaveHttpService().request  = requestObj;
    }
    override public function preEntryResultHandler():Object
    {
         addCommonResultKes();
         return keylist;
    }
    override public function postEntryResultHandler(mapObj:Object):void
    {
        
        commonResult(mapObj);
        
        //usrCnfMessage.text ="Security In Entry - User Confirmation ";
    }   
    private function commonResult(mapObj:Object):void{
        if(mapObj!=null){            
            if(mapObj["errorFlag"].toString() == "error"){
                //result = mapObj["errorMsg"] .toString();
                if(mode != "cancel"){
                  errPage.showError(mapObj["errorMsg"]);                        
                }else{
                    XenosAlert.error(mapObj["errorMsg"]);
                }
            }else if(mapObj["errorFlag"].toString() == "noError"){
                
             errPage.clearError(super.getSaveResultEvent());                            
             
             XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.confirm.txn'));
             // Close the Popup
             this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
                             
            }else{
                errPage.removeError();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            }            
        }
    }   
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
         reqObj.ReceivedCompNoticeInfoPk = receivedCompNoticeInfoPk;
         if(this.mode == this.MODE_MARK_AS_MATCH){
            reqObj.method = "doMarkAsMatch";
            reqObj.ActionType = this.MODE_MARK_AS_MATCH;
         }else if(this.mode == this.MODE_CXL_MARK_AS_MATCH){
            reqObj.method = "doCxlMarkAsMatch"; 
            reqObj.ActionType = this.MODE_CXL_MARK_AS_MATCH;
         }else if(this.mode == "view"){
            reqObj.method = "doViewRcvdNotice";
            reqObj.ActionType = "VIEW";
         }
         return reqObj;
    }
    
    private function populateRequestParamsConfirm():Object {
        var requestObj : Object = new Object();
        //requestObj['SCREEN_KEY'] = 250;
        if(this.mode == this.MODE_MARK_AS_MATCH){
            requestObj['method'] = "confirmMarkAsMatch";
            requestObj['SCREEN_KEY'] = 11122;            
        }else if(this.mode == this.MODE_CXL_MARK_AS_MATCH){
            requestObj['method'] = "confirmCxlMarkAsMatch";
            requestObj['SCREEN_KEY'] = 11123;            
        }
        return requestObj;
    }
    
    private function showInstrumentDetail(event:MouseEvent):void{
        //var InstPkStr : String = xmlSource.detailView.summary.instrumentPk;
		var parentApp :UIComponent = UIComponent(this.parentApplication);
		XenosPopupUtils.showInstrumentDetails(instrumentPkforDetail, parentApp);
        
    }    