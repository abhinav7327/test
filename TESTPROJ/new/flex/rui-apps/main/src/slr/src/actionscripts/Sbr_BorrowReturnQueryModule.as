// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.RendererFectory;
import com.nri.rui.core.containers.SummaryPopup;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;
import mx.utils.StringUtil;

	[Bindable] private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
	[Bindable] private var queryResult:ArrayCollection= new ArrayCollection();
	[Bindable] private var mode : String = "QUERY";
	[Bindable] private var tradeTypeList:ArrayCollection = null;
	[Bindable] private var statusList:ArrayCollection = null;
	[Bindable] private var sortFieldList1:ArrayCollection = null;
	[Bindable] private var sortFieldList2:ArrayCollection = null;
	[Bindable] private var sortFieldList3:ArrayCollection = null;
	[Bindable] private var sortFieldList4:ArrayCollection = null;
	[Bindable] private var sortFieldList5:ArrayCollection = null; 
	public var selectAllBind:Boolean=false;
	[Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
	
	
	private var keylist:ArrayCollection = new ArrayCollection();
	private var sortFieldArray:Array = new Array();
	private var sortFieldDataSet:Array = new Array();
	private var sortFieldSelectedItem:Array = new Array();
	private var csd:CustomizeSortOrder = null;
	 private var selectedResults:ArrayCollection=new ArrayCollection(); 
    
  	/**
  	 * Set Item Renderer to the Document Id field of Table
  	 */
	private function changeCurrentState():void {
	 	currentState = "result";
	}
			 
 	public function loadAll():void {
 		parseUrlString();
 		super.setXenosQueryControl(new XenosQuery());
 		
 		if(mode=="QUERY") {
 			this.dispatchEvent(new Event('queryInit'));
 		}else if(this.mode == 'AMEND'){
       	   	 this.dispatchEvent(new Event('amendInit'));
       	   	 this.status.visible = false;
       	   	 this.status.includeInLayout = false;
       	   	 this.statusLbl.visible = false;
       	   	 this.statusLbl.includeInLayout = false;
       	   	 addColumn();
       	   } else { 
       	     this.dispatchEvent(new Event('cancelInit'));
       	     this.status.visible = false;
       	   	 this.status.includeInLayout = false;
       	   	 this.statusLbl.visible = false;
       	   	 this.statusLbl.includeInLayout = false;
       	   	 addColumn();
       	   }
   	}
   	
   	/**
   	 * Extracts the parameters and set them to some variables for 
   	 * query criteria from the Module Loader Info.
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
	        	mode = "QUERY";
	        }                 
	    } catch (e:Error) {
	        trace(e);
	    }      
	}
	     
	override public function preQueryInit():void {
		super.getInitHttpService().url = "slr/stockBorrowReturnQueryDispatch.action?rnd="+Math.random();            
      	var req : Object = new Object();
        req.SCREEN_KEY = 11143;
        req.method="initialExecute";
        super.getInitHttpService().request = req;
	}
	
	 override public function preAmendInit():void{
		        var rndNo:Number= Math.random();
		        super.getInitHttpService().url = "slr/stockBorrowReturnAmendQueryDispatch.action?&rnd=" + rndNo;
		        var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="initialExecute";
		  		 reqObject.SCREEN_KEY = 11153; 
		  		super.getInitHttpService().request = reqObject;     	
        }
        
        override public function preCancelInit():void{
		        var rndNo:Number= Math.random();
		        super.getInitHttpService().url = "slr/stockBorrowReturnCancelQueryDispatch.action?&rnd=" + rndNo;
		        var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="initialExecute";
		  		reqObject.SCREEN_KEY = 11154; 
		  		super.getInitHttpService().request = reqObject;     	
        }
	
	override public function preResetQuery():void {
		super.getResetHttpService().url = "slr/stockBorrowReturnQueryDispatch.action?rnd="+Math.random();
        var reqObject:Object = new Object();
        reqObject.method="resetQuery";
        reqObject.SCREEN_KEY = 11143;
        super.getResetHttpService().request = reqObject;
	}
	
	override public function preResetAmend():void{
		        var rndNo:Number= Math.random();
		        super.getResetHttpService().url = "slr/stockBorrowReturnAmendQueryDispatch.action?&rnd=" + rndNo;
		        var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="resetQuery";
		  		 reqObject.SCREEN_KEY = 11153; 
		  		super.getResetHttpService().request = reqObject;     	
        }
        
        override public function preResetCancel():void{
		        var rndNo:Number= Math.random();
		        super.getResetHttpService().url = "slr/stockBorrowReturnCancelQueryDispatch.action?&rnd=" + rndNo;
		        var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="resetQuery";
		  		reqObject.SCREEN_KEY = 11154; 
		  		super.getResetHttpService().request = reqObject;     	
        }
        
    override public function preQuery():void {
    	qh.resetPageNo();
    	super.getSubmitQueryHttpService().url = "slr/stockBorrowReturnQueryDispatch.action?rnd="+Math.random()
    	super.getSubmitQueryHttpService().request = populateRequestParams();
    	super.getSubmitQueryHttpService().method = "POST";
    }
    
    override public function preAmend():void{
            qh.resetPageNo();	
            super.getSubmitQueryHttpService().url = "slr/stockBorrowReturnAmendQueryDispatch.action?rnd="+Math.random()  
            super.getSubmitQueryHttpService().request = populateRequestParams();  
           
		}
		
		override public function preCancel():void{
            qh.resetPageNo();	
            super.getSubmitQueryHttpService().url = "slr/stockBorrowReturnCancelQueryDispatch.action?rnd="+Math.random()  
            super.getSubmitQueryHttpService().request = populateRequestParams();  
           
		}
		
	/**
	 * This method will populate the request parameters for the 
	 * submitQuery call and bind the parameters with the HTTPService object.
	 */
	private function populateRequestParams():Object {
	   	var reqObj : Object = new Object();
		
		reqObj.method= "submitQuery";
		reqObj.SCREEN_KEY = 11144;
		
		reqObj.fundCode = this.fundPopUp.fundCode.text;
		reqObj.referenceNo = this.referenceNo.text;
		reqObj.fundAccountNo = this.fundactPopUp.accountNo.text;
		reqObj.tradeTypePk =  this.tradeType.selectedItem != null ?  this.tradeType.selectedItem.value : "";
		reqObj.tradeDateFrom = this.trddtFrom.text;
		reqObj.tradeDateTo = this.trddtTo.text;
		reqObj.valueDateFrom = this.vddtFrom.text;
		reqObj.valueDateTo = this.vddtTo.text;
		reqObj.securityCode = this.securityCode.instrumentId.text;
		if(this.mode == 'QUERY') {
     		reqObj.status =  this.status.selectedItem != null ?  this.status.selectedItem.value : "";
		} else if(this.mode == 'AMEND') {
			reqObj.SCREEN_KEY = 11155;
			reqObj.status = "NORMAL";
		} else if(this.mode == 'CANCEL') {
			reqObj.SCREEN_KEY = 11156;
			reqObj.status = "NORMAL";
		}
		reqObj.sortField1 = StringUtil.trim(this.sortField1.selectedItem.value);
		reqObj.sortField2 = StringUtil.trim(this.sortField2.selectedItem.value);
		reqObj.sortField3 = StringUtil.trim(this.sortField3.selectedItem.value);
		reqObj.sortField4 = StringUtil.trim(this.sortField4.selectedItem.value);
		reqObj.sortField5 = StringUtil.trim(this.sortField5.selectedItem.value);
		
		return reqObj;
	}
	
	
	private function addCommonKeys():void {  
		keylist = new ArrayCollection();  
	  	keylist.addItem("tradeTypeList.item");
	  	keylist.addItem("statusList.item");
	  	keylist.addItem("sortFieldList.item");
	}
        
	override public function preQueryResultInit():Object {
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
	
	override public function postQueryResultInit(mapObj:Object):void {
		commonInit(mapObj);
	}
	
	  override public function postAmendResultInit(mapObj:Object):void{
        	commonInit(mapObj);	
        	
        }
        
         override public function postCancelResultInit(mapObj:Object):void{
        	commonInit(mapObj);	
        	
        }
	
	private function commonInit(mapObj:Object):void {
		app.submitButtonInstance = submit;
		
		this.referenceNo.text = "";
		this.fundPopUp.fundCode.text = "";
		this.tradeType.selectedIndex = 0;
		this.fundactPopUp.accountNo.text = "";
		this.trddtFrom.text = "";
		this.trddtTo.text = "";
		this.vddtFrom.text = "";
		this.vddtTo.text = "";
		this.securityCode.instrumentId.text = "";
		this.status.selectedIndex = 0;
		this.sortField1.selectedIndex = 0;
		this.sortField2.selectedIndex = 0;
		this.sortField3.selectedIndex = 0;
		this.sortField4.selectedIndex = 0;
		this.sortField5.selectedIndex = 0;
		fundPopUp.fundCode.setFocus();
		
		//Populate Trade Type Combo Box
		tradeTypeList = new ArrayCollection();
		tradeTypeList.addItem({label: " " , value : " "});
		
		for each(var obj:Object in mapObj["tradeTypeList.item"] as ArrayCollection) {
			tradeTypeList.addItem(obj);
		}
		tradeTypeList.refresh();
		
		//Populate Status Combo Box
		statusList = new ArrayCollection();
		statusList.addItem({label: " " , value : " "});
		
		for each(var obj1:Object in mapObj["statusList.item"] as ArrayCollection) { 
			statusList.addItem(obj1);
		}
		statusList.refresh();
		
		//Populate Sort Field Combo Box
		sortFieldList1 = new ArrayCollection();
		sortFieldList1.addItem({label: " " , value : " "});
		
		sortFieldList2 = new ArrayCollection();
		sortFieldList2.addItem({label: " " , value : " "});
		
		sortFieldList3 = new ArrayCollection();
		sortFieldList3.addItem({label: " " , value : " "});
		
		sortFieldList4 = new ArrayCollection();
		sortFieldList4.addItem({label: " " , value : " "});
		
		sortFieldList5 = new ArrayCollection();
		sortFieldList5.addItem({label: " " , value : " "});

		for each(var obj4:Object in mapObj["sortFieldList.item"] as ArrayCollection) {
			sortFieldList1.addItem(obj4);
			sortFieldList2.addItem(obj4);
			sortFieldList3.addItem(obj4);
			sortFieldList4.addItem(obj4);
			sortFieldList5.addItem(obj4);
		}
	
    	//For Sort Field 1 Combo
    	sortFieldArray[0] = sortField1;
    	sortFieldDataSet[0]= sortFieldList1;
    	
    	//Set the default value object
    	sortFieldSelectedItem[0] = sortFieldList1.getItemAt(1);
    	
    	//For Sort Field 2 Combo
    	sortFieldArray[1] = sortField2;
    	sortFieldDataSet[1] = sortFieldList2;
    	
    	//Set the default value object
    	sortFieldSelectedItem[1] = sortFieldList2.getItemAt(2);
    	
    	//For Sort Field 3 Combo
    	sortFieldArray[2] = sortField3;
    	sortFieldDataSet[2] = sortFieldList3;
    	
    	//Set the default value object
    	sortFieldSelectedItem[2] = sortFieldList3.getItemAt(3);
    	
    	//For Sort Field 4 Combo
    	sortFieldArray[3] = sortField4;
    	sortFieldDataSet[3] = sortFieldList4;
    	
    	//Set the default value object
		sortFieldSelectedItem[3] = sortFieldList4.getItemAt(4);
		
    	//For Sort Field 5 Combo
    	sortFieldArray[4] = sortField5;
    	sortFieldDataSet[4] = sortFieldList5;
    	
    	//Set the default value object
    	sortFieldSelectedItem[4] = sortFieldList5.getItemAt(5);
    	
    	csd = new CustomizeSortOrder(sortFieldArray, sortFieldDataSet, sortFieldSelectedItem);
    	csd.init();
    	errPage.clearError(super.getInitResultEvent());
    }
    
    private function sortOrder1Update():void {
    	csd.update(sortField1.selectedItem, 0);
    }
    
    private function sortOrder2Update():void {
    	csd.update(sortField2.selectedItem, 1);
	}
	
	private function sortOrder3Update():void{
		csd.update(sortField3.selectedItem, 2);
	}
	
	private function sortOrder4Update():void{
		csd.update(sortField4.selectedItem, 3);
	}
	
	private function sortOrder5Update():void{
		csd.update(sortField5.selectedItem, 4);
	}
	
	override public function postQueryResultHandler(mapObj:Object):void {
		commonResult(mapObj);
	}
	
	 override public function postAmendResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    }
    
     override public function postCancelResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    }
	
	private function commonResult(mapObj:Object):void {
		
		var result:String = "";
		if(mapObj != null) {
			
			if(mapObj["errorFlag"].toString() == "error") {
				queryResult.removeAll();
	    		errPage.showError(mapObj["errorMsg"]);
	    	} else if(mapObj["errorFlag"].toString() == "noError") {
	    		errPage.clearError(super.getSubmitQueryResultEvent());
	    		//errPage.removeError();
	    		
	    		queryResult.removeAll();
	    		
	    		queryResult = mapObj["row"];
	    		resetSellection(queryResult);
	    		changeCurrentState();
	    		qh.setOnResultVisibility();
	    		qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,
	    		                         (mapObj["nextTraversable"] == "true")?true:false);
	    		qh.PopulateDefaultVisibleColumns();
	    		queryResult.refresh();
	    		
	    	} else {
	    		errPage.removeError();
	    		queryResult.removeAll();
	    		queryResult.refresh();
	    		setIfAllSelected();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}
	    }
	}
 
 	/**
	 * Method to prepare the context for Fund Account popup 
	 */
	private function populateFundAccountContext():ArrayCollection {
		//pass the context data to the popup
		var myContextList:ArrayCollection = new ArrayCollection(); 
	  
		//passing counter party type                
		var cpTypeArray:Array = new Array(1);
	    cpTypeArray[0]="INTERNAL";
		myContextList.addItem(new HiddenObject("invCpTypeContext",cpTypeArray));
	   
		//passing longShortFlag
	   	var longShortFlagArray:Array = new Array(1);
	    longShortFlagArray[0]="S";
	  	myContextList.addItem(new HiddenObject("longShortFlagContext",longShortFlagArray));
	
		//passing account status                
		var actStatusArray:Array = new Array(1);
		actStatusArray[0]="OPEN";
		myContextList.addItem(new HiddenObject("actStatusContext",actStatusArray));
		
		return myContextList;
	}

	override public function preGenerateXls():String {
		var url : String = "slr/stockBorrowReturnQueryDispatch.action?method=generateXLS";
		return url;
	}
	
	override public function preGeneratePdf():String {
		var url : String ="slr/stockBorrowReturnQueryDispatch.action?method=generatePDF";
		return url;
	}
	
	override public function preNext():Object {
		var reqObj : Object = new Object();
		reqObj.method = "doNext";
		return reqObj;
	}
	
	override public function prePrevious():Object {
		var reqObj : Object = new Object();
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
		
		 private function showCancelConfirmModule():void{
    	var parentApp :UIComponent = UIComponent(this.parentApplication);
    	var selectedTradePks:Array = getSelectedPks();
    	if(selectedTradePks.length < 1){
	    		XenosAlert.error("Select at least one trade to Cancel");
	    		return;
    		}
    	var sPopup : SummaryPopup;	
		sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
		sPopup.title = this.parentApplication.xResourceManager.getKeyValue('slr.sbr.borrowreturn.label.tradeCancel');
		sPopup.owner = this;
		sPopup.width = 800;
    		sPopup.height = 330;
			PopUpManager.centerPopUp(sPopup);
			sPopup.owner = this;
			sPopup.addEventListener(CloseEvent.CLOSE,closeHandler);
			sPopup.dataObj = queryResult;
			sPopup.moduleUrl = "assets/appl/slr/Sbr_BorrowReturnEntryModule.swf"+Globals.QS_SIGN+"mode"+Globals.EQUALS_SIGN+mode+Globals.AND_SIGN+"selectedItems"+Globals.EQUALS_SIGN+selectedTradePks;
    	} 
    	
    	public function closeHandler(e:CloseEvent):void
            {
            	this.dispatchEvent(new Event("cancelSubmit"));	 
            }
    	
    	 private function getSelectedPks():Array{
    	var tempArray:ArrayCollection = new ArrayCollection();
    	for(var i:int=0;i<queryResult.length;i++){
    		if(queryResult[i].selected == true){
    			tempArray.addItem(queryResult[i].tradePk);
    		}
    		
    	}
    	return tempArray.toArray();
    } 
    
    public function checkSelectToModify(item:Object):void {
    	setIfAllSelected();
    	resultSummary.invalidateDisplayList();
    	resultSummary.validateNow();
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
    	if(i == queryResult.length && i != 0) {
    		return true;
         }else {
    		return false;
    	}
    }
    
    // This as file contains code specific to the Check Box Selections.    
    
    public function selectAllRecords(flag:Boolean): void {
    	var i:Number = 0;
    	selectedResults.removeAll();
    	for(i=0; i<queryResult.length; i++){
    		var obj:XML=queryResult[i];
            obj.selected = flag;
            queryResult[i]=obj;
    	}
    }
    
    private function resetSellection(queryResult:ArrayCollection):void{
    	for(var i:int=0;i<queryResult.length;i++){
    		queryResult[i].selected = false;
    	}
    }
