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
import com.nri.rui.drv.validators.DrvBulkCloseoutQueryValidator;

import mx.collections.ArrayCollection;
import mx.controls.DataGrid;
import mx.controls.TextInput;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.DataGridEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
			
	
	  
   [Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
   [Bindable]public var queryResult:ArrayCollection= new ArrayCollection();
   [Bindable]public var selectedQueryResult:ArrayCollection= new ArrayCollection();
   [Bindable]public var softException:ArrayCollection= new ArrayCollection();  
   [Bindable]private var mode : String = "query";
   [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
   
    private var keylist:ArrayCollection = new ArrayCollection(); 
	private var sortFieldArray:Array =new Array();
	private var sortFieldDataSet:Array =new Array();
	private var sortFieldSelectedItem:Array =new Array();
	private var csd:CustomizeSortOrder=null; 
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    private var sPopup : SummaryPopup;
	public var actionMode:String = "";
	private var trdPkArr:Array = new Array();
	public var isEvaluated:Boolean = false;
	public var isEvaluatedByFocus:Boolean = false;


            
	  
		/**
		 *  datagrid header release event handler to handle datagridcolumn sorting
		 */
		public function dataGrid_headerRelease(evt:DataGridEvent):void {				
			var dg:DataGrid = DataGrid(evt.currentTarget);
		    sortUtil.clickedColumn = dg.columns[evt.columnIndex];		
		}
		
		private function changeCurrentState():void{
			currentState = "result";
			app.submitButtonInstance = null;
		}
			 
       public function loadAll():void{
       	   super.setXenosQueryControl(new XenosQuery());
       	   this.dispatchEvent(new Event('queryInit'));
       }
       
        override public function preQueryInit():void{
	       	var rndNo:Number= Math.random();
	  		super.getInitHttpService().url = "drv/drvBulkCloseoutDispatch.action?method=initialExecute&menuType=Y&SCREEN_KEY=12007&rnd=" + rndNo;        	
        }
        
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();
	    	keylist.addItem("sortFieldList1.item");
	    	keylist.addItem("sortFieldList2.item");
	    	keylist.addItem("sortFieldList3.item");	    	
	    	keylist.addItem("sortField1");
	    	keylist.addItem("sortField2");
	    	keylist.addItem("sortField3");
		    keylist.addItem("dropDownListValues.executionOfficeList.item");    	
		    keylist.addItem("dropDownListValues.applicationRoleOfficeList.item");  	
	    	keylist.addItem("defaultOffice");
        }
        
        override public function preQueryResultInit():Object{
        	addCommonKeys();   	
	    	return keylist;        	
        }
        
        private function commonInit(mapObj:Object):void{
        	
        	submit.enabled = true;
	    	btnResetQry.enabled = true;
	    	app.submitButtonInstance = submit;
        	var i:int = 0;
	        var selIndx:int = 0;
	        var dateStr:String = null;
	        var tempColl: ArrayCollection = new ArrayCollection();
	        var initColl:ArrayCollection = new ArrayCollection();
        
   	        //variables to hold the default values from the server
	        var sortField1Default:String = mapObj["sortField1"];
	        var sortField2Default:String = mapObj["sortField2"];
	        var sortField3Default:String = mapObj["sortField3"];
	        var executionOfficeDefault:String = mapObj["defaultOffice"];	        
        	
        	this.fundCode.fundCode.text = "";
        	this.fundCode.fundCode.setFocus();
        	this.securityId.instrumentId.text = "";
        	this.underlyingSecurityId.instrumentId.text = "";
	    	this.trddateFrom.text = "";
	    	this.trddateTo.text = "";
	    	this.valuedateFrom.text = "";
	    	this.valuedateTo.text = "";
	    	this.referenceNo.text = "";
	    	this.contractReferenceNo.text = "";
	    	this.fundAccountNo.accountNo.text = "";
	    	this.exeBrkAccountNo.accountNo.text = "";
	    	this.brkAccountNo.accountNo.text = "";
	    	this.executionMarket.itemCombo.text="";  	
	    	   	
	    	errPage.clearError(super.getInitResultEvent());
	        //Initialize sortFieldList1.
	        if(null != mapObj["sortFieldList1.item"]){
	            tempColl = new ArrayCollection();
	            tempColl.addItem({label:" ", value: " "});
	            selIndx = 0;
	        	
	        	if(mapObj["sortFieldList1.item"] is ArrayCollection){
		            initColl = mapObj["sortFieldList1.item"] as ArrayCollection;
		       		for each(var item1:Object in initColl){
		                //Get the default value object's index
		                if(XenosStringUtils.equals(item1.value, sortField1Default)){                    
		                    selIndx = initColl.getItemIndex(item1);
		                }
		                   tempColl.addItem(item1);            
		            }
		            sortFieldArray[0]=sortField1;
			        sortFieldDataSet[0]=tempColl;
			        //Set the default value object
			        sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
		            
		        } 
	        }else {
	            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.alert.value.sortorder.one'));
	        }
	        
	        //Initialize sortFieldList2.
	        if(null != mapObj["sortFieldList2.item"]){
	            tempColl = new ArrayCollection();
	            tempColl.addItem({label:" ", value: " "});
	            selIndx=0;
	            if(mapObj["sortFieldList2.item"] is ArrayCollection){
		            initColl = mapObj["sortFieldList2.item"] as ArrayCollection;
		            for each(var item2:Object in initColl){
		                //Get the default value object's index
		                if(XenosStringUtils.equals(item2.value, sortField2Default)){                    
		                    selIndx = initColl.getItemIndex(item2);
		                }
		                tempColl.addItem(item2);            
		            }
	            
		            sortFieldArray[1]=sortField2;
			        sortFieldDataSet[1]=tempColl;
			        //Set the default value object
			        sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);		            
		        }
	        } else {
	            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.alert.value.sortorder.two'));
	        }
	        
	        //Initialize sortFieldList3.
	        if(null != mapObj["sortFieldList3.item"]){
	            tempColl = new ArrayCollection();
	            tempColl.addItem({label:" ", value: " "});
	            selIndx = 0;
	            
	            if(mapObj["sortFieldList3.item"] is ArrayCollection){
		            initColl = mapObj["sortFieldList3.item"] as ArrayCollection;
		            for each(var item3:Object in initColl){
		                //Get the default value object's index
		                if(XenosStringUtils.equals(item3.value, sortField3Default)){                    
		                    selIndx = initColl.getItemIndex(item3);
		                }
		                
		                tempColl.addItem(item3);            
		            }
	            
		            sortFieldArray[2]=sortField3;
			        sortFieldDataSet[2]=tempColl;
			        //Set the default value object
			        sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx+1);
			       
		        } 
	        }else {
	            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.alert.value.sortorder.three'));
	        }  
	        
	        csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
			csd.init();  		
			
			// initialize Execution office list for query criteria
	    	
	    	tempColl = new ArrayCollection();
	        tempColl.addItem({label:" ", value: " "});

	    	if(mapObj["dropDownListValues.executionOfficeList.item"] is ArrayCollection){
	    		initColl = mapObj["dropDownListValues.executionOfficeList.item"] as ArrayCollection;
		    	for each(var item4:Object in initColl){
		            tempColl.addItem(item4);
			   	}
			}			    
		    this.executionOffice.dataProvider = tempColl;
		   	this.executionOffice.selectedIndex = 0; 
		   	
		     			   	
		   	// initialize Execution office list for close trade
	    	
	    	tempColl = new ArrayCollection();
	        selIndx = 0;

	    	if(mapObj["dropDownListValues.applicationRoleOfficeList.item"] is ArrayCollection){
	    		initColl = mapObj["dropDownListValues.applicationRoleOfficeList.item"] as ArrayCollection;
		    	for each(var item5:Object in initColl){
			   		if(XenosStringUtils.equals(item5.value, executionOfficeDefault)){                    
		            	selIndx = initColl.getItemIndex(item5);
		            }
		            tempColl.addItem(item5);
			   	}
			}			    
		    this.closeExecutionOffice.dataProvider = tempColl;
		   	this.closeExecutionOffice.selectedItem = tempColl.getItemAt(selIndx);  
		   	
        }
        
        private function sortOrder1Update():void{
	    	csd.update(sortField1.selectedItem,0);
	    }
	     
	    private function sortOrder2Update():void{     	
	    	csd.update(sortField2.selectedItem,1);
	    }
	     
        override public function postQueryResultInit(mapObj:Object):void{
        	commonInit(mapObj);
        }
        
        private function setValidator():void{
			 var drvTradeModel:Object={
                            drvQuery:{
                                tradeDateFrom : this.trddateFrom.text,
                                tradeDateTo : this.trddateTo.text,
                                valueDateFrom : this.valuedateFrom.text,
                                valueDateTo : this.valuedateTo.text
                            }
                           }; 
	        super._validator = new DrvBulkCloseoutQueryValidator();
	        super._validator.source = drvTradeModel;
	        super._validator.property = "drvQuery";
		}
		
		override public function preQuery():void{
			setValidator();
            qh.resetPageNo();	
            super.getSubmitQueryHttpService().url = "drv/drvBulkCloseoutDispatch.action?";  
            super.getSubmitQueryHttpService().request = populateRequestParams();
           
		}
		
	    /**
	    * This method will populate the request parameters for the
	    * submitQuery call and bind the parameters with the HTTPService
	    * object.
	    */
	    private function populateRequestParams():Object {
	    	
	    	var reqObj : Object = new Object();
	    	
	    	reqObj.method= "submitQuery";
	    	reqObj['SCREEN_KEY'] = "12008";
	    	reqObj.fundCode = fundCode.fundCode.text;
	        reqObj.inventoryAccountNo = fundAccountNo.accountNo.text;
	        reqObj.cpAccountNo = brkAccountNo.accountNo.text;
	        reqObj.executionBrokerAccountNo = exeBrkAccountNo.accountNo.text;
	        reqObj.securityId = securityId.instrumentId.text;
	        reqObj.underlyingSecurityId = underlyingSecurityId.instrumentId.text;
	        reqObj.tradeDateFrom = trddateFrom.text;
	        reqObj.tradeDateTo = trddateTo.text;
	        reqObj.valueDateFrom = valuedateFrom.text;
	        reqObj.valueDateTo = valuedateTo.text;
	        reqObj.referenceNo = referenceNo.text;
	        reqObj.contractReferenceNo = contractReferenceNo.text;
	        reqObj.executionMarket = executionMarket.itemCombo.text;
			reqObj.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : XenosStringUtils.EMPTY_STR;
			reqObj.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : XenosStringUtils.EMPTY_STR;
			reqObj.sortField3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : XenosStringUtils.EMPTY_STR;
			reqObj.executionOffice = this.executionOffice.selectedItem != null ? StringUtil.trim(this.executionOffice.selectedItem.value) : XenosStringUtils.EMPTY_STR;    	
	    	
	    	return reqObj;
	    }
    
	    override public function postQueryResultHandler(mapObj:Object):void{
	    	commonResult(mapObj);
	    }
        private function submitQuery():void {
        	if(submit.enabled){
        		submit.enabled = false;
	    		btnResetQry.enabled = false;
	    		this.trddate.text = "";
	    	    this.valdate.text = ""; 
	        	this.dispatchEvent(new Event('querySubmit'));
        	}
        }
        private function submitReset():void {
        	submit.enabled = false;
	    	btnResetQry.enabled = false;
        	this.dispatchEvent(new Event('queryReset'));
        }
        override public function postQuery():void{
			submit.enabled = true;
	    	btnResetQry.enabled = true;
		}
	    private function commonResult(mapObj:Object):void{    	
	    	var result:String = "";
	    	summaryErrPage.removeError();
	    	submit.enabled = true;
	    	btnResetQry.enabled = true;
	    	btnConfirm.enabled = true;
	    	btnResetConfirm.enabled = true;
	    	this.trddate.setFocus();
	    	if(mapObj!=null){   
		    	if(mapObj["errorFlag"].toString() == "error"){
		    		queryResult.removeAll();
		    		errPage.showError(mapObj["errorMsg"]);
		    		app.submitButtonInstance = submit;
		    	}else if(mapObj["errorFlag"].toString() == "noError"){
		    	   errPage.clearError(super.getSubmitQueryResultEvent());
	               queryResult.removeAll();
	               queryResult = mapObj["row"];
	               initializeQueryResult();
				   changeCurrentState();
	               qh.setOnResultVisibility();
	               qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
	               qh.PopulateDefaultVisibleColumns();
	               queryResult.refresh();
	               app.submitButtonInstance = btnConfirm;
		    	}else{
		    		errPage.removeError();
		    		queryResult.removeAll();
		    		currentState = ""
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    		app.submitButtonInstance = submit;
		    	}    		
	    	}
	    }   
       
      
        override public function preResetQuery():void{
		    var rndNo:Number= Math.random();
		  	super.getResetHttpService().url = "drv/drvBulkCloseoutDispatch.action?method=resetQuery&menuType=Y&SCREEN_KEY=12007&rnd=" + rndNo;        	
        }
        
        override public function preGenerateXls():String{
        	 var url : String =null;
        	 url = "drv/drvBulkCloseoutDispatch.action?method=generateXLS";
	    	 return url;
        }	
   		override public function preGeneratePdf():String{
    	   var url : String =null;   
    	   url = "drv/drvBulkCloseoutDispatch.action?method=generatePDF";
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
	    private function populateContext():ArrayCollection {
	        //pass the context data to the popup
	        var myContextList:ArrayCollection = new ArrayCollection(); 
	      
	        //passing account type
	        var acTypeArray:Array = new Array(1);
	            acTypeArray[0]="T|B";            
	        myContextList.addItem(new HiddenObject("invActTypeContext",acTypeArray));  
	        
	        //passing counter party type                
	        var cpTypeArray:Array = new Array(1);
	            cpTypeArray[0]="INTERNAL";
	            //cpTypeArray[1]="CLIENT";
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
	    private function populateInvActContext():ArrayCollection {
	        //pass the context data to the popup
	        var myContextList:ArrayCollection = new ArrayCollection(); 
	      
	        //passing account type
	        var acTypeArray:Array = new Array(1);
	            acTypeArray[0]="T|B";
	            
	        myContextList.addItem(new HiddenObject("invActTypeContext",acTypeArray));
	        
	        //passing counter party type                
	        var cpTypeArray:Array = new Array(1);
	            cpTypeArray[0]="BROKER";
	            
	        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
	        return myContextList;
	    }
	    
	    private function confirm():void {
	    	var isReqEligibleToBeSent:Boolean = false;
	    	var isDateNull:Boolean = true;
	    	trdPkArr = new Array();
	    	var qtyArray:Array = new Array();
			var priceArray:Array = new Array();
			var commissionArray:Array = new Array();
			var taxArray:Array = new Array();
			var taxArray02:Array = new Array();
			var index:int = 0;			
			var validEntry:Boolean = true;	
			var parentArray:Array = new Array();					
	    	for each(var view:Object in this.queryResult){
	    		if(!XenosStringUtils.isBlank(view.price)){
	    			btnConfirm.enabled = false;
	    			btnResetConfirm.enabled = false;
	    			isReqEligibleToBeSent = validateQuantity(view);
	    			if(!isReqEligibleToBeSent){
	    				btnConfirm.enabled = true;
	    				btnResetConfirm.enabled = true;
	    				return;
	    			}
	    			isReqEligibleToBeSent = validateCommission(view);
	    			if(!isReqEligibleToBeSent){
	    				btnConfirm.enabled = true;
	    				btnResetConfirm.enabled = true;
	    				return;
	    			}
	    			isReqEligibleToBeSent = validateTax(view);
	    			if(!isReqEligibleToBeSent){
	    				btnConfirm.enabled = true;
	    				btnResetConfirm.enabled = true;
	    				return;
	    			}
	    			isReqEligibleToBeSent = validateDrvTax02(view);
	    			if(!isReqEligibleToBeSent){
	    				btnConfirm.enabled = true;
	    				btnResetConfirm.enabled = true;
	    				return;
	    			}
	    			index = index + 1;
	    			trdPkArr.push(view.tradePk);
	    			qtyArray.push(view.openBalanceQty);
	                priceArray.push(view.price);
	                commissionArray.push(view.commission);
	                taxArray.push(view.tax);
	                taxArray02.push(view.tax02);
	                parentArray.push(view.parentInstrumentType);
	               
	    		}
	    	}
	    	
	    	if(!isEvaluatedByFocus){
		    	isEvaluated = true;    
		         var qtySize:int = 0;
		         for(qtySize = 0; qtySize < qtyArray.length; qtySize++ ){
		             var qtyObj:TextInput = new TextInput();
		             qtyObj.text = (clearComma(String(qtyArray[qtySize])));
		             qtyVal.source = qtyObj;
		                	//XenosAlert.info('Quantity '+ qtyObj.text);
			         if(!qtyVal.handleNumericField(numberFormatter)){
			            validEntry = false;
			            btnConfirm.enabled = true;
		    			btnResetConfirm.enabled = true;
		    			isEvaluated = false;
		    			return;
			            }
		          }
	          
	            var priceSize:int = 0;
		        for(priceSize = 0; priceSize < priceArray.length; priceSize++ ){
		            var priceObj:TextInput = new TextInput();
		            var parent:String = parentArray[priceSize];
		            priceObj.text = (clearComma(String(priceArray[priceSize])));
		           
		                	//XenosAlert.info('Price '+ priceObj.text);
		            if(parent == 'OPT'){
		            	 priceValOpt.source = priceObj;
		            	if(!priceValOpt.handleNumericField(numberFormatter)){
				        	validEntry = false;
				        	btnConfirm.enabled = true;
			    			btnResetConfirm.enabled = true;
			    			isEvaluated = false;
			    			return;
			          		}
		            }else if(parent == 'FUT'){
		            	  priceValFut.source = priceObj;
		            	 if(!priceValFut.handleNumericField(numberFormatter)){
				        	validEntry = false;
				        	btnConfirm.enabled = true;
			    			btnResetConfirm.enabled = true;
			    			isEvaluated = false;
			    			return;
			          		}
		            }
		           }   	
			       
		            
		          var commissionSize:int = 0;
		                //XenosAlert.info('Commission Size '+ commissionArray.length);
		          for(commissionSize = 0; commissionSize < commissionArray.length; commissionSize++ ){
		              var commissionObj:TextInput = new TextInput();
		              commissionObj.text = (clearComma(String(commissionArray[commissionSize])));
		              commVal.source = commissionObj;
		              if(!commVal.handleNumericField(numberFormatter)){
		                		//XenosAlert.info('Inside invalid commission');
		                 validEntry = false;
			             btnConfirm.enabled = true;
		    			 btnResetConfirm.enabled = true;
		    			 isEvaluated = false;
		    			 return;
		                }
		           }
	           
		           var taxSize:int = 0;
		           for(taxSize = 0; taxSize < taxArray.length; taxSize++ ){
		               var taxObj:TextInput = new TextInput();
		               taxObj.text = (clearComma(String(taxArray[taxSize])));
		               taxVal.source = taxObj;
		                	//XenosAlert.info('TAX '+ taxObj.text);
			           if(!taxVal.handleNumericField(numberFormatter)){
			              validEntry = false;
			              btnConfirm.enabled = true;
		    			  btnResetConfirm.enabled = true;
		    			  isEvaluated = false;
		    			  return;
			              }
		            }
		            var taxSize02:int = 0;
		           for(taxSize02 = 0; taxSize02 < taxArray02.length; taxSize02++ ){
		               var taxObj:TextInput = new TextInput();
		               taxObj.text = (clearComma(String(taxArray02[taxSize02])));
		               taxVal02.source = taxObj;
		                	//XenosAlert.info('TAX '+ taxObj.text);
			           if(!taxVal02.handleNumericField(numberFormatter)){
			              validEntry = false;
			              btnConfirm.enabled = true;
		    			  btnResetConfirm.enabled = true;
		    			  isEvaluated = false;
		    			  return;
			              }
		            }
	    	}
	    	
	    	       
	    	if(XenosStringUtils.isBlank(this.trddate.text)){
				isEvaluated = true;
				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('drv.validation.error.tradedate.cannot.be.blank'));
				isEvaluated = false;		
				isDateNull = false;	
				btnConfirm.enabled = true;
	    		btnResetConfirm.enabled = true;
	    		return;		
	    	}
	    	else {
	    		
	    		if(!DateUtils.isValidDate(this.trddate.text))
	    		{
	    			isEvaluated = true;
	    			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('drv.validation.error.tradedate.format'));
	    			isEvaluated = false;
	    			isDateNull = false;	
				    btnConfirm.enabled = true;
	    		    btnResetConfirm.enabled = true;
	    		    return;		
	    		}	    		
	    	}
		    if(XenosStringUtils.isBlank(this.valdate.text)){
				
				isEvaluated = true;
				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('drv.validation.error.valuedate.cannot.be.blank'));					
				isEvaluated = false;
				isDateNull = false;	
				btnConfirm.enabled = true;
	    		btnResetConfirm.enabled = true;
	    		return;			
			}
			else {
	    		
	    		if(!DateUtils.isValidDate(this.valdate.text))
	    		{
	    			isEvaluated = true;
	    			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('drv.validation.error.valuedate.format'));
	    			isEvaluated = false;
	    			isDateNull = false;	
				    btnConfirm.enabled = true;
	    		    btnResetConfirm.enabled = true;
	    		    return;		
	    		}	    		
	    	}
	    	
	    	if(isDateNull)
	    	{
	    	  if(DateUtils.compareDates(this.trddate.text,this.valdate.text) == 1)
	    	  {
	    	  	isEvaluated = true;
	    	  	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('drv.validation.error.td.greater.vd'));
	    	    isEvaluated = false;
	    	    isDateNull = false;	
				btnConfirm.enabled = true;
	    		btnResetConfirm.enabled = true;
	    		return;		  		
	    	  }	    	  	
	    	}
	    	
	    	if(index == 0){
	    		isEvaluated = true;
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('drv.validation.info.provide.price.for.eligibility'));
	    		isEvaluated = false;
	    		return;
	    	}
	    	
	    	/**
	    	 * The two variables isEvaluatedByFocus and isEvaluated is used so as to identify that once the 
	    	 * validation for a particular field has been done and depending on the values of these
	    	 * two variables the other validation is skiped otherwise there will be two alert messages for
	    	 * the same invalid entry.
	    	*/
	    	
	    	/**if(!isEvaluatedByFocus){
		    	isEvaluated = true;
		    	var priceSize:int = 0;
		        for(priceSize = 0; priceSize < priceArray.length; priceSize++ ){
		            var priceObj:TextInput = new TextInput();
		            priceObj.text = (clearComma(String(priceArray[priceSize])));
		            priceVal.source = priceObj;
		                	//XenosAlert.info('Price '+ priceObj.text);
			        if(!priceVal.handleNumericField(numberFormatter)){
			        	validEntry = false;
			        	btnConfirm.enabled = true;
		    			btnResetConfirm.enabled = true;
		    			isEvaluated = false;
		    			return;
			          }
		            }
		            
		         var qtySize:int = 0;
		         for(qtySize = 0; qtySize < qtyArray.length; qtySize++ ){
		             var qtyObj:TextInput = new TextInput();
		             qtyObj.text = (clearComma(String(qtyArray[qtySize])));
		             qtyVal.source = qtyObj;
		                	//XenosAlert.info('Quantity '+ qtyObj.text);
			         if(!qtyVal.handleNumericField(numberFormatter)){
			            validEntry = false;
			            btnConfirm.enabled = true;
		    			btnResetConfirm.enabled = true;
		    			isEvaluated = false;
		    			return;
			            }
		          }
	          
		          var commissionSize:int = 0;
		                //XenosAlert.info('Commission Size '+ commissionArray.length);
		          for(commissionSize = 0; commissionSize < commissionArray.length; commissionSize++ ){
		              var commissionObj:TextInput = new TextInput();
		              commissionObj.text = (clearComma(String(commissionArray[commissionSize])));
		              commVal.source = commissionObj;
		              if(!commVal.handleNumericField(numberFormatter)){
		                		//XenosAlert.info('Inside invalid commission');
		                 validEntry = false;
			             btnConfirm.enabled = true;
		    			 btnResetConfirm.enabled = true;
		    			 isEvaluated = false;
		    			 return;
		                }
		           }
	           
		           var taxSize:int = 0;
		           for(taxSize = 0; taxSize < taxArray.length; taxSize++ ){
		               var taxObj:TextInput = new TextInput();
		               taxObj.text = (clearComma(String(taxArray[taxSize])));
		               taxVal.source = taxObj;
		                	//XenosAlert.info('TAX '+ taxObj.text);
			           if(!taxVal.handleNumericField(numberFormatter)){
			              validEntry = false;
			              btnConfirm.enabled = true;
		    			  btnResetConfirm.enabled = true;
		    			  isEvaluated = false;
		    			  return;
			              }
		            }
	    	}*/
	    	//XenosAlert.info(' Valid Entry ' + validEntry.valueOf());
	    	//XenosAlert.info('Entry Valid  '+ validEntry.valueOf());
	    	 if(isReqEligibleToBeSent && isDateNull && validEntry){
	    		var obj:Object = new Object();
				obj.method= "loadBulkCloseoutUserConf";
		 		obj.selector = trdPkArr;
		 		obj.qtyArray = qtyArray;
		 		obj.priceArray = priceArray;
		 		obj.commissionArray = commissionArray;
		 		obj.taxArray = taxArray;
		 		obj.taxArray02 = taxArray02;
		 	    obj.tradeDateStr = this.trddate.text;
		 		obj.valueDateStr = this.valdate.text;
		 		obj.closeExecutionOffice = this.closeExecutionOffice.selectedItem != null ? StringUtil.trim(this.closeExecutionOffice.selectedItem.value) : XenosStringUtils.EMPTY_STR;
		 		obj['SCREEN_KEY'] = "12009";
		 		obj.rnd = Math.random();
		 		loadUserConf.url = "drv/drvBulkCloseoutDispatch.action?";
		 		loadUserConf.request = obj;
				loadUserConf.send();
	    	}
	    	else if(!validEntry){
	    		isEvaluated = false;
	    		isEvaluatedByFocus = false;
	    	}
	    }
	    
	    
	    private function loadUserConfPage(event:ResultEvent):void {
	    	btnConfirm.enabled = true;
	    	btnResetConfirm.enabled = true;
	       	if(event != null){
				if(event.result != null){
					var rs:XML = XML(event.result);
					if(rs.child("selectedTradeList").length()>0){
						summaryErrPage.removeError();
						selectedQueryResult = new ArrayCollection();
						for each ( var rec:XML in rs.selectedTradeList.selectedTrade ) {
		 				    selectedQueryResult.addItem(rec);
					    }
                        softException = new ArrayCollection();
					    if(rs.child("softExceptionList").length()>0){
						for each ( var rec:XML in rs.softExceptionList.item.value ) {					    	
							softException.addItem(rec);
							}
						}
					    
						var parentApp :UIComponent = UIComponent(this.parentApplication);
						sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
						sPopup.addEventListener(CloseEvent.CLOSE,closePopUp);
						sPopup.title = this.parentApplication.xResourceManager.getKeyValue('drv.bulk.closeout.popup.title');
						sPopup.width = 950;
						sPopup.height = 550;
						sPopup.owner = this;
						PopUpManager.centerPopUp(sPopup);
						sPopup.moduleUrl = "assets/appl/drv/DrvBulkCloseoutConfirmation.swf?selTrdPkArr="+trdPkArr;
					}else if(rs.child("Errors").length()>0){
								var errorInfoList : ArrayCollection = new ArrayCollection();
								for each ( var error:XML in rs.Errors.error ) {
					 			   errorInfoList.addItem(error.toString());
								}
			    				summaryErrPage.showError(errorInfoList);
					}else{
						XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
					}
				}else{
					XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				}
			}else{
				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			}
       }
	    
	    
	    
	    public function closePopUp(event:CloseEvent):void{
			this.dispatchEvent(new Event('querySubmit'));
			sPopup.removeEventListener(CloseEvent.CLOSE,closePopUp);
			sPopup.removeMe();
			isEvaluated = false;
			isEvaluatedByFocus = false;
		}
	    
	    private function validateQuantity(view:Object):Boolean{
	    	var isReqEligibleToBeSent:Boolean = true;
	    	if(XenosStringUtils.isBlank(view.openBalanceQty)){
	    		isReqEligibleToBeSent = false;
	    		//isEvaluated is being set just before the error alert to avoid the focusout
	    		isEvaluated = true;
	    		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.validation.error.qty.cannot.be.blank')+view.tradeReferenceNo);
	    		//isEvaluated is again reset to the previous stage
	    		isEvaluated = false;
	    	}else{
	    		var qtyStr:String = clearComma(String(view.openBalanceQty));
	    		var openQtyStr:String = clearComma(String(view.openBalanceQuantityStr));
	    		var qty:Number = new Number(qtyStr);
	    		var openQty:Number = new Number(openQtyStr);
	    		if(qty <= 0){
	    			isReqEligibleToBeSent = false;
	    			isEvaluated = true;
	    			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.validation.error.qty.less.or.equal.zero')+view.tradeReferenceNo);
	    			isEvaluated = false;
	    		}else{
	    			if(qty > openQty){
	    				isReqEligibleToBeSent = false;
	    				isEvaluated = true;
		    			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.validation.error.qty.greater.than.open.balance.qty')+view.tradeReferenceNo);
		    			isEvaluated = false;
	    			}
	    		}
	    	}
	    	return isReqEligibleToBeSent;
	    }
	    
	    private function validateCommission(view:Object):Boolean{
	    	var isReqEligibleToBeSent:Boolean = true;
	    	if(XenosStringUtils.isBlank(view.commission)){
	    		isReqEligibleToBeSent = false;
	    		isEvaluated = true;
	    		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.validation.error.comm.cannot.be.blank')+view.tradeReferenceNo);
	    		isEvaluated = false;
	    	}
	    	return isReqEligibleToBeSent;
	    }
	    
	    private function validateTax(view:Object):Boolean{
	    	var isReqEligibleToBeSent:Boolean = true;
	    	if(!XenosStringUtils.isBlank(view.tax)){
	    		var taxStr:String = clearComma(String(view.tax));
	    		var tax:Number = new Number(taxStr);
	    		if(tax <= 0){
	    			isReqEligibleToBeSent = false;
	    			isEvaluated = true;
	    			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.validation.error.tax.cannot.be.zero.or.less')+view.tradeReferenceNo);
	    			isEvaluated = false;
	    		}
	    	}
	    	return isReqEligibleToBeSent;
	    }
	    
	    /**
	    * Validate Drv Tax 02.
	    * If value of Drv Tax 02 is less than Zero error message will 
	    * be displayed.
	    * 
	    */
	    private function validateDrvTax02(view:Object):Boolean{
	    	var isReqEligibleToBeSent:Boolean = true;
	    	if(!XenosStringUtils.isBlank(view.tax02)){
	    		var taxStr:String = clearComma(String(view.tax02));
	    		var tax:Number = new Number(taxStr);
	    		if(tax <= 0){
	    			isReqEligibleToBeSent = false;
	    			isEvaluated = true;
	    			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.validation.error.tax02.cannot.be.zero.or.less')+view.tradeReferenceNo);
	    			isEvaluated = false;
	    		}
	    	}
	    	return isReqEligibleToBeSent;
	    }
	    
	    private function clearComma(str:String):String{
        	var retStr:String = '';
        	var strArr:Array = new Array();
        	if(str != null){
        		if(str.indexOf(',') != -1){
	        		strArr = str.split(',');
	        	}
        	}
        	if(strArr.length > 0){
        		for(var i:int = 0; i < strArr.length; i++){
        			retStr = retStr + strArr[i];
        		}
        	}else{
        		retStr = str;
        	}
        	return retStr;
        }
	    
	    
	    
	    private function initializeQueryResult():void {
	    	for each(var view:Object in this.queryResult){
	    		view.price = XenosStringUtils.EMPTY_STR;
	    		view.commission = XenosStringUtils.EMPTY_STR;
	    		view.tax = XenosStringUtils.EMPTY_STR;
	    		view.openBalanceQty = String(view.openBalanceQuantityStr);
	    	}
	    }
	    
	    private function resetConfirm():void {
	    	btnConfirm.enabled = false;
	    	btnResetConfirm.enabled = false;
	    	this.trddate.text = XenosStringUtils.EMPTY_STR;
	    	this.valdate.text = XenosStringUtils.EMPTY_STR;
	    	isEvaluated = false;
	    	isEvaluatedByFocus = false;
	    	this.dispatchEvent(new Event('querySubmit'));
	    }
