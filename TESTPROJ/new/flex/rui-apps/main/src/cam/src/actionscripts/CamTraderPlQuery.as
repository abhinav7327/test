
 // ActionScript file for Cam Trader Pl Query
 import com.nri.rui.cam.validators.TraderPlValidator;
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.ProcessResultUtil;

 import flash.net.URLRequest;
 import flash.net.URLRequestMethod;
 
 import mx.collections.ArrayCollection;
 import mx.events.ResourceEvent;
 import mx.events.ValidationResultEvent;
 import mx.formatters.NumberBase;
 import mx.resources.ResourceBundle;
 import mx.rpc.events.ResultEvent;
 import mx.utils.ObjectUtil;
    
    
    [Bindable]
    private var initColl:ArrayCollection;
    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    private var emptyResult:ArrayCollection= new ArrayCollection();
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    private var formApplicatiodate:String = "";//To hold the applicationdate from the server    
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();

    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    
    /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
        qh.dgrid = traderPlSummary;
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
            req.SCREEN_KEY = 630;
            initializeTraderPlQuery.request = req;         
            initializeTraderPlQuery.url = "cam/traderPlQueryDispatch.action?method=initialExecute&rnd=" + rndNo;                    
            initializeTraderPlQuery.send();        
        } else
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.initiate'));
     } 
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * Once initial data is fetched from database to fill some form data, this method works
    * to actually show the data.
    */   
     private function initPage(event: ResultEvent) : void {
        var i:int = 0;
        var selIndx:int = 0;
        var dateStr:String = null;
        var tempColl: ArrayCollection = new ArrayCollection();
        
        errPage.clearError(event); //clears the errors if any 
        
        //initiate text fields
        actPopUp.accountNo.text = "";
        issueCcyBox.ccyText.text = "";
        instPopUp.instrumentId.text="";
        fundPopUp.fundCode.text = "";
        
        formApplicatiodate = "";        
        
        //Initialize Balance Types.
        tempColl = new ArrayCollection();        
        //tempColl.addItem({label:" ",value:" "});
               
        if(event.result.traderPLQueryActionForm.balanceTypes.item is ArrayCollection){
            initColl = event.result.traderPLQueryActionForm.balanceTypes.item;
        }else{
            initColl = new ArrayCollection();
            initColl.addItem(event.result.traderPLQueryActionForm.balanceTypes.item);
        }        
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);            
        }
        balanceType.dataProvider = tempColl;
        
        formApplicatiodate = event.result.traderPLQueryActionForm.applicationDate;
        
        initCompFlg = true;
    } 
    /**
     * It sends/submits the query after validating the user input data. 
     * 
     */
     private function submitQuery():void 
     {    
         //Reset Page No
         qh.resetPageNo();         
         //Set the request parameters
         var requestObj :Object = populateRequestParams();
         
        traderPlQueryRequest.request = requestObj; 
         
        var dataValidationModel:Object={
                           traderPl:{
                                 balanceType:(this.balanceType.selectedItem != null? this.balanceType.selectedItem.value : ""),
                                 accountNo:this.actPopUp.accountNo.text,
                                 securityId:this.instPopUp.instrumentId.text               
                            }
                           }; 
        var traderPlvalidator:TraderPlValidator =new TraderPlValidator();
        traderPlvalidator.source=dataValidationModel;
        traderPlvalidator.property="traderPl";
        var validationResult:ValidationResultEvent=traderPlvalidator.validate();
        
        if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
            resultHead.text = "";
        }else {            
            resultHead.text = dataValidationModel.traderPl.balanceType + " " + this.parentApplication.xResourceManager.getKeyValue('cam.traderpl.label.based') + " "
                                                                             + this.parentApplication.xResourceManager.getKeyValue('cam.traderplquery.label.traderpl') + " "
                                                                             + formApplicatiodate;
            qh.resetPageNo();
            
            traderPlQueryRequest.send();   
        }                   
    } 
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
         var reqObj : Object = new Object();
         reqObj.SCREEN_KEY = 631;
         reqObj.method = "submitQuery";
         
         reqObj.balanceType = (this.balanceType.selectedItem != null ? this.balanceType.selectedItem.value : "");
         reqObj.fundCode = this.fundPopUp.fundCode.text;
         reqObj.accountNo = this.actPopUp.accountNo.text;
         reqObj.securityId = this.instPopUp.instrumentId.text;
         reqObj.settlementCcy = this.issueCcyBox.ccyText.text;
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
        traderPlQueryRequest.request = reqObj;
        traderPlQueryRequest.send();
    } 
    /**
     * This method sends the HttpService for Previous Set of results operation.
     * This is actually server side pagination for the previous set of results.
     */ 
    private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        traderPlQueryRequest.request = reqObj;
        traderPlQueryRequest.send();
    }   
    /**
     * This method sends the HttpService for reset operation.
     */
    private function resetQuery():void {         
        traderPlResetQueryRequest.send();
    }  
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * This also takes care of the buttons/images to be shown on the top panel of the
    * result.
    */
     private function LoadSummaryPage(event:ResultEvent):void {
        
        //changeColumnOrder(event);
        var rs:XML = XML(event.result);
    
        if (null != event) {
            if(rs.child("row").length()>0) {
                errPage.clearError(event);
                summaryResult.removeAll();
                try {
                    for each ( var rec:XML in rs.row ) {
                        summaryResult.addItem(rec);
                    }
                    
                    changeCurrentState();
                    qh.setOnResultVisibility();
                    
                    qh.setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
                    qh.PopulateDefaultVisibleColumns();
                    //replace null objects in datagrid with empty string
                    summaryResult=ProcessResultUtil.process(summaryResult,traderPlSummary.columns);
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
    * This is called at creationComplete of the module
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
      
        //passing counter party type                
        var cpTypeArray:Array = new Array(1);
            cpTypeArray[0]="INTERNAL";
            
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
    
        //passing account status                
        var actStatusArray:Array = new Array(1);
        actStatusArray[0]="OPEN";
        myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
        return myContextList;
    }
                
                
    /**
     * This is the method to access the Collection of data items receive
     * through the context from the account popup. This will be implemented as per specifdic  
     * requriment. 
     */
    public function showReturnContext(retCtxItem:ArrayCollection):void {
        /*
        This is sample implemetation
         XenosAlert.info("showReturnContext");
    
        for (var i:int = 0; i<returnContextItem.length; i++){
            
            XenosAlert.info("index :: "+ i);
            
            var itemObject:HiddenObject;
            
            itemObject = HiddenObject (returnContextItem.getItemAt(i));
            
            XenosAlert.info("hidden property :: "+ itemObject.m_propertyName );
            
            var propertyValues:Array = itemObject.m_propertyValues;
            
            for (var j:int = 0; j<propertyValues.length; j++){
                XenosAlert.info("hidden values :: " + propertyValues[j]);
            }
        }
        */
    }
        
    public function dispReturnContext(retCtxItem:ArrayCollection):void {        
       
        // This is sample implemetation
        XenosAlert.info("dispReturnContext CAM TRADER PL QUERY");
    
        for (var i:int = 0; i<retCtxItem.length; i++){
            
            XenosAlert.info("index :: "+ i);
            
            var itemObject:HiddenObject;
            
            itemObject = HiddenObject (retCtxItem.getItemAt(i));
            
            XenosAlert.info("hidden property :: "+ itemObject.m_propertyName );
            
            var propertyValues:Array = itemObject.m_propertyValues;
            
            for (var j:int = 0; j<propertyValues.length; j++){
                XenosAlert.info("hidden values :: " + propertyValues[j]);
            }
        }
            
    }
    /**
     * This will generate the Xls report for the entire query result set 
     * and will open in a separate window.
     */
    private function generateXls():void {
        var url : String = "cam/traderPlQueryDispatch.action?method=generateXLS";
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
        try {
            navigateToURL(request,"_blank");
        }catch (e:Error) {
            // handle error here
            trace(e);
        }
    } 
    /**
     * This will generate the Pdf report for the entire query result set 
     * and will open in a separate window.
     */
    private function generatePdf():void {
        var url : String = "cam/traderPlQueryDispatch.action?method=generatePDF";
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
        try {
                navigateToURL(request,"_blank");
        }catch(e:Error) {
             // handle error here
             trace(e);
        }
    } 
    /**
     * This is for the Print button which at a  time will print all the data 
     * in the dataprovider of the Datagrid object
     */
    private function doPrint():void{
        
    }    
    /**
     * Number Comparator function
     */  
    private function numaricCompareFunc(itemA:Object, itemB:Object):int {
        var dataFormatter:NumberBase = new NumberBase(".",",",
                                                      ".",",");
        var valueA:Number = Number(dataFormatter.parseNumberString(itemA.formattedQuantity));
        var valueB:Number = Number(dataFormatter.parseNumberString(itemB.formattedQuantity));
        return ObjectUtil.numericCompare(valueA, valueB);
    }