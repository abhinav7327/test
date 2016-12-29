// ActionScript file
import com.nri.rui.bkg.validators.BkgTradeQueryValidator;
import com.nri.rui.core.Globals;
import com.nri.rui.core.RendererFectory;
import com.nri.rui.core.containers.SummaryPopup;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.core.validators.XenosNumberValidator;
import com.nri.rui.ref.popupImpl.FinInstitutePopUpHbox;
import com.nri.rui.ref.popupImpl.StrategyPopUpHBox;

import mx.collections.ArrayCollection;
import mx.controls.TextInput;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.UIComponent;
import mx.events.ValidationResultEvent;
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
		  
       public function loadAll():void{
       	   parseUrlString();
       	   super.setXenosQueryControl(new XenosQuery());
       	   if(this.mode == 'query'){
       	   	 this.dispatchEvent(new Event('queryInit'));
       	   } else if(this.mode == 'amend'){
       	   	 this.dispatchEvent(new Event('amendInit'));
       	   	 addColumn();
       	   } else { 
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
		        super.getInitHttpService().url = "bkg/depoLoanQueryDispatch.action?method=initialExecute&mode=query&menuType=Y&rnd=" + rndNo;
		        var req : Object = new Object();
	            req.SCREEN_KEY = "357";
	            super.getInitHttpService().request = req;
        }
        
        override public function preAmendInit():void{
		        var rndNo:Number= Math.random();
		        super.getInitHttpService().url = "bkg/depoLoanAmendQueryDispatch.action?&rnd=" + rndNo;
		        var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="initialExecute";
		  		reqObject.SCREEN_KEY = "349";
		  		super.getInitHttpService().request = reqObject;     	
        }
        
        override public function preCancelInit():void{
		        var rndNo:Number= Math.random();
		        super.getInitHttpService().url = "bkg/depoLoanCxlQueryDispatch.action?&rnd=" + rndNo;  
		        var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="initialExecute";
		  		reqObject.SCREEN_KEY = "348";
		  		super.getInitHttpService().request = reqObject;      	
        }        
        
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();      	
	    	keylist.addItem("scrndisdata.tradeTypeList.tradeType");
	    	keylist.addItem("counterPartyTypeValues.item");
	    	keylist.addItem("scrndisdata.statusList.item");
	    	keylist.addItem("scrndisdata.outStandList.item");	
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
        	
        	var selIndx:int = 0;
        	var i:int = 0;
        	fundPopUp.fundCode.setFocus();
        	var tempColl: ArrayCollection = new ArrayCollection();
        	//clears the errors if any
	        errPage.clearError(super.getInitResultEvent());
	        app.submitButtonInstance = submit;
        	//For SortField1
	        var sortField1Default:String = mapObj[keylist.getItemAt(7)].toString();
	        //For SortField2
	        var sortField2Default:String = mapObj[keylist.getItemAt(8)].toString();
	        //For SortField3
	        var sortField3Default:String = mapObj[keylist.getItemAt(9)].toString(); 
	    	
	    	this.fundPopUp.fundCode.text = "";
	    	this.fundAccountPopup.accountNo.text = "";
	    	
	    	/* Populating Trade type drop down*/
	    	initcol = new ArrayCollection();
	    	initcol.addItem(" ");
	    	if(mapObj[keylist.getItemAt(0)]!=null){
	    		if(mapObj[keylist.getItemAt(0)] is ArrayCollection){
	    			for each(var item:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	    		}else{
	    			initcol.addItem(mapObj[keylist.getItemAt(0)].toString());
	    		}
	    	}
	    	this.tradeType.dataProvider = initcol;
	    	/* End of Populating Trade type drop down */
	    	
	    	/* Populating CounterParty drop down*/
	    	initcol = new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	if(mapObj[keylist.getItemAt(1)]!=null){
	    		if(mapObj[keylist.getItemAt(1)] is ArrayCollection){
	    			for each(var item1:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
		    			initcol.addItem(item1);
		    		}
	    		}else{
	    			initcol.addItem(mapObj[keylist.getItemAt(1)]);
	    		}
	    	}
	    	this.counterPartyCode.dataProvider = initcol;
	    	this.counterPartyCode.selectedIndex = 0;
	    	/* End of Populating CounterParty drop down */
	    	
	    	/*Populating CounterParty Code Text Box*/
	    	if(counterpartyCodeBox.contains(finInst)){
	    		counterpartyCodeBox.removeChild(finInst);
	    	}
	    	if(counterpartyCodeBox.contains(counterPartyTxtInput)){
	    		counterpartyCodeBox.removeChild(counterPartyTxtInput);
	    	}
	    	finInst.percentWidth = 50;
	    	finInst.name = "Broker";
	    	finInst.recContextItem = populateFinInstRole();
	    	counterPartyTxtInput.percentWidth = 50;
	    	counterPartyTxtInput.name = "Blank"; 
	    	counterPartyTxtInput.restrict=Globals.INPUT_PATTERN;
	    	counterpartyCodeBox.addChild(counterPartyTxtInput);
	    	/*End of Populating CounterParty Code Text Box*/
	    	
	    	//Initial Settings for populating Counterparty Code
	        if(finInst!=null){
	        	if(finInst.finInstCode !=null){
	        		finInst.finInstCode.text = "";
	        	}
	        	finInst.name = "Broker";
	        }
	        if(counterPartyTxtInput!=null){
	        	counterPartyTxtInput.text = "";
	        	counterPartyTxtInput.name = "Blank";
	        }
	        onChangeCounterpartyCode();
	    	/* End of Initial Settings for populating Counterparty Code*/
	    	
	    	this.referenceNo.text = "";
	    	
	    	/* Populating Status drop down*/
	    	initcol = new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	if(mapObj[keylist.getItemAt(2)]!=null){
	    		if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
	    			for each(var item2:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
		    			initcol.addItem(item2);
		    		}
	    		}else{
	    			initcol.addItem(mapObj[keylist.getItemAt(2)]);
	    		}
	    	}
	    	this.statusCombo.visible = true;
	    	this.statusCombo.includeInLayout = true;
	    	this.statusTxt.visible = false;
	    	this.statusTxt.includeInLayout = false;
	    	this.statusCombo.dataProvider = initcol;
	    	/* End of Populating Status drop down */
	    	
	    	
	    	this.currencyCode.ccyText.text = "";
	    	this.tradeDateFrom.text = "";
	    	this.tradeDateTo.text = "";
	    	this.startDateFrom.text = "";
	    	this.startDateTo.text = "";
	    	this.maturityDateFrom.text = "";
	    	this.maturityDateTo.text = "";
	    	this.principalAmtFrom.text = "";
	    	this.principalAmtTo.text = "";
	    	this.netAmtFrom.text = "";
	    	this.netAmtTo.text = "";
	    	
	    	/* Populating Outstanding-Matured drop down*/
	    	initcol = new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	if(mapObj[keylist.getItemAt(3)]!=null){
	    		if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
	    			for each(var item3:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
		    			initcol.addItem(item3);
		    		}
	    		}else{
	    			initcol.addItem(mapObj[keylist.getItemAt(3)]);
	    		}
	    	}
	    	this.outStand.dataProvider = initcol;
	    	/* End of Populating Outstanding-Matured drop down */
	    	
	    	this.cancelReferenceNo.text = "";
	    	this.accountNo.accountNo.text = "";
	    	
	    	//----------Start of population of SortField1----------//
	        
	        if(null != mapObj[keylist.getItemAt(4)]){
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
        		tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	if(mapObj[keylist.getItemAt(4)] is ArrayCollection){
	        		for each(var item4:Object in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
		    			initcol.addItem(item4);
		    		}
	        	}else {
	        		initcol.addItem(mapObj[keylist.getItemAt(4)]);
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
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('bkg.error.populate.sortorder1'));
	        } 
	        
	        //---------------End of population of SortField1-----------------------//
	        
	        //--------Start of population of sortField2---------//
	        
	        if(null != mapObj[keylist.getItemAt(5)]){
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
	        	tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	
	        	if(mapObj[keylist.getItemAt(5)] is ArrayCollection){
	        		for each(var item5:Object in (mapObj[keylist.getItemAt(5)] as ArrayCollection)){
		    			initcol.addItem(item5);
		    		}
	        	}else{
	        		initcol.addItem(mapObj[keylist.getItemAt(5)]);
	        	}
		        for(i = 0; i<initcol.length; i++) {
		        	//Get the default value object's index
	                if(XenosStringUtils.equals((initcol[i].value),sortField2Default)){                    
	                    selIndx = i;
	                }
		           tempColl.addItem(initcol[i]);            
		        }
		        
		        sortFieldArray[1]=sortField2;
		        sortFieldDataSet[1]=tempColl;
		        //Set the default value object
		        sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);
		        
	        } else {
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('bkg.error.populate.sortorder2'));
	        }
	        
	         //--------End of population of sortField2---------// 
	        
	         //--------Start of population of sortField3---------//
	        
	        if(null != mapObj[keylist.getItemAt(6)]){
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
	        	tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	
	        	if(mapObj[keylist.getItemAt(6)] is ArrayCollection){
	        		for each(var item6:Object in (mapObj[keylist.getItemAt(6)] as ArrayCollection)){
		    			initcol.addItem(item6);
		    		}
	        	}else{
	        		initcol.addItem(mapObj[keylist.getItemAt(6)]);
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
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('bkg.error.populate.sortorder3'));
	        } 
	        
	         //--------End of population of sortField3---------//
	        //-------------Initializing the sortfields-------------//
			csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
		    csd.init();
        }
        
        /**
	     * Method for updating the other two sortfields after any change in the sortfield1
	     */ 
	     private function sortOrder1Update():void{
	     	 csd.update(sortField1.selectedItem,0);
	     }
	     /**
	     * Method for updating the other two sortfields after any change in the sortfield2
	     */
	     private function sortOrder2Update():void{     	
	     	csd.update(sortField2.selectedItem,1);
	     }
        
        override public function postQueryResultInit(mapObj:Object):void{
        	commonInit(mapObj);
        }
        
        
        override public function postAmendResultInit(mapObj:Object):void{
        	commonInit(mapObj);	
        	this.statusCombo.visible = false;
        	this.statusCombo.includeInLayout = false;
        	this.statusTxt.visible = true;
        	this.statusTxt.includeInLayout = true;
        	this.statusTxt.text = "NORMAL";
        }
        
        override public function postCancelResultInit(mapObj:Object):void{
        	commonInit(mapObj);	
        	this.statusCombo.visible = false;
        	this.statusCombo.includeInLayout = false;
        	this.statusTxt.visible = true;
        	this.statusTxt.includeInLayout = true;
        	this.statusTxt.text = "NORMAL";
        }
        
    	private function setValidator():void{
		
	    var validateModel:Object={
                        bkgTradeQuery:{                                 
                             tradeDateFrom:this.tradeDateFrom.text,
                             tradeDateTo:this.tradeDateTo.text,
                             startDateFrom:this.startDateFrom.text,
                             startDateTo:this.startDateTo.text,
                             maturityDateFrom:this.maturityDateFrom.text,
                             maturityDateTo:this.maturityDateTo.text
                        }
                       }; 
         super._validator = new BkgTradeQueryValidator();
         super._validator.source = validateModel ;
         super._validator.property = "bkgTradeQuery";
		}
		
		override public function preQuery():void{
			setValidator();
            qh.resetPageNo();	
            super.getSubmitQueryHttpService().url = "bkg/depoLoanQueryDispatch.action?";  
            super.getSubmitQueryHttpService().request = populateRequestParams();
		}
		
		override public function preAmend():void{
			setValidator();
            qh.resetPageNo();	
            super.getSubmitQueryHttpService().url = "bkg/depoLoanAmendQueryDispatch.action?";   
            super.getSubmitQueryHttpService().request = populateRequestParams();  
           
		}
		
		override public function preCancel():void{
			setValidator();
			qh.resetPageNo();	
            super.getSubmitQueryHttpService().url = "bkg/depoLoanCxlQueryDispatch.action?"; 
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
    		reqObj['SCREEN_KEY'] = "344";
    	} else if(this.mode == 'amend'){
    		reqObj['SCREEN_KEY'] = "351";
    	}else if(this.mode == 'cancel'){
    		reqObj['SCREEN_KEY'] = "350";
    	}
     	reqObj.method = "submitQuery";
     	reqObj.fundCode = this.fundPopUp.fundCode.text;
     	reqObj.inventoryAccountNo = this.fundAccountPopup.accountNo.text;
     	reqObj.tradeType = this.tradeType.selectedItem != null ?  this.tradeType.selectedItem : "";
     	reqObj.counterPartyType = this.counterPartyCode.selectedItem != null ?  this.counterPartyCode.selectedItem.value : "";
     	if(counterPartyCode.selectedItem.label == "BROKER"){
    		 reqObj.counterPartyCode= this.finInst.finInstCode.text != null ? this.finInst.finInstCode.text : "";
    	}else{
    		 reqObj.counterPartyCode= this.counterPartyTxtInput.text != null ? this.counterPartyTxtInput.text : "";
    	}
    	reqObj.referenceNo = this.referenceNo.text; 
     	reqObj.currencyCode = this.currencyCode.ccyText.text;
     	reqObj.tradeDateFrom = this.tradeDateFrom.text; 
        reqObj.tradeDateTo = this.tradeDateTo.text;           
        reqObj.startDateFrom = this.startDateFrom.text; 
        reqObj.startDateTo = this.startDateTo.text;           
        reqObj.maturityDateFrom = this.maturityDateFrom.text; 
        reqObj.maturityDateTo = this.maturityDateTo.text; 
        reqObj.principalAmtFrom = this.principalAmtFrom.text; 
        reqObj.principalAmtTo = this.principalAmtTo.text;           
        reqObj.netAmtFrom = this.netAmtFrom.text; 
        reqObj.netAmtTo = this.netAmtTo.text;
        reqObj.outStand = this.outStand.selectedItem != null ?  this.outStand.selectedItem.value : "";
     	reqObj.cancelReferenceNo = this.cancelReferenceNo.text;
     	reqObj.accountNo = this.accountNo.accountNo.text;
        reqObj.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : Globals.EMPTY_STRING;
        reqObj.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : Globals.EMPTY_STRING;
        reqObj.sortField3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : Globals.EMPTY_STRING;
     	reqObj.rnd = Math.random() + "";
    	if(mode == "query"){
    		reqObj.status = this.statusCombo.selectedItem != null ? this.statusCombo.selectedItem.value : "";
    	}else{
    		reqObj.status = this.statusTxt.text;
    	}
    	
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
             	 displayDetailView(queryResult[0].bankingTradePk);
               }
	    	}else{
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}    		
    	}
    }   
       
      
        override public function preResetQuery():void{
		       var rndNo:Number= Math.random();
		  		super.getResetHttpService().url = "bkg/depoLoanQueryDispatch.action?method=reset&&mode=query&&menuType=Y&rnd=" + rndNo;        	
        }
        
        override public function preResetAmend():void{
		        var rndNo:Number= Math.random();
		        super.getResetHttpService().url = "bkg/depoLoanAmendQueryDispatch.action?&rnd=" + rndNo;
		        var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="reset";
		  		super.getResetHttpService().request = reqObject;     	
        }
        
        override public function preResetCancel():void{
		        var rndNo:Number= Math.random();
		        super.getResetHttpService().url = "bkg/depoLoanCxlQueryDispatch.action?&rnd=" + rndNo;  
		        var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="reset";
		  		super.getResetHttpService().request = reqObject;      	
        }       
        
        
        override public function preGenerateXls():String{
        	 var url : String =null;
		    	if(mode == "query"){		    		
		    	  url = "bkg/depoLoanQueryDispatch.action?method=generateXLS";
		    	}else if(mode == "amend"){
		    		url = "bkg/depoLoanAmendQueryDispatch.action?method=generateXLS";
		    	}else{
		    		url = "bkg/depoLoanCxlQueryDispatch.action?method=generateXLS";
		    	}
		    	return url;
         }	
   
   		override public function preGeneratePdf():String{
    	   var url : String =null;
		    	if(mode == "query"){		    		
		    	  url = "bkg/depoLoanQueryDispatch.action?method=generatePDF";
		    	}else if(mode == "amend"){
		    		url = "bkg/depoLoanAmendQueryDispatch.action?method=generatePDF";
		    	}else{
		    		url = "bkg/depoLoanCxlQueryDispatch.action?method=generatePDF";
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
             // XenosAlert.info("dispatchEvent pdf");
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
	     * Method to Format and validate numbers(B,M,T)
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
	                actTypeArray[0]="T|S|B";
	                //cpTypeArray[1]="CLIENT";
	            myContextList.addItem(new HiddenObject("invActTypeContext",actTypeArray));    
	                      
	            //passing counter party type                
	            var cpTypeArray:Array = new Array(1);
	                cpTypeArray[0]="INTERNAL";
	                //cpTypeArray[1]="CLIENT";
	            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
	        
	            //passing account status                
	            var actStatusArray:Array = new Array(1);
	            actStatusArray[0]="TRADING|BOTH";
	            myContextList.addItem(new HiddenObject("actContext",actStatusArray));
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
	                actTypeArray[0]="T|S|B";
	                //cpTypeArray[1]="CLIENT";
	            myContextList.addItem(new HiddenObject("invActTypeContext",actTypeArray));    
	                      
	            var cpTypeArray:Array = new Array(1);
	                cpTypeArray[0]="BROKER|BANK/CUSTODIAN";
	                //cpTypeArray[1]="CLIENT";
	            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
	        
	            //passing account status                
	            var actStatusArray:Array = new Array(1);
	            actStatusArray[0]="TRADING|BOTH";
	            myContextList.addItem(new HiddenObject("actContext",actStatusArray));
	            return myContextList;
	        }
	        
	        /**
		     * This method handles the counterpartycode and corresponding popup population
		     */ 
		    private function onChangeCounterpartyCode():void{
		    	if(counterPartyCode.selectedItem.label == "BROKER"){
		    		if(counterpartyCodeBox.getChildByName("Blank")){
			    		counterpartyCodeBox.addChild(finInst);
			    		counterpartyCodeBox.removeChild(counterPartyTxtInput);
			    	}
			    }else{
			    	if(counterpartyCodeBox.getChildByName("Broker")){
			    		counterpartyCodeBox.addChild(counterPartyTxtInput);
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
		     
		     
		     private function displayDetailView(bankingTrdPkStr:String):void{
					var sPopup : SummaryPopup;	
					sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
					sPopup.title = this.parentApplication.xResourceManager.getKeyValue('bkg.detail.label');
					sPopup.width = 700;
		    		sPopup.height = 460;
					PopUpManager.centerPopUp(sPopup);		
					sPopup.moduleUrl = Globals.BKG_TRADE_DETAILS_SWF+Globals.QS_SIGN+Globals.BKG_TRADE_PK+Globals.EQUALS_SIGN+bankingTrdPkStr;    	
		    }
