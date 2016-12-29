// ActionScript file

 import com.nri.rui.core.Globals;
 import com.nri.rui.core.containers.SummaryPopup;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.controls.XenosQuery;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.frx.constants.Constants;
 import com.nri.rui.frx.validators.FrxInstructionValidator;
 
 import flash.events.Event;
 
 import mx.collections.ArrayCollection;
 import mx.core.UIComponent;
 import mx.events.ListEvent;
 import mx.managers.PopUpManager;
 import mx.rpc.events.ResultEvent;
 import mx.utils.StringUtil;
 
[Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
 //Items returning through context - Non display objects for accountPopup
[Bindable]public var returnFundContextItem:ArrayCollection = new ArrayCollection();
[Bindable]public var returnOurContextItem:ArrayCollection = new ArrayCollection();
[Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
[Bindable]public var opObjDisp : String = XenosStringUtils.EMPTY_STR; 
[Bindable]public var selectAllBind:Boolean=false;  
[Bindable]private var mode : String = "query";
[Bindable]private var frxInfoPksConcated : String = XenosStringUtils.EMPTY_STR;
[Bindable]private var queryResult:ArrayCollection= new ArrayCollection();
[Bindable]private var valueDateFrom:String = XenosStringUtils.EMPTY_STR;
[Bindable]private var tradeDateFrom:String = XenosStringUtils.EMPTY_STR;
[Bindable]private var tradeDateTo:String = XenosStringUtils.EMPTY_STR;
[Bindable]private var transmissionDate:String = XenosStringUtils.EMPTY_STR;
[Bindable]private var opObj : String = XenosStringUtils.EMPTY_STR; 
[Bindable]private var confirmResult:ArrayCollection= new ArrayCollection();
[Bindable]private var noOfSelected:int=0;
[Bindable]private var showHelp:Boolean = true;

    

private var csd:CustomizeSortOrder=null;
private var csd1:CustomizeSortOrder=null;
private var initCompFlg : Boolean = false;
private var rndNo:Number = 0;
private var FrxInstructionInfoPk:int = -1; 
private var keylist:ArrayCollection = new ArrayCollection();
private var sortUtil: ProcessResultUtil= new ProcessResultUtil();  
private var sortFieldArray:Array = new Array();
private var sortFieldDataSet:Array = new Array();
private var sortFieldSelectedItem:Array =new Array();
private var selectedResults:ArrayCollection=new ArrayCollection();  
public var conformSelectedResults : Array; 
private var helpPopup : SummaryPopup = null;
private var recordStatistics:String = Globals.EMPTY_STRING;

	private function loadAll():void{
		 parseUrlString();
		 super.setXenosQueryControl(new XenosQuery());
		  if(this.mode == 'query')
	      	this.dispatchEvent(new Event('queryInit'));
	     else { 
	        this.dispatchEvent(new Event('cancelInit'));
	      }
	}
	
		  
	 private function changeCurrentState():void{
				currentState = "result";
	 }
	
	/**
	* Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
	* 
	*/ 
	private function parseUrlString():void {
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
	      if(this.mode == "query") {
		  	super.getInitHttpService().url = "frx/frxInstructionDetailDispatch.action?";
			var reqObject:Object = new Object();
			reqObject.rnd = rndNo;
	        reqObject.method= "initialExecute";
			reqObject.mode="query";
			reqObject.SCREEN_KEY = "12073";
			super.getInitHttpService().request = reqObject;
		  } 	
	}
	
	private function visibilityOfQueryScreenFields(opobjective:String):void{
		switch(opobjective){
			case 'QUERY' :
				glFundAcNo.includeInLayout = true;
				glFundAcNo.visible = true;
				giFundActPopUp.includeInLayout = true;
				giFundActPopUp.visible = true;
				glinxrefno.includeInLayout = true;
				glinxrefno.visible = true;
				giInxRefNo.includeInLayout = true;
				giInxRefNo.visible = true;
				glAckStatus.includeInLayout = true;
				glAckStatus.visible = true;
				giAckStatus.includeInLayout = true;
				giAckStatus.visible = true;
				
				gOurBankOurSettlemenAc.includeInLayout = true;
				gOurBankOurSettlemenAc.visible = true;
				glStatus.includeInLayout = true;
				glStatus.visible = true;
				giStatus.includeInLayout = true;
				giStatus.visible = true;
				
				transmissionDateGrid.visible = true;
				transmissionDateGrid.includeInLayout = true;
				
				trddateFrom.text = "";
				trddateTo.text = "";
				valdateFrom.text = "";
				valdateTo.text = "";
				
				transdate.text = transmissionDate;
				break;
			case Constants.SEND_NEW :
				glFundAcNo.includeInLayout = true;
				glFundAcNo.visible = true;
				giFundActPopUp.includeInLayout = true;
				giFundActPopUp.visible = true;
				glinxrefno.includeInLayout = false;
				glinxrefno.visible = false;
				giInxRefNo.includeInLayout = false;
				giInxRefNo.visible = false;
				glAckStatus.includeInLayout = false;
				glAckStatus.visible = false;
				giAckStatus.includeInLayout = false;
				giAckStatus.visible = false;
				
				gOurBankOurSettlemenAc.includeInLayout = false;
				gOurBankOurSettlemenAc.visible = false;
				glStatus.includeInLayout = true;
				glStatus.visible = true;
				giStatus.includeInLayout = true;
				giStatus.visible = true;
				
				transmissionDateGrid.visible = false;
				transmissionDateGrid.includeInLayout = false;
				
				trddateFrom.text = "";
				trddateTo.text = "";				
				valdateFrom.text = "";
				valdateTo.text = "";
				
				transdate.text = "";
				break;
			case Constants.MARK_AS_TRANSMITTED :
				glFundAcNo.includeInLayout = true;
				glFundAcNo.visible = true;
				giFundActPopUp.includeInLayout = true;
				giFundActPopUp.visible = true;
				glinxrefno.includeInLayout = false;
				glinxrefno.visible = false;
				giInxRefNo.includeInLayout = false;
				giInxRefNo.visible = false;
				glAckStatus.includeInLayout = false;
				glAckStatus.visible = false;
				giAckStatus.includeInLayout = false;
				giAckStatus.visible = false;
				
				gOurBankOurSettlemenAc.includeInLayout = false;
				gOurBankOurSettlemenAc.visible = false;
				glStatus.includeInLayout = true;
				glStatus.visible = true;
				giStatus.includeInLayout = true;
				giStatus.visible = true;
				
				transmissionDateGrid.visible = false;
				transmissionDateGrid.includeInLayout = false;
				
				trddateFrom.text = "";
				trddateTo.text = "";				
				valdateFrom.text = "";
				valdateTo.text = "";
				
				transdate.text = "";
				break;
		}
		
	}
	
	
	
	private function onChangeOperationObjective(event:ListEvent):void {
		FrxInstructionInfoPk = -1;
		frxInfoPksConcated = XenosStringUtils.EMPTY_STR;
		
		var target: Object = event.currentTarget.selectedItem as Object;
		var tarValue:String = target.value; 
		this.visibilityOfQueryScreenFields(tarValue);					
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
	
	override public function preGeneratePdf():String{
		var url:String = null;
		if(mode == 'query')
			url="frx/frxInstructionDetailDispatch.action?method=generatePDF";
		else
			url = "frx/frxInstructionDetailDispatch.action?method=generatePDF";
		return url;
	}
	
	override public function preGenerateXls():String{
		var url:String = null;
		if(mode == 'query')
			url="frx/frxInstructionDetailDispatch.action?method=generateXLS";
		else
			url = "frx/frxInstructionDetailDispatch.action?method=generateXLS";
		return url;
	}
	
	private function clearState():void{
		currentState = '';
	    app.submitButtonInstance = submit;
	 }
		  
	/**
     * This method should be called on creationComplete of the datagrid 
     */ 
	private function bindQryDataGrid():void {
        qhothers.dgrid = resultSummaryOthers;
         
     }
    private function  bindQryDGrid():void {
    	qhQuery.dgrid = resultSummaryQuery;
    }
	
	
	private function populateFinInstRole():ArrayCollection {
	    //pass the context data to the popup
	    var myContextList:ArrayCollection = new ArrayCollection();
	    return myContextList;
	} 
	
	
	/**
	* This is the method to pass the Collection of data items
	* through the context to the account popup. This will be implemented as per specifdic  
	* requriment. 
	*/
		

	
	//------------------ Validator Method --------------------/
	 private function setValidator():void{
	 	var frxInstValidationModel:Object = {
	 				frxInstQry:{
	 					operationObj:opObj,
	 					trdDateFrom:this.trddateFrom.text,
	 					trdDateTo:this.trddateTo.text,
	 					valueDateFrom:this.valdateFrom.text,
	 					valueDateTo:this.valdateTo.text,
	 					transDate:this.transdate.text
	 				}
	 	};
	 	super._validator = new FrxInstructionValidator();
        super._validator.source = frxInstValidationModel ;
        super._validator.property = "frxInstQry";
	 }
	// -------------- Query Submit Operation -----------------/
	
	private function decideSelectedVBoxInVStack():void {
        switch(opObj) {
        	case Constants.SEND_NEW :
                showHelp = true;
                transmitOthers.label=this.parentApplication.xResourceManager.getKeyValue('frx.inst.label.transmit');
            	stackresult.selectedChild = others;
            	sendNewShowCount304.includeInLayout = true;
            	sendNewShowCount304.visible = true;
            	sendNewShowCount210.includeInLayout = true;
            	sendNewShowCount210.visible = true;
            	sendNewShowCount202.includeInLayout = true;
            	sendNewShowCount202.visible = true;
                break;
            case Constants.MARK_AS_TRANSMITTED :
            	showHelp = false;
            	transmitOthers.label=this.parentApplication.xResourceManager.getKeyValue('frx.inst.label.markastransmit');
                stackresult.selectedChild = others;
                sendNewShowCount304.includeInLayout = false;
            	sendNewShowCount304.visible = false;
            	sendNewShowCount210.includeInLayout = false;
            	sendNewShowCount210.visible = false;
            	sendNewShowCount202.includeInLayout = false;
            	sendNewShowCount202.visible = false;
                break;
            case Constants.QUERY :
                stackresult.selectedChild = query;
                break;    
            default :
//                trace(opObj);
//                stackresult.selectedChild = other;
            break;        
        }
   }
	
	override public function preQuery():void{
		 opObj = this.opObjective.selectedItem != null ? this.opObjective.selectedItem.value : "";
		 opObjDisp = this.opObjective.selectedItem != null ? this.opObjective.selectedItem.label : "";
		 setValidator();
		 qhothers.resetPageNo();
		 qhQuery.resetPageNo();		 
		 super.getSubmitQueryHttpService().url = "frx/frxInstructionDetailDispatch.action?";
		 super.getSubmitQueryHttpService().method="POST";
         super.getSubmitQueryHttpService().request  = populateRequestParams(); 
		 
	}
	

	
	 private function populateRequestParams():Object{
		
		var reqObject:Object = new Object();
		reqObject..SCREEN_KEY = "12074";
		reqObject.fundCode = this.fundPopUp.fundCode.text;
		reqObject.tradeRefNo = this.trdrefno.text;
		reqObject.tradeType = this.tradetypevalues.selectedItem != null ? this.tradetypevalues.selectedItem.value : "";
		reqObject.operationObjective = this.opObjective.selectedItem != null ? this.opObjective.selectedItem.value : "";
		reqObject.officeId = this.officevalues.selectedItem != null ? this.officevalues.selectedItem : "" ;
		reqObject.dataSource = this.datasourcevalues.selectedItem != null ? this.datasourcevalues.selectedItem.value : "";
		reqObject.instructionType = this.instructionTypeValues.selectedItem != null ? this.instructionTypeValues.selectedItem.value : "";
		reqObject.tradeDateFrom = this.trddateFrom.text;
		reqObject.tradeDateTo = this.trddateTo.text;
		reqObject.valueDateFrom = this.valdateFrom.text;
		reqObject.valueDateTo = this.valdateTo.text;
		reqObject.cpAccountNo = this.cpAccountNoPopUp.accountNo.text;
		reqObject.buyCurrency  = this.baseccyBox.ccyText.text;
		reqObject.sellCurrency = this.againstccyBox.ccyText.text;
		reqObject.method="submitQuery";
	    reqObject.fundAccountNo = this.fundActPopUp.accountNo.text;
	    reqObject.status = this.statusvalues.selectedItem != null ? this.statusvalues.selectedItem.value : "";
		
		reqObject.ndfType = this.ndftypevalues.selectedItem != null ? this.ndftypevalues.selectedItem.value : "";
		reqObject.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : XenosStringUtils.EMPTY_STR;
		reqObject.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : XenosStringUtils.EMPTY_STR;
		reqObject.sortField3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : XenosStringUtils.EMPTY_STR;

		if(XenosStringUtils.equals(opObj , Constants.SEND_NEW) 
		   || XenosStringUtils.equals(opObj , Constants.MARK_AS_TRANSMITTED)){
		   	reqObject.instructionRefNo = XenosStringUtils.EMPTY_STR;
			reqObject.ourBankCode = XenosStringUtils.EMPTY_STR;
			reqObject.ourSettleAccountNo = XenosStringUtils.EMPTY_STR;
			reqObject.acceptanceStatus = XenosStringUtils.EMPTY_STR;
		   	reqObject.transmissionDate = XenosStringUtils.EMPTY_STR;
		}else{
			reqObject.instructionRefNo = this.inxRefNo.text;
			reqObject.ourBankCode = this.ourBankCodePopUp.finInstCode.text;
			reqObject.ourSettleAccountNo = this.ourSettleAccountNoPopUp.accountNo.text;
			reqObject.acceptanceStatus = this.ackStatus.selectedItem != null ? this.ackStatus.selectedItem.value : "";
			
			reqObject.transmissionDate = this.transdate.text;
       	}
       	reqObject.rnd = Math.random() + "";
       	return reqObject;
	} 
	
	override public function postQueryResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    }
    
    //Show record count statistics
    private function setRecordCount(tempObj:Object):void{
    	if(XenosStringUtils.equals(opObj , Constants.SEND_NEW)){	    	
    		sendNewRecordCountMT304.text =  'Total:'+ tempObj.totalCount+
    							';Cancel:'+tempObj.totalCancel+
                    		    '; \nPending:'+tempObj.totalPendingCount+ 
                    		    ' (Unknown CPSSI:'+tempObj.totalUnknownCpssi+
                    		    ' Missing Receiver BIC:'+tempObj.totalMissingReceiverBic+
                    		    ' Incomplete CP SSI(Missing BIC/Acount):'+tempObj.totalIncompleteCpssi+
                    		    ' Different Broker BIC:'+tempObj.totalDiffSsiMissingXref+
                    		    ')';
            sendNewRecordCountMT202.text = 'Total:'+ tempObj.totalCount202+
    							';Cancel:'+tempObj.totalCancelNet+
                    		    '; \nPending:'+tempObj.totalPendingCount202+ 
                    		    ' (Unknown CPSSI:'+tempObj.totalUnknownCpssi202+
                    		    ' Missing Receiver BIC:'+tempObj.totalMissingReceiverBic202+
                    		    ' Incomplete CP SSI(Missing BIC/Acount):'+tempObj.totalIncompleteCpssi202+
                    		    ' Different Broker BIC:'+tempObj.totalDiffSsiMissXref202+
                    		    ')';
			sendNewRecordCountMT210.text = 'Total:'+ tempObj.totalCount210+
    							';Cancel:'+tempObj.totalCancelNet+
                    		    '; \nPending:'+tempObj.totalPendingCount210+ 
                    		    ' (Unknown CPSSI:'+tempObj.totalUnknownCpssi210+
                    		    ' Missing Receiver BIC:'+tempObj.totalMissingReceiverBic210+
                    		    ' Incomplete CP SSI(Missing BIC/Acount):'+tempObj.totalIncompleteCpssi210+
                    		    ' Different Broker BIC:'+tempObj.totalDiffSsiMissXref210+
                    		    ')';
			sendNewResultHeaderMT304.text = "MT304 : ";
			sendNewResultHeaderMT202.text = "MT202 : ";
			sendNewResultHeaderMT210.text = "MT210 : ";			                	
    	}else if(XenosStringUtils.equals(opObj , Constants.QUERY)){
    		recordCountMT304.text = 'Total(Normal):'+tempObj.normal304Total +' Transmitted:'+ tempObj.normalTransmitted304Total +' (Ack:'+ tempObj.normalAck304Total +')  Unsent:'+tempObj.normal304Unsent +
    						   '\nTotal(Cancel):'+tempObj.cancel304Total + ' Transmitted:'+ tempObj.cancelTransmitted304Total +' (Ack:'+ tempObj.cancelAck304Total +')  Unsent:'+tempObj.cancel304Unsent ;
    		
    		recordCountMT210.text = 'Total(Normal):'+tempObj.normal210Total +' Transmitted:'+ tempObj.normalTransmitted210Total +' (Ack:'+ tempObj.normalAck210Total +')  Unsent:'+tempObj.normal210Unsent +
    						   '\nTotal(Cancel):'+tempObj.cancel210Total + ' Transmitted:'+ tempObj.cancelTransmitted210Total +' (Ack:'+ tempObj.cancelAck210Total +')  Unsent:'+tempObj.cancel210Unsent ;
    		
    		recordCountMT202.text = 'Total(Normal):'+tempObj.normal202Total +' Transmitted:'+ tempObj.normalTransmitted202Total +' (Ack:'+ tempObj.normalAck202Total +')  Unsent:'+tempObj.normal202Unsent +
    						   '\nTotal(Cancel):'+tempObj.cancel202Total + ' Transmitted:'+ tempObj.cancelTransmitted202Total +' (Ack:'+ tempObj.cancelAck202Total +')  Unsent:'+tempObj.cancel202Unsent ;

    		resultHeaderMT304.text="MT304 : ";
    		resultHeaderMT202.text="MT202 : ";
    		resultHeaderMT210.text="MT210 : ";
    	}else{
    		recordStatistics = "";
    		qhothers.recordCount.text = recordStatistics;
            qhothers.recordCount.minWidth = 620;
            //qhothers.help.enabled = false;
    	}
    	
    }
    //common result of the query
    private function commonResult(mapObj:Object):void{ 
    	var result:String = "";
    	queryResult.removeAll();
    	conformSelectedResults = new Array();
    	selectedResults.removeAll();
    	selectAllBind = false;
    	if(mapObj!=null){  
    		if(mapObj["errorFlag"].toString() == "error"){
		    	errPage.showError(mapObj["errorMsg"]); 
		    	recordStatistics = Globals.EMPTY_STRING;
				sendNewRecordCountMT304.text = recordStatistics;		
				sendNewRecordCountMT202.text = recordStatistics;
				sendNewRecordCountMT210.text = recordStatistics;
				recordCountMT304.text = recordStatistics;
				recordCountMT210.text = recordStatistics;
				recordCountMT202.text = recordStatistics;
				}else if(mapObj["errorFlag"].toString() == "noError"){
	    			decideSelectedVBoxInVStack();
	    			errPage.clearError(super.getSubmitQueryResultEvent());
                	queryResult=mapObj["row"];
					if(XenosStringUtils.equals(opObj , Constants.SEND_NEW)){
					}
                    setRecordCount(queryResult[0]);
                	changeCurrentState();		
	    	}else{
	    		errPage.removeError();
	    		recordStatistics = Globals.EMPTY_STRING;
				sendNewRecordCountMT304.text = recordStatistics;		
				sendNewRecordCountMT202.text = recordStatistics;
				sendNewRecordCountMT210.text = recordStatistics;
				recordCountMT304.text = recordStatistics;
				recordCountMT210.text = recordStatistics;
				recordCountMT202.text = recordStatistics;
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}
	    	
	    	var prev:Boolean = (mapObj["prevTraversable"] == "true")?true:false;
            var next:Boolean = (mapObj["nextTraversable"] == "true")?true:false;
	    	if(XenosStringUtils.equals(opObj,Constants.MARK_AS_TRANSMITTED)){
					 	qhothers.setOnResultVisibility();
		     		 	qhothers.setPrevNextVisibility(prev,next);
		     		 	qhothers.PopulateDefaultVisibleColumns();
	     	    	} else if(XenosStringUtils.equals(opObj,Constants.SEND_NEW)) {
	     	    		qhothers.setOnResultVisibility();
		     		 	qhothers.setPrevNextVisibility(prev,next);
		     		 	qhothers.PopulateDefaultVisibleColumns();
	     	    	} else {	
				   		qhQuery.setOnResultVisibility();
		     		 	qhQuery.setPrevNextVisibility(prev,next);
		     		 	qhQuery.PopulateDefaultVisibleColumns();	
			    	}    		
    	}
     	
     	
     }
	
	//--------------  Reset Operation -----------------------//
	
	override public function preQueryResultInit():Object{
	   	addCommonKeys();	    	
	   	return keylist;        	
	}
	
	override public function postQueryResultInit(mapObj:Object):void{
	   	commonInit(mapObj);
	}
	
	override public function preResetQuery():void{
		var rndNo:Number = Math.random();
		if(this.mode == 'query'){
			super.getResetHttpService().url = "frx/frxInstructionDetailDispatch.action?";
			var reqObject:Object = new Object();
			reqObject.method = "resetQueryCriteria";
			reqObject.mode = "query";
			reqObject.rnd = rndNo + "";
			super.getResetHttpService().request = reqObject;
		}
	}
	   
	   
	private function addCommonKeys():void{
		keylist = new ArrayCollection();
		keylist.addItem("operationObjDropdownList.item");
		keylist.addItem("acceptanceStatusValueList.item");
		keylist.addItem("tradeTypeList.item");
		keylist.addItem("ndfTypeList.item");
		keylist.addItem("officeIdList.officeId");
		keylist.addItem("dataSourceValues.item");
		keylist.addItem("statusValues.item");
		keylist.addItem("sortFieldList.item");
		keylist.addItem("sortField1");
		keylist.addItem("sortField2");
		keylist.addItem("sortField3");
		keylist.addItem("transmissionDate");
		keylist.addItem("instructionTypeValues.item");
		
	}     
	
	
	private function commonInit(mapObj:Object):void{
		var selIndx1:int = 0;
		var selIndx2:int = 0;
		var selIndx3:int = 0;
		
		errPage.clearError(super.getInitResultEvent());
		app.submitButtonInstance = submit;
		var i:int = 0;
		var dateStr:String = null;
		var tempColl: ArrayCollection = new ArrayCollection();
		var initColl:ArrayCollection = new ArrayCollection();
		
		
	    var sortField1Default:String ;
	    var sortField2Default:String ; 
		var sortField3Default:String ; 
		var sortFieldList1:ArrayCollection = new ArrayCollection();
		var sortFieldList2:ArrayCollection = new ArrayCollection();
		var sortFieldList3:ArrayCollection = new ArrayCollection();
		fundPopUp.fundCode.text = "";
		fundActPopUp.accountNo.text = "";
		ourBankCodePopUp.finInstCode.text = "";
		ourSettleAccountNoPopUp.accountNo.text = "";
		cpAccountNoPopUp.accountNo.text = "";
		trddateTo.text = "";
		valdateTo.text = "";
		transdate.text = "";
		trdrefno.text = "";
		inxRefNo.text = "";
		baseccyBox.ccyText.text = "";
		againstccyBox.ccyText.text = ""; 
		
		
		//Providing data to Operation Objective 
		tempColl = new ArrayCollection();
		initColl = new ArrayCollection();
		if(mapObj[keylist.getItemAt(0)] !=null){
			if(mapObj[keylist.getItemAt(0)] is ArrayCollection){
			  	initColl = mapObj[keylist.getItemAt(0)] as ArrayCollection;
			   	for each(var item1:Object in initColl){
			   		tempColl.addItem(item1);
			   	}
			}
			else {
			  		tempColl.addItem(mapObj[keylist.getItemAt(0)].toString());
			}
		}
		this.opObjective.dataProvider = tempColl;
		var opobj1:String = tempColl[0].value;
		this.visibilityOfQueryScreenFields(opobj1);
		
		
		//Data Provider for ACKStatus 
		tempColl = new ArrayCollection();
		initColl = new ArrayCollection();
		tempColl.addItem({label:" ", value: " "});
		if(mapObj[keylist.getItemAt(1)] != null){
			if(mapObj[keylist.getItemAt(1)] is ArrayCollection){
				initColl = mapObj[keylist.getItemAt(1)] as ArrayCollection;
				for each(item1 in initColl){
					tempColl.addItem(item1);
				}
			}else{
				tempColl.addItem(mapObj[keylist.getItemAt(1)].toString());
			}
		}
		this.ackStatus.dataProvider = tempColl;
		
		//Data Provider for Trade Type  
		
		tempColl = new ArrayCollection();
		initColl = new ArrayCollection();
		tempColl.addItem({label:" ", value: " "});
		if(mapObj[keylist.getItemAt(2)] != null){
			if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
				initColl = mapObj[keylist.getItemAt(2)] as ArrayCollection;
				for each(item1 in initColl){
					tempColl.addItem(item1);
				}
			}else{
				tempColl.addItem(mapObj[keylist.getItemAt(2)].toString());
			}
		}
		this.tradetypevalues.dataProvider = tempColl;
		
		//Data Provider for NDF Open/Close 
		
		tempColl = new ArrayCollection();
		initColl = new ArrayCollection();
		tempColl.addItem({label:" ", value: " "});
		if(mapObj[keylist.getItemAt(3)] != null){
			if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
				initColl = mapObj[keylist.getItemAt(3)] as ArrayCollection;
				for each(item1 in initColl){
					tempColl.addItem(item1);
				}
			}else{
				tempColl.addItem(mapObj[keylist.getItemAt(3)].toString());
			}
		}
		this.ndftypevalues.dataProvider = tempColl;
		
		//Data Provider for Office
		
		tempColl = new ArrayCollection();
		initColl = new ArrayCollection();
		tempColl.addItem(" ");
		if(mapObj[keylist.getItemAt(4)] != null){
			if(mapObj[keylist.getItemAt(4)] is ArrayCollection){
				initColl = mapObj[keylist.getItemAt(4)] as ArrayCollection;
				for each(item1 in initColl){
					tempColl.addItem(item1);
				}
			}else{
				tempColl.addItem(mapObj[keylist.getItemAt(4)].toString());
			}
		}
		this.officevalues.dataProvider = tempColl;
		
		//Data Provider for Origin Data Source
		
		tempColl = new ArrayCollection();
		initColl = new ArrayCollection();
		tempColl.addItem({label:" ", value: " "});
		if(mapObj[keylist.getItemAt(5)] != null){
			if(mapObj[keylist.getItemAt(5)] is ArrayCollection){
				initColl = mapObj[keylist.getItemAt(5)] as ArrayCollection;
				for each(item1 in initColl){
					tempColl.addItem(item1);
				}
			}else{
				tempColl.addItem(mapObj[keylist.getItemAt(5)].toString());
			}
		}
		this.datasourcevalues.dataProvider = tempColl;
		
		//Data Provider for Status
		
		tempColl = new ArrayCollection();
		initColl = new ArrayCollection();
		tempColl.addItem({label:" ", value: " "});
		if(mapObj[keylist.getItemAt(6)] != null){
			if(mapObj[keylist.getItemAt(6)] is ArrayCollection){
				initColl = mapObj[keylist.getItemAt(6)] as ArrayCollection;
				for each(item1 in initColl){
					tempColl.addItem(item1);
				}
			}else{
				tempColl.addItem(mapObj[keylist.getItemAt(6)].toString());
			}
		}
		this.statusvalues.dataProvider = tempColl;
		
		// Data Provider for Instruction Type
		
		tempColl = new ArrayCollection();
		initColl = new ArrayCollection();
		tempColl.addItem({label:" ", value: " "});
		if(mapObj[keylist.getItemAt(12)] != null){
			if(mapObj[keylist.getItemAt(12)] is ArrayCollection){
				initColl = mapObj[keylist.getItemAt(12)] as ArrayCollection;
				for each(item1 in initColl){
					tempColl.addItem(item1);
				}
			}else{
				tempColl.addItem(mapObj[keylist.getItemAt(12)].toString());
			}
		}
		this.instructionTypeValues.dataProvider = tempColl;
		
		// Data provider for sort order list.
		
		sortField1Default = mapObj[keylist.getItemAt(8)].toString();
	    sortField2Default = mapObj[keylist.getItemAt(9)].toString();
		sortField3Default = mapObj[keylist.getItemAt(10)].toString();
		initColl.removeAll();
		if( mapObj[keylist.getItemAt(7)] != null){
			if( mapObj[keylist.getItemAt(7)] is ArrayCollection){
				initColl = mapObj[keylist.getItemAt(7)] as ArrayCollection;
			}else{
				initColl.addItem(mapObj[keylist.getItemAt(7)].toString());
			}
		} 
		
		sortFieldList1.addItem({label:" ", value: " "});
		sortFieldList2.addItem({label:" ", value: " "});
		sortFieldList3.addItem({label:" ", value: " "});
		
		for( i = 0 ; i<initColl.length ; i++){
			if(XenosStringUtils.equals(initColl[i].value , sortField1Default))
				selIndx1 = i;
			else if(XenosStringUtils.equals(initColl[i].value , sortField2Default))
				selIndx2 = i;
			else if(XenosStringUtils.equals(initColl[i].value , sortField3Default))
				selIndx3 = i;
				
		    sortFieldList1.addItem(initColl[i]);
            sortFieldList2.addItem(initColl[i]);
            sortFieldList3.addItem(initColl[i]);    	
		}
		
		sortFieldArray[0]=sortField1;
        sortFieldArray[1]=sortField2;
        sortFieldArray[2]=sortField3;
        
        sortFieldDataSet[0]=sortFieldList1;
        sortFieldDataSet[1]=sortFieldList2;
        sortFieldDataSet[2]=sortFieldList3;
        
        sortFieldSelectedItem[0] = sortFieldList1.getItemAt(selIndx1+1);
        sortFieldSelectedItem[1] = sortFieldList2.getItemAt(selIndx2+1);
        sortFieldSelectedItem[2] = sortFieldList3.getItemAt(selIndx3+1);
        
        sortField1.dataProvider = sortFieldList1;
        sortField2.dataProvider = sortFieldList2;
        sortField3.dataProvider = sortFieldList3;
		
		csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
		csd.init();
		transmissionDate = mapObj[keylist.getItemAt(11)];
	}
	
	private function sortOrder1Update():void{
	    csd.update(sortField1.selectedItem,0);
	}
	
	private function sortOrder2Update():void{         
	    csd.update(sortField2.selectedItem,1);
	}
	
	private function initQueryResult(event:ResultEvent):void{
		
	}

	private function submitTransmit():void{
		if(conformSelectedResults != null && 
		   conformSelectedResults.length == 0) {
              XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.selectatleastonerecord'));
      } else {
      	inxDetailConfirmRequest.url="frx/frxInstructionDetailDispatch.action?";
		var reqObj:Object = new Object();
		reqObj.method = "doSubmit";
		reqObj.rnd = Math.random();
		reqObj.SCREEN_KEY = "12075";
		reqObj.frxTrdPkArray = conformSelectedResults;
		inxDetailConfirmRequest.request = reqObj;
		inxDetailConfirmRequest.send();
      }
		
	}
	
	private function confirmHandler(event:ResultEvent):void{
		var rs:XML = XML(event.result);
		var errorInfoList : ArrayCollection = new ArrayCollection();
		confirmResult = new ArrayCollection();
		if(null != rs){
			if(rs.child("selectedResult").length() > 0){
				errPage2.clearError(event);
				confirmResult.removeAll();
				var selectedList:XMLList = rs.child("selectedResult");
				try{
					var i:int = 0;
					if(selectedList.child("selectedResultItem").length() >0){
						for each ( var rec:XML in selectedList.selectedResultItem){
							confirmResult.addItem(rec);
							i++;
						}
						this.noOfSelected = i;	
					}
				}catch(e:Error) {
                    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                }
			} else if (rs.child("Errors").length()>0){
				confirmResult.removeAll();
				errorInfoList = new ArrayCollection();
				//populate the error info list                  
                for each ( var error:XML in rs.Errors.error ) {
                    errorInfoList.addItem(error.toString());
                }
			}else{
				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                confirmResult.removeAll(); // clear previous data if any as there is no result now.
			}
		}else {
            confirmResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }
		
		frxpopUp = FrxInstructionConfirm(PopUpManager.createPopUp(this , FrxInstructionConfirm ,true));
		frxpopUp.width = this.parentApplication.width - 300;
		frxpopUp.dataprovider = confirmResult;
		frxpopUp.noOfSelectedRecord = noOfSelected;
		frxpopUp.errPage.showError(errorInfoList);//Display the error
		frxpopUp.title = this.parentApplication.xResourceManager.getKeyValue('frx.inst.label.maintenance');
		frxpopUp.addEventListener("OkSystemConfirm",handleOkSystemConfirm);
		PopUpManager.centerPopUp(frxpopUp);
	}
	
	 public function handleOkSystemConfirm(event:Event):void {              
       this.dispatchEvent(new Event('querySubmit'));
    }  
    
    
    /* ************  Select Multiple record in data grid *************/
    
    
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
    		if(queryResult.getItemAt(i).selected == false || queryResult.getItemAt(i).selected == 'false' || XenosStringUtils.isBlank(queryResult.getItemAt(i).selected)) {
        		return false;
        	}
    	}
    	if(i == queryResult.length) {
    		return true;
         }else {
    		return false;
    	}
    } 
    
    
    public function selectAllRecords(flag:Boolean): void {
    	var i:Number = 0;
    	selectedResults.removeAll();
    	for(i=0; i<queryResult.length; i++){
    		var obj:XML=queryResult.getItemAt(i) as XML;
    		if(XenosStringUtils.equals(obj.operationObjective,Constants.MARK_AS_TRANSMITTED)
    		   || ( XenosStringUtils.equals(obj.operationObjective,Constants.SEND_NEW)
    		        && !( XenosStringUtils.equals(obj.cyan, "true") ||
    		       		  XenosStringUtils.equals(obj.pink, "true") || 
        		          XenosStringUtils.equals(obj.yellow, "true") || 
        		          XenosStringUtils.equals(obj.blue, "true") )
    		       )
    		   
    		   ) {
    		   	
    				obj.selected = flag;
    				
		            queryResult.setItemAt(obj,i);
		            queryResult.refresh();
		            addOrRemove(obj);
    		}
            
    	}
    	conformSelectedResults = selectedResults.toArray();
    }
    
	public function addOrRemove(item:Object):void {
    	var i:Number;
        var tempArray:Array = new Array();
        if(item.selected == true || XenosStringUtils.equals(item.selected , "true")){ 
            selectedResults.addItem(item.key);
    	} else { //needs to pop
    		if(selectedResults.length <= 0)
                return;
            var tempFrxObjs:ArrayCollection = new ArrayCollection();
            var tmpObj:Object;
            
            for(i=0; i<selectedResults.length; i++){
                tmpObj = selectedResults.getItemAt(i); 
                if(tmpObj != (item.key)){
                    tempFrxObjs.addItem(tmpObj);
                }
            }
            selectedResults.removeAll();
            selectedResults = tempFrxObjs;
    		   
    	}		
    }
    
   public function checkSelectToModify(item:Object):void {
        var i:Number;
        if(item.selected == true || XenosStringUtils.equals(item.selected , "true")){
            selectedResults.addItem(item.key);          
    	} else { 
			if(selectedResults.length <= 0)
                return;
            var tempFrxObjs:ArrayCollection = new ArrayCollection();
            var tmpObj:Object;
            
            for(i=0; i<selectedResults.length; i++){
                tmpObj = selectedResults.getItemAt(i); 
                if(tmpObj != (item.key)){
                    tempFrxObjs.addItem(tmpObj);
                }
            }
            selectedResults.removeAll();
            selectedResults = tempFrxObjs;      	 	
    	}    
    	conformSelectedResults=	selectedResults.toArray();
    	setIfAllSelected();    	    	
    }
    
    
    // For Help Function 
    
    private function displayHelp():void {
    	this.helpBox.visible = true;
		this.helpBox.includeInLayout = true;
		var validationtext:String = null;
		
		validationtext = this.parentApplication.xResourceManager.getKeyValue('frx.label.differentbic');
		validationtext = validationtext + '\n' + this.parentApplication.xResourceManager.getKeyValue('frx.label.missing.fundcrossref');
		validationtext = validationtext + '\n' + this.parentApplication.xResourceManager.getKeyValue('frx.label.brkno.missing');	
		
		PopUpManager.removePopUp(helpPopup);
		
		helpPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
		
		helpPopup.title = this.parentApplication.xResourceManager.getKeyValue('frx.inst.label.color.background.info');
		helpPopup.minWidth= 400;
		helpPopup.height = 200;		
		this.differentBicText.htmlText = validationtext; 
		helpPopup.addChild(this.helpBox);
		PopUpManager.centerPopUp(helpPopup);
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
            myContextList.addItem(new HiddenObject("actTypeContext",actTypeArray));    
                      
            //passing counter party type                
            var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="INTERNAL";
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
        private function populateCounterPartyActContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing act type                
            var actTypeArray:Array = new Array(1);
                actTypeArray[0]="T|B";
            myContextList.addItem(new HiddenObject("cpActTypeContext",actTypeArray));    
                      
            //passing counter party type                
            var cpTypeArray:Array = new Array(2);
                cpTypeArray[0]="BROKER";
                cpTypeArray[1]="BANK/CUSTODIAN";
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("actStatusContext",actStatusArray));
            return myContextList;
        }
        
        /**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
        private function populateOurSettleActContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing act type                
            var actTypeArray:Array = new Array(1);
                actTypeArray[0]="T|B";
            myContextList.addItem(new HiddenObject("cpActTypeContext",actTypeArray));    
                      
            //passing counter party type                
            var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="BANK/CUSTODIAN";
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("actStatusContext",actStatusArray));
            return myContextList;
        }
        
        override public function preNext():Object
	{
	    var reqObj : Object = new Object();
	    reqObj.method = "doNext";
	    return reqObj;
	}
	         
	override public function prePrevious():Object
	{   
	    var reqObj : Object = new Object();
	    reqObj.method = "doPrevious";
	    return reqObj;
	}