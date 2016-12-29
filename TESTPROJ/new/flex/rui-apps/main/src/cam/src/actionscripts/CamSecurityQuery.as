
 // ActionScript file for Cam Movement Query
 import com.nri.rui.cam.validators.CamSecurityValidator;
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.ProcessResultUtil;
 
 import flash.net.URLRequest;
 import flash.net.URLRequestMethod;
 
 import mx.collections.ArrayCollection;
 import mx.controls.dataGridClasses.DataGridColumn;
 import mx.events.ResourceEvent;
 import mx.events.ValidationResultEvent;
 import mx.resources.ResourceBundle;
 import mx.rpc.events.ResultEvent;
 import com.nri.rui.core.containers.SummaryPopup;
 import mx.core.UIComponent;
    
    
    [Bindable]
    private var initColl:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    private var emptyResult:ArrayCollection= new ArrayCollection();
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    [Bindable]
    private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    
    
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    
    private var  csd:CustomizeSortOrder=null;
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();


    /**
     * Array to hold the Account based column order for query result.
     * The contents are the dataField property value of the data grod columns.
     */
    private const accountBasedColumns:Array = [ "view","accountPrefix", "accountName", "fundCode", "securityId", 
                                                "instrumentName", "baseDateDisp", "tradeDateDisp", "valueDateDisp",
                                                "description", "amountDisp", "formattedPrice", "balanceDisp", 
                                                "transactionRefNo"
                                              ];

    /**
     * Array to hold the Security based column order for query result.
     * The contents are the dataField property value of the data grod columns.
     */
    private const securityBasedColumns:Array = [ "view", "securityId", "instrumentName","accountPrefix", "accountName",
                                                 "fundCode",  "baseDateDisp", "tradeDateDisp", "valueDateDisp",
                                                 "description", "amountDisp", "formattedPrice", "balanceDisp", 
                                                 "transactionRefNo"
                                               ];                                          
     /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
        qh.dgrid = securitySummary;
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
            req.SCREEN_KEY = 254;
            initializeSecurityQuery.request = req;         
            initializeSecurityQuery.url = "cam/camSecurityQueryDispatch.action?method=initialExecute&rnd=" + rndNo;                    
            initializeSecurityQuery.send();        
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
        //variables to hold the default values from the server
        /* var defaultMovementBasis:String = event.result.camMovementQueryActionForm.movementBasis;
        var sortField1Default:String = event.result.camMovementQueryActionForm.sortField1;
        var sortField2Default:String = event.result.camMovementQueryActionForm.sortField2;
        var sortField3Default:String = event.result.camMovementQueryActionForm.sortField3;
         */
        errPage.clearError(event); //clears the errors if any 
        referenceNo.text = "";
        referenceNo.setFocus();
        securityDateFrom.text = event.result.camSecurityQueryActionForm.securityDateFrom;
        securityDateTo.text = event.result.camSecurityQueryActionForm.securityDateTo;
        //initiate text fields
        actPopUp.accountNo.text = "";
        instPopUp.instrumentId.text="";
        //form.text = "";
        ledgerCode.text = "";
        custodianBank.finInstCode.text = "";
        inOut.text = "";
        fundPopUp.fundCode.text = "";
        appRegiDateFrom.text = "";
        appRegiDateTo.text = "";
        updateDateFrom.text = "";
        updateDateTo.text = "";
        entryBy.employeeText.text="";
        updateBy.employeeText.text="";
        //counterPartyCode.customerCode.text="";
        
        //Initialize form.
   /*      tempColl = new ArrayCollection();  
        initColl = event.result.camSecurityQueryActionForm.formList.item as ArrayCollection;
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);            
        }
        form.dataProvider = tempColl; */
        
        //Initialize counterPartyType.
    /*     tempColl = new ArrayCollection();  
        if(event.result.camSecurityQueryActionForm.counterPartyTypes.item is ArrayCollection){ 
            initColl = event.result.camSecurityQueryActionForm.counterPartyTypes.item as ArrayCollection;
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);            
            }
        }
        else{
            tempColl.addItem(event.result.camSecurityQueryActionForm.counterPartyTypes.item); 
        }
        counterPartyType.dataProvider = tempColl; */
        
        //Initialize ledgerCodeList.
        tempColl = new ArrayCollection(); 
        initColl.removeAll();
        if (event.result.camSecurityQueryActionForm.ledgerCodeList.ledgerCode != null) {
            if (event.result.camSecurityQueryActionForm.ledgerCodeList.ledgerCode is ArrayCollection) {
                initColl = event.result.camSecurityQueryActionForm.ledgerCodeList.ledgerCode as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.camSecurityQueryActionForm.ledgerCodeList.ledgerCode);
            }
        }
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);            
        }
        ledgerCode.dataProvider = tempColl;
        
        //Initialize inOutList.
        tempColl = new ArrayCollection();   
        initColl.removeAll();
        if (event.result.camSecurityQueryActionForm.inOutList.item != null) {
            if(event.result.camSecurityQueryActionForm.inOutList.item is ArrayCollection) {
                initColl = event.result.camSecurityQueryActionForm.inOutList.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.camSecurityQueryActionForm.inOutList.item);
            }
        }
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);            
        }
        inOut.dataProvider = tempColl;

       
    } 
    
    
    /**
      * This is the method to pass the Collection of data items
      * through the context to the FinInst popup. This will be implemented as per specifdic  
      * requirement. 
      */
    private function populateFinInstRole():ArrayCollection {
    //pass the context data to the popup
    var myContextList:ArrayCollection = new ArrayCollection(); 

    var bankRoleArray : Array = new Array(1);
    bankRoleArray[0] = "Bank/Custodian";
    myContextList.addItem(new HiddenObject("bankRoles",bankRoleArray));

    return myContextList;
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
         
         securityQueryRequest.request = requestObj; 
         
         var myModel:Object={
                            security:{
                                 toSecDate:this.securityDateTo.text,
                                 fromSecDate:this.securityDateFrom.text,
                                 fromAppRegiDate:this.appRegiDateFrom.text,
                                 toAppRegiDate:this.appRegiDateTo.text,
                                 fromUpdateDate:this.updateDateFrom.text,
                                 toUpdateDate:this.updateDateTo.text           
                            }
                           };  
         var camSecurityValidate:CamSecurityValidator =new CamSecurityValidator();
        camSecurityValidate.source=myModel;
        camSecurityValidate.property="security";
        var validationResult:ValidationResultEvent =camSecurityValidate.validate(); 

        
         if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
            resultHead.text = "";
           
        }else { 
            qh.resetPageNo();
          //  resultHead.text = this.movementBasis.selectedItem.value + " " + this.parentApplication.xResourceManager.getKeyValue('cam.movementquery.label.basemovement');
            securityQueryRequest.send();   
        }                   
    } 
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
         reqObj.SCREEN_KEY = 255;
         reqObj.method = "submitQuery";
         reqObj.referenceNo = referenceNo.text;
         //reqObj.counterPartyType = this.counterPartyType.selectedItem != null ? this.counterPartyType.selectedItem.value : "";
         //reqObj.counterPartyCode = this.counterPartyCode.customerCode.text;
         reqObj.accountNo = this.actPopUp.accountNo.text;
         reqObj.securityCode = this.instPopUp.instrumentId.text ;
         //reqObj.form = this.form.selectedItem != null ? this.form.selectedItem.value : "";
         reqObj.securityDateFrom = this.securityDateFrom.text;
         reqObj.securityDateTo = this.securityDateTo.text;
         reqObj.ledgerCode = this.ledgerCode.selectedItem != null ? this.ledgerCode.selectedItem.value : "";
         reqObj.custodianBank = this.custodianBank.finInstCode.text;
         reqObj.inOut = this.inOut.selectedItem != null ? this.inOut.selectedItem.value : "";
         reqObj.fundCode = this.fundPopUp.fundCode.text;
         reqObj.appRegiDateFrom = this.appRegiDateFrom.text;
         reqObj.appRegiDateTo = this.appRegiDateTo.text;
         reqObj.updateDateFrom = this.updateDateFrom.text;
         reqObj.updateDateTo = this.updateDateTo.text;
         reqObj.entryBy = this.entryBy.employeeText.text;
         reqObj.updateBy = this.updateBy.employeeText.text;
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
        securityQueryRequest.request = reqObj;
        securityQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        securityQueryRequest.request = reqObj;
        securityQueryRequest.send();
    }   
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
     private function resetQuery():void {         
         securityResetQueryRequest.send();
    }  
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * This also takes care of the buttons/images to be shown on teh top panel of the
    * result .
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
                    summaryResult=ProcessResultUtil.process(summaryResult,securitySummary.columns);
                    summaryResult.refresh();
                    if(summaryResult.length==1){
                        displayDetailView(summaryResult[0].camEntryPk);
                    }
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
     
        //var title:String = this.parentApplication.xResourceManager.getKeyValue('cam.movement.query') + " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.query');
        //if(title!= null)
          //  this.parentDocument.title = title;
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
            XenosAlert.info("dispReturnContext CAM MOVEMENT QUERY");
        
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
        var url : String = "cam/camSecurityQueryDispatch.action?method=generateXLS";
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
        var url : String = "cam/camSecurityQueryDispatch.action?method=generatePDF";
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
    * This is for the Print button which at a  time will print all the data 
    * in the dataprovider of the Datagrid object
    */
     private function doPrint():void{
        /* var printObject:XenosPrintView = new XenosPrintView();
        printObject.frmPrintHeader.lbl.text = "Cam Movement Query";
        printObject.pDataGrid.dataProvider = movementSummary.dataProvider;
        PrintDG.printAll(printObject); */
    }
    /**
     * Change the order of the result columns depending on the value of the 
     * accountBasedFlag of the result view records.
     * 
     * @param event The ResultEvent received from the server responce after the query request.
     * 
     */
    private function changeColumnOrder(event:ResultEvent):void{
        var resultColl:ArrayCollection = new ArrayCollection();
        var arrayColl:ArrayCollection = new ArrayCollection();
        var tempArrayColl:ArrayCollection = new ArrayCollection();
        var objResult:Object;        
        
        if (null != event) {            
            if(null != event.result.rows){
                if(event.result.rows.row != null){   
                    if(event.result.rows.row is ArrayCollection) {
                            resultColl = event.result.rows.row as ArrayCollection;
                    } else {                            
                            resultColl.addItem(event.result.rows.row);
                    }
                
                    objResult = resultColl.getItemAt(0);
                    if(objResult != null){
                        arrayColl.source = securitySummary.columns;
                        tempArrayColl.source = securitySummary.columns;
                        
                        if(objResult.accountBasedFlag == true){
                            //XenosAlert.info("Account based ordering done.");
                            tempArrayColl = orderColumns(arrayColl,accountBasedColumns,tempArrayColl);
                        }else if(objResult.accountBasedFlag == false){
                            //XenosAlert.info("Security based ordering done.");                            
                            tempArrayColl = orderColumns(arrayColl,securityBasedColumns,tempArrayColl);
                        }else{
                            //XenosAlert.info("No column ordering done.");
                        }
                        securitySummary.columns = tempArrayColl.source;
                    }
            }
         }
    }
    }
    
    /**
     * This method reorders the columns based on the supplied column array. 
     * @param dgColumns      The current oredred columns.
     * @param colOrder       The column order to be done.
     * @param orderedColumns The current oredred columns which will be modified for final oredr.
     * @return               The final ordered columns.
     * 
     */
    private function orderColumns(dgColumns:ArrayCollection,colOrder:Array,orderedColumns:ArrayCollection):ArrayCollection{
        var dgc : DataGridColumn;
        var i:int=0;
        var j:int=0;
        
        for(i=0;i<dgColumns.length;i++){
            dgc = DataGridColumn(dgColumns.getItemAt(i));                                
            
            j=colOrder.indexOf(dgc.dataField);                                
            if(j != -1)
                orderedColumns.setItemAt(dgc,j);
        }
        return orderedColumns;
    }
    
     private function displayDetailView(camEntryPk:String):void{
            var sPopup : SummaryPopup;  
            sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
            
            sPopup.title = this.parentApplication.xResourceManager.getKeyValue('cam.security.query.detail.header');
            sPopup.width = 780;
            sPopup.height = 430;
            PopUpManager.centerPopUp(sPopup);
            
            sPopup.moduleUrl = Globals.CAM_SECURITY_DETAILS_SWF+Globals.QS_SIGN+Globals.CAM_ENTRY_PK+Globals.EQUALS_SIGN+camEntryPk;
    }
