// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.RendererFectory;
import com.nri.rui.core.containers.SummaryPopup;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.ref.popupImpl.FinInstitutePopUpHbox;
import com.nri.rui.ref.popupImpl.StrategyPopUpHBox;
import com.nri.rui.trd.validator.TradeQueryValidator;

import mx.collections.ArrayCollection;
import mx.controls.TextInput;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.UIComponent;
import mx.managers.PopUpManager;
import mx.utils.StringUtil;
			
	     [Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
	     [Bindable]private var queryResult:ArrayCollection= new ArrayCollection();
	     [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
	     [Bindable]private var mode : String = "query";
	     [Bindable]private var finInst:FinInstitutePopUpHbox = new FinInstitutePopUpHbox();
    	 [Bindable]private var strategyPopup:StrategyPopUpHBox = new StrategyPopUpHBox();
    	 [Bindable]private var counterPartyTxtInput:TextInput = new TextInput();
	     private var keylist:ArrayCollection = new ArrayCollection(); 
	     private var csd:CustomizeSortOrder = null;
	     private var sortFieldArray:Array =new Array();
    	 private var sortFieldDataSet:Array =new Array();
    	 private var sortFieldSelectedItem:Array =new Array();
    	 private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    	 [Bindable]private var initcol:ArrayCollection = new ArrayCollection();
    	 private var selIndx:int = 0;
         private var i:int = 0;
         private var item:Object = new Object();
         private var tempColl: ArrayCollection = new ArrayCollection();
		  
       public function loadAll():void{
       	   parseUrlString();
       	   super.setXenosQueryControl(new XenosQuery());
       	   if(this.mode == 'query'){
       	   	 this.dispatchEvent(new Event('queryInit'));
       	   } else if(this.mode == 'amendment'){
       	   	 this.dispatchEvent(new Event('amendInit'));
       	   	 addColumn();
       	   } else if(XenosStringUtils.equals(this.mode ,Globals.MODE_SPCL_AMEND)){
       	   	 this.dispatchEvent(new Event('amendInit'));
       	   	 addColumn();
       	   } else if(this.mode == 'cancel'){ 
       	     this.dispatchEvent(new Event('cancelInit'));
       	   	 addColumn();
       	   }
       	     
       }
        /**
         * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
         * 
         */ 
        public function parseUrlString():void {
            try {
                // Remove everything before the question mark, including
                // the question mark.
                var myPattern:RegExp = /.*\?/; 
                var s:String = this.loaderInfo.url.toString();
                s = s.replace(myPattern, "");
                // Create an Array of name=value Strings.
                var params:Array = s.split(Globals.AND_SIGN); 
                 // Print the params that are in the Array.
                var keyStr:String;
                var valueStr:String;
                var paramObj:Object = params;
              
                // Set the values of the salutation.
                if(params != null){
                    for (var i:int = 0; i < params.length; i++) {
                        var tempA:Array = params[i].split("=");  
                        if (tempA[0] == "mode") {
                            mode = tempA[1];
                        }
                    }                    	
                }else{
                	mode = "query";
                }                 
            } catch (e:Error) {
                trace(e);
            }               
        }
        override public function preQueryInit():void{
		        var rndNo:Number= Math.random();
		        super.getInitHttpService().url = "trd/tradeQuery.action?method=initialExecute&mode=query&menuType=Y&rnd=" + rndNo;
		        var req : Object = new Object();
		        req.SCREEN_KEY = "41";
	            super.getInitHttpService().request = req;
        }
        
        override public function preAmendInit():void{
		        var rndNo:Number= Math.random();
		        var reqObject:Object = new Object();
		  		reqObject.SCREEN_KEY = "41";
		  		if(XenosStringUtils.equals(this.mode ,Globals.MODE_SPCL_AMEND)){
		        	super.getInitHttpService().url = "trd/tradeSpecialAmendQuery.action?&rnd=" + rndNo;
		        	reqObject.SCREEN_KEY = "11186";
		        }else if ( XenosStringUtils.equals(this.mode ,"amendment") ){
		        	super.getInitHttpService().url = "trd/tradeAmendQuery.action?&rnd=" + rndNo;
		        }
		        reqObject.mode=this.mode;
		  		reqObject.method="initialExecute";
		  		super.getInitHttpService().request = reqObject;
        }
        
        override public function preCancelInit():void{
		        var rndNo:Number= Math.random();
		        super.getInitHttpService().url = "trd/tradeCancelQuery.action?&rnd=" + rndNo;  
		        var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.SCREEN_KEY = "42";
		  		reqObject.method="initialExecute";
		  		super.getInitHttpService().request = reqObject;      	
        }        
        
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();      	
	    	keylist.addItem("tradeTypeValues.item");
	    	keylist.addItem("serviceOfficeList.officeId");
	    	keylist.addItem("buySellFlagValues.item");
	    	keylist.addItem("negativeAccrualFlagValues.item");
	    	keylist.addItem("matchStatusFlagValues.item");
	    	keylist.addItem("counterPartyTypeList.item");
	    	keylist.addItem("tradeDateFrom");
	    	keylist.addItem("tradeDateTo");
	    	keylist.addItem("statusValues.item");
	    	keylist.addItem("shortSellExemptFlagValues.item");
	    	keylist.addItem("shortSellingFlagValues.item");
	    	keylist.addItem("sortFieldList1.item");
	    	keylist.addItem("sortFieldList2.item");
	    	keylist.addItem("sortFieldList3.item");
	    	keylist.addItem("sortFieldList4.item");
	    	keylist.addItem("sortField1");
	    	keylist.addItem("sortField2");
	    	keylist.addItem("sortField3");
	    	keylist.addItem("sortField4");
        }
        
        override public function preQueryResultInit():Object{
        	addCommonKeys();   	
	    	return keylist;        	
        }
        
        override public function preAmendResultInit():Object{
        	addCommonKeys();   		    	
	    	return keylist;        	
        }
        
        override public function preCancelResultInit():Object{
        	addCommonKeys();   		    	
	    	return keylist;        	
        }
        
        private function commonInit(mapObj:Object):void{
        	
        	//clears the errors if any
	        errPage.clearError(super.getInitResultEvent());
	        app.submitButtonInstance = submit;
        	//For SortField1
	        var sortField1Default:String = mapObj[keylist.getItemAt(15)].toString();
	        //For SortField2
	        var sortField2Default:String = mapObj[keylist.getItemAt(16)].toString();
	        //For SortField3
	        var sortField3Default:String = mapObj[keylist.getItemAt(17)].toString(); 
	        //For SortField4
	        var sortField4Default:String = mapObj[keylist.getItemAt(18)].toString();
	    	
	    	this.fundPopUp.fundCode.text = "";
	    	
	    	/* Populating Trade type drop down*/
	    	initcol = new ArrayCollection();
	    	item = new Object();
	    	initcol.addItem({label:" ", value: " "});
	    	if(mapObj[keylist.getItemAt(0)]!=null){
	    		if(mapObj[keylist.getItemAt(0)] is ArrayCollection){
	    			for each(item in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	    		}else{
	    			initcol.addItem(mapObj[keylist.getItemAt(0)].toString());
	    		}
	    	}
	    	this.tradeType.dataProvider = initcol;
	    	/* End of Populating Trade type drop down */
	    	
	    	this.trdRefNo.text=""; 
	    	
	    	/* Populating OfficeId drop down*/
	    	initcol = new ArrayCollection();
	    	item = new Object();
	    	initcol.addItem(" ");
	    	if(mapObj[keylist.getItemAt(1)]!=null){
	    		if(mapObj[keylist.getItemAt(1)] is ArrayCollection){
	    			for each(item in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	    		}else{
	    			initcol.addItem(mapObj[keylist.getItemAt(1)]);
	    		}
	    	}
	    	this.officeId.dataProvider = initcol;
	    	/* End of Populating OfficeId drop down */
	    	
	    	/* Populating Buy Sell Flag drop down*/
	    	initcol = new ArrayCollection();
	    	item = new Object();
	    	initcol.addItem({label:" ", value: " "});
	    	if(mapObj[keylist.getItemAt(2)]!=null){
	    		if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
	    			for each(item in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	    		}else{
	    			initcol.addItem(mapObj[keylist.getItemAt(2)]);
	    		}
	    	}
	    	this.buySellFlag.dataProvider = initcol;
	    	/* End of Populating Buy Sell Flag drop down */
	    	
	    	/* Populating Negative Accrual Flag drop down*/
	    	initcol = new ArrayCollection();
	    	item = new Object();
	    	initcol.addItem({label:" ", value: " "});
	    	if(mapObj[keylist.getItemAt(3)]!=null){
	    		if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
	    			for each(item in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	    		}else{
	    			initcol.addItem(mapObj[keylist.getItemAt(3)]);
	    		}
	    	}
	    	this.negativeAccrualFlag.dataProvider = initcol;
	    	/* End of Populating Negative Accrual Flag drop down */
	    	showNegativeAccrualFlag();
	    	
	    	/* Populating Match Status drop down*/
	    	initcol = new ArrayCollection();
	    	item = new Object();
	    	initcol.addItem({label:" ", value: " "});
	    	if(mapObj[keylist.getItemAt(4)]!=null){
	    		if(mapObj[keylist.getItemAt(4)] is ArrayCollection){
	    			for each(item in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	    		}else{
	    			initcol.addItem(mapObj[keylist.getItemAt(4)]);
	    		}
	    	}
	    	this.matchStatusFlag.dataProvider = initcol;
	    	this.statusTxt.visible = false;
	    	this.statusTxt.includeInLayout = false;
	    	/* End of Populating Match Status drop down */
	    	
	    	/*Populating CounterParty Code Text Box*/
	    	if(counterpartyCodeBox.contains(finInst)){
	    		counterpartyCodeBox.removeChild(finInst);
	    	}
	    	if(counterpartyCodeBox.contains(strategyPopup)){
	    		counterpartyCodeBox.removeChild(strategyPopup);
	    	}
	    	finInst.percentWidth = 50;
	    	finInst.name = "Broker";
	    	finInst.recContextItem = populateFinInstRole();
	    	strategyPopup.percentWidth = 50;
	    	strategyPopup.name = "Firm";
	    	
	    	counterpartyCodeBox.addChild(finInst);
	    	/*End of Populating CounterParty Code Text Box*/
	    	
	    	
	    	/* Populating Counterpartytype drop down*/
	    	initcol = new ArrayCollection();
	    	item = new Object();
	    	if(mapObj[keylist.getItemAt(5)]!=null){
	    		if(mapObj[keylist.getItemAt(5)] is ArrayCollection){
	    			for each(item in (mapObj[keylist.getItemAt(5)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	    		}else{
	    			initcol.addItem(mapObj[keylist.getItemAt(5)]);
	    		}
	    	}
	    	this.counterpartyCode.dataProvider = initcol;
	    	this.counterpartyCode.selectedIndex = 0;
	    	/* End of Populating Counterpartytype drop down */
	    	
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
	    	onChangeCounterpartyCode();
	    	
	    	var dateStr:String = "";
	    	if(mapObj[keylist.getItemAt(6)]!= null && mapObj[keylist.getItemAt(7)] != null) {
	            dateStr = mapObj[keylist.getItemAt(6)];
	            if(!XenosStringUtils.isBlank(dateStr))
	                trddateFrom.selectedDate = DateUtils.toDate(dateStr);                
	
	            dateStr = mapObj[keylist.getItemAt(7)];
	            if(!XenosStringUtils.isBlank(dateStr))
	                trddateTo.selectedDate = DateUtils.toDate(dateStr);
	        } else {
	            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.initialize.date'));
	        }
	    	
	    	//inventoryAccountNo
	        this.inventoryAccountNo.accountNo.text=""; 
	        
	        //fundCode
	        this.fundPopUp.fundCode.text="";
	        this.fundPopUp.fundCode.setFocus();
	        
	        //instrumentType
	        this.instrumentType.text="";
	        
	        //security
	        this.security.instrumentId.text="";
	        
	        //tradecurrency
	        this.tradecurrency.ccyText.text="";
	        
	        //market
			this.listedMarket.itemCombo.text="";
			
			//valuedateFrom
	        this.valuedateFrom.text="";
	        
	        //valuedateTo
	        this.valuedateTo.text="";
	        
	        //lastEntryDateFrom
	        this.lastEntryDateFrom.text="";
	        
	        //lastEntryDateTo
	        this.lastEntryDateTo.text="";
	        
	        //EntryDateFrom
	        this.EntrydateFrom.text="";
	        
	        //EntryDateTo
	        this.EntrydateTo.text="";
	        
	        //omsExecutionNo
	        this.extrefno.text="";
	        
	        //External Reference No
	        this.externalReferenceNo.text=""; 
	        
	        //etcrefno
	        this.etcrefno.text=""; 
	        
	        //orderreferenceno
	        this.orderreferenceno.text=""; 
	        
	        //cancelrefno
	        this.cancelrefno.text="";
	        
	        //userId
        	this.userId.text="";
	    	
	    	/* Populating status drop down*/
	    	initcol = new ArrayCollection();
	    	item = new Object();
	    	initcol.addItem({label:" ", value: " "});
	    	if(mapObj[keylist.getItemAt(8)]!=null){
	    		if(mapObj[keylist.getItemAt(8)] is ArrayCollection){
	    			for each(item in (mapObj[keylist.getItemAt(8)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	    		}else{
	    			initcol.addItem(mapObj[keylist.getItemAt(8)]);
	    		}
	    	}
	    	this.tradestatus.dataProvider = initcol;
	    	/* End of Populating status drop down */
	    	
	    	/* Populating shortsellexempt drop down*/
	    	//XGA-105
	    	/*
	    	initcol = new ArrayCollection();
	    	item = new Object();
	    	initcol.addItem({label:" ", value: " "});
	    	if(mapObj[keylist.getItemAt(9)]!=null){
	    		if(mapObj[keylist.getItemAt(9)] is ArrayCollection){
	    			for each(item in (mapObj[keylist.getItemAt(9)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	    		}else{
	    			initcol.addItem(mapObj[keylist.getItemAt(9)]);
	    		}
	    	}
	    	this.shortellExemptFlag.dataProvider = initcol;
	    	*/
	    	/* End of Populating shortsellexempt drop down */
	    	
	    	/* Populating shortsell drop down*/
	    	//XGA-105
	    	/*
	    	initcol = new ArrayCollection();
	    	item = new Object();
	    	initcol.addItem({label:" ", value: " "});
	    	if(mapObj[keylist.getItemAt(10)]!=null){
	    		if(mapObj[keylist.getItemAt(10)] is ArrayCollection){
	    			for each(item in (mapObj[keylist.getItemAt(10)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	    		}else{
	    			initcol.addItem(mapObj[keylist.getItemAt(10)]);
	    		}
	    	}
	    	this.shortsellingFlag.dataProvider = initcol;
	    	*/
	    	/* End of Populating shortsell drop down */

	    	
	    	//----------Start of population of SortField1----------//
	        
	        if(null != mapObj[keylist.getItemAt(11)]){
	        	item = new Object();
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
        		tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	if(mapObj[keylist.getItemAt(11)] is ArrayCollection){
	        		for each(item in (mapObj[keylist.getItemAt(11)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	        	}else {
	        		initcol.addItem(mapObj[keylist.getItemAt(11)]);
	        	}
		        for(i = 0; i<initcol.length; i++) {
		        	//Get the default value object's index
	                if(XenosStringUtils.equals((initcol[i].value),sortField1Default)){                    
	                    selIndx = i;
	                }
		           tempColl.addItem(initcol[i]);            
		        }
		        
		        sortFieldArray[0]=sortField1;
		        sortFieldDataSet[0]=tempColl;
		        //Set the default value object
		        sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
		        
	        } else {
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.initialize.sortfield1'));
	        } 
	        
	        //---------------End of population of SortField1-----------------------//
	        
	        //--------Start of population of sortField2---------//
	        
	        if(null != mapObj[keylist.getItemAt(12)]){
	        	item = new Object();
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
	        	tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	
	        	if(mapObj[keylist.getItemAt(5)] is ArrayCollection){
	        		for each(item in (mapObj[keylist.getItemAt(12)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	        	}else{
	        		initcol.addItem(mapObj[keylist.getItemAt(12)]);
	        	}
		        for(i = 0; i<initcol.length; i++) {
		        	//Get the default value object's index
	                if(XenosStringUtils.equals((initcol[i].value),sortField2Default)){                    
	                    selIndx = i;
	                }
		           tempColl.addItem(initcol[i]);            
		        }
		        
		        sortFieldArray[1]= sortField2;
		        sortFieldDataSet[1]= tempColl;
		        //Set the default value object
		        sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);
		        
	        } else {
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.initialize.sortfield2'));
	        }
	        
	         //--------End of population of sortField2---------// 
	        
	         //--------Start of population of sortField3---------//
	        
	        if(null != mapObj[keylist.getItemAt(13)]){
	        	item = new Object();
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
	        	tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	
	        	if(mapObj[keylist.getItemAt(13)] is ArrayCollection){
	        		for each(item in (mapObj[keylist.getItemAt(13)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	        	}else{
	        		initcol.addItem(mapObj[keylist.getItemAt(13)]);
	        	}
		        for(i = 0; i<initcol.length; i++) {
		        	//Get the default value object's index
	                if(XenosStringUtils.equals((initcol[i].value),sortField3Default)){                    
	                    selIndx = i;
	                }
		        	
		           tempColl.addItem(initcol[i]);            
		        }
		        
		        sortFieldArray[2]=sortField3;
		        sortFieldDataSet[2]=tempColl;
		        //Set the default value object
		        sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx+1);
		        
	        } else {
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.initialize.sortfield3'));
	        } 
	        
	         //--------End of population of sortField3---------//
	         
	         //--------Start of population of sortField4---------//
	        
	        if(null != mapObj[keylist.getItemAt(14)]){
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
	        	tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	
	        	if(mapObj[keylist.getItemAt(14)] is ArrayCollection){
	        		for each(item in (mapObj[keylist.getItemAt(14)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	        	}else{
	        		initcol.addItem(mapObj[keylist.getItemAt(14)]);
	        	}
		        for(i = 0; i<initcol.length; i++) {
		        	//Get the default value object's index
	                if(XenosStringUtils.equals((initcol[i].value),sortField4Default)){                    
	                    selIndx = i;
	                }
		        	
		           tempColl.addItem(initcol[i]);            
		        }
		        
		        sortFieldArray[3]= sortField4;
		        sortFieldDataSet[3]= tempColl;
		        //Set the default value object
		        sortFieldSelectedItem[3] = tempColl.getItemAt(selIndx+1);
		        
	        } else {
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.initialize.sortfield4'));
	        } 
	        
	         //--------End of population of sortField4---------//
	         
	        //-------------Initializing the sortfields-------------//
			csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
		    csd.init();
        }
        
        /**
	     * Method for updating the other three sortfields after any change in the sortfield1
	     */ 
	     private function sortOrder1Update():void{
	     	 csd.update(sortField1.selectedItem,0);
	     }
	     /**
	     * Method for updating the other three sortfields after any change in the sortfield2
	     */
	     private function sortOrder2Update():void{     	
	     	csd.update(sortField2.selectedItem,1);
	     }
	     /**
	     * Method for updating the other three sortfields after any change in the sortfield3
	     */
	     private function sortOrder3Update():void{     	
	     	csd.update(sortField3.selectedItem,2);
	     }
        
        override public function postQueryResultInit(mapObj:Object):void{
        	commonInit(mapObj);
        }
        
        
        override public function postAmendResultInit(mapObj:Object):void{
        	commonInit(mapObj);	
        	this.tradestatus.visible = false;
        	this.tradestatus.includeInLayout = false;
        	this.statusTxt.visible = true;
        	this.statusTxt.includeInLayout = true;
        	this.statusTxt.text = "NORMAL"; 
        }
        
        override public function postCancelResultInit(mapObj:Object):void{
        	commonInit(mapObj);	
        	this.tradestatus.visible = false;
        	this.tradestatus.includeInLayout = false;
        	this.statusTxt.visible = true;
        	this.statusTxt.includeInLayout = true;
        	this.statusTxt.text = "NORMAL"; 
        }
        
    	private function setValidator():void{
		
	    var tradeQueryModel:Object={
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
         super._validator = new TradeQueryValidator();
         super._validator.source = tradeQueryModel ;
         super._validator.property = "tradeQuery";
		}
		
		override public function preQuery():void{
			setValidator();
            qh.resetPageNo();	
            super.getSubmitQueryHttpService().url = "trd/tradeQuery.action?";  
            super.getSubmitQueryHttpService().request = populateRequestParams();
		}
		/**
		 *   Applicable for both Amend and Special Amend 
		 */
		override public function preAmend():void{
			setValidator();
            qh.resetPageNo();
            
            if(XenosStringUtils.equals(this.mode ,Globals.MODE_SPCL_AMEND)){
	        	super.getSubmitQueryHttpService().url = "trd/tradeSpecialAmendQuery.action?";
		    }else if ( XenosStringUtils.equals(this.mode ,"amendment") ){
	        	super.getSubmitQueryHttpService().url = "trd/tradeAmendQuery.action?";
		    }
            super.getSubmitQueryHttpService().request = populateRequestParams();  
           
		}
		
		override public function preCancel():void{
			setValidator();
			qh.resetPageNo();	
            super.getSubmitQueryHttpService().url = "trd/tradeCancelQuery.action?"; 
            super.getSubmitQueryHttpService().request = populateRequestParams();
           
		}
		
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	
    		if(this.mode == 'query'){
       	   	 reqObj.SCREEN_KEY = "11083";
       	   } else if(this.mode == 'amendment'){
       	   	 reqObj.SCREEN_KEY = "11077";
       	   } else if(this.mode == Globals.MODE_SPCL_AMEND){
       	   	 reqObj.SCREEN_KEY = "11183";
       	   } else if(this.mode == 'cancel'){ 
       	     reqObj.SCREEN_KEY = "11080";
       	   }
    	
    	
     	reqObj.method = "submitQuery";
     	reqObj.mode = this.mode ;
        reqObj.tradeType = this.tradeType.selectedItem != null ?  this.tradeType.selectedItem.value : "";
        reqObj.referenceNo = this.trdRefNo.text;
        reqObj.officeId = this.officeId.selectedItem != null ?  this.officeId.selectedItem : "";
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
        if(mode == "query"){
    		reqObj.status = this.tradestatus.selectedItem != null ?  this.tradestatus.selectedItem.value : "";
    	}else{
    		reqObj.status = this.statusTxt.text;
    	}
        reqObj.userId = this.userId.text;
        //reqObj.shortSellExemptFlag = this.shortellExemptFlag.selectedItem != null ?  this.shortellExemptFlag.selectedItem.value : "";//XGA-105
        //reqObj.shortSellingFlag = this.shortsellingFlag.selectedItem != null ?  this.shortsellingFlag.selectedItem.value : "";//XGA-105   
        reqObj.sortField1 = this.sortField1.selectedItem != null ? this.sortField1.selectedItem.value : "";
        reqObj.sortField2 = this.sortField2.selectedItem != null ? this.sortField2.selectedItem.value : "";
        reqObj.sortField3 = this.sortField3.selectedItem != null ? this.sortField3.selectedItem.value : "";
        reqObj.sortField4 = this.sortField4.selectedItem != null ? this.sortField4.selectedItem.value : "";
     	reqObj.rnd = Math.random() + "";
    	
    	return reqObj;
    }
    
    override public function postQueryResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    }
    override public function postAmendResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    }
    override public function postCancelResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    }
       
        
    private function commonResult(mapObj:Object):void{    	
    	var result:String = "";
    	if(mapObj!=null){   
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		queryResult.removeAll();
	    		errPage.showError(mapObj["errorMsg"]);
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    	   errPage.clearError(super.getSubmitQueryResultEvent());
               queryResult.removeAll();
               queryResult=mapObj["row"];
			   changeCurrentState();
	           qh.setOnResultVisibility();
	           qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
	           qh.PopulateDefaultVisibleColumns();
	    	   if(queryResult.length == 1 && this.mode == 'query'){
             	 displayDetailView(queryResult[0].tradePk);
               }
	    	}else{
	    		errPage.removeError();
	    		queryResult.removeAll();
	    		currentState = "";
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}    		
    	}
    }   
       
      
        override public function preResetQuery():void{
		       var rndNo:Number= Math.random();
		  		super.getResetHttpService().url = "trd/tradeQuery.action?method=resetQuery&&mode=query&&menuType=Y&rnd=" + rndNo;        	
        }
        
        override public function preResetAmend():void{
		        var rndNo:Number= Math.random();
		        if(this.mode == Globals.MODE_SPCL_AMEND){
       	   			super.getResetHttpService().url = "trd/tradeSpecialAmendQuery.action?&rnd=" + rndNo;
       	   		}else{
       	   			super.getResetHttpService().url = "trd/tradeAmendQuery.action?&rnd=" + rndNo;	
       	   		}
		        var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="resetQuery";
		  		super.getResetHttpService().request = reqObject;     	
        }
        
        override public function preResetCancel():void{
		        var rndNo:Number= Math.random();
		        super.getResetHttpService().url = "trd/tradeCancelQuery.action?&rnd=" + rndNo;  
		        var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="resetQuery";
		  		super.getResetHttpService().request = reqObject;      	
        }       
        
        
        override public function preGenerateXls():String{
        	 var url : String =null;
		    	if(mode == "query"){		    		
		    	  url = "trd/tradeQuery.action?method=generateXLS";
		    	}else if(mode == "amendment"){
		    		url = "trd/tradeAmendQuery.action?method=generateXLS";
		    	}else if( mode == Globals.MODE_SPCL_AMEND ){
		    		url = "trd/tradeSpecialAmendQuery.action?method=generateXLS";
		    	}else{
		    		url = "trd/tradeCancelQuery.action?method=generateXLS";
		    	}
		    	return url;
         }	
   
   		override public function preGeneratePdf():String{
    	   var url : String =null;
		    	if(mode == "query"){		    		
		    	  url = "trd/tradeQuery.action?method=generatePDF";
		    	}else if(mode == "amendment"){
		    		url = "trd/tradeAmendQuery.action?method=generatePDF";
		    	}else if( mode == Globals.MODE_SPCL_AMEND ){
		    		url = "trd/tradeSpecialAmendQuery.action?method=generatePDF";
		    	}else{
		    		url = "trd/tradeCancelQuery.action?method=generatePDF";
		    	}
		    	return url;
          }	
            
   		override public function preNext():Object{
    	   var reqObj : Object = new Object();
    	   reqObj.method = "doNext";
    	   return reqObj;
         }	
    	override public function prePrevious():Object{
    	   
    	    var reqObj : Object = new Object();
    	    reqObj.method = "doPrevious";
    	    return reqObj;
          }	
          
          private function dispatchPrintEvent():void{
              this.dispatchEvent(new Event("print"));
          }  
          private function dispatchPdfEvent():void{
              this.dispatchEvent(new Event("pdf"));
          }  
          private function dispatchXlsEvent():void{
              this.dispatchEvent(new Event("xls"));
          }   
          private function dispatchNextEvent():void{
              this.dispatchEvent(new Event("next"));
          }  
          private function dispatchPrevEvent():void{
              this.dispatchEvent(new Event("prev"));
          }      
      
		private function addColumn():void
		{
			
			var dg :DataGridColumn = new DataGridColumn();
			dg.dataField="";
			dg.editable = false;
			dg.headerText = "";
			dg.width = 40;
			dg.itemRenderer = new RendererFectory(ImgSummaryRenderer);
			
			var cols :Array = resultSummary.columns;
			cols.unshift(dg);
			resultSummary.columns = cols;
			
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
	            myContextList.addItem(new HiddenObject("invActTypeContext",actTypeArray));    
	                      
	            //passing counter party type                
	            var cpTypeArray:Array = new Array(1);
	                cpTypeArray[0]="INTERNAL";
	                //cpTypeArray[1]="CLIENT";
	            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
	        
	            //passing account status                
	            var actStatusArray:Array = new Array(1);
	            actStatusArray[0]="OPEN";
	            myContextList.addItem(new HiddenObject("actStatusContext",actStatusArray));
	            
	            //passing inv prefix                
	            var actInvPrefixArray:Array = new Array(1);
	            actInvPrefixArray[0]="";
	            myContextList.addItem(new HiddenObject("invPrefix",actInvPrefixArray));
	            
	            return myContextList;
	        }
	        
	        /**
		     * This method handles the counterpartycode and corresponding popup population
		     */ 
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
		     
		     
		     private function displayDetailView(tradePkStr:String):void{
					var sPopup : SummaryPopup;	
					sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
					sPopup.title = this.parentApplication.xResourceManager.getKeyValue('trd.details.title');
					sPopup.width = 700;
		    		sPopup.height = 460;
					PopUpManager.centerPopUp(sPopup);		
					sPopup.moduleUrl = Globals.TRADE_DETAILS_SWF+Globals.QS_SIGN+Globals.TRADE_PK+Globals.EQUALS_SIGN+tradePkStr;    	
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
