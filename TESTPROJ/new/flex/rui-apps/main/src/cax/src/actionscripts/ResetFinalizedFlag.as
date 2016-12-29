// ActionScript file

 // ActionScript file for Cax Revert Cxl Flag
 
 import com.nri.rui.cax.validator.ResetFinalizedFlagValidator;
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.containers.SummaryPopup;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosPopupUtils;
 import com.nri.rui.core.utils.XenosStringUtils;
 
 import mx.collections.ArrayCollection;
 import mx.core.UIComponent;
 import mx.events.CloseEvent;
 import mx.events.ListEvent;
 import mx.events.ValidationResultEvent;
 import mx.managers.PopUpManager;
 import mx.rpc.events.ResultEvent;
 import mx.utils.StringUtil;
 
    // mode to indicate operation mode like Query/Delete
    [Bindable]private var mode:String="";
    
    [Bindable]
    private var initColl:ArrayCollection;
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    [Bindable]
    private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    private var  csd:CustomizeSortOrder=null;
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    private var selectedResults:ArrayCollection=new ArrayCollection(); 
    private var selectedFlag:ArrayCollection=new ArrayCollection(); 
    [Bindable]public var finalizedFlagDropdownList:ArrayCollection=new ArrayCollection();
    [Bindable]
    public var conformSelectedResults : ArrayCollection = new ArrayCollection(); 
     [Bindable]
    public var selectifAny:Boolean=false;
    
    [Bindable]public var sPopup : SummaryPopup ;
    
    public var officeId:String="";
    
    public var defaultFinalizedFlag:String = "";
    
    //For check box
	[Bindable]
	public var selectAllBind:Boolean=false;
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    * This will fetch data to fill the initial form data to show the user.
    */
     private function initPageStart():void {
     	rdReferenceNo.setFocus();            
        if (!initCompFlg) {    
            rndNo= Math.random();        
            var req : Object = new Object();
            req.SCREEN_KEY = 12148;
            initializeRightsDetailQuery.request = req;
            
            initializeRightsDetailQuery.url = "cax/resetFinalizedFlagDispatch.action?method=initialExecute&mode="+mode+"&rnd=" + rndNo;;
                                            
            initializeRightsDetailQuery.send();        
        } else
            XenosAlert.info("Already Initiated!");
     } 
     
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * Once initial data is fetched from database to fill some form data, this method works
    * to actually show the data.
    */   
     private function initPage(event: ResultEvent) : void {
     	app.submitButtonInstance = submit;
        var i:int = 0;
        var selIndx:int = 0;
        var dateStr:String = null;
        var tempColl: ArrayCollection = new ArrayCollection();
        
        //variables to hold the default values from the server
        
     /*   var sortField1Default:String = XenosStringUtils.EMPTY_STR;
        var sortField2Default:String = XenosStringUtils.EMPTY_STR;
        var sortField3Default:String = XenosStringUtils.EMPTY_STR;
        var sortField4Default:String = XenosStringUtils.EMPTY_STR; */
        var sortField1Default:String = event.result.revertCancelActionForm.sortField1;
        var sortField2Default:String = event.result.revertCancelActionForm.sortField2;
        var sortField3Default:String = event.result.revertCancelActionForm.sortField3;
        var sortField4Default:String = event.result.revertCancelActionForm.sortField4; 
        //var sortField5Default:String = event.result.revertCancelActionForm.sortField5;        
        
        errPage.clearError(event); //clears the errors if any 
        
        //Initialize all fields
        rdReferenceNo.text = XenosStringUtils.EMPTY_STR;
        rcReferenceNo.text = XenosStringUtils.EMPTY_STR;
        instPopUp.instrumentId.text = XenosStringUtils.EMPTY_STR;
        allotmentInstPopUp.instrumentId.text = XenosStringUtils.EMPTY_STR;
        paymentDateFrom.selectedDate = null;
        paymentDateTo.selectedDate = null;
        exDateFrom.selectedDate = null;
        exDateTo.selectedDate = null;
        fundPopUp.fundCode.text = XenosStringUtils.EMPTY_STR;
        actPopUp.accountNo.text = XenosStringUtils.EMPTY_STR;
        //DetailType List
        if(event.result.revertCancelActionForm.detailTypeList !=null){
                if(event.result.revertCancelActionForm.detailTypeList.item != null) {
                    if(event.result.revertCancelActionForm.detailTypeList.item is ArrayCollection)
                        initColl = event.result.revertCancelActionForm.detailTypeList.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.revertCancelActionForm.detailTypeList.item);
                }
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value:" "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        
       //Status List
       var defaultStatus:String = event.result.revertCancelActionForm.status;
       initColl.removeAll();
       if(event.result.revertCancelActionForm.statusDropdownList !=null){
                if(event.result.revertCancelActionForm.statusDropdownList.item != null) {
                    if(event.result.revertCancelActionForm.statusDropdownList.item is ArrayCollection)
                        initColl = event.result.revertCancelActionForm.statusDropdownList.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.revertCancelActionForm.statusDropdownList.item);
                }
        }
        tempColl = new ArrayCollection();
        for(i = 0; i<initColl.length; i++) {
//        	if(XenosStringUtils.equals((initColl[i].value),defaultStatus)){                    
//                selIndx = i;
//            }
            tempColl.addItem(initColl[i]);
                
        }
        status.dataProvider = tempColl;
       // status.selectedIndex = selIndx+1;
        
       //eventType List
       initColl.removeAll();
       if(event.result.revertCancelActionForm.corporateActionIdDropdownList !=null){
                if(event.result.revertCancelActionForm.corporateActionIdDropdownList.item != null) {
                    if(event.result.revertCancelActionForm.corporateActionIdDropdownList.item is ArrayCollection)
                        initColl = event.result.revertCancelActionForm.corporateActionIdDropdownList.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.revertCancelActionForm.corporateActionIdDropdownList.item);
                }
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value:" "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        eventType.dataProvider = tempColl;
        
        
        //FinalizedFlagList List
        defaultFinalizedFlag = event.result.revertCancelActionForm.finalizedFlag;
        initColl.removeAll();
        if(event.result.revertCancelActionForm.finalizedFlagValue !=null){
                if(event.result.revertCancelActionForm.finalizedFlagValue.item != null) {
                    if(event.result.revertCancelActionForm.finalizedFlagValue.item is ArrayCollection)
                        initColl = event.result.revertCancelActionForm.finalizedFlagValue.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.revertCancelActionForm.finalizedFlagValue.item);
                }
        }
        tempColl = new ArrayCollection();
    //    tempColl.addItem({label:" ", value:" "});
        for(i = 0; i<initColl.length; i++) {
//        	 if(XenosStringUtils.equals((initColl[i].value),defaultFinalizedFlag)){                    
//                selIndx = i;
//            }
            tempColl.addItem(initColl[i]);    
        }
        finalizedFlag.dataProvider = tempColl;
      //  finalizedFlag.selectedIndex = selIndx+1;
        
        
        //populate office id
        tempColl=new ArrayCollection();
        tempColl.addItem("");
        initColl.removeAll();	        
        if(event.result.revertCancelActionForm.officeValues !=null){	        		
                if(event.result.revertCancelActionForm.officeValues.item != null) {	                	
                    if(event.result.revertCancelActionForm.officeValues.item is ArrayCollection){	                    
                        initColl = event.result.revertCancelActionForm.officeValues.item as ArrayCollection;
                    }
                    else
                    {
                        //initColl = new ArrayCollection();
                        initColl.addItem(event.result.revertCancelActionForm.officeValues.item);
                    }
                }         
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);            
            }
       }
       officeIdList.dataProvider = tempColl;
       officeIdList.selectedIndex=-1;
          
          //populate Fund Category
       	tempColl=new ArrayCollection();
        tempColl.addItem({label:" ", value:" "});
        initColl.removeAll();
       	if(event.result.revertCancelActionForm.fundCategoryList !=null){
                if(event.result.revertCancelActionForm.fundCategoryList.item != null) {
                    if(event.result.revertCancelActionForm.fundCategoryList.item is ArrayCollection)
                        initColl = event.result.revertCancelActionForm.fundCategoryList.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.revertCancelActionForm.fundCategoryList.item);
                }
        }
	      for(i = 0; i<initColl.length; i++) {
	        tempColl.addItem(initColl[i]);    
	    }
	    fundCategoryList.dataProvider = tempColl;
          
        //Initialize sortFieldList1.
        selIndx =0;
        if(null != event.result.revertCancelActionForm.sortFieldList1.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            initColl = event.result.revertCancelActionForm.sortFieldList1.item as ArrayCollection;
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
        if(null != event.result.revertCancelActionForm.sortFieldList2.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx=0;
            
            initColl = event.result.revertCancelActionForm.sortFieldList2.item as ArrayCollection;
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
        if(null != event.result.revertCancelActionForm.sortFieldList3.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
            
            initColl = event.result.revertCancelActionForm.sortFieldList3.item as ArrayCollection;
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
        } else {
            XenosAlert.error("Sort Order Field List 3 not Populated");
        }           
            
        //Initialize sortFieldList4.
        if(null != event.result.revertCancelActionForm.sortFieldList4.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
            
            initColl = event.result.revertCancelActionForm.sortFieldList4.item as ArrayCollection;
            for(i = 0; i<initColl.length; i++) {
                //Get the default value object's index
                if(XenosStringUtils.equals((initColl[i].value),sortField4Default)){                    
                    selIndx = i;
                }
                
                tempColl.addItem(initColl[i]);            
            }
            
            sortFieldArray[3]=sortField4;
            sortFieldDataSet[3]=tempColl;
            //Set the default value object
            sortFieldSelectedItem[3] = tempColl.getItemAt(selIndx+1);           
        } else {
            XenosAlert.error("Sort Order Field List 4 not Populated");
        }           
		
		initColl.removeAll();
		initColl = event.result.revertCancelActionForm.finalizedFlagList.item as ArrayCollection;
        finalizedFlagDropdownList = new ArrayCollection();
      //  finalizedFlagDropdownList.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            finalizedFlagDropdownList.addItem(initColl[i]);    
        }
            csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
            csd.init();
     }
     
     private function sortOrder1Update():void{
         csd.update(sortField1.selectedItem,0);
     }
     
     private function sortOrder2Update():void{      
        csd.update(sortField2.selectedItem,1);
     }
     
     private function sortOrder3Update():void{      
        csd.update(sortField3.selectedItem,2);
     }
     
     /* private function sortOrder4Update():void{      
        csd.update(sortField4.selectedItem,3);
     }      */
          
     private function onChangeDetailType(event:ListEvent):void{
        var detType : String = String(event.currentTarget);
        if(XenosStringUtils.equals(detType,"NCM_RIGHTS_DETAIL")){
            actPopUp.visible = false;
        }else {
            actPopUp.visible = true;
        }
     }
     
     /**
     * On change of Event Type determine whether to show the Sub Event
     * Type List or not
     */     
        
     
     /**
     *  This function is called when Event Type is changed. 
     */
     private function onChangeEventTypeResult(event: ResultEvent):void{
        
        var i:int = 0;
        var selIndx:int = 0;
        var dateStr:String = null;
        var tempColl: ArrayCollection = new ArrayCollection();
        
        
        //set Sub Event Type
        
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        selIndx = 0;
        if(event.result.revertCancelActionForm.subEventTypeDropDownList != null && this.eventType.selectedItem != XenosStringUtils.EMPTY_STR){
            
            if(event.result.revertCancelActionForm.subEventTypeDropDownList.item is ArrayCollection){
               initColl = event.result.revertCancelActionForm.subEventTypeDropDownList.item as ArrayCollection;                
            }else{
                initColl=new ArrayCollection();
                initColl.addItem(event.result.revertCancelActionForm.subEventTypeDropDownList.item);
            }
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);            
            }
            
        } else {
            
        }
     }
     
     /**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
        private function populateContext(index:int):ArrayCollection {
       //pass the context data to the popup
         var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing counter party type                
            var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="INTERNAL";
        var cpTypeArray1:Array = new Array(2);
        cpTypeArray1[0]="BANK/CUSTODIAN";
        cpTypeArray1[1]="BROKER";       
                
           if(index==1){
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        }
        else
        {
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray1));
        }
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
            return myContextList;

        }
  /**
    * This method sends the HttpService for reset operation.
    * 
    */
     private function resetQuery():void {
       rightDetailResetRequest.url = "cax/resetFinalizedFlagDispatch.action?method=resetQuery";
       rightDetailResetRequest.send();
     }  

 
   /**
    * It sends/submits the query after validating the user input data. 
    * 
    */
    public function submitQuery():void 
     {  
        //Reset Page No
         qh.resetPageNo();
         
        resetFinalizedRequest.url = "cax/resetFinalizedFlagDispatch.action?";
        //Set the request parameters
         var requestObj :Object = populateRequestParams();
         
         resetFinalizedRequest.request = requestObj;
         
         
         
         var myModel:Object={
                            rdQuery:{
                                 
                                 paymentDateFrom:this.paymentDateFrom.text,
                                 paymentDateTo:this.paymentDateTo.text,
                                 exDateFrom:this.exDateFrom.text,
                                 exDateTo:this.exDateTo.text
                            }
                           }; 
        
         var rdQueryValidator : ResetFinalizedFlagValidator = new ResetFinalizedFlagValidator();
         rdQueryValidator.source=myModel;
         rdQueryValidator.property="rdQuery";
         var validationResult:ValidationResultEvent = rdQueryValidator.validate();  
         if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            //trace(errorMsg);
            XenosAlert.error(errorMsg);
        }
        else{                           
            resetFinalizedRequest.send();
        }
     } 
     /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
       // addExtraColumn();
        qh.dgrid = rdSummary;
    } 
     /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        reqObj.SCREEN_KEY = 12149;
        reqObj.method = "submitQuery";
        reqObj.modeOfOperation = mode;
        reqObj.detailType = "RIGHTS_DETAIL";
        reqObj.corporateActionId = (this.eventType.selectedItem != null ? this.eventType.selectedItem.value : XenosStringUtils.EMPTY_STR);
        reqObj.detailReferenceNo = this.rdReferenceNo.text;
        reqObj.conditionReferenceNo = this.rcReferenceNo.text;
        reqObj.instrumentCode = this.instPopUp.instrumentId.text;
        reqObj.allotmentInstrumentCode = this.allotmentInstPopUp.instrumentId.text;
        reqObj.accountNo = this.actPopUp.accountNo.text;
        reqObj.paymentDateFromStr = this.paymentDateFrom.text;
        reqObj.paymentDateToStr = this.paymentDateTo.text;
        reqObj.exDateFromStr = this.exDateFrom.text;
        reqObj.exDateToStr = this.exDateTo.text;
        reqObj.status = (this.status.selectedItem != null ? this.status.selectedItem.value : XenosStringUtils.EMPTY_STR);
        
        reqObj.finalizedFlag = (this.finalizedFlag.selectedItem != null ? this.finalizedFlag.selectedItem.value : XenosStringUtils.EMPTY_STR);
        reqObj.fundCode = this.fundPopUp.fundCode.text;
        reqObj.lmOfficeId = (officeIdList.selectedItem!=null)?officeIdList.selectedItem.toString():"";
        reqObj.fundCategory = (this.fundCategoryList.selectedItem!=null?this.fundCategoryList.selectedItem.value :"");
        reqObj.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.sortField3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.sortField4 = this.sortField4.selectedItem != null ? StringUtil.trim(this.sortField4.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        
        //reqObj.sortField5 = this.sortField5.selectedItem != null ? StringUtil.trim(this.sortField5.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        
        reqObj.rnd = Math.random() + "";
        return reqObj;
    }
     /**
    * This method works as the result handler of the Submit Query Http Services.
    * This also takes care of the buttons/images to be shown on the top panel of the
    * result .
    */
      private function loadSummaryPage(event:ResultEvent):void {
        var rs:XML = XML(event.result);
        if (null != event) {                
            if(rs.child("row").length()>0) {
                errPage.clearError(event);
                summaryResult.removeAll();
                try {
                    for each (var rec:XML in rs.row ) {
                        summaryResult.addItem(rec);
                    }                               
                    changeCurrentState();
                    qh.setOnResultVisibility();    
                                 
                    qh.setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
                    qh.PopulateDefaultVisibleColumns();
                    //replace null objects with empty string
                    summaryResult=ProcessResultUtil.process(summaryResult,rdSummary.columns); 
                    summaryResult.refresh();                                            
                }catch(e:Error){
                    XenosAlert.error(e.toString() + e.message);
                    //XenosAlert.error("No result found");
                }
            }else if(rs.child("Errors").length()>0) {
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
        //isAllSelected =false;
        resetSellection(summaryResult);
        setIfAllSelected(); 
      }         
      
    private function displayDetailView(rightsDetailPk:String,stlRefNo:String,slrRefNo:String):void {
            
            var parentApp :UIComponent = UIComponent(this.parentApplication);
            
            XenosPopupUtils.showCaxRightsDetails(rightsDetailPk,parentApp,stlRefNo,slrRefNo);   
        }
      
    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
    
     private function doNext():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
        reqObj.listIndex = "0";
        resetFinalizedRequest.request = reqObj;
        resetFinalizedRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        reqObj.listIndex = "0";
        resetFinalizedRequest.request = reqObj;
        resetFinalizedRequest.send();
    }
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
    //TODO
     private function generateXls():void {        
     	var url = "cax/resetFinalizedFlagDispatch.action?method=generateXLS";
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
    //TODO
      private function generatePdf():void {
     	var url = "cax/resetFinalizedFlagDispatch.action?method=generatePDF";
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
      public function checkSelectToModify(item:Object):void {
    	setIfAllSelected();    	    	
    }	
  	
  	    private function resetSellection(summaryResult:ArrayCollection):void{
    	for(var i:int=0;i<summaryResult.length;i++){
    		summaryResult[i].selected = false;
    		summaryResult[i].rowNum = i;
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
    	if(summaryResult == null){
    	 return false;
    	}
    	for(i=0; i<summaryResult.length; i++){
    		if(summaryResult[i].selected == false) {
        		return false;
        	} 
    	}
    	if(i == summaryResult.length) {
    		return true;
         }else {
    		return false;
    	}
    }
    
    // This as file contains code specific to the Check Box Selections.    
    
    public function selectAllRecords(flag:Boolean): void {
    	var i:Number = 0;
    	selectedResults.removeAll();
    	for(i=0; i<summaryResult.length; i++){
    		var obj:XML=summaryResult[i];
            obj.selected = flag;
            summaryResult[i]=obj;
            summaryResult.refresh();
            addOrRemove(summaryResult[i]);
    	}
    	
    	conformSelectedResults= selectedResults;
    }
    
    public function addOrRemove(item:Object):void {
    	var i:Number;
        var tempArray:Array = new Array();
        if(item.selected == true){ 
            selectedResults.addItem(item.rightsDetailPk);
            selectedFlag.addItem(item.finalizedFlag);
           
    	}else { //needs to pop
    		for(i=0; i<selectedResults.length; i++){
    			if(selectedResults[i].rightsDetailPk != item.rightsDetailPk){
    			    selectedResults.removeItemAt(i);
    			    selectedFlag.removeItemAt(i);
    			}
    		}     
    	}
    } 

     private function showConfirmModule(event:Event):void{
     	var i:Number;
    	var parentApp :UIComponent = UIComponent(this.parentApplication);
    	var selectedItem:Array = getSelectedPks();
    	var selectedFlag:Array = getSelectedFlag();
    	var selectedRefNo:Array = getSelectedDetailRefNo();
    	var pkArray:Array = new Array();
    	var flagArray:Array = new Array();
    	 if(selectedItem.length > 0 ) {
            selectifAny = true;
            
            for(i=0; i<selectedItem.length; i++){
                pkArray[i] = selectedItem[i];
                flagArray[i]= Globals.DATABASE_NO;
            }
        } else {
            selectifAny = false;
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('cax.reset.select.atleast.single.record'));
            return;
        }
			sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
			sPopup.addEventListener(CloseEvent.CLOSE,closeHandler,false,0,true);
			sPopup.width = parentApplication.width * 50/100;
    		sPopup.height = parentApplication.height * 55/100; 
			PopUpManager.centerPopUp(sPopup);
			sPopup.owner = this;
			sPopup.dataObj = summaryResult;
			sPopup.moduleUrl = "assets/appl/cax/ResetFinalizedFlagPopUp.swf"+Globals.QS_SIGN+"selectedItems"+Globals.EQUALS_SIGN+pkArray+Globals.AND_SIGN+"selectedFlagArray"+Globals.EQUALS_SIGN+flagArray;;
    }
    
     public function closeHandler(event:Event):void {
    	this.submitQuery();
		//sPopup.removeEventListener(CloseEvent.CLOSE,closeHandler);
		sPopup.removeMe();
    }
    
    private function getSelectedPks():Array{
    	var tempArray:ArrayCollection = new ArrayCollection();
    	//var numBase:NumberBase = new NumberBase();
    	for(var i:int=0;i<summaryResult.length;i++){
    		if(summaryResult[i].selected == true){
    			tempArray.addItem(summaryResult[i].rightsDetailPk);
    			trace("Selected index :: " + summaryResult[i].originalIndex);
	    	}
    	}
    	return tempArray.toArray();
    } 
    
    private function getSelectedFlag():Array{
    	var tempArray:ArrayCollection = new ArrayCollection();
    	//var numBase:NumberBase = new NumberBase();
    	for(var i:int=0;i<summaryResult.length;i++){
    		if(summaryResult[i].selected == true){
    			tempArray.addItem(summaryResult[i].finalizedFlag);
	    	}
    	}
    	return tempArray.toArray();
    } 
    
     private function getSelectedDetailRefNo():Array{
    	var tempArray:ArrayCollection = new ArrayCollection();
    	//var numBase:NumberBase = new NumberBase();
    	for(var i:int=0;i<summaryResult.length;i++){
    		if(summaryResult[i].selected == true){
    			tempArray.addItem(summaryResult[i].detailReferenceNo);
    			trace("Selected index :: " + summaryResult[i].originalIndex);
	    	}
    	}
    	return tempArray.toArray();
    } 
    
  	private function resetCol():void{
       		selectAllBind = false;
           	resetSellection(summaryResult);
           	
           	for(var i:int=0; i<summaryResult.length; i++){
                    summaryResult[i].finalizedFlag = defaultFinalizedFlag;
                }
	        rdSummary.dataProvider = summaryResult; 	
	        }
	        
	        private function dispatchPrintEvent():void{
              this.dispatchEvent(new Event("print"));
          }
          
          private function loadAll():void {
    }  
  	