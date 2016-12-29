// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.ref.popupImpl.FinInstitutePopUpHbox;
import com.nri.rui.ref.popupImpl.StrategyPopUpHBox;

import mx.collections.ArrayCollection;
import mx.controls.TextInput;
import mx.events.ListEvent;
import mx.utils.StringUtil;
			
	     [Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
	     [Bindable]private var queryResult:ArrayCollection= new ArrayCollection();
	     [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
	     [Bindable]public var returnInvContextItem:ArrayCollection = new ArrayCollection();
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
         private var allSBTType:ArrayCollection = new ArrayCollection(); 
         private var subTypeForRPRV:ArrayCollection = new ArrayCollection(); 
         private var subTypeForBBBL:ArrayCollection = new ArrayCollection(); 
         private var subTypeForSB:ArrayCollection = new ArrayCollection(); 
         private var subTypeForSL:ArrayCollection = new ArrayCollection(); 
		  
       public function loadAll():void{
       	   parseUrlString();
       	   populateSubTradeType();
       	   super.setXenosQueryControl(new XenosQuery());
       	   if(this.mode == 'query'){
       	   	 this.dispatchEvent(new Event('queryInit'));
       	   	 addColumn();
       	   } 
       	   else if(this.mode == 'action'){
       	   	 this.dispatchEvent(new Event('queryInit'));
       	   	 this.statusCol.visible = false;
       	   	 addColumn();
       	   } 
       	   else if(this.mode == 'amend'){
       	   	 this.dispatchEvent(new Event('amendInit'));
       	   	 this.statusCol.visible = false;
       	   	 addColumn();
       	   } else if(this.mode == 'cancel'){ 
       	     this.dispatchEvent(new Event('cancelInit'));
       	     this.statusCol.visible = false;
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
                        //XenosAlert.info("mode "+mode);
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
		        super.getInitHttpService().url = "slr/slrContractQueryDispatch.action?method=initialExecute&menuType=Y&rnd=" + rndNo;
		        var req : Object = new Object();
		        req.mode=this.mode;
		        if(this.mode =="query"){
	            	req.SCREEN_KEY = 121;
	        	 }
	        	 else req.SCREEN_KEY = 781;
	            super.getInitHttpService().request = req;
        }
        
        override public function preAmendInit():void{
		        var rndNo:Number= Math.random();
		        super.getInitHttpService().url = "slr/slrContractQueryDispatch.action?&rnd=" + rndNo;
		        var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="initialExecute";
		  		reqObject.SCREEN_KEY = 783;
		  		super.getInitHttpService().request = reqObject;     	
        }
        
        override public function preCancelInit():void{
		        var rndNo:Number= Math.random();
		        super.getInitHttpService().url = "slr/slrContractQueryDispatch.action?&rnd=" + rndNo;  
		        var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="initialExecute";
		  		reqObject.SCREEN_KEY = 782;
		  		super.getInitHttpService().request = reqObject;      	
        }        
        
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();      	
	    	keylist.addItem("tradeTypeList.tradeTypeValues");
	    	keylist.addItem("subTradeTypeValues.item");
	    	keylist.addItem("dataSourceValues.item");
	    	keylist.addItem("statusValues.item");
	    	keylist.addItem("stlLocationValues.item");
	    	keylist.addItem("sortFieldList1.item");
	    	keylist.addItem("sortFieldList2.item");
	    	keylist.addItem("sortFieldList3.item");
	    	keylist.addItem("sortField1");
	    	keylist.addItem("sortField2");
	    	keylist.addItem("sortField3");
	    	
	    	
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
	        var sortField1Default:String = mapObj[keylist.getItemAt(8)].toString();
	        //For SortField2
	        var sortField2Default:String = mapObj[keylist.getItemAt(9)].toString();
	        //For SortField3
	        var sortField3Default:String = mapObj[keylist.getItemAt(10)].toString(); 
	    	
	    	
	    	/* Populating Trade type drop down*/
	    	initcol = new ArrayCollection();
	    	item = new Object();
	    	initcol.addItem("");
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
	    	this.tradeType.setFocus();
	    	/* End of Populating Trade type drop down */
	    	
	    	/* Populating Sub Trade type drop down*/
	    	initcol = new ArrayCollection();
	    	item = new Object();
	    	initcol.addItem({label:" ", value: " "});
	    	if(mapObj[keylist.getItemAt(1)]!=null){
	    		if(mapObj[keylist.getItemAt(1)] is ArrayCollection){
	    			for each(item in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	    		}else{
	    			initcol.addItem(mapObj[keylist.getItemAt(1)].toString());
	    		}
	    	}
	    	allSBTType = initcol;
	    	this.subTradeType.dataProvider = initcol;
	    	/* End of Populating Sub Trade type drop down */
	    	
	    	this.contractNo.text = "";
	    	this.extRefNo.text = "";
	    	this.accountNo.accountNo.text = "";
	    	this.rr.salesCode.text = "";
	    	this.inventoryAccountNo.accountNo.text = "";
	    	this.brokerCode.finInstCode.text = "";
	    	this.fundCode.fundCode.text = "";
	    	this.startDateFrom.text = "";
	    	this.startDateTo.text = "";
	    	this.endDateFrom.text = "";
	    	this.endDateTo.text = "";
	    	this.trddateFrom.text = "";
	    	this.trddateTo.text = "";
	    	
	    	/* Populating Open Ended drop down*/
	    	initcol = new ArrayCollection();
	    	//item = new Object();
	    	initcol.addItem({label:" ", value: " "});
	    	initcol.addItem({label:this.parentApplication.xResourceManager.getKeyValue('slr.label.optionyes'), value: "Y"});
	    	initcol.addItem({label:this.parentApplication.xResourceManager.getKeyValue('slr.label.optionno'), value: "N"});
	    	
	    	this.openended.dataProvider = initcol;
	    	/* End of Populating Open Ended drop down */
	    	this.extRr.salesCode.text = "";
	    	this.traderId.salesCode.text = "";
	    	this.security.instrumentId.text = "";
	    	this.actionExtRefNo.text = "";
	    	this.instrumentType.text = "";
	    	this.actionRefNo.text = "";
	    	this.tradecurrency.ccyText.text="";
	    	
	    	/* Populating Data source drop down*/
	    	initcol = new ArrayCollection();
	    	item = new Object();
	    	initcol.addItem({label:" ", value: " "});
	    	if(mapObj[keylist.getItemAt(2)]!=null){
	    		if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
	    			for each(item in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	    		}else{
	    			initcol.addItem(mapObj[keylist.getItemAt(2)].toString());
	    		}
	    	}
	    	this.datasource.dataProvider = initcol;
	    	/* End of Populating Data source drop down */
	    	
	    	/* Populating Status drop down*/
	    	initcol = new ArrayCollection();
	    	item = new Object();
	    	initcol.addItem({label:" ", value: " "});
	    	if(mapObj[keylist.getItemAt(3)]!=null){
	    		if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
	    			for each(item in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	    		}else{
	    			initcol.addItem(mapObj[keylist.getItemAt(3)].toString());
	    		}
	    	}
	    	this.status1.dataProvider = initcol;
	    	//this.status2.dataProvider = initcol;	    	
	    	/* End of Populating Status drop down */
	    	this.checkLRCash.selected = false;
	    	
	    	/* Populating SLR01 supress drop down*/
	    	initcol = new ArrayCollection();
	    	item = new Object();
	    	initcol.addItem({label:" ", value: " "});
	    	initcol.addItem({label:this.parentApplication.xResourceManager.getKeyValue('slr.label.optionyes'), value: "Y"});
	    	initcol.addItem({label:this.parentApplication.xResourceManager.getKeyValue('slr.label.optionno'), value: "N"});
	    	
	    	this.slr01Suppressed.dataProvider = initcol;
	    	/* End of Populating SLR01 supress drop down */
	    	
	    	
	    	/* Populating Stl Location Security drop down*/
	    	initcol = new ArrayCollection();
	    	item = new Object();
	    	initcol.addItem({label:" ", value: " "});
	    	if(mapObj[keylist.getItemAt(4)]!=null){
	    		if(mapObj[keylist.getItemAt(4)] is ArrayCollection){
	    			for each(item in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	    		}else{
	    			initcol.addItem(mapObj[keylist.getItemAt(4)].toString());
	    		}
	    	}
	    	this.stlmntLocSec.dataProvider = initcol;
	    	this.stlmntLocCash.dataProvider = initcol;

	    	/* End of Populating Stl Location Security drop down */
	    	
	        this.startSenderRefNo.text = "";  
	        this.endSenderRefNo.text = "";
	        this.conEntryDateFrom.text = "";  
	        this.conEntryDateTo.text = "";
	        this.lastConEntryDateFrom.text = "";  
	        this.lastConEntryDateTo.text = "";
	        this.actionEntryDateFrom.text = "";  
	        this.actionEntryDateTo.text = "";
	        this.lastActionEntryDateFrom.text = "";  
	        this.lastActionEntryDateTo.text = "";
	        
	        //--------------set the visible fields-------------------//
	        
	        if(mode == "query"){
	        	this.statusLabel.visible = true;
	        	this.statusLabel.includeInLayout = true;
	        	this.statusForNotLRCash.visible = true;
	        	this.statusForNotLRCash.includeInLayout = true;
//	        	this.checkLabelForLRCash.visible = true;
//	        	this.checkLabelForLRCash.includeInLayout = true;
//	        	this.checkForLRCash.visible = true;
//	        	this.checkForLRCash.includeInLayout = true;
	        	
	        	this.forActionOnly1.visible = false;
	        	this.forActionOnly1.includeInLayout = false;
	        	this.forActionOnly2.visible = false;
	        	this.forActionOnly2.includeInLayout = false;
	        	
	        	this.checkLabelForLRCash.visible = false;
	        	this.checkLabelForLRCash.includeInLayout = false;
	        	this.checkForLRCash.visible = false;
	        	this.checkForLRCash.includeInLayout = false;
	        	
	        }else if(mode == "query" || mode == "cancel"){
	        	this.slr01SuppressedLabel.visible = true;
	        	this.slr01SuppressedLabel.includeInLayout = true;
	        	this.forActionOnly1.visible = false;
	        	this.forActionOnly1.includeInLayout = false;
	        	this.forActionOnly2.visible = false;
	        	this.forActionOnly2.includeInLayout = false;
	        	
	        	this.statusPart.visible = false;
	        	this.statusPart.includeInLayout = false;

	        	
	        }else if(mode == "action"){
	        	this.forActionOnly1.visible = true;
	        	this.forActionOnly1.includeInLayout = true;
	        	this.forActionOnly2.visible = true;
	        	this.forActionOnly2.includeInLayout = true;
	        	
	        	
	        	this.slr01Part.visible = false;
	        	this.slr01Part.includeInLayout = false;
	        	this.statusPart.visible = false;
	        	this.statusPart.includeInLayout = false;
	        	
	        }else {
	        	this.forActionOnly1.visible = false;
	        	this.forActionOnly1.includeInLayout = false;
	        	this.forActionOnly2.visible = false;
	        	this.forActionOnly2.includeInLayout = false;
	        	
	        	this.slr01Part.visible = false;
	        	this.slr01Part.includeInLayout = false;
	        	this.statusPart.visible = false;
	        	this.statusPart.includeInLayout = false;
	        	
	         	
	        }
	        
	        
	        
	    	
	    	//----------Start of population of SortField1----------//
	        
	        if(null != mapObj[keylist.getItemAt(5)]){
	        	item = new Object();
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
        		tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	if(mapObj[keylist.getItemAt(5)] is ArrayCollection){
	        		for each(item in (mapObj[keylist.getItemAt(5)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	        	}else {
	        		initcol.addItem(mapObj[keylist.getItemAt(5)]);
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
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.sortfield1err'));
	        } 
	        
	        //---------------End of population of SortField1-----------------------//
	        
	        //--------Start of population of sortField2---------//
	        
	        if(null != mapObj[keylist.getItemAt(6)]){
	        	item = new Object();
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
	        	tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	
	        	if(mapObj[keylist.getItemAt(6)] is ArrayCollection){
	        		for each(item in (mapObj[keylist.getItemAt(6)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	        	}else{
	        		initcol.addItem(mapObj[keylist.getItemAt(6)]);
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
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.sortfield2err'));
	        }
	        
	         //--------End of population of sortField2---------// 
	        
	         //--------Start of population of sortField3---------//
	        
	        if(null != mapObj[keylist.getItemAt(7)]){
	        	item = new Object();
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
	        	tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	
	        	if(mapObj[keylist.getItemAt(7)] is ArrayCollection){
	        		for each(item in (mapObj[keylist.getItemAt(7)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	        	}else{
	        		initcol.addItem(mapObj[keylist.getItemAt(7)]);
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
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.sortfield3err'));
	        } 
	        
	         //--------End of population of sortField3---------//
	         
	        
	         
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
	     
	      private function populateAllocationCheck(event:ListEvent):void {
        	if(mode == "query" && subTradeType.selectedItem.value == "LR-CASH" ){
        		checkLabelForLRCash.visible=true;
        		checkLabelForLRCash.includeInLayout=true;
        		checkForLRCash.visible=true;
        		checkForLRCash.includeInLayout=true;
        		
        	}else{
        		checkLabelForLRCash.visible=false;
        		checkLabelForLRCash.includeInLayout=false;
        		checkForLRCash.visible=false;
        		checkForLRCash.includeInLayout=false;
        	}
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

        
        override public function postQueryResultInit(mapObj:Object):void{
        	commonInit(mapObj);
        }
        
        
        override public function postAmendResultInit(mapObj:Object):void{
        	commonInit(mapObj);	
        }
        
        override public function postCancelResultInit(mapObj:Object):void{
        	commonInit(mapObj);	
        }
       
//    	private function setValidator():void{
//		
//	    var tradeQueryModel:Object={
//                        tradeQuery:{                                 
//                             trddateFrom:this.trddateFrom.text,
//                             trddateTo:this.trddateTo.text,
//                             valuedateFrom:this.valuedateFrom.text,
//                             valuedateTo:this.valuedateTo.text,
//                             lastEntryDateFrom:this.lastEntryDateFrom.text,
//                             lastEntryDateTo:this.lastEntryDateTo.text,
//                             EntrydateFrom:this.EntrydateFrom.text,
//                             EntrydateTo:this.EntrydateTo.text
//                        }
//                       }; 
//         super._validator = new TradeQueryValidator();
//         super._validator.source = tradeQueryModel ;
//         super._validator.property = "tradeQuery";
//		}
//		
		override public function preQuery():void{
			//setValidator();
            qh.resetPageNo();	
            super.getSubmitQueryHttpService().url = "slr/slrContractQueryDispatch.action?";  
            super.getSubmitQueryHttpService().request = populateRequestParams();
		}
		
		override public function preAmend():void{
			//setValidator();
            qh.resetPageNo();	
            super.getSubmitQueryHttpService().url = "slr/slrContractQueryDispatch.action?";   
            super.getSubmitQueryHttpService().request = populateRequestParams();  
           
		}
		
		override public function preCancel():void{
			//setValidator();
			qh.resetPageNo();	
            super.getSubmitQueryHttpService().url = "slr/slrContractQueryDispatch.action?"; 
            super.getSubmitQueryHttpService().request = populateRequestParams();
           
		}
		
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	if(this.mode =="query"){
        	reqObj.SCREEN_KEY = 122;
    	 }else if(this.mode =="amend"){
    	 	reqObj.SCREEN_KEY = 11104;
    	 }else if(this.mode =="cancel"){
    	 	reqObj.SCREEN_KEY = 11107;
    	 }else if(this.mode =="action"){
    	 	reqObj.SCREEN_KEY = 11113;
    	 }
    	//reqObj.SCREEN_KEY = 122;
     	reqObj.method = "submitQuery";
     	
        reqObj.tradeType = this.tradeType.selectedItem != null ?  this.tradeType.selectedItem : "";
        reqObj.subTradeType = this.subTradeType.selectedItem != null ?  this.subTradeType.selectedItem.value : "";
        reqObj.contractNo = this.contractNo.text;
        reqObj.fundCode = this.fundCode.fundCode.text;
        reqObj.extRefNo = this.extRefNo.text;
        reqObj.accountNo = this.accountNo.accountNo.text;
        reqObj.rr = this.rr.salesCode.text;
        reqObj.inventoryAccount = this.inventoryAccountNo.accountNo.text;
        reqObj.brokerCode = this.brokerCode.finInstCode.text;
        reqObj.startDateFrom = this.startDateFrom.text;
        reqObj.startDateTo = this.startDateTo.text;
        reqObj.endDateFrom = this.endDateFrom.text;
        reqObj.endDateTo = this.endDateTo.text;
        reqObj.tradeDateFrom = this.trddateFrom.text;
        reqObj.tradeDateTo = this.trddateTo.text;
        reqObj.openEnded = this.openended.selectedItem != null ?  this.openended.selectedItem.value : "";
        reqObj.executingRr = this.extRr.salesCode.text;
        reqObj.traderId = this.traderId.salesCode.text = "";
        reqObj.securityCode = this.security.instrumentId.text;
        reqObj.actionExtRefNo = this.actionExtRefNo.text;
        reqObj.instrumentType = this.instrumentType.itemCombo.text;
        reqObj.actionRefNo = this.actionRefNo.text;
        reqObj.tradeCurrency = this.tradecurrency.ccyText.text;
        reqObj.dataSource = this.datasource.selectedItem != null ?  this.datasource.selectedItem.value : "";
        reqObj.status = this.status1.selectedItem != null ?  this.status1.selectedItem.value : "";
        reqObj.notAllocated = this.checkLRCash.selected;
        reqObj.slr01Suppressed = this.slr01Suppressed.selectedItem != null ?  this.slr01Suppressed.selectedItem.value : "";
        reqObj.stlmntLocSec = this.stlmntLocSec.selectedItem != null ?  this.stlmntLocSec.selectedItem.value : "";
        reqObj.stlmntLocCash = this.stlmntLocCash.selectedItem != null ?  this.stlmntLocCash.selectedItem.value : "";
        reqObj.startSenderRefNo = this.startSenderRefNo.text;
        reqObj.endSenderRefNo = this.endSenderRefNo.text;
        reqObj.conEntryDateFrom = this.conEntryDateFrom.text;
        reqObj.conEntryDateTo = this.conEntryDateTo.text;        
        reqObj.conLastEntryDateFrom = this.lastConEntryDateFrom.text;
        reqObj.conLastEntryDateTo = this.lastConEntryDateTo.text;
        reqObj.actEntryDateFrom =  this.actionEntryDateFrom.text;
        reqObj.actEntryDateTo =  this.actionEntryDateTo.text;
        reqObj.actLastEntryDateFrom =  this.lastActionEntryDateFrom.text;
        reqObj.actLastEntryDateTo =  this.lastActionEntryDateTo.text;
        reqObj.sortField1 = this.sortField1.selectedItem != null ? this.sortField1.selectedItem.value : "";
        reqObj.sortField2 = this.sortField2.selectedItem != null ? this.sortField2.selectedItem.value : "";
        reqObj.sortField3 = this.sortField3.selectedItem != null ? this.sortField3.selectedItem.value : "";
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
	    	}else{
	    		errPage.removeError();
	    		queryResult.removeAll();
	    		currentState = "";
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}    		
    	}
    }   
       
      
        override public function preResetQuery():void{
//		       var rndNo:Number= Math.random();
//		  		super.getResetHttpService().url = "slr/slrContractQueryDispatch.action?method=resetQuery&&mode=query&&menuType=Y&rnd=" + rndNo;
		  		
		  		var rndNo:Number= Math.random();
		        super.getResetHttpService().url = "slr/slrContractQueryDispatch.action?&rnd=" + rndNo;
		        var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="resetQuery";
		  		super.getResetHttpService().request = reqObject;         	
        }
        
        override public function preResetAmend():void{
		        var rndNo:Number= Math.random();
		        super.getResetHttpService().url = "slr/slrContractQueryDispatch.action?&rnd=" + rndNo;
		        var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="resetQuery";
		  		super.getResetHttpService().request = reqObject;     	
        }
        
        override public function preResetCancel():void{
		        var rndNo:Number= Math.random();
		        super.getResetHttpService().url = "slr/slrContractQueryDispatch.action?&rnd=" + rndNo;  
		        var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="resetQuery";
		  		super.getResetHttpService().request = reqObject;      	
        }       
        
        
        override public function preGenerateXls():String{
        	 var url : String =null;
		    	if(mode == "query"){		    		
		    	  url = "slr/slrContractQueryDispatch.action?method=generateXLS";
		    	}else if(mode == "amend"){
		    		url = "slr/slrContractQueryDispatch.action?method=generateXLS";
		    	}else{
		    		url = "slr/slrContractQueryDispatch.action?method=generateXLS";
		    	}
		    	return url;
         }	
   
   		override public function preGeneratePdf():String{
    	   var url : String =null;
		    	if(mode == "query"){		    		
		    	  url = "slr/slrContractQueryDispatch.action?method=generatePDF";
		    	}else if(mode == "amend"){
		    		url = "slr/slrContractQueryDispatch.action?method=generatePDF";
		    	}else{
		    		url = "slr/slrContractQueryDispatch.action?method=generatePDF";
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
	                //cpTypeArray[1]="CLIENT";
	            myContextList.addItem(new HiddenObject("actType",actTypeArray));    
	                      
	            //passing counter party type                
	            var cpTypeArray:Array = new Array(1);
	                //cpTypeArray[0]="INTERNAL";
	                cpTypeArray[0]="BROKER";
	            myContextList.addItem(new HiddenObject("actCpType",cpTypeArray));
	        
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
	        
	    private function changeSubTradeType():void{
			var sbTypeObj:ArrayCollection = new ArrayCollection();
			if(this.tradeType.selectedItem != null){
				if(XenosStringUtils.isBlank(StringUtil.trim(this.tradeType.selectedItem.toString()))){
					sbTypeObj = allSBTType;	
				}else if(XenosStringUtils.equals(StringUtil.trim(this.tradeType.selectedItem.toString()),"RP") || 
						XenosStringUtils.equals(StringUtil.trim(this.tradeType.selectedItem.toString()),"RV")){
					sbTypeObj = subTypeForRPRV;
				}else if(XenosStringUtils.equals(StringUtil.trim(this.tradeType.selectedItem.toString()),"SB")){
					sbTypeObj = subTypeForSB;
				}else if(XenosStringUtils.equals(StringUtil.trim(this.tradeType.selectedItem.toString()),"SL")){
					sbTypeObj = subTypeForSL;
				}else{
					sbTypeObj = subTypeForBBBL;
				}
				this.subTradeType.dataProvider = sbTypeObj;
			}
		}
		
       public function populateSubTradeType():void{
	       	allSBTType.addItem({label:"",value:""});
	       	allSBTType.addItem({label:"GC",value:"GC"});
	       	allSBTType.addItem({label:"GCF",value:"GCF"});
	       	allSBTType.addItem({label:"TP",value:"TP"});
	       	allSBTType.addItem({label:"HIC",value:"HIC"});
	       	allSBTType.addItem({label:"FWD",value:"FWD"});
	       	allSBTType.addItem({label:"NONCASH",value:"NONCASH"});
	       	allSBTType.addItem({label:"CASH",value:"CASH"});
	       	allSBTType.addItem({label:"LR-CASH",value:"LR-CASH"});
	       	allSBTType.addItem({label:"LR-COL",value:"LR-COL"});
	       	
	       	subTypeForRPRV.addItem({label:"",value:""});
	       	subTypeForRPRV.addItem({label:"GC",value:"GC"});
	       	subTypeForRPRV.addItem({label:"GCF",value:"GCF"});
	       	subTypeForRPRV.addItem({label:"TP",value:"TP"});
	       	subTypeForRPRV.addItem({label:"HIC",value:"HIC"});
	       	subTypeForRPRV.addItem({label:"FWD",value:"FWD"});
	       	subTypeForRPRV.addItem({label:"NONCASH",value:"NONCASH"});
	       	subTypeForRPRV.addItem({label:"CASH",value:"CASH"});
	       	subTypeForRPRV.addItem({label:"LR-CASH",value:"LR-CASH"});
	       	subTypeForRPRV.addItem({label:"LR-COL",value:"LR-COL"});
	       	
	       	subTypeForBBBL.addItem({label:"",value:""});
	       	subTypeForBBBL.addItem({label:"TP",value:"TP"});
	       	subTypeForBBBL.addItem({label:"FWD",value:"FWD"});
	       	subTypeForBBBL.addItem({label:"NONCASH",value:"NONCASH"});
	       	subTypeForBBBL.addItem({label:"CASH",value:"CASH"});
	       	subTypeForBBBL.addItem({label:"LR-CASH",value:"LR-CASH"});
	       	subTypeForBBBL.addItem({label:"LR-COL",value:"LR-COL"});
	       	
	       	subTypeForSB.addItem({label:"",value:""});
	       	subTypeForSB.addItem({label:"NONCASH",value:"NONCASH"});
	       	subTypeForSB.addItem({label:"CASH",value:"CASH"});
	       	
	       	subTypeForSL.addItem({label:"",value:""});
	       	subTypeForSL.addItem({label:"NONCASH",value:"NONCASH"});
	       	subTypeForSL.addItem({label:"CASH",value:"CASH"});
	       	subTypeForSL.addItem({label:"TP",value:"TP"});
       	
       }