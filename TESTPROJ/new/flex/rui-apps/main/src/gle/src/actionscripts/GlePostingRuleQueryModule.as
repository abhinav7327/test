// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.ProcessResultUtil;

import mx.collections.ArrayCollection;
import mx.controls.DataGrid;
import mx.events.DataGridEvent;
import mx.events.ResourceEvent;
import mx.resources.ResourceBundle;
			
	  	  
     [Bindable]
     private var queryResult:ArrayCollection = new ArrayCollection();
     
     private var keylist:ArrayCollection = new ArrayCollection();     
     private var sortUtil: ProcessResultUtil = new ProcessResultUtil();
     
     [Bindable]
     private var mode:String = "query";
     	
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
            
     //Items returning through context - Non display objects for accountPopup
     [Bindable]
    	public var returnContextItem:ArrayCollection = new ArrayCollection();
      
	 /**
 	  *  datagrid header release event handler to handle datagridcolumn sorting
 	  */
     public function dataGrid_headerRelease(evt:DataGridEvent):void {
	 	var dg:DataGrid = DataGrid(evt.currentTarget);
     	sortUtil.clickedColumn = dg.columns[evt.columnIndex];		
	 }
		  
     private function changeCurrentState():void {
     	currentState = "result";
     }
			 
     public function loadAll():void {
     	parseUrlString();
     	super.setXenosQueryControl(new XenosQuery());
     	transactionType.setFocus();
     	if(this.mode == 'query') {
     		this.dispatchEvent(new Event('queryInit'));
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
     		//XenosAlert.info("Load Url : "+ this.loaderInfo.url.toString());
     		var s:String = this.loaderInfo.url.toString();
     		s = s.replace(myPattern, "");
     		// Create an Array of name=value Strings.
     		var params:Array = s.split(Globals.AND_SIGN); 
     		// Print the params that are in the Array.
     		var keyStr:String;
     		var valueStr:String;
     		var paramObj:Object = params;
                  
     		// Set the values of the salutation.
     		if(params != null) {
	 			for (var i:int = 0; i < params.length; i++) {
	 				var tempA:Array = params[i].split("=");  
	 				if (tempA[0] == "mode") {
	 					//XenosAlert.info("movArray param = " + tempA[1]);
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
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specifdic  
      * requriment. 
      */
     private function populateContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
          
        //passing counter party type                
        var cpTypeArray:Array = new Array(1);
        cpTypeArray[0] = "INTERNAL";
                
        myContextList.addItem(new HiddenObject("invCPTypeContext", cpTypeArray));
        
        //passing account status                
        var actStatusArray:Array = new Array(1);
        actStatusArray[0] = "OPEN";
        myContextList.addItem(new HiddenObject("accountStatus", actStatusArray));
        return myContextList;
     }
     
                
     override public function preQueryInit():void {
		var rndNo:Number = Math.random();
		super.getInitHttpService().url = "gle/postingRuleQueryDispatch.action?method=initialExecute&&mode=query&&menuType=Y&rnd=" + rndNo;
		var reqObj:Object = new Object();
		reqObj['SCREEN_KEY'] = 558;
		super.getInitHttpService().request = reqObj;        	
     }
     
     override public function preQueryResultInit():Object {
        addCommonKeys();     	
	    return keylist;        	
     }
         
     private function addCommonKeys():void{  
        	keylist = new ArrayCollection();  
	    	keylist.addItem("transactionTypeList.item");
	    	keylist.addItem("accountBalanceTypeList.item");
	    	keylist.addItem("principalAgentFlagList.item");
	    	keylist.addItem("tradeTypeList.item");
	    	keylist.addItem("settlementModeList.item");
	    	keylist.addItem("actionTypeList.item");	
	    	keylist.addItem("subTradeTypeList.item");
	    	keylist.addItem("longShortFlagList.item");
	    	keylist.addItem("accrualTypeList.item");
	    	keylist.addItem("inOutFlagList.item");
	    	keylist.addItem("payableReceivableFlagList.item");
	    	keylist.addItem("startEndFlagList.item");
	    	keylist.addItem("plIndicatorList.item");
	    	keylist.addItem("netDownFlagList.item");
	    	keylist.addItem("counterpartyTypeList.item");
	    	keylist.addItem("forwardRepoFlagList.item");
	    	keylist.addItem("quasiCompByList.item");
	    	keylist.addItem("reportableFlagList.item");
	    	keylist.addItem("wireTypeList.item");
	    	keylist.addItem("pwcIncomeTypeList.item");
        }
     
     override public function postQueryResultInit(mapObj:Object):void {
        commonInit(mapObj);    		
     }
        
     private function commonInit(mapObj:Object):void{
     	var i:int = 0;
        var initColl: ArrayCollection = new ArrayCollection();
        var tempColl: ArrayCollection = new ArrayCollection();    
        errPage.clearError(super.getInitResultEvent()); //clears the errors if any
        if(initColl.length > 0){
    		initColl.removeAll();
    	} 
               
        //*******************************************************************
                
        //Initialize Transaction Type.
        for each(var item0:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)) {
	    	initColl.addItem(item0);
	    }
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
	    transactionType.dataProvider = tempColl;
	    
	    //Initialize Security Type
	    this.securitytype.text = "";
	    
	    //Initialize Market
	    this.market.text = "";
		
		//Initialize Account Balance Type.
		initColl.removeAll();
		tempColl = new ArrayCollection();
        for each(var item1:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)) {
	    	initColl.addItem(item1);
	    }
	    tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
	    accountbalancetype.dataProvider = tempColl;
		
		//Initialize Principal Agent Flag.
		initColl.removeAll();
		tempColl = new ArrayCollection();
        for each(var item2:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)) {
	    	initColl.addItem(item2);
	    }
	    tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
	    principalagentflag.dataProvider = tempColl;
		
		//Initialize Trade Type.
		initColl.removeAll();
		tempColl = new ArrayCollection();
        for each(var item3:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)) {
	    	initColl.addItem(item3);
	    }
	    tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
	    tradetype.dataProvider = tempColl;
		
		//Initialize Settlement Mode.
		initColl.removeAll();
		tempColl = new ArrayCollection();
        for each(var item4:Object in (mapObj[keylist.getItemAt(4)] as ArrayCollection)) {
	    	initColl.addItem(item4);
	    }
	    tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
	    settlementmode.dataProvider = tempColl;
		
		//Initialize Action Type.
		initColl.removeAll();
		tempColl = new ArrayCollection();
        for each(var item5:Object in (mapObj[keylist.getItemAt(5)] as ArrayCollection)) {
	    	initColl.addItem(item5);
	    }
	    tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
	    actiontype.dataProvider = tempColl;
		
		//Initialize Sub Trade Type.
		initColl.removeAll();
		tempColl = new ArrayCollection();
        for each(var item6:Object in (mapObj[keylist.getItemAt(6)] as ArrayCollection)) {
	    	initColl.addItem(item6);
	    }
	    tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
	    subtradetype.dataProvider = tempColl;
		
		//Initialize Long Short Flag.
		initColl.removeAll();
		tempColl = new ArrayCollection();
        for each(var item7:Object in (mapObj[keylist.getItemAt(7)] as ArrayCollection)) {
	    	initColl.addItem(item7);
	    }
	    tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
	    longshortflag.dataProvider = tempColl;
		
		//Initialize Accrual Type.
		initColl.removeAll();
		tempColl = new ArrayCollection();
        for each(var item8:Object in (mapObj[keylist.getItemAt(8)] as ArrayCollection)) {
	    	initColl.addItem(item8);
	    }
	    tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
	    accrualtype.dataProvider = tempColl;
		
		//Initialize In/Out Flag.
		initColl.removeAll();
		tempColl = new ArrayCollection();
        for each(var item9:Object in (mapObj[keylist.getItemAt(9)] as ArrayCollection)) {
	    	initColl.addItem(item9);
	    }
	    tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
	    inoutflag.dataProvider = tempColl;
		
		//Initialize Payable Receivable Flag.
		initColl.removeAll();
		tempColl = new ArrayCollection();
        for each(var item10:Object in (mapObj[keylist.getItemAt(10)] as ArrayCollection)) {
	    	initColl.addItem(item10);
	    }
	    tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
	    payablereceivableflag.dataProvider = tempColl;
		
		//Initialize Start End Flag.
		initColl.removeAll();
		tempColl = new ArrayCollection();
        for each(var item11:Object in (mapObj[keylist.getItemAt(11)] as ArrayCollection)) {
	    	initColl.addItem(item11);
	    }
	    tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
	    startendflag.dataProvider = tempColl;
		
		//Initialize PL Indicator.
		initColl.removeAll();
		tempColl = new ArrayCollection();
        for each(var item12:Object in (mapObj[keylist.getItemAt(12)] as ArrayCollection)) {
	    	initColl.addItem(item12);
	    }
	    tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
	    plindicator.dataProvider = tempColl;
		
		//Initialize Net Down Flag.
		initColl.removeAll();
		tempColl = new ArrayCollection();
        for each(var item13:Object in (mapObj[keylist.getItemAt(13)] as ArrayCollection)) {
	    	initColl.addItem(item13);
	    }
	    tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
	    netdownflag.dataProvider = tempColl;
		
		//Initialize Counter Party Type.
		initColl.removeAll();
		tempColl = new ArrayCollection();
        for each(var item14:Object in (mapObj[keylist.getItemAt(14)] as ArrayCollection)) {
	    	initColl.addItem(item14);
	    }
	    tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
	    counterpartytype.dataProvider = tempColl;
		
		//Initialize Forward Repo Flag.
		initColl.removeAll();
		tempColl = new ArrayCollection();
        for each(var item15:Object in (mapObj[keylist.getItemAt(15)] as ArrayCollection)) {
	    	initColl.addItem(item15);
	    }
	    tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
	    forwardrepoflag.dataProvider = tempColl;
		
		//Initialize Quasi Comp By.
		initColl.removeAll();
		tempColl = new ArrayCollection();
        for each(var item16:Object in (mapObj[keylist.getItemAt(16)] as ArrayCollection)) {
	    	initColl.addItem(item16);
	    }
	    tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
	    quasicompby.dataProvider = tempColl;
		
		//Initialize Reportable Flag.
		initColl.removeAll();
		tempColl = new ArrayCollection();
        for each(var item17:Object in (mapObj[keylist.getItemAt(17)] as ArrayCollection)) {
	    	initColl.addItem(item17);
	    }
	    tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
	    reportableflag.dataProvider = tempColl;
		
		//Initialize Wire Type.
		initColl.removeAll();
		tempColl = new ArrayCollection();
        for each(var item18:Object in (mapObj[keylist.getItemAt(18)] as ArrayCollection)) {
	    	initColl.addItem(item18);
	    }
	    tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
	    wiretype.dataProvider = tempColl;
		
		//Initialize Pwc Income Type.
		initColl.removeAll();
		tempColl = new ArrayCollection();
        for each(var item19:Object in (mapObj[keylist.getItemAt(19)] as ArrayCollection)) {
	    	initColl.addItem(item19);
	    }
	    tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
	    pwcincometype.dataProvider = tempColl;
    }
     
     override public function preQuery():void {
        qh.resetPageNo();
        super.getSubmitQueryHttpService().url = "gle/postingRuleQueryDispatch.action?";  
        super.getSubmitQueryHttpService().request = populateRequestParams();
	 }
		
     /**
      * This method will populate the request parameters for the
      * submitQuery call and bind the parameters with the HTTPService
      * object.
      */
     private function populateRequestParams():Object {
        var reqObj:Object = new Object();
         
        reqObj.method = "submitQuery";
        reqObj['SCREEN_KEY'] = 559; 
        reqObj.transactionType = (this.transactionType.selectedItem != null ? this.transactionType.selectedItem.value : "");
        reqObj.instrumentType = (this.securitytype.itemCombo != null ? securitytype.itemCombo.text : "");        
        reqObj.market = (this.market.itemCombo != null ? market.itemCombo.text : "");
        reqObj.accountBalanceType = (this.accountbalancetype.selectedItem != null ? this.accountbalancetype.selectedItem.value : "");        
        reqObj.principalAgentFlag = (this.principalagentflag.selectedItem != null ? this.principalagentflag.selectedItem.value : "");        
        reqObj.tradeType = (this.tradetype.selectedItem != null ? this.tradetype.selectedItem.value : "");        
        reqObj.settlementMode = (this.settlementmode.selectedItem != null ? this.settlementmode.selectedItem.value : "");        
        reqObj.actionType = (this.actiontype.selectedItem != null ? this.actiontype.selectedItem.value : "");        
        reqObj.subTradeType = (this.subtradetype.selectedItem != null ? this.subtradetype.selectedItem.value : "");        
        reqObj.longShortFlag = (this.longshortflag.selectedItem != null ? this.longshortflag.selectedItem.value : "");        
        reqObj.accrualType = (this.accrualtype.selectedItem != null ? this.accrualtype.selectedItem.value : "");        
        reqObj.inOutFlag = (this.inoutflag.selectedItem != null ? this.inoutflag.selectedItem.value : "");        
        reqObj.payableReceivableFlag = (this.payablereceivableflag.selectedItem != null ? this.payablereceivableflag.selectedItem.value : "");        
        reqObj.startEndFlag = (this.startendflag.selectedItem != null ? this.startendflag.selectedItem.value : "");        
        reqObj.plIndicator = (this.plindicator.selectedItem != null ? this.plindicator.selectedItem.value : "");        
        reqObj.netDownFlag = (this.netdownflag.selectedItem != null ? this.netdownflag.selectedItem.value : "");        
        reqObj.counterpartyType = (this.counterpartytype.selectedItem != null ? this.counterpartytype.selectedItem.value : "");
        reqObj.forwardRepoFlag = (this.forwardrepoflag.selectedItem != null ? this.forwardrepoflag.selectedItem.value : "");
        reqObj.quasiCompBy = (this.quasicompby.selectedItem != null ? this.quasicompby.selectedItem.value : "");
        reqObj.reportableFlag = (this.reportableflag.selectedItem != null ? this.reportableflag.selectedItem.value : "");
        reqObj.wireType = (this.wiretype.selectedItem != null ? this.wiretype.selectedItem.value : "");
        reqObj.pwcIncomeType = (this.pwcincometype.selectedItem != null ? this.pwcincometype.selectedItem.value : "");       
	    	         
        reqObj.rnd = Math.random() + "";
        return reqObj;
     }
    
     override public function postQueryResultHandler(mapObj:Object):void {
    	commonResult(mapObj);
     }
        
     private function commonResult(mapObj:Object):void {
    	var result:String = "";
    	if(mapObj != null) {   
    		//XenosAlert.info("mapObj : "+mapObj.toString()); 		
	    	if(mapObj["errorFlag"].toString() == "error") {
	    		//result = mapObj["errorMsg"] .toString();
	    		queryResult.removeAll();
	    		errPage.showError(mapObj["errorMsg"]);
	    	} else if(mapObj["errorFlag"].toString() == "noError") {
	    	    errPage.clearError(super.getSubmitQueryResultEvent());
	    	    //errPage.removeError();
	    	    // XenosAlert.info("I am in errPage ");
                queryResult.removeAll();
	    	    // XenosAlert.info("I am in queryResult : "+currentState);
                queryResult=mapObj["row"];
			    changeCurrentState();
		        qh.setOnResultVisibility();
		        qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
		        qh.PopulateDefaultVisibleColumns();
	    	} else {
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}    		
    	}
    	//XenosAlert.info(result);
     }   
       
      
     override public function preResetQuery():void {
		var rndNo:Number = Math.random();
		super.getResetHttpService().url = "gle/postingRuleQueryDispatch.action?method=initialExecute&&menuType=Y&rnd=" + rndNo;
     }
        
     override  public function preGenerateXls():String {
        var url:String = null;
		if(mode == "query") {		    		
			url = "gle/postingRuleQueryDispatch.action?method=generateXLS";
		}
		return url;
     }
     	
     override public function preGeneratePdf():String {
    	var url:String = null;
		if(mode == "query") {		    		
			url = "gle/postingRuleQueryDispatch.action?method=generatePDF";
		}
		return url;
     }	
            
     override public function preNext():Object {
    	var reqObj:Object = new Object();
    	reqObj.rnd = Math.random() + "";
    	reqObj.method = "doNext";
    	return reqObj;
     }
     	
     override public function prePrevious():Object {
    	var reqObj:Object = new Object();
    	reqObj.rnd = Math.random() + "";
    	reqObj.method = "doPrevious";
    	return reqObj;
     }	
          
     private function dispatchPrintEvent():void {
        this.dispatchEvent(new Event("print"));
     }
       
     private function dispatchPdfEvent():void {
        this.dispatchEvent(new Event("pdf"));
     }
       
     private function dispatchXlsEvent():void {
        this.dispatchEvent(new Event("xls"));
     }
         
     private function dispatchNextEvent():void {
        this.dispatchEvent(new Event("next"));
     }
      
     private function dispatchPrevEvent():void {
        this.dispatchEvent(new Event("prev"));
     }      
      

