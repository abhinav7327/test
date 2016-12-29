
 // ActionScript file for Cax Right Detail Query
 
 import com.nri.rui.cax.renderers.EntitlementDetailRenderer;
 import com.nri.rui.cax.validator.RightsDetailQueryValidator;
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.RendererFectory;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosPopupUtils;
 import com.nri.rui.core.utils.XenosStringUtils;
 
 import mx.collections.ArrayCollection;
 import mx.core.UIComponent;
 import mx.events.ListEvent;
 import mx.events.ValidationResultEvent;
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
    
    public var officeId:String="";
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
            req.SCREEN_KEY = 446;
            if(XenosStringUtils.equals(mode, Globals.MODE_CANCEL) || XenosStringUtils.equals(mode, Globals.MODE_AMEND)){
                //mode = Globals.MODE_CANCEL;
                removeExtraField();
            }
            initializeRightsDetailQuery.request = req;
            
            if(XenosStringUtils.equals(mode, Globals.MODE_AMEND)) {
            	initializeRightsDetailQuery.url = "cax/rightsDetailsAmendQueryDispatch.action?method=initialExecute&mode="+mode+"&rnd=" + rndNo;
            } else if(XenosStringUtils.equals(mode, Globals.MODE_CANCEL)) {
            	initializeRightsDetailQuery.url = "cax/rightsDetailsCancelQueryDispatch.action?method=initialExecute&mode="+mode+"&rnd=" + rndNo;
            } else {
                initializeRightsDetailQuery.url = "cax/rightsDetailsQueryDispatch.action?method=initialExecute&mode="+mode+"&rnd=" + rndNo;
            }
                                            
            initializeRightsDetailQuery.send();        
        } else
            XenosAlert.info("Already Initiated!");
     } 
     
     
     
        /**
     * In case of Cancel Operation Mode Disable the status field. 
     */ 
     private function removeExtraField():void {
            statusLbl.includeInLayout = false;
            statusLbl.visible = false;
            status.includeInLayout = false;
            status.visible = false;
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
        var sortField1Default:String = event.result.rightsDetailQueryActionForm.sortField1;
        var sortField2Default:String = event.result.rightsDetailQueryActionForm.sortField2;
        var sortField3Default:String = event.result.rightsDetailQueryActionForm.sortField3;
        var sortField4Default:String = event.result.rightsDetailQueryActionForm.sortField4;
        //var sortField5Default:String = event.result.rightsDetailQueryActionForm.sortField5;        
        
        errPage.clearError(event); //clears the errors if any 
        
        //Initialize all fields
        rdReferenceNo.text = XenosStringUtils.EMPTY_STR;
        rcReferenceNo.text = XenosStringUtils.EMPTY_STR;
        instPopUp.instrumentId.text = XenosStringUtils.EMPTY_STR;
        allotmentInstPopUp.instrumentId.text = XenosStringUtils.EMPTY_STR;
        bankNo.text = XenosStringUtils.EMPTY_STR;
        actPopUp1.accountNo.text = XenosStringUtils.EMPTY_STR;
        actPopUp.accountNo.text = XenosStringUtils.EMPTY_STR; 
        recordDateFrom.selectedDate = null;
        recordDateTo.selectedDate = null;
        paymentDateFrom.selectedDate = null;
        paymentDateTo.selectedDate = null;
        exDateFrom.selectedDate = null;
        exDateTo.selectedDate = null;
        processStartDateFrom.selectedDate = null;
        processStartDateTo.selectedDate = null;
        processEndDateFrom.selectedDate = null;
        processEndDateTo.selectedDate = null;
        entryDateFrom.selectedDate = null;
        entryDateTo.selectedDate = null;
        lastEntryDateFrom.selectedDate = null;
        lastEntryDateTo.selectedDate = null;
        isForTempBalance.selected = false;
        fundPopUp.fundCode.text= XenosStringUtils.EMPTY_STR;
        availableDateFrom.selectedDate=null;
        availableDateTo.selectedDate=null;
        
        //DetailType List
        if(event.result.rightsDetailQueryActionForm.detailTypeList !=null){
                if(event.result.rightsDetailQueryActionForm.detailTypeList.item != null) {
                    if(event.result.rightsDetailQueryActionForm.detailTypeList.item is ArrayCollection)
                        initColl = event.result.rightsDetailQueryActionForm.detailTypeList.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.rightsDetailQueryActionForm.detailTypeList.item);
                }
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value:" "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
       // detailType.dataProvider = tempColl;
       // detailType.setFocus();
        
       //Status List
       initColl.removeAll();
       if(event.result.rightsDetailQueryActionForm.statusDropdownList !=null){
                if(event.result.rightsDetailQueryActionForm.statusDropdownList.item != null) {
                    if(event.result.rightsDetailQueryActionForm.statusDropdownList.item is ArrayCollection)
                        initColl = event.result.rightsDetailQueryActionForm.statusDropdownList.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.rightsDetailQueryActionForm.statusDropdownList.item);
                }
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value:" "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        status.dataProvider = tempColl;
        
       //eventType List
       initColl.removeAll();
       if(event.result.rightsDetailQueryActionForm.corporateActionIdDropdownList !=null){
                if(event.result.rightsDetailQueryActionForm.corporateActionIdDropdownList.item != null) {
                    if(event.result.rightsDetailQueryActionForm.corporateActionIdDropdownList.item is ArrayCollection)
                        initColl = event.result.rightsDetailQueryActionForm.corporateActionIdDropdownList.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.rightsDetailQueryActionForm.corporateActionIdDropdownList.item);
                }
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value:" "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        eventType.dataProvider = tempColl;
        
       //sub eventType List
       initColl.removeAll();
       if(event.result.rightsDetailQueryActionForm.subEventTypeDropDownList !=null){
                if(event.result.rightsDetailQueryActionForm.subEventTypeDropDownList.item != null) {
                    if(event.result.rightsDetailQueryActionForm.subEventTypeDropDownList.item is ArrayCollection)
                        initColl = event.result.rightsDetailQueryActionForm.subEventTypeDropDownList.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.rightsDetailQueryActionForm.subEventTypeDropDownList.item);
                }
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value:" "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        
        
        
        
       //eventTypeStatus List
       initColl.removeAll();
       if(event.result.rightsDetailQueryActionForm.conditionStatusDropdownList !=null){
                if(event.result.rightsDetailQueryActionForm.conditionStatusDropdownList.item != null) {
                    if(event.result.rightsDetailQueryActionForm.conditionStatusDropdownList.item is ArrayCollection)
                        initColl = event.result.rightsDetailQueryActionForm.conditionStatusDropdownList.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.rightsDetailQueryActionForm.conditionStatusDropdownList.item);
                }
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value:" "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        eventTypeStatus.dataProvider = tempColl;
        
        
        //GiveUpDropDown List
        var defaultGiveUp:String = event.result.rightsDetailQueryActionForm.giveUp;
        initColl.removeAll();
        if(event.result.rightsDetailQueryActionForm.giveUpDropDownValues !=null){
                if(event.result.rightsDetailQueryActionForm.giveUpDropDownValues.item != null) {
                    if(event.result.rightsDetailQueryActionForm.giveUpDropDownValues.item is ArrayCollection)
                        initColl = event.result.rightsDetailQueryActionForm.giveUpDropDownValues.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.rightsDetailQueryActionForm.giveUpDropDownValues.item);
                }
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value:" "});
        for(i = 0; i<initColl.length; i++) {
            if(XenosStringUtils.equals((initColl[i].value),defaultGiveUp)){                    
                selIndx = i;
            }
            tempColl.addItem(initColl[i]);    
        }
        giveUpIndicator.dataProvider = tempColl;
        giveUpIndicator.selectedIndex = selIndx+1;
        
        //ExceptionFlagList List
        initColl.removeAll();
        if(event.result.rightsDetailQueryActionForm.exceptionFlagList !=null){
                if(event.result.rightsDetailQueryActionForm.exceptionFlagList.item != null) {
                    if(event.result.rightsDetailQueryActionForm.exceptionFlagList.item is ArrayCollection)
                        initColl = event.result.rightsDetailQueryActionForm.exceptionFlagList.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.rightsDetailQueryActionForm.exceptionFlagList.item);
                }
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value:" "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        exceptionFlag.dataProvider = tempColl;
        
        //FinalizedFlagList List
        initColl.removeAll();
        if(event.result.rightsDetailQueryActionForm.finalizedFlagList !=null){
                if(event.result.rightsDetailQueryActionForm.finalizedFlagList.item != null) {
                    if(event.result.rightsDetailQueryActionForm.finalizedFlagList.item is ArrayCollection)
                        initColl = event.result.rightsDetailQueryActionForm.finalizedFlagList.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.rightsDetailQueryActionForm.finalizedFlagList.item);
                }
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value:" "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        finalizedFlag.dataProvider = tempColl;
        
        //InconsistencyFlagList List
        initColl.removeAll();
        if(event.result.rightsDetailQueryActionForm.inconsistencyFlagList !=null){
                if(event.result.rightsDetailQueryActionForm.inconsistencyFlagList.item != null) {
                    if(event.result.rightsDetailQueryActionForm.inconsistencyFlagList.item is ArrayCollection)
                        initColl = event.result.rightsDetailQueryActionForm.inconsistencyFlagList.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.rightsDetailQueryActionForm.inconsistencyFlagList.item);
                }
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value:" "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        inconsistencyFlag.dataProvider = tempColl;
        
        //CashInLieuFlag List
        initColl.removeAll();
        if(event.result.rightsDetailQueryActionForm.cashInLieuFlagDropDownList !=null){
                if(event.result.rightsDetailQueryActionForm.cashInLieuFlagDropDownList.item != null) {
                    if(event.result.rightsDetailQueryActionForm.cashInLieuFlagDropDownList.item is ArrayCollection)
                        initColl = event.result.rightsDetailQueryActionForm.cashInLieuFlagDropDownList.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.rightsDetailQueryActionForm.cashInLieuFlagDropDownList.item);
                }
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value:" "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        cashinLieuFlag.dataProvider = tempColl;
        
        //Form List
        /* initColl.removeAll();
        if(event.result.rightsDetailQueryActionForm.formDropdownList !=null){
                if(event.result.rightsDetailQueryActionForm.formDropdownList.item != null) {
                    if(event.result.rightsDetailQueryActionForm.formDropdownList.item is ArrayCollection)
                        initColl = event.result.rightsDetailQueryActionForm.formDropdownList.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.rightsDetailQueryActionForm.formDropdownList.item);
                }
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value:" "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        form.dataProvider = tempColl; */
        
        //Data Source List
       initColl.removeAll();
       if(event.result.rightsDetailQueryActionForm.dataSourceDropdownList !=null){
                if(event.result.rightsDetailQueryActionForm.dataSourceDropdownList.item != null) {
                    if(event.result.rightsDetailQueryActionForm.dataSourceDropdownList.item is ArrayCollection)
                        initColl = event.result.rightsDetailQueryActionForm.dataSourceDropdownList.item as ArrayCollection;
                    else
                        initColl.addItem(event.result.rightsDetailQueryActionForm.dataSourceDropdownList.item);
                }
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value:" "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        dataSource.dataProvider = tempColl;
        
        //populate office id
        if(XenosStringUtils.equals(mode, Globals.MODE_AMEND) || XenosStringUtils.equals(mode, Globals.MODE_CANCEL)) {
	        tempColl=new ArrayCollection();
	        tempColl.addItem("");
	        initColl.removeAll();	        
	        if(event.result.rightsDetailQueryActionForm.officeValues !=null){	        		
	                if(event.result.rightsDetailQueryActionForm.officeValues.item != null) {	                	
	                    if(event.result.rightsDetailQueryActionForm.officeValues.item is ArrayCollection){	                    
	                        initColl = event.result.rightsDetailQueryActionForm.officeValues.item as ArrayCollection;
	                    }
	                    else
	                    {
	                        //initColl = new ArrayCollection();
	                        initColl.addItem(event.result.rightsDetailQueryActionForm.officeValues.item);
	                    }
	                }         
	            for(i = 0; i<initColl.length; i++) {
	                tempColl.addItem(initColl[i]);            
	            }
	       }
	       officeIdList.dataProvider = tempColl;
	       officeIdList.selectedIndex=-1;
          }
          
          //populate Fund Category
           if(XenosStringUtils.equals(mode, Globals.MODE_AMEND) || XenosStringUtils.equals(mode, Globals.MODE_CANCEL)) {
	           	tempColl=new ArrayCollection();
		        tempColl.addItem({label:" ", value:" "});
		        initColl.removeAll();
		       	if(event.result.rightsDetailQueryActionForm.fundCategoryList !=null){
		                if(event.result.rightsDetailQueryActionForm.fundCategoryList.item != null) {
		                    if(event.result.rightsDetailQueryActionForm.fundCategoryList.item is ArrayCollection)
		                        initColl = event.result.rightsDetailQueryActionForm.fundCategoryList.item as ArrayCollection;
		                    else
		                        initColl.addItem(event.result.rightsDetailQueryActionForm.fundCategoryList.item);
		                }
		        }
		      for(i = 0; i<initColl.length; i++) {
	            tempColl.addItem(initColl[i]);    
	        }
	        fundCategoryList.dataProvider = tempColl;
           }
          
        //Initialize sortFieldList1.
        selIndx =0;
        if(null != event.result.rightsDetailQueryActionForm.sortFieldList1.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            initColl = event.result.rightsDetailQueryActionForm.sortFieldList1.item as ArrayCollection;
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
        if(null != event.result.rightsDetailQueryActionForm.sortFieldList2.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx=0;
            
            initColl = event.result.rightsDetailQueryActionForm.sortFieldList2.item as ArrayCollection;
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
        if(null != event.result.rightsDetailQueryActionForm.sortFieldList3.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
            
            initColl = event.result.rightsDetailQueryActionForm.sortFieldList3.item as ArrayCollection;
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
        if(null != event.result.rightsDetailQueryActionForm.sortFieldList4.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
            
            initColl = event.result.rightsDetailQueryActionForm.sortFieldList4.item as ArrayCollection;
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

        //Initialize sortFieldList5.
        /*if(null != event.result.rightsDetailQueryActionForm.sortFieldList5.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
            
            initColl = event.result.rightsDetailQueryActionForm.sortFieldList5.item as ArrayCollection;
            for(i = 0; i<initColl.length; i++) {
                //Get the default value object's index
                if(XenosStringUtils.equals((initColl[i].value),sortField5Default)){                    
                    selIndx = i;
                }
                
                tempColl.addItem(initColl[i]);            
            }
            
            sortFieldArray[4]=sortField5;
            sortFieldDataSet[4]=tempColl;
            //Set the default value object
            sortFieldSelectedItem[4] = tempColl.getItemAt(selIndx+1);
        } else {
            XenosAlert.error("Sort Order Field List 5 not Populated");
        }*/

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
        if(event.result.rightsDetailQueryActionForm.subEventTypeDropDownList != null && this.eventType.selectedItem != XenosStringUtils.EMPTY_STR){
            
            if(event.result.rightsDetailQueryActionForm.subEventTypeDropDownList.item is ArrayCollection){
               initColl = event.result.rightsDetailQueryActionForm.subEventTypeDropDownList.item as ArrayCollection;                
            }else{
                initColl=new ArrayCollection();
                initColl.addItem(event.result.rightsDetailQueryActionForm.subEventTypeDropDownList.item);
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

        if(XenosStringUtils.equals(mode, Globals.MODE_AMEND)) {
            rightDetailResetRequest.url = "cax/rightsDetailsAmendQueryDispatch.action?method=resetDetail";
        } else if(XenosStringUtils.equals(mode, Globals.MODE_CANCEL)) {
            rightDetailResetRequest.url = "cax/rightsDetailsCancelQueryDispatch.action?method=resetDetail";
        } else {
            rightDetailResetRequest.url = "cax/rightsDetailsQueryDispatch.action?method=resetDetail";
        }        
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
         
        if(XenosStringUtils.equals(mode, Globals.MODE_AMEND)) {
        	rightDetailRequest.url = "cax/rightsDetailsAmendQueryDispatch.action?";
        } else if(XenosStringUtils.equals(mode, Globals.MODE_CANCEL)) {
        	rightDetailRequest.url = "cax/rightsDetailsCancelQueryDispatch.action?";
        } else {
            rightDetailRequest.url = "cax/rightsDetailsQueryDispatch.action?";
        }
        //Set the request parameters
         var requestObj :Object = populateRequestParams();
         
         rightDetailRequest.request = requestObj;
         
         
         
         var myModel:Object={
                            rdQuery:{
                                 
                                 recordDateFrom:this.recordDateFrom.text,
                                 recordDateTo:this.recordDateTo.text,
                                 paymentDateFrom:this.paymentDateFrom.text,
                                 paymentDateTo:this.paymentDateTo.text,
                                 exDateFrom:this.exDateFrom.text,
                                 exDateTo:this.exDateTo.text,
                                 processStartDateFrom:this.processStartDateFrom.text,
                                 processStartDateTo:this.processStartDateTo.text ,
                                 processEndDateFrom:this.processEndDateFrom.text,
                                 processEndDateTo:this.processEndDateTo.text, 
                                 entryDateFrom:this.entryDateFrom.text,
                                 entryDateTo:this.entryDateTo.text,
                                 lastEntryDateFrom:this.lastEntryDateFrom.text,
                                 lastEntryDateTo:this.lastEntryDateTo.text,
                                 availableDateFrom:this.availableDateFrom.text,
                                 availableDateTo:this.availableDateTo.text        
                            }
                           }; 
        
         var rdQueryValidator : RightsDetailQueryValidator = new RightsDetailQueryValidator();
         rdQueryValidator.source=myModel;
         rdQueryValidator.property="rdQuery";
         var validationResult:ValidationResultEvent = rdQueryValidator.validate();  
         if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            //trace(errorMsg);
            XenosAlert.error(errorMsg);
        }
        else{                           
            rightDetailRequest.send();
        }
     }
     /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
        addExtraColumn();
        qh.dgrid = rdSummary;
    } 
     /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
         if(XenosStringUtils.equals(mode, Globals.MODE_CANCEL) || XenosStringUtils.equals(mode, Globals.MODE_AMEND))
            reqObj.SCREEN_KEY = 447;
         else
            reqObj.SCREEN_KEY = 446;
        reqObj.method = "submitQuery";
        reqObj.modeOfOperation = mode;
        reqObj.detailType = "RIGHTS_DETAIL";
        reqObj.detailReferenceNo = this.rdReferenceNo.text;
        reqObj.conditionReferenceNo = this.rcReferenceNo.text;
        reqObj.corporateActionId = (this.eventType.selectedItem != null ? this.eventType.selectedItem.value : XenosStringUtils.EMPTY_STR);
        reqObj.conditionStatus = (this.eventTypeStatus.selectedItem != null ? this.eventTypeStatus.selectedItem.value : XenosStringUtils.EMPTY_STR);
        reqObj.dataSource = (this.dataSource.selectedItem != null? this.dataSource.selectedItem.value : "");
        reqObj.instrumentCode = this.instPopUp.instrumentId.text;
        reqObj.allotmentInstrumentCode = this.allotmentInstPopUp.instrumentId.text;
        reqObj.bankNo = this.bankNo.text;
        reqObj.bankAccountNo = actPopUp1.accountNo.text;
        reqObj.accountNo = this.actPopUp.accountNo.text;
        reqObj.recordDateFromStr = this.recordDateFrom.text;
        reqObj.recordDateToStr = this.recordDateTo.text;
        reqObj.paymentDateFromStr = this.paymentDateFrom.text;
        reqObj.paymentDateToStr = this.paymentDateTo.text;
        reqObj.exDateFromStr = this.exDateFrom.text;
        reqObj.exDateToStr = this.exDateTo.text;
        reqObj.processStartDateFromStr = this.processStartDateFrom.text;
        reqObj.processStartDateToStr = this.processStartDateTo.text;
        reqObj.processEndDateFromStr = this.processEndDateFrom.text;
        reqObj.processEndDateToStr = this.processEndDateTo.text;
        reqObj.availableDateFromStr=this.availableDateFrom.text;
        reqObj.availableDateToStr=this.availableDateTo.text;
        
 		if(XenosStringUtils.equals(mode,Globals.MODE_QUERY)) {             	
            reqObj.status = (this.status.selectedItem != null ? this.status.selectedItem.value : XenosStringUtils.EMPTY_STR);
        } else {
            reqObj.status = ""; 
        } 
        reqObj.giveUp = (this.giveUpIndicator.selectedItem != null ? this.giveUpIndicator.selectedItem.value : XenosStringUtils.EMPTY_STR);
        reqObj.exceptionFlag = (this.exceptionFlag.selectedItem != null ? this.exceptionFlag.selectedItem.value : XenosStringUtils.EMPTY_STR);
        reqObj.finalizedFlag = (this.finalizedFlag.selectedItem != null ? this.finalizedFlag.selectedItem.value : XenosStringUtils.EMPTY_STR);
        reqObj.inconsistencyFlag = (this.inconsistencyFlag.selectedItem != null ? this.inconsistencyFlag.selectedItem.value : XenosStringUtils.EMPTY_STR);
        reqObj.cashInLieuFlag = (this.cashinLieuFlag.selectedItem != null ? this.cashinLieuFlag.selectedItem.value : XenosStringUtils.EMPTY_STR);
        //reqObj.form = (this.form.selectedItem != null ? this.form.selectedItem.value : XenosStringUtils.EMPTY_STR);
        reqObj.entryDateFromStr  = this.entryDateFrom.text;
        reqObj.entryDateToStr = this.entryDateTo.text;
        reqObj.lastEntryDateFromStr = this.lastEntryDateFrom.text;
        reqObj.lastEntryDateToStr = this.lastEntryDateTo.text;
        reqObj.isForTempBalance = this.isForTempBalance.selected == true ? "Y":"N";
        reqObj.fundCode = this.fundPopUp.fundCode.text;
        reqObj.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.sortField3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.sortField4 = this.sortField4.selectedItem != null ? StringUtil.trim(this.sortField4.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.lmOfficeId = (officeIdList.selectedItem!=null)?officeIdList.selectedItem.toString():"";
        reqObj.dataSource = (this.dataSource.selectedItem != null? this.dataSource.selectedItem.value : "");
        reqObj.fundCategory = (this.fundCategoryList.selectedItem!=null?this.fundCategoryList.selectedItem.value :"");
        
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
                    if(summaryResult.length==1 && !XenosStringUtils.equals(mode, Globals.MODE_CANCEL) && !XenosStringUtils.equals(mode, Globals.MODE_AMEND)){
                     displayDetailView(summaryResult[0].rightsDetailPk,summaryResult[0].settlementReferenceNo,summaryResult[0].slrActionReferenceNo);
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
      
    private function displayDetailView(rightsDetailPk:String,stlRefNo:String,slrRefNo:String):void {
            
            var parentApp :UIComponent = UIComponent(this.parentApplication);
            
            XenosPopupUtils.showCaxRightsDetails(rightsDetailPk,parentApp,stlRefNo,slrRefNo);   
        }
    /*
    private function changeCurrentState():void{
            currentState = "result";
    }
     * */       
      
    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
     private function doNext():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
        rightDetailRequest.request = reqObj;
        rightDetailRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        rightDetailRequest.request = reqObj;
        rightDetailRequest.send();
    }
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {     	
     	var url : String = "";
        if(XenosStringUtils.equals(mode, Globals.MODE_AMEND)) {
        	url = "cax/rightsDetailsAmendQueryDispatch.action?method=generateXLS";
        } else if(XenosStringUtils.equals(mode, Globals.MODE_CANCEL)) {
        	url = "cax/rightsDetailsCancelQueryDispatch.action?method=generateXLS";
        } else {
            url = "cax/rightsDetailsQueryDispatch.action?method=generateXLS";
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
        if(XenosStringUtils.equals(mode, Globals.MODE_AMEND)) {
        	url = "cax/rightsDetailsAmendQueryDispatch.action?method=generatePDF";
        } else if(XenosStringUtils.equals(mode, Globals.MODE_CANCEL)) {
        	url = "cax/rightsDetailsCancelQueryDispatch.action?method=generatePDF";
        } else {
            url = "cax/rightsDetailsQueryDispatch.action?method=generatePDF";
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
    * This is called at creationComplete of the module
    */
     private function loadAll():void {
     	parseUrlString();
        if(XenosStringUtils.equals(mode,Globals.MODE_AMEND) || XenosStringUtils.equals(mode,Globals.MODE_CANCEL)){
        	officeIdGrid1.includeInLayout=true;
        	officeIdGrid1.visible=true;
        	officeIdGrid2.includeInLayout=true;
        	officeIdGrid2.visible=true;
        }  

     } 

  
     /**
     * In case of Delete Operation Mode Add Extra column in the result columns.
     */    
    private function addExtraColumn():void {
        if(XenosStringUtils.equals(mode, Globals.MODE_CANCEL)
            || XenosStringUtils.equals(mode, Globals.MODE_AMEND)){
            var delColumn:DataGridColumn = new DataGridColumn();
            delColumn.headerText = "";
            delColumn.draggable=false;
            delColumn.resizable=false;
            delColumn.width = 40;
            delColumn.itemRenderer = new  RendererFectory(EntitlementDetailRenderer, mode);
            
            //delColumn.
            var colArray:Array = rdSummary.columns;
            var customArray:Array = new Array();            
            
            customArray.push(colArray[0]);
            customArray.push(delColumn);
            for(var i:int=1; i<colArray.length;i++){
                customArray.push(colArray[i]);
            }            
            
            rdSummary.columns = customArray;
            
            qh.startIndex = 2; // To list list the columns from the 3rd column
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
