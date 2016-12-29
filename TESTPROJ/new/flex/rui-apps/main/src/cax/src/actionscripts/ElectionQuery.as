
 // ActionScript file for Cax Election Query
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.RendererFectory;
 import com.nri.rui.core.containers.SummaryPopup;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.controls.XenosQuery;
 import com.nri.rui.core.formatters.CustomDateFormatter;
 import com.nri.rui.core.renderers.SelectAllItem;
 import com.nri.rui.core.renderers.SelectItem;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.DateUtils;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosStringUtils;
 
 import flash.events.MouseEvent;
 
 import mx.collections.ArrayCollection;
 import mx.controls.Alert;
 import mx.controls.dataGridClasses.DataGridColumn;
 import mx.core.UIComponent;
 import mx.events.CloseEvent;
 import mx.managers.PopUpManager;
 import mx.utils.ObjectUtil;
 import mx.utils.StringUtil;
 
 
  [Bindable]public var mode : String = "query";
  [Bindable]
  public var queryResult:ArrayCollection= new ArrayCollection();
  [Bindable]
  public var returnContextItem:ArrayCollection = new ArrayCollection();
  private var keylist:ArrayCollection = new ArrayCollection(); 
 
  private var sortFieldArray:Array =new Array();
  private var sortFieldDataSet:Array =new Array();
  private var sortFieldSelectedItem:Array =new Array();
  private var csd:CustomizeSortOrder=null;
  [Bindable]
  private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
  //For check box
  [Bindable]
  public var selectAllBind:Boolean=false;
  [Bindable]
  public var rowNoArray : Array = new Array();
  private var selectedResults:ArrayCollection=new ArrayCollection();   
  
  private var valid:Boolean = true;
  private var validZero:Boolean = true;
  private var validOther:Boolean = true;
  private var expDateAfter:Boolean = true;
  
  private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
   
  public function loadAll():void{
  	parseUrlString();
    super.setXenosQueryControl(new XenosQuery()); 
    if(this.mode == 'query'){
    	this.dispatchEvent(new Event('queryInit'));
    }
    else { 
	    this.dispatchEvent(new Event('amendInit'));
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
	        if(params != null){
	            for (var i:int = 0; i < params.length; i++) {
	                var tempA:Array = params[i].split("=");  
	                if (tempA[0] == "mode") {
	                    //XenosAlert.info("movArray param = " + tempA[1]);
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
	
	
	/**
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specific  
      * requriment. 
      */
    private function populateContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection();
        
        //passing counter party type                
        var cpTypeArray:Array = new Array(1);
        cpTypeArray[0]="INTERNAL";
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
    
        return myContextList;
    }
    
    private function changeCurrentState():void{
		currentState = "result";
	}
    
    override public function preQueryInit():void{
    	var rndNo:Number= Math.random();
  	   super.getInitHttpService().url = "cax/optCashStockDivElectionQueryDispatch.action?method=initialExecute&mode="+mode+"&rnd=" + rndNo;
  	   
  	   var reqObject:Object = new Object();
  	   reqObject.SCREEN_KEY = 10073;
  	   super.getInitHttpService().request = reqObject;         	
    } 
    override public function preAmendInit():void{
	    var rndNo:Number= Math.random();
	    super.getInitHttpService().url = "cax/optCashStockDivElectionEntryAmendQueryDispatch.action?&rnd=" + rndNo;
	    var reqObject:Object = new Object();
	  	reqObject.mode=this.mode;
	  	reqObject.SCREEN_KEY = 10072;
	  	reqObject.method="initialExecute";
	  	super.getInitHttpService().request = reqObject;     	
    }
    private function addCommonKeys():void{ 
    	keylist = new ArrayCollection();
    	keylist.addItem("eventTypeDropdownList.item");
    	keylist.addItem("electionStatusDropdownList.item");
    	
    	//Sort fields
    	keylist.addItem("sortFieldList1.item");
    	keylist.addItem("sortFieldList2.item");
    	keylist.addItem("sortFieldList3.item");
    }
    
    override public function preQueryResultInit():Object{
    	addCommonKeys();   	
    	return keylist;        	
    }
    override public function preAmendResultInit():Object{
    	addCommonKeys();   		    	
    	return keylist;        	
    }
    override public function postQueryResultInit(mapObj:Object):void{
    	commonInit(mapObj);
    	
    }
    override public function postAmendResultInit(mapObj:Object):void{
    	commonInit(mapObj);	
    }
     private function clearCommonFields():void{
     	this.conditionReferenceNo.text = XenosStringUtils.EMPTY_STR;
     	this.detailReferenceNo.text = XenosStringUtils.EMPTY_STR;
     	this.fundPopUp.fundCode.text = XenosStringUtils.EMPTY_STR;
     	this.actPopUp.accountNo.text = XenosStringUtils.EMPTY_STR;
     	this.instPopUp.instrumentId.text = XenosStringUtils.EMPTY_STR;
     	this.allotmentCcy.instrumentId.text = XenosStringUtils.EMPTY_STR;
     	this.underlyingSecurityQty.text = XenosStringUtils.EMPTY_STR;
     	
     	this.exdateFrom.text = XenosStringUtils.EMPTY_STR;
     	this.exdateTo.text = XenosStringUtils.EMPTY_STR;
     	this.recdateFrom.text = XenosStringUtils.EMPTY_STR;
     	this.recdateTo.text = XenosStringUtils.EMPTY_STR;
     	this.deadlineDateFrom.text = XenosStringUtils.EMPTY_STR;
     	this.deadlineDateTo.text = XenosStringUtils.EMPTY_STR;
     	this.expiryDateFrom.text = XenosStringUtils.EMPTY_STR;
     	this.expiryDateTo.text = XenosStringUtils.EMPTY_STR;
     	this.paymentDateFrom.text = XenosStringUtils.EMPTY_STR;
     	this.paymentDateTo.text = XenosStringUtils.EMPTY_STR;
     	this.electionDateFrom.text = XenosStringUtils.EMPTY_STR;
     	this.electionDateTo.text = XenosStringUtils.EMPTY_STR;
     	
     	this.exdateFrom.selectedDate = null;
     	this.exdateTo.selectedDate = null;
     	this.recdateFrom.selectedDate = null;
     	this.recdateTo.selectedDate = null;
     	this.deadlineDateFrom.selectedDate = null;
     	this.deadlineDateTo.selectedDate = null;
     	this.expiryDateFrom.selectedDate = null;
     	this.expiryDateTo.selectedDate = null;
     	this.paymentDateFrom.selectedDate = null;
     	this.paymentDateTo.selectedDate = null;
     	this.electionDateFrom.selectedDate = null;
     	this.electionDateTo.selectedDate = null;     	
     	
     }
    
    private function commonInit(mapObj:Object):void{
    	clearCommonFields();
        	
    	errPage.clearError(super.getInitResultEvent());
    	
    	var initcol:ArrayCollection = new ArrayCollection();
    	var tempColl: ArrayCollection = new ArrayCollection();
    	//variables to hold the default values from the server
        var sortField1Default:String = "CAX_RIGHTS_CONDITION.CONDITION_REFERENCE_NO";
        var sortField2Default:String = "CAX_RIGHTS_DETAIL.DETAIL_REFERENCE_NO";
        var sortField3Default:String = "REF_FUND.FUND_CODE";   
        var i:int = 0;
        var selIndx:int = 0;
        
    	//Event Types
        initcol.addItem({label:" ", value: " "});
        for each(var item:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
			initcol.addItem(item);
    	}
    	this.eventTypes.dataProvider = initcol;
    	this.eventTypes.selectedIndex =0;
        
        //Expiry Status
        initcol=new ArrayCollection();
        initcol.addItem({label:" ", value: " "});
        for each(var item:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
        	initcol.addItem(item);
    	}
    	this.electionStatus.dataProvider = initcol;
    	this.electionStatus.selectedIndex =0;
    	
    	// Sort Fields
    	initcol=new ArrayCollection();
    	initcol.addItem({label:" ", value: " "});
    	selIndx = 0;
    	for each(var item:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
    		initcol.addItem(item);
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
        sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx);
        
        initcol=new ArrayCollection();
    	initcol.addItem({label:" ", value: " "});
    	selIndx = 0;
    	for each(var item:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
    		initcol.addItem(item);
    	}
    	tempColl.removeAll();
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
        sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx);
	        
	    initcol=new ArrayCollection();
    	initcol.addItem({label:" ", value: " "});
    	selIndx = 0;
    	//index=0;
    	tempColl.removeAll();
    	for each(var item:Object in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
    		initcol.addItem(item);
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
        sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx);	
    		
		csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
    	csd.init();    
	    app.submitButtonInstance = submit;    
    }
    
    private function sortOrder1Update():void{
 	    csd.update(sortField1.selectedItem,0);
    }
     
    private function sortOrder2Update():void{     	
    	csd.update(sortField2.selectedItem,1);
    }
    override public function preQuery():void{
    	qh.resetPageNo();	
       // XenosAlert.info("I am in preQuery ");
        super.getSubmitQueryHttpService().url = "cax/optCashStockDivElectionQueryDispatch.action?";  
        super.getSubmitQueryHttpService().request  =populateRequestParams();
        super.getSubmitQueryHttpService().method="POST";
    }
    override public function preAmend():void{
		qh.resetPageNo();
		super.getSubmitQueryHttpService().url = "cax/optCashStockDivElectionEntryAmendQueryDispatch.action?";   
        super.getSubmitQueryHttpService().request  =populateRequestParams();  
        super.getSubmitQueryHttpService().method="POST";
      }
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	var reqObj : Object = new Object();
    	reqObj.method= "submitQuery";
    	reqObj.SCREEN_KEY = 10074;
    	
    	reqObj.conditionReferenceNo = this.conditionReferenceNo.text;
    	reqObj.eventType = (this.eventTypes.selectedItem != null ? StringUtil.trim(this.eventTypes.selectedItem.value) : ""); 
     	reqObj.detailReferenceNo = this.detailReferenceNo.text;
     	reqObj.electionStatus = (this.electionStatus.selectedItem != null ? StringUtil.trim(this.electionStatus.selectedItem.value) : "");
     	
     	reqObj.fundCode = this.fundPopUp.fundCode.text;
     	reqObj.fundAccountNo = this.actPopUp.accountNo.text;
     	reqObj.instrumentCode = this.instPopUp.instrumentId.text;
     	reqObj.allotmentCcy = this.allotmentCcy.instrumentId.text;
     	reqObj.underlyingSecurityQty = this.underlyingSecurityQty.text;
     	
     	reqObj.exDateFromStr = this.exdateFrom.text;
     	reqObj.exDateToStr = this.exdateTo.text;
     	reqObj.recordDateFromStr = this.recdateFrom.text;
     	reqObj.recordDateToStr = this.recdateTo.text;
     	reqObj.deadlineDateFromStr = this.deadlineDateFrom.text;
     	reqObj.deadlineDateToStr = this.deadlineDateTo.text;
     	reqObj.expiryDateFromStr = this.expiryDateFrom.text;
     	reqObj.expiryDateToStr = this.expiryDateTo.text;
     	reqObj.paymentDateFromStr = this.paymentDateFrom.text;
     	reqObj.paymentDateToStr = this.paymentDateTo.text;
     	reqObj.electionDateFromStr = this.electionDateFrom.text;
     	reqObj.electionDateToStr = this.electionDateTo.text;
    	
    	reqObj.sortField1 = (this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : "");
        reqObj.sortField2 = (this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : "");
        reqObj.sortField3 = (this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : "");
        reqObj.rnd = Math.random() + "";
    	return reqObj;
    }
    
    override public function postQueryResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    	if(queryResult.length == 1){
    		displayDetailView(queryResult[0].rightsConditionPk);
    	}
    	app.submitButtonInstance = null;
    }
    override public function postAmendResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    	setIfAllSelected();
    	app.submitButtonInstance = entrysubmit;
    }
    private function commonResult(mapObj:Object):void{
    	
    	var result:String = "";
    	if(mapObj!=null){   
    		queryResult.removeAll(); 		
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		//result = mapObj["errorMsg"] .toString();
	    		//queryResult.removeAll();
	    		errPage.showError(mapObj["errorMsg"]);
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    	    errPage.clearError(super.getSubmitQueryResultEvent());
	    	  
                //queryResult.removeAll();
	    	  
                queryResult=mapObj["row"];
                resetSelection(queryResult);
                
			    changeCurrentState();
			    //app.submitButtonInstance = entrysubmit;
                
	            qh.setOnResultVisibility();
	            qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
	            qh.PopulateDefaultVisibleColumns();
	    		
	    	}else{
	    		errPage.removeError();
	    		//queryResult.removeAll();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cax.data.not.found'));
	    	}    		
    	}
    	
    }
    
    override public function preResetQuery():void{
	    var rndNo:Number= Math.random();
	  	super.getResetHttpService().url = "cax/optCashStockDivElectionQueryDispatch.action?method=resetQuery&mode=query&menuType=Y&rnd=" + rndNo;
	  	var reqObject:Object = new Object();
		reqObject.SCREEN_KEY = 10073;
		super.getInitHttpService().request = reqObject;          	
    }
    override public function preResetAmend():void{
	   var rndNo:Number= Math.random();
	   super.getResetHttpService().url = "cax/optCashStockDivElectionEntryAmendQueryDispatch.action?&rnd=" + rndNo;
	   var reqObject:Object = new Object();
	   reqObject.actionType=this.mode;
	   reqObject.method="resetQuery";
	   reqObject.SCREEN_KEY = 10072;
	  super.getResetHttpService().request = reqObject;     	
    }
    override    public function preNext():Object{
   		var reqObj : Object = new Object();
   		reqObj.method = "doNext";
   		return reqObj;
  	}	
  	override public function prePrevious():Object{
   
   	 	var reqObj : Object = new Object();
   	 	reqObj.method = "doPrevious";
   	 	return reqObj;
  	}	
    
    override    public function preGenerateXls():String{
	 	var url : String =null;
    	
    	if(this.mode == "query")		    		
    		url = "cax/optCashStockDivElectionQueryDispatch.action?method=generateXLS";
    	else
    		url = "cax/optCashStockDivElectionEntryAmendQueryDispatch.action?method=generateXLS";
    	
    	return url;
     }
     
     override public function preGeneratePdf():String{
        var url : String =null;
        
        if(this.mode == "query")
    		url = "cax/optCashStockDivElectionQueryDispatch.action?method=generatePDF";
    	else
    		url = "cax/optCashStockDivElectionEntryAmendQueryDispatch.action?method=generatePDF";
    	return url;
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
		//Add a object
		
		var dg :DataGridColumn = new DataGridColumn();
		dg.dataField="selected";
		dg.editable = false;
		dg.resizable = false;
		dg.draggable = false;
		dg.headerText = "";
		dg.width = 40;
		dg.sortable = false;
		dg.itemRenderer = new RendererFectory(SelectItem);
		dg.headerRenderer = new RendererFectory(SelectAllItem);
		var cols :Array = resultSummary.columns;
		/* var dg1 : DataGridColumn = cols[12] as DataGridColumn;
		dg1.itemRenderer = new ClassFactory(TextInput); */
		
		cols.unshift(dg);
		resultSummary.columns = cols;
		
	}
	
	public function selectAllRecords(flag:Boolean): void {
      var i:Number = 0;
      selectedResults.removeAll();
      for(i=0; i<queryResult.length; i++){
            var obj:XML=queryResult[i];
            obj.selected = flag;
            queryResult[i]=obj;
          //  addOrRemove(queryResult[i]);
      }

     // rowNoArray= selectedResults.toArray();
    }
    
    /* public function addOrRemove(item:Object):void {
    	var i:Number;
        var tempArray:Array = new Array();
        if(item.selected == true){ 
        	var obj:Object=new Object();
        	obj.rowNumInt=item.rowNumInt;
            selectedResults.addItem(obj);
           
    	}else { //needs to pop
    		tempArray=selectedResults.toArray();
    	    selectedResults.removeAll();
    		for(i=0; i<tempArray.length; i++){
    			if(tempArray[i].rowNumInt != item.rowNumInt)
    			    selectedResults.addItem(tempArray[i]);
    			   
    		}
    	}   		
    } */
    
	/**
	 * Check one by one selection.
	 */
	public function checkSelectToModify(item:Object):void {
		
		/* var tempArray:Array = new Array();
		if(item.selected == true){ // needs to insert   
			var obj:Object = new Object();
			obj.rowNumInt = item.rowNumInt;
			selectedResults.addItem(obj);
		}else {
			tempArray=selectedResults.toArray();
    	    selectedResults.removeAll();
    		for(var i:int=0; i<tempArray.length; i++){
    			if(tempArray[i].rowNumInt != item.rowNumInt){
    			    selectedResults.addItem(tempArray[i]);
    			}
    		}        		
		}
		rowNoArray = selectedResults.toArray(); */
		setIfAllSelected();
	}
	
	private function resetSelection(queryResult:ArrayCollection):void{
    	for(var i:int=0;i<queryResult.length;i++){
    		queryResult[i].selected = false;
    		queryResult[i].rowNumInt= i;
    		//trace("cashElectionStr : "+queryResult[i].cashElectionStr+" cashElectionDisp : " +queryResult[i].cashElectionDisp);
    		var cashDisp:String = queryResult[i].cashElectionDisp;
    		var stockDisp:String = queryResult[i].stockElectionDisp;
    		queryResult[i].cashElectionStr = cashDisp;
    		queryResult[i].stockElectionStr = stockDisp;
    		//trace("After cashElectionStr : "+queryResult[i].cashElectionStr+" cashElectionDisp : " +cashDisp+"from row : "+queryResult[i].cashElectionDisp);
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
    	if(queryResult == null)
    		return false;
    		
    	for(i=0; i<queryResult.length; i++){
    		if(queryResult[i].selected == false) {
    			
        		return false;
        	}
    	}
    	if(i == queryResult.length) {
    		return true;
         }else {			
    		return false;        		
    	}
    }
    
    private function resetElectionEntryAmendForm(event:MouseEvent, mode:String):void{
    	var noOfRows:int = queryResult.length;
    	for(var i:int=0;i<noOfRows;i++){
    		var rowObj:XML = queryResult[i];
    		var modeOfQuery : String = rowObj.modeOfQuery;
    		if(modeOfQuery == "entry") {
    			rowObj.cashElectionStr = "";
    			rowObj.stockElectionStr = "";
    		}
    		if(modeOfQuery == "amend") {
    			
    			var cashDisp:String = rowObj.cashElectionDisp;
    			var stockDisp:String = rowObj.stockElectionDisp;
    			rowObj.cashElectionStr = cashDisp;
    			rowObj.stockElectionStr = stockDisp;
    			
    		}
    		if(mode == "entryAmend") {
    			rowObj.selected = false;
    		}
    	}
    	setIfAllSelected();
    	(resultSummary.dataProvider as ArrayCollection).refresh();
    }
    
    private function getAllSelectedRows():Array{
    	var tempArray:ArrayCollection = new ArrayCollection();
    	
    	for(var i:int=0;i<queryResult.length;i++){
    		if(queryResult[i].selected == true){
    			tempArray.addItem(i);
    			var cashElectionStr : String = queryResult[i].cashElectionStr;
    			var stockElectionStr : String = queryResult[i].stockElectionStr;
    			if(XenosStringUtils.isBlank(stockElectionStr) || XenosStringUtils.isBlank(cashElectionStr)){
    				valid = false;
    				break;
    			}
    			var ownershipQuantityStr: String = queryResult[i].ownershipQuantityStr;
    			var locationQuantityStr: String = queryResult[i].locationQuantityStr;
    			
    			var cashQty: String  = removeCommaFromString(cashElectionStr);
				var stockQty : String = removeCommaFromString(stockElectionStr);

				var ownQty : String = removeCommaFromString(ownershipQuantityStr);
				var locQty : String = removeCommaFromString(locationQuantityStr);
				
				if (cashQty != "" && stockQty == "") {
					stockQty = 0+"";
				}

				if (stockQty != "" && cashQty == "") {
					cashQty = 0+"";
				}
				
				if(parseFloat(cashQty) == 0 && parseFloat(stockQty) == 0) {
					validZero = false;
					break;
				}
				
				var totalQty:Number = parseFloat(cashQty) + parseFloat(stockQty);
				/* trace("total Qty : "+totalQty+" casshQty : "+cashQty+" stockQty :"+stockQty);
				trace(parseFloat(cashQty)+" : "+parseFloat(stockQty));
				trace("ownQty : "+ownQty+" : "+parseFloat(ownQty)); */
				if( (totalQty  - parseFloat(ownQty)) != 0 ) {
					validOther = false;
					//validationMsg = "Total of Cash and Stock Election Quantity should be equal to ownership quantity";
					break;
				}
				
				var caxApp:String = app.caxAppDate;
				var expirydate : String = queryResult[i].expiryDateStr;
				var dateformat:CustomDateFormatter =new CustomDateFormatter();
				var caxAppDateObj:Date = null;
            
	            if(DateUtils.isValidDate(caxApp)){
	                caxAppDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(caxApp));
	            }
	            var expiryDateObj:Date = null;
            
	            if(DateUtils.isValidDate(expirydate)){
	                expiryDateObj = dateformat.toDate(CustomDateFormatter.customizedInputDateString(expirydate));
	            }
	            
	            var comDate:int=ObjectUtil.dateCompare(caxAppDateObj,expiryDateObj);
	            if(comDate == 1){
	            	expDateAfter = false;
	            }
    		}
    	}
    	return tempArray.toArray();
    }
    private function removeCommaFromString(string1: String):String {
		var string:String = string1;
		var len:int = string.length;
		var newString :String = "";
		for(var index:int = 0; index < len; index++ ){
			if(string.charAt(index)!= ',')
			{
				newString = newString + string.charAt(index);
			}
		}
		return newString;
	}

    private function showEntryAmendConfirmModule(event:MouseEvent):void{
    	
    	rowNoArray = getAllSelectedRows();
    	
    	if(rowNoArray.length < 1){
    		XenosAlert.error("Select at least one record.");
    		return;
    	}
    	if(!valid){
    		XenosAlert.error("Valid Cash or Stock Quantity should be entered for the selected records");
    		valid = true;
    		return;
    	}
    	if(!validZero){
    		XenosAlert.error("Both Cash and Stock Quantity can not be zero\ntogether or one null and other 0");
    		validZero = true;
    		return;
    	}
    	if(!validOther){
    		XenosAlert.error("Total of Cash and Stock Election Quantity should be equal to ownership quantity");
    		validOther = true;
    		return;
    	}
    	if(!expDateAfter){
    		XenosAlert.confirm("Expiry Date has been passed. Do you want to continue?",handleCloseEvent);
    		expDateAfter = true;
    	}else{
    		openEntryAmendPopUp();
	    	/* var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
			sPopup.title = "Election  Entry/Amend";
			sPopup.width = 700;
			sPopup.height = 400;
			PopUpManager.centerPopUp(sPopup);
			sPopup.owner = this;
			sPopup.dataObj = queryResult;
			sPopup.moduleUrl = "assets/appl/cax/ElectionEntryAmend.swf"+Globals.QS_SIGN+"mode"+Globals.EQUALS_SIGN+mode+Globals.AND_SIGN+"selectedItems"+Globals.EQUALS_SIGN+rowNoArray; */
    	}
    }
    private function handleCloseEvent(event:CloseEvent):void{
    	if(event.detail == mx.controls.Alert.YES){
	    	openEntryAmendPopUp();
    	}else{
    		return;
    	}
    	
    }
    private function openEntryAmendPopUp():void{
    	var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
			sPopup.title = this.parentApplication.xResourceManager.getKeyValue('cax.election.entry.amend');
			sPopup.width = 700;
			sPopup.height = 400;
			PopUpManager.centerPopUp(sPopup);
			sPopup.owner = this;
			sPopup.dataObj = queryResult;
			sPopup.moduleUrl = "assets/appl/cax/ElectionEntryAmend.swf"+Globals.QS_SIGN+"mode"+Globals.EQUALS_SIGN+mode+Globals.AND_SIGN+"selectedItems"+Globals.EQUALS_SIGN+rowNoArray;
    }
    private function displayDetailView(rightsConditionPk:String):void {
	    	
			var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
			
			sPopup.title = this.parentApplication.xResourceManager.getKeyValue('cax.corporateaction.event.view');
			sPopup.width = parentApplication.width - 125;    		
			sPopup.height = 500;
			PopUpManager.centerPopUp(sPopup);		
			sPopup.moduleUrl = Globals.RIGHTS_CONITION_QUERY_DETAILS_SWF + Globals.QS_SIGN + Globals.RIGHTS_CONDITION_PK + Globals.EQUALS_SIGN+rightsConditionPk;
				
	    }