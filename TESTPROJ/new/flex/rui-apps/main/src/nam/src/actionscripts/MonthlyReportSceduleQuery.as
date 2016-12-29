// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.RendererFectory;
import com.nri.rui.core.containers.SummaryPopup;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.renderers.ImgSummaryRenderer;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;

import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.net.navigateToURL;

import mx.collections.ArrayCollection;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.Application;
import mx.core.UIComponent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;

[Bindable]
private var app:XenosApplication=XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);

[Bindable]
public var summaryResult:ArrayCollection=new ArrayCollection();
private var sortFieldArray:Array=new Array();
private var sortFieldDataSet:Array=new Array();
private var sortFieldSelectedItem:Array=new Array();
private var sortUtil:ProcessResultUtil=new ProcessResultUtil();
private var csd:CustomizeSortOrder=null;

 [Bindable]
 public var selectedScheduleRecords:ArrayCollection = new ArrayCollection();  
 [Bindable] 
 public var selectAllBind:Boolean=false;

 public var summaryPopup:SummaryPopup;

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
	req.SCREEN_KEY="13002";
	initMvrScheduleQuery.request=req;
	initMvrScheduleQuery.url="nam/mvrScheduleQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
	initMvrScheduleQuery.send();
}

public function resetQuery():void
{
	resetFields();
	initMvrScheduleQuery.url="nam/mvrScheduleQueryDispatch.action?method=initialExecute";
	initMvrScheduleQuery.send();
}

private function resetFields():void
{
	this.fundPopUp.fundCode.text = "";
	this.userId.text = "";
	this.tempOrFinal.selectedIndex = 0;
	this.scheduleType.selectedIndex = 0;
	this.referenceNo.text = "";
}

/**
* This method works as the result handler of the Initialization/Reset Http Services.
* Once initial data is fetched from database to fill some form data, this method works
* to actually show the data.
*/
private function initPage(event:ResultEvent):void
{
	var i:int=0;
	var initColl:ArrayCollection=new ArrayCollection();
	var tempColl:ArrayCollection;
	var selIndx:int=0;

	//variables to hold the default values from the server
	var sortField1Default:String=event.result.scheduleQueryActionForm.sortField1;
	var sortField2Default:String=event.result.scheduleQueryActionForm.sortField2;
	var sortField3Default:String=event.result.scheduleQueryActionForm.sortField3;
	
	// Temporary/Final List
	initColl.removeAll();
	if (event.result.scheduleQueryActionForm.tempOrFinalList.item != null)
	{
		if (event.result.scheduleQueryActionForm.tempOrFinalList.item is ArrayCollection)
		{
			initColl=event.result.scheduleQueryActionForm.tempOrFinalList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.scheduleQueryActionForm.tempOrFinalList.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	this.tempOrFinal.dataProvider=tempColl;

	//ScheduleType List
	initColl.removeAll();
	if (event.result.scheduleQueryActionForm.scheduleTypeList.item != null)
	{
		if (event.result.scheduleQueryActionForm.scheduleTypeList.item is ArrayCollection)
		{
			initColl=event.result.scheduleQueryActionForm.scheduleTypeList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.scheduleQueryActionForm.scheduleTypeList.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	this.scheduleType.dataProvider=tempColl;
	
	// Setting values of the SortField1
	initColl.removeAll();
	if (null != event.result.scheduleQueryActionForm.sortFieldList1.item)
	{
		tempColl=new ArrayCollection();
		tempColl.addItem({label: " ", value: " "});
		selIndx=0;

		if (event.result.scheduleQueryActionForm.sortFieldList1.item is ArrayCollection)
			initColl=event.result.scheduleQueryActionForm.sortFieldList1.item as ArrayCollection;
		else
			initColl.addItem(event.result.scheduleQueryActionForm.sortFieldList1.item);

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

	//Setting values of the SortField2
	initColl.removeAll();
	if (null != event.result.scheduleQueryActionForm.sortFieldList2.item)
	{
		tempColl=new ArrayCollection();
		tempColl.addItem({label: " ", value: " "});
		selIndx=0;

		if (event.result.scheduleQueryActionForm.sortFieldList2.item is ArrayCollection)
			initColl=event.result.scheduleQueryActionForm.sortFieldList2.item as ArrayCollection;
		else
			initColl.addItem(event.result.scheduleQueryActionForm.sortFieldList2.item);

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

	//Setting values of the SortField3
	initColl.removeAll();
	if (null != event.result.scheduleQueryActionForm.sortFieldList3.item)
	{
		tempColl=new ArrayCollection();
		tempColl.addItem({label: " ", value: " "});
		selIndx=0;

		if (event.result.scheduleQueryActionForm.sortFieldList3.item is ArrayCollection)
			initColl=event.result.scheduleQueryActionForm.sortFieldList3.item as ArrayCollection;
		else
			initColl.addItem(event.result.scheduleQueryActionForm.sortFieldList3.item);

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
	qh.resetPageNo();
	var requestObj:Object=populateRequestParams();
	mvrScheduleSubmitQuery.request=requestObj;
	mvrScheduleSubmitQuery.url="nam/mvrScheduleQueryDispatch.action";
	mvrScheduleSubmitQuery.send();
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
				
				 for(var i:int = 0; i < summaryResult.length; i++)
				 {
                   summaryResult[i]['selected'] = false;   //['selected'] = false;                   
                 }
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
	selectedScheduleRecords.removeAll();
	selectAllBind=false;
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
	
	reqObj.fundCode=this.fundPopUp.fundCode.text;
	reqObj.userId=this.userId.text;
	reqObj.referenceNo =this.referenceNo.text;
	reqObj.tempOrFinal=this.tempOrFinal.selectedItem != null ? StringUtil.trim(this.tempOrFinal.selectedItem.value) : Globals.EMPTY_STRING;
	reqObj.scheduleType=this.scheduleType.selectedItem != null ? StringUtil.trim(this.scheduleType.selectedItem.value) : Globals.EMPTY_STRING;
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
	url="nam/mvrScheduleQueryDispatch.action?method=generateXLS";

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
	url="nam/mvrScheduleQueryDispatch.action?method=generatePDF";

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
	mvrScheduleSubmitQuery.request=reqObj;
	mvrScheduleSubmitQuery.send();
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
	mvrScheduleSubmitQuery.request=reqObj;
	mvrScheduleSubmitQuery.send();
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

// ################## Handling CheckBoxes #########################33
//************* To fetch selected records *******************
public function checkSelectToModify(item:Object):void 
{
    var i:Number;
    var tempArray:Array = new Array();
    if(item.selected == 'true')
    {
         // needs to insert
        var obj:Object=new Object();
        
        obj.reportGenPlanPk = item.reportGenPlanPk;          
        
        selectedScheduleRecords.addItem(obj);
    }
    else
    { //needs to pop
        tempArray=selectedScheduleRecords.toArray();
        selectedScheduleRecords.removeAll();
        for(i=0; i<tempArray.length; i++)
        {
            if(tempArray[i].reportGenPlanPk != item.reportGenPlanPk)
            {
                selectedScheduleRecords.addItem(tempArray[i]);
            }
        }                
    }        
    setIfAllSelected();                
}
    
public function selectAllRecords(flag:Boolean): void
{
    var i:Number = 0;
    //trace("flag = " + flag);
    selectedScheduleRecords.removeAll();
    var tempColl : ArrayCollection = resultSummary.dataProvider as ArrayCollection;
    for(i=0; i<tempColl.length; i++)
    {
        tempColl[i]['selected'] = flag;
        addOrRemove(tempColl[i]);
    }
    summaryResult.refresh();
    resultSummary.invalidateDisplayList();
   // btnRecycle.setFocus();               
}
    
public function addOrRemove(item:Object):void 
{
    var i:Number;
    var tempArray:Array = new Array();
    //trace("item.selected=" + item.selected + " :: item.messagePk " + item.messagePk + " : " + (item.selected == true));
    if(item.selected == 'true' || item.selected == true)
    { 
        var obj:Object=new Object();
        obj.reportGenPlanPk = item.reportGenPlanPk;        
        selectedScheduleRecords.addItem(obj);       
    }
    else
    { //needs to pop
        tempArray=selectedScheduleRecords.toArray();
        selectedScheduleRecords.removeAll();
        for(i=0; i<tempArray.length; i++)
        {
            if(tempArray[i].reportGenPlanPk != item.reportGenPlanPk)
                selectedScheduleRecords.addItem(tempArray[i]);
        }
    }        
}

public function setIfAllSelected() : void 
{
    if(isAllSelected())
    {
        selectAllBind=true;
    } 
    else 
    {
        selectAllBind=false;
    }                     
}

public function isAllSelected(): Boolean 
{
    var i:Number = 0;
    if(summaryResult == null)
    {
    	return false;
    }
    for(i=0; i<summaryResult.length; i++)
    {
        if(summaryResult[i].selected == 'false') 
        {
            return false;
        }
    }
    
    if(i == summaryResult.length) 
    {
        return true;
    }
    else 
    {
        return false;
    }
}

// ################## End Handling CheckBoxes #########################33

public function showDeleteModule():void 
{
    var parentApp :UIComponent = UIComponent(this.parentApplication);        
    if(selectedScheduleRecords.length < 1)
    {
        XenosAlert.error(Application.application.xResourceManager.getKeyValue('nam.monthlyReport.Delete.select.atleastone.record'));
        return;
    }

    summaryPopup = SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
    summaryPopup.title = "Delete - Monthly Valuation Report Schedule";
    summaryPopup.width = 840;
    summaryPopup.height = 445;
    PopUpManager.centerPopUp(summaryPopup);
    summaryPopup.owner = this;
    var rndNo:Number = Math.random();
    summaryPopup.moduleUrl = "assets/appl/nam/MonthlyReportScheduleCancel.swf?rnd="+rndNo;       
}

