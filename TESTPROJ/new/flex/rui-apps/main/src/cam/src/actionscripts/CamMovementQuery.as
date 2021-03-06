
 // ActionScript file for Cam Movement Query
 import com.nri.rui.cam.validators.MovementBalanceValidator;
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.DateUtils;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosStringUtils;
 
 import flash.net.URLRequest;
 import flash.net.URLRequestMethod;
 import flash.net.URLVariables;
 
 import mx.collections.ArrayCollection;
 import mx.controls.dataGridClasses.DataGridColumn;
 import mx.events.ValidationResultEvent;
 import mx.formatters.DateFormatter;
 import mx.rpc.events.ResultEvent;
    
    
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
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    
    
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    
    private var  csd:CustomizeSortOrder=null;
   
    /**
     * Array to hold the Account based column order for query result.
     * The contents are the dataField property value of the data grod columns.
     */
    private const accountBasedColumns:Array = [ "view", "fundCode", "accountPrefix", "accountName", "securityId", 
                                                "instrumentName", "transactionRefNo","baseDateDisp", "tradeDateDisp", "valueDateDisp",
                                                "description", "amountDisp", "formattedPrice", "balanceDisp", "principalAmount"                                                
                                              ];

    /**
     * Array to hold the Security based column order for query result.
     * The contents are the dataField property value of the data grod columns.
     */
    private const securityBasedColumns:Array = [ "view", "securityId", "instrumentName", "fundCode", "accountPrefix", 
                                                 "accountName","transactionRefNo", "baseDateDisp", "tradeDateDisp", "valueDateDisp",
                                                 "description", "amountDisp", "formattedPrice", "balanceDisp", "principalAmount"
                                               ];                                          
     /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
        qh.dgrid = movementSummary;
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
            req.SCREEN_KEY = 242;
            initializeMovementQuery.request = req;         
            initializeMovementQuery.url = "cam/camMovementQueryDispatch.action?method=initialExecute&rnd=" + rndNo;                    
            initializeMovementQuery.send();        
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
        var defaultMovementBasis:String = event.result.camMovementQueryActionForm.movementBasis;
        var sortField1Default:String = event.result.camMovementQueryActionForm.sortField1;
        var sortField2Default:String = event.result.camMovementQueryActionForm.sortField2;
        var sortField3Default:String = event.result.camMovementQueryActionForm.sortField3;
        
        errPage.clearError(event); //clears the errors if any 
        
        //initiate text fields
        actPopUp.accountNo.text = "";
//        accountFrom.text = "";
//        accountTo.text = "";
//        ccyBox.ccyText.text = "";
        instPopUp.instrumentId.text="";
        instrumentType.text = "";
//        form.text = "";
        appUpdDate.text = "";
        fundPopUp.fundCode.text = "";
                
//        initColl = event.result.camMovementQueryActionForm.acBalanceTypes.item as ArrayCollection;
//    
//        
//        tempColl.addItem({label:" ", value: " "});
//        for(i = 0; i<initColl.length; i++) {
//            tempColl.addItem(initColl[i]);    
//        
//        }
//        accountBalanceType.dataProvider = tempColl;
        
        //Initialize Movement Basis.
        tempColl = new ArrayCollection();
//        tempColl.addItem({label:" ", value: " "});
        selIndx = 0;
        initColl.removeAll();     
        if (event.result.camMovementQueryActionForm.balanceTypes.item != null) {
            if (event.result.camMovementQueryActionForm.balanceTypes.item is ArrayCollection) {
                initColl = event.result.camMovementQueryActionForm.balanceTypes.item as ArrayCollection;
           } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.camMovementQueryActionForm.balanceTypes.item);
           }    
        }
        for(i = 0; i<initColl.length; i++) {
            //Get the default value object's index
            if(XenosStringUtils.equals((initColl[i].value),defaultMovementBasis)){                    
                selIndx = i;
            }
            
            tempColl.addItem(initColl[i]);            
        }
        movementBasis.dataProvider = tempColl;
        //Set the default value object
        movementBasis.selectedItem = tempColl.getItemAt(selIndx);
        movementBasis.setFocus();
//        tempColl = new ArrayCollection();
//        tempColl.addItem({label:" ", value: " "});
//        
//        initColl = event.result.camMovementQueryActionForm.formData.item as ArrayCollection;
//        for(i = 0; i<initColl.length; i++) {
//           tempColl.addItem(initColl[i]);            
//        }
//    
//        form.dataProvider = tempColl;
        initCompFlg = true;
        
        //Setting dateFrom and dateTo
        if(event.result.camMovementQueryActionForm.dateFrom!= null && event.result.camMovementQueryActionForm.dateTo != null) {
            dateStr=event.result.camMovementQueryActionForm.dateFrom;
            if(dateStr != null)
                dateFrom.selectedDate = DateUtils.toDate(dateStr);                

            dateStr=event.result.camMovementQueryActionForm.dateTo;
            if(dateStr != null)
                dateTo.selectedDate = DateUtils.toDate(dateStr);
                                
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('cam.common.prompt.init.fromtodate.failed'));
        }
        
        //Initialize sortFieldList1.
        initColl.removeAll();
        if(null != event.result.camMovementQueryActionForm.sortFieldList1.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if (event.result.camMovementQueryActionForm.sortFieldList1.item is ArrayCollection) {
                initColl = event.result.camMovementQueryActionForm.sortFieldList1.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.camMovementQueryActionForm.sortFieldList1.item);
            }
            for(i = 0; i<initColl.length; i++) {
                //Get the default value object's index
                if(XenosStringUtils.equals((initColl[i].value),sortField1Default)){                    
                    selIndx = i;
                }
                
                   tempColl.addItem(initColl[i]);            
            }
            //sortField1.dataProvider = tempColl;
            //Set the default value object
            //sortField1.selectedItem = tempColl.getItemAt(selIndx+1);
            
            sortFieldArray[0]=sortField1;
            sortFieldDataSet[0]=tempColl;
            //Set the default value object
            sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('cam.error.prompt.populate.sortorder1'));
        }
        
        //Initialize sortFieldList2.
        initColl.removeAll();
        if(null != event.result.camMovementQueryActionForm.sortFieldList2.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx=0;
            
            if (event.result.camMovementQueryActionForm.sortFieldList2.item is ArrayCollection) {
                initColl = event.result.camMovementQueryActionForm.sortFieldList2.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.camMovementQueryActionForm.sortFieldList2.item);
            }
            for(i = 0; i<initColl.length; i++) {
                //Get the default value object's index
                if(XenosStringUtils.equals((initColl[i].value),sortField2Default)){                    
                    selIndx = i;
                }
                
                tempColl.addItem(initColl[i]);            
            }
            //sortField2.dataProvider = tempColl;
            //Set the default value object
            //sortField2.selectedItem = tempColl.getItemAt(selIndx+1);
            
            sortFieldArray[1]=sortField2;
            sortFieldDataSet[1]=tempColl;
            //Set the default value object
            sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('cam.error.prompt.populate.sortorder2'));
        }
        
        //Initialize sortFieldList3.
        initColl.removeAll();
        if(null != event.result.camMovementQueryActionForm.sortFieldList3.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
            
            if (event.result.camMovementQueryActionForm.sortFieldList3.item is ArrayCollection) {
                initColl = event.result.camMovementQueryActionForm.sortFieldList3.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.camMovementQueryActionForm.sortFieldList3.item);
            }
            for(i = 0; i<initColl.length; i++) {
                //Get the default value object's index
                if(XenosStringUtils.equals((initColl[i].value),sortField3Default)){                    
                    selIndx = i;
                }
                
                tempColl.addItem(initColl[i]);            
            }
            //sortField3.dataProvider = tempColl;
            //Set the default value object
            //sortField3.selectedItem = tempColl.getItemAt(selIndx+1);
            
            sortFieldArray[2]=sortField3;
            sortFieldDataSet[2]=tempColl;
            //Set the default value object
            sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx+1);
            
            
            //set data provider
           // sortFieldArray={sortField1,sortField2,sortField3};
           
            csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
            csd.init();
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('cam.error.prompt.populate.sortorder3'));
        }
        
//        if(null != event.result.camMovementQueryActionForm.sortField4.item){
//            tempColl = new ArrayCollection();
//            tempColl.addItem({label:" ", value: " "});
//        
//            initColl = event.result.camMovementQueryActionForm.sortField4.item as ArrayCollection;
//            for(i = 0; i<initColl.length; i++) {
//               tempColl.addItem(initColl[i]);            
//            }
//            sortField4.dataProvider = tempColl;
//        } else {
//            XenosAlert.error("Sort Order Field List 4 not Populated");
//        }
       
    } 
    
     private function sortOrder1Update():void{
         csd.update(sortField1.selectedItem,0);
     }
     
     private function sortOrder2Update():void{      
        csd.update(sortField2.selectedItem,1);
     }
     
    /**
    * It sends/submits the query after validating the user input data. 
    * 
    */
     private function submitQuery():void 
     {  
		if (!validateBaseDate()) {
			return;
		}	 
         //Reset Page No
        qh.resetPageNo();          
         //Set the request parameters
         var requestObj :Object = populateRequestParams();
         
         movementQueryRequest.request = requestObj; 
         
        var myModel:Object={
                            movement:{
                                 movBasis:(this.movementBasis.selectedItem !=null? this.movementBasis.selectedItem.value : ""),
                                 toDate:this.dateTo.text,
                                 fromDate:this.dateFrom.text,
                                 securityCode:this.instPopUp.instrumentId.text,
                                 /*ccy:this.ccyBox.ccyText.text,*/
                                 accNo:this.actPopUp.accountNo.text,
                                 /*accNoTo:this.accountTo.text,*/
                                 /*accNoFrom:this.accountFrom.text,*/
                                 instrumentType:this.instrumentType.text,
                                 appUpdDate:this.appUpdDate .text               
                            }
                           }; 
        var mobBalanceValidate:MovementBalanceValidator =new MovementBalanceValidator();
        mobBalanceValidate.source=myModel;
        mobBalanceValidate.property="movement";
        var validationResult:ValidationResultEvent =mobBalanceValidate.validate();

        
        if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
            resultHead.text = "";
           
        }else {
            
            resultHead.text = this.movementBasis.selectedItem.label.toUpperCase() + " " + this.parentApplication.xResourceManager.getKeyValue('cam.movementquery.label.basemovement');
            qh.resetPageNo();
            movementQueryRequest.send();   
        }                   
    } 
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
         reqObj.SCREEN_KEY = 245;
         reqObj.method = "submitQuery";
         reqObj.accountNo = this.actPopUp.accountNo.text;
         reqObj.dateFrom = this.dateFrom.text;
         reqObj.dateTo = this.dateTo.text;
//         reqObj.accountFrom = this.accountFrom.text;
//         reqObj.accountTo = this.accountTo.text;
         reqObj.movementBasis = (this.movementBasis.selectedItem != null ? this.movementBasis.selectedItem.value : "");
//         reqObj.currency = this.ccyBox.ccyText.text;
         reqObj.securityCode = this.instPopUp.instrumentId.text ;
         reqObj.instrumentType = this.instrumentType.itemCombo.text;
//         reqObj.form = this.form.selectedItem != null ?  this.form.selectedItem.value : "" ;
//         reqObj.accountBalanceType = (this.accountBalanceType.selectedItem != null ? this.accountBalanceType.selectedItem.value : "");
         reqObj.appUpdDate = this.appUpdDate.text;
         reqObj.fundCode = this.fundPopUp.fundCode.text;
         reqObj.sortField1 = this.sortField1.selectedItem != null ? this.sortField1.selectedItem.value : "";
         reqObj.sortField2 = this.sortField2.selectedItem != null ? this.sortField2.selectedItem.value : "";
         reqObj.sortField3 = this.sortField3.selectedItem != null ? this.sortField3.selectedItem.value : "";
//         reqObj.sortField4 = this.sortField4.selectedItem != null ? this.sortField4.selectedItem.value : "";
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
        movementQueryRequest.request = reqObj;
        movementQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        movementQueryRequest.request = reqObj;
        movementQueryRequest.send();
    }   
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
     private function resetQuery():void {         
         movementResetQueryRequest.send();
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
                    summaryResult=ProcessResultUtil.process(summaryResult,movementSummary.columns);
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
        
        //var title:String = this.parentApplication.xResourceManager.getKeyValue('cam.movement.query') + " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.query');
        //if(title!= null)
        //    this.parentDocument.title = title;
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
        var url : String = "cam/camMovementQueryDispatch.action?method=generateXLS";
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
        var variables:URLVariables = new URLVariables();
        trace("Menu Pk in XLS using parent application: " + this.parentApplication.mdiCanvas.getwindowKey());
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
        var url : String = "cam/camMovementQueryDispatch.action?method=generatePDF";
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
        var variables:URLVariables = new URLVariables();
        trace("Menu Pk in PDF using parent application: " + this.parentApplication.mdiCanvas.getwindowKey());
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
                        arrayColl.source = movementSummary.columns;
                        tempArrayColl.source = movementSummary.columns;
                        
                        if(objResult.accountBasedFlag == true){
                            //XenosAlert.info("Account based ordering done.");
                            tempArrayColl = orderColumns(arrayColl,accountBasedColumns,tempArrayColl);
                        }else if(objResult.accountBasedFlag == false){
                            //XenosAlert.info("Security based ordering done.");                            
                            tempArrayColl = orderColumns(arrayColl,securityBasedColumns,tempArrayColl);
                        }else{
                            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cam.common.prompt.no.column.ordering'));
                        }
                        movementSummary.columns = tempArrayColl.source;
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
	
	private function validateBaseDate():Boolean {
		
		// Remove errors
		errPage.removeError();
		
		var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
		var matches:XMLList = app.cachedItems.retentionDates.date.(@component == "CAM");
		trace("matches : " + matches.toXMLString());
		if (matches == null || matches.length() == 0) {
			return true;
		}		
		var retentionDate:String = matches[0].@value;
		trace("retentionDate : " + retentionDate);

		var errors:ArrayCollection = new ArrayCollection();
		var dateLabel:String = this.parentApplication.xResourceManager.getKeyValue('cam.movementquery.label.statementperiodfromto');
		var dateValue:String = this.dateFrom.text;
		trace("dateLabel: " + dateLabel);
		trace("dateValue: " + dateValue);
		
		var year:Number = parseInt(dateValue.substring(0, 4));
		var month:Number = parseInt(dateValue.substring(4, 6)) - 1;
		var date:Number = parseInt(dateValue.substring(6, 8));
		trace("new Date(year, month, date): " + new Date(year, month, date));

		if (new Date(year, month, date).getTime() < new Date(retentionDate).getTime()) {
		
			var formatter:DateFormatter = new DateFormatter();
			formatter.formatString = "YYYYMMDD";
			var retentionDateStr:String = formatter.format(retentionDate);
			var msg:String = dateLabel + " is less than Retention Start Date - [" + retentionDateStr + "].";
			errors.addItem(msg);
		}
			
		if (errors.length > 0) {
			errPage.showError(errors);
			return false;
		}
		return true;
		
	}	
