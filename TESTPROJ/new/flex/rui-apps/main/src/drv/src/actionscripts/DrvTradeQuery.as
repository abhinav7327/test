
 // ActionScript file for Derivative Trade Query
 
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.containers.SummaryPopup;
    import com.nri.rui.core.controls.CustomizeSortOrder;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.HiddenObject;
    import com.nri.rui.core.utils.XenosStringUtils;
    import com.nri.rui.drv.validators.DrvTradeValidator;
    import com.nri.rui.core.utils.ProcessResultUtil;

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
            initializeDrvTradeQuery.request = req;     
            initializeDrvTradeQuery.url = "drv/drvTradeQuery.action?method=initialExecute&mode=query&rnd=" + rndNo;                    
            initializeDrvTradeQuery.send();        
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
        exeBrkAccountNo.accountNo.text = "";
        securityId.instrumentId.text = "";
        underlyingSecurityId.instrumentId.text = "";
        trddateFrom.text = "";
        trddateTo.text = "";
        valuedateFrom.text = "";
        valuedateTo.text = "";
        referenceNo.text = "";
        contractReferenceNo.text = "";
        executionMarket.text = ""; 
                     
        //variables to hold the default values from the server
        var sortField1Default:String = event.result.drvTradeQueryActionForm.sortField1;
        var sortField2Default:String = event.result.drvTradeQueryActionForm.sortField2;
        var sortField3Default:String = event.result.drvTradeQueryActionForm.sortField3;
 
        
        fundPopUp.fundCode.setFocus();
        
        if(event == null || event.result == null || event.result.drvTradeQueryActionForm ==null){
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.error.cannot.initialize.form'));
            return;
        }
               
        //Population of the combo boxes
        if(event.result.drvTradeQueryActionForm.dropDownListValues!= null) {
            //1. Populate the buySellOrientation
            /* if(event.result.drvTradeQueryActionForm.dropDownListValues.buySellOrientationList != null){
                initColl.removeAll();
                if(event.result.drvTradeQueryActionForm.dropDownListValues.buySellOrientationList.item != null) {
                    if(event.result.drvTradeQueryActionForm.dropDownListValues.buySellOrientationList.item is ArrayCollection)
                        initColl = event.result.drvTradeQueryActionForm.dropDownListValues.buySellOrientationList.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.drvTradeQueryActionForm.dropDownListValues.buySellOrientationList.item);
                }
            
                tempColl = new ArrayCollection();
                
                tempColl.addItem({label:" ", value: " "});
                for(i = 0; i<initColl.length; i++) {                    
                    tempColl.addItem(initColl[i]);
                }
                buySellOrientation.dataProvider = tempColl;
            }else {
                XenosAlert.error("Buy Sell Orientation Values cannot be initialized.");
            } */
            
            //1. Populate the open close position
            if(event.result.drvTradeQueryActionForm.dropDownListValues.openClosePositionList != null){
                initColl.removeAll();
                if(event.result.drvTradeQueryActionForm.dropDownListValues.openClosePositionList.item != null) {
                    if(event.result.drvTradeQueryActionForm.dropDownListValues.openClosePositionList.item is ArrayCollection)
                        initColl = event.result.drvTradeQueryActionForm.dropDownListValues.openClosePositionList.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.drvTradeQueryActionForm.dropDownListValues.openClosePositionList.item);
                }
            
                tempColl = new ArrayCollection();
                
                tempColl.addItem({label:" ", value: " "});
                for(i = 0; i<initColl.length; i++) {                    
                    tempColl.addItem(initColl[i]);
                }
                openClosePosition.dataProvider = tempColl;
            }else {
                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.error.cannot.openclose.initialize'));
            }
            
            //1. Populate the Status List
            if(event.result.drvTradeQueryActionForm.dropDownListValues.statusList != null){
                initColl.removeAll();
                if(event.result.drvTradeQueryActionForm.dropDownListValues.statusList.item != null) {
                    if(event.result.drvTradeQueryActionForm.dropDownListValues.statusList.item is ArrayCollection)
                        initColl = event.result.drvTradeQueryActionForm.dropDownListValues.statusList.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.drvTradeQueryActionForm.dropDownListValues.statusList.item);
                }
            
                tempColl = new ArrayCollection();
                
                tempColl.addItem({label:" ", value: " "});
                for(i = 0; i<initColl.length; i++) {                    
                    tempColl.addItem(initColl[i]);
                }
                status.dataProvider = tempColl;
            }else {
                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.error.cannot.ststus.initialize'));
            }
            //setting the actionMode received fromthe action form
            actionMode = event.result.drvTradeQueryActionForm.actionMode;               
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.error.cannot.dropdown.initialize'));
        }
        
        initColl.removeAll();
        if(null != event.result.drvTradeQueryActionForm.sortFieldList1.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        	
        	if(event.result.drvTradeQueryActionForm.sortFieldList1.item is ArrayCollection)
                initColl = event.result.drvTradeQueryActionForm.sortFieldList1.item as ArrayCollection;
            else
                initColl.addItem(event.result.drvTradeQueryActionForm.sortFieldList1.item);
        	
	        for(i = 0; i<initColl.length; i++) {
	        	//Get the default value object's index
                if(XenosStringUtils.equals((initColl[i].value),sortField1Default)){                    
                    selIndx = i;
                }
	        	
	           tempColl.addItem(initColl[i]);            
	        }
	        
	        sortFieldArray[0]=sortField1;
	        sortFieldDataSet[0]=tempColl;
	        //Set the default value object
	        sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
	        
        } else {
        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.alert.value.sortorder.one'));
        }
        
        
        initColl.removeAll();
        if(null != event.result.drvTradeQueryActionForm.sortFieldList2.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        	
        	if(event.result.drvTradeQueryActionForm.sortFieldList2.item is ArrayCollection)
                initColl = event.result.drvTradeQueryActionForm.sortFieldList2.item as ArrayCollection;
            else
                initColl.addItem(event.result.drvTradeQueryActionForm.sortFieldList2.item);
        	
	        for(i = 0; i<initColl.length; i++) {
	        	//Get the default value object's index
                if(XenosStringUtils.equals((initColl[i].value),sortField2Default)){                    
                    selIndx = i;
                }
	        	
	           tempColl.addItem(initColl[i]);            
	        }
	        
	        sortFieldArray[1]=sortField2;
	        sortFieldDataSet[1]=tempColl;
	        //Set the default value object
	        sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);
	        
        } else {
        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.alert.value.sortorder.two'));
        }
        
        initColl.removeAll();
        if(null != event.result.drvTradeQueryActionForm.sortFieldList3.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        	
        	if(event.result.drvTradeQueryActionForm.sortFieldList3.item is ArrayCollection)
                initColl = event.result.drvTradeQueryActionForm.sortFieldList3.item as ArrayCollection;
            else
                initColl.addItem(event.result.drvTradeQueryActionForm.sortFieldList3.item);
        	
	        for(i = 0; i<initColl.length; i++) {
	        	//Get the default value object's index
                if(XenosStringUtils.equals((initColl[i].value),sortField3Default)){                    
                    selIndx = i;
                }
	        	
	           tempColl.addItem(initColl[i]);            
	        }
	        
	        sortFieldArray[2]=sortField3;
	        sortFieldDataSet[2]=tempColl;
	        //Set the default value object
	        sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx+1);
	        
        } else {
        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.alert.value.sortorder.three'));
        } 
        csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
        csd.init();
    }
        
     private function sortOrder1Update():void{
     	 csd.update(sortField1.selectedItem,0);
     }
     
     private function sortOrder2Update():void{     	
     	csd.update(sortField2.selectedItem,1);
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
         
        drvTradeQueryRequest.request = requestObj; 
        
        var drvTradeModel:Object={
                            drvQuery:{
                                tradeDateFrom : this.trddateFrom.text,
                                tradeDateTo : this.trddateTo.text,
                                valueDateFrom : this.valuedateFrom.text,
                                valueDateTo : this.valuedateTo.text
                            }
                           }; 
        var drvTradeValidator:DrvTradeValidator = new DrvTradeValidator();
        drvTradeValidator.source=drvTradeModel;
        drvTradeValidator.property="drvQuery";
        
        var validationResult:ValidationResultEvent = drvTradeValidator.validate();

        if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            //trace(errorMsg);
            XenosAlert.error(errorMsg);            
        }else {
            //send the submit request
            drvTradeQueryRequest.send();
        }               
    }
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        reqObj.SCREEN_KEY = 10043;
        reqObj.method = "submitQuery";
        reqObj.fundCode = fundPopUp.fundCode.text;
        reqObj.inventoryAccountNo = actPopUp.accountNo.text;
        reqObj.cpAccountNo = brkAccountNo.accountNo.text;
        reqObj.executionBrokerAccountNo = exeBrkAccountNo.accountNo.text;
        //reqObj.buySellOrientation = (this.buySellOrientation.selectedItem != null ? buySellOrientation.selectedItem.value : "");         
		reqObj.openCloseFlag = (this.openClosePosition.selectedItem != null ? openClosePosition.selectedItem.value : XenosStringUtils.EMPTY_STR);         
        reqObj.securityId = securityId.instrumentId.text;
        reqObj.underlyingSecurityId = underlyingSecurityId.instrumentId.text;
        reqObj.tradeDateFrom = trddateFrom.text;
        reqObj.tradeDateTo = trddateTo.text;
        reqObj.valueDateFrom = valuedateFrom.text;
        reqObj.valueDateTo = valuedateTo.text;
        reqObj.referenceNo = referenceNo.text;
        reqObj.contractReferenceNo = contractReferenceNo.text;
        reqObj.executionMarket = executionMarket.itemCombo.text;
        reqObj.status = (this.status.selectedItem != null ? status.selectedItem.value : XenosStringUtils.EMPTY_STR);
        reqObj.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.sortField3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : XenosStringUtils.EMPTY_STR;
     
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
        drvTradeQueryRequest.request = reqObj;
        drvTradeQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        drvTradeQueryRequest.request = reqObj;
        drvTradeQueryRequest.send();
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
        var url : String = "drv/drvTradeQuery.action?method=generateXLS";
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
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
        var url : String = "drv/drvTradeQuery.action?method=generatePDF";
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
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
    