
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.containers.SummaryPopup;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.stl.validators.CashTransferAuthorizationQueryValidator; 
 
 import flash.net.URLRequest;
 import flash.net.URLRequestMethod;
 
 import mx.collections.ArrayCollection;
 import mx.core.UIComponent;
 import mx.events.CloseEvent;
 import mx.events.ValidationResultEvent;
 import mx.managers.PopUpManager;
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
    //[Bindable]
   // private var finContextList:ArrayCollection = new ArrayCollection();
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
    [Bindable]public var sPopup : SummaryPopup ;
   //[Bindable]
    //private var status : String = "cancel";

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
            req.SCREEN_KEY = 12054;
            initStlCashTransferAuthorizationQuery.request = req;            
            initStlCashTransferAuthorizationQuery.url = "stl/stlCashTransferAuthQueryDispatch.action?method=initialExecute&rnd=" + rndNo;                    
            initStlCashTransferAuthorizationQuery.send();        
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
     	app.submitButtonInstance = submit;
        var i:int = 0;
        var dateStr:String = null;
        var initColl:ArrayCollection = new ArrayCollection();
        var tempColl: ArrayCollection;
        var selIndx:int = 0;
        if(event.result == null || event.result.stlCashTransferAuthQueryActionForm ==null){
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.query.error.prompt.initialization.fail'));
        }
        //variables to hold the default values from the server
        var sortField1Default:String = event.result.stlCashTransferAuthQueryActionForm.sortField1;
        var sortField2Default:String = event.result.stlCashTransferAuthQueryActionForm.sortField2;
        var sortField3Default:String = event.result.stlCashTransferAuthQueryActionForm.sortField3;
        
        errPage.clearError(event); //clears the errors if any 
        //initiate text fields
        refno.text = "";
        
        //fininstPopUp.bankCode.text = "";
        //stlAccForFundPopUp.stlAccNo.text = "";
        ccyBox.ccyText.text = "";
        fundPopUp.fundCode.text = "";
        counterPartyAccount.accountNo.text = "";
        tradeDateFrom.text = "";
        tradeDateTo.text = "";
        valueDateFrom.text = "";
        valueDateTo.text = "";
        //gleledger.gleCode.text = "";
        fundPopUp.setFocus();
         
        //Setting logged on user
        loggedOnUser = event.result.stlCashTransferAuthQueryActionForm.loggedOnUser;
        //4. Setting values of the SortField1
        //initColl.removeAll();
        if(null != event.result.stlCashTransferAuthQueryActionForm.sortFieldList1.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
            
            if(event.result.stlCashTransferAuthQueryActionForm.sortFieldList1.item is ArrayCollection)
                initColl = event.result.stlCashTransferAuthQueryActionForm.sortFieldList1.item as ArrayCollection;
            else
                initColl.addItem(event.result.stlCashTransferAuthQueryActionForm.sortFieldList1.item);
            
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
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.sortorderlist1notpopulated'));
        }
        //5. Setting values of the SortField2 
        initColl.removeAll();
        if(null != event.result.stlCashTransferAuthQueryActionForm.sortFieldList2.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.stlCashTransferAuthQueryActionForm.sortFieldList2.item is ArrayCollection)
                initColl = event.result.stlCashTransferAuthQueryActionForm.sortFieldList2.item as ArrayCollection;
            else
                initColl.addItem(event.result.stlCashTransferAuthQueryActionForm.sortFieldList2.item);
                
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
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.sortorderlist2notpopulated'));
        }
        //6. Setting values of the SortField3
        initColl.removeAll();
        if(null != event.result.stlCashTransferAuthQueryActionForm.sortFieldList3.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.stlCashTransferAuthQueryActionForm.sortFieldList3.item is ArrayCollection)
                initColl = event.result.stlCashTransferAuthQueryActionForm.sortFieldList3.item as ArrayCollection;
            else
                initColl.addItem(event.result.stlCashTransferAuthQueryActionForm.sortFieldList3.item);
                
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
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.sortorderlist3notpopulated'));
        }

        csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
        csd.init();
        //set wire type
        var wireTypeColl:ArrayCollection = new ArrayCollection();
      
        if(null != event.result.stlCashTransferAuthQueryActionForm.wireTypeList.item){
            if(event.result.stlCashTransferAuthQueryActionForm.wireTypeList.item is ArrayCollection)
                wireTypeColl = event.result.stlCashTransferAuthQueryActionForm.wireTypeList.item as ArrayCollection;
            else
                wireTypeColl.addItem(event.result.stlCashTransferAuthQueryActionForm.wireTypeList.item);            
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.error.prompt.populate.wiretype'));
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<wireTypeColl.length; i++) {
            tempColl.addItem(wireTypeColl[i]);    
        }
       wireType.dataProvider = tempColl;
        //set status
        var statusColl:ArrayCollection = new ArrayCollection();
        
        if(null != event.result.stlCashTransferAuthQueryActionForm.statusList.item){
            if(event.result.stlCashTransferAuthQueryActionForm.statusList.item is ArrayCollection)
                statusColl = event.result.stlCashTransferAuthQueryActionForm.statusList.item as ArrayCollection;
            else
                statusColl.addItem(event.result.stlCashTransferAuthQueryActionForm.statusList.item);            
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.error.prompt.populate.status'));
        }
        
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<statusColl.length; i++) {
            tempColl.addItem(statusColl[i]);    
        }
       status.dataProvider = tempColl;

        // 
        initColl.removeAll();
        initColl = event.result.stlCashTransferAuthQueryActionForm.authRejectList.authReject as ArrayCollection;
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
                            summaryResult[i].showTip = this.parentApplication.xResourceManager.getKeyValue('stl.authorization.entry.tooltip');
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
        stlCashTransferAuthorizationQuery.request = reqObj;
        stlCashTransferAuthorizationQuery.send();
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
        stlCashTransferAuthorizationQuery.request = reqObj;
        stlCashTransferAuthorizationQuery.send();
     }
    /**
    * It sends/submits the query. 
    * 
    */
    public function submitQuery():void 
    {  
        //Reset Page No
        qh.resetPageNo();
        //Set the request parameters
        var requestObj :Object = populateRequestParams();
        
        stlCashTransferAuthorizationQuery.request = requestObj; 
        var myModel:Object = { adjustment : {
                                            valueToDate:this.valueDateTo.text, 
                                            valueFromDate:this.valueDateFrom.text,
                                            tradeToDate:this.tradeDateTo.text, 
                                            tradeFromDate:this.tradeDateFrom.text
                                            }
                             };
         var authorizationValidate : CashTransferAuthorizationQueryValidator = new CashTransferAuthorizationQueryValidator();
         authorizationValidate.source = myModel;
         authorizationValidate.property = "adjustment";
         var validationResult:ValidationResultEvent = authorizationValidate.validate();
         
        if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
                       
        } else {
            stlCashTransferAuthorizationQuery.send();   
        }    
    }
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        reqObj.SCREEN_KEY = 12055;
        reqObj.fromPage = "query";
        reqObj.traversableIndex = "1";
        reqObj.method = "submitQuery";
        reqObj.referenceNo = this.refno.text;
        
        reqObj.fundCode = this.fundPopUp.fundCode.text;
        //reqObj.bankCode = fininstPopUp.bankCode.text;
        //reqObj.bankAccountNo = this.stlAccForFundPopUp.stlAccNo.text;
        reqObj.currency = this.ccyBox.ccyText.text;
        reqObj.valueDateFrom = this.valueDateFrom.text;
        reqObj.valueDateTo = this.valueDateTo.text;
     	reqObj.cpAccountNo = this.counterPartyAccount.accountNo.text;        
        reqObj.tradeDateFrom = this.tradeDateFrom.text;
        reqObj.tradeDateTo = this.tradeDateTo.text;
        reqObj.wireType = this.wireType.selectedItem != null ?  this.wireType.selectedItem.value : "" ;
        reqObj.status = this.status.selectedItem != null ?  this.status.selectedItem.value : "" ;
        //reqObj.gleLedgerCode = this.gleledger.selectedItem != null ? this.gleledger.selectedItem.value : "";

        reqObj.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.sortField3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : XenosStringUtils.EMPTY_STR;

        reqObj.rnd = Math.random() + "";
        return reqObj;
    }
     
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
    private function resetQuery():void { 
        StlCashTransferAuthorizationResetQuery.send();
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
        var url : String = "stl/stlCashTransferAuthQueryDispatch.action?method=generateXLS";
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
        var url : String = "stl/stlCashTransferAuthQueryDispatch.action?method=generatePDF";
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
        var parentApp :UIComponent = UIComponent(this.parentApplication);

        if(conformSelectedResults.length > 0 ) {
            selectifAny = true;
            obj.fromPage = "queryResult";
            obj.traversableIndex = "2";
            obj.method="doPreConfirmAuthorize";
            
            for(i=0; i<conformSelectedResults.length; i++){
                authRejectArray[i] = conformSelectedResults[i].selectedValue;
                pkArray[i] = conformSelectedResults[i].cashEntryPk;
            }
            obj.selectedAuthRejectArray = null;
            obj.selectedAuthRejectArray = authRejectArray;
            obj.selectedCashEntryPkArray = null;
            obj.selectedCashEntryPkArray = pkArray;
        } else {
            selectifAny = false;
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.authorization.entry.prompt.select'));
        }
        if(selectifAny){
    	//var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
			sPopup.showCloseButton = false;			
            sPopup.addEventListener("EnterKeyEnable",enableEnterKeyOnReturn);
            sPopup.addEventListener(CloseEvent.CLOSE,closeHandler,false,0,true);
			sPopup.title = this.parentApplication.xResourceManager.getKeyValue('stl.message.cashtransfer');
    		sPopup.width = 620;
    		sPopup.height = 330;
			PopUpManager.centerPopUp(sPopup);
			sPopup.owner = this;
			sPopup.dataObj = queryResult;
			sPopup.moduleUrl = "assets/appl/stl/StlCashTransferAuthConfirmationPopup.swf"+Globals.QS_SIGN+"selectedCashEntryPkArray"+Globals.EQUALS_SIGN+pkArray+Globals.AND_SIGN+"selectedAuthRejectArray"+Globals.EQUALS_SIGN+authRejectArray;;
        }
     }  
     
     public function closeHandler(event:Event):void {
    	//this.submitQuery();
		sPopup.removeEventListener(CloseEvent.CLOSE,closeHandler);
		sPopup.removeMe();
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
    	/**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
        private function populateCounterPartyActContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing act type                
            var actTypeArray:Array = new Array(1);
                actTypeArray[0]="T|B";
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("cpActTypeContext",actTypeArray));    
                      
            //passing counter party type                
            var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="BROKER|BANK/CUSTODIAN";
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("cpCPTypeContext",cpTypeArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("actStatusContext",actStatusArray));
            return myContextList;
        }    
