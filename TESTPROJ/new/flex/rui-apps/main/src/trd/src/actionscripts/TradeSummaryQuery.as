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
import com.nri.rui.trd.validator.TradeSummaryQueryValidator;

import mx.collections.ArrayCollection;
import mx.controls.TextInput;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.UIComponent;
import mx.events.ValidationResultEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;
			
	     [Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
	     [Bindable]private var queryResult:ArrayCollection= new ArrayCollection();
	     [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
	     [Bindable]private var mode : String = "query";
	     [Bindable]private var finInst:FinInstitutePopUpHbox = new FinInstitutePopUpHbox();
    	 [Bindable]private var strategyPopup:StrategyPopUpHBox = new StrategyPopUpHBox();
    	 [Bindable]private var counterPartyTxtInput:TextInput = new TextInput();
    	 [Bindable]private var xmlSource:XML = new XML();
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
       	   super.setXenosQueryControl(new XenosQuery());
       	   this.dispatchEvent(new Event('queryInit'));
        }
        
        override public function preQueryInit():void{
		        var rndNo:Number= Math.random();
		        super.getInitHttpService().url = "trd/tradeSummaryQueryDispatch.action?method=initialExecute&modeOfOperation=VIEW&rnd=" + rndNo;
		        var req : Object = new Object();
		        req.SCREEN_KEY = "672";
	            super.getInitHttpService().request = req; 
        }
        
        
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();      	
	    	keylist.addItem("tradeDateFromStr");
	    	keylist.addItem("tradeDateToStr");
	    	keylist.addItem("sortFieldList1.item");
	    	keylist.addItem("sortFieldList2.item");
	    	keylist.addItem("sortField1");
	    	keylist.addItem("sortField2");
        }
        
        override public function preQueryResultInit():Object{
        	addCommonKeys();   	
	    	return keylist;        	
        }
        
        
        private function queryInit(mapObj:Object):void{
        	
        	//clears the errors if any
	        errPage.clearError(super.getInitResultEvent());
	        app.submitButtonInstance = submit;
	        brokerAccountNo.accountNo.setFocus();
        	//For SortField1
	        var sortField1Default:String = mapObj[keylist.getItemAt(4)].toString();
	        //For SortField2
	        var sortField2Default:String = mapObj[keylist.getItemAt(5)].toString();
	    	
	    	this.brokerAccountNo.accountNo.text = XenosStringUtils.EMPTY_STR;
	    	this.inventoryAccountNo.accountNo.text = XenosStringUtils.EMPTY_STR;
	    	this.securityCode.instrumentId.text = XenosStringUtils.EMPTY_STR;
	    	this.basketId.text = XenosStringUtils.EMPTY_STR;
	    	
	    	var dateStr:String = XenosStringUtils.EMPTY_STR;
	    	if(mapObj[keylist.getItemAt(0)]!= null && mapObj[keylist.getItemAt(1)] != null) {
	            dateStr = mapObj[keylist.getItemAt(0)];
	            if(!XenosStringUtils.isBlank(dateStr))
	                trddateFrom.selectedDate = DateUtils.toDate(dateStr);                
	
	            dateStr = mapObj[keylist.getItemAt(1)];
	            if(!XenosStringUtils.isBlank(dateStr))
	                trddateTo.selectedDate = DateUtils.toDate(dateStr);
	        } else {
	            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.summaryquery.alert.frdatetodatenotinit'));
	        }
	        
	        this.valuedateFrom.text = XenosStringUtils.EMPTY_STR;
	        this.valuedateFrom.selectedDate = null;
	        
	        this.valuedateTo.text = XenosStringUtils.EMPTY_STR;
	        this.valuedateTo.selectedDate = null;
	    	
	    	//----------Start of population of SortField1----------//
	        
	        if(null != mapObj[keylist.getItemAt(2)]){
	        	item = new Object();
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
        		tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
	        		for each(item in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	        	}else {
	        		initcol.addItem(mapObj[keylist.getItemAt(2)]);
	        	}
		        for(i = 0; i<initcol.length; i++) {
		        	//Get the default value object's index
	                if(XenosStringUtils.equals((initcol[i].value),sortField1Default)){                    
	                    selIndx = i;
	                }
		           tempColl.addItem(initcol[i]);            
		        }
		        
		        sortFieldArray[0]= sortField1;
		        sortFieldDataSet[0]= tempColl;
		        //Set the default value object
		        sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
		        
	        } else {
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.summaryquery.alert.sort1notpopulated'));
	        } 
	        
	        //---------------End of population of SortField1-----------------------//
	        
	        //---------------Start of population of sortField2---------------------//
	        
	        if(null != mapObj[keylist.getItemAt(3)]){
	        	item = new Object();
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
	        	tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	
	        	if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
	        		for each(item in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	        	}else{
	        		initcol.addItem(mapObj[keylist.getItemAt(3)]);
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
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.summaryquery.alert.sort2notpopulated'));
	        }
	        
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
        
        override public function postQueryResultInit(mapObj:Object):void{
        	queryInit(mapObj);
        }
        
		private function submitQuery():void{
			
			var tradeSummaryQueryModel:Object={
                            tradeSummaryQuery:{
                                 brokerAccountNo:this.brokerAccountNo.accountNo.text,
	                        	 fundAccountNo:this.inventoryAccountNo.accountNo.text,
	                        	 securityCode:this.securityCode.instrumentId.text,
	                        	 basketId:this.basketId.text,                               
	                             trddateFrom:this.trddateFrom.text,
	                             trddateTo:this.trddateTo.text,
	                             valuedateFrom:this.valuedateFrom.text,
	                             valuedateTo:this.valuedateTo.text
                            }
                           }; 
			var tradeSummaryQueryValidator:TradeSummaryQueryValidator = new TradeSummaryQueryValidator();
			tradeSummaryQueryValidator.source = tradeSummaryQueryModel;
			tradeSummaryQueryValidator.property = "tradeSummaryQuery";
			var validationResult:ValidationResultEvent = tradeSummaryQueryValidator.validate();
			
			if(validationResult.type == ValidationResultEvent.INVALID){
	            var errorMsg:String = validationResult.message;
	            XenosAlert.error(errorMsg);
	        } else {
	        	qh.resetPageNo();
	        	var requestObj :Object = populateRequestParams();
	        	tradeSummaryQueryRequest.request = requestObj;
	    		tradeSummaryQueryRequest.send();
	        }
		}
		
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	
       	reqObj.SCREEN_KEY = "673";
       	reqObj.rnd = Math.random() + "";
     	reqObj.method = "submitQuery";
     	reqObj.accountNo = this.brokerAccountNo.accountNo.text;
        reqObj.inventoryAccountNo = this.inventoryAccountNo.accountNo.text; 
        reqObj.securityId = this.securityCode.instrumentId.text; 
        reqObj.basketId = this.basketId.text;     
        reqObj.tradeDateFromStr = this.trddateFrom.text; 
        reqObj.tradeDateToStr = this.trddateTo.text;           
        reqObj.valueDateFromStr = this.valuedateFrom.text; 
        reqObj.valueDateToStr = this.valuedateTo.text;           
        reqObj.sortField1 = this.sortField1.selectedItem != null ? this.sortField1.selectedItem.value : "";
        reqObj.sortField2 = this.sortField2.selectedItem != null ? this.sortField2.selectedItem.value : "";
    	
    	return reqObj;
    }
    
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    
    private function loadResultPage(event:ResultEvent):void {
     	
		if (event != null) {
			var rs:XML = XML(event.result);
			if(event.result != null){
				if(rs.child("resultViews").length()>0){
					errPage.removeError();
					var rs1:XML = XML(rs.resultViews);
					if(rs1.child("resultview").length()>0) {
			            queryResult.removeAll();
			            xmlSource = new XML();
					    for each ( var rec:XML in rs1.resultview ) {
		 				    queryResult.addItem(rec);
					    }
					    xmlSource = XML(queryResult.getItemAt(0));
						queryResult = ProcessResultUtil.process(queryResult,resultSummary.columns);
					 	queryResult.refresh();
					    changeCurrentState();
			            qh.setOnResultVisibility();
			            qh.setPrevNextVisibility(((XML(event.result)).prevTraversable == "true")?true:false,((XML(event.result)).nextTraversable == "true")?true:false );
			            qh.PopulateDefaultVisibleColumns();
					 }else{
					 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
					 }
				}else if(rs.child("Errors").length()>0) {
				 	queryResult.removeAll();
				 	errPage.removeError();
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	errPage.showError(errorInfoList);
				 }else {
				 	queryResult.removeAll();
				 	errPage.removeError();
				 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				 }
			} else {
			 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			 	queryResult.removeAll(); 
			 	errPage.removeError();
			 }
        }
        
     }
       
      
        override public function preResetQuery():void{
		   super.getResetHttpService().url = "trd/tradeSummaryQueryDispatch.action?method=resetTrdQueryForm&rnd=" + Math.random();        	
        }
        
        override public function preGenerateXls():String{
		    return "trd/tradeSummaryQueryDispatch.action?method=generateXLS&rnd=" + Math.random();
         }	
   
   		override public function preGeneratePdf():String{
		    return "trd/tradeSummaryQueryDispatch.action?method=generatePDF&rnd=" + Math.random();
          }	
            
          /**
		    * This method sends the HttpService for Next Set of results operation.
		    * This is actually server side pagination for the next set of results.
		    */ 
		     private function goNext():void {
		        var reqObj : Object = new Object();
		    	reqObj.method = "doNext";
		        reqObj.rnd = Math.random()+"";
		    	tradeSummaryQueryRequest.request = reqObj;
		        tradeSummaryQueryRequest.send();
		    }
		    /**
		    * This method sends the HttpService for Previous Set of results operation.
		    * This is actually server side pagination for the previous set of results.
		    */ 
		     private function goPrev():void {
				var reqObj : Object = new Object();
		    	reqObj.method = "doPrevious";
		        reqObj.rnd = Math.random()+"";
		    	tradeSummaryQueryRequest.request = reqObj;
		        tradeSummaryQueryRequest.send();
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
                
      
	     /**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
	        private function populateInvActContext():ArrayCollection {
	            //pass the context data to the popup
	            var myContextList:ArrayCollection = new ArrayCollection(); 
	          
	            var actTypeArray:Array = new Array(1);
	                actTypeArray[0]="T|B";
	            myContextList.addItem(new HiddenObject("invActTypeContext",actTypeArray));    
	                      
	            var cpTypeArray:Array = new Array(1);
	                cpTypeArray[0]="INTERNAL";
	            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
	        
	            var actStatusArray:Array = new Array(1);
	            actStatusArray[0]="OPEN";
	            myContextList.addItem(new HiddenObject("actStatusContext",actStatusArray));
	            
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
	        private function populateCpActContext():ArrayCollection {
	            //pass the context data to the popup
	            var myContextList:ArrayCollection = new ArrayCollection(); 
	            
	            var actTypeContextArray:Array = new Array(1);
	            actTypeContextArray[0]="T|B";
	            
	            myContextList.addItem(new HiddenObject("actTypeContext",actTypeContextArray));
	            
	            var actCPTypeContextArray:Array = new Array(1);
	            actCPTypeContextArray[0]="BROKER";
	            
	            myContextList.addItem(new HiddenObject("actCPTypeContext",actCPTypeContextArray));
	            
	            var actStatusArray:Array = new Array(1);
	            actStatusArray[0]="OPEN";
	            
	            myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
	            
	            var actCpPrefixArray:Array = new Array(1);
	            actCpPrefixArray[0]="";
	            myContextList.addItem(new HiddenObject("prefix",actCpPrefixArray));
	            
	            return myContextList;
	        }
	        
		     private function displayDetailView(tradePkStr:String):void{
					var sPopup : SummaryPopup;	
					sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
					sPopup.title = this.parentApplication.xResourceManager.getKeyValue('trd.summaryquery.label.tradedetailsummary');
					sPopup.width = 700;
		    		sPopup.height = 460;
					PopUpManager.centerPopUp(sPopup);		
					sPopup.moduleUrl = Globals.TRADE_DETAILS_SWF+Globals.QS_SIGN+Globals.TRADE_PK+Globals.EQUALS_SIGN+tradePkStr;    	
		    }
