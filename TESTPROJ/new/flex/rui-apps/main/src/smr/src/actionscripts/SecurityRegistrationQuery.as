
// ActionScript file for Security Registration

 import com.nri.rui.core.Globals;
 import com.nri.rui.core.containers.SummaryPopup;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.controls.XenosQuery;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.smr.validator.SecurityRegistrationQueryValidator;
 
 import flash.events.Event;
 import flash.events.MouseEvent;
 
 import mx.collections.ArrayCollection;
 import mx.core.Application;
 import mx.core.UIComponent;
 import mx.events.CloseEvent;
 import mx.managers.PopUpManager;
 import mx.rpc.events.ResultEvent;

 
  [Bindable]
  private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
  
  [Bindable]public var mode : String = "query";
  
  private var keylist:ArrayCollection = new ArrayCollection();
  [Bindable]
  public var queryResult1:ArrayCollection= new ArrayCollection();
  [Bindable]
  public var queryResult2:ArrayCollection= new ArrayCollection();
  
  private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
  private var sortUtil2: ProcessResultUtil= new ProcessResultUtil();
  [Bindable]
  private var bloomberg:Boolean = false;
  
  [Bindable]private var selectedIndex : int = -1;  
  [Bindable]private var xSelectedIndex : int = -1;  
  [Bindable]private var selectedBoolean : Boolean = false;
  [Bindable]private var xSelectedBoolean : Boolean = false;  
  [Bindable]private var bbUniqueId:String = XenosStringUtils.EMPTY_STR;
  [Bindable]private var instrumentPk:String = XenosStringUtils.EMPTY_STR;
  [Bindable]public var xdata:Object;
  [Bindable]public var bbdata:Object;
  
  private var sPopup : SummaryPopup;
  
  public function loadAll():void{
  	super.setXenosQueryControl(new XenosQuery());
  	if(this.mode == 'query'){
    	this.dispatchEvent(new Event('queryInit'));
    }
  }
  
  override public function preQueryInit():void{
    	var rndNo:Number= Math.random();
  	   super.getInitHttpService().url = "smr/securityRegistrationQueryDispatch.action?method=initialExecute&mode="+mode+"&rnd=" + rndNo;
  	   
  	  /*  var reqObject:Object = new Object();
  	   reqObject.SCREEN_KEY = 10073;
  	   super.getInitHttpService().request = reqObject;  */        	
    }
    
  private function addCommonKeys():void{ 
    	keylist = new ArrayCollection();
    	//keylist.addItem("secCodeType.item");
  }  
  override public function preQueryResultInit():Object{
    	addCommonKeys();   	
    	return keylist;        	
    }
  
  override public function postQueryResultInit(mapObj:Object):void{
	  		commonInit(mapObj);
   }
  private function clearCommonFields():void{
  		
  		this.ticker.text = XenosStringUtils.EMPTY_STR;
  		this.exchngCode.text = XenosStringUtils.EMPTY_STR;
  		this.cusipSecCode.text = XenosStringUtils.EMPTY_STR;
  		this.isinSecCode.text = XenosStringUtils.EMPTY_STR;
  		this.sedolSecCode.text = XenosStringUtils.EMPTY_STR;
  		this.namSecCode.text = XenosStringUtils.EMPTY_STR;
  		this.secCcyName.text = XenosStringUtils.EMPTY_STR;
  		this.ccyBox.ccyText.text =  XenosStringUtils.EMPTY_STR;
  		//this.instrumentType.itemCombo.text = XenosStringUtils.EMPTY_STR;
  		this.ccyBox.ccyText.text = XenosStringUtils.EMPTY_STR;
  }
  private function commonInit(mapObj:Object):void{
    	clearCommonFields();
    	
    	errPage.clearError(super.getInitResultEvent());
    	        
        //Set focus on ticker
        ticker.setFocus();
        
        app.submitButtonInstance = submit;       
  }    
  
  override public function preQuery():void {
  		setValidator();
    	qh1.resetPageNo();
    	qh2.resetPageNo();	
       
        super.getSubmitQueryHttpService().url = "smr/securityRegistrationQueryDispatch.action?";  
        super.getSubmitQueryHttpService().request = populateRequestParams();
        super.getSubmitQueryHttpService().method="POST";
    }
    
   /**
   * Ticker or SedolCode or ISIN Code or Cusip Code is mandatory field for querying
   */
   private function setValidator():void {
	   	var validateModel:Object={
	   					secRegistrationModel:{
	   						ticker:this.ticker.text,
	   						isin:this.isinSecCode.text,
	   						cusip:this.cusipSecCode.text,
	   						sedol:this.sedolSecCode.text,
	   						nam:this.namSecCode.text,
	   						name:this.secCcyName.text
	   					}
	   	};
	   	
	   	super._validator = new SecurityRegistrationQueryValidator();
	   	super._validator.source = validateModel ;
        super._validator.property = "secRegistrationModel"; 
   } 
   /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	var reqObj : Object = new Object();
    	reqObj.method= "submitSummary";
    	
    	//reqObj.securityCodeType = (this.secCodeType.selectedItem != null ? StringUtil.trim(this.secCodeType.selectedItem.value) : "");
    	//reqObj.securityCode= this.secCode ;
    	reqObj.exchangeCode= this.exchngCode.text;
    	reqObj.ticker= this.ticker.text;
    	reqObj.securityName= this.secCcyName.text;
    	reqObj.issueCcy= this.ccyBox.ccyText.text;
    	//reqObj.securityType = this.instrumentType.itemCombo.text;
    	reqObj.sedolCode = this.sedolSecCode.text;
    	reqObj.isinCode = this.isinSecCode.text;
    	reqObj.namCode = this.namSecCode.text;
    	reqObj.cusipCode = this.cusipSecCode.text;
    	reqObj.rnd = Math.random() + "";
    	return reqObj;
    } 
    override public function preQueryResultHandler():Object
	{
		keylist = new ArrayCollection();
		keylist.addItem("rows.row");
		keylist.addItem("xpreviousTraversable");
		keylist.addItem("xnextTraversable");
		keylist.addItem("bbresultviews.view");
		keylist.addItem("bbNextTraversable");
		keylist.addItem("bbPreviousTraversable");
		return keylist;
	}
    override public function postQueryResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    }
    private function commonResult(mapObj:Object):void{
    	
    	var result:String = "";
    	qerrPage.removeError();
    	if(mapObj!=null){   
    		queryResult1.removeAll(); 		
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		//result = mapObj["errorMsg"] .toString();
	    		errPage.showError(mapObj["errorMsg"]);
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    	    errPage.clearError(super.getSubmitQueryResultEvent());
	    	    queryResult1=mapObj["rows.row"];
	    	    
	    	    queryResult2 = mapObj["bbresultviews.view"];
                //resetSelection(queryResult);
                addPropertiesToBB(); 
                addPropertiesToXenos();	
			    changeCurrentState();
			    qh1.resultHeader.text = "Xenos Details";
			     //qh1.print.visible = false;
	            qh1.setOnResultVisibility();
	            qh1.setPrevNextVisibility((mapObj["xpreviousTraversable"] == "true")?true:false,(mapObj["xnextTraversable"] == "true")?true:false );
	            qh1.PopulateDefaultVisibleColumns();
			    qh2.resultHeader.text = "Bloomberg Bulk Details";
			    qh2.setOnResultVisibility();
			    qh2.setPrevNextVisibility((mapObj["bbPreviousTraversable"] == "true")?true:false,(mapObj["bbNextTraversable"] == "true")?true:false );
	    		qh2.PopulateDefaultVisibleColumns();
	    	}else{
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('smr.data.not.found'));
	    	}    		
    	}
    }
    
    /**
    * This method will add a new property "rowNo" to each element of the
    * views of Xenos. This index will correspond to the index of the 
    * element in the resultList fetched.
    */
    private function addPropertiesToXenos():void {
    	var index:int =0;
    	for each(var xenosView:Object in queryResult1){
    		xenosView["rowNo"] = index;
    		xenosView["selected"] = false;
    		index++;
    	}
    }
        
    /**
    * This method will add a new property "rowNo" to each element of the
    * views of Bloomberg. This index will correspond to the index of the 
    * element in the resultList fetched.
    */
    private function addPropertiesToBB():void{
    	var index:int =0;
    	for each(var bloombergView:Object in queryResult2){
    		bloombergView["rowNo"] = index;
    		bloombergView["selected"] = false;
    		index++;
    	}
    }
    
    public function selectXenosSecurity(data:Object):void {
    	xSelectedIndex = data["rowNo"];
    	instrumentPk = data["instrumentPk"];
    	for each (var xenosView:Object in queryResult1){
    		xenosView["selected"] = false;
    	}
    	data["selected"]= true;
    	xSelectedBoolean = true;
    	trace("selected Index : " + xSelectedIndex + " instrumentPk : " + instrumentPk);
    	queryResult1.refresh();
    }
    
    public function selectBloombergSecurity(data:Object):void {
    	selectedIndex = data["rowNo"];
    	bbUniqueId = data["bbUniqueId"];
    	for each(var bloombergView:Object in queryResult2){
    		bloombergView["selected"] = false;
    	}
    	data["selected"]= true;
    	selectedBoolean = true;
    	trace("selected Index : "+selectedIndex+" bbUniqueID : "+bbUniqueId);
    	queryResult2.refresh();
    }
    
    /**
    * Validates the security during add and update.
    */
    public function validateSecurity(event:MouseEvent, isForUpdate:Boolean):void {
		
		var rndNo:Number = Math.random();
		var reqObj:Object = new Object();
		reqObj.rndNo = rndNo;
		reqObj.method = "validateForRegistration";
		reqObj.forUpdate = isForUpdate;
    	
    	if (isForUpdate) {
	    	if (selectedBoolean && xSelectedBoolean) {
    			reqObj.rowNum = selectedIndex;
    			reqObj.xRowNum = xSelectedIndex;
				validateRequest.request = reqObj;
				validateRequest.send();
	    	} else{
	     		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('smr.msg.update.selectone'));
	     	}    		
    	} else {
	    	if (selectedBoolean && !xSelectedBoolean) {
    			reqObj.rowNum = selectedIndex;
				validateRequest.request = reqObj;
				validateRequest.send();
	    	} else{
	     		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('smr.msg.entry.selectone'));
		    	for each (var xenosView:Object in queryResult1) {
		    		xenosView["selected"] = false;
		    	}
		    	queryResult1.refresh();
		    	xSelectedBoolean = false;		
		    	for each (var bloombergView:Object in queryResult2) {
		    		bloombergView["selected"] = false;
		    	}
		    	queryResult2.refresh();
		    	selectedBoolean = false;
	     	}
    	}
    	
    }
    
    private function resultHandler(event:ResultEvent):void{
    	var rs:XML = XML(event.result);
    	trace("result : "+ rs.toXMLString());
    	if (null != event && rs != null) {
    		if(rs.child("Errors").length()>0) {
    			var errorInfoList : ArrayCollection = new ArrayCollection();
				//populate the error info list 			 	
				for each ( var error:XML in rs.Errors.error ) {
					errorInfoList.addItem(error.toString());
				}
				qerrPage.showError(errorInfoList);//Display the error
    		}else{
    			if(rs.child("registeredSecurity").length() > 0){
    				qerrPage.clearError(event);
    				
    				trace("registeredSecurity :"+rs.registeredSecurity+" : "+rs.isForUpdate);
    				if(rs.isForUpdate == false){
    					//For Addition
	    					openEntryPopup(false);
	    			}else{
	    				//Update
	    				if(rs.registeredSecurity == true)
	    					openEntryPopup(false);
	    			}
    			}
    		}
    	}
    }
    private function handleConfirm(event:CloseEvent):void{
    	if(event.detail == mx.controls.Alert.YES)
    	{
    		openEntryPopup(false);
    	}
    }
    public function openEntryPopup(isNew:Boolean):void{
    		sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
    		sPopup.title =  Application.application.xResourceManager.getKeyValue('smr.label.secregistration.entry');
    		sPopup.addEventListener(CloseEvent.CLOSE,closeHandler,false,0,true);
    		sPopup.width = this.parentApplication.width - 100;
	       	sPopup.height = 600;
	       	PopUpManager.centerPopUp(sPopup);
	       	mode = "securityentry";
	       	
       		sPopup.moduleUrl = "assets/appl/smr/SecurityRegistrationEntry.swf" + Globals.QS_SIGN + "mode" + Globals.EQUALS_SIGN + this.mode+ Globals.AND_SIGN + "rowNum"+ Globals.EQUALS_SIGN +selectedIndex+
       							Globals.AND_SIGN+"bbUniqueId"+Globals.EQUALS_SIGN+bbUniqueId+Globals.AND_SIGN+"isNew"+Globals.EQUALS_SIGN+isNew;
       		
    }
    public function openDetailsEntryPopup(event:MouseEvent, isNew:Boolean):void{
    	//if(selectedBoolean){
    		openEntryPopup(isNew);
    	/* 	sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
    		sPopup.title =  Application.application.xResourceManager.getKeyValue('smr.label.secregistration.entry');
    		sPopup.addEventListener(CloseEvent.CLOSE,closeHandler,false,0,true);
    		sPopup.width = 950;
	       	sPopup.height = 600;
	       	PopUpManager.centerPopUp(sPopup);
	       	mode = "securityentry";
       		sPopup.moduleUrl = "assets/appl/smr/SecurityRegistrationEntry.swf" + Globals.QS_SIGN + "mode" + Globals.EQUALS_SIGN + this.mode+ Globals.AND_SIGN + "rowNum"+ Globals.EQUALS_SIGN +selectedIndex+
       							Globals.AND_SIGN+"bbUniqueId"+Globals.EQUALS_SIGN+bbUniqueId; */
     /* 	}else{
     		//User has not selected any record
     		XenosAlert.error("Please select at least one record to add");
     	} */
    }
	/**
	 * Event Handler for the custom event "OkSystemConfirm"
	 */
	public function closeHandler(event:CloseEvent):void {
		if(mode == "securityentry"){
			//this.dispatchEvent(new Event("querySubmit"));
		}
		this.mode="query";
		selectedBoolean = false;
		app.submitButtonInstance = submit;
		sPopup.removeMe();
 	}
    override public function preResetQuery():void{
	    var rndNo:Number= Math.random();
	  	super.getResetHttpService().url = "smr/securityRegistrationQueryDispatch.action?method=resetQuery&mode=query"+ rndNo;
	}
    override    public function preNext():Object{
   		var reqObj : Object = new Object();
   		if(bloomberg == false)
   			reqObj.method = "doNext";
   		else {
   			reqObj.method = "doBbNext";
   		}	
   		return reqObj;
  	}	
  	override public function prePrevious():Object{
   
   	 	var reqObj : Object = new Object();
   	 	if(bloomberg == false)
   	 		reqObj.method = "doPrevious";
    	else {
   			reqObj.method = "doBbPrevious";
   		}	
   	 	return reqObj;
  	}	
    private function dispatchNextEvent():void{
    	bloomberg = false;
	    this.dispatchEvent(new Event("next"));
	}  
	private function dispatchPrevEvent():void{
	    bloomberg = false;
	    this.dispatchEvent(new Event("prev"));
	}
	
	private function dispatchBBNextEvent():void{
		bloomberg = true;
		this.dispatchEvent(new Event("next"));
	
	}
	
	private function dispatchBBPrevEvent():void{
		
		bloomberg = true;
		this.dispatchEvent(new Event("prev"));
	}
	
	public function sendRequestToBB():void {
	    var parentApp :UIComponent = UIComponent(this.parentApplication);        
//        if(selectedMessageRecords.length < 1){
//            XenosAlert.error("Select at least one record");
//            return;
//        }
        sendrequesttoBB.enabled = false;
        var summaryPopup:SummaryPopup;
        summaryPopup = SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,false));
        summaryPopup.title = "Enter - Send Request To BB";
        summaryPopup.width = 840;
        summaryPopup.height = 445;
        PopUpManager.centerPopUp(summaryPopup);
        summaryPopup.owner = this;
        summaryPopup.addEventListener(CloseEvent.CLOSE,closeHandlerBB,false,0,true);
        var rndNo:Number = Math.random();
        summaryPopup.moduleUrl = "assets/appl/smr/SendRequestToBBEntryModule.swf?mode=entry&rnd="+rndNo; 
	}
	/**
     * Event Handler for the close event
     */
    public function closeHandlerBB(event:CloseEvent):void {
	
        //this.dispatchEvent(new Event("querySubmit"));
        //this.parentDocument.dispatchEvent(new Event("querySubmit")); 
        sendrequesttoBB.enabled = true;
        //app.submitButtonInstance = sendrequesttoBB;               
    }
    
	private function dispatchPdfEvent():void {
		this.dispatchEvent(new Event("pdf"));
	}  
  
	private function dispatchXlsEvent():void {
		this.dispatchEvent(new Event("xls"));
	}       
    
	override public function preGenerateXls():String {
    	return "smr/securityRegistrationQueryDispatch.action?method=generateXLS";
    }    
    
    override public function preGeneratePdf():String {
    	trace("within preGeneratePdf");
    	return "smr/securityRegistrationQueryDispatch.action?method=generatePDF";
    }
    
	private function dispatchBBPdfEvent():void {
    	var request:URLRequest = new URLRequest("smr/securityRegistrationQueryDispatch.action?method=generateBloombergPDF");
    	request.method = URLRequestMethod.POST;
    	// set menu pk in the request
      	var variables:URLVariables = new URLVariables();
      	variables.menuPk = this.parentApplication.mdiCanvas.getwindowKey();
      	request.data = variables;
		try {
        	navigateToURL(request,"_blank");
        } catch (e:Error) {
			trace(e);
        }
	}
  
	private function dispatchBBXlsEvent():void {
    	var request:URLRequest = new URLRequest("smr/securityRegistrationQueryDispatch.action?method=generateBloombergXLS");
    	request.method = URLRequestMethod.POST;
    	// set menu pk in the request
      	var variables:URLVariables = new URLVariables();
      	variables.menuPk = this.parentApplication.mdiCanvas.getwindowKey();
      	request.data = variables;
		try {
        	navigateToURL(request,"_blank");
        } catch (e:Error) {
			trace(e);
        }
	}     
