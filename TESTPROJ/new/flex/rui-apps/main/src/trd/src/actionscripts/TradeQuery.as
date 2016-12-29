// ActionScript file

 // ActionScript file for Trade Query
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.containers.SummaryPopup;
    import com.nri.rui.core.controls.CustomizeSortOrder;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.HiddenObject;
    import com.nri.rui.core.utils.XenosStringUtils;
    import com.nri.rui.ref.popupImpl.FinInstitutePopUpHbox;
    import com.nri.rui.ref.popupImpl.StrategyPopUpHBox;
    import com.nri.rui.trd.validator.TradeQueryValidator;
    import com.nri.rui.core.utils.ProcessResultUtil;
    
    import mx.collections.ArrayCollection;
    import mx.core.UIComponent;
    import mx.events.ResourceEvent;
    import mx.events.ValidationResultEvent;
    import mx.managers.PopUpManager;
    import mx.resources.ResourceBundle;
    import mx.rpc.events.ResultEvent;
    
    
    [Bindable]
    private var initColl:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var queryResult:ArrayCollection= new ArrayCollection();
    private var emptyResult:ArrayCollection= new ArrayCollection();
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
    private var finInst:FinInstitutePopUpHbox = new FinInstitutePopUpHbox();
    [Bindable]
    private var strategyPopup:StrategyPopUpHBox = new StrategyPopUpHBox();
    
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    
    private var  csd:CustomizeSortOrder=null;
    
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    private function initPageStart():void {   
    	
    	finInst.percentWidth = 50;
    	finInst.name = "Broker";
    	finInst.recContextItem = populateFinInstRole();
    	strategyPopup.percentWidth = 50;
    	strategyPopup.name = "Firm";
    	
    	counterpartyCodeBox.addChild(finInst);        
        if (!initCompFlg) {    
            rndNo= Math.random();
            var req : Object = new Object();
            req.SCREEN_KEY = 41;
            initializeTradeQuery.request = req;        
            initializeTradeQuery.url = "trd/tradeQuery.action?method=initialExecute&mode=query&menuType=Y&rnd=" + rndNo;                    
            initializeTradeQuery.send();        
        } else
            XenosAlert.info("Already Initiated!");
         
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
    * This method works as the result handler of the Initialization/Reset Http Services.
    * 
    */   
    private function initPage(event: ResultEvent) : void {
        var i:int = 0;
        var selIndx:int = 0;
        var dateStr:String = null;
        
        //variables to hold the default values from the server
        var sortField1Default:String = event.result.tradeQueryActionForm.sortField1;
        var sortField2Default:String = event.result.tradeQueryActionForm.sortField2;
        var sortField3Default:String = event.result.tradeQueryActionForm.sortField3;
        var sortField4Default:String = event.result.tradeQueryActionForm.sortField4;
    	
    	errPage.clearError(event); //clears the errors if any  
    	if(initColl.length > 0){
    		initColl.removeAll();
    	}   
        initColl = event.result.tradeQueryActionForm.tradeTypeValues.item as ArrayCollection;
        if(event.result.tradeQueryActionForm.tradeTypeValues.item !=null){
        	if(event.result.tradeQueryActionForm.tradeTypeValues.item is ArrayCollection){
	        	initColl = event.result.tradeQueryActionForm.tradeTypeValues.item as ArrayCollection;
	        }else{
	        	initColl.addItem(event.result.tradeQueryActionForm.tradeTypeValues.item);
	        }
        }
    
        var tempColl: ArrayCollection = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
        tradeType.dataProvider = tempColl;
        
        // trdRefNo
        trdRefNo.text="";   
             
        //office id
        initColl.removeAll();
        if(event.result.tradeQueryActionForm.serviceOfficeList.officeId !=null){
        	if(event.result.tradeQueryActionForm.serviceOfficeList.officeId is ArrayCollection){
	        	initColl = event.result.tradeQueryActionForm.serviceOfficeList.officeId as ArrayCollection;
	        }else{
	        	initColl.addItem(event.result.tradeQueryActionForm.serviceOfficeList.officeId);
	        }
        }
        
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
        officeId.dataProvider = tempColl;
        
        //buysellflag
        //initColl = event.result.tradeQueryActionForm.buySellFlagValues.item as ArrayCollection;]
		initColl.removeAll();	
		if(event.result.tradeQueryActionForm.buySellFlagValues.item !=null){
        	if(event.result.tradeQueryActionForm.buySellFlagValues.item is ArrayCollection){
	        	initColl = event.result.tradeQueryActionForm.buySellFlagValues.item as ArrayCollection;
	        }else{
	        	initColl.addItem(event.result.tradeQueryActionForm.buySellFlagValues.item);
	        }
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
        buySellFlag.dataProvider = tempColl;
        
        
        //negative accrual flag        
        initColl.removeAll();
        if(event.result.tradeQueryActionForm.negativeAccrualFlagValues.item !=null){
        if(event.result.tradeQueryActionForm.negativeAccrualFlagValues.item is ArrayCollection){
                initColl = event.result.tradeQueryActionForm.negativeAccrualFlagValues.item as ArrayCollection;
        }
            else{
                initColl.addItem(event.result.tradeQueryActionForm.negativeAccrualFlagValues.item);
            }
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
         for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        } 
        negativeAccrualFlag.dataProvider = tempColl;
        
        showNegativeAccrualFlag();
        
        //matchstatusflag
        initColl.removeAll();
        if(event.result.tradeQueryActionForm.matchStatusFlagValues.item !=null){
        if(event.result.tradeQueryActionForm.matchStatusFlagValues.item is ArrayCollection){
                initColl = event.result.tradeQueryActionForm.matchStatusFlagValues.item as ArrayCollection;
        }
            else{
                initColl.addItem(event.result.tradeQueryActionForm.matchStatusFlagValues.item);
            }
         }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
        matchStatusFlag.dataProvider = tempColl;
        
        //principalAgentFlag
        initColl.removeAll();
        initColl = event.result.tradeQueryActionForm.principalAgentFlagValues.item as ArrayCollection;
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
        
        //inventoryAccountNo
        inventoryAccountNo.accountNo.text=""; 
        
        //fundCode
        fundPopUp.fundCode.text="";
        fundPopUp.fundCode.setFocus();
        
        //instrumentType
        instrumentType.text="";
        
        //security
        security.instrumentId.text="";
        
        //tradecurrency
        tradecurrency.ccyText.text="";
        
        //market
		listedMarket.itemCombo.text="";
		   
        //counterpartyCode
        //initColl = event.result.tradeQueryActionForm.counterPartyTypeList.item as ArrayCollection;
		initColl.removeAll();
		if(event.result.tradeQueryActionForm.counterPartyTypeList.item !=null){
        if(event.result.tradeQueryActionForm.counterPartyTypeList.item is ArrayCollection){
                initColl = event.result.tradeQueryActionForm.counterPartyTypeList.item as ArrayCollection;
        }
            else{
                initColl.addItem(event.result.tradeQueryActionForm.counterPartyTypeList.item);
            }
  		}
    	
        tempColl = new ArrayCollection();
        //for(i = 0; i < 1; i++) {
            tempColl.addItem(initColl[0]);    
        
        //}
        counterpartyCode.dataProvider = tempColl;
        counterpartyCode.selectedItem = tempColl[0];
        
        if(finInst!=null){
        	if(finInst.finInstCode !=null){
        		finInst.finInstCode.text = "";
        	}
        	finInst.name = "Broker";
        }
        if(strategyPopup!=null){
        	if(strategyPopup.strategyCode !=null){
        		strategyPopup.strategyCode.text="";
        	}
        	strategyPopup.name = "Firm";
        }
    	//counterpartyCodeBox.addChild(finInst); 
    	onChangeCounterpartyCode();
        
        //trddateFrom
        //trddateFrom.text=event.result.tradeQueryActionForm.tradeDateFrom == null ? "":event.result.tradeQueryActionForm.tradeDateFrom;
        
        //trddateTo
        //trddateTo.text=event.result.tradeQueryActionForm.tradeDateTo == null ? "":event.result.tradeQueryActionForm.tradeDateTo;
        
        
        //Setting dateFrom and dateTo
        if(event.result.tradeQueryActionForm.tradeDateFrom!= null && event.result.tradeQueryActionForm.tradeDateTo != null) {
            dateStr=event.result.tradeQueryActionForm.tradeDateFrom;
            if(dateStr != null)
                trddateFrom.selectedDate = DateUtils.toDate(dateStr);                

            dateStr=event.result.tradeQueryActionForm.tradeDateTo;
            if(dateStr != null)
                trddateTo.selectedDate = DateUtils.toDate(dateStr);
                                
        } else {
            XenosAlert.error("Error: From Date and To Date cannot be initialized.");
        }
        
        
        
        //valuedateFrom
        valuedateFrom.text="";
        
        //valuedateTo
        valuedateTo.text="";
        
        //lastEntryDateFrom
        lastEntryDateFrom.text="";
        
        //lastEntryDateTo
        lastEntryDateTo.text="";
        
        //EntryDateFrom
        EntrydateFrom.text="";
        
        //EntryDateTo
        EntrydateTo.text="";
        
        //omsExecutionNo
        extrefno.text="";
        
        //External Reference No
        externalReferenceNo.text=""; 
        
        //etcrefno
        etcrefno.text=""; 
        
        //orderreferenceno
        orderreferenceno.text=""; 
        
        //cancelrefno
        cancelrefno.text="";
        
        //tradestatus
        //initColl = event.result.tradeQueryActionForm.statusValues.item as ArrayCollection;
		initColl.removeAll();
		if(event.result.tradeQueryActionForm.statusValues.item !=null){
        if(event.result.tradeQueryActionForm.statusValues.item is ArrayCollection){
                initColl = event.result.tradeQueryActionForm.statusValues.item as ArrayCollection;
        }
            else{
                initColl.addItem(event.result.tradeQueryActionForm.statusValues.item);
            }
  		}
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
        tradestatus.dataProvider = tempColl;
        
        //tbaAllocableStatus
        //initColl = event.result.tradeQueryActionForm.allocationStatusValues.item as ArrayCollection;
		initColl.removeAll();
		if(event.result.tradeQueryActionForm.allocationStatusValues.item !=null){
        if(event.result.tradeQueryActionForm.allocationStatusValues.item is ArrayCollection){
                initColl = event.result.tradeQueryActionForm.allocationStatusValues.item as ArrayCollection;
        }
            else{
                initColl.addItem(event.result.tradeQueryActionForm.allocationStatusValues.item);
            }
  		}
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
        
        //userId
        userId.text="";  
        
        //compressedTradeFlag
		initColl.removeAll();
		if(event.result.tradeQueryActionForm.compressedTradeFlagValues.item !=null){
        if(event.result.tradeQueryActionForm.compressedTradeFlagValues.item is ArrayCollection){
                initColl = event.result.tradeQueryActionForm.compressedTradeFlagValues.item as ArrayCollection;
        }
            else{
                initColl.addItem(event.result.tradeQueryActionForm.compressedTradeFlagValues.item);
            }
  		}
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
        
        //formT
        initColl.removeAll();
        if(event.result.tradeQueryActionForm.formTypeValues.item !=null){
        if(event.result.tradeQueryActionForm.formTypeValues.item is ArrayCollection){
                initColl = event.result.tradeQueryActionForm.formTypeValues.item as ArrayCollection;
        }
            else{
                initColl.addItem(event.result.tradeQueryActionForm.formTypeValues.item);
            }
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
        
        //idConfirmationEligible
        initColl.removeAll();
        if(event.result.tradeQueryActionForm.idConfirmationEligibleValues.item !=null){
        if(event.result.tradeQueryActionForm.idConfirmationEligibleValues.item is ArrayCollection){
                initColl = event.result.tradeQueryActionForm.idConfirmationEligibleValues.item as ArrayCollection;
        }
            else{
                initColl.addItem(event.result.tradeQueryActionForm.idConfirmationEligibleValues.item);
            }
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
        
        //shortellExemptFlag
        initColl.removeAll();
        if(event.result.tradeQueryActionForm.shortSellExemptFlagValues.item !=null){
        if(event.result.tradeQueryActionForm.shortSellExemptFlagValues.item is ArrayCollection){
                initColl = event.result.tradeQueryActionForm.shortSellExemptFlagValues.item as ArrayCollection;
        }
            else{
                initColl.addItem(event.result.tradeQueryActionForm.shortSellExemptFlagValues.item);
            }
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
        shortellExemptFlag.dataProvider = tempColl;
        
        //shortSellingFlagValues
        initColl.removeAll();
        if(event.result.tradeQueryActionForm.shortSellingFlagValues.item !=null){
        if(event.result.tradeQueryActionForm.shortSellingFlagValues.item is ArrayCollection){
                initColl = event.result.tradeQueryActionForm.shortSellingFlagValues.item as ArrayCollection;
        }
            else{
                initColl.addItem(event.result.tradeQueryActionForm.shortSellingFlagValues.item);
            }
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
        shortsellingFlag.dataProvider = tempColl;  
        
        //dataSource
        initColl.removeAll();
        if(event.result.tradeQueryActionForm.dataSourceValues.item !=null){
        if(event.result.tradeQueryActionForm.dataSourceValues.item is ArrayCollection){
                initColl = event.result.tradeQueryActionForm.dataSourceValues.item as ArrayCollection;
        }
            else{
                initColl.addItem(event.result.tradeQueryActionForm.dataSourceValues.item);
            }
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
        
        initColl.removeAll();
        if(null != event.result.tradeQueryActionForm.sortFieldList1.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        	
        	if(event.result.tradeQueryActionForm.sortFieldList1.item is ArrayCollection)
                initColl = event.result.tradeQueryActionForm.sortFieldList1.item as ArrayCollection;
            else
                initColl.addItem(event.result.tradeQueryActionForm.sortFieldList1.item);
        	
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
        
        
        initColl.removeAll();
        if(null != event.result.tradeQueryActionForm.sortFieldList2.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        	
        	if(event.result.tradeQueryActionForm.sortFieldList2.item is ArrayCollection)
                initColl = event.result.tradeQueryActionForm.sortFieldList2.item as ArrayCollection;
            else
                initColl.addItem(event.result.tradeQueryActionForm.sortFieldList2.item);
        	
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
        
        initColl.removeAll();
        if(null != event.result.tradeQueryActionForm.sortFieldList3.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        	
        	if(event.result.tradeQueryActionForm.sortFieldList3.item is ArrayCollection)
                initColl = event.result.tradeQueryActionForm.sortFieldList3.item as ArrayCollection;
            else
                initColl.addItem(event.result.tradeQueryActionForm.sortFieldList3.item);
        	
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
        
        
        initColl.removeAll();
        if(null != event.result.tradeQueryActionForm.sortFieldList4.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        	
        	if(event.result.tradeQueryActionForm.sortFieldList4.item is ArrayCollection)
                initColl = event.result.tradeQueryActionForm.sortFieldList4.item as ArrayCollection;
            else
                initColl.addItem(event.result.tradeQueryActionForm.sortFieldList4.item);
        	
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
		csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
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
     
    private function loadAll():void {
    }
    
	
    
    public function submitQuery():void{
    	
    	//Reset Page No
    	 qh.resetPageNo();    	
     	//Set the request parameters
     	var requestObj :Object = populateRequestParams();
     	
     	tradeQueryRequest.request = requestObj; 
    	var myModel:Object={
                            tradeQuery:{
                                 
                                 trddateFrom:this.trddateFrom.text,
                                 trddateTo:this.trddateTo.text,
                                 valuedateFrom:this.valuedateFrom.text,
                                 valuedateTo:this.valuedateTo.text,
                                 lastEntryDateFrom:this.lastEntryDateFrom.text,
                                 lastEntryDateTo:this.lastEntryDateTo.text,
                                 EntrydateFrom:this.EntrydateFrom.text,
                                 EntrydateTo:this.EntrydateTo.text
                                        
                            }
                           }; 
		var tradeQueryValidator:TradeQueryValidator = new TradeQueryValidator();
		tradeQueryValidator.source=myModel;
		tradeQueryValidator.property="tradeQuery";
		var validationResult:ValidationResultEvent =tradeQueryValidator.validate();
		
		if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
        }
        else{
    	tradeQueryRequest.send();  
        }
    		
    }
    
     
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	reqObj.SCREEN_KEY = 672;
     	reqObj.method = "submitQuery";
     	
        reqObj.tradeType = this.tradeType.selectedItem != null ?  this.tradeType.selectedItem.value : "";
        reqObj.referenceNo = this.trdRefNo.text;
        reqObj.officeId = this.officeId.selectedItem != null ?  this.officeId.selectedItem.value : "";
        reqObj.matchStatusFlag = this.matchStatusFlag.selectedItem != null ?  this.matchStatusFlag.selectedItem.value : "";
        reqObj.buySellFlag = this.buySellFlag.selectedItem != null ?  this.buySellFlag.selectedItem.value : "";
        reqObj.inventoryAccountNo = this.inventoryAccountNo.accountNo.text; 
        reqObj.fundCode = this.fundPopUp.fundCode.text;
        reqObj.instrumentType = this.instrumentType.itemCombo.text;
        reqObj.securityCode = this.security.instrumentId.text;      
        reqObj.tradeCcy = this.tradecurrency.ccyText.text;
        reqObj.executionMarket = this.listedMarket.itemCombo.text; 
        reqObj.counterPartyType = this.counterpartyCode.selectedItem != null ?  this.counterpartyCode.selectedItem.value : "";
        if(counterpartyCode.selectedItem.label == "BROKER"){
    		 reqObj.counterPartyCode= this.finInst.finInstCode.text != null ? this.finInst.finInstCode.text : "";
    	}
    	if(counterpartyCode.selectedItem.label == "FIRM"){
    		reqObj.counterPartyCode= this.strategyPopup.strategyCode.text != null ? this.strategyPopup.strategyCode.text : "";
    	} 
    	if(tradeType != null){
    		if(tradeType.selectedItem != null){
    			if(tradeType.selectedItem.value == "BOND"){
		    		reqObj.negativeAccrualFlag = this.negativeAccrualFlag.selectedItem != null ?  this.negativeAccrualFlag.selectedItem.value : "";
		    	}
    		}
    	}   
        reqObj.tradeDateFrom = this.trddateFrom.text; 
        reqObj.tradeDateTo = this.trddateTo.text;           
        reqObj.valueDateFrom = this.valuedateFrom.text; 
        reqObj.valueDateTo = this.valuedateTo.text;           
        reqObj.updateDateFrom = this.lastEntryDateFrom.text; 
        reqObj.updateDateTo = this.lastEntryDateTo.text; 
        reqObj.entryDateFrom = this.EntrydateFrom.text; 
        reqObj.entryDateTo = this.EntrydateTo.text;
        reqObj.omsExecutionNo = this.extrefno.text; 
        reqObj.externalReferenceNo = this.externalReferenceNo.text; 
        reqObj.etcReferenceNo = this.etcrefno.text; 
        reqObj.orderReferenceNo = this.orderreferenceno.text; 
        reqObj.cancelReferenceNo = this.cancelrefno.text;
        reqObj.status = this.tradestatus.selectedItem != null ?  this.tradestatus.selectedItem.value : "";
        reqObj.userId = this.userId.text;
        reqObj.shortSellExemptFlag = this.shortellExemptFlag.selectedItem != null ?  this.shortellExemptFlag.selectedItem.value : "";
        reqObj.shortSellingFlag = this.shortsellingFlag.selectedItem != null ?  this.shortsellingFlag.selectedItem.value : "";   
        reqObj.sortField1 = this.sortField1.selectedItem != null ? this.sortField1.selectedItem.value : "";
        reqObj.sortField2 = this.sortField2.selectedItem != null ? this.sortField2.selectedItem.value : "";
        reqObj.sortField3 = this.sortField3.selectedItem != null ? this.sortField3.selectedItem.value : "";
        reqObj.sortField4 = this.sortField4.selectedItem != null ? this.sortField4.selectedItem.value : "";
     	reqObj.rnd = Math.random() + "";
     	
     	return reqObj;
    }
    
    
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    
    private function LoadResultPage(event:ResultEvent):void {
     	
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
		            if(queryResult.length==1){
		             	displayDetailView(queryResult[0].tradePk);
		             }
	     	        //replace null objects in with empty string
					queryResult=ProcessResultUtil.process(queryResult,tradeQueryResult.columns);
					queryResult.refresh();
				}catch(e:Error){
				    //XenosAlert.error(e.toString() + e.message);
				    XenosAlert.error("No result found");
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
			 	XenosAlert.info("No Result Found!");
			 	queryResult.removeAll(); // clear previous data if any as there is no result now.
			 	errPage.removeError(); //clears the errors if any
			 }
        }
     }

    
    
    
    /*public function LoadResultPage(event:ResultEvent):void {
    	if (null != event) {            
            if(null == event.result.rows){
                queryResult.removeAll(); // clear previous data if any as there is no result now.
            	if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
            	    errPage.clearError(event); //clears the errors if any
            		XenosAlert.info("No Result Found!");
            	} else { // Must be error
            		errPage.displayError(event);	
            	}            	
            }else {
            	errPage.clearError(event);   
	            if(event.result.rows.row is ArrayCollection) {
	                    queryResult = event.result.rows.row as ArrayCollection;
	            } else {
	                    queryResult.removeAll();
	                    queryResult.addItem(event.result.rows.row);
	             }
	             
	              if(queryResult[0]==null){			             	
		            queryResult.removeAll();
		            XenosAlert.info("No Results Found");
		            return;
	             }
	             changeCurrentState();
	             qh.setOnResultVisibility();
	             qh.setPrevNextVisibility(Boolean(event.result.rows.prevTraversable),Boolean(event.result.rows.nextTraversable));
	             qh.PopulateDefaultVisibleColumns();
	             if(queryResult.length==1){
	             	displayDetailView(queryResult[0].tradePk);
	             }
	             
	            //replace null objects in with empty string
				queryResult=ProcessResultUtil.process(queryResult,tradeQueryResult.columns);
				queryResult.refresh();
            
            } 
        }else {
            queryResult.removeAll();
            XenosAlert.info("No Results Found");
        }
    }*/
    private function displayDetailView(tradePkStr:String):void{
    	
			var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
			
			sPopup.title = "Trade Details Summary";
			sPopup.width = 650;
    		sPopup.height = 420;
			PopUpManager.centerPopUp(sPopup);		
			sPopup.moduleUrl = Globals.TRADE_DETAILS_SWF+Globals.QS_SIGN+Globals.TRADE_PK+Globals.EQUALS_SIGN+tradePkStr;
			
    }
    
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
    
    public function resetQuery():void{
        tradeResetQueryRequest.send();
    	
    }
    
    
    private function onChangeCounterpartyCode():void{
    	if(counterpartyCode.selectedItem.label == "BROKER"){
    		if(counterpartyCodeBox.getChildByName("Firm")){
    			strategyPopup.strategyCode.text="";
	    		counterpartyCodeBox.addChild(finInst);
	    		counterpartyCodeBox.removeChild(strategyPopup);
	    	}
	    }
	    if(counterpartyCode.selectedItem.label == "FUND"){
	    	if(counterpartyCodeBox.getChildByName("Broker")){
	    		finInst.finInstCode.text="";
		    		counterpartyCodeBox.addChild(strategyPopup);
		    		counterpartyCodeBox.removeChild(finInst);
		    }
	    } 
    }
    
    /**
    * This method is for showing Negative Accrual Flag
    * drop down when the trade type is 'BOND'
    */
    private function showNegativeAccrualFlag():void{
    	if(tradeType.selectedItem != null){
    		if(tradeType.selectedItem.value == "BOND"){
	    		negativeAccrualFlag.visible = true;
	    		negativeAccrualFlag.includeInLayout = true;
	    		negativeAccrualFlaglbl.visible = true;
	    		negativeAccrualFlaglbl.includeInLayout = true;
		    }else{
		    	negativeAccrualFlag.visible = false;
	    		negativeAccrualFlag.includeInLayout = false;
	    		negativeAccrualFlaglbl.visible = false;
	    		negativeAccrualFlaglbl.includeInLayout = false;
		    }
    	}else{
    		negativeAccrualFlag.visible = false;
	    	negativeAccrualFlag.includeInLayout = false;
	    	negativeAccrualFlaglbl.visible = false;
	    	negativeAccrualFlaglbl.includeInLayout = false;
    	}
    	
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
            myContextList.addItem(new HiddenObject("actTypeContext",actTypeArray));    
                      
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
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
        private function populateActContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing act type                
            var actTypeArray:Array = new Array(1);
                actTypeArray[0]="T|B";
            myContextList.addItem(new HiddenObject("actTypeContext",actTypeArray));    
                      
            var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="CLIENT|INTERNAL|BROKER";
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
		qh.dgrid = tradeQueryResult;
	}  
   /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
    	var url : String = "trd/tradeQuery.action?method=generateXLS";
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
    	var url : String = "trd/tradeQuery.action?method=generatePDF";
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
    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
     private function doNext():void { 
        var reqObj : Object = new Object();
    	reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
    	tradeQueryRequest.request = reqObj;
        tradeQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
		var reqObj : Object = new Object();
    	reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
    	tradeQueryRequest.request = reqObj;
        tradeQueryRequest.send();
    }  