
 // ActionScript file for Derivative Expiry Query
 
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.containers.SummaryPopup;
    import com.nri.rui.core.controls.CustomizeSortOrder;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.HiddenObject;
    import com.nri.rui.core.utils.XenosStringUtils;
    import com.nri.rui.drv.validators.DrvTradeValidator;
    import com.nri.rui.core.utils.ProcessResultUtil;
	import flash.net.URLVariables;
    import mx.collections.ArrayCollection;
    import mx.core.UIComponent;
    import mx.events.ResourceEvent;
    import mx.events.ValidationResultEvent;
    import mx.managers.PopUpManager;
    import mx.resources.ResourceBundle;
    import mx.rpc.events.ResultEvent;
    import mx.utils.StringUtil;
    
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    
    [Bindable]
    private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    public var actionMode:String = ""; // Nedded to hold value at submit time to pass in the ItemRenderer
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    private var  csd:CustomizeSortOrder=null;
	
	private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
        qh.dgrid = resultSummary;
    } 
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    private function initPageStart():void {            
        if (!initCompFlg) {    
            rndNo= Math.random();   
            var req : Object = new Object();
            req.SCREEN_KEY = 10042;
            initializeDrvExpiryQuery.request = req;     
            initializeDrvExpiryQuery.url = "drv/drvExpiryQuery.action?method=initialExecute&mode=query&SCREEN_KEY=11051&rnd=" + rndNo;                    
            initializeDrvExpiryQuery.send();        
        } else
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('drv.label.already.initiated'));
    }
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * 
    */   
    private function initPage(event: ResultEvent) : void {
        var i:int = 0;
        var selIndx:int = 0;
        var dateStr:String = null;
        var initColl:ArrayCollection = new ArrayCollection();
        var tempColl: ArrayCollection;
        
        errPage.clearError(event); //clears the errors if any 
        
        //initiate text fields
        fundPopUp.fundCode.text = "";
        actPopUp.accountNo.text = "";
        brkAccountNo.accountNo.text = "";
        securityId.instrumentId.text = "";
        contractReferenceNo.text = "";
        failReason.text = "";
        underlyingSecurityId.instrumentId.text = "";
                     
         
        fundPopUp.fundCode.setFocus();
        
        if(event == null || event.result == null || event.result.drvExpiryQueryActionForm ==null){
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.error.cannot.initialize.form'));
            return;
        }
               
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
         
        drvExpiryQueryRequest.request = requestObj; 
        
        
        //send the submit request
        drvExpiryQueryRequest.send();
                       
    }
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        reqObj.method = "submitQuery";
        reqObj.fundCode = fundPopUp.fundCode.text;
        reqObj.inventoryAccountNo = actPopUp.accountNo.text;
        reqObj.cpAccountNo = brkAccountNo.accountNo.text;
        reqObj.securityId = securityId.instrumentId.text;
        reqObj.contractReferenceNo = contractReferenceNo.text;
        reqObj.failReason = failReason.text;
        reqObj.underlyingSecurityId = underlyingSecurityId.instrumentId.text;
        reqObj['SCREEN_KEY'] = "11052";
     	reqObj.rnd = Math.random() + "";
        return reqObj;
    }
    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
     private function doNext():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
        drvExpiryQueryRequest.request = reqObj;
        drvExpiryQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        drvExpiryQueryRequest.request = reqObj;
        drvExpiryQueryRequest.send();
    }
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
    private function resetQuery():void { 
        drvResetQueryRequest.send();
    }
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    public function loadSummaryPage(event:ResultEvent):void {
        var showNext:Boolean;
        var showPrev:Boolean;
    
        if (null != event) {            
            if(null == event.result.rows){
                summaryResult.removeAll(); // clear previous data if any as there is no result now.
                if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
                    errPage.clearError(event); //clears the errors if any
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                } else { // Must be error
                    errPage.displayError(event);    
                }                
            }else {
                errPage.clearError(event);
                summaryResult.removeAll();
                if(event.result.rows.row != null){   
                    if(event.result.rows.row is ArrayCollection) {
                            summaryResult = event.result.rows.row as ArrayCollection;
                    } else {                            
                            summaryResult.addItem(event.result.rows.row);
                    }
                    changeCurrentState();
                }else{                    
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                }
                //changeCurrentState();
                
                //replace null objects 
				summaryResult=ProcessResultUtil.process(summaryResult,resultSummary.columns);
                qh.setOnResultVisibility();
                qh.setPrevNextVisibility(Boolean(event.result.rows.prevTraversable),Boolean(event.result.rows.nextTraversable));
                qh.PopulateDefaultVisibleColumns();
                
            }
            //refresh the results.        
            summaryResult.refresh(); 
        }else {
            summaryResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        } 
               
    }
    /**
     * Display the Trade Detail when there is only one record in the result.
     * 
     */  
    private function displayDetailView(resultObj:Object):void{
        
        var sPopup : SummaryPopup;  
        sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
        
        sPopup.title = this.parentApplication.xResourceManager.getKeyValue('drv.derivativetrade.title') + " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.view');
        //set the width and height of the popup
        sPopup.width = 975;
        sPopup.height = 550;
 
        sPopup.horizontalScrollPolicy="auto";
        sPopup.verticalScrollPolicy="auto";
        PopUpManager.centerPopUp(sPopup);

        var tradePk : String = resultObj.tradePk;
        var actMode : String = this.actionMode;        
        
        //Setting the Module path with some parameters which will be needed in the module for internal processing.
        sPopup.moduleUrl = Globals.DRV_TRADE_DETAILS_SWF + Globals.QS_SIGN + Globals.DRV_TRADE_PK + Globals.EQUALS_SIGN + tradePk + Globals.AND_SIGN + Globals.DRV_ACTION_MODE + Globals.EQUALS_SIGN + actMode;
            
    }    
    
    /**
     * Loading the initial configuaration.
     * 
     */
    private function loadAll():void {
    }
    /**
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specifdic  
      * requriment. 
      */
    private function populateContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
      
        //passing account type
        var acTypeArray:Array = new Array(1);
            acTypeArray[0]="T|B";            
        myContextList.addItem(new HiddenObject("invActTypeContext",acTypeArray));  
        
        //passing counter party type                
        var cpTypeArray:Array = new Array(1);
            cpTypeArray[0]="INTERNAL";
            //cpTypeArray[1]="CLIENT";
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
    
        //passing account status                
        var actStatusArray:Array = new Array(1);
        actStatusArray[0]="OPEN";
        myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
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
      
        //passing account type
        var acTypeArray:Array = new Array(1);
            acTypeArray[0]="T|B";
            
        myContextList.addItem(new HiddenObject("invActTypeContext",acTypeArray));
        
        //passing counter party type                
        var cpTypeArray:Array = new Array(1);
            cpTypeArray[0]="BROKER";
            
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
    
        //passing account status                
//        var actStatusArray:Array = new Array(1);
//        actStatusArray[0]="OPEN";
//        myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
        return myContextList;
    }
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
        var url : String = "drv/drvExpiryQuery.action?method=generateXLS";
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
        // To set menu pk in the request
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
        var url : String = "drv/drvExpiryQuery.action?method=generatePDF";
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
        // To set menu pk in the request
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
    * This is for the Print button which at a  time will print all the data 
    * in the dataprovider of the Datagrid object
    */
     private function doPrint():void{
        //Do Nothing
    }
    