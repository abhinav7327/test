
 // ActionScript file for Feed File Query
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.ProcessResultUtil;
    
    import mx.collections.ArrayCollection;
    import mx.events.ResourceEvent;
    import mx.resources.ResourceBundle;
    import mx.rpc.events.ResultEvent;
    
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    private var initCompFlg : Boolean = false;
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    [Bindable]
    private var summaryResult1:ArrayCollection= new ArrayCollection();
    [Bindable]
    private var confirmResult:ArrayCollection= new ArrayCollection();
    //For check box
    [Bindable]
    public var selectAllBind:Boolean=false;
    public var rowNum : ArrayCollection=new ArrayCollection();
    [Bindable]
    public var selectedRdArray : Array = new Array();
    private var tempArray : Array = new Array();
    private var rowNumArray : Array = new Array();
    
    //public var trxpop : FeedFileResend;
    
    /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
        qh.dgrid = resultSummary;
    } 
    
    
    /**
     * Loading the initial configuaration.
     * 
     */
    private function loadAll():void {        
        //load();
    }
    
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    private function initPageStart():void {            
        if (!initCompFlg) {    
        	applDate.setFocus();
            //rndNo= Math.random();
            var req : Object = new Object();
            req.SCREEN_KEY = 11059;
            initializeFeedQuery.request = req;         
            initializeFeedQuery.url = "icn/feedResendQueryDispatchforQuery.action?method=initialExecute&mode=query&menuType=Y" ;                    
            initializeFeedQuery.send();        
        } else
            XenosAlert.info("Already Initiated!");
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
        
               
        instPopUp.instrumentId.text="";
        fundPopUp.fundCode.text = "";
        xenosRefNo.text = "";
        applDate.text = "";
        icnRefNo.text = "";
        userIdPopUp.employeeText.text = "";

        applDate.setFocus();
        
        // Setting values of the officeId
        initColl.removeAll();
        if(event.result.feedResendQueryActionForm.officeIdValues.officeId != null) {
            if(event.result.feedResendQueryActionForm.officeIdValues.officeId is ArrayCollection)
                initColl = event.result.feedResendQueryActionForm.officeIdValues.officeId as ArrayCollection;
            else
                initColl.addItem(event.result.feedResendQueryActionForm.officeIdValues.officeId);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem("");
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        officeId.dataProvider = tempColl;
        
        
        // Setting values of the group id
        initColl.removeAll();
        if(event.result.feedResendQueryActionForm.interfaceGroupList.interfaceGroup != null) {
            if(event.result.feedResendQueryActionForm.interfaceGroupList.interfaceGroup is ArrayCollection)
                initColl = event.result.feedResendQueryActionForm.interfaceGroupList.interfaceGroup as ArrayCollection;
            else
                initColl.addItem(event.result.feedResendQueryActionForm.interfaceGroupList.interfaceGroup);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem("");
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        interfacegroup.dataProvider = tempColl;
        
        
        
        if(event == null || event.result == null || event.result.feedResendQueryActionForm ==null){
            XenosAlert.error("Failed to Initialize the Form");
            return;
        }        
        
    }
    
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
     private function resetQuery():void { 
        feedResetQueryRequest.send();
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
         
      
            feedQueryRequest.request = requestObj;
            qh.resetPageNo();
            feedQueryRequest.send();
            resultSummary.visible=true;
            resultSummary.includeInLayout=true;
    }
    
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
     private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        reqObj.SCREEN_KEY = 11061;
        reqObj.applicationDate = this.applDate.text;
        reqObj.fundCode = this.fundPopUp.fundCode.text;
        reqObj.assetCode = this.instPopUp.instrumentId.text;
        reqObj.xnsRefNo = this.xenosRefNo.text;
        reqObj.officeId = (this.officeId.selectedItem != null ? officeId.selectedItem : "");
        reqObj.groupName = (this.interfacegroup.selectedItem != null ? interfacegroup.selectedItem : "");
        reqObj.icnRefNo = this.icnRefNo.text;
        reqObj.userId = this.userIdPopUp.employeeText.text;
        reqObj.method = "submitQuery";
         return reqObj;
    }
    
   
    
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
     private function loadSummaryPage(event:ResultEvent):void {
        //changeColumnOrder(event);
        var rs:XML = XML(event.result);
        selectAllBind = false;
        rowNum.removeAll();
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
                    summaryResult=ProcessResultUtil.process(summaryResult,resultSummary.columns);
                    summaryResult.refresh();
                    qh.pdf.enabled = false;
                    qh.xls.enabled = false;
                    //qh.print.enabled = false;
                }catch(e:Error){
                    //XenosAlert.error(e.toString() + e.message);
                    XenosAlert.error("No result found");
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
                XenosAlert.info("No Result Found!");
                summaryResult.removeAll(); // clear previous data if any as there is no result now.
                errPage.removeError(); //clears the errors if any
             }
        
        }
        
     }
     
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
        
    } 
    /**
    * This will generate the Pdf report for the entire query result set 
    * and will open in a separate window.
    */
     private function generatePdf():void {

    } 
    /**
    * This is for the Print button which at a  time will print all the data 
    * in the dataprovider of the Datagrid object
    */
     private function doPrint():void{
        
    }
    
    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
      private function doNext():void { 
         var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
        feedQueryRequest.request = reqObj;
        feedQueryRequest.send();
     
    }  
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
      private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        feedQueryRequest.request = reqObj;
        feedQueryRequest.send();
      
    } 