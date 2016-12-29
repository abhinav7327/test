
 // ActionScript file for Cax Right Condition Query
 import com.nri.rui.cax.validator.RightsConditionQueryValidator;
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.containers.SummaryPopup;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosStringUtils;
 
 import flash.net.URLRequest;
 import flash.net.URLRequestMethod;
 
 import mx.collections.ArrayCollection;
 import mx.core.UIComponent;
 import mx.events.ValidationResultEvent;
 import mx.managers.PopUpManager;
 import mx.rpc.events.ResultEvent;
 import mx.utils.StringUtil;
    
    
    [Bindable]
    private var initColl:ArrayCollection;
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
    [Bindable]   
    private var mode : String = null;
    [Bindable]
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    private var  csd:CustomizeSortOrder=null;
   	public var officeId:String="";
   	public var fundCategory:String="";
    /**
     * Array to hold the Account based column order for query result.
     * The contents are the dataField property value of the data grod columns.
     */
    /* private const accountBasedColumns:Array = [ "view","accountPrefix", "accountName", "fundCode", "securityId", 
                                                "instrumentName", "baseDateDisp", "tradeDateDisp", "valueDateDisp",
                                                "description", "amountDisp", "formattedPrice", "balanceDisp", 
                                                "transactionRefNo"
                                              ]; */

    /**
     * Array to hold the Security based column order for query result.
     * The contents are the dataField property value of the data grod columns.
     */
    /* private const securityBasedColumns:Array = [ "view", "securityId", "instrumentName","accountPrefix", "accountName",
                                                 "fundCode",  "baseDateDisp", "tradeDateDisp", "valueDateDisp",
                                                 "description", "amountDisp", "formattedPrice", "balanceDisp", 
                                                 "transactionRefNo"
                                               ];  */                                         
     /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
        qh.dgrid = rightConditionSummary;
    }  
     /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid2():void {        
        qh2.dgrid = rightConditionSummary2;
    }     
    
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    * This will fetch data to fill the initial form data to show the user.
    */
     private function initPageStart():void {            
        if (!initCompFlg) {
            parseUrlString(); 
            rndNo= Math.random();     
            var req : Object = new Object();
            req.SCREEN_KEY = 417;
            initializeRightConditionQuery.request = req;
            if(XenosStringUtils.equals(mode,"detailsEntry")){   
                initializeRightConditionQuery.url = "cax/rightsConditionDetailEntryQueryDispatch.action?method=initialExecute&mode="+mode+"&rnd=" + rndNo;
            }else if(XenosStringUtils.equals(mode,"bulkAmend")){
            	initializeRightConditionQuery.url = "cax/rightsConditionBulkAmendQueryDispatch.action?method=initialExecute&mode="+mode+"&rnd=" + rndNo;
            }else if(XenosStringUtils.equals(mode,"adjustment")){
            	initializeRightConditionQuery.url = "cax/rightsConditionAdjustmentQueryDispatch.action?method=initialExecute&mode="+mode+"&rnd=" + rndNo;
            }else if(XenosStringUtils.equals(mode,Globals.MODE_AMEND)){   
                initializeRightConditionQuery.url = "cax/rightsConditionAmendQueryDispatch.action?method=initialExecute&mode="+mode+"&rnd=" + rndNo;
            }else if(XenosStringUtils.equals(mode,Globals.MODE_CANCEL)){   
                initializeRightConditionQuery.url = "cax/rightsConditionCancelQueryDispatch.action?method=initialExecute&mode="+mode+"&rnd=" + rndNo;
            }else if(XenosStringUtils.equals(mode,"rateentry")){   
                initializeRightConditionQuery.url = "cax/rightsConditionStRateQueryDispatch.action?method=initialExecute&mode="+mode+"&rnd=" + rndNo;
            }else if(XenosStringUtils.equals(mode,"ratedelete")){   
                initializeRightConditionQuery.url = "cax/rightsConditionStDelQueryDispatch.action?method=initialExecute&mode="+mode+"&rnd=" + rndNo;
            }else {
                initializeRightConditionQuery.url = "cax/rightsConditionQueryDispatch.action?method=initialExecute&mode="+mode+"&rnd=" + rndNo;                                      
            }
            initializeRightConditionQuery.send();  
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
        var sortField1Default:String = event.result.rightsConditionQueryActionForm.sortField1;
        var sortField2Default:String = event.result.rightsConditionQueryActionForm.sortField2;
        var sortField3Default:String = event.result.rightsConditionQueryActionForm.sortField3;
        
        errPage.clearError(event); //clears the errors if any 
        
        
        //initiate text fields
        rightCondRefNo.text = "";
        rightCondRefNo.setFocus();
        
        instPopUp.instrumentId.text = "";
        allotmentInstPopUp.instrumentId.text = "";
        allotmentRightsInstPopUp.instrumentId.text = "";
        //bankPopUp.finInstCode.text="";//?????????????????
        exDateFrom.text="";
        exDateTo.text="";
        recordDateFrom.text="";
        recordDateTo.text="";
        paymentDateFrom.text="";
        paymentDateTo.text="";
        processStartDateFrom.text="";
        processStartDateTo.text="";
        processEndDateFrom.text="";
        processEndDateTo.text="";
        dueBillEndDateFrom.text="";
        dueBillEndDateTo.text="";
        app_regi_DateFrom.text="";
        app_regi_DateTo.text="";
        app_upd_DateFrom.text="";
        app_upd_DateTo.text="";
        extRefNo.text="";
        paymentDateTakeUpFrom.text="";
        paymentDateTakeUpTo.text="";
        
        exDateFrom.selectedDate=null;
        exDateTo.selectedDate=null;
        recordDateFrom.selectedDate=null;
        recordDateTo.selectedDate=null;
        paymentDateFrom.selectedDate=null;
        paymentDateTo.selectedDate=null;
        processStartDateFrom.selectedDate=null;
        processStartDateTo.selectedDate=null;
        processEndDateFrom.selectedDate=null;
        processEndDateTo.selectedDate=null;
        dueBillEndDateFrom.selectedDate=null;
        dueBillEndDateTo.selectedDate=null;
        app_regi_DateFrom.selectedDate=null;
        app_regi_DateTo.selectedDate=null;
        app_upd_DateFrom.selectedDate=null;
        app_upd_DateTo.selectedDate=null; 
        paymentDateTakeUpFrom.selectedDate=null;
        paymentDateTakeUpTo.selectedDate=null;
        
                
        if(XenosStringUtils.equals(mode,"query")) {
            statusRow.visible = true;
            statusRow.includeInLayout = true;           
        } else {
            statusRow.visible = false;
            statusRow.includeInLayout = false;          
        }
        
        if(XenosStringUtils.equals(mode,"detailsEntry") || XenosStringUtils.equals(mode,"bulkAmend")) {
            fundCategoryRow.visible = true;
            fundCategoryRow.includeInLayout = true;           
        } else {
            fundCategoryRow.visible = false;
            fundCategoryRow.includeInLayout = false;          
        }
        //Initialize Event Type
        
        
        
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value:" "});
        selIndx = 0;
               
       if(event.result.rightsConditionQueryActionForm.eventTypeList !=null){
                if(event.result.rightsConditionQueryActionForm.eventTypeList.item != null) {
                    if(event.result.rightsConditionQueryActionForm.eventTypeList.item is ArrayCollection)
                        initColl = event.result.rightsConditionQueryActionForm.eventTypeList.item as ArrayCollection;
                    else
                        //initColl = new ArrayCollection();
                        initColl.addItem(event.result.rightsConditionQueryActionForm.eventTypeList.item);
                }
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);            
            }
            eventType.dataProvider = tempColl;              
        }               
               
               
       // initColl = event.result.rightsConditionQueryActionForm.eventTypeList.item as ArrayCollection;

        
        
        //Initialize Sub Event Type
        
        
     /*   tempColl = new ArrayCollection();
        tempColl.addItem({label:"", value: ""});
        selIndx = 0;
        if(event.result.rightsConditionQueryActionForm.subEventTypeList != null){       
            initColl = event.result.rightsConditionQueryActionForm.subEventTypeList.item as ArrayCollection;
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);            
            }
        } 
        
       if(event.result.rightsConditionQueryActionForm.subEventTypeList !=null){
                if(event.result.rightsConditionQueryActionForm.subEventTypeList.item != null) {
                    if(event.result.rightsConditionQueryActionForm.subEventTypeList.item is ArrayCollection)
                        initColl = event.result.rightsConditionQueryActionForm.subEventTypeList.item as ArrayCollection;
                    else
                        initColl = new ArrayCollection();
                        initColl.addItem(event.result.rightsConditionQueryActionForm.subEventTypeList.item);
                }
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);            
            }
            eventType.dataProvider = tempColl;              
        }        
        */
        
       //Status List
       initColl.removeAll();
       
       if(event.result.rightsConditionQueryActionForm.statusDropdownList !=null){
                if(event.result.rightsConditionQueryActionForm.statusDropdownList.item != null) {
                    if(event.result.rightsConditionQueryActionForm.statusDropdownList.item is ArrayCollection)
                        initColl = event.result.rightsConditionQueryActionForm.statusDropdownList.item as ArrayCollection;
                    else
                        //initColl = new ArrayCollection();
                        initColl.addItem(event.result.rightsConditionQueryActionForm.statusDropdownList.item);
                }
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value:" "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        status.dataProvider = tempColl;        
        
        //Initialize Event Type Status
        
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        selIndx = 0;
        
       if(event.result.rightsConditionQueryActionForm.eventTypeStatusList !=null){
                if(event.result.rightsConditionQueryActionForm.eventTypeStatusList.item != null) {
                    if(event.result.rightsConditionQueryActionForm.eventTypeStatusList.item is ArrayCollection)
                        initColl = event.result.rightsConditionQueryActionForm.eventTypeStatusList.item as ArrayCollection;
                    else
                        //initColl = new ArrayCollection();
                        initColl.addItem(event.result.rightsConditionQueryActionForm.eventTypeStatusList.item);
                }
                      
        //initColl = event.result.rightsConditionQueryActionForm.eventTypeStatusList.item as ArrayCollection;
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);            
            }
       }
        eventTypeStatus.dataProvider = tempColl;
        
        //Initialize Allotment Type
        
      /*  tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        selIndx = 0;
               
        initColl = event.result.rightsConditionQueryActionForm.allotmentTypeList.item as ArrayCollection;
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);            
        }
        allotmentType.dataProvider = tempColl; */
        
        //Initialize Processing Frequency
        
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        selIndx = 0;
               
        //initColl = event.result.rightsConditionQueryActionForm.processingFrequencyList.item as ArrayCollection;
       if(event.result.rightsConditionQueryActionForm.processingFrequencyList !=null){
                if(event.result.rightsConditionQueryActionForm.processingFrequencyList.item != null) {
                    if(event.result.rightsConditionQueryActionForm.processingFrequencyList.item is ArrayCollection)
                        initColl = event.result.rightsConditionQueryActionForm.processingFrequencyList.item as ArrayCollection;
                    else
                        //initColl = new ArrayCollection();
                        initColl.addItem(event.result.rightsConditionQueryActionForm.processingFrequencyList.item);
                }        
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);            
            }
       }
        processingFrequency.dataProvider = tempColl;
        
        //Initialize Exception Flag
        
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        selIndx = 0;
               
        //initColl = event.result.rightsConditionQueryActionForm.exceptionFlagValues.item as ArrayCollection;
       if(event.result.rightsConditionQueryActionForm.exceptionFlagValues !=null){
                if(event.result.rightsConditionQueryActionForm.exceptionFlagValues.item != null) {
                    if(event.result.rightsConditionQueryActionForm.exceptionFlagValues.item is ArrayCollection)
                        initColl = event.result.rightsConditionQueryActionForm.exceptionFlagValues.item as ArrayCollection;
                    else
                        //initColl = new ArrayCollection();
                        initColl.addItem(event.result.rightsConditionQueryActionForm.exceptionFlagValues.item);
                }         
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);            
            }
       }
        exceptionFlag.dataProvider = tempColl;
        
         //Initialize Data Source List
        
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        selIndx = 0;
        
         //initColl = event.result.rightsConditionQueryActionForm.dataSourceDropdownList.item as ArrayCollection;
       if(event.result.rightsConditionQueryActionForm.dataSourceDropdownList !=null){
                if(event.result.rightsConditionQueryActionForm.dataSourceDropdownList.item != null) {
                    if(event.result.rightsConditionQueryActionForm.dataSourceDropdownList.item is ArrayCollection)
                        initColl = event.result.rightsConditionQueryActionForm.dataSourceDropdownList.item as ArrayCollection;
                    else
                        //initColl = new ArrayCollection();
                        initColl.addItem(event.result.rightsConditionQueryActionForm.dataSourceDropdownList.item);
                }         
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);            
            }
       }
        dataSource.dataProvider = tempColl;
        
        //populate Fund Category
       	tempColl=new ArrayCollection();
        tempColl.addItem({label:" ", value:" "});
        initColl.removeAll();
       	if(event.result.rightsConditionQueryActionForm.fundCategoryList !=null){
                if(event.result.rightsConditionQueryActionForm.fundCategoryList.item != null) {
                    if(event.result.rightsConditionQueryActionForm.fundCategoryList.item is ArrayCollection)
                        initColl = event.result.rightsConditionQueryActionForm.fundCategoryList.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.rightsConditionQueryActionForm.fundCategoryList.item);
                }
        }
	      for(i = 0; i<initColl.length; i++) {
	        tempColl.addItem(initColl[i]);    
	    }
	    fundCategoryList.dataProvider = tempColl;
           
               
        //Initialize sortFieldList1.
        if(null != event.result.rightsConditionQueryActionForm.sortFieldList1.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            initColl = event.result.rightsConditionQueryActionForm.sortFieldList1.item as ArrayCollection;
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
        if(null != event.result.rightsConditionQueryActionForm.sortFieldList2.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx=0;
            
            initColl = event.result.rightsConditionQueryActionForm.sortFieldList2.item as ArrayCollection;
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
        if(null != event.result.rightsConditionQueryActionForm.sortFieldList3.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
            
            initColl = event.result.rightsConditionQueryActionForm.sortFieldList3.item as ArrayCollection;
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

        /* initCompFlg = true;?????????? */
        if(XenosStringUtils.equals(mode,"detailsEntry")  || XenosStringUtils.equals(mode,"bulkAmend")){
	        //populate office id
	        tempColl=new ArrayCollection();
	        tempColl.addItem("");
	        initColl.removeAll();	        
	        if(event.result.rightsConditionQueryActionForm.officeValues !=null){	        		
	                if(event.result.rightsConditionQueryActionForm.officeValues.item != null) {	                	
	                    if(event.result.rightsConditionQueryActionForm.officeValues.item is ArrayCollection){	                    
	                        initColl = event.result.rightsConditionQueryActionForm.officeValues.item as ArrayCollection;
	                    }
	                    else
	                    {
	                        //initColl = new ArrayCollection();
	                        initColl.addItem(event.result.rightsConditionQueryActionForm.officeValues.item);
	                    }
	                }         
	            for(i = 0; i<initColl.length; i++) {
	                tempColl.addItem(initColl[i]);            
	            }
	       }
	       officeIdList.dataProvider = tempColl;
	       officeIdList.selectedIndex=-1;
       }
               
    } 
        
     private function sortOrder1Update():void{
         csd.update(sortField1.selectedItem,0);
     }
     
     private function sortOrder2Update():void{      
        csd.update(sortField2.selectedItem,1);
     }
     
     
     
     
     
     
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
        if(event.result.rightsConditionQueryActionForm.subEventTypeList != null && this.eventType.selectedItem != XenosStringUtils.EMPTY_STR){
            
            if(event.result.rightsConditionQueryActionForm.subEventTypeList.item is ArrayCollection){
               initColl = event.result.rightsConditionQueryActionForm.subEventTypeList.item as ArrayCollection;             
            }else{
                initColl=new ArrayCollection();
                initColl.addItem(event.result.rightsConditionQueryActionForm.subEventTypeList.item);
            }
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);            
            }
            
        } else {
            
        }
     }
     
     /**
               * This is the method to pass the Collection of data items
               * through the context to the FinInst popup. This will be implemented as per specifdic  
               * requirement. 
               */
             private function populateFinInstRole():ArrayCollection {
                //pass the context data to the popup
                 var myContextList:ArrayCollection = new ArrayCollection(); 
                 
                 var bankRoleArray : Array = new Array(4);
                 bankRoleArray[0] = "Security Broker";
                 bankRoleArray[1] = "Bank/Custodian";
                 bankRoleArray[2] = "Stock Exchange";
                 bankRoleArray[3] = "Central Depository";
                 myContextList.addItem(new HiddenObject("bankRoles",bankRoleArray));
                 
                 return myContextList;
        }
    /**
    * It sends/submits the query after validating the user input data. 
    * 
    */
     public function submitQuery():void 
     {            
        //Reset Page No
         qh.resetPageNo();         
        //Set the request parameters
        var requestObj :Object = populateRequestParams();
        
        if(XenosStringUtils.equals(mode,"detailsEntry")){   
        	rightConditionRequest.url = "cax/rightsConditionDetailEntryQueryDispatch.action?";
        	officeId=(officeIdList.selectedItem!=null)?officeIdList.selectedItem.toString():"";
        	"&";
        	fundCategory=(this.fundCategoryList.selectedItem!=null?this.fundCategoryList.selectedItem.value :"");
        }else if(XenosStringUtils.equals(mode,"bulkAmend")){
        	rightConditionRequest.url = "cax/rightsConditionBulkAmendQueryDispatch.action?";
        	officeId=(officeIdList.selectedItem!=null)?officeIdList.selectedItem.toString():"";
        	"&";
        	fundCategory=(this.fundCategoryList.selectedItem!=null?this.fundCategoryList.selectedItem.value :"");
        }else if(XenosStringUtils.equals(mode,"adjustment")){
        	rightConditionRequest.url = "cax/rightsConditionAdjustmentQueryDispatch.action?";
        }else if(XenosStringUtils.equals(mode,Globals.MODE_AMEND)){   
            rightConditionRequest.url = "cax/rightsConditionAmendQueryDispatch.action?";
        }else if(XenosStringUtils.equals(mode,Globals.MODE_CANCEL)){   
            rightConditionRequest.url = "cax/rightsConditionCancelQueryDispatch.action?";
        }else if(XenosStringUtils.equals(mode,"rateentry")){   
            rightConditionRequest.url = "cax/rightsConditionStRateQueryDispatch.action?";
        }else if(XenosStringUtils.equals(mode,"ratedelete")){   
            rightConditionRequest.url = "cax/rightsConditionStDelQueryDispatch.action?";
        }else {
            rightConditionRequest.url = "cax/rightsConditionQueryDispatch.action?";                                      
        }
        
         rightConditionRequest.request = requestObj; 
         
        var myModel:Object={
                            rightCondition:{
                                 exDateFrom: this.exDateFrom.text,
                                 exDateTo: this.exDateTo.text,
                                 recordDateFrom:this.recordDateFrom.text,
                                 recordDateTo:this.recordDateTo.text,
                                 paymentDateFrom:this.paymentDateFrom.text,
                                 paymentDateTo:this.paymentDateTo.text,
                                 processStartDateFrom:this.processStartDateFrom.text,
                                 processStartDateTo:this.processStartDateTo.text,
                                 processEndDateFrom:this.processEndDateFrom.text,
                                 processEndDateTo:this.processEndDateTo.text,
                                 dueBillEndDateFrom:this.dueBillEndDateFrom.text,
                                 dueBillEndDateTo:this.dueBillEndDateTo.text,
                                 app_regi_DateFrom:this.app_regi_DateFrom.text,
                                 app_regi_DateTo:this.app_regi_DateTo.text,
                                 app_upd_DateFrom:this.app_upd_DateFrom.text,
                                 app_upd_DateTo:this.app_upd_DateTo.text,
                                 paymentDateTakeUpFrom:this.paymentDateTakeUpFrom.text,
                                 paymentDateTakeUpTo:this.paymentDateTakeUpTo.text
                            }
                           }; 
        var rightsConditionQueryValidate:RightsConditionQueryValidator =new RightsConditionQueryValidator();
        rightsConditionQueryValidate.source=myModel;
        rightsConditionQueryValidate.property="rightCondition";
        var validationResult:ValidationResultEvent =rightsConditionQueryValidate.validate();

        
        if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
            if(XenosStringUtils.equals(mode,"detailsEntry")) {
                resultHead2.text = "";
            } else {
                resultHead.text = "";
            }         
           
        }else {
            rightConditionRequest.send();   
        }                    
    } 
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        reqObj.SCREEN_KEY = 423;
         reqObj.method = "submitQuery";
         reqObj.conditionRefNo = this.rightCondRefNo.text;
         reqObj.corporateActionId = (this.eventType.selectedItem != null ? this.eventType.selectedItem.value : "");
         
         reqObj.eventTypeStatus = (this.eventTypeStatus.selectedItem != null? this.eventTypeStatus.selectedItem.value : "");
         reqObj.dataSource = (this.dataSource.selectedItem != null? this.dataSource.selectedItem.value : "");
         //reqObj.allotmentType = (this.allotmentType.selectedItem != null? this.allotmentType.selectedItem.value : "");
         reqObj.instrumentCode = this.instPopUp.instrumentId.text;
         reqObj.allotmentInstrument = this.allotmentInstPopUp.instrumentId.text;
         reqObj.allotmentInstrumentRights = this.allotmentRightsInstPopUp.instrumentId.text;
         //reqObj.custodian = this.bankPopUp.finInstCode.text;
         reqObj.processingFrequency = (this.processingFrequency.selectedItem != null? this.processingFrequency.selectedItem.value : "");
         reqObj.exDateFromStr = this.exDateFrom.text;
         reqObj.exDateToStr = this.exDateTo.text;
         reqObj.recordDateFromStr = this.recordDateFrom.text;
         reqObj.recordDateToStr= this.recordDateTo.text;
         reqObj.paymentDateFromStr = this.paymentDateFrom.text;
         reqObj.paymentDateToStr = this.paymentDateTo.text;
         reqObj.processStartDateFromStr = this.processStartDateFrom.text;
         reqObj.processStartDateToStr = this.processStartDateTo.text;
         reqObj.processEndDateFromStr = this.processEndDateFrom.text;
         reqObj.processEndDateToStr = this.processEndDateTo.text;
         reqObj.dueBillEndDateFromStr = this.dueBillEndDateFrom.text;
         reqObj.dueBillEndDateToStr = this.dueBillEndDateTo.text;
         reqObj.entryDateFromStr = this.app_regi_DateFrom.text;
         reqObj.entryDateToStr = this.app_regi_DateTo.text;
         reqObj.lastEntryDateFromStr = this.app_upd_DateFrom.text;
         reqObj.lastEntryDateToStr = this.app_upd_DateTo.text;
         reqObj.exceptionFlag = (this.exceptionFlag.selectedItem != null? this.exceptionFlag.selectedItem.value : "");
         reqObj.externalReferenceNo = this.extRefNo.text;
         reqObj.paymentDateTakeUpFromStr = this.paymentDateTakeUpFrom.text;
         reqObj.paymentDateTakeUpToStr   = this.paymentDateTakeUpTo.text;
         
         if(XenosStringUtils.equals(mode,"query")) {         
            reqObj.status = (this.status.selectedItem != null? this.status.selectedItem.value : "");
         } else {
            reqObj.status = "";
         }
         reqObj.modeOfOperation = mode;
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
        rightConditionRequest.request = reqObj;
        rightConditionRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        rightConditionRequest.request = reqObj;
        rightConditionRequest.send();
    }   
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
     private function resetQuery():void { 
     	
     	if(XenosStringUtils.equals(mode,"detailsEntry")){   
                rightConditionResetQueryRequest.url = "cax/rightsConditionDetailEntryQueryDispatch.action?method=resetQuery";
            }else if(XenosStringUtils.equals(mode,"bulkAmend")){
            	rightConditionResetQueryRequest.url = "cax/rightsConditionBulkAmendQueryDispatch.action?method=resetQuery";
            }else if(XenosStringUtils.equals(mode,"adjustment")){
            	rightConditionResetQueryRequest.url = "cax/rightsConditionAdjustmentQueryDispatch.action?method=resetQuery";
            }else if(XenosStringUtils.equals(mode,Globals.MODE_AMEND)){   
                rightConditionResetQueryRequest.url = "cax/rightsConditionAmendQueryDispatch.action?method=resetQuery";
            }else if(XenosStringUtils.equals(mode,Globals.MODE_CANCEL)){   
                rightConditionResetQueryRequest.url = "cax/rightsConditionCancelQueryDispatch.action?method=resetQuery";
            }else if(XenosStringUtils.equals(mode,"rateentry")){   
                rightConditionResetQueryRequest.url = "cax/rightsConditionStRateQueryDispatch.action?method=resetQuery";
            }else if(XenosStringUtils.equals(mode,"ratedelete")){   
                rightConditionResetQueryRequest.url = "cax/rightsConditionStDelQueryDispatch.action?method=resetQuery";
            }else {
                rightConditionResetQueryRequest.url = "cax/rightsConditionQueryDispatch.action?method=resetQuery";                                      
            }
            rightConditionResetQueryRequest.send();
    }  
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * This also takes care of the buttons/images to be shown on the top panel of the
    * result .
    */
      public function LoadSummaryPage(event:ResultEvent):void {
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
                    //replace null objects in dataProvider with empty string
                    summaryResult=ProcessResultUtil.process(summaryResult,rightConditionSummary.columns);
                    //changeCurrentState();
                     if(XenosStringUtils.equals(mode,"detailsEntry")||XenosStringUtils.equals(mode,"bulkAmend")||XenosStringUtils.equals(mode,"adjustment")) {
                        corporateActionDetail.selectedChild=rslt2;                  
                        qh2.setOnResultVisibility();
                        qh2.setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
                        //qh2.setPrevNextVisibility(Boolean(event.result.rows.prevTraversable),Boolean(event.result.rows.nextTraversable));
                        qh2.PopulateDefaultVisibleColumns();                    
                     } else {
                        if(XenosStringUtils.equals(mode,"query")) {
                            // addDataGridColumns();
                            allotmentPercentageCol.visible = true;
                            statusCol.visible = true;
                            exceptionFlagCol.visible = true;
                        } else {
                        	allotmentPercentageCol.visible = false;
                            statusCol.visible = false;
                            exceptionFlagCol.visible = false;
                        }
                        corporateActionDetail.selectedChild=rslt;      
                        qh.setOnResultVisibility();
                        qh.setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
                        qh.PopulateDefaultVisibleColumns();                     
                     }
                     if(this.mode!="detailsEntry" && this.mode!="bulkAmend" && this.mode!="adjustment" && this.mode!="rateentry" && this.mode!="ratedelete" && this.mode!="amend" && this.mode!="cancel"){
                        if(summaryResult.length==1){
                        displayDetailView(summaryResult[0].rightsConditionPk);
                     }                  
                    }   
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
         
    }  
    
    
    private function displayDetailView(rightsConditionPk:String):void {
            
            var sPopup : SummaryPopup;  
            sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
            
            sPopup.title = this.parentApplication.xResourceManager.getKeyValue('cax.corporateaction.event.view');
            sPopup.width = parentApplication.width - 125;           
            sPopup.height = 500;
            PopUpManager.centerPopUp(sPopup);       
            sPopup.moduleUrl = Globals.RIGHTS_CONITION_QUERY_DETAILS_SWF + Globals.QS_SIGN + Globals.RIGHTS_CONDITION_PK + Globals.EQUALS_SIGN+rightsConditionPk;
                
        }    
    
    /**
    * This is called at creationComplete of the module
    */
     private function loadAll():void {
        parseUrlString();
        if(XenosStringUtils.equals(mode,"detailsEntry") || XenosStringUtils.equals(mode,"bulkAmend")){
        	officeIdGrid1.includeInLayout=true;
        	officeIdGrid1.visible=true;
        	officeIdGrid2.includeInLayout=true;
        	officeIdGrid2.visible=true;
        }       
        //var title:String = "Corpoarte Action Event "+ " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.query');
        //if(title!= null)
        //    this.parentDocument.title = title;
     } 
    

    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
        var url : String = "";
        
        if(XenosStringUtils.equals(mode,"detailsEntry")){   
            url = "cax/rightsConditionDetailEntryQueryDispatch.action?method=generateCustomizedXLS";;
        }else if(XenosStringUtils.equals(mode,"bulkAmend")){
        	url = "cax/rightsConditionBulkAmendQueryDispatch.action?method=generateCustomizedXLS";
        }else if(XenosStringUtils.equals(mode,"adjustment")){
        	url = "cax/rightsConditionAdjustmentQueryDispatch.action?method=generateCustomizedXLS";
        }else if(XenosStringUtils.equals(mode,Globals.MODE_AMEND)){   
            url = "cax/rightsConditionAmendQueryDispatch.action?method=generateCustomizedXLS";
        }else if(XenosStringUtils.equals(mode,Globals.MODE_CANCEL)){   
            url = "cax/rightsConditionCancelQueryDispatch.action?method=generateCustomizedXLS";
        }else if(XenosStringUtils.equals(mode,"rateentry")){   
            url = "cax/rightsConditionStRateQueryDispatch.action?method=generateCustomizedXLS";
        }else if(XenosStringUtils.equals(mode,"ratedelete")){   
            url = "cax/rightsConditionStDelQueryDispatch.action?method=generateCustomizedXLS";
        }else {
            url = "cax/rightsConditionQueryDispatch.action?method=generateCustomizedXLS";                                      
        }        
        
        
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
        var url : String = "";
        
        if(XenosStringUtils.equals(mode,"detailsEntry")){   
            url = "cax/rightsConditionDetailEntryQueryDispatch.action?method=generateCustomizedPDF";
        }else if(XenosStringUtils.equals(mode,"bulkAmend")){
        	url = "cax/rightsConditionBulkAmendQueryDispatch.action?method=generateCustomizedPDF";
        }else if(XenosStringUtils.equals(mode,"adjustment")){
        	url = "cax/rightsConditionAdjustmentQueryDispatch.action?method=generateCustomizedPDF";
        }else if(XenosStringUtils.equals(mode,Globals.MODE_AMEND)){   
            url = "cax/rightsConditionAmendQueryDispatch.action?method=generateCustomizedPDF";
        }else if(XenosStringUtils.equals(mode,Globals.MODE_CANCEL)){   
            url = "cax/rightsConditionCancelQueryDispatch.action?method=generateCustomizedPDF";
        }else if(XenosStringUtils.equals(mode,"rateentry")){   
            url = "cax/rightsConditionStRateQueryDispatch.action?method=generateCustomizedPDF";
        }else if(XenosStringUtils.equals(mode,"ratedelete")){   
            url = "cax/rightsConditionStDelQueryDispatch.action?method=generateCustomizedPDF";
        }else {
            url = "cax/rightsConditionQueryDispatch.action?method=generateCustomizedPDF";                                      
        }         
        
        
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
    * Parsing the URL for mode  
    * 
    */    
    private function parseUrlString():void {
        try {
            // Remove everything before the question mark, including
            // the question mark.
            var myPattern:RegExp = /.*\?/; 
            var s:String = this.loaderInfo.url.toString();
            s = s.replace(myPattern, "");
            // Create an Array of name=value Strings.
            var params:Array = s.split("&"); 
             // Print the params that are in the Array.
            var keyStr:String;
            var valueStr:String;
            var paramObj:Object = params;
          
            // Set the values of the salutation.
            for (var i:int = 0; i < params.length; i++) {
                var tempA:Array = params[i].split("=");  
                if (tempA[0] == "mode") {
                    mode = tempA[1];
                } 
            }                    
            
        } catch (e:Error) {
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
        printObject.pDataGrid.dataProvider = rightConditionSummary.dataProvider;
        PrintDG.printAll(printObject); */
    }
    