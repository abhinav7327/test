
import com.nri.rui.core.Globals;
import com.nri.rui.core.RendererFectory;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.renderers.ImgSummaryRenderer;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.NumberUtils;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosPopupUtils;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.fam.validators.FamPortfolioBalanceQueryValidator;
import mx.collections.ArrayCollection;
import mx.controls.ComboBox;
import mx.core.UIComponent;
import mx.events.DataGridEvent;
import mx.events.ValidationResultEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;
import com.nri.rui.core.controls.XenosHTTPServiceForSpring;

[Bindable]
public var app:XenosApplication=XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
public var baseDateItemRndr:String=XenosStringUtils.EMPTY_STR; // Needed to hold value at submit time to pass in the ItemRenderer

[Bindable]
public var editFundCodeMode:Boolean=false;

[Bindable]
public var returnContextItem:ArrayCollection=new ArrayCollection();
[Bindable]
private var commandForm:Object=new Object();
[Bindable]
private var commandFormId:String=XenosStringUtils.EMPTY_STR;

private var commandFormIdForTransaction:String=XenosStringUtils.EMPTY_STR;
private var csd:CustomizeSortOrder=null;
private var editFundCodeIndex:int=-1;
private var emptyResult:ArrayCollection=new ArrayCollection();
[Bindable]
private var errorColls:ArrayCollection=new ArrayCollection();
[Bindable]
private var fundCodeArrColl:ArrayCollection=new ArrayCollection();
private var i:int=0;

[Bindable]
private var initColl:ArrayCollection=new ArrayCollection();
private var initCompFlg:Boolean=false;

[Bindable]
private var initcol:ArrayCollection=new ArrayCollection();
private var item:Object=new Object();

private var keylist:ArrayCollection=new ArrayCollection();
[Bindable]
private var queryResult:ArrayCollection=new ArrayCollection();
private var rndNo:Number=0;
private var selIndx:int=0;

private var sortFieldArray:Array=new Array();
private var sortFieldDataSet:Array=new Array();
private var sortFieldSelectedItem:Array=new Array();
private var sortUtil:ProcessResultUtil=new ProcessResultUtil();
[Bindable]
private var tempColl:ArrayCollection=new ArrayCollection();

/**
* Sends the HttpService for reset operation.
*/
public function resetQuery():void
{
	initializePortfolioBalanceQuery.url="fam/portfolioBalanceQuery.spring";
	var reqObj:Object=new Object();
	reqObj["method"]="resetQuery";
	portfolioBalanceQueryResetRequest.send(reqObj);

}

/**
*
*/
public function submitQuery():void
{
	if (!multipleFundSelector.isAllFundSelected())
	{
		// check if fund list is empty or fund code is in edit mode
		if (fundCodeArrColl.length == 0)
		{
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.portfoliobalance.error.fundcode.empty'));
			return;
		}
		// check if fund code is in edit mode
		if (editFundCodeIndex != -1)
		{
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.portfoliobalance.error.fundcode.edit'));
			return;
		}
	}
	//Reset Page No
	qh.resetPageNo();
	//Set the request parameters
	var requestObj:Object=populateRequestParams();

	portfolioBalanceQueryRequest.request=requestObj;


	var myModel:Object={portfolioBalanceQuery: {allFundRadioFlag: this.multipleFundSelector.isAllFundSelected(), fundCodeFlag: isAnyFundCodeEntered(), baseDate: this.baseDate.text, securityCode: this.securityCode.instrumentId.text}};
	var portfolioBalanceQueryValidator:FamPortfolioBalanceQueryValidator=new FamPortfolioBalanceQueryValidator();
	portfolioBalanceQueryValidator.source=myModel;
	portfolioBalanceQueryValidator.property="portfolioBalanceQuery";

	var validationResult:ValidationResultEvent=portfolioBalanceQueryValidator.validate();

	if (validationResult.type == ValidationResultEvent.INVALID)
	{
		var errorMsg:String=validationResult.message;
		XenosAlert.error(errorMsg);
		resultHead.text="";
	}
	else
	{
		baseDateItemRndr=baseDate.text;
		resultHead.text=this.parentApplication.xResourceManager.getKeyValue('fam.portfoliobalance.result.label.balancebasis') + " " + baseDateItemRndr;

		qh.commandFormIdForPreference=famPortfolioBalanceQueryResult.commandFormIdForPreference;
		portfolioBalanceQueryRequest.send();
	}

}

/**
 * This method should be called on creationComplete of the datagrid
 */
private function bindDataGrid():void
{
	qh.dgrid=famPortfolioBalanceQueryResult;
}

/**
* Sends the HttpService for Next Set of results operation.
* This is actually server side pagination for the next set of results.
*/
private function doNext():void
{
	var reqObj:Object=new Object();
	reqObj.method="doNext";
	reqObj.rnd=Math.random() + "";
	portfolioBalanceQueryRequest.request=reqObj;
	portfolioBalanceQueryRequest.send();
}

/**
* Sends the HttpService for Previous Set of results operation.
* This is actually server side pagination for the previous set of results.
*/
private function doPrev():void
{
	var reqObj:Object=new Object();
	reqObj.method="doPrevious";
	reqObj.rnd=Math.random() + "";
	portfolioBalanceQueryRequest.request=reqObj;
	portfolioBalanceQueryRequest.send();
}

/**
   * This is for the Print button which at a  time will print all the data
   * in the dataprovider of the Datagrid object
   */
private function doPrint():void
{
}

private function dummyServiceResultHandler(event:ResultEvent):void
{
	commandFormIdForTransaction=event.result.transactionQueryCommandForm.commandFormId;
}

/**
 * Handler for fundCode selection
 */
private function fundCodeSelectionHandler(mode:String, fundCode:String, index:String="-1"):void
{
	var params:Object=new Object();
	if (XenosStringUtils.equals(mode, MultipleFundSelector.ADD))
	{
		// validation for trying to add empty fund code
		if (fundCode == XenosStringUtils.EMPTY_STR)
		{
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.portfoliobalance.error.fundcode.empty'));
			return;
		}
		params['method']="addFundCode";
		params['editFundCodeIndex']=editFundCodeIndex;
	}
	else if (XenosStringUtils.equals(mode, MultipleFundSelector.EDIT))
	{
		params['method']="editFundCode";
		params['editFundCodeIndex']=index;
	}
	else if (XenosStringUtils.equals(mode, MultipleFundSelector.DELETE))
	{
		params['method']="deleteFundCode";
		//Reset (required when the user issued Edit and then Delete)
		params['editFundCodeIndex']=-1;
		params['deleteFundCodeIndex']=index;
	}
	params['fundCode']=fundCode;
	fundCodeQueryRequest.send(params);
}

/**
* Generate the Pdf report for the entire query result set
* and will open in a separate window.
*/
private function generatePdf():void
{
	var url:String="fam/portfolioBalanceQuery.spring?method=generatePDF&commandFormId=" + commandFormId;
	var request:URLRequest=new URLRequest(url);
	request.method=URLRequestMethod.POST;
	// set menu pk in the request
	var variables:URLVariables=new URLVariables();
	variables.menuPk=this.parentApplication.mdiCanvas.getwindowKey();
	request.data=variables;
	try
	{
		navigateToURL(request, "_blank");
	}
	catch (e:Error)
	{
		trace(e);
	}
}

/**
 * Generate the XlS report for the entire query result set
 * and will open in a separate window.
 */
private function generateXls():void
{
	var url:String="fam/portfolioBalanceQuery.spring?method=generateXLS&commandFormId=" + commandFormId;
	var request:URLRequest=new URLRequest(url);
	request.method=URLRequestMethod.POST;
	// set menu pk in the request
	var variables:URLVariables=new URLVariables();
	variables.menuPk=this.parentApplication.mdiCanvas.getwindowKey();
	request.data=variables;
	try
	{
		navigateToURL(request, "_blank");
	}
	catch (e:Error)
	{
		trace(e);
	}
}

/**
* Handles fund code result
*/
private function handleFundCodeResult(event:ResultEvent):void
{

	errPage.clearError(event);
	var errorInfoList:ArrayCollection=new ArrayCollection();
	if (event.result != null && event.result.XenosErrors != null && event.result.XenosErrors.Errors != null)
	{
		if (event.result.XenosErrors.Errors.error != null)
		{
			if (event.result.XenosErrors.Errors.error is ArrayCollection)
			{
				errorInfoList=event.result.XenosErrors.Errors.error as ArrayCollection;
			}
			else
			{
				errorInfoList.addItem(event.result.XenosErrors.Errors.error);
			}
		}
		errPage.showError(errorInfoList);
		return;
	}

	var commandForm:Object=event.result.portfolioBalanceQueryCommandForm;

	// Set 'editFundCodeIndex' from Server sent XML 
	editFundCodeIndex=commandForm.editFundCodeIndex;

	// Stores elements of type 'String' i.e. Fund Code from Server sent XML
	tempColl=new ArrayCollection();

	// Get rid of all previously stored items
	fundCodeArrColl.removeAll();

	// Fill up 'tempColl' from Server sent XML
	if (commandForm.fundCodeList != null && commandForm.fundCodeList.fundCode != null)
	{
		if (commandForm.fundCodeList.fundCode is ArrayCollection)
		{
			tempColl=commandForm.fundCodeList.fundCode as ArrayCollection;
		}
		else
		{
			tempColl.addItem(commandForm.fundCodeList.fundCode);
		}

		// Fill up 'fundCodeArrColl' which is displayed in the Grid of 'MultipleFundSelector'           
		for (i=0; i < tempColl.length; i++)
		{
			var obj:Object=new Object();
			obj["fundCode"]=tempColl[i];
			obj["index"]=i;
			fundCodeArrColl.addItem(obj);
		}

	}

	// Set Fund Code if 'Edit' has been issued otherwise clear the TextInput.
	if (editFundCodeIndex >= 0 && fundCodeArrColl.length > 0)
	{
		multipleFundSelector.setFundCode(fundCodeArrColl.getItemAt(editFundCodeIndex)["fundCode"]);
	}
	else
	{
		multipleFundSelector.setFundCode(XenosStringUtils.EMPTY_STR);
	}
}

/**
* This method works as the result handler of the Initialization/Reset Http Services.
*
*/
private function initPage(event:ResultEvent):void
{
	var i:int=0;
	errPage.clearError(event); //clears the errors if any 

	commandForm=event.result.portfolioBalanceQueryCommandForm;
	commandFormId=commandForm.commandFormId;

	// reset fields

	//resultHead.text=XenosStringUtils.EMPTY_STR;
	multipleFundSelector.fundCodeSummary.enabled=true;
	multipleFundSelector.fundPopUp.fundCode.text="";
	baseDate.text=commandForm.baseDate != null ? commandForm.baseDate : "";
	securityCode.instrumentId.text=XenosStringUtils.EMPTY_STR;
	drvRefNo.text=XenosStringUtils.EMPTY_STR;
	localCcy.ccyText.text=XenosStringUtils.EMPTY_STR;
	baseCcy.ccyText.text=XenosStringUtils.EMPTY_STR;
	securityTypeList.itemCombo.text=XenosStringUtils.EMPTY_STR;
	this.multipleFundSelector.reset();
	handleFundCodeResult(event);

	// Setting the values of Long/Short type
	initColl.removeAll();
	if (commandForm.lsTypeList.item != null)
	{
		if (commandForm.lsTypeList.item is ArrayCollection)
			initColl=commandForm.lsTypeList.item as ArrayCollection;
		else
			initColl.addItem(commandForm.lsTypeList.item);
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: "", value: ""});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	lsTypeList.dataProvider=tempColl;
	// Setting the values of Include Zero List... start
	initColl.removeAll();
	if (commandForm.includeZeroList.item != null)
	{
		if (commandForm.includeZeroList.item is ArrayCollection)
		{
			initColl=commandForm.includeZeroList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(commandForm.includeZeroList.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: "", value: ""});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	includeZero.dataProvider=tempColl;
	// this will set default value as 'NO'
	includeZero.selectedItem=tempColl.getItemAt(1);
	// Setting values of the SortFields
	initColl.source=new Array();

	if (null != commandForm.sortFieldList.item)
	{
		tempColl=new ArrayCollection();
		tempColl.addItem({label: "", value: ""});
		selIndx=0;

		if (commandForm.sortFieldList.item is ArrayCollection)
		{
			initColl=commandForm.sortFieldList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(commandForm.sortFieldList.item);
		}

		for (i=0; i < initColl.length; i++)
		{
			tempColl.addItem(initColl[i]);
		}

		sortFieldArray[0]=sortField1;
		sortFieldDataSet[0]=tempColl;
		//Set the default value object           
		sortFieldSelectedItem[0]=tempColl.getItemAt(1);

	}
	else
	{
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.error.initialize.sortfield1'));
	}

	sortFieldArray[1]=sortField2;
	sortFieldDataSet[1]=tempColl;
	//Set the default value object           
	sortFieldSelectedItem[1]=tempColl.getItemAt(2);

	sortFieldArray[2]=sortField3;
	sortFieldDataSet[2]=tempColl;
	//Set the default value object           
	sortFieldSelectedItem[2]=tempColl.getItemAt(3);

	csd=new CustomizeSortOrder(sortFieldArray, sortFieldDataSet, sortFieldSelectedItem);
	csd.init();
}

/**
* This method will be called at the time of the loading this module and pressing the reset button.
*
*/
private function initPageStart():void
{
	if (!initCompFlg)
	{
		rndNo=Math.random();
		var req:Object=new Object();
		req.SCREEN_KEY=12100;
		initializePortfolioBalanceQuery.request=req;
		initializePortfolioBalanceQuery.url="fam/portfolioBalanceQuery.spring?method=initialExecute&menuType=y&rnd=" + rndNo;
		initializePortfolioBalanceQuery.send();
		dummyService.send();
	}
	else
	{
		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.initiate'));
	}


}

/**
 * Checks if any fund code is available in fundCode or fundCodeArrColl
 */
private function isAnyFundCodeEntered():Boolean
{
	if (XenosStringUtils.isBlank(this.multipleFundSelector.fundPopUp.fundCode.text) && fundCodeArrColl.length == 0)
	{
		return false;
	}
	return true;
}

/**
 * Checks wheather fundCode is duplicated or not.
 */
private function isDuplicatedFundCode(value:String):Boolean
{
	var i:int;
	var len:int=fundCodeArrColl.length;

	for each (var o:Object in fundCodeArrColl)
	{
		if (o.fundCode == value)
		{
			return true;
		}
	}
	return false;
}

/**
* This method works as the result handler of the Submit Query Http Services.
*/
private function loadResultPage(event:ResultEvent):void
{

	var rs:XML = XML(XenosHTTPServiceForSpring.getXmlResult(event));
	var cmdChildObj:XML=<commandFormIdForPortfolioBalance>{commandFormId}</commandFormIdForPortfolioBalance>
	var cmdChildObjForTransaction:XML=<commandFormId>{commandFormIdForTransaction}</commandFormId>

	if (rs.child("row").length() > 0)
	{
		errPage.clearError(event);
		queryResult.removeAll();
		try
		{
			for each (var rec:XML in rs.row)
			{
				rec.appendChild(cmdChildObj);
				rec.appendChild(cmdChildObjForTransaction);
				queryResult.addItem(rec);
			}

			changeCurrentState();
			qh.setOnResultVisibility();

			qh.setPrevNextVisibility((rs.prevTraversable == "true") ? true : false, (rs.nextTraversable == "true") ? true : false);
			qh.PopulateDefaultVisibleColumns();
		}
		catch (e:Error)
		{
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		}
	}
	else if (rs.child("Errors").length() > 0)
	{
		//some error found
		queryResult.removeAll(); // clear previous data if any as there is no result now.
		var errorInfoList:ArrayCollection=new ArrayCollection();
		//populate the error info list              
		for each (var error:XML in rs.Errors.error)
		{
			errorInfoList.addItem(error.toString());
		}
		errPage.showError(errorInfoList); //Display the error
	}
	else
	{
		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		queryResult.removeAll(); // clear previous data if any as there is no result now.
		errPage.removeError(); //clears the errors if any
	}
}

/**
  * Pass the Collection of data items
  * through the context to the account popup. This will be implemented as per specifdic
  * requriment.
  */
private function populateContext():ArrayCollection
{
	//pass the context data to the popup
	var myContextList:ArrayCollection=new ArrayCollection();

	//passing counter party type            
	var cpTypeArray:Array=new Array(1);
	cpTypeArray[0]="INTERNAL";
	myContextList.addItem(new HiddenObject("invCPTypeContext", cpTypeArray));

	//passing account status                
	var actStatusArray:Array=new Array(1);
	actStatusArray[0]="OPEN";
	myContextList.addItem(new HiddenObject("accountStatus", actStatusArray));
	return myContextList;
}

/**
* Populate the request parameters for the
* submitQuery call and bind the parameters with the HTTPService
* object.
*/
private function populateRequestParams():Object
{

	var reqObj:Object=new Object();
	reqObj["SCREEN_KEY"]=12127;
	reqObj["method"]="submitQuery";
	reqObj["allFundRadioFlag"]=this.multipleFundSelector.isAllFundSelected();
	reqObj["fundCode"]=this.multipleFundSelector.fundPopUp.fundCode.text;
	reqObj["baseDate"]=this.baseDate.text;
	reqObj["securityCode"]=this.securityCode.instrumentId.text;
	reqObj["drvRefNo"]=this.drvRefNo.text;
	reqObj["localCcy"]=this.localCcy.ccyText.text;
	reqObj["baseCcy"]=this.baseCcy.ccyText.text;
	reqObj["securityType"]=this.securityTypeList.itemCombo.text;
	reqObj["lsType"]=this.lsTypeList.selectedItem != null ? this.lsTypeList.selectedItem.value : XenosStringUtils.EMPTY_STR;
	reqObj["includeZero"]=this.includeZero.selectedItem != null ? this.includeZero.selectedItem.value : XenosStringUtils.EMPTY_STR;
	reqObj["sortField1"]=this.sortField1.selectedItem != null ? this.sortField1.selectedItem.value : XenosStringUtils.EMPTY_STR;
	reqObj["sortField2"]=this.sortField2.selectedItem != null ? this.sortField2.selectedItem.value : XenosStringUtils.EMPTY_STR;
	reqObj["sortField3"]=this.sortField3.selectedItem != null ? this.sortField3.selectedItem.value : XenosStringUtils.EMPTY_STR;

	return reqObj;
}

/**
*
*/
private function saveScreenCriteria():void
{
	var params:Object=new Object;
	initializePortfolioBalanceQuery.url="fam/portfolioBalanceQuery.spring?method=saveFormCriteria&commandFormId=" + commandFormId;
	initializePortfolioBalanceQuery.send();
}

/**
*
*/
private function sortOrder1Update():void
{
	csd.update(sortField1.selectedItem, 0);
}

/**
*
*/
private function sortOrder2Update():void
{
	csd.update(sortField2.selectedItem, 1);
}
