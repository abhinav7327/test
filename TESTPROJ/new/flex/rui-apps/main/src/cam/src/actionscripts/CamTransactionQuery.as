// ActionScript file


    import com.nri.rui.cam.validators.CamTransactionQueryValidator;
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.HiddenObject;
    
    import flash.events.IEventDispatcher;
    
    import mx.collections.ArrayCollection;
    import mx.events.ResourceEvent;
    import mx.events.ValidationResultEvent;
    import mx.resources.ResourceBundle;
    import mx.rpc.events.ResultEvent;
    
    
    [Bindable]
    private var initColl:ArrayCollection;
    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var queryResult:ArrayCollection= new ArrayCollection();
    private var emptyResult:ArrayCollection= new ArrayCollection();
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    
    private var tempColl:ArrayCollection = new ArrayCollection();
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    private function initPageStart():void {            
        if (!initCompFlg) {    
            rndNo= Math.random();
            var req : Object = new Object();
            req.SCREEN_KEY = 689;
            initializeTransactionQuery.request = req;         
            initializeTransactionQuery.url = "cam/transactionQueryDispatch.action?method=initialExecute&menuType=y&rnd=" + rndNo;                    
            initializeTransactionQuery.send(); 
                  
        } else
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.initiate'));
         
    }
    
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * 
    */  
    private function initPage(event: ResultEvent) : void {
        var i:int = 0;
        actPopUp.accountNo.text = "";
        security.instrumentId.text = "";
        fundPopUp.fundCode.text = "";
//      transactionCurrency.ccyText.text = "";
        
        errPage.clearError(event); //clears the errors if any 
        
        dateFrom.text = event.result.camTransactionQueryActionForm.fromDate != null ?  event.result.camTransactionQueryActionForm.fromDate : "";
        dateTo.text = event.result.camTransactionQueryActionForm.toDate != null ?  event.result.camTransactionQueryActionForm.toDate : "";
        if(event.result) {
            if (event.result.camTransactionQueryActionForm.transactionGroup.transactionGroupList != null) {
                if (event.result.camTransactionQueryActionForm.transactionGroup.transactionGroupList is ArrayCollection) {
                    initColl = event.result.camTransactionQueryActionForm.transactionGroup.transactionGroupList as ArrayCollection;
                } else {
                    initColl = new ArrayCollection();
                    initColl.addItem(event.result.camTransactionQueryActionForm.transactionGroup.transactionGroupList);
                }
            }
        }
            //new code
        tempColl = new ArrayCollection();           
        tempColl.addItem(" ");
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        stlTransaction.dataProvider = tempColl;
        actPopUp.accountNo.setFocus();
    }
    
    /**
    * 
    */ 
    public function submitQuery():void{
        
        //Reset Page No
         qh.resetPageNo();      
        //Set the request parameters
        var requestObj :Object = populateRequestParams();
        
        transactionQueryRequest.request = requestObj; 
        
         var myModel:Object={
                            transactionQuery:{
                                 
                                 transDateFrom:this.dateFrom.text,
                                 transDateTo:this.dateTo.text,
                                 security:this.security.instrumentId.text,
                                 /*currency:this.transactionCurrency.ccyText.text,*/
                                 accNo:this.actPopUp.accountNo.text,
                                 fundCode:this.fundPopUp.fundCode.text
                            }
                           }; 
        var transactionQueryValidator:CamTransactionQueryValidator = new CamTransactionQueryValidator();
        transactionQueryValidator.source=myModel;
        transactionQueryValidator.property="transactionQuery";
        
        var validationResult:ValidationResultEvent =transactionQueryValidator.validate();
        
         if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            //trace(errorMsg);
            XenosAlert.error(errorMsg);
        }
        else{   
        transactionQueryRequest.send();  
        }
            
    }
    
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
    
    public function resetQuery():void{
        transactionResetQueryRequest.send();
        
    }
    
    
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        reqObj.SCREEN_KEY = 690;
        reqObj.method = "submitQuery";
        
        reqObj.ourBankAccountNo = this.actPopUp.accountNo.text;
        reqObj.securityCode = this.security.instrumentId.text;
        reqObj.fundCode = this.fundPopUp.fundCode.text;
//        reqObj.currencyCode = this.transactionCurrency.ccyText.text;
        //reqObj.stlTransactionGroup = this.stlTransaction.selectedItem != null ?  this.stlTransaction.selectedItem.value : "";
        reqObj.stlTransaction = (this.stlTransaction.selectedItem != null ? this.stlTransaction.selectedItem : "");
        reqObj.fromDate = this.dateFrom.text; 
        reqObj.toDate = this.dateTo.text; 
        reqObj.rnd = Math.random() + "";
        return reqObj;
    }
    
    
    
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    /*
    public function LoadResultPage(event:ResultEvent):void {
        if (null != event) {            
            if(null == event.result.rows){
                queryResult.removeAll(); // clear previous data if any as there is no result now.
                if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
                    errPage.clearError(event); //clears the errors if any
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                } else { // Must be error
                    errPage.displayError(event);    
                }               
            }else {
                errPage.clearError(event);
                queryResult.removeAll();
                if(event.result.rows.row != null){    
                    if(event.result.rows.row is ArrayCollection) {
                        queryResult = event.result.rows.row as ArrayCollection;
                    } else {
                        queryResult.removeAll();
                        queryResult.addItem(event.result.rows.row);
                    }
                    changeCurrentState();
                }else{                    
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                } 
                 
                 //changeCurrentState();
                 qh.setOnResultVisibility();
                 qh.setPrevNextVisibility(Boolean(event.result.rows.prevTraversable),Boolean(event.result.rows.nextTraversable));
                 qh.PopulateDefaultVisibleColumns();            
            }
            //refresh the results.
            queryResult.refresh(); 
        }else {
            queryResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }
    }*/
     private function LoadResultPage(event:ResultEvent):void {
        
        //changeColumnOrder(event);
        var rs:XML = XML(event.result);
    
        if (null != event) {
            if(rs.child("row").length()>0) {
                errPage.clearError(event);
                queryResult.removeAll();
                try {
                    for each ( var rec:XML in rs.row ) {
                        queryResult.addItem(rec);
                    }
                    
                    changeCurrentState();
                    qh.setOnResultVisibility();
                    
                    qh.setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
                    qh.PopulateDefaultVisibleColumns();
             
                }catch(e:Error){
                    //XenosAlert.error(e.toString() + e.message);
                    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                }
             } else if(rs.child("Errors").length()>0) {
                //some error found
                queryResult.removeAll(); // clear previous data if any as there is no result now.
                var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list              
                for each ( var error:XML in rs.Errors.error ) {
                   errorInfoList.addItem(error.toString());
                }
                errPage.showError(errorInfoList);//Display the error
             } else {
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                queryResult.removeAll(); // clear previous data if any as there is no result now.
                errPage.removeError(); //clears the errors if any
             }
        
        }
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
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
        qh.dgrid = camTransactionQueryResult;
    }  
   /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
        var url : String = "cam/transactionQueryDispatch.action?method=generateXLS";
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
        var url : String = "cam/transactionQueryDispatch.action?method=generatePDF";
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
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
     private function doNext():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
        transactionQueryRequest.request = reqObj;
        transactionQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        transactionQueryRequest.request = reqObj;
        transactionQueryRequest.send();
    }  