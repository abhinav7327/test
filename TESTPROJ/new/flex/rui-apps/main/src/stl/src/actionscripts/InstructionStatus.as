// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;

import com.nri.rui.stl.validators.InxStatusQueryValidator;


import mx.collections.ArrayCollection;
import mx.controls.DataGrid;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.DataGridEvent;

import mx.utils.StringUtil;
import com.nri.rui.stl.validators.InxStatusQueryValidator;

import mx.utils.StringUtil;

			
    [Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]private var queryResult:ArrayCollection = new ArrayCollection();
    private var keylist:ArrayCollection = new ArrayCollection(); 
    private var sortUtil: ProcessResultUtil = new ProcessResultUtil();
    private var csd:CustomizeSortOrder = null;
	[Bindable]private var mode : String = "query";
    private var sortFieldArray:Array = new Array();
    private var sortFieldDataSet:Array = new Array();
    private var sortFieldSelectedItem:Array = new Array();
    public var menuHit:Boolean = true;
    public var additionalCriteria:Boolean = false;
	  
	/**
 	*  datagrid header release event handler to handle datagridcolumn sorting
 	*/
	public function dataGrid_headerRelease(evt:DataGridEvent):void {				
		//sortUtil.clickedColumn=evt.dataField;
		var dg:DataGrid = DataGrid(evt.currentTarget);
        sortUtil.clickedColumn = dg.columns[evt.columnIndex];		
	}
	
	private function changeCurrentState():void{
        currentState = "result";
	}
			 
    public function loadAll():void {
    	menuHit = true;
    	qh.resultHeader.text = '';
        super.setXenosQueryControl(new XenosQuery());
        this.dispatchEvent(new Event('queryInit'));
        this.fundCode.setFocus();
        changeCurrentState();
    }
    
    override public function preQueryInit():void {
	    var rndNo:Number= Math.random();
	    var reqObject:Object = new Object();
	    reqObject.SCREEN_KEY = 11187;
        super.getInitHttpService().request = reqObject;
	  	super.getInitHttpService().url = "stl/instructionStatusDispatch.action?method=initialExecute&&mode=query&&rnd=" + rndNo;        	
    }
            
    private function addCommonKeys():void{  
    	keylist = new ArrayCollection();      	
    	keylist.addItem("officeIdList.officeId");
    	keylist.addItem("dataSourceList.item");
        keylist.addItem("sortFields.item");
        keylist.addItem("tradeDateFrom");
        keylist.addItem("tradeDateTo");
        keylist.addItem("transmissionDate");
        keylist.addItem("functionList.item");
        keylist.addItem("mtTypeList.item");
        keylist.addItem("fundCategoryList.item");
        
    }
    
    override public function preQueryResultInit():Object{
    	addCommonKeys();   	
    	return keylist;        	
    }
    
    private function commonInit(mapObj:Object):void{   	
		errPage.clearError(super.getInitResultEvent());
		this.queryResult.removeAll();
        
        var selIndx:int = 0;
        var i:int = 0;
        var tempColl:ArrayCollection = new ArrayCollection();
        
        var sortField1Default:String = "fund_code";
        var sortField2Default:String = "fund_account_no";
        //office id
        var initcol:ArrayCollection = new ArrayCollection();
        initcol.addItem({label:" ", value: " "});
        for each(var itemTran:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)) {
    		initcol.addItem(itemTran);
    	}
    	office.dataProvider  = initcol;
        //data source
        var initcol1:ArrayCollection = new ArrayCollection();
        initcol1.addItem({label:" ", value: " "});
        for each(itemTran in (mapObj[keylist.getItemAt(1)] as ArrayCollection)) {
    		initcol1.addItem(itemTran);
    	}
    	dataSource.dataProvider  = initcol1;
        //Short order
        var arrCollSort:ArrayCollection = new ArrayCollection();
        for each(var itemSort:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)) {
    		arrCollSort.addItem(itemSort);
    	}
    	//msg function
    	var initcol2:ArrayCollection = new ArrayCollection();
        initcol2.addItem({label:" ", value: " "});
        for each(itemTran in (mapObj[keylist.getItemAt(6)] as ArrayCollection)) {
    		initcol2.addItem(itemTran);
    	}
    	msgFunc.dataProvider  = initcol2;
    	//MT Type
    	var initcol3:ArrayCollection = new ArrayCollection();
        initcol3.addItem({label:" ", value: " "});
        for each(itemTran in (mapObj[keylist.getItemAt(7)] as ArrayCollection)) {
    		initcol3.addItem(itemTran);
    	}
    	mtType.dataProvider  = initcol3;
        //Fund Category
    	var initcol4:ArrayCollection = new ArrayCollection();
    	initcol4.addItem({label:" ", value: " "});
       for each(itemTran in (mapObj[keylist.getItemAt(8)] as ArrayCollection)) {
    		initcol4.addItem(itemTran);
    	}
        fundCategory.dataProvider  = initcol4;
    	
    	this.tradedateFrom.text = mapObj[keylist.getItemAt(3)];
    	this.tradedateTo.text = mapObj[keylist.getItemAt(4)];
    	this.transmissionDate.text = mapObj[keylist.getItemAt(5)];
    	
    	/**** For SortField1 ****/
    	tempColl = new ArrayCollection();
    	tempColl.addItem({label:" ", value: " "});
    	for(i=0; i<arrCollSort.length; ++i) {
    		tempColl.addItem(arrCollSort[i]);
    	}
    	sortFieldArray[0] = sortField1;
        sortFieldDataSet[0] = tempColl;
        sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx + 1);
        
        
        /**** For SortField2 ****/
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
    	for(i=0; i<arrCollSort.length; ++i) {
    		tempColl.addItem(arrCollSort[i]);
    		if(XenosStringUtils.equals((arrCollSort[i].value),sortField2Default)){                    
            	selIndx = i;
            }
    	}
        sortFieldArray[1] = sortField2;
        sortFieldDataSet[1] = tempColl;
        sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx + 1);
            	    	
        csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
        csd.init();
    }
    
    private function sortOrder1Update():void {
		csd.update(sortField1.selectedItem,0);
	}
     
	private function sortOrder2Update():void {     	
		csd.update(sortField2.selectedItem,1);
	}
     
    private function populateFundContext():ArrayCollection {
	  	//pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing counter party type                
            var settleActTypeArray:Array = new Array(3);
                settleActTypeArray[0]="S";
                settleActTypeArray[1]="B";
                settleActTypeArray[2]="T";
            myContextList.addItem(new HiddenObject("invActTypeContext",settleActTypeArray));
        
            var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="INTERNAL";
               
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
            
            return myContextList;
	}
	
    override public function postQueryResultInit(mapObj:Object):void {
    	commonInit(mapObj);
	    if(menuHit){                
	        submitQuery();
	        menuHit = false;
	    }
    }
	    	    
	override public function preQuery():void {

		setValidator();
        qh.resetPageNo();
        additionalCriteria = false;
        checkAdditionalCriteria();
        btnRefresh.enabled = false;
        submit.enabled = false;
        super.getSubmitQueryHttpService().url = "stl/instructionStatusDispatch.action?";  
        super.getSubmitQueryHttpService().request = populateRequestParams();
	}

	

	private function setValidator():void{
		
	    var validateModel:Object={
	                    inxStatusQuery:{                                 
	                         tradeDateFrom:this.tradedateFrom.text,
	                         tradeDateTo:this.tradedateTo.text,
	                         transmissionDate:this.transmissionDate.text
	                    }
	                   }; 
	     super._validator = new InxStatusQueryValidator();
	     super._validator.source = validateModel ;
	     super._validator.property = "inxStatusQuery";
		}
	
	private function checkAdditionalCriteria():void {
		if(XenosStringUtils.isBlank(this.transmissionDate.text)
			&& XenosStringUtils.isBlank(this.swiftRefNo.text)
			&& XenosStringUtils.isBlank(this.rcvBic.text)
			&& (this.mtType.selectedIndex <= 0) 
			&& (this.msgFunc.selectedIndex <= 0)) {
			additionalCriteria = false;
		} else {
			additionalCriteria = true;
		}
	}

		
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object(); 	
    	reqObj.method = "doQuery";    	
    	reqObj.fundCode = this.fundCode.fundCode.text;    	
    	reqObj.fundAccountNo = this.fundAccountNo.accountNo.text;    	
    	reqObj.officeId = this.office.selectedItem != null ? this.office.text : "";
    	reqObj.tradeDateFrom = this.tradedateFrom.text;
    	reqObj.instrumentType = this.instrumentType.itemCombo.text;
    	reqObj.tradeDateTo = this.tradedateTo.text;    	
    	reqObj.dataSource = this.dataSource.selectedItem != null ? StringUtil.trim(this.dataSource.selectedItem.value) : XenosStringUtils.EMPTY_STR;
    	reqObj.transmissionDate = this.transmissionDate.text;
    	reqObj.swiftRefNo = this.swiftRefNo.text; 
    	reqObj.receiverBic = this.rcvBic.text;
    	reqObj.mtType = this.mtType.selectedItem != null ? StringUtil.trim(this.mtType.selectedItem.value) : XenosStringUtils.EMPTY_STR;
    	reqObj.msgFunction = this.msgFunc.selectedItem != null ? StringUtil.trim(this.msgFunc.selectedItem.value) : XenosStringUtils.EMPTY_STR; 
    	reqObj.fundCategory = this.fundCategory.selectedItem != null ? StringUtil.trim(this.fundCategory.selectedItem.value) : XenosStringUtils.EMPTY_STR;  	
    	reqObj.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : XenosStringUtils.EMPTY_STR;    	
    	reqObj.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : XenosStringUtils.EMPTY_STR;    	
        
    	reqObj.SCREEN_KEY = 11188;
    	
    	return reqObj;
    }
    
    override public function postQueryResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    }       
        
    private function commonResult(mapObj:Object):void {    	
    	var result:String = "";
    	if(mapObj != null){   
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		queryResult.removeAll();
	    		submit.enabled = true;
       			btnRefresh.enabled = true;
	    		errPage.showError(mapObj["errorMsg"]);
	    	} else if(mapObj["errorFlag"].toString() == "noError"){
	    	    errPage.clearError(super.getSubmitQueryResultEvent());
                queryResult.removeAll();
                queryResult=mapObj["row"];
                submit.enabled = true;
       		    btnRefresh.enabled = true;
			    changeCurrentState();
	            qh.setOnResultVisibility();
	            qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
	            qh.PopulateDefaultVisibleColumns();
	            
	    		for(var i:int=0;i<queryResult.length;i++) {
	    			queryResult.getItemAt(i).itemIndex=i;
	    		}
	    		var strTrdStatistics:String = XenosStringUtils.EMPTY_STR;
	    		//Trade Count for additional criteria
	    		if(additionalCriteria){
	    			strTrdStatistics = '[Trade match number]\t - ';
	    		} else {
	    			strTrdStatistics = '[Trade match number]\tMatch:' + queryResult[0].matchTotal +
                                                '(Copy:' + queryResult[0].copyTotal + ')';
	    		}
                
                var strNormalStatistics:String = '[SWIFT related number]\tTotal(Normal):' + queryResult[0].normalTotal +
                                                ' Transmitted:' + queryResult[0].normalTransmittedTotal + '(Ack:' + 
                                                queryResult[0].normalAckTotal + ') Unsent:' + queryResult[0].normalUnsentTotal + 
                                                ' Copy Transmitted:' + queryResult[0].normalCopyTransmittedTotal + '(Ack:' + 
                                                queryResult[0].normalCopyAckTotal + ')\n';
                var strCancelStatistics:String = '\t\t\t\t\t\t\tTotal(Cancel):' + queryResult[0].cancelTotal +
                                                ' Transmitted:' + queryResult[0].cancelTransmittedTotal + '(Ack:' + 
                                                queryResult[0].cancelAckTotal + ') Unsent:' + queryResult[0].cancelUnsentTotal + 
                                                ' Copy Transmitted:' + queryResult[0].cancelCopyTransmittedTotal + '(Ack:' + 
                                                queryResult[0].cancelCopyAckTotal + ')';
                qh.resultHeader.width = 500;
                qh.resultHeader.text = strTrdStatistics;
                swiftNormal.text = strNormalStatistics+strCancelStatistics;
	    	} else {
	    		errPage.removeError();
	    		submit.enabled = true;
       		    btnRefresh.enabled = true;
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}
    	}
    }   
             
    override public function preResetQuery():void {
		super.getResetHttpService().url = "stl/instructionStatusDispatch.action?method=resetQueryCriteria&&mode=query&&rnd=" + Math.random();        	
    }
    
    override public function postResetQuery():void {
    	resetValues();
    }
            
    override public function preGenerateXls():String{
        return "stl/instructionStatusDispatch.action?method=generateXLS&rnd=" + Math.random();
    }  
   
    override public function preGeneratePdf():String{
        return "stl/instructionStatusDispatch.action?method=generatePDF&rnd=" + Math.random();
    }
     
    private function dispatchPdfEvent():void{
        this.dispatchEvent(new Event("pdf"));
    }
      
    private function dispatchXlsEvent():void{
        this.dispatchEvent(new Event("xls"));
    }   

  	private function resetValues():void {		
		this.fundCode.fundCode.text = null;
		this.fundAccountNo.accountNo.text = null;
        this.office.selectedItem = null;
		this.tradedateFrom.text = null;
		this.tradedateTo.text = null;
        this.dataSource.selectedItem = null;

        this.msgFunc.selectedItem = null;
        this.mtType.selectedItem = null;
        this.fundCategory.selectedItem = null;
        this.instrumentType.itemCombo.text = null;
        this.swiftRefNo.text = null;
        this.rcvBic.text = null;
        this.transmissionDate.text = null;
        submit.enabled = true;
        btnRefresh.enabled = true;

		errPage.removeError();
	}      
                    
	override public function preNext():Object {
		var reqObj : Object = new Object();
		reqObj.method = "nextPage";
		return reqObj;
	}	
    
	override public function prePrevious():Object {
		var reqObj : Object = new Object();
		reqObj.method = "prevPage";
		return reqObj;
	}	
          
    private function dispatchPrintEvent():void {
        this.dispatchEvent(new Event("print"));
    } 

    private function dispatchNextEvent():void {
        this.dispatchEvent(new Event("next"));
    }  

    private function dispatchPrevEvent():void {
        this.dispatchEvent(new Event("prev"));
    }      
      
	private function submitQuery():void{
        this.dispatchEvent(new Event('querySubmit'));             
	}

    private function getXenosReferenceNo(item:Object, column : DataGridColumn):String{        
        return item.xenosReferenceNoDisp;        
    }
            
    private function getSecurityCode(item:Object,column : DataGridColumn):String{
        return item.securityCode;
    }

    private function getFundCode(item:Object,column : DataGridColumn):String{
        return item.fundCode;
    }

    private function getFundAccountNo(item:Object,column : DataGridColumn):String{
        return item.fundAccountDisp;
    }

    private function getBrokerAccountName(item:Object,column : DataGridColumn):String{
        return item.brokerAccountName;
    }
    
    private function modifyTransmitTime(item:Object,column : DataGridColumn):String{
        
        var obj:XML = XML(item);
        var markStatus:String = obj.child("markStatus").toString();
            	
        if(StringUtil.trim(markStatus) == Globals.EMPTY_STRING || StringUtil.trim(markStatus)== null) {
            	return item.transmissionDateStr;
        }
        else{
                return item.markStatus;
        }        
    }
    
    private function selectColor(item:Object, color:uint):uint {
       if(XenosStringUtils.equals(item.acceptanceStatus, 'OK') || XenosStringUtils.equals(item.markStatus, '(Marked)')) {
            return 0x33CC99;
       }else if(XenosStringUtils.equals(item.acceptanceStatus, 'NO_ACK')){     
            return  0xF97777 ;
        } else {
            return color;
        }
    }
    
    private function refreshQuery():void{
    	this.dispatchEvent(new Event("querySubmitRefresh"));
    }
    
    override public  function  postQuery():void{
    	
    	btnRefresh.enabled = true;
    	submit.enabled = true;
    }
        