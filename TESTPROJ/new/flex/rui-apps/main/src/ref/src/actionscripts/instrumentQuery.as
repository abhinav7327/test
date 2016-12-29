// ActionScript file

 
  	import com.nri.rui.core.Globals;
  	import com.nri.rui.core.controls.CustomizeSortOrder;
  	import com.nri.rui.core.controls.XenosAlert;
  	import com.nri.rui.core.controls.XenosQuery;
  	import com.nri.rui.core.startup.XenosApplication;
  	import com.nri.rui.core.utils.HiddenObject;
  	import com.nri.rui.core.utils.ProcessResultUtil;
  	import com.nri.rui.core.validators.XenosNumberValidator;
  	import com.nri.rui.ref.validators.InstrumentQueryValidator;
  	
  	import mx.collections.ArrayCollection;
  	import mx.events.ResourceEvent;
  	import mx.events.ValidationResultEvent;
  	import mx.formatters.NumberBase;
  	import mx.resources.ResourceBundle;
  	import mx.rpc.events.ResultEvent;
  	import mx.utils.StringUtil;
    import com.nri.rui.core.utils.XenosStringUtils;
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    private var balanceType : String = new String();
    
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();    
        
    private var  csd:CustomizeSortOrder=null;
    
    
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    
    [Bindable]
    public var mode : String = "query";
    
    
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
		parseUrlString();          
		if (!initCompFlg) {    
		    rndNo= Math.random();
		    var req : Object = new Object();
		   	req.SCREEN_KEY = 24;
		   	initializeInstrumentQuery.request = req;    
		   	if(mode=="query"){      
		    	initializeInstrumentQuery.url = "ref/instrumentQueryDispatch.action?method=initialExecute&mode=query&rnd=" + rndNo;
		    }   
		    else if(mode=="amend"){
		    	trace("here amend****");
		    	initializeInstrumentQuery.url = "ref/instrumentAmendQueryDispatch.action?method=initialExecute&mode=amendment&rnd=" + rndNo;
		    }    
		    else {
		    	initializeInstrumentQuery.url = "ref/instrumentCloseQueryDispatch.action?method=initialExecute&mode=close&rnd=" + rndNo;
		    }               
		    initializeInstrumentQuery.send();
		} else {
		    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.alreadyinitiated'));
		}
                
		//super.setXenosQueryControl(new XenosQuery());           	   
		if (this.mode == 'query') {
   			this.dispatchEvent(new Event('queryInit'));
  		} else if(this.mode == 'amend') {
   			this.dispatchEvent(new Event('amendInit'));
   			addColumn();
  		} else if(this.mode == 'cancel') { 
			this.dispatchEvent(new Event('cancelInit'));
   			addColumn();
  		}
    }
    
	private function addColumn():void
	{
		//Add a object
		
		var dg :DataGridColumn = new DataGridColumn();
		dg.dataField="";
		dg.editable = false;
		dg.headerText = "";
		dg.width = 40;
		dg.resizable = false;
		dg.itemRenderer = new RendererFectory(ImgSummaryRenderer);
		
		var cols :Array = resultSummary.columns;
		cols.unshift(dg);
		resultSummary.columns = cols;
		
	}    
    
    /**
     * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
     */ 
    public function parseUrlString():void {
        try {
            var myPattern:RegExp = /.*\?/; 
            var s:String = this.loaderInfo.url.toString();
            s = s.replace(myPattern, "");
            var params:Array = s.split(Globals.AND_SIGN); 
            var keyStr:String;
            var valueStr:String;
            var paramObj:Object = params;
          
            if(params != null) {
                for (var i:int = 0; i < params.length; i++) {
                    var tempA:Array = params[i].split("=");  
                    if (tempA[0] == "mode") {
                        mode = tempA[1];
                    }
                }                    	
            } else {
            	mode = "query";
            }                 

        } catch (e:Error) {
            trace(e);
        }               
    }
    
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * 
    */   
    private function initPage(event: ResultEvent) : void {
        var i:int = 0;
        var dateStr:String = null;
        var initColl:ArrayCollection = new ArrayCollection();
        var tempColl: ArrayCollection;
        
        var sortFieldList1: ArrayCollection = new ArrayCollection();
     	var sortFieldList2: ArrayCollection = new ArrayCollection();
     	var sortFieldList3: ArrayCollection = new ArrayCollection();
     	var sortField1Default:String = " ";
        var sortField2Default:String = " ";
        var sortField3Default:String = " ";
        
         //variables to hold the default values from the server
        
     	
        
        errPage.clearError(event); //clears the errors if any 
     	//initiate text fields
     	instPopUp.instrumentId.text="";
     	issueCcyBox.ccyText.text = "";   
     	couponCcyBox.ccyText.text = "";   
     	redemptionCcyBox.ccyText.text="";   
     	subscriptionCodeInstPopUp.instrumentId.text="";   
     	countryPopUp.countryCode.text = "";   
     	transferAgentFinInstitutePopUpHbox.finInstCode.text=""; 
     	
     	instrumentType.text="";
     	instrumentName.text="";
     	issueDateFrom.text="";
     	issueDateTo.text="";
     	maturityDateFrom.text="";
     	maturityDateTo.text="";
     	couponDateFrom.text="";
     	couponDateTo.text="";
     	couponRateFrom.text="";
     	couponRateTo.text="";
     	listedDateFrom.text="";
     	listedDateTo.text="";
     	ipoPaymentDateFrom.text="";
     	ipoPaymentDateTo.text="";
     	conversionStartDateFrom.text="";
     	conversionStartDateTo.text="";
     	conversionEndDateFrom.text="";
     	conversionEndDateTo.text="";
     	publicOfferStartDateFrom.text="";
     	publicOfferStartDateTo.text="";
     	publicOfferEndDateFrom.text="";
     	publicOfferEndDateTo.text="";
     	contractStartDate.text="";
     	contractExpiryDate.text="";
     	appRegiDateFrom.text="";
     	appRegiDateTo.text="";
     	appUpdDateFrom.text="";
     	appUpdDateTo.text="";
     	categoryTypes.text="";
     	categoryIds.text="";
     	
     	
     	
     	
     	updatedBy.text="";
     	createdBy.text="";
     	tickValue.text="";
     	qtyPerUnit.text="";
     	
     	posStartDateFrom.text="";
     	posStartDateTo.text="";
     	posEndDateFrom.text="";
     	posEndDateTo.text="";
     	
     	instPopUp.instrumentId.setFocus();
     	
     	
     	if(event.result == null || event.result.InstrumentQueryActionForm == null){
     		 if(XenosStringUtils.equals(StringUtil.trim(event.result.XenosErrors.pageSummary.status),'Y')){
     		 	errPage.displayError(event); 
     		 }
     		 else{
     		 	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.initialize.form'));
     		 }            
        }
        
     	
     	//Setting value of Bond Types OR Discount Coupon Types
        if(event.result.InstrumentQueryActionForm.discountCouponTypeValues.item != null) {
           	    
            tempColl = new ArrayCollection;
            tempColl.addItem({label:" ", value: " "});
            
            if(event.result.InstrumentQueryActionForm.discountCouponTypeValues.item is ArrayCollection)
                initColl = event.result.InstrumentQueryActionForm.discountCouponTypeValues.item as ArrayCollection;
            else
                initColl.addItem(event.result.InstrumentQueryActionForm.discountCouponTypeValues.item);
            
            for(i=0;i<initColl.length;i++)
                tempColl.addItem(initColl.getItemAt(i));
            discountCouponTypeValues.dataProvider=tempColl;               
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.initialize.bondtype'));
        } 
        
     	//Setting value of Option Types 
     	initColl.removeAll();
        if(event.result.InstrumentQueryActionForm.optionTypeValues.item != null) {
           	//initColl=event.result.InstrumentQueryActionForm.optionTypeValues.item as ArrayCollection;    
            tempColl = new ArrayCollection;
            tempColl.addItem({label:" ", value: " "});
            
            if(event.result.InstrumentQueryActionForm.optionTypeValues.item is ArrayCollection)
                initColl = event.result.InstrumentQueryActionForm.optionTypeValues.item as ArrayCollection;
            else
                initColl.addItem(event.result.InstrumentQueryActionForm.optionTypeValues.item);
            
            for(i=0;i<initColl.length;i++)
                tempColl.addItem(initColl.getItemAt(i));
            optionTypeValues.dataProvider=tempColl;               
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.initialize.optiontypes'));
        }    
        
        //Setting value of Pool Types 
     	initColl.removeAll();
        if(event.result.InstrumentQueryActionForm.poolTypeValues.item != null) {
           	    
            tempColl = new ArrayCollection;
            tempColl.addItem({label:" ", value: " "});
            
             if(event.result.InstrumentQueryActionForm.poolTypeValues.item is ArrayCollection)
                initColl = event.result.InstrumentQueryActionForm.poolTypeValues.item as ArrayCollection;
            else
                initColl.addItem(event.result.InstrumentQueryActionForm.poolTypeValues.item);
            
            for(i=0;i<initColl.length;i++)
                tempColl.addItem(initColl.getItemAt(i));
            poolTypeValues.dataProvider=tempColl;               
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.initialize.pooltypes'));
        }    
        //Setting value of When Issued Flags
        initColl.removeAll();
        if(event.result.InstrumentQueryActionForm.whenIssuedFlagValues.item != null) {
           	    
            tempColl = new ArrayCollection;
            tempColl.addItem({label:" ", value: " "});
            
            if(event.result.InstrumentQueryActionForm.whenIssuedFlagValues.item is ArrayCollection)
                initColl = event.result.InstrumentQueryActionForm.whenIssuedFlagValues.item as ArrayCollection;
            else
                initColl.addItem(event.result.InstrumentQueryActionForm.whenIssuedFlagValues.item);
            
            for(i=0;i<initColl.length;i++)
                tempColl.addItem(initColl.getItemAt(i));
            whenIssuedFlagValues.dataProvider=tempColl;               
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.initialize.whenissuedflags'));
        }          
        //Setting value of Tips Flags
        initColl.removeAll();
        if(event.result.InstrumentQueryActionForm.tipsFlagValues.item != null) {
           	    
            tempColl = new ArrayCollection;
            tempColl.addItem({label:" ", value: " "});
            
            if(event.result.InstrumentQueryActionForm.tipsFlagValues.item is ArrayCollection)
                initColl = event.result.InstrumentQueryActionForm.tipsFlagValues.item as ArrayCollection;
            else
                initColl.addItem(event.result.InstrumentQueryActionForm.tipsFlagValues.item);
                
            for(i=0;i<initColl.length;i++)
                tempColl.addItem(initColl.getItemAt(i));
            tipsFlagValues.dataProvider=tempColl;               
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.initialize.tipsflags'));
        }   
        //Setting value of Category Types
    	initColl.removeAll();
        if(event.result.InstrumentQueryActionForm.categoryTypes.categoryTypes != null) {
           	    
            tempColl = new ArrayCollection;
            tempColl.addItem(" ");
            
            if(event.result.InstrumentQueryActionForm.categoryTypes.categoryTypes is ArrayCollection)
                initColl = event.result.InstrumentQueryActionForm.categoryTypes.categoryTypes as ArrayCollection;
            else
                initColl.addItem(event.result.InstrumentQueryActionForm.categoryTypes.categoryTypes);
                
            for(i=0;i<initColl.length;i++)
                tempColl.addItem(initColl.getItemAt(i));
            categoryTypes.dataProvider=tempColl;               
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.initialize.categorytypes'));
        }     
        
        //Setting values of Rate Type
        initColl.removeAll();
        if(event.result.InstrumentQueryActionForm.floatingFixFlagValues.item != null) {
           	    
            tempColl = new ArrayCollection;
            tempColl.addItem({label:" ", value: " "});
            
            if(event.result.InstrumentQueryActionForm.floatingFixFlagValues.item is ArrayCollection)
                initColl = event.result.InstrumentQueryActionForm.floatingFixFlagValues.item as ArrayCollection;
            else
                initColl.addItem(event.result.InstrumentQueryActionForm.floatingFixFlagValues.item);
                
            for(i=0;i<initColl.length;i++)
                tempColl.addItem(initColl.getItemAt(i));
            floatingFixFlagValues.dataProvider=tempColl;               
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.initialize.ratetypes'));
        }  
         
        //Setting values of CMO Type
 		initColl.removeAll();
        if(event.result.InstrumentQueryActionForm.cmoTypeValues.item!= null) {
           	    
            tempColl = new ArrayCollection;
            tempColl.addItem({label:" ", value: " "});
            
            if(event.result.InstrumentQueryActionForm.cmoTypeValues.item is ArrayCollection)
                initColl = event.result.InstrumentQueryActionForm.cmoTypeValues.item as ArrayCollection;
            else
                initColl.addItem(event.result.InstrumentQueryActionForm.cmoTypeValues.item);
            
            for(i=0;i<initColl.length;i++)
                tempColl.addItem(initColl.getItemAt(i));
            cmoTypeValues.dataProvider=tempColl;               
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.initialize.cmotypes'));
        } 
        
        //Setting values of Dual Listed Flag 
        initColl.removeAll();
        if(event.result.InstrumentQueryActionForm.dualListedFlagValues.item != null) {
           	    
            tempColl = new ArrayCollection;
            tempColl.addItem({label:" ", value: " "});
            
             if(event.result.InstrumentQueryActionForm.dualListedFlagValues.item is ArrayCollection)
                initColl = event.result.InstrumentQueryActionForm.dualListedFlagValues.item as ArrayCollection;
            else
                initColl.addItem(event.result.InstrumentQueryActionForm.dualListedFlagValues.item);
            
            for(i=0;i<initColl.length;i++)
                tempColl.addItem(initColl.getItemAt(i));
            dualListedFlagValues.dataProvider=tempColl;               
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.initialize.duallistedflags'));
        } 
        
        //Setting values of Call Put  Flag 
        initColl.removeAll();
        if(event.result.InstrumentQueryActionForm.callPutFlagValues.item!= null) {
           	    
            tempColl = new ArrayCollection;
            tempColl.addItem({label:" ", value: " "});
            
            if(event.result.InstrumentQueryActionForm.callPutFlagValues.item is ArrayCollection)
                initColl = event.result.InstrumentQueryActionForm.callPutFlagValues.item as ArrayCollection;
            else
                initColl.addItem(event.result.InstrumentQueryActionForm.callPutFlagValues.item);
            
            for(i=0;i<initColl.length;i++)
                tempColl.addItem(initColl.getItemAt(i));
            callPutFlagValues.dataProvider=tempColl;               
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.initialize.callputflags'));
        } 
        
        //Setting values of Default Delivery Methos List
        initColl.removeAll();
        if(event.result.InstrumentQueryActionForm.defaultDeliveryMethodList.item!= null) {
           	    
            tempColl = new ArrayCollection;
            tempColl.addItem({label:" ", value: " "});
            
            if(event.result.InstrumentQueryActionForm.defaultDeliveryMethodList.item is ArrayCollection)
                initColl = event.result.InstrumentQueryActionForm.defaultDeliveryMethodList.item as ArrayCollection;
            else
                initColl.addItem(event.result.InstrumentQueryActionForm.defaultDeliveryMethodList.item);
            
            for(i=0;i<initColl.length;i++)
                tempColl.addItem(initColl.getItemAt(i));
            defaultDeliveryMethodList.dataProvider=tempColl;      
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.initialize.deliverymethods'));
        } 
        
        // setting values for Data Source List
        initColl.removeAll();
        if(event.result.InstrumentQueryActionForm.dataSourceList.item!= null) {
           	    
            tempColl = new ArrayCollection;
            tempColl.addItem({label:" ", value: " "});
            
            if(event.result.InstrumentQueryActionForm.dataSourceList.item is ArrayCollection)
                initColl = event.result.InstrumentQueryActionForm.dataSourceList.item as ArrayCollection;
            else
                initColl.addItem(event.result.InstrumentQueryActionForm.dataSourceList.item);
            
            for(i=0;i<initColl.length;i++)
                tempColl.addItem(initColl.getItemAt(i));
            dataSourceValues.dataProvider=tempColl;               
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.initialize.deliverymethods'));
        } 
        
        initColl.removeAll();
        if(event.result.InstrumentQueryActionForm.fixedDaysCouponFlagValues.item!= null){
        	tempColl = new ArrayCollection;
            tempColl.addItem({label:" ", value: " "});
            
            if(event.result.InstrumentQueryActionForm.fixedDaysCouponFlagValues.item is ArrayCollection)
                initColl = event.result.InstrumentQueryActionForm.fixedDaysCouponFlagValues.item as ArrayCollection;
            else
                initColl.addItem(event.result.InstrumentQueryActionForm.fixedDaysCouponFlagValues.item);
            
            for(i=0;i<initColl.length;i++)
                tempColl.addItem(initColl.getItemAt(i));
            fixedCouponDayFlag.dataProvider=tempColl;               
        }
        else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.initialize.deliverymethods'));
        } 
        
        //Setting values of Coupon Payment  Frequent 
        initColl.removeAll();
        if(event.result.InstrumentQueryActionForm.couponPaymentFreqValues.item!= null) {
           	    
            tempColl = new ArrayCollection;
            tempColl.addItem({label:" ", value: " "});
            
            if(event.result.InstrumentQueryActionForm.couponPaymentFreqValues.item is ArrayCollection)
                initColl = event.result.InstrumentQueryActionForm.couponPaymentFreqValues.item as ArrayCollection;
            else
                initColl.addItem(event.result.InstrumentQueryActionForm.couponPaymentFreqValues.item);
            
            for(i=0;i<initColl.length;i++)
                tempColl.addItem(initColl.getItemAt(i));
            couponPaymentFreqValues.dataProvider=tempColl;               
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.initialize.paymentfreq'));
        } 
        
        //Setting values of Default Settlement Location
        initColl.removeAll();
        if(event.result.InstrumentQueryActionForm.defaultSettlementLocationList.item!= null) {
           	    
            tempColl = new ArrayCollection;
            tempColl.addItem({label:" ", value: " "});
            
            if(event.result.InstrumentQueryActionForm.defaultSettlementLocationList.item is ArrayCollection)
                initColl = event.result.InstrumentQueryActionForm.defaultSettlementLocationList.item as ArrayCollection;
            else
                initColl.addItem(event.result.InstrumentQueryActionForm.defaultSettlementLocationList.item);
            
            for(i=0;i<initColl.length;i++)
                tempColl.addItem(initColl.getItemAt(i));
            defaultSettlementLocationList.dataProvider=tempColl;               
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.initialize.stllocations'));
        } 
        
        //Setting values of Status
        initColl.removeAll();
        if(event.result.InstrumentQueryActionForm.statusValues.item != null) {
           	    
            tempColl = new ArrayCollection;
            tempColl.addItem({label:" ", value: " "});
            
            if(event.result.InstrumentQueryActionForm.statusValues.item is ArrayCollection)
                initColl = event.result.InstrumentQueryActionForm.statusValues.item as ArrayCollection;
            else
                initColl.addItem(event.result.InstrumentQueryActionForm.statusValues.item);
            
            for(i=0;i<initColl.length;i++)
                tempColl.addItem(initColl.getItemAt(i));
            statusValues.dataProvider=tempColl;               
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.initialize.status'));
        } 
        
        
        //Setting values of Default Positions Methos List
        initColl.removeAll();
        if(event.result.InstrumentQueryActionForm.positionValues.item!= null) {
           	    
            tempColl = new ArrayCollection;
            tempColl.addItem({label:" ", value: " "});
            
            if(event.result.InstrumentQueryActionForm.positionValues.item is ArrayCollection)
                initColl = event.result.InstrumentQueryActionForm.positionValues.item as ArrayCollection;
            else
                initColl.addItem(event.result.InstrumentQueryActionForm.positionValues.item);
            
            for(i=0;i<initColl.length;i++)
                tempColl.addItem(initColl.getItemAt(i));
            posXenos.dataProvider=tempColl; 
            posTx.dataProvider=tempColl;
            posPx.dataProvider=tempColl;
                           
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.initialize.positionlists'));
        }
        
        
        // Setting the Values of sort field
       /*  initColl.removeAll();
        
        initColl.addItem({label:" ", value: " "});
        initColl.addItem({label:"Instrument Code",value: "security_id"});
        initColl.addItem({label:"Instrument Name",value: "official_name"});
        initColl.addItem({label:"Instrument Type",value: "instrument_type"});
        initColl.addItem({label:"Bond Type",value: "discount_coupon_type"});
        initColl.addItem({label:"Issue Date",value: "issue_date"});
        initColl.addItem({label:"Maturity Date",value: "maturity_date"});
        initColl.addItem({label:"Status",value: "status"});
        
        sortField1.dataProvider=initColl;
        sortField2.dataProvider=initColl;
        sortField3.dataProvider=initColl; */
////////////////////////////////////////////////////////////        
       
        // Populating sortfield combos
        
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.instrument.label.securitycode'), value: "security_id"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.instrument.label.securityname'), value: "official_name"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.instrument.label.securitytype'), value: "instrument_type"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.instrument.label.bondtype'), value: "discount_coupon_type"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.instrument.label.issuedate'), value: "issue_date"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.instrument.label.maturitydate'), value: "maturity_date"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.instrument.label.status'), value: "status"});
        sortField1.dataProvider = tempColl;
                
        sortFieldArray[0]= sortField1;
	    sortFieldDataSet[0]=tempColl;
	   //Set the default value object
	    sortFieldSelectedItem[0] = tempColl.getItemAt(1);	
        
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.instrument.label.securitycode'), value: "security_id"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.instrument.label.securityname'), value: "official_name"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.instrument.label.securitytype'), value: "instrument_type"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.instrument.label.bondtype'), value: "discount_coupon_type"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.instrument.label.issuedate'), value: "issue_date"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.instrument.label.maturitydate'), value: "maturity_date"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.instrument.label.status'), value: "status"});
        sortField2.dataProvider = tempColl;
                
        sortFieldArray[1]= sortField2;
	    sortFieldDataSet[1]=tempColl;
	   //Set the default value object
	    sortFieldSelectedItem[1] = tempColl.getItemAt(2);
        
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.instrument.label.securitycode'), value: "security_id"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.instrument.label.securityname'), value: "official_name"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.instrument.label.securitytype'), value: "instrument_type"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.instrument.label.bondtype'), value: "discount_coupon_type"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.instrument.label.issuedate'), value: "issue_date"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.instrument.label.maturitydate'), value: "maturity_date"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.instrument.label.status'), value: "status"});
        sortField3.dataProvider = tempColl;
                
        sortFieldArray[2]= sortField3;
	    sortFieldDataSet[2]=tempColl;
	   //Set the default value object
	    sortFieldSelectedItem[2] = tempColl.getItemAt(3);
               
        csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
        csd.init();
      }
        
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
    public function resetQuery():void { 
    	if(mode=="query"){      
		    	instrumentResetQueryRequest.url="ref/instrumentQueryDispatch.action?method=resetQuery";
		  }   
		else if(mode=="amend"){
		    	instrumentResetQueryRequest.url="ref/instrumentAmendQueryDispatch.action?method=resetQuery";
		}    
		else {
		    	instrumentResetQueryRequest.url="ref/instrumentCloseQueryDispatch.action?method=resetQuery";
		 }   
        instrumentResetQueryRequest.send();
    }
    
    /**
 	* This method sets the Category IDs for the corresponding Category types 
 	* in Instrument Query Page.
 	*/
 	private function setCategoryIds() : void { 
        if(String(StringUtil.trim(this.categoryTypes.text)).length != 0) {
       		var reqObj : Object = new Object();
        	reqObj.categoryType=this.categoryTypes.text;
        	if(mode=="query"){      
		    	initializeCategoryIds.url="ref/instrumentQueryDispatch.action?method=setCategoryIds";
		    }   
		    else if(mode=="amend"){
		    	initializeCategoryIds.url="ref/instrumentAmendQueryDispatch.action?method=setCategoryIds";
		    }    
		    else {
		    	initializeCategoryIds.url="ref/instrumentCloseQueryDispatch.action?method=setCategoryIds";
		    }   
        	
        	initializeCategoryIds.send(reqObj);
        	
        } else {
        	var tempColl: ArrayCollection = new ArrayCollection();
        	tempColl.addItem(" ");
        	categoryIds.dataProvider=tempColl;
        }        	
   	}
   	
   	private function populateCategoryIds(event: ResultEvent): void{
   		var i:int = 0;
        var initColl:ArrayCollection = new ArrayCollection();
        var tempColl: ArrayCollection = new ArrayCollection();
        initColl.removeAll();
        tempColl.removeAll();
        if(event.result.InstrumentQueryActionForm.categoryIds.categoryId!= null) {
        	tempColl = new ArrayCollection;
	        tempColl.addItem(" ");
        	if(event.result.InstrumentQueryActionForm.categoryIds.categoryId as ArrayCollection){
	           	initColl=event.result.InstrumentQueryActionForm.categoryIds.categoryId as ArrayCollection;  	            
	            for(i=0;i<initColl.length;i++)
	                tempColl.addItem(initColl.getItemAt(i));
         	}
         	else
         		tempColl.addItem(event.result.InstrumentQueryActionForm.categoryIds.categoryId);      	
               
       	}else{
       		tempColl.addItem(event.result.InstrumentQueryActionForm.categoryIds.categoryId);    
       	}  
       	categoryIds.dataProvider=tempColl; 
   	}
  														  
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var numFormatter:NumberBase = new NumberBase(".",",",".",",");
    	
    	var reqObj : Object = new Object();
    	reqObj.SCREEN_KEY = 21;
        reqObj.method = "submitQuery";
        reqObj.securityCode = this.instPopUp.instrumentId.text;
        reqObj.tradeCcy = this.issueCcyBox.ccyText.text;//couponCcy
        reqObj.couponCcy = this.couponCcyBox.ccyText.text;
        reqObj.redemptionCcy = this.redemptionCcyBox.ccyText.text;
        reqObj.instrumentType = this.instrumentType.itemCombo.text;
        reqObj.subscriptionCode=this.subscriptionCodeInstPopUp.instrumentId.text;
        reqObj.countryCode = this.countryPopUp.countryCode.text;
        reqObj.transferAgentCode=this.transferAgentFinInstitutePopUpHbox.finInstCode.text;
       
        
        //Text Fields
        reqObj.instrumentName=this.instrumentName.text;
        reqObj.couponRateFrom=numFormatter.parseNumberString(this.couponRateFrom.text);
        reqObj.couponRateTo=numFormatter.parseNumberString(this.couponRateTo.text);
        reqObj.updatedBy=this.updatedBy.text;
        reqObj.createdBy=this.createdBy.text;
        reqObj.tickValue=numFormatter.parseNumberString(this.tickValue.text);
        reqObj.quantityPerUnit=this.qtyPerUnit.text;
        
        
        
        //Date Fields
        reqObj.issueDateFrom=this.issueDateFrom.text;
        reqObj.issueDateTo=this.issueDateTo.text;
		reqObj.maturityDateFrom=this.maturityDateFrom.text;
        reqObj.maturityDateTo=this.maturityDateTo.text;
        reqObj.couponDateFrom=this.couponDateFrom.text;
        reqObj.couponDateTo=this.couponDateTo.text;     
        reqObj.listedDateFrom=this.listedDateFrom.text;
        reqObj.listedDateTo=this.listedDateTo.text;
        reqObj.ipoPaymentDateFrom=this.ipoPaymentDateFrom.text;
        reqObj.ipoPaymentDateTo=this.ipoPaymentDateTo.text;  
        reqObj.conversionStartDateFrom=this.conversionStartDateFrom.text;
        reqObj.conversionStartDateTo=this.conversionStartDateTo.text;
        reqObj.conversionEndDateFrom=this.conversionEndDateFrom.text;
        reqObj.conversionEndDateTo=this.conversionEndDateTo.text;
        reqObj.publicOfferStartDateFrom=this.publicOfferStartDateFrom.text;
        reqObj.publicOfferStartDateTo=this.publicOfferStartDateTo.text;
        reqObj.publicOfferEndDateFrom=this.publicOfferEndDateFrom.text;
        reqObj.publicOfferEndDateTo=this.publicOfferEndDateTo.text;   
        reqObj.contractStartDate=this.contractStartDate.text;
        reqObj.contractExpiryDate=this.contractExpiryDate.text;
        reqObj.appRegiDateFrom=this.appRegiDateFrom.text;
        reqObj.appRegiDateTo=this.appRegiDateTo.text;
        reqObj.appUpdDateFrom=this.appUpdDateFrom.text;
        reqObj.appUpdDateTo=this.appUpdDateTo.text;
        
        reqObj.posStartDateFrom = this.posStartDateFrom.text;
        reqObj.posStartDateTo = this.posStartDateTo.text;
        reqObj.posEndDateFrom = this.posEndDateFrom.text;
        reqObj.posEndDateTo = this.posEndDateTo.text;
        
        // Lists
        reqObj.discountCouponType=(this.discountCouponTypeValues.selectedItem !=null ? this.discountCouponTypeValues.selectedItem.value : "");
        reqObj.optionType=(this.optionTypeValues.selectedItem !=null ? this.optionTypeValues.selectedItem.value : "");
        reqObj.poolType=(this.poolTypeValues.selectedItem != null ? this.poolTypeValues.selectedItem.value : "");
        reqObj.whenIssuedFlag=(this.whenIssuedFlagValues.selectedItem ? this.whenIssuedFlagValues.selectedItem.value : "");
        reqObj.tipsFlag=(this.tipsFlagValues.selectedItem != null ? this.tipsFlagValues.selectedItem.value : "");
        reqObj.categoryId=this.categoryIds.text;  
        reqObj.categoryType=this.categoryTypes.text;
        reqObj.floatingFixFlag=(this.floatingFixFlagValues.selectedItem != null ? this.floatingFixFlagValues.selectedItem.value : "");
        reqObj.cmoType=(this.cmoTypeValues.selectedItem != null ? this.cmoTypeValues.selectedItem.value : "");
        reqObj.callPutFlag=(this.callPutFlagValues.selectedItem != null ? this.callPutFlagValues.selectedItem.value : "");
        reqObj.dualListedFlag=(this.dualListedFlagValues.selectedItem != null ? this.dualListedFlagValues.selectedItem.value : "");
        reqObj.defaultDeliveryMethod=(this.defaultDeliveryMethodList.selectedItem != null ? this.defaultDeliveryMethodList.selectedItem.value : "");
        reqObj.dataSource=(this.dataSourceValues.selectedItem != null ? this.dataSourceValues.selectedItem.value : "");
        reqObj.couponPaymentFreq=(this.couponPaymentFreqValues.selectedItem != null ? this.couponPaymentFreqValues.selectedItem.value : "");
        reqObj.defaultSettlementLocation=(this.defaultSettlementLocationList.selectedItem !=null ? this.defaultSettlementLocationList.selectedItem.value : "");
        reqObj.fixedDaysCouponFlag = (this.fixedCouponDayFlag.selectedItem !=null ? this.fixedCouponDayFlag.selectedItem.value : "" );
        
        reqObj.posXenos=(this.posXenos.selectedItem != null ? this.posXenos.selectedItem.value : "");
        reqObj.posTx=(this.posTx.selectedItem != null ? this.posTx.selectedItem.value : "");
        reqObj.posPx=(this.posPx.selectedItem != null ? this.posPx.selectedItem.value : "");
        
        if(mode=="query"){
        		reqObj.status=(this.statusValues.selectedItem != null ? this.statusValues.selectedItem.value : "");
        }
        else{
        	reqObj.status="NORMAL";
        }
     	reqObj.sortField1 = (this.sortField1.selectedItem != null ? this.sortField1.selectedItem.value : "");
     	reqObj.sortField2 = (this.sortField2.selectedItem != null ? this.sortField2.selectedItem.value : "");
     	reqObj.sortField3 = (this.sortField3.selectedItem != null ? this.sortField3.selectedItem.value : ""); 
        
       	reqObj.rnd = Math.random() + "";
     	return reqObj;
    }
    
    
    private function sortOrder1Update():void{
     	 //XenosAlert.info(sortField1.selectedItem.value);
     	 csd.update(sortField1.selectedItem,0);
     }
     
     private function sortOrder2Update():void{     	
     	//XenosAlert.info(sortField2.selectedItem.value);
     	csd.update(sortField2.selectedItem,1);
     } 
    
    
    /**
               * This is the method to pass the Collection of data items
               * through the context to the FinInst popup. This will be implemented as per specifdic  
               * requirement. 
               */
             private function populateFinInstRole():ArrayCollection {
         	//pass the context data to the popup
         	var myContextList:ArrayCollection = new ArrayCollection(); 
         
         	var bankRoleArray : Array = new Array(2);
         	bankRoleArray[0] = "Bank/Custodian";
         	bankRoleArray[1] = "Central Depository";
         	myContextList.addItem(new HiddenObject("bankRoles",bankRoleArray));
         
         	return myContextList;
    }
    
      /**
    * It sends/submits the query. 
    * 
    */
    private function submitQuery():void 
    {  
    	
		if(mode=="query"){      
	    	instrumentQueryRequest.url = "ref/instrumentQueryDispatch.action?";
	    }   
	    else if(mode=="amend"){
	    	instrumentQueryRequest.url = "ref/instrumentAmendQueryDispatch.action?";
	    }    
	    else {
	    	instrumentQueryRequest.url = "ref/instrumentCloseQueryDispatch.action?";
	    }      
        //Set the request parameters
     	var requestObj :Object = populateRequestParams();
     	instrumentQueryRequest.request = requestObj;
     	//instrumentQueryRequest.send(); 
     	
     	var myModel:Object={
        	instrumentQuery:{
		        issueDateFrom:this.issueDateFrom.text,
		        issueDateTo:this.issueDateTo.text,
				maturityDateFrom:this.maturityDateFrom.text,
		        maturityDateTo:this.maturityDateTo.text,
		        couponDateFrom:this.couponDateFrom.text,
		        couponDateTo:this.couponDateTo.text,     
		        listedDateFrom:this.listedDateFrom.text,
		        listedDateTo:this.listedDateTo.text,
		        ipoPaymentDateFrom:this.ipoPaymentDateFrom.text,
		        ipoPaymentDateTo:this.ipoPaymentDateTo.text,  
		        conversionStartDateFrom:this.conversionStartDateFrom.text,
		        conversionStartDateTo:this.conversionStartDateTo.text,
		        conversionEndDateFrom:this.conversionEndDateFrom.text,
		        conversionEndDateTo:this.conversionEndDateTo.text,
		        publicOfferStartDateFrom:this.publicOfferStartDateFrom.text,
		        publicOfferStartDateTo:this.publicOfferStartDateTo.text,
		        publicOfferEndDateFrom:this.publicOfferEndDateFrom.text,
		        publicOfferEndDateTo:this.publicOfferEndDateTo.text,   
		        contractStartDate:this.contractStartDate.text,
		        contractExpiryDate:this.contractExpiryDate.text,
		        appRegiDateFrom:this.appRegiDateFrom.text,
		        appRegiDateTo:this.appRegiDateTo.text,
		        appUpdDateFrom:this.appUpdDateFrom.text,
		        appUpdDateTo:this.appUpdDateTo.text,
		        quantityPerUnit:this.qtyPerUnit.text,
		        categoryTypes:this.categoryTypes.selectedItem!=null ? this.categoryTypes.selectedItem :" ",
		        categoryIds :this.categoryIds.selectedItem!=null ? this.categoryIds.selectedItem :" ",
		        posStartDateFrom:posStartDateFrom.text,
		     	posStartDateTo:posStartDateTo.text,
		     	posEndDateFrom:posEndDateFrom.text,
		     	posEndDateTo:posEndDateTo.text
            }
        };
     	
     	var instrumentQueryValidator:InstrumentQueryValidator = new InstrumentQueryValidator();
     	instrumentQueryValidator.source = myModel;
		instrumentQueryValidator.property = "instrumentQuery";
		
		var validationResult:ValidationResultEvent = instrumentQueryValidator.validate();
     	
     	if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            //trace(errorMsg);
            
            XenosAlert.error(errorMsg);
            
        } else {
    		qh.resetPageNo();
    		instrumentQueryRequest.send();
        }
     	        
    }
     /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
     /*public function loadSummaryPage(event:ResultEvent):void {
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
                qh.PopulateDefaultVisibleColumns();// RAKESH
            }
            
            //replace null objects in datagrid with empty string
            summaryResult=ProcessResultUtil.process(summaryResult,resultSummary.columns);
           
            //refresh the results.
            summaryResult.refresh();
            //processResult(); 
         //   resultSummary.includeInLayout = true;
         //   resultSummary.visible = true;
          
        }else {
            summaryResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }             */
        
       
   	private function loadSummaryPage(event:ResultEvent):void {
     	
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
	            	summaryResult=ProcessResultUtil.process(summaryResult,resultSummary.columns);
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
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
     	var url : String ="";
     	if(mode=="query"){      
	    	url = "ref/instrumentQueryDispatch.action?method=generateXLS";
	    }   
	    else if(mode=="amend"){
	    	url = "ref/instrumentAmendQueryDispatch.action?method=generateXLS";
	    }    
	    else {
	    	url="ref/instrumentCloseQueryDispatch.action?method=generateXLS";
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
    	var url : String="";
    	if(mode=="query"){      
	    	url = "ref/instrumentQueryDispatch.action?method=generatePDF";
	    }   
	    else if(mode=="amend"){
	    	url = "ref/instrumentAmendQueryDispatch.action?method=generatePDF";
	    }    
	    else {
	    	url = "ref/instrumentCloseQueryDispatch.action?method=generatePDF";
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
    } // ActionScript file
    
	 /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
     private function doNext():void { 
        var reqObj : Object = new Object();
    	reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
        instrumentQueryRequest.request = reqObj;
        instrumentQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
		var reqObj : Object = new Object();
    	reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
    	instrumentQueryRequest.request = reqObj;
        instrumentQueryRequest.send();
    }
	
	
     /**
     * Method to Format(B,M,T) and validate numbers
     */
     private function numberHandler(numVal:XenosNumberValidator):void{
     	//The source textinput control
     	var source:Object=numVal.source; 
     	    	
     	var vResult:ValidationResultEvent;
     	var tmpStr:String = source.text; 
		vResult = numVal.validate();
        
        if (vResult.type==ValidationResultEvent.VALID) {
     		source.text=numberFormatter.format(source.text);     		
        }else{
        	source.text = tmpStr;        	
        }
     } 	
        
        
        
        

