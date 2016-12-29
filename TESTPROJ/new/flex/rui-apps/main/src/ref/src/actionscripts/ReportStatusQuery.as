
 // ActionScript file for Gle Journal Query
 

    import com.nri.rui.core.Globals; 
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    
    import mx.collections.ArrayCollection;
    import mx.controls.Alert;
    import mx.events.ResourceEvent;
    import mx.resources.ResourceBundle;
    import mx.rpc.events.ResultEvent;
    
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
   
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
			var req:Object = new Object();
			req.SCREEN_KEY = 11124;             
            initializeReportStatusQuery.url = "ref/reportStatusQueryDispatch.action?method=initialExecute&menuType=Y&rnd=" + rndNo;
            initializeReportStatusQuery.request = req;                    
            initializeReportStatusQuery.send();
        } else
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.alreadyinitiated'));
    }
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * 
    */   
    private function initPage(event: ResultEvent) : void {
        var i:int = 0;
        var initColl:ArrayCollection = new ArrayCollection();
        var tempColl: ArrayCollection;
        
        errPage.clearError(event);
        
        //initiate text fields
        reportReferenceNo.text = "";
        appRegiDate.text = ""; 
       
        if(event.result == null || event.result.reportStatusQueryActionForm == null){
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.reportui.msg.error.initialize.form'));
        }
       
       //ReportId
      initColl = event.result.reportStatusQueryActionForm.reportIdList.item as ArrayCollection;
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        reportId.dataProvider = tempColl;

        //tempColl.removeAll();
                
        //Status        
      initColl = event.result.reportStatusQueryActionForm.statusList.item as ArrayCollection;
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        status.dataProvider = tempColl;
        
        reportId.setFocus();

    }
    
    /**
    * It sends/submits the query. 
    * 
    */
    private function submitQuery():void 
    {  
        //Set the request parameters
        var requestObj :Object = populateRequestParams();
        
        reportStatusQueryRequest.request = requestObj; 
        qh.resetPageNo();
        //send the submit request 
        reportStatusQueryRequest.send();
                
    }
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
  private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
         reqObj.SCREEN_KEY = 11125;
        
        reqObj.method = "submitQuery";
        reqObj.reportReferenceNo = this.reportReferenceNo.text;
        reqObj.appRegiDate = this.appRegiDate.text;
        reqObj.reportId = this.reportId.selectedItem != null ?  this.reportId.selectedItem.value : "";
        reqObj.status = this.status.selectedItem != null ?  this.status.selectedItem.value : "";
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
        reportStatusQueryRequest.request = reqObj;
        reportStatusQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        reportStatusQueryRequest.request = reqObj;
        reportStatusQueryRequest.send();
    }
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
    private function resetQuery():void { 
        reportStatusResetQueryRequest.send();
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
                qh.setOnResultVisibility();
                qh.setPrevNextVisibility(Boolean(event.result.rows.prevTraversable),Boolean(event.result.rows.nextTraversable));
              //  qh.PopulateDefaultVisibleColumns();
            }
            //refresh the results.
            summaryResult.refresh();
                   
  
        }else {
            summaryResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }                
    } 
    

    /**
     * Loading the initial configuaration.
     * 
     */
    private function loadAll():void {
        
    }
 
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
        var url : String = "ref/reportStatusQueryDispatch.action?method=generateXLS";
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
        var url : String = "ref/reportStatusQueryDispatch.action?method=generatePDF";
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
    } // ActionScript file
    
 