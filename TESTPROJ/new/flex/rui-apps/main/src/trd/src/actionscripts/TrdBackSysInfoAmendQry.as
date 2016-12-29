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
import com.nri.rui.trd.validator.TradeBackSystemInfoAmendQueryValidator;

import mx.collections.ArrayCollection;
import mx.controls.TextInput;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.UIComponent;
import mx.managers.PopUpManager;
import mx.utils.StringUtil;
			
	     [Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
	     [Bindable]public var queryResult:ArrayCollection= new ArrayCollection();
	     [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
	     [Bindable]private var mode : String = "query";
	     [Bindable]private var finInst:FinInstitutePopUpHbox = new FinInstitutePopUpHbox();
    	 [Bindable]private var strategyPopup:StrategyPopUpHBox = new StrategyPopUpHBox();
    	 [Bindable]private var counterPartyTxtInput:TextInput = new TextInput();
    	 [Bindable]private var initcol:ArrayCollection = new ArrayCollection();
    	 [Bindable]public var backSysPendingFlagList:ArrayCollection = new ArrayCollection();
    	 [Bindable]public var sPopup : SummaryPopup ;
    	 [Bindable]public var trdPkArray : Array = new Array();
    	 [Bindable]public var selectAllBind:Boolean = false;
    	 
    	 private var selectedResults:ArrayCollection=new ArrayCollection();
    	 public var confirmSelectedResults : Array;
    	 public var trdPks : ArrayCollection = new ArrayCollection();
	     private var keylist:ArrayCollection = new ArrayCollection(); 
	     private var csd:CustomizeSortOrder = null;
	     private var sortFieldArray:Array =new Array();
    	 private var sortFieldDataSet:Array =new Array();
    	 private var sortFieldSelectedItem:Array =new Array();
    	 private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
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
		        super.getInitHttpService().url = "trd/trdBackSysInfoAmendDispatch.action?method=initialExecute&mode=query&menuType=Y&rnd=" + rndNo;
		        var req : Object = new Object();
		        req.SCREEN_KEY = "12003";
	            super.getInitHttpService().request = req;
        }
        
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();      	
	    	keylist.addItem("tradeTypeValues.item");
	    	keylist.addItem("buySellFlagValues.item");
	    	keylist.addItem("backSystemPendingFlagValues.item");
	    	keylist.addItem("tradeDateFrom");
	    	keylist.addItem("tradeDateTo");
	    	keylist.addItem("statusValues.item");
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
        
        private function commonInit(mapObj:Object):void{
        	
        	btnSubmit.enabled = true;
    		btnReset.enabled = true;
        	//clears the errors if any
	        errPage.clearError(super.getInitResultEvent());
	        app.submitButtonInstance = btnSubmit;
        	//For SortField1
	        var sortField1Default:String = mapObj["sortField1"].toString();
	        //For SortField2
	        var sortField2Default:String = mapObj["sortField2"].toString();
	        //For SortField3
	        var sortField3Default:String = mapObj["sortField3"].toString(); 
	        //For SortField4
	        var sortField4Default:String = mapObj["sortField4"].toString();
	    	
	    	this.fundPopUp.fundCode.text = "";
	    	
	    	/* Populating Trade type drop down*/
	    	initcol = new ArrayCollection();
	    	item = new Object();
	    	initcol.addItem({label:" ", value: " "});
	    	if(mapObj["tradeTypeValues.item"]!=null){
	    		if(mapObj["tradeTypeValues.item"] is ArrayCollection){
	    			for each(item in (mapObj["tradeTypeValues.item"] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	    		}else{
	    			initcol.addItem(mapObj["tradeTypeValues.item"]);
	    		}
	    	}
	    	this.tradeType.dataProvider = initcol;
	    	/* End of Populating Trade type drop down */
	    	
	    	this.trdRefNo.text=""; 
	    	
	    	/* Populating Buy Sell Flag drop down*/
	    	initcol = new ArrayCollection();
	    	item = new Object();
	    	initcol.addItem({label:" ", value: " "});
	    	if(mapObj["buySellFlagValues.item"]!=null){
	    		if(mapObj["buySellFlagValues.item"] is ArrayCollection){
	    			for each(item in (mapObj["buySellFlagValues.item"] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	    		}else{
	    			initcol.addItem(mapObj["buySellFlagValues.item"]);
	    		}
	    	}
	    	this.buySellFlag.dataProvider = initcol;
	    	/* End of Populating Buy Sell Flag drop down */
	    	
	    	backSysPendingFlagList = new ArrayCollection();
	    	this.backSysPendingFlagList.addItem("Y");
	    	this.backSysPendingFlagList.addItem("N");
	    	
	    	var dateStr:String = "";
	    	if(mapObj["tradeDateFrom"]!= null && mapObj["tradeDateTo"] != null) {
	            dateStr = mapObj["tradeDateFrom"];
	            if(!XenosStringUtils.isBlank(dateStr))
	                trddateFrom.selectedDate = DateUtils.toDate(dateStr);                
	
	            dateStr = mapObj["tradeDateTo"];
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
	        
	        //security
	        this.security.instrumentId.text="";
	        
	        //tradecurrency
	        this.tradecurrency.ccyText.text="";
	        
			//valuedateFrom
	        this.valuedateFrom.text="";
	        
	        //valuedateTo
	        this.valuedateTo.text="";
	        
	    	/* Populating status drop down*/
	    	initcol = new ArrayCollection();
	    	item = new Object();
	    	initcol.addItem({label:" ", value: " "});
	    	if(mapObj["statusValues.item"]!=null){
	    		if(mapObj["statusValues.item"] is ArrayCollection){
	    			for each(item in (mapObj["statusValues.item"] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	    		}else{
	    			initcol.addItem(mapObj["statusValues.item"]);
	    		}
	    	}
	    	this.tradestatus.dataProvider = initcol;
	    	
	    	/* Populating back system pending flag drop down*/
	    	initcol = new ArrayCollection();
	    	item = new Object();
	    	initcol.addItem({label:" ", value: " "});
	    	if(mapObj["backSystemPendingFlagValues.item"]!=null){
	    		if(mapObj["backSystemPendingFlagValues.item"] is ArrayCollection){
	    			for each(item in (mapObj["backSystemPendingFlagValues.item"] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	    		}else{
	    			initcol.addItem(mapObj["backSystemPendingFlagValues.item"]);
	    		}
	    	}
	    	this.bckSysPendingFlag.dataProvider = initcol;

	    	
	    	//----------Start of population of SortField1----------//
	        
	        if(null != mapObj["sortFieldList1.item"]){
	        	item = new Object();
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
        		tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	if(mapObj["sortFieldList1.item"] is ArrayCollection){
	        		for each(item in (mapObj["sortFieldList1.item"] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	        	}else {
	        		initcol.addItem(mapObj["sortFieldList1.item"]);
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
	        
	        if(null != mapObj["sortFieldList2.item"]){
	        	item = new Object();
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
	        	tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	
	        	if(mapObj["sortFieldList2.item"] is ArrayCollection){
	        		for each(item in (mapObj["sortFieldList2.item"] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	        	}else{
	        		initcol.addItem(mapObj["sortFieldList2.item"]);
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
	        
	        if(null != mapObj["sortFieldList3.item"]){
	        	item = new Object();
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
	        	tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	
	        	if(mapObj["sortFieldList3.item"] is ArrayCollection){
	        		for each(item in (mapObj["sortFieldList3.item"] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	        	}else{
	        		initcol.addItem(mapObj["sortFieldList3.item"]);
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
	        
	        if(null != mapObj["sortFieldList4.item"]){
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
	        	tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	
	        	if(mapObj["sortFieldList4.item"] is ArrayCollection){
	        		for each(item in (mapObj["sortFieldList4.item"] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	        	}else{
	        		initcol.addItem(mapObj["sortFieldList4.item"]);
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
        
    	private function setValidator():void{
		
	    var tradeQueryModel:Object={
                        tradeQuery:{                                 
                             trddateFrom:this.trddateFrom.text,
                             trddateTo:this.trddateTo.text,
                             valuedateFrom:this.valuedateFrom.text,
                             valuedateTo:this.valuedateTo.text
                        }
                       }; 
         super._validator = new TradeBackSystemInfoAmendQueryValidator();
         super._validator.source = tradeQueryModel ;
         super._validator.property = "tradeQuery";
		}
		
		override public function preQuery():void{
			if(selectedResults!=null){
       			selectedResults.removeAll();
       			confirmSelectedResults = selectedResults.toArray();
       		}
			setValidator();
            qh.resetPageNo();
            super.getSubmitQueryHttpService().url = "trd/trdBackSysInfoAmendDispatch.action?";  
            super.getSubmitQueryHttpService().request = populateRequestParams();
		}
		override public function postQuery():void{
			btnSubmit.enabled = true;
    		btnReset.enabled = true;
		}
		
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	
    	reqObj.SCREEN_KEY = "12004";
     	reqObj.method = "submitQuery";
        reqObj.tradeType = this.tradeType.selectedItem != null ?  this.tradeType.selectedItem.value : "";
        reqObj.referenceNo = this.trdRefNo.text;
        reqObj.buySellFlag = this.buySellFlag.selectedItem != null ?  this.buySellFlag.selectedItem.value : "";
        reqObj.backSystemPendingFlag = this.bckSysPendingFlag.selectedItem != null ?  this.bckSysPendingFlag.selectedItem.value : "";
        reqObj.inventoryAccountNo = this.inventoryAccountNo.accountNo.text; 
        reqObj.fundCode = this.fundPopUp.fundCode.text;
        reqObj.securityCode = this.security.instrumentId.text;      
        reqObj.tradeCcy = this.tradecurrency.ccyText.text;
        reqObj.tradeDateFrom = this.trddateFrom.text; 
        reqObj.tradeDateTo = this.trddateTo.text;           
        reqObj.valueDateFrom = this.valuedateFrom.text; 
        reqObj.valueDateTo = this.valuedateTo.text;
        reqObj.status = this.tradestatus.selectedItem != null ?  this.tradestatus.selectedItem.value : "";           
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
        
    private function commonResult(mapObj:Object):void{
    	var result:String = "";
    	btnSubmit.enabled = true;
    	btnReset.enabled = true;
    	if(mapObj!=null){   
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		queryResult.removeAll();
	    		errPage.showError(mapObj["errorMsg"]);
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    	   errPage.clearError(super.getSubmitQueryResultEvent());
               queryResult.removeAll();
               queryResult = mapObj["row"];
			   changeCurrentState();
			   resetSellection(queryResult);
			   setIfAllSelected();
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
	       var rndNo:Number= Math.random();
	  		super.getResetHttpService().url = "trd/trdBackSysInfoAmendDispatch.action?method=resetQuery&&mode=query&&menuType=Y&rnd=" + rndNo;        	
    }
    override public function preGenerateXls():String{
    	 var url : String =null;
    	 url = "trd/trdBackSysInfoAmendDispatch.action?method=generateXLS";
	     return url;
     }	
   
   	  override public function preGeneratePdf():String{
	    var url : String = null;
		url = "trd/trdBackSysInfoAmendDispatch.action?method=generatePDF";
	    return url;
      }	
        
   	override public function preNext():Object{
   		if(selectedResults!=null){
   			selectedResults.removeAll();
   			confirmSelectedResults=selectedResults.toArray();
   		}
	   var reqObj : Object = new Object();
	   reqObj.method = "doNext";
	   return reqObj;
     }	
	override public function prePrevious():Object{
		if(selectedResults!=null){
   			selectedResults.removeAll();
   			confirmSelectedResults=selectedResults.toArray();
   		}
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
	
	private function showConfirmModule():void {
        var parentApp :UIComponent = UIComponent(this.parentApplication);
        var selectedItem:Array = getSelectedRows();
        if(selectedItem.length < 1){
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.back.system.error.trade.notselected'));
            return;
        }else{
        	for(var i:int; i < confirmSelectedResults.length; i++){
	        	var isCancel:Boolean = false;
	        	if(!XenosStringUtils.equals(String(confirmSelectedResults[i].status),"NORMAL")){
	  				isCancel = true;
	  				break;
	  			}
	        }
	        if(isCancel){
 	 			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.back.system.error.amend.screen.only.normal'));
 	 		}else{
 	 			sPopup = SummaryPopup(PopUpManager.createPopUp(this, SummaryPopup, true));
		        sPopup.title = this.parentApplication.xResourceManager.getKeyValue('trd.back.system.info.amend.screen.title.confirmation');
		        sPopup.addEventListener(CloseEvent.CLOSE,closeHandler);
		        sPopup.width = 820;
		        sPopup.height = 330;
		        PopUpManager.centerPopUp(sPopup);
		        sPopup.owner = this;
		        sPopup.dataObj = selectedItem;
		        sPopup.moduleUrl = "assets/appl/trd/BackSystemInfoAmendConfirmation.swf" + Globals.QS_SIGN
									+ "selectedItems"+ Globals.EQUALS_SIGN + selectedItem;
 	 		}
        }
    }
    
    public function closeHandler(event:Event):void {
    	this.submitQuery();
		sPopup.removeEventListener(CloseEvent.CLOSE,closeHandler);
		sPopup.removeMe();
    }
    
    public function submitQuery():void {
    	if(btnSubmit.enabled){
    		btnSubmit.enabled = false;
    		btnReset.enabled = false;
    		this.dispatchEvent(new Event("querySubmit"));
    	}
    }
    
    public function resetQuery():void {
    	btnSubmit.enabled = false;
    	btnReset.enabled = false;
    	this.dispatchEvent(new Event("queryReset"));
    }
	
	
	private function getSelectedRows():Array{
        var tempArray:ArrayCollection = new ArrayCollection();
        for(var i:int=0; i < queryResult.length; i++){
            if(queryResult[i].selected == true){
                tempArray.addItem(i);
            }            
        }
        return tempArray.toArray();
    }
	
	
	//***Start**** To handle select and select all functionality *****Start***/
	public function checkSelectToModify(item:Object):void {
        var i:Number;
        var tempArray:Array = new Array();
        if(item.selected == true){
        	 // needs to insert
        	var obj:Object=new Object();
        	obj.backSystemInfoPk = item.backSystemInfoPk;
        	obj.tradePk = item.tradePk;
        	obj.backSystemPendingFlag = item.backSystemPendingFlag;
        	obj.status = item.status;
        	obj.rowNum=item.rowNum;
            selectedResults.addItem(obj);
    	}else { //needs to pop
    		tempArray = selectedResults.toArray();
    	    selectedResults.removeAll();
    		for(i=0; i<tempArray.length; i++){
    			if(tempArray[i].tradePk != item.tradePk){
    			    selectedResults.addItem(tempArray[i]);
    			}
    		}
    	}    
    	confirmSelectedResults = selectedResults.toArray();
    	setIfAllSelected();    	    	
    }

    public function selectAllRecords(flag:Boolean): void {
    	var i:Number = 0;
    	selectedResults.removeAll();
    	for(i=0; i<queryResult.length; i++){
    		var obj:XML=queryResult[i];
            obj.selected = flag;
            queryResult[i]=obj;
            addOrRemove(queryResult[i]);
    	}
    	confirmSelectedResults = selectedResults.toArray();
    }

    /**
    * Determines whether the record needs to be added or deleted according the 
    * selected value of the Check Box.
    */ 
    public function addOrRemove(item:Object):void {
    	var i:Number;
        var tempArray:Array = new Array();
        if(item.selected == true){ 
        	var obj:Object=new Object();
        	obj.backSystemInfoPk = item.backSystemInfoPk;
        	obj.tradePk = item.tradePk;
        	obj.backSystemPendingFlag = item.backSystemPendingFlag;
        	obj.status = item.status;
        	obj.rowNum=item.rowNum;
            selectedResults.addItem(obj);
           
    	}else { //needs to pop
    		tempArray = selectedResults.toArray();
    	    selectedResults.removeAll();
    		for(i=0; i<tempArray.length; i++){
    			if(tempArray[i].backSystemInfoPk != item.backSystemInfoPk){
    			    selectedResults.addItem(tempArray[i]);
    			}
    		}        		
    	}		
    }
    
    private function resetSellection(queryResult:ArrayCollection):void{
    	for(var i:int=0;i<queryResult.length;i++){
    		queryResult[i].selected = false;
    		queryResult[i].rowNum = i;
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
        if(queryResult == null){
         return false;
        }
        for(i=0; i<queryResult.length; i++){
            if(queryResult[i].selected == false) {
                return false;
            }
        }
        if(i == queryResult.length) {
            return true;
         } else {
            return false;
        }
    }
    
	//***End**** To handle select and select all functionality *****End***/
