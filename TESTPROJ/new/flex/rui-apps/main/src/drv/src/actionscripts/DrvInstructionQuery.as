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
import com.nri.rui.drv.DrvConstants;
import com.nri.rui.drv.validators.DrvInstructionValidator;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.core.UIComponent;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;

[Bindable] private var app: XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
//Items returning through context - Non display objects for accountPopup
[Bindable] public var returnFundContextItem: ArrayCollection = new ArrayCollection();
[Bindable] public var returnContextItem: ArrayCollection = new ArrayCollection();
[Bindable] public var opObjDisp: String = XenosStringUtils.EMPTY_STR;
[Bindable] public var selectAllBind: Boolean = false;
[Bindable] private var mode: String = "query";
[Bindable] private var drvInfoPksConcated: String = XenosStringUtils.EMPTY_STR; // @TODO
[Bindable] private var queryResult: ArrayCollection = new ArrayCollection();
[Bindable] private var valueDateFrom: String = XenosStringUtils.EMPTY_STR;
[Bindable] private var tradeDateFrom: String = XenosStringUtils.EMPTY_STR;
[Bindable] private var tradeDateTo: String = XenosStringUtils.EMPTY_STR;
[Bindable] private var transmissionDate: String = XenosStringUtils.EMPTY_STR;
[Bindable] private var opObj: String = XenosStringUtils.EMPTY_STR;
[Bindable] private var confirmResult: ArrayCollection = new ArrayCollection();
[Bindable] private var noOfSelected: int = 0;
[Bindable] private var showHelp: Boolean = true;
[Bindable] public var actionMode:String = "query"; // Nedded to hold value at submit time to pass in the ItemRenderer

private var csd: CustomizeSortOrder = null;
private var rndNo: Number = 0;
private var drvInstructionInfoPk: int = -1; // @TODO
private var keylist: ArrayCollection = new ArrayCollection();
private var sortUtil: ProcessResultUtil= new ProcessResultUtil();  
private var sortFieldArray: Array = new Array();
private var sortFieldDataSet: Array = new Array();
private var sortFieldSelectedItem: Array = new Array();
private var selectedResults: ArrayCollection = new ArrayCollection();
public var conformSelectedResults: Array;
private var helpPopup: SummaryPopup = null;
private var recordStatistics: String = Globals.EMPTY_STRING;

private function loadAll(): void {
	parseUrlString();
	super.setXenosQueryControl(new XenosQuery());
	if (this.mode == 'query') {
		this.dispatchEvent(new Event('queryInit'));
	}
	else {
		this.dispatchEvent(new Event('cancelInit'));
	}
}

private function changeCurrentState(): void {
	currentState = "result";
}

/**
 * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
 * 
 */
private function parseUrlString(): void {
	try {
		// Remove everything before the question mark, including
		// the question mark.
		var myPattern: RegExp = /.*\?/;
		var s: String = this.loaderInfo.url.toString();
		s = s.replace(myPattern, "");
		// Create an Array of name=value Strings.
		var params: Array = s.split(Globals.AND_SIGN);
		// Print the params that are in the Array.
		var keyStr: String;
		var valueStr: String;
		var paramObj: Object = params;

		// Set the values of the salutation.
		if (params != null) {
			for (var i: int = 0; i < params.length; i++) {
				var tempA: Array = params[i].split("=");
				if (tempA[0] == "mode") {
					mode = tempA[1];
				}
			}
		} else {
			mode = "query";
		}

	} catch (e: Error) {
		trace(e);
	}
}

private function onChangeOperationObjective(event: ListEvent): void {
	drvInstructionInfoPk = -1;
	drvInfoPksConcated = XenosStringUtils.EMPTY_STR;
	var target: Object = event.currentTarget.selectedItem as Object;
	var tarValue: String = target.value;
	this.visibilityOfQueryScreenFields(tarValue);
}

private function visibilityOfQueryScreenFields(opobjective: String): void {
	switch (opobjective) {
		case 'QUERY':

			glAckStatus.includeInLayout = true;
			glAckStatus.visible = true;
			giAckStatus.includeInLayout = true;
			giAckStatus.visible = true;

			transmissionDateGrid.visible = true;
			transmissionDateGrid.includeInLayout = true;

			trddateFrom.text = "";
			trddateTo.text = "";
			valuedateFrom.text = "";
			valuedateTo.text = "";

			transdate.text = transmissionDate;
			break;
		case DrvConstants.SEND_NEW:

			glAckStatus.includeInLayout = false;
			glAckStatus.visible = false;
			giAckStatus.includeInLayout = false;
			giAckStatus.visible = false;

			transmissionDateGrid.visible = false;
			transmissionDateGrid.includeInLayout = false;

			trddateFrom.text = "";
			trddateTo.text = "";
			valuedateFrom.text = "";
			valuedateTo.text = "";

			transdate.text = "";
			break;
		case DrvConstants.MARK_AS_TRANSMITTED:

			glAckStatus.includeInLayout = false;
			glAckStatus.visible = false;
			giAckStatus.includeInLayout = false;
			giAckStatus.visible = false;

			transmissionDateGrid.visible = false;
			transmissionDateGrid.includeInLayout = false;

			trddateFrom.text = "";
			trddateTo.text = "";
			valuedateFrom.text = "";
			valuedateTo.text = "";

			transdate.text = "";
			break;
	}
}

/**
 * This is the method to pass the Collection of data items
 * through the context to the account popup. This will be implemented as per specifdic  
 * requriment. 
 */
private function populateInvActContext(): ArrayCollection {
	//pass the context data to the popup
	var myContextList: ArrayCollection = new ArrayCollection();

	//passing account type
	var acTypeArray: Array = new Array(1);
	acTypeArray[0] = "T|B";
	myContextList.addItem(new HiddenObject("invActTypeContext", acTypeArray));

	//passing counter party type                
	var cpTypeArray: Array = new Array(1);
	cpTypeArray[0] = "INTERNAL";
	//cpTypeArray[1]="CLIENT";
	myContextList.addItem(new HiddenObject("invCPTypeContext", cpTypeArray));

	//passing account status                
	var actStatusArray: Array = new Array(1);
	actStatusArray[0] = "OPEN";
	myContextList.addItem(new HiddenObject("accountStatus", actStatusArray));
	return myContextList;
}

/**
 * This is the method to pass the Collection of data items
 * through the context to the account popup. This will be implemented as per specifdic  
 * requriment. 
 */
private function populateBrkActContext(): ArrayCollection {
	//pass the context data to the popup
	var myContextList: ArrayCollection = new ArrayCollection();

	//passing account type
	var acTypeArray: Array = new Array(1);
	acTypeArray[0] = "T|B";

	myContextList.addItem(new HiddenObject("invActTypeContext", acTypeArray));

	//passing counter party type                
	var cpTypeArray: Array = new Array(1);
	cpTypeArray[0] = "BROKER";

	myContextList.addItem(new HiddenObject("invCPTypeContext", cpTypeArray));
	return myContextList;
}

private function dispatchPrintEvent(): void {
	this.dispatchEvent(new Event("print"));
}

private function dispatchPdfEvent(): void {
	this.dispatchEvent(new Event("pdf"));
}

private function dispatchXlsEvent(): void {
	this.dispatchEvent(new Event("xls"));
}

private function dispatchNextEvent(): void {
	this.dispatchEvent(new Event("next"));
}

private function dispatchPrevEvent(): void {
	this.dispatchEvent(new Event("prev"));
}

override public function preGeneratePdf(): String {
	var url: String = null;
	if (mode == 'query') url = "drv/drvInstructionDetailDispatch.action?method=generatePDF";
	else url = "drv/drvInstructionDetailDispatch.action?method=generatePDF";
	return url;
}

override public function preGenerateXls(): String {
	var url: String = null;
	if (mode == 'query') url = "drv/drvInstructionDetailDispatch.action?method=generateXLS";
	else url = "drv/drvInstructionDetailDispatch.action?method=generateXLS";
	return url;
}

/**
 * This method should be called on creationComplete of the datagrid 
 */
private function bindQryDataGrid(): void {
	qhothers.dgrid = resultSummaryOthers;
}

private function bindQryDGrid(): void {
	qhQuery.dgrid = resultSummaryQuery;
}

override public function preQueryInit(): void {
	
	var rndNo: Number = Math.random();
	if (this.mode == "query") {		
		super.getInitHttpService().url = "drv/drvInstructionDetailDispatch.action?";
		var reqObj: Object = new Object();
		reqObj.rnd = rndNo;
		reqObj.method = "initialExecute";
		reqObj.mode = "query";
		reqObj.SCREEN_KEY = "13004";
		super.getInitHttpService().request = reqObj;
	}
}

private function submitTransmit(): void {
	if (conformSelectedResults != null && conformSelectedResults.length == 0) {
		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.selectatleastonerecord'));
	} else {
		inxDetailConfirmRequest.url = "drv/drvInstructionDetailDispatch.action?";
		var reqObj: Object = new Object();
		reqObj.method = "doSubmit";
		reqObj.rnd = Math.random();
		reqObj.SCREEN_KEY = "13006";
		reqObj.drvTrdPkArray = conformSelectedResults;
		inxDetailConfirmRequest.request = reqObj;
		inxDetailConfirmRequest.send();
	}
}

public function handleOkSystemConfirm(event: Event): void {
	this.dispatchEvent(new Event('querySubmit'));
}



/**
 * This is the method to pass the Collection of data items
 * through the context. This will be implemented as per specifdic  
 * requriment. 
 */

//------------------ Validator Method --------------------/
private function setValidator(): void {
	var drvInstValidationModel: Object = {
		drvInstQry: {
			operationObj:opObj,
			trdDateFrom:this.trddateFrom.text,
			trdDateTo:this.trddateTo.text,
			valueDateFrom:this.valuedateFrom.text,
			valueDateTo:this.valuedateTo.text,
			transDate:this.transdate.text
		}
	};
	super._validator = new DrvInstructionValidator();
	super._validator.source = drvInstValidationModel;
	super._validator.property = "drvInstQry";
}

// -------------- Query Submit Operation -----------------/
private function decideSelectedVBoxInVStack(): void {	
	switch (opObj) {
		case DrvConstants.SEND_NEW:
			showHelp = true;
			transmitOthers.label = this.parentApplication.xResourceManager.getKeyValue('drv.inst.label.transmit');
			stackresult.selectedChild = others;
			sendNewShowCount541.includeInLayout = true;
			sendNewShowCount541.visible = true;
			sendNewShowCount543.includeInLayout = true;
			sendNewShowCount543.visible = true;
			break;
		case DrvConstants.MARK_AS_TRANSMITTED:
			showHelp = false;
			transmitOthers.label = this.parentApplication.xResourceManager.getKeyValue('drv.inst.label.markastransmit');
			stackresult.selectedChild = others;
			sendNewShowCount541.includeInLayout = false;
			sendNewShowCount541.visible = false;
			sendNewShowCount543.includeInLayout = false;
			sendNewShowCount543.visible = false;
			break;
		case DrvConstants.QUERY:
			stackresult.selectedChild = query;
			break;
		default:
			//                trace(opObj);
			//                stackresult.selectedChild = other;
			break;
	}	 
}

override public function preQuery(): void {
	opObj = this.opObjective.selectedItem != null ? this.opObjective.selectedItem.value : "";
	opObjDisp = this.opObjective.selectedItem != null ? this.opObjective.selectedItem.label : "";
	setValidator();
	qhothers.resetPageNo();
	qhQuery.resetPageNo();
	super.getSubmitQueryHttpService().url = "drv/drvInstructionDetailDispatch.action?";
	super.getSubmitQueryHttpService().method = "POST";
	super.getSubmitQueryHttpService().request = populateRequestParams();
}

/**
 * This method will populate the request parameters for the
 * submitQuery call and bind the parameters with the HTTPService
 * object.
 */
private function populateRequestParams(): Object {
	// DRV Inx quey
	var reqObj: Object = new Object();
	reqObj.SCREEN_KEY = 13005;
	reqObj.method = "submitQuery";
	reqObj.fundCode = fundPopUp.fundCode.text;
	reqObj.inventoryAccountNo = actPopUp.accountNo.text;
	reqObj.cpAccountNo = brkAccountNo.accountNo.text;
	reqObj.executionBrokerAccountNo = exeBrkAccountNo.accountNo.text;
	reqObj.openCloseFlag = (this.openClosePosition.selectedItem != null ? openClosePosition.selectedItem.value : XenosStringUtils.EMPTY_STR);
	reqObj.securityId = securityId.instrumentId.text;
	reqObj.underlyingSecurityId = underlyingSecurityId.instrumentId.text;
	reqObj.tradeDateFrom = trddateFrom.text;
	reqObj.tradeDateTo = trddateTo.text;
	reqObj.valueDateFrom = valuedateFrom.text;
	reqObj.valueDateTo = valuedateTo.text;
	reqObj.referenceNo = referenceNo.text;
	reqObj.contractReferenceNo = contractReferenceNo.text;
	reqObj.executionMarket = executionMarket.itemCombo.text;
	reqObj.dataSource = this.dataSourceValues.selectedItem != null ? this.dataSourceValues.selectedItem.value : XenosStringUtils.EMPTY_STR;
	reqObj.status = this.statusvalues.selectedItem != null ? this.statusvalues.selectedItem.value : XenosStringUtils.EMPTY_STR;
	reqObj.operationObjective = this.opObjective.selectedItem != null ? this.opObjective.selectedItem.value : XenosStringUtils.EMPTY_STR;
	reqObj.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : XenosStringUtils.EMPTY_STR;
	reqObj.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : XenosStringUtils.EMPTY_STR;
	reqObj.sortField3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : XenosStringUtils.EMPTY_STR;
	reqObj.sortField4 = this.sortField4.selectedItem != null ? StringUtil.trim(this.sortField4.selectedItem.value) : XenosStringUtils.EMPTY_STR;

	if (XenosStringUtils.equals(opObj, DrvConstants.SEND_NEW) || XenosStringUtils.equals(opObj, DrvConstants.MARK_AS_TRANSMITTED)) {
		reqObj.instructionRefNo = XenosStringUtils.EMPTY_STR;
		reqObj.acceptanceStatus = XenosStringUtils.EMPTY_STR;
		reqObj.transmissionDate = XenosStringUtils.EMPTY_STR;
	} else {
		reqObj.instructionRefNo = this.inxRefNo.text;
		reqObj.acceptanceStatus = this.ackStatus.selectedItem != null ? this.ackStatus.selectedItem.value : "";
		reqObj.transmissionDate = this.transdate.text;
	}

	reqObj.rnd = Math.random() + "";
	return reqObj;
}

override public function postQueryResultHandler(mapObj: Object): void {
	commonResult(mapObj);
}

//Show record count statistics
private function setRecordCount(tempObj: Object): void {
	if (XenosStringUtils.equals(opObj, DrvConstants.SEND_NEW)) {
		sendNewRecordCountMT541.text = 'Total:' + tempObj.totalMt541 +
			';Cancel:' + tempObj.totalCancelMt541 +
			'; \nPending:' + tempObj.totalMt541Pending +
			' (Unknown CPSSI:' + tempObj.totalMt541UnknownCpssi +
			' Missing Receiver BIC:' + tempObj.totalMt541MissingRcvBic +
			' Incomplete CP SSI(Missing BIC):' + tempObj.totalMt541IncompleteCpssi + 
			' Missing cross ref of Account:' + tempObj.totalMt541MissingAcc +
			' Missing cross ref of Instrument:' + tempObj.totalMt541MissingInstr +
			' Missing Market Place:' + tempObj.totalMt541MissingMarket +')';
		sendNewRecordCountMT543.text = 'Total:' + tempObj.totalMt543 +
			';Cancel:' + tempObj.totalCancelMt543 +
			'; \nPending:' + tempObj.totalMt543Pending +
			' (Unknown CPSSI:' + tempObj.totalMt543UnknownCpssi +
			' Missing Receiver BIC:' + tempObj.totalMt543MissingRcvBic +
			' Incomplete CP SSI(Missing BIC):' + tempObj.totalMt543IncompleteCpssi + 
			' Missing cross ref of Account:' + tempObj.totalMt543MissingAcc +
			' Missing cross ref of Instrument:' + tempObj.totalMt543MissingInstr +
			' Missing Market Place:' + tempObj.totalMt543MissingMarket +')';
		sendNewResultHeaderMT541.text = "MT541 : ";
		sendNewResultHeaderMT543.text = "MT543 : ";
	} else if (XenosStringUtils.equals(opObj, DrvConstants.QUERY)) {
		recordCountMT541.text = 'Total(Normal):' + tempObj.normal541Total + ' Transmitted:' + tempObj.normalTransmitted541Total + ' (Ack:' + tempObj.normalAck541Total + ')  Unsent:' + tempObj.normal541Unsent +
			'\nTotal(Cancel):' + tempObj.cancel541Total + ' Transmitted:' + tempObj.cancelTransmitted541Total + ' (Ack:' + tempObj.cancelAck541Total + ')  Unsent:' + tempObj.cancel541Unsent;

		recordCountMT543.text = 'Total(Normal):' + tempObj.normal543Total + ' Transmitted:' + tempObj.normalTransmitted543Total + ' (Ack:' + tempObj.normalAck543Total + ')  Unsent:' + tempObj.normal543Unsent +
			'\nTotal(Cancel):' + tempObj.cancel543Total + ' Transmitted:' + tempObj.cancelTransmitted543Total + ' (Ack:' + tempObj.cancelAck543Total + ')  Unsent:' + tempObj.cancel543Unsent;

		resultHeaderMT541.text = "MT541 : ";
		resultHeaderMT543.text = "MT543 : ";
	} else {
		recordStatistics = "";
		qhothers.recordCount.text = recordStatistics;
		qhothers.recordCount.minWidth = 620;
		qhothers.help.enabled = false;
	}
}
//common result of the query
private function commonResult(mapObj: Object): void {
	var result: String = "";
	queryResult.removeAll();
	conformSelectedResults = new Array();
	selectedResults.removeAll();
	selectAllBind = false;
	if (mapObj != null) {
		if (mapObj["errorFlag"].toString() == "error") {
			errPage.showError(mapObj["errorMsg"]);
			recordStatistics = Globals.EMPTY_STRING;
			sendNewRecordCountMT541.text = recordStatistics;
			sendNewRecordCountMT543.text = recordStatistics;
			recordCountMT541.text = recordStatistics;
			recordCountMT543.text = recordStatistics;
		} else if (mapObj["errorFlag"].toString() == "noError") {
			decideSelectedVBoxInVStack();
			errPage.clearError(super.getSubmitQueryResultEvent());
			queryResult = mapObj["row"];
			setRecordCount(queryResult[0]);
			changeCurrentState();
		} else {
			errPage.removeError();
			recordStatistics = Globals.EMPTY_STRING;
			sendNewRecordCountMT541.text = recordStatistics;
			sendNewRecordCountMT543.text = recordStatistics;
			recordCountMT541.text = recordStatistics;
			recordCountMT543.text = recordStatistics;
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		}

		var prev: Boolean = (mapObj["prevTraversable"] == "true") ? true : false;
		var next: Boolean = (mapObj["nextTraversable"] == "true") ? true : false;
		
		if (XenosStringUtils.equals(opObj, DrvConstants.MARK_AS_TRANSMITTED)) {
			qhothers.setOnResultVisibility();
			qhothers.setPrevNextVisibility(prev, next);
			qhothers.PopulateDefaultVisibleColumns();
		} else if (XenosStringUtils.equals(opObj, DrvConstants.SEND_NEW)) {
			qhothers.setOnResultVisibility();
			qhothers.setPrevNextVisibility(prev, next);
			qhothers.PopulateDefaultVisibleColumns();
		} else {
			qhQuery.setOnResultVisibility();
			qhQuery.setPrevNextVisibility(prev, next);
			qhQuery.PopulateDefaultVisibleColumns();
		}
	}
}

//--------------  Reset Operation -----------------------//

override public function preQueryResultInit(): Object {
	addCommonKeys();
	return keylist;
}

override public function postQueryResultInit(mapObj: Object): void {
	commonInit(mapObj);
}

override public function preResetQuery(): void {
	var rndNo: Number = Math.random();
	if (this.mode == 'query') {
		super.getResetHttpService().url = "drv/drvInstructionDetailDispatch.action?";
		var reqObj: Object = new Object();
		reqObj.method = "resetQueryCriteria";
		reqObj.mode = "query";
		reqObj.rnd = rndNo + "";
		super.getResetHttpService().request = reqObj;
	}
}

private function addCommonKeys(): void {
	keylist = new ArrayCollection();
	keylist.addItem("operationObjDropdownList.item");
	keylist.addItem("acceptanceStatusValueList.item");
	keylist.addItem("dataSourceValues.item");
	keylist.addItem("statusValues.item");
	keylist.addItem("sortFieldList.item");
	keylist.addItem("sortField1");
	keylist.addItem("sortField2");
	keylist.addItem("sortField3");
	keylist.addItem("sortField4");
	keylist.addItem("transmissionDate");
	keylist.addItem("openClosePositionList.item");

}
	
private function clearState():void{
	currentState = '';
    app.submitButtonInstance = submit;
}

private function commonInit(mapObj: Object): void {
	
	var selIndx1: int = 0;
	var selIndx2: int = 0;
	var selIndx3: int = 0;
	var selIndx4: int = 0;
	errPage.clearError(super.getInitResultEvent()); //clears the errors if any 

	app.submitButtonInstance = submit;
	var i: int = 0;
	var j: int = 0;
	var dateStr: String = null;
	var tempColl: ArrayCollection = new ArrayCollection();
	var initColl: ArrayCollection = new ArrayCollection();

	var sortField1Default: String;
	var sortField2Default: String;
	var sortField3Default: String;
	var sortField4Default: String;
	var sortFieldList1: ArrayCollection = new ArrayCollection();
	var sortFieldList2: ArrayCollection = new ArrayCollection();
	var sortFieldList3: ArrayCollection = new ArrayCollection();
	var sortFieldList4: ArrayCollection = new ArrayCollection();
	fundPopUp.fundCode.setFocus();
	//initiate text fields
	fundPopUp.fundCode.text = XenosStringUtils.EMPTY_STR;
	actPopUp.accountNo.text = XenosStringUtils.EMPTY_STR;
	brkAccountNo.accountNo.text = XenosStringUtils.EMPTY_STR;
	exeBrkAccountNo.accountNo.text = XenosStringUtils.EMPTY_STR;
	securityId.instrumentId.text = XenosStringUtils.EMPTY_STR;
	underlyingSecurityId.instrumentId.text = XenosStringUtils.EMPTY_STR;
	transdate.text = XenosStringUtils.EMPTY_STR;
	inxRefNo.text = XenosStringUtils.EMPTY_STR;
	trddateFrom.text=XenosStringUtils.EMPTY_STR;
	trddateTo.text=XenosStringUtils.EMPTY_STR;
	valuedateFrom.text = XenosStringUtils.EMPTY_STR;
	valuedateTo.text = XenosStringUtils.EMPTY_STR;
	referenceNo.text = XenosStringUtils.EMPTY_STR;
	contractReferenceNo.text = XenosStringUtils.EMPTY_STR;
	executionMarket.text = XenosStringUtils.EMPTY_STR;
	
	//Providing data to Operation Objective 
	tempColl = new ArrayCollection();
	initColl = new ArrayCollection();
	if (mapObj[keylist.getItemAt(0)] != null) {
		if (mapObj[keylist.getItemAt(0)] is ArrayCollection) {
			initColl = mapObj[keylist.getItemAt(0)] as ArrayCollection;
			for each(var item1: Object in initColl) {
				tempColl.addItem(item1);
			}
		} else {
			tempColl.addItem(mapObj[keylist.getItemAt(0)].toString());
		}
	}
	
	this.opObjective.dataProvider = tempColl;
	var opobj1: String = XenosStringUtils.EMPTY_STR
	

	for (j = 0; j < tempColl.length; j++) {
		if (XenosStringUtils.equals(tempColl[j].value, "SEND_NEW")){
			this.opObjective.selectedItem = tempColl[j];
			opobj1 =tempColl[j].value;
			break;
		} 
		opobj1 =tempColl[j].value;
	}
		 
	this.visibilityOfQueryScreenFields(opobj1);


	//Data Provider for ACKStatus 
	tempColl = new ArrayCollection();
	initColl = new ArrayCollection();
	tempColl.addItem({
		label: " ",
		value: " "
	});
	if (mapObj[keylist.getItemAt(1)] != null) {
		if (mapObj[keylist.getItemAt(1)] is ArrayCollection) {
			initColl = mapObj[keylist.getItemAt(1)] as ArrayCollection;
			for each(item1 in initColl) {
				tempColl.addItem(item1);
			}
		} else {
			tempColl.addItem(mapObj[keylist.getItemAt(1)].toString());
		}
	}
	this.ackStatus.dataProvider = tempColl;

	//Data Provider for Data Source  

	tempColl = new ArrayCollection();
	initColl = new ArrayCollection();
	tempColl.addItem({
		label: " ",
		value: " "
	});
	if (mapObj[keylist.getItemAt(2)] != null) {
		if (mapObj[keylist.getItemAt(2)] is ArrayCollection) {
			initColl = mapObj[keylist.getItemAt(2)] as ArrayCollection;
			for each(item1 in initColl) {
				tempColl.addItem(item1);
			}
		} else {
			tempColl.addItem(mapObj[keylist.getItemAt(2)].toString());
		}
	}
	this.dataSourceValues.dataProvider = tempColl;

	//Data Provider for Status 

	tempColl = new ArrayCollection();
	initColl = new ArrayCollection();
	tempColl.addItem({
		label: " ",
		value: " "
	});
	if (mapObj[keylist.getItemAt(3)] != null) {
		if (mapObj[keylist.getItemAt(3)] is ArrayCollection) {
			initColl = mapObj[keylist.getItemAt(3)] as ArrayCollection;
			for each(item1 in initColl) {
				tempColl.addItem(item1);
			}
		} else {
			tempColl.addItem(mapObj[keylist.getItemAt(3)].toString());
		}
	}
	this.statusvalues.dataProvider = tempColl;

	// Data provider for sort order list.

	sortField1Default = mapObj[keylist.getItemAt(5)].toString();
	sortField2Default = mapObj[keylist.getItemAt(6)].toString();
	sortField3Default = mapObj[keylist.getItemAt(7)].toString();
	sortField4Default = mapObj[keylist.getItemAt(8)].toString();
	initColl.removeAll();
	
	if (mapObj[keylist.getItemAt(4)] != null) {
		if (mapObj[keylist.getItemAt(4)] is ArrayCollection) {
			initColl = mapObj[keylist.getItemAt(4)] as ArrayCollection;
		} else {
			initColl.addItem(mapObj[keylist.getItemAt(4)].toString());
		}
	}
	
	sortFieldList1.addItem({
		label: " ",
		value: " "
	});
	sortFieldList2.addItem({
		label: " ",
		value: " "
	});
	sortFieldList3.addItem({
		label: " ",
		value: " "
	});
	sortFieldList4.addItem({
		label: " ",
		value: " "
	});

	for (i = 0; i < initColl.length; i++) {
		if (XenosStringUtils.equals(initColl[i].value, sortField1Default)) selIndx1 = i;
		else if (XenosStringUtils.equals(initColl[i].value, sortField2Default)) selIndx2 = i;
		else if (XenosStringUtils.equals(initColl[i].value, sortField3Default)) selIndx3 = i;
		else if (XenosStringUtils.equals(initColl[i].value, sortField4Default)) selIndx4 = i;

		sortFieldList1.addItem(initColl[i]);
		sortFieldList2.addItem(initColl[i]);
		sortFieldList3.addItem(initColl[i]);
		sortFieldList4.addItem(initColl[i]);
	}

	sortFieldArray[0] = sortField1;
	sortFieldArray[1] = sortField2;
	sortFieldArray[2] = sortField3;
	sortFieldArray[3] = sortField4;

	sortFieldDataSet[0] = sortFieldList1;
	sortFieldDataSet[1] = sortFieldList2;
	sortFieldDataSet[2] = sortFieldList3;
	sortFieldDataSet[3] = sortFieldList4;

	sortFieldSelectedItem[0] = sortFieldList1.getItemAt(selIndx1 + 1);
	sortFieldSelectedItem[1] = sortFieldList2.getItemAt(selIndx2 + 1);
	sortFieldSelectedItem[2] = sortFieldList3.getItemAt(selIndx3 + 1);
	sortFieldSelectedItem[3] = sortFieldList3.getItemAt(selIndx4 + 1);

	sortField1.dataProvider = sortFieldList1;
	sortField2.dataProvider = sortFieldList2;
	sortField3.dataProvider = sortFieldList3;
	sortField4.dataProvider = sortFieldList4;

	csd = new CustomizeSortOrder(sortFieldArray, sortFieldDataSet, sortFieldSelectedItem);
	csd.init();
	transmissionDate = mapObj[keylist.getItemAt(9)];

	//Data Provider for Status 

	tempColl = new ArrayCollection();
	initColl = new ArrayCollection();
	tempColl.addItem({
		label: " ",
		value: " "
	});
	if (mapObj[keylist.getItemAt(10)] != null) {
		if (mapObj[keylist.getItemAt(10)] is ArrayCollection) {
			initColl = mapObj[keylist.getItemAt(10)] as ArrayCollection;
			for each(item1 in initColl) {
				tempColl.addItem(item1);
			}
		} else {
			tempColl.addItem(mapObj[keylist.getItemAt(10)].toString());
		}
	}
	this.openClosePosition.dataProvider = tempColl;
}

private function sortOrder1Update(): void {
	csd.update(sortField1.selectedItem, 0);
}

private function sortOrder2Update(): void {
	csd.update(sortField2.selectedItem, 1);
}

private function sortOrder3Update(): void {
	csd.update(sortField3.selectedItem, 2);
}

private function sortOrder4Update(): void {
	csd.update(sortField4.selectedItem, 3);
}

/* ************  Select Multiple record in data grid *************/


public function setIfAllSelected(): void {
	if (isAllSelected()) {
		selectAllBind = true;
	} else {
		selectAllBind = false;
	}
}


public function isAllSelected(): Boolean {
	var i: Number = 0;
	if (queryResult == null) {
		return false;
	}
	for (i = 0; i < queryResult.length; i++) {
		if (queryResult.getItemAt(i).selected == false || queryResult.getItemAt(i).selected == 'false' || XenosStringUtils.isBlank(queryResult.getItemAt(i).selected)) {
			return false;
		}
	}
	if (i == queryResult.length) {
		return true;
	} else {
		return false;
	}
}


public function selectAllRecords(flag: Boolean): void {
	var i: Number = 0;
	selectedResults.removeAll();
	for (i = 0; i < queryResult.length; i++) {
		var obj: XML = queryResult.getItemAt(i) as XML;
		if (XenosStringUtils.equals(obj.operationObjective, DrvConstants.MARK_AS_TRANSMITTED) 
		|| (XenosStringUtils.equals(obj.operationObjective, DrvConstants.SEND_NEW) 
		&& !(XenosStringUtils.equals(obj.cyan, "true") 
		|| XenosStringUtils.equals(obj.pink, "true") 
		|| XenosStringUtils.equals(obj.yellow, "true") 
		|| XenosStringUtils.equals(obj.blue1, "true")
		|| XenosStringUtils.equals(obj.blue2, "true")
		|| XenosStringUtils.equals(obj.blue3, "true")))) {
			obj.selected = flag;
			queryResult.setItemAt(obj, i);
			queryResult.refresh();
			addOrRemove(obj);
		}
	}
	conformSelectedResults = selectedResults.toArray();
}

public function addOrRemove(item: Object): void {
	var i: Number;
	var tempArray: Array = new Array();
	if (item.selected == true || XenosStringUtils.equals(item.selected, "true")) {
		selectedResults.addItem(item.key);
	} else { //needs to pop
		if (selectedResults.length <= 0) return;
		var tempDrvObjs: ArrayCollection = new ArrayCollection();
		var tmpObj: Object;

		for (i = 0; i < selectedResults.length; i++) {
			tmpObj = selectedResults.getItemAt(i);
			if (tmpObj != (item.key)) {
				tempDrvObjs.addItem(tmpObj);
			}
		}
		selectedResults.removeAll();
		selectedResults = tempDrvObjs;

	}
}

public function checkSelectToModify(item: Object): void {
	var i: Number;
	if (item.selected == true || XenosStringUtils.equals(item.selected, "true")) {
		selectedResults.addItem(item.key);
	} else {
		if (selectedResults.length <= 0) return;
		var tempDrvObjs: ArrayCollection = new ArrayCollection();
		var tmpObj: Object;

		for (i = 0; i < selectedResults.length; i++) {
			tmpObj = selectedResults.getItemAt(i);
			if (tmpObj != (item.key)) {
				tempDrvObjs.addItem(tmpObj);
			}
		}
		selectedResults.removeAll();
		selectedResults = tempDrvObjs;
	}
	conformSelectedResults = selectedResults.toArray();
	setIfAllSelected();
}


// For Help Function 
private function displayHelp(): void {
	this.helpBox.visible = true;
	this.helpBox.includeInLayout = true;
	var validationtext: String = null;

	validationtext = this.parentApplication.xResourceManager.getKeyValue('drv.label.missingbrkno');
	validationtext = validationtext + '\n' + this.parentApplication.xResourceManager.getKeyValue('drv.label.missingsecuritycodecrossref');
	validationtext = validationtext + '\n' + this.parentApplication.xResourceManager.getKeyValue('drv.label.missingmarketplace');

	PopUpManager.removePopUp(helpPopup);

	helpPopup = SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication), SummaryPopup, false));

	helpPopup.title = this.parentApplication.xResourceManager.getKeyValue('drv.inst.label.color.background.info');
	helpPopup.minWidth = 400;
	helpPopup.height = 200;
	this.differentBicText.htmlText = validationtext;
	helpPopup.addChild(this.helpBox);
	PopUpManager.centerPopUp(helpPopup);
}

override public function preNext(): Object {
	var reqObj: Object = new Object();
	reqObj.method = "doNext";
	return reqObj;
}

override public function prePrevious(): Object {
	var reqObj: Object = new Object();
	reqObj.method = "doPrevious";
	return reqObj;
}

private function confirmHandler(event: ResultEvent): void {
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
		drvpopUp = DrvInstructionConfirm(PopUpManager.createPopUp(this , DrvInstructionConfirm ,true));
		drvpopUp.width = this.parentApplication.width - 300;
		drvpopUp.dataprovider = confirmResult;
		drvpopUp.noOfSelectedRecord = noOfSelected;
		drvpopUp.errPage.showError(errorInfoList);//Display the error
		drvpopUp.title = this.parentApplication.xResourceManager.getKeyValue('drv.inst.label.maintenance');
		drvpopUp.addEventListener("OkSystemConfirm",handleOkSystemConfirm);
		PopUpManager.centerPopUp(drvpopUp);
		app.submitButtonInstance = drvpopUp.okButton;
}