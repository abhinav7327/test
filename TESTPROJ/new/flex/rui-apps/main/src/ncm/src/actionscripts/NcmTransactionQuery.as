
 // ActionScript file for Ncm Movement Query
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.DateUtils;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.ncm.validators.NcmTransactionQueryValidator;
 
 import flash.net.URLRequest;
 import flash.net.URLRequestMethod;
 
 import mx.collections.ArrayCollection;
 import mx.controls.dataGridClasses.DataGridColumn;
 import mx.events.ResourceEvent;
 import mx.events.ValidationResultEvent;
 import mx.resources.ResourceBundle;
 import mx.rpc.events.ResultEvent;
    
    
    [Bindable]
    private var initColl:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var stlTransactionList:ArrayCollection;
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
            req.SCREEN_KEY = 691;   
            initializeTransactionQuery.request = req;     
            initializeTransactionQuery.url = "ncm/transactionQueryDispatch.action?method=initialExecute&rnd=" + rndNo;                    
            initializeTransactionQuery.send();        
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
        var sortField1Default:String = event.result.ncmTransactionQueryActionForm.sortField1;
        var sortField2Default:String = event.result.ncmTransactionQueryActionForm.sortField2;
        var sortField3Default:String = event.result.ncmTransactionQueryActionForm.sortField3;
        
        errPage.clearError(event); //clears the errors if any 
        
        //initiate text fields
        actPopUp.accountNo.text = "";
        actPopUp.accountNo.setFocus();
        ccyBox.ccyText.text = "";
        instPopUp.instrumentId.text="";
                
        
        initCompFlg = true;
        
        //fundCode
        fundPopUp.fundCode.text="";
        fundPopUp.fundCode.setFocus();
        
        //Setting dateFrom and dateTo
        if(event.result.ncmTransactionQueryActionForm.defaultDateFrom!= null && event.result.ncmTransactionQueryActionForm.defaultDateTo != null) {
            dateStr=event.result.ncmTransactionQueryActionForm.defaultDateFrom;
            if(dateStr != null)
                dateFrom.selectedDate = DateUtils.toDate(dateStr);                

            dateStr=event.result.ncmTransactionQueryActionForm.defaultDateTo;
            if(dateStr != null)
                dateTo.selectedDate = DateUtils.toDate(dateStr);
                                
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ncm.query.error.prompt.fromto.date'));
        }
        
        //Setting stl Transaction Group List
        if(event.result){
            if(event.result.ncmTransactionQueryActionForm.stlTransactionGroupList.stlTransactionGroup is ArrayCollection){
                initColl = event.result.ncmTransactionQueryActionForm.stlTransactionGroupList.stlTransactionGroup as ArrayCollection;

            }
            else {
                initColl = new ArrayCollection();
                /* stlTransactionList.addItem({label:" ", value: " "});
                stlTransactionList.addItem(event.result.ncmTransactionQueryActionForm.stlTransactionGroupList.stlTransactionGroup); */
                initColl.addItem(event.result.ncmTransactionQueryActionForm.stlTransactionGroupList.stlTransactionGroup);
            }
            tempColl = new ArrayCollection();           
            tempColl.addItem("");
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);
            }
            stlTransaction.dataProvider = tempColl;
        }
        
        //Initialize sortFieldList1.
        initColl.removeAll();
        if(null != event.result.ncmTransactionQueryActionForm.sortFieldList1.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if (event.result.ncmTransactionQueryActionForm.sortFieldList1.item is ArrayCollection) {
                initColl = event.result.ncmTransactionQueryActionForm.sortFieldList1.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.ncmTransactionQueryActionForm.sortFieldList1.item);
            }
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
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ncm.error.prompt.populate.sortorder1'));
        }
        
        //Initialize sortFieldList2.
        initColl.removeAll();
        if(null != event.result.ncmTransactionQueryActionForm.sortFieldList2.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx=0;
            
            if (event.result.ncmTransactionQueryActionForm.sortFieldList2.item is ArrayCollection) {
                initColl = event.result.ncmTransactionQueryActionForm.sortFieldList2.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.ncmTransactionQueryActionForm.sortFieldList2.item);
            }
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
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ncm.error.prompt.populate.sortorder2'));
        }
        
        //Initialize sortFieldList3.
        initColl.removeAll();
        if(null != event.result.ncmTransactionQueryActionForm.sortFieldList3.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
            
            if (event.result.ncmTransactionQueryActionForm.sortFieldList3.item is ArrayCollection) {
                initColl = event.result.ncmTransactionQueryActionForm.sortFieldList3.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.ncmTransactionQueryActionForm.sortFieldList3.item);
            }
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
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ncm.error.prompt.populate.sortorder3'));
        }
        
       
    } 
    
     private function sortOrder1Update():void{
         csd.update(sortField1.selectedItem,0);
     }
     
     private function sortOrder2Update():void{      
        csd.update(sortField2.selectedItem,1);
     }
     
      /**
    * 
    */ 
    public function submitQuery():void{
        
		var dateLabel:String = this.parentApplication.xResourceManager.getKeyValue('ref.label.app_regi_date.from_to');
		var dateValue:String = this.dateFrom.text;
		if (!DateUtils.validateBaseDate(errPage, "NCM", dateLabel, dateValue)) {
			return;
		}
        //Reset Page No
         qh.resetPageNo();
        //Set the request parameters
        var requestObj :Object = populateRequestParams();
        
        transactionQueryRequest.request = requestObj; 
        
         var myModel:Object={
                            transactionQuery:{
                                 entryDateFrom:this.dateFrom.text,
                                 entryDateTo:this.dateTo.text,
                                 security:this.instPopUp.instrumentId.text,
                                 currency:this.ccyBox.ccyText.text,
                                 accNo:this.actPopUp.accountNo.text
                                 
                            }
                           }; 
        var transactionQueryValidator:NcmTransactionQueryValidator = new NcmTransactionQueryValidator();
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
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
     private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
         reqObj.SCREEN_KEY = 692;
         reqObj.method = "submitQuery"; 
         reqObj.fundCode = this.fundPopUp.fundCode.text;
         reqObj.accountNo = this.actPopUp.accountNo.text;
         reqObj.dateFrom = this.dateFrom.text;
         reqObj.dateTo = this.dateTo.text;
         reqObj.securityCode = this.instPopUp.instrumentId.text;
         reqObj.currency = this.ccyBox.ccyText.text;
         reqObj.stlTransactionGroup = (this.stlTransaction.selectedItem != null ? this.stlTransaction.selectedItem : "");
         reqObj.sortField1 = this.sortField1.selectedItem != null ? this.sortField1.selectedItem.value : XenosStringUtils.EMPTY_STR;
         reqObj.sortField2 = this.sortField2.selectedItem != null ? this.sortField2.selectedItem.value : XenosStringUtils.EMPTY_STR;
         reqObj.sortField3 = this.sortField3.selectedItem != null ? this.sortField3.selectedItem.value : XenosStringUtils.EMPTY_STR;
         
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
    public function loadSummaryPage(event:ResultEvent):void {
        var showNext:Boolean;
        var showPrev:Boolean;
        
        /* changeColumnOrder(event); */
        
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
                
                //changeCurrentState();
                qh.setOnResultVisibility();
                qh.setPrevNextVisibility(Boolean(event.result.rows.prevTraversable),Boolean(event.result.rows.nextTraversable));
                qh.PopulateDefaultVisibleColumns();
            }
            //refresh the results.
            summaryResult.refresh(); 
        }else {
            summaryResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        } 
               
    }
    
    /**
    * This is called at creationComplete of the module
    */
     private function loadAll():void {
                
        //var title:String = "Entry Date Based Transaction" + " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.query');
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
            var cpTypeArray:Array = new Array(2);
            cpTypeArray[0]="BANK/CUSTODIAN";
            cpTypeArray[1]="BROKER";    
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
        var url : String = "ncm/transactionQueryDispatch.action?method=generateXLS";
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
        var url : String = "ncm/transactionQueryDispatch.action?method=generatePDF";
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
        printObject.frmPrintHeader.lbl.text = "ncm Movement Query";
        printObject.pDataGrid.dataProvider = movementSummary.dataProvider;
        PrintDG.printAll(printObject); */
    }     
    
