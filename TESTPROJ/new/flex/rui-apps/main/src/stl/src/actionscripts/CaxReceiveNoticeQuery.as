// ActionScript file

 // ActionScript file for Receive Notice Query
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.containers.SummaryPopup;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.controls.XenosQuery;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.HiddenObject;
    import com.nri.rui.core.utils.ProcessResultUtil;
    import com.nri.rui.core.utils.XenosStringUtils;
    import com.nri.rui.stl.validators.CaxReceiveNoticeValidator;
    import com.nri.rui.stl.validators.IoverUnderValidator;
    
    
    import mx.collections.ArrayCollection;
    import mx.events.CloseEvent;
    import mx.events.ValidationResultEvent;
    import mx.managers.PopUpManager;
    import mx.utils.StringUtil; 
    
    
    [Bindable]
    private var _mode:String;
    private var keylist:ArrayCollection = new ArrayCollection(); 
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
    private var queryResult:ArrayCollection= new ArrayCollection();
    
    private var sPopup : SummaryPopup; 

    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    
    public function loadAll():void{
        this._mode = "query";  //Default Mode
        //parseUrlString();
        super.setXenosQueryControl(new XenosQuery());        
        
        if(this._mode == "query"){
           this.dispatchEvent(new Event('queryInit'));
           this.fundCodePop.fundCode.setFocus();
        }else{
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.invalidmode') + _mode);   
        }            
    }       
    /**
     * This is the method to pass the Collection of data items
     * through the context to the FinInst popup. This will be implemented as per specifdic  
     * requirement. 
     */
    private function populateFinInstRole():ArrayCollection {
    	//pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
        
        var bankRoleArray : Array = new Array(3);
        bankRoleArray[0] = "Security Broker";
        bankRoleArray[1] = "Bank/Custodian";
        bankRoleArray[2] = "Central Depository";
        myContextList.addItem(new HiddenObject("bankRoles",bankRoleArray));
        
        return myContextList;
    }
    /**
     * This is the method to pass the Collection of data items
     * through the context to the account popup. This will be implemented as per specifdic  
     * requriment. 
     */
    private function populateInvActContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
                  
        //passing counter party type                
        var cpTypeArray:Array = new Array(2);
            cpTypeArray[0]="BROKER";
            cpTypeArray[1]="BANK/CUSTODIAN";
            //cpTypeArray[1]="CLIENT";
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
        return myContextList;
    }
    private function addCommonKeys():void{  
        keylist = new ArrayCollection();
        keylist.addItem("subEventType");
        keylist.addItem("subEventTypeList.item");          
        keylist.addItem("messageStatus");
        keylist.addItem("messageStatusList.item");
        keylist.addItem("settlementDateFrom");
        keylist.addItem("settlementDateTo");
        keylist.addItem("tradeDateFrom");    
        keylist.addItem("tradeDateTo");
        keylist.addItem("lmOfficeList.officeId");
    }        
    override public function preQueryInit():void{
      	super.getInitHttpService().url = "stl/caxReceiveNoticeDispatch.action?rnd="+Math.random();            
      	var req : Object = new Object();
        req.SCREEN_KEY = 11120;
        req.method="initialExecute";
        super.getInitHttpService().request = req;
    }
    override public function preQueryResultInit():Object{        
        addCommonKeys();       
        
        return keylist;            
    }
    override public function postQueryResultInit(mapObj:Object):void{
        commonInit(mapObj);
        
        app.submitButtonInstance = submit;
        this.fundCodePop.fundCode.setFocus();

        errPage2.removeError();
    }
    override public function preQuery():void{
        setValidator();
        qh.resetPageNo();
        super.getSubmitQueryHttpService().useProxy = false;
        super.getSubmitQueryHttpService().url = "stl/caxReceiveNoticeDispatch.action?rnd=" + Math.random();    
        super.getSubmitQueryHttpService().request = populateRequestParams();              
    }
    override public function postQueryResultHandler(mapObj:Object):void{
        commonResult(mapObj);
        
        errPage2.removeError();
    }
    override public function preResetQuery():void{
                
        super.getResetHttpService().url = "stl/caxReceiveNoticeDispatch.action?rnd=" + Math.random();
        var reqObject:Object = new Object();
        reqObject.mode=this._mode;
        reqObject.method="resetQueryCriteria";
        reqObject.SCREEN_KEY = 11120;
        super.getResetHttpService().request = reqObject;
    }
    
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * 
    */   
    private function commonInit(mapObj: Object) : void {
        var index:int=-1;
        var tempColl: ArrayCollection = new ArrayCollection();
        
        //Initialize form.
        
        errPage.clearError(super.getInitResultEvent());//clears the errors if any 
        this.queryResult.removeAll();
        resetResultHandler();
        
        //Initialize the Field values
        fundCodePop.fundCode.text = "";
        fundCodePop.fundCode.setFocus();
        
        
        //Initialize eventTypeList.
        tempColl = new ArrayCollection();
            
        tempColl.addItem({label:" ", value: " "});
        index=-1;
        for each(var item:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
            tempColl.addItem(item);
        }
        eventTypes.dataProvider = tempColl;
        eventTypes.selectedIndex = index !=-1 ? index+1 : 0; 
        
        ourBank.finInstCode.text = "";        
        ourSettleAccount.accountNo.text = "";
        settlementDateFrom.text = mapObj[keylist.getItemAt(4)].toString();
        settlementDateTo.text = mapObj[keylist.getItemAt(5)].toString();
        tradeDateFrom.text = mapObj[keylist.getItemAt(6)].toString();
        tradeDateTo.text = mapObj[keylist.getItemAt(7)].toString();
        ccy.ccyText.text = "";
        undSecurityId.instrumentId.text = "";
        senderReferenceNo.text = "";
        settleReferenceNo.text = "";
        rcvdCompNoticeRefNo.text = "";
        
        //Initialize messageStatusList.
        tempColl = new ArrayCollection();
            
        tempColl.addItem({label:" ", value: " "});
        index=-1;
        for each(item in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
            tempColl.addItem(item);
        }
        messageStatus.dataProvider = tempColl;
        messageStatus.selectedIndex = index !=-1 ? index+1 : 0;
        
        // Initialize LM Office
        tempColl = new ArrayCollection();
            
        tempColl.addItem(" ");
        for each(item in (mapObj[keylist.getItemAt(8)] as ArrayCollection)){
            tempColl.addItem(item);
        }
        lmOffice.dataProvider = tempColl;
    }
    
    private function setValidator():void{        
        var validateModel:Object={
                                   receiveQuery:{
                                       settleDateFrom:this.settlementDateFrom.text,
                                       settleDateTo:this.settlementDateTo.text ,
                                       tradeDateFrom:this.tradeDateFrom.text,
                                       tradeDateTo:this.tradeDateTo.text                                          
                                   }
                                 }; 
         super._validator = new CaxReceiveNoticeValidator();
         super._validator.source = validateModel ;
         super._validator.property = "receiveQuery";
    }
    private function commonResult(mapObj:Object):void{        
        
        var result:String = "";
        if(mapObj!=null){   
            //XenosAlert.info("mapObj : "+mapObj.toString());         
            if(mapObj["errorFlag"].toString() == "error"){
                //result = mapObj["errorMsg"] .toString();
                queryResult.removeAll();
                resetResultHandler();
                errPage.showError(mapObj["errorMsg"]);
            }else if(mapObj["errorFlag"].toString() == "noError"){
                errPage.clearError(super.getSubmitQueryResultEvent());
                                
                queryResult.removeAll();
                operatopnArray.removeAll(); // Remove if any previous selection
                // XenosAlert.info("I am in queryResult : "+currentState);
                queryResult=mapObj["row"];
                
                for(var i:int=0; i<queryResult.length; i++){
                    queryResult[i].selected = false;
                }
                
                changeCurrentState();
                qh.setOnResultVisibility(); 
                qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
                qh.PopulateDefaultVisibleColumns();
                
            }else{
                errPage.removeError();
                queryResult.removeAll();
                resetResultHandler();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            }            
        }
        
    }   

    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
     	reqObj.method = "submitQuery";
     	reqObj.SCREEN_KEY = 11121;
     	
     	reqObj.fundCode = fundCodePop.fundCode.text;
     	reqObj.subEventType = this.eventTypes.selectedItem != null ?  this.eventTypes.selectedItem.value : "";
     	reqObj.ourSettlementBank = ourBank.finInstCode.text;
     	reqObj.ourSettlementAccount = ourSettleAccount.accountNo.text;
     	reqObj.settlementDateFrom = this.settlementDateFrom.text;     	
     	reqObj.settlementDateTo = this.settlementDateTo.text;
     	reqObj.tradeDateFrom = this.tradeDateFrom.text;     	
     	reqObj.tradeDateTo = this.tradeDateTo.text;
     	reqObj.settlementCcy = this.ccy.ccyText.text;
     	reqObj.underlyingSecurityId = this.undSecurityId.instrumentId.text;
     	reqObj.senderReferenceNo = this.senderReferenceNo.text;
     	reqObj.settlementReferenceNo = this.settleReferenceNo.text;     	
     	reqObj.rcvdCompNoticeRefNo = this.rcvdCompNoticeRefNo.text;
     	reqObj.messageStatus = this.messageStatus.selectedItem != null ?  StringUtil.trim(this.messageStatus.selectedItem.value) : "";
     	reqObj.lmOffice = this.lmOffice.selectedItem != null ? StringUtil.trim(this.lmOffice.text) : "";
     	
        reqObj.rnd = Math.random() + "";
     	return reqObj;
    }
    
    /**
	 * This method should be called on creationComplete of the datagrid 
	 */ 
	 private function bindDataGrid():void {
		qh.dgrid = receiveNoticeOutQueryResult;
	}
	
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
    override public function preGenerateXls():String {
    	var url : String = "stl/caxReceiveNoticeDispatch.action?method=generateXLS&rnd="+Math.random();
    	return url;
    } 
    /**
    * This will generate the Pdf report for the entire query result set 
    * and will open in a separate window.
    */
    override public function preGeneratePdf():String {
    	var url : String = "stl/caxReceiveNoticeDispatch.action?method=generatePDF&rnd=" + Math.random();
    	return url;
    }    
    override public function preNext():Object{
       var reqObj : Object = new Object();
       reqObj.method = "doNext";
       return reqObj;
    }    
    override public function prePrevious():Object{
           
	    var reqObj : Object = new Object();
	    reqObj.method = "doPrevious";
	    return reqObj;
    }    
          
    private function dispatchPrintEvent():void{
        this.dispatchEvent(new Event("print"));
    }  
    private function dispatchPdfEvent():void{
       // XenosAlert.info("dispatchEvent pdf");
        this.dispatchEvent(new Event("pdf"));
    }  
    private function dispatchXlsEvent():void{
        this.dispatchEvent(new Event("xls"));
    }   
    private function dispatchNextEvent():void{
        this.dispatchEvent(new Event("next"));
    }  
    private function dispatchPrevEvent():void{
        this.dispatchEvent(new Event("prev"));
    }
    
    private function doMarkAsMatch():void {
        var parentApp :UIComponent = UIComponent(this.parentApplication);
        var objSelected:Object;
        if(operatopnArray.length == 0 || operatopnArray.length > 1){
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.selectonercvdrecord'));
            return;
        }else if(operatopnArray.length == 1){
            objSelected = operatopnArray[0];            
            if(objSelected == null || objSelected.typeOfRecord != "R" || objSelected.messageStatus != "OUTSTANDING" ||  objSelected.receivedCompNoticeInfoPk == "-1"){
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.selectvalidoutstandingrcvdnotice'));
                return;
            }
        }
           
        sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,false));
        sPopup.addEventListener(CloseEvent.CLOSE,closeHandler,false,0,true);
        sPopup.title = this.parentApplication.xResourceManager.getKeyValue('stl.receivenoticepopup.title.markasmatch');
        sPopup.width = 840;
        sPopup.height = 500;
        PopUpManager.centerPopUp(sPopup);
        sPopup.moduleUrl = Globals.CAX_RECEIVED_NOTICE_DETAIL_SWF+Globals.QS_SIGN+Globals.RECEIVED_COMP_NOTICE_INFO_PK+Globals.EQUALS_SIGN+ objSelected.receivedCompNoticeInfoPk + Globals.AND_SIGN + "mode" + Globals.EQUALS_SIGN + "MARK_AS_MATCH";
    }
    private function doCxlMarkAsMatch():void {
        var parentApp :UIComponent = UIComponent(this.parentApplication);
        var objSelected:Object;
        if(operatopnArray.length == 0 || operatopnArray.length > 1){
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.selectonercvdrecord'));
            return;
        }else if(operatopnArray.length == 1){
            objSelected = operatopnArray[0];            
            if(objSelected == null || objSelected.typeOfRecord != "R" || objSelected.messageStatus != "MARK_AS_MATCH" ||  objSelected.receivedCompNoticeInfoPk == "-1"){
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.selectvalidmarkasmatchrcvdnotice'));
                return;
            }
        }
           
        sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,false));
        sPopup.addEventListener(CloseEvent.CLOSE,closeHandler,false,0,true);
        sPopup.title = this.parentApplication.xResourceManager.getKeyValue('stl.receivenoticepopup.title.cxlmarkasmatch');
        sPopup.width = 840;
        sPopup.height = 500;
        PopUpManager.centerPopUp(sPopup);
        sPopup.moduleUrl = Globals.CAX_RECEIVED_NOTICE_DETAIL_SWF+Globals.QS_SIGN+Globals.RECEIVED_COMP_NOTICE_INFO_PK+
                           Globals.EQUALS_SIGN + objSelected.receivedCompNoticeInfoPk + Globals.AND_SIGN + "mode" + 
                           Globals.EQUALS_SIGN + "CXL_MARK_AS_MATCH";
    }
    /**
	 * Event Handler for the custom event "CloseEvent.CLOSE" to refresh the result page
	 */
	public function closeHandler(event:Event):void {
		//this.parentDocument.currentState = "";        
        this.dispatchEvent(new Event("querySubmit"));
        if(sPopup.hasEventListener(CloseEvent.CLOSE))
            sPopup.removeEventListener(CloseEvent.CLOSE,closeHandler);
        sPopup.removeMe();
    }    
    /**
     * Disables the pdf, xls and print button on query result header.
     */
    private function resetResultHandler():void {
        this.qh.setPrevNextVisibility(false,false);
        this.qh.pdf.enabled = false;
        this.qh.xls.enabled = false;
        //this.qh.print.enabled = false;
    }   
    //TODO:
    private function generateOverUnderPdf():void {
    	
    	var reciveModel:Object={
	                    receiveQuery:{
	                            fundCode:fundCodePop.fundCode.text,
	                            subEventType:this.eventTypes.selectedItem != null ?  this.eventTypes.selectedItem.value : "",
	                            settleDateFrom:this.settlementDateFrom.text,
				    settleDateTo:this.settlementDateTo.text ,
				    tradeDateFrom:this.tradeDateFrom.text,
                                    tradeDateTo:this.tradeDateTo.text     
	                    }
	                }; 
	var receiveNoticeValidator:IoverUnderValidator = new IoverUnderValidator();
	receiveNoticeValidator.source=reciveModel;
	receiveNoticeValidator.property="receiveQuery";
	var validationResult:ValidationResultEvent =receiveNoticeValidator.validate();
			
	if(validationResult.type==ValidationResultEvent.INVALID){
  		var errorMsg:String=validationResult.message;
            	XenosAlert.error(errorMsg);
        }else{
    	
	    var url:String="stl/caxReceiveNoticeDispatch.action?method=doOverUnder";
	    var request:URLRequest = new URLRequest(url);
	    var variables:URLVariables = new URLVariables();
	    variables.fundCode = fundCodePop.fundCode.text;
	    variables.subEventType = this.eventTypes.selectedItem != null ?  this.eventTypes.selectedItem.value : "";
	    variables.ourSettlementBank = ourBank.finInstCode.text;
		variables.ourSettlementAccount = ourSettleAccount.accountNo.text;
		variables.settlementDateFrom = this.settlementDateFrom.text;     	
		variables.settlementDateTo = this.settlementDateTo.text;
		variables.tradeDateFrom = this.tradeDateFrom.text;     	
		variables.tradeDateTo = this.tradeDateTo.text;
		variables.settlementCcy = this.ccy.ccyText.text;
		variables.underlyingSecurityId = this.undSecurityId.instrumentId.text;
		variables.senderReferenceNo = this.senderReferenceNo.text;
		variables.settlementReferenceNo = this.settleReferenceNo.text;     	
		variables.rcvdCompNoticeRefNo = this.rcvdCompNoticeRefNo.text;
		variables.messageStatus = this.messageStatus.selectedItem != null ?  StringUtil.trim(this.messageStatus.selectedItem.value) : "";
		variables.menuPk = this.parentApplication.mdiCanvas.getwindowKey();
		variables.rnd = Math.random() + "";
	    request.data = variables;
	    request.method = URLRequestMethod.POST;
	     try {
		    navigateToURL(request,"_blank");
		}
		catch (e:Error) {
		    // handle error here
		    trace(e);
	    }
	}	    
    }    