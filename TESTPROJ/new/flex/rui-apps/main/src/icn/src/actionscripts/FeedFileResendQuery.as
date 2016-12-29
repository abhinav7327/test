
 // ActionScript file for Feed File Query
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.ProcessResultUtil;
    import com.nri.rui.icn.validators.FeedResendQueryValidator;
    
    import flash.events.Event;
    
    import mx.collections.ArrayCollection;
    import mx.events.ResourceEvent;
    import mx.events.ValidationResultEvent;
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
    private var tempArray : Array = new Array();
    private var rowNumArray : Array = new Array();
    private var rndNo:Number = 0;
    
    //public var trxpop : FeedFileResend;
    
    /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
        qh.dgrid = resultSummary;
    }
     
    /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGridNew():void {
        qh1.dgrid = resultSummaryNew;
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
        	app.submitButtonInstance = submit;
        	applDate.setFocus();
            rndNo= Math.random();
            var req : Object = new Object();
            req.SCREEN_KEY = 11060;
            initializeFeedQuery.request = req;         
            initializeFeedQuery.url = "icn/feedResendQueryDispatch.action?method=initialExecute&mode=resend&menuType=Y&rnd=" + rndNo;                    
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
        //applDate.text = "";
        icnRefNo.text = "";
        icnref1.visible=false;
        icnref1.includeInLayout=false;
        icnref2.visible=false;
        icnref2.includeInLayout=false;
        
        if(event.result.feedResendQueryActionForm.applicationDate!= null) {
            dateStr=event.result.feedResendQueryActionForm.applicationDate;
            if(dateStr != null)
                applDate.selectedDate = DateUtils.toDate(dateStr); 
                //XenosAlert.info("dateStr "+dateStr);               
        } else {
            XenosAlert.error("Feed Creation Date cannot be initialized.");
        }
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
        //tempColl.addItem("");
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        officeId.dataProvider = tempColl;
        
        
        // Setting values of the feed status
        initColl.removeAll();
        if(event.result.feedResendQueryActionForm.feedStatusValues.item != null) {
            if(event.result.feedResendQueryActionForm.feedStatusValues.item is ArrayCollection)
                initColl = event.result.feedResendQueryActionForm.feedStatusValues.item as ArrayCollection;
            else
                initColl.addItem(event.result.feedResendQueryActionForm.feedStatusValues.item);
        }
    
        tempColl = new ArrayCollection();
        //tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        feedStatus.dataProvider = tempColl;
        
        // Setting values of the group id
        initColl.removeAll();
        if(event.result.feedResendQueryActionForm.interfaceGroupList.interfaceGroup != null) {
            if(event.result.feedResendQueryActionForm.interfaceGroupList.interfaceGroup is ArrayCollection)
                initColl = event.result.feedResendQueryActionForm.interfaceGroupList.interfaceGroup as ArrayCollection;
            else
                initColl.addItem(event.result.feedResendQueryActionForm.interfaceGroupList.interfaceGroup);
        }
    
        tempColl = new ArrayCollection();
        //tempColl.addItem("");
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
        summaryResult.removeAll();
        summaryResult1.removeAll(); 
        btnResend.enabled = true;
        btnNew.enabled    = true;
        
        //Set the request parameters
         var requestObj :Object = populateRequestParams();
         
         var feedModel:Object={
                            feed:{
                                 officeId:(this.officeId.selectedItem != null ? officeId.selectedItem : ""),
                                 applDate:this.applDate.text,
                                 interfacegroup:(this.interfacegroup.selectedItem != null ? interfacegroup.selectedItem : "")                
                            }
                           }; 
        var feedValidator:FeedResendQueryValidator = new FeedResendQueryValidator();
        feedValidator.source=feedModel;
        feedValidator.property="feed";
         
         var validationResult:ValidationResultEvent =feedValidator.validate();
         
         if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            //trace(errorMsg);
            XenosAlert.error(errorMsg);
            //resultHead.text = "";
        }else {
         
             if(feedStatus.selectedItem.value == "SENT"){
                feedQueryRequest.request = requestObj;
                qh.resetPageNo();
                feedQueryRequest.send();
                resultSummary.visible=true;
                resultSummary.includeInLayout=true;
                qh.visible=true;
                qh.includeInLayout=true;
                resendBtn.visible=true;
                resendBtn.includeInLayout=true;
                resultSummaryNew.visible=false;
                resultSummaryNew.includeInLayout=false;
                qh1.visible=false;
                qh1.includeInLayout=false;
                sendBtnNew.visible=false;
                sendBtnNew.includeInLayout=false;
             }else if((feedStatus.selectedItem.value == "NEW") || (feedStatus.selectedItem.value == "ALL")){
                feedStatusRequest.request = requestObj;
                qh1.resetPageNo();
                feedStatusRequest.send();
                resultSummary.visible=false;
                resultSummary.includeInLayout=false;
                qh.visible=false;
                qh.includeInLayout=false;
                resultSummaryNew.visible=true;
                resultSummaryNew.includeInLayout=true;
                if(feedStatus.selectedItem.value == "ALL")
                    btnNew.label = "Send/Resend";
                else
                    btnNew.label = "Send";
                sendBtnNew.visible=true;
                sendBtnNew.includeInLayout=true;
                qh1.visible=true;
                qh1.includeInLayout=true;
                resendBtn.visible=false;
                resendBtn.includeInLayout=false;
             }
        } 
    }
    
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
     private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        reqObj.SCREEN_KEY = 11062;
        reqObj.applicationDate = this.applDate.text;
        reqObj.fundCode = this.fundPopUp.fundCode.text;
        reqObj.assetCode = this.instPopUp.instrumentId.text;
        reqObj.xnsRefNo = this.xenosRefNo.text;
        reqObj.officeId = (this.officeId.selectedItem != null ? officeId.selectedItem : "");
        reqObj.groupName = (this.interfacegroup.selectedItem != null ? interfacegroup.selectedItem : "");
        reqObj.feedStatus = (this.feedStatus.selectedItem != null ? feedStatus.selectedItem.value : "");
        reqObj.icnRefNo = this.icnRefNo.text;
        reqObj.method = "submitQuery";
      
         return reqObj;
    }
    
    //This as file contains code specific to the Check Box Selections.    
    /**
     * Used to select all records together.
     */    
    public function selectAllRecs(flag:Boolean): void {
        var i:Number = 0;
        rowNum = new ArrayCollection();
        for(i=0; i<summaryResult.length; i++){
            summaryResult[i].selected = flag;
            addOrRemove(summaryResult[i],i);
        }
        for(i=0; i<summaryResult1.length; i++){
            summaryResult1[i].selected = flag;
            addOrRemove1(summaryResult1[i],i);
        }  
        
        if(summaryResult.length>0)
        {
            summaryResult.refresh();
        }   
        else
        {
            summaryResult1.refresh();
        }
     } 
 
     
   /**
    * Determines whether the record needs to be added for New status 
    * or deleted according the selected value of teh Check Box.
    */ 
     private function addOrRemove1(item:Object,ix : int):void {
        var i:int = 0;
        var j:int = 0;
        if(item.selected == true){ // need to insert
            rowNum.addItem(item.txnGroup);                    
        }else { //need to pop   
            tempArray=rowNum.toArray();
            rowNum.removeAll();
            for(i=0; i<tempArray.length; i++){
                if(tempArray[i] != item.txnGroup){
                    rowNum.addItem(tempArray[i]);
                }
            }           
        }           
    }
    
    /**
    * Determines whether the record needs to be added for resend
    * or deleted according the selected value of teh Check Box.
    */ 
     private function addOrRemove(item:Object,ix : int):void {
        var i:int = 0;
        var j:int = 0;
        if(item.selected == true){ // need to insert
            rowNum.addItem(item.feedDetailPk);                    
                    
        }else { //need to pop   
            tempArray=rowNum.toArray();
            rowNum.removeAll();
            for(i=0; i<tempArray.length; i++){
                if(tempArray[i] != item.feedDetailPk){
                    rowNum.addItem(tempArray[i]);
                }
            }           
        }           
    } 
     
     //select function
    /**
     * Check one by one selection.
     */
    public function checkSelectToModify(item:Object,ix:int):void {
        var i:int = 0;
        addOrRemove(item,ix);
        setIfAllSelected();     
    }
     
     
    //select function
    /**
     * Check one by one selection.
     */
    public function checkSelectToModifyForNew(item:Object,ix:int):void {
        var i:int = 0;
        addOrRemove1(item,ix);
        setIfAllSelected();     
    }
    /**
     * sets all selected.
     */
    private function setIfAllSelected() : void {
        if(isAllSelected()){
            selectAllBind=true;
        } else {
            selectAllBind=false;
        }
    }

    /**
     * Checks whether all the records are selected one by one then make all selected true.
     *
     */
    private function isAllSelected(): Boolean {
        var i:int = 0;
        if(summaryResult == null){
            return false;
        }
        if(summaryResult1 == null){
            return false;
        }

        for(i=0; i<summaryResult.length; i++){
            if(summaryResult[i].selected == false) {
                return false;
            }
            //return false;
        }
        for(i=0; i<summaryResult1.length; i++){
            if(summaryResult1[i].selected == false) {
                return false;
            }
        
            //return false;
        }
        
        if(i == summaryResult.length) {
            return true;
         }else {
            return false;
        }
        
        if(i == summaryResult1.length) {
            return true;
         }else {
            return false;
        }       
        

    
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
                    resetSellection(summaryResult);
                    setIfAllSelected(); 
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
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
     private function loadSummaryPageForNew(event:ResultEvent):void {
        //changeColumnOrder(event);
        var rs:XML = XML(event.result);
        selectAllBind = false;
        rowNum.removeAll();
        if (null != event) {
            if(rs.child("summaryViewList").length()>0) {
                errPage.clearError(event);
                summaryResult1.removeAll();
                try {
                    for each ( var rec:XML in rs.summaryViewList ) {
                        summaryResult1.addItem(rec);
                    }
                    
                    changeCurrentState();
                    qh1.setOnResultVisibility();
                    
                    qh1.setPrevNextVisibility((rs.previous == "true")?true:false,(rs.next == "true")?true:false );
                    qh1.PopulateDefaultVisibleColumns();
                    //replace null objects in datagrid with empty string
                    summaryResult1=ProcessResultUtil.process(summaryResult1,resultSummaryNew.columns);
                    summaryResult1.refresh();
                    resetSellection(summaryResult1);
                    setIfAllSelected();
                    qh1.pdf.enabled = false;
                    qh1.xls.enabled = false;    
                    //qh1.print.enabled = false;
                }catch(e:Error){
                    //XenosAlert.error(e.toString() + e.message);
                    XenosAlert.error("No result found");
                }
             } else if(rs.child("Errors").length()>0) {
                //some error found
                summaryResult1.removeAll(); // clear previous data if any as there is no result now.
                var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list              
                for each ( var error:XML in rs.Errors.error ) {
                   errorInfoList.addItem(error.toString());
                }
                errPage.showError(errorInfoList);//Display the error
             } else {
                XenosAlert.info("No Result Found!");
                summaryResult1.removeAll(); // clear previous data if any as there is no result now.
                errPage.removeError(); //clears the errors if any
             }
        
        }
        
     }
     
   /**
    * It resend feed record the query. 
    * 
    */
     private function resendQry():void 
    {  
        if(rowNum.length == 0){
            XenosAlert.info("Please select at least one record");
        }else{
            btnResend.enabled = false;
            var requestObj :Object = populateRequestSendParams();
            feedRecordResend.request = requestObj;
            feedRecordResend.send()
        }
                       
    }
    
   /**
    * It send new feed 
    * 
    */
     private function resendQryForNew():void 
    {  
        if(rowNum.length == 0){
            XenosAlert.info("Please select at least one record");
        }else{
            btnNew.enabled = false;
            var requestObj :Object = populateRequestSendParamsForNew();
            feedRecordResendForNew.request = requestObj;
            feedRecordResendForNew.send()
        }
                       
    }
      private function resetSellection(summaryResult:ArrayCollection):void{
        rowNum.removeAll();
        for(var i:int=0;i<summaryResult.length;i++){
            summaryResult[i].selected = false;
            addOrRemove(summaryResult[i],i);
        }
    }     
      
    
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestSendParams():Object {
        
        var reqObj : Object = new Object();
        rowNumArray = rowNum.toArray();
        reqObj.SCREEN_KEY = 11063;
        reqObj['rowNoArray'] = rowNumArray;
        reqObj.method = "doSubmitResendEntry"; 
        return reqObj;
    } 
    
   /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestSendParamsForNew():Object {
        
        var reqObj : Object = new Object();
        rowNumArray = rowNum.toArray();
        reqObj.SCREEN_KEY = 11063;
        reqObj['rowNoArray'] = rowNumArray;
        reqObj.method = "doSubmitEntry"; 
        return reqObj;
    } 
    
    
   /**
    *Handler for Resend 
    * 
    */
    
    private function confirmHandler(event:ResultEvent):void {
        
        trxpop = FeedFileResend(PopUpManager.createPopUp(this, FeedFileResend, true));        
        trxpop.width = this.parentApplication.width - 100;
        trxpop.addEventListener("OkSystemConfirm", handleOkSystemConfirm);
        trxpop.addEventListener("enableButton", enableButton);
        var rs:XML = XML(event.result);
        
            
                var tempResult:ArrayCollection = new ArrayCollection();     
                if (null != event) {
                    trxpop.errorInfoList = new ArrayCollection();
                    if(rs.child("Errors").length()>0){ 
                        // i.e. Must be error, display it .
                        //populate the error info list              
                        for each ( var error:XML in rs.Errors.error ) {
                            //errorInfoList.addItem(error.toString());
                            trxpop.errorInfoList.addItem(error.toString());
                        }
                        
                        //trxpop.errPage.showError(errorInfoList);//Display the error
                    }else {
                        errPage.removeError();   
                        
                        for each ( var rec:XML in rs.selectedSummaryViewList.selectedSummaryViewListItem ) {
                            tempResult.addItem(rec);
                        }
                        
                        confirmResult = tempResult;  
            
                        trxpop.dProvider = confirmResult;
                        //trxpop.operationObj = opObj;
                        trxpop.formData = rs;
                    } 
                }else {
                    confirmResult.removeAll();
                    XenosAlert.info("No Results Found");
                }
        
        
        trxpop.title = "Feed Re-Send User Confirmation";
        
            
        PopUpManager.centerPopUp(trxpop);
     }
     
    public function handleOkSystemConfirm(event:Event):void {
        btnResend.enabled = true;
        btnNew.enabled    = true;
        submitQuery();
    }
    
    /**
    * Enables the Send/Resend button once the pop-up is closed.
    * Note : The buttons were disabled to prevent multiple pop-up's from being opened.
    */
     public function enableButton(event:Event):void {
       btnResend.enabled = true;
       btnNew.enabled    = true;
    }
     /**
    *Handler for Resend 
    * 
    */
    
    private function confirmHandlerForNew(event:ResultEvent):void {
        
        trxpopnew = FeedFileResendForNew(PopUpManager.createPopUp(this, FeedFileResendForNew, true));        
        trxpopnew.width = this.parentApplication.width - 100;
        trxpopnew.addEventListener("OkSystemConfirm", handleOkSystemConfirm);
        trxpopnew.addEventListener("enableButton", enableButton);
        var rs:XML = XML(event.result);
        
            
                var tempResult:ArrayCollection = new ArrayCollection();     
                if (null != event) {
                    trxpopnew.errorInfoList = new ArrayCollection();
                    if(rs.child("Errors").length()>0){ 
                        // i.e. Must be error, display it .
                        //populate the error info list              
                        for each ( var error:XML in rs.Errors.error ) {
                            trxpopnew.errorInfoList.addItem(error.toString());
                        }
                        //errPage.showError(errorInfoList);//Display the error
                        
                    }else {
                        errPage.removeError();   
                        
                        for each ( var rec:XML in rs.selectedSummaryViewList.selectedSummaryViewListItem ) {
                            tempResult.addItem(rec);
                        }
                        
                        confirmResult = tempResult;  
            
                        trxpopnew.dProvider = confirmResult;
                        //trxpop.operationObj = opObj;
                        trxpopnew.formData = rs;
                    } 
                }else {
                    confirmResult.removeAll();
                    XenosAlert.info("No Results Found");
                }
        
        if(feedStatus.selectedItem.value == "NEW"){
            trxpopnew.title = "Feed Send User Confirmation";
            trxpopnew.sysConfirmTitle = "Feed Send System Confirmation";
        } else{
            trxpopnew.title = "Feed Send/Re-Send User Confirmation";// for ALL
            trxpopnew.sysConfirmTitle = "Feed Send/Re-Send System Confirmation";//for ALL
        }
        
            
        PopUpManager.centerPopUp(trxpopnew);
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
    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
      private function doNextForNew():void { 
          //Set the request parameters
            var reqObj : Object = new Object();
            reqObj.method = "doNext";
            reqObj.rnd = Math.random()+"";
            feedStatusRequest.request = reqObj;
            feedStatusRequest.send();
    }  
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
      private function doPrevForNew():void { 
         //Set the request parameters
            var reqObj : Object = new Object();
            reqObj.method = "doPrevious";
            reqObj.rnd = Math.random()+"";
            feedStatusRequest.request = reqObj;
            feedStatusRequest.send();
    } 
    /**
    * This method selects/de-selects all the records which belong to the same group.
    */ 
    public function selectSameGroup(txnGroup:int, selFlag:Boolean):void {
            var j:Number = 0;
            for( j = 0; j < summaryResult1.length;j++){
                if(summaryResult1.getItemAt(j).txnGroup == txnGroup){
                    summaryResult1[j].selected = selFlag;
                    addOrRemove1(summaryResult1[j],j);
                    setIfAllSelected();
                }
                summaryResult1.refresh();
            }
    }
      
      
    