
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.nam.validators.FundConfigQueryValidator;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.ValidationResultEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;


[Bindable]
private var app:XenosApplication=XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);

[Bindable]
private var queryResult:ArrayCollection=new ArrayCollection();
private var keylist:ArrayCollection=new ArrayCollection();

[Bindable]
private var mode:String="query";
[Bindable]
private var summaryResult:ArrayCollection=new ArrayCollection();
private var sortFieldArray:Array=new Array();
private var sortFieldDataSet:Array=new Array();
private var sortFieldSelectedItem:Array=new Array();
private var sortUtil:ProcessResultUtil=new ProcessResultUtil();

private var csd:CustomizeSortOrder=null;

private function changeCurrentState():void
{
	currentState="result";
}

/**
* This method should be called on creationComplete of the datagrid
*/
private function bindDataGrid():void
{
	qh.dgrid=resultSummary;
}

/**
 * For Initializing the Fund Configuration Query Screen.
 * Dispatches an event
 */
public function initPageStart():void
{
	var rndNo:Number=Math.random();
	var req:Object=new Object();
	req.SCREEN_KEY="13000";
	initFundQuery.request=req;
	initFundQuery.url="nam/fundConfigQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
	initFundQuery.send();
}

public function resetQuery():void
{
	initFundQuery.url="nam/fundConfigQueryDispatch.action?method=initialExecute";
	initFundQuery.send();
}

/**
* This method works as the result handler of the Initialization/Reset Http Services.
* Once initial data is fetched from database to fill some form data, this method works
* to actually show the data.
*/
private function initPage(event:ResultEvent):void
{

	this.resetFormValues();
	var i:int=0;
	var initColl:ArrayCollection=new ArrayCollection();
	var tempColl:ArrayCollection;
	var selIndx:int=0;

	//variables to hold the default values from the server
	var sortField1Default:String=event.result.fundConfigQueryActionForm.sortField1;
	var sortField2Default:String=event.result.fundConfigQueryActionForm.sortField2;
	var sortField3Default:String=event.result.fundConfigQueryActionForm.sortField3;

	errPage.clearError(event); //clears the errors if any 

	//1. Setting values of the Office Id
	initColl.removeAll();
	if(event.result.fundConfigQueryActionForm.officeIdValues != null)
	{
		if (event.result.fundConfigQueryActionForm.officeIdValues.officeId != null)
		{
			if (event.result.fundConfigQueryActionForm.officeIdValues.officeId is ArrayCollection)
			{
				initColl=event.result.fundConfigQueryActionForm.officeIdValues.officeId as ArrayCollection;
			}
			else
			{
				initColl.addItem(event.result.fundConfigQueryActionForm.officeIdValues.officeId);
			}
		}
		
	}

	tempColl=new ArrayCollection();
	tempColl.addItem("");
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	officeIdList.dataProvider=tempColl;

	//2. Setting values of the Status
	initColl.removeAll();
	if (event.result.fundConfigQueryActionForm.statusValues.item != null)
	{
		if (event.result.fundConfigQueryActionForm.statusValues.item is ArrayCollection)
		{
			initColl=event.result.fundConfigQueryActionForm.statusValues.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.fundConfigQueryActionForm.statusValues.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);

	}
	statusList.dataProvider=tempColl;

	//3. Setting values of the Fund Category
	initColl.removeAll();
	if (event.result.fundConfigQueryActionForm.fundCategoryList.item != null)
	{
		if (event.result.fundConfigQueryActionForm.fundCategoryList.item is ArrayCollection)
		{
			initColl=event.result.fundConfigQueryActionForm.fundCategoryList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.fundConfigQueryActionForm.fundCategoryList.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);

	}
	fundCategoryList.dataProvider=tempColl;

	//4. Setting values of the SortField1
	initColl.removeAll();
	if (null != event.result.fundConfigQueryActionForm.sortFieldList1.item)
	{
		tempColl=new ArrayCollection();
		tempColl.addItem({label: " ", value: " "});
		selIndx=0;

		if (event.result.fundConfigQueryActionForm.sortFieldList1.item is ArrayCollection)
			initColl=event.result.fundConfigQueryActionForm.sortFieldList1.item as ArrayCollection;
		else
			initColl.addItem(event.result.fundConfigQueryActionForm.sortFieldList1.item);

		for (i=0; i < initColl.length; i++)
		{

			if (XenosStringUtils.equals((initColl[i].value), sortField1Default))
			{
				selIndx=i;
			}
			tempColl.addItem(initColl[i]);
		}
		sortFieldArray[0]=sortField1;
		sortFieldDataSet[0]=tempColl;
		//Set the default value object
		sortFieldSelectedItem[0]=tempColl.getItemAt(selIndx + 1);

	}
	else
	{
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fnd.fundquery.msg.error.load.sortfieldlist', new Array("1")));
	}


	//5. Setting values of the SortField2
	initColl.removeAll();
	if (null != event.result.fundConfigQueryActionForm.sortFieldList2.item)
	{
		tempColl=new ArrayCollection();
		tempColl.addItem({label: " ", value: " "});
		selIndx=0;

		if (event.result.fundConfigQueryActionForm.sortFieldList2.item is ArrayCollection)
			initColl=event.result.fundConfigQueryActionForm.sortFieldList2.item as ArrayCollection;
		else
			initColl.addItem(event.result.fundConfigQueryActionForm.sortFieldList2.item);

		for (i=0; i < initColl.length; i++)
		{
			if (XenosStringUtils.equals((initColl[i].value), sortField2Default))
			{
				selIndx=i;
			}
			tempColl.addItem(initColl[i]);
		}
		sortFieldArray[1]=sortField2;
		sortFieldDataSet[1]=tempColl;
		//Set the default value object
		sortFieldSelectedItem[1]=tempColl.getItemAt(selIndx + 1);

	}
	else
	{
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fnd.fundquery.msg.error.load.sortfieldlist', new Array("2")));
	}


	//6. Setting values of the SortField3
	initColl.removeAll();
	if (null != event.result.fundConfigQueryActionForm.sortFieldList3.item)
	{
		tempColl=new ArrayCollection();
		tempColl.addItem({label: " ", value: " "});
		selIndx=0;

		if (event.result.fundConfigQueryActionForm.sortFieldList3.item is ArrayCollection)
			initColl=event.result.fundConfigQueryActionForm.sortFieldList3.item as ArrayCollection;
		else
			initColl.addItem(event.result.fundConfigQueryActionForm.sortFieldList3.item);

		for (i=0; i < initColl.length; i++)
		{
			if (XenosStringUtils.equals((initColl[i].value), sortField3Default))
			{
				selIndx=i;
			}
			tempColl.addItem(initColl[i]);
		}
		sortFieldArray[2]=sortField3;
		sortFieldDataSet[2]=tempColl;
		//Set the default value object
		sortFieldSelectedItem[2]=tempColl.getItemAt(selIndx + 1);

	}
	else
	{
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fnd.fundquery.msg.error.load.sortfieldlist', new Array("3")));
	}

	csd=new CustomizeSortOrder(sortFieldArray, sortFieldDataSet, sortFieldSelectedItem);
	csd.init();

}

/**
 * Method for updating the other two sortfields after any change in the sortfield1
 */
private function sortOrder1Update():void
{
	csd.update(sortField1.selectedItem, 0);
}

/**
 * Method for updating the other one sortfields after any change in the sortfield2
 */
private function sortOrder2Update():void
{
	csd.update(sortField2.selectedItem, 1);
}

/**
 * It sends/submits the query after validating the user input data.
 */
public function submitQuery():void
{
	var myModel:Object={fundQuery: 
	{
		openDateFrom: this.openDateFrom.text, 
		openDateTo: this.openDateTo.text, 
		closeDateFrom: this.closeDateFrom.text, 
		closeDateTo : this.closeDateTo.text, 
		entryDateFrom: this.entryDateFrom.text, 
		entryDateTo: this.entryDateTo.text, 
		lastEntryDateFrom: this.lastEntryDateFrom.text, 
		lastEntryDateTo: this.lastEntryDateTo.text}
	};
	var fundConfigQueryValidator:FundConfigQueryValidator=new FundConfigQueryValidator();
	fundConfigQueryValidator.source=myModel;
	fundConfigQueryValidator.property="fundQuery";

	var validationResult:ValidationResultEvent=fundConfigQueryValidator.validate();
	if (validationResult.type == ValidationResultEvent.INVALID)
	{
		var errorMsg:String=validationResult.message;
		XenosAlert.error(errorMsg);
	}
	else
	{
		//Reset Page No
		qh.resetPageNo();
		//Set the request parameters
		var requestObj:Object=populateRequestParams();

		fundConfigSubmitQuery.request=requestObj;
		fundConfigSubmitQuery.url="nam/fundConfigQueryDispatch.action";
		fundConfigSubmitQuery.send();
	}
}

/**
 * Result Event for Submit Query and Load the summary page records
 */
private function loadSummaryPage(event:ResultEvent):void
{

	var rs:XML=XML(event.result);
	if (null != event)
	{
		if (rs.child("row").length() > 0)
		{
			errPage.clearError(event);
			summaryResult.removeAll();
			try
			{
				for each (var rec:XML in rs.row)
				{
					summaryResult.addItem(rec);
				}

				changeCurrentState();
				qh.setOnResultVisibility();

				qh.setPrevNextVisibility((rs.prevTraversable == "true") ? true : false, (rs.nextTraversable == "true") ? true : false);
				qh.PopulateDefaultVisibleColumns();
				//replace null objects in datagrid with empty string
				summaryResult=ProcessResultUtil.process(summaryResult, resultSummary.columns);
				summaryResult.refresh();
			}
			catch (e:Error)
			{
				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			}
		}
		else if (rs.child("Errors").length() > 0)
		{
			//some error found
			summaryResult.removeAll(); // clear previous data if any as there is no result now.
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
			summaryResult.removeAll(); // clear previous data if any as there is no result now.
			errPage.removeError(); //clears the errors if any
		}
	}
}

/**
*  This method resets all the values in the form.
*/
private function resetFormValues():void
{
	this.fundName.text="";
	this.fundPopUp.fundCode.text="";
	this.openDateFrom.text="";
	this.openDateTo.text="";
	this.openedBy.text="";
	this.closeDateFrom.text="";
	this.closeDateTo.text="";
	this.closedBy.text="";
	this.entryDateFrom.text="";
	this.entryDateTo.text="";
	this.lastEntryDateFrom.text="";
	this.lastEntryDateTo.text="";
	this.entryBy.text="";
	this.lastEntryBy.text="";
}

/**
* This method will populate the request parameters for the
* submitQuery call and bind the parameters with the HTTPService
* object.
*/
private function populateRequestParams():Object
{
	var reqObj:Object=new Object();
	reqObj.SCREEN_KEY=62;
	reqObj.method="submitQuery";

	reqObj.officeId=this.officeIdList.selectedItem != null ? StringUtil.trim(this.officeIdList.selectedItem.toString()) : Globals.EMPTY_STRING;
	reqObj.fundName=this.fundName.text;
	reqObj.fundCode=this.fundPopUp.fundCode.text;
	reqObj.fundCategory=this.fundCategoryList.selectedItem != null ? StringUtil.trim(this.fundCategoryList.selectedItem.value) : Globals.EMPTY_STRING;
	reqObj.openDateFrom=this.openDateFrom.text;
	reqObj.openDateTo=this.openDateTo.text;
	reqObj.openedBy=this.openedBy.text;
	reqObj.closeDateFrom=this.closeDateFrom.text;
	reqObj.closeDateTo=this.closeDateTo.text;
	reqObj.closedBy=this.closedBy.text;
	reqObj.entryDateFrom=this.entryDateFrom.text;
	reqObj.entryDateTo=this.entryDateTo.text;
	reqObj.lastEntryDateFrom=this.lastEntryDateFrom.text;
	reqObj.lastEntryDateTo=this.lastEntryDateTo.text;
	reqObj.entryBy=this.entryBy.text;
	reqObj.lastEntryBy=this.lastEntryBy.text;
	reqObj.status=this.statusList.selectedItem != null ? StringUtil.trim(this.statusList.selectedItem.value) : Globals.EMPTY_STRING;
	reqObj.sortField1=this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : Globals.EMPTY_STRING;
	reqObj.sortField2=this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : Globals.EMPTY_STRING;
	reqObj.sortField3=this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : Globals.EMPTY_STRING;

	reqObj.rnd=Math.random() + "";
	return reqObj;
}

/**
 * This is for the Print button which at a  time will print all the data
 * in the dataprovider of the Datagrid object
 */
private function doPrint():void
{

}

/**
 * This will generate the Xls report for the entire query result set
 * and will open in a separate window.
 */
private function generateXls():void
{

	var url:String="";
	url="nam/fundConfigQueryDispatch.action?method=generateXLS";

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
		// handle error here
		trace(e);
	}
}

/**
* This will generate the Pdf report for the entire query result set
* and will open in a separate window.
*/
private function generatePdf():void
{

	var url:String="";
	url="nam/fundConfigQueryDispatch.action?method=generatePDF";

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
		// handle error here
		trace(e);
	}
}

/**
 * This method sends the HttpService for Next Set of results operation.
 * This is actually server side pagination for the next set of results.
 */
private function doNext():void
{
	var reqObj:Object=new Object();
	reqObj.method="doNext";
	reqObj.rnd=Math.random() + "";
	fundConfigSubmitQuery.request=reqObj;
	fundConfigSubmitQuery.send();
}

/**
 * This method sends the HttpService for Previous Set of results operation.
 * This is actually server side pagination for the previous set of results.
 */
private function doPrev():void
{
	var reqObj:Object=new Object();
	reqObj.method="doPrevious";
	reqObj.rnd=Math.random() + "";
	fundConfigSubmitQuery.request=reqObj;
	fundConfigSubmitQuery.send();
}

private function addColumn():void
{
	var dg:DataGridColumn=new DataGridColumn();
	dg.dataField="";
	dg.editable=false;
	dg.headerText="";
	dg.width=40;
	dg.itemRenderer=new RendererFectory(ImgSummaryRenderer);

	var cols:Array=resultSummary.columns;
	cols.unshift(dg);
	resultSummary.columns=cols;
}

/**
 * Method to change text to uppercase for fund name.
 */
private function changeToUpperCase():void
{
	this.fundName.text=fundName.text.toUpperCase()
}
