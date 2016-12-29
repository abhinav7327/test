
 // ActionScript file for Frx Trade Query
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.containers.SummaryPopup;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.frx.validators.FrxTrdQueryValidator;
 import com.nri.rui.core.utils.ProcessResultUtil;
 
 import flash.net.URLRequest;
 import flash.net.URLRequestMethod;
 
 import mx.collections.ArrayCollection;
 import mx.core.UIComponent;
 import mx.events.ResourceEvent;
 import mx.events.ValidationResultEvent;
 import mx.resources.ResourceBundle;
 import mx.rpc.events.ResultEvent;
 import mx.utils.StringUtil;
    
    
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
            req.SCREEN_KEY = 328;
            initializeFrxTrdQuery.request = req;        
            initializeFrxTrdQuery.url = "frx/forexQueryDispatch.action?method=initialExecute&rnd=" + rndNo;                    
            initializeFrxTrdQuery.send();        
        } else
            XenosAlert.info("Already Initiated!");
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
        
        
        var sortField1Default:String = event.result.forexQueryActionForm.sortField1;
        var sortField2Default:String = event.result.forexQueryActionForm.sortField2;
        var sortField3Default:String = event.result.forexQueryActionForm.sortField3; 
        
        errPage.clearError(event); //clears the errors if any 
        
        //initiate text fields
        
        fundPopUp.fundCode.text = "";
        fundPopUp.setFocus();
        
        invActPopUp.accountNo.text = "";
        cpActPopUp.accountNo.text = "";
        cancelReferenceNo.text = "";
        trdDateFrom.text = "";
        trdDateTo.text = "";
        valueDateFrom.text = "";
        valueDateTo.text = "";
        trdCcyBox.ccyText.text = "";
        counterCcyBox.ccyText.text = "";
        referenceNo.text = "";
        status.text = "";
        creationDateFrom.text = "";
        creationDateTo.text = "";
        updateDateFrom.text = "";
        updateDateTo.text = "";
        
        //Initialize Trade Type
        initColl.removeAll(); 
        if(event.result){
            if(event.result.forexQueryActionForm.scrDisDatas.tradeTypeList.tradeTypeList !=null){
            if(event.result.forexQueryActionForm.scrDisDatas.tradeTypeList.tradeTypeList is ArrayCollection){
                initColl = event.result.forexQueryActionForm.scrDisDatas.tradeTypeList.tradeTypeList as ArrayCollection;
            }
            else {
                initColl.addItem(event.result.forexQueryActionForm.scrDisDatas.tradeTypeList.tradeTypeList);
            }
            }
            tempColl = new ArrayCollection();           
            tempColl.addItem("");
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);
            }
            tradeType.dataProvider = tempColl;
        }
        
        //Initialize Buy Sell Flag
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        selIndx = 0;
        initColl.removeAll(); 
        if(event.result){
            if(event.result.forexQueryActionForm.scrDisDatas.buySellFlagList.item !=null){
            if(event.result.forexQueryActionForm.scrDisDatas.buySellFlagList.item is ArrayCollection){
                initColl = event.result.forexQueryActionForm.scrDisDatas.buySellFlagList.item as ArrayCollection;
            }
            else {
                initColl.addItem(event.result.forexQueryActionForm.scrDisDatas.buySellFlagList.item);
            }
            } 
            for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);            
        }
        buySellFlag.dataProvider = tempColl;
        }
        //Initialize Status
        initColl.removeAll(); 
        if(event.result){
            if(event.result.forexQueryActionForm.scrDisDatas.statusList.statusList !=null){
            if(event.result.forexQueryActionForm.scrDisDatas.statusList.statusList is ArrayCollection){
                initColl = event.result.forexQueryActionForm.scrDisDatas.statusList.statusList as ArrayCollection;
            }
            else {
                initColl.addItem(event.result.forexQueryActionForm.scrDisDatas.statusList.statusList);
            }
            }
            tempColl = new ArrayCollection();           
            tempColl.addItem("");
            for(i = 0; i<initColl.length; i++) {
                if(initColl[i].toString().indexOf("object") == -1)
                tempColl.addItem(initColl[i]);
            }
            status.dataProvider = tempColl;
        }
        
        //Initialize NoExchangeFlag
        tempColl = new ArrayCollection();
        initColl.removeAll(); 
        if(event.result){
            if(event.result.forexQueryActionForm.scrDisDatas.spotRateStatusList.item !=null){
            if(event.result.forexQueryActionForm.scrDisDatas.spotRateStatusList.item is ArrayCollection){
                initColl = event.result.forexQueryActionForm.scrDisDatas.spotRateStatusList.item as ArrayCollection;
            }
            else {
                initColl.addItem(event.result.forexQueryActionForm.scrDisDatas.spotRateStatusList.item);
            }
            }
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);            
        }
        spotRateStatus.dataProvider = tempColl;
        }
        //Initialize confirmationStatus
        tempColl = new ArrayCollection();
        initColl.removeAll(); 
        if(event.result){
            if(event.result.forexQueryActionForm.scrDisDatas.confirmationStatusList.item !=null){
            if(event.result.forexQueryActionForm.scrDisDatas.confirmationStatusList.item is ArrayCollection){
                initColl = event.result.forexQueryActionForm.scrDisDatas.confirmationStatusList.item as ArrayCollection;
            }
            else {
                initColl.addItem(event.result.forexQueryActionForm.scrDisDatas.confirmationStatusList.item);
            }
            }
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);            
        }
        confirmationStatus.dataProvider = tempColl;
        }
        //Initialize sortFieldList1.
        if(null != event.result.forexQueryActionForm.sortFieldList1.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            initColl = event.result.forexQueryActionForm.sortFieldList1.item as ArrayCollection;
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
            XenosAlert.error("Sort Order Field List 1 not Populated");
        }
        
        //Initialize sortFieldList2.
        if(null != event.result.forexQueryActionForm.sortFieldList2.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx=0;
            
            initColl = event.result.forexQueryActionForm.sortFieldList2.item as ArrayCollection;
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
            XenosAlert.error("Sort Order Field List 2 not Populated");
        }
        
        //Initialize sortFieldList3.
        if(null != event.result.forexQueryActionForm.sortFieldList3.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
            
            initColl = event.result.forexQueryActionForm.sortFieldList3.item as ArrayCollection;
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
           
            csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
            csd.init();
            
        } else {
            XenosAlert.error("Sort Order Field List 3 not Populated");
        }
       
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
        private function populateInvActContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing act type                
            var actTypeArray:Array = new Array(1);
                actTypeArray[0]="T|B";
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("actTypeContext",actTypeArray));    
                      
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
        private function populateConterPartyActContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing act type                
            var actTypeArray:Array = new Array(1);
                actTypeArray[0]="T|B";
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("cpActTypeContext",actTypeArray));    
                      
            //passing counter party type                
            var cpTypeArray:Array = new Array(2);
                cpTypeArray[0]="BROKER";
                cpTypeArray[1]="BANK/CUSTODIAN";
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("actStatusContext",actStatusArray));
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
         
         FrxTrdQueryRequest.request = requestObj; 
         
        var myModel:Object={
                            frxTrd:{
                                     trdDateFrom:this.trdDateFrom.text,
                                     trdDateTo:this.trdDateTo.text,
                                     valueDateFrom:this.valueDateFrom.text,
                                     valueDateTo:this.valueDateTo.text,
                                     creationDateFrom:this.creationDateFrom.text,
                                     creationDateTo:this.creationDateTo.text,
                                     updateDateFrom:this.updateDateFrom.text,
                                     updateDateTo:this.updateDateTo.text
                                }
                           }; 
        var frxTrdQueryValidate:FrxTrdQueryValidator = new FrxTrdQueryValidator();
        frxTrdQueryValidate.source=myModel;
        frxTrdQueryValidate.property="frxTrd";
        var validationResult:ValidationResultEvent =frxTrdQueryValidate.validate();

        
        if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
            resultHead.text = "";
           
        }else {
            FrxTrdQueryRequest.send();   
        }                   
    } 
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
         reqObj.SCREEN_KEY = 329;
         reqObj.method = "submitQuery";
         reqObj.fundCode = this.fundPopUp.fundCode.text;
         reqObj.inventoryAccountNo = this.invActPopUp.accountNo.text;
         //reqObj.tradeType = this.tradeType.selectedItem != null ? this.tradeType.selectedItem.value : "";
         
         reqObj.tradeType = (String(StringUtil.trim(this.tradeType.text)).length > 0 
                                && this.tradeType.selectedItem != null) ? this.tradeType.selectedItem.value : "";
         
         reqObj.accountNo = this.cpActPopUp.accountNo.text;
         reqObj.buySellFlag = this.buySellFlag.selectedItem != null ? this.buySellFlag.selectedItem.value : "";
         reqObj.spotRateStatus = this.spotRateStatus.selectedItem != null ? this.spotRateStatus.selectedItem.value : "";
         reqObj.confirmationStatus = this.confirmationStatus.selectedItem != null ? this.confirmationStatus.selectedItem.value : "";
         reqObj.cancelReferenceNo = this.cancelReferenceNo.text;
         reqObj.tradeDateFrom = this.trdDateFrom.text;
         reqObj.tradeDateTo = this.trdDateTo.text;
         reqObj.valueDateFrom = this.valueDateFrom.text;
         reqObj.valueDateTo = this.valueDateTo.text;
         reqObj.baseCcy = this.trdCcyBox.ccyText.text;
         reqObj.againstCcy = this.counterCcyBox.ccyText.text;
         reqObj.referenceNo = this.referenceNo.text;
         //reqObj.status = this.status.selectedItem != null ? this.status.selectedItem.value : "";
         
         reqObj.status = (String(StringUtil.trim(this.status.text)).length > 0 
                            && this.status.selectedItem != null) ? this.status.selectedItem.value : "";
         
         reqObj.appRegiDateFrom = this.creationDateFrom.text;
         reqObj.appRegiDateTo = this.creationDateTo.text;
         reqObj.appUpdDateFrom = this.updateDateFrom.text;
         reqObj.appUpdDateTo = this.updateDateTo.text;
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
        FrxTrdQueryRequest.request = reqObj;
        FrxTrdQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        FrxTrdQueryRequest.request = reqObj;
        FrxTrdQueryRequest.send();
    }   
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
     private function resetQuery():void {         
         FrxTrdResetQueryRequest.send();
    }  
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * This also takes care of the buttons/images to be shown on teh top panel of the
    * result .
    */
    
    private function LoadSummaryPage(event:ResultEvent):void {
        
    var rs:XML = XML(event.result);
    
        if (null != event) {
            if(rs.child("row").length()>0) {
                errPage.clearError(event);
                summaryResult.removeAll();
                try {
                    for each ( var rec:XML in rs.row ) {
                        summaryResult.addItem(rec);
                    }
                    
                    //replace null objects with empty string
                    summaryResult=ProcessResultUtil.process(summaryResult,movementSummary.columns);
                    summaryResult.refresh();
                    
                    changeCurrentState();
                    qh.setOnResultVisibility();
                    qh.setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
                    qh.PopulateDefaultVisibleColumns();
                    if(summaryResult.length==1){
                        displayDetailView(summaryResult[0].frxTrdPk);
                     }
                    
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

    
    
    /* public function LoadSummaryPage(event:ResultEvent):void {
        var showNext:Boolean;
        var showPrev:Boolean;
        
        //changeColumnOrder(event);
        
        if (null != event) {            
            if(null == event.result.rows){
                summaryResult.removeAll(); // clear previous data if any as there is no result now.
                if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
                    errPage.clearError(event); //clears the errors if any
                    XenosAlert.info("No Result Found!");
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
                    XenosAlert.info("No Results Found");
                }                 
                
                //replace null objects with empty string
                summaryResult=ProcessResultUtil.process(summaryResult,movementSummary.columns);
                
                //changeCurrentState();
                qh.setOnResultVisibility();
                qh.setPrevNextVisibility(Boolean(event.result.rows.prevTraversable),Boolean(event.result.rows.nextTraversable));
                qh.PopulateDefaultVisibleColumns();
                if(summaryResult.length==1){
                    displayDetailView(summaryResult[0].frxTrdPk);
                 }
            }
            //refresh the results.
            summaryResult.refresh(); 
        }else {
            summaryResult.removeAll();
            XenosAlert.info("No Results Found");
        } 
               
    } */
    
     private function displayDetailView(frxTrdPk:String):void{
            
            
            var sPopup:SummaryPopup = SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
                
                sPopup.title = "Forex Trade Details";
                //set the width and height of the popup
                sPopup.width = parentApplication.width - 125;
                sPopup.height = parentApplication.height - 150;
     
                sPopup.horizontalScrollPolicy="auto";
                sPopup.verticalScrollPolicy="auto";
                PopUpManager.centerPopUp(sPopup);
        
                
                //Setting the Module path with some parameters which will be needed in the module for internal processing.
                sPopup.moduleUrl = Globals.FRX_TRADE_DETAILS_SWF + Globals.QS_SIGN + "frxTradePk" + Globals.EQUALS_SIGN + frxTrdPk;
            
    }
    
    /**
    * This is called at creationComplete of the module
    */
     private function loadAll():void {
        
        //var title:String = "Forex Trade "+" " + this.parentApplication.xResourceManager.getKeyValue('inf.title.query');
        //if(title!= null)
        //    this.parentDocument.title = title;
     } 
    
        
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
        var url : String = "frx/forexQueryDispatch.action?method=generateXLS";
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
        var url : String = "frx/forexQueryDispatch.action?method=generatePDF";
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
        /* var printObject:XenosPrintView = new XenosPrintView();
        printObject.frmPrintHeader.lbl.text = "Cam Movement Query";
        printObject.pDataGrid.dataProvider = movementSummary.dataProvider;
        PrintDG.printAll(printObject); */
    }