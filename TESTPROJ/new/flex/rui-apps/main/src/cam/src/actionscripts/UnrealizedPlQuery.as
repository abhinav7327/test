
 // ActionScript file for Unrealized Pl Query
 import com.nri.rui.cam.validators.UnrealizedPlValidator;
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.containers.SummaryPopup;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.DateUtils;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.ProcessResultUtil;
 
 import flash.net.URLRequest;
 import flash.net.URLRequestMethod;
 
 import mx.collections.ArrayCollection;
 import mx.core.UIComponent;
 import mx.events.ResourceEvent;
 import mx.events.ValidationResultEvent;
 import mx.resources.ResourceBundle;
 import mx.rpc.events.ResultEvent;
    
    
    [Bindable]
    private var initColl:ArrayCollection = new ArrayCollection();
    private var selectedResults:ArrayCollection=new ArrayCollection();   
    public var confirmSelectedResults : Array; 
    [Bindable]
    public var selectAllBind:Boolean=false;
    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    [Bindable]
    private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    private var selectedSummaryResult:ArrayCollection= new ArrayCollection();
    private var emptyResult:ArrayCollection= new ArrayCollection();
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    
    
    
   
                                             
     /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
        qh.dgrid = unrealizedPlQueryResult;
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
            req.SCREEN_KEY = 485;
            initializeUnrealizedPlQuery.request = req;         
            initializeUnrealizedPlQuery.url = "cam/unrealizedPlQueryDispatch.action?method=initialExecute&rnd=" + rndNo;                    
            initializeUnrealizedPlQuery.send();        
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
        var tempColl: ArrayCollection = new ArrayCollection();
        var dateStr:String = null;
        
        
        errPage.clearError(event); //clears the errors if any 
        
        //initiate text fields
        fundPopUp.fundCode.text = "";
        refNo.text = "";
        actPopUp.accountNo.text = "";
        instPopUp.instrumentId.text="";
        
        //Setting base date
        if(event.result.unrealizedPlQueryActionForm.baseDate!= null) {
            dateStr=event.result.unrealizedPlQueryActionForm.baseDate;
            if(dateStr != null)
                baseDate.selectedDate = DateUtils.toDate(dateStr);                
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('cam.common.prompt.init.basedate.failed'));
        }
        
        //Initialize Balance Basis.
        tempColl = new ArrayCollection();
        //tempColl.addItem({label:" ", value: " "});
        selIndx = 0;
        
        initColl.removeAll();
        if (event.result.unrealizedPlQueryActionForm.balanceTypes.item != null) {
            if (event.result.unrealizedPlQueryActionForm.balanceTypes.item is ArrayCollection) {
                initColl = event.result.unrealizedPlQueryActionForm.balanceTypes.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.unrealizedPlQueryActionForm.balanceTypes.item);
            }
        }
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);            
        }
        balanceBasis.dataProvider = tempColl;
        balanceBasis.setFocus();
        
        
        //Initialize mpNotFoundList
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        selIndx = 0;
        initColl.removeAll();
        if (event.result.unrealizedPlQueryActionForm.mpNotFoundList.item != null) {
            if (event.result.unrealizedPlQueryActionForm.mpNotFoundList.item is ArrayCollection) {
                initColl = event.result.unrealizedPlQueryActionForm.mpNotFoundList.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.unrealizedPlQueryActionForm.mpNotFoundList.item);
            }
        }
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);            
        }
        marketPriceNotFound.dataProvider = tempColl;
        
        //Initialize beyondLtdPriceNotFound
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        selIndx = 0;
               
        initColl.removeAll();
        if (event.result.unrealizedPlQueryActionForm.beyondLtdPriceList.item != null) {
            if (event.result.unrealizedPlQueryActionForm.beyondLtdPriceList.item is ArrayCollection) {
                initColl = event.result.unrealizedPlQueryActionForm.beyondLtdPriceList.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.unrealizedPlQueryActionForm.beyondLtdPriceList.item);
            }
        }
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);            
        }
        beyondLtdPriceNotFound.dataProvider = tempColl;
        
        //Initialize vendorPriceNotFound
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        selIndx = 0;
               
        initColl.removeAll();
        if (event.result.unrealizedPlQueryActionForm.vpNotFoundList.item != null) {
            if (event.result.unrealizedPlQueryActionForm.vpNotFoundList.item is ArrayCollection) {
                initColl = event.result.unrealizedPlQueryActionForm.vpNotFoundList.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.unrealizedPlQueryActionForm.vpNotFoundList.item);
            }
        }
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);            
        }
        vendorPriceNotFound.dataProvider = tempColl;
        app.submitButtonInstance = submit;
    } 
     
    /**
    * It sends/submits the query after validating the user input data. 
    * 
    */
     private function submitQuery():void 
     {  
        
         //Set the request parameters
         var requestObj :Object = populateRequestParams();
         
         unrealizedPlQueryRequest.request = requestObj; 
         
        var myModel:Object={
                            unrealizedPl:{
                                 balanceBasis:(this.balanceBasis.selectedItem !=null? this.balanceBasis.selectedItem.value : ""),
                                 baseDate:this.baseDate.text
                            }
                           }; 
        var unrealizedPlValidate:UnrealizedPlValidator =new UnrealizedPlValidator();
        unrealizedPlValidate.source=myModel;
        unrealizedPlValidate.property="unrealizedPl";
        var validationResult:ValidationResultEvent =unrealizedPlValidate.validate();

        
        if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
            //resultHead.text = "";
           
        }else {
            //Reset Page No
            qh.resetPageNo(); 
            unrealizedPlQueryRequest.send();   
        }                   
    } 
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
         reqObj.SCREEN_KEY = 486;
         reqObj.method = "submitQuery";
         reqObj.balanceBasis =(this.balanceBasis.selectedItem != null ? this.balanceBasis.selectedItem.value : "");
         reqObj.fundCode = this.fundPopUp.fundCode.text;
         reqObj.referenceNo = this.refNo.text;
         reqObj.baseDate = this.baseDate.text;
         reqObj.accountNo = this.actPopUp.accountNo.text;
         reqObj.securityId = this.instPopUp.instrumentId.text;
         reqObj.mpNotFound = (this.marketPriceNotFound.selectedItem != null ? this.marketPriceNotFound.selectedItem.value : "");
         reqObj.beyondLtdPrice = (this.beyondLtdPriceNotFound.selectedItem != null ? this.beyondLtdPriceNotFound.selectedItem.value : "");
         reqObj.vpNotFound = (this.vendorPriceNotFound.selectedItem != null ? this.vendorPriceNotFound.selectedItem.value : "");
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
        unrealizedPlQueryRequest.request = reqObj;
        unrealizedPlQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        unrealizedPlQueryRequest.request = reqObj;
        unrealizedPlQueryRequest.send();
    }   
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
     private function resetQuery():void {         
         unrealizedPlResetQueryRequest.send();
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
                    summaryResult=ProcessResultUtil.process(summaryResult,unrealizedPlQueryResult.columns);
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
        
        //var title:String = "Unrealized PL" + " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.query');
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
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
        var url : String = "cam/unrealizedPlQueryDispatch.action?method=generateXLS";
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
        var url : String = "cam/unrealizedPlQueryDispatch.action?method=generatePDF";
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
        printObject.pDataGrid.dataProvider = unrealizedPlQueryResult.dataProvider;
        PrintDG.printAll(printObject); */
    }
        
  
    
    //code specific to the Check Box Selections.
    
     private function resetSellection(summaryResult:ArrayCollection):void{
        for(var i:int=0;i<summaryResult.length;i++){
            if(!(summaryResult[i].processStatus=="READY")){
                summaryResult[i].selected = false;
            }else{
                summaryResult[i].selected = true;
            }
            if(summaryResult[i].processStatus=="READY"){
                summaryResult[i].visible = false;
            }else{
                summaryResult[i].visible = true;
            }
        }
    }
    
    public function setIfAllSelected() : void {
        if(isAllSelected()){
            
            selectAllBind=true;
        } else {
            selectAllBind=false;
        }
        
    }
    
    public function isAllSelected(): Boolean {
        var i:Number = 0;           
        if(summaryResult == null)
            return false;
            
        for(i=0; i<summaryResult.length; i++){
            if(summaryResult[i].selected == false && summaryResult[i].processStatus!="READY") {
                return false;
            }
        }
        if(i == summaryResult.length) {
            return true;
         }else {            
            return false;               
        }
    }    
    
    public function selectAllRecords(flag:Boolean): void {
        var i:Number = 0;
        selectedResults.removeAll();
        for(i=0; i<summaryResult.length; i++){
            if(summaryResult[i].processStatus=="READY"){
                summaryResult[i].selected = false;
            } else {
                summaryResult[i].selected = flag;
                addOrRemove(summaryResult[i]);
            }
            
        }
        confirmSelectedResults= selectedResults.toArray();
    }
        
     
    public function addOrRemove(item:Object):void {
        var i:Number;
        var tempArray:Array = new Array();
        if(item.selected == true){ 
            selectedResults.addItem(item.unrealizedPlPk);
           
        }else { //needs to pop
            tempArray=selectedResults.toArray();
            selectedResults.removeAll();
            for(i=0; i<tempArray.length; i++){
                if(tempArray[i] != item.unrealizedPlPk)
                    selectedResults.addItem(tempArray[i]);
            }
        }           
    }
   
    public function checkSelectToModify(item:Object):void {
        var i:Number;
       
        var tempArray:Array = new Array();
        if(item.selected == true){ // needs to insert
            selectedResults.addItem(item.unrealizedPlPk);
        }else { //needs to pop
            selectedResults.removeItemAt(item.rowIndex);
                        
        }    
        confirmSelectedResults = selectedResults.toArray();
        setIfAllSelected();             
    }
    
     
    /**
    * This method is the resultHandler for confirm action. This is required for the 
    * User Confirmation Screen to show the values in non editable form.
    */
     private function LoadSelectQueryPage():void{
        var obj:Object=new Object();
        if(confirmSelectedResults == null){
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cam.common.prompt.select.item'));
            return;
        }
        if(confirmSelectedResults != null ){
            if(confirmSelectedResults.length == 0){
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cam.common.prompt.select.item'));
                return;
            }
        }
        
        var sPopup : SummaryPopup;  
        var parentApp :UIComponent = UIComponent(this.parentApplication);
        sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
        
        sPopup.title = this.parentApplication.xResourceManager.getKeyValue('cam.unrealized.pl.query.header');
        sPopup.width = parentApplication.width - 125;
        sPopup.height = parentApplication.height - 250;
        sPopup.owner=this;
        
        PopUpManager.centerPopUp(sPopup);
        sPopup.moduleUrl = "assets/appl/cam/UnrealizedSelectPopup.swf?unrealizedPlPkArray="+confirmSelectedResults;
                
     }    
     