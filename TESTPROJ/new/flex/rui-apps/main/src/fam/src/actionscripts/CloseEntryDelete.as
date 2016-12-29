// ActionScript file


import com.nri.rui.core.Globals;
import com.nri.rui.core.containers.SummaryPopup;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosHTTPServiceForSpring;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.fam.validators.FamCloseEntryDeleteValidator;

import mx.collections.ArrayCollection;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.ValidationResultEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;
// number of funds currently present in the list
private static var fundCodeListSize:int=0;

[Bindable]
public var app:XenosApplication=XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);

[Bindable]
public var editFundCodeMode:Boolean=false;

//private var tempColl:ArrayCollection = new ArrayCollection();
//Items returning through context - Non display objects for accountPopup
[Bindable]
public var returnContextItem:ArrayCollection=new ArrayCollection();
[Bindable]
private var commandFormId:String="";
private var csd:CustomizeSortOrder=null;

private var editFundCodeIndex:int=-1;
private var emptyResult:ArrayCollection=new ArrayCollection();

[Bindable]
private var errorColls:ArrayCollection=new ArrayCollection();
private var i:int=0;


[Bindable]
private var initColl:ArrayCollection=new ArrayCollection();
private var initCompFlg:Boolean=false;

[Bindable]
private var initcol:ArrayCollection=new ArrayCollection();
private var item:Object=new Object();

private var keylist:ArrayCollection=new ArrayCollection();
//maximum number of fund that can be selected
private var maxFundCodeSummarySize:int=3;
[Bindable]
private var queryResult:ArrayCollection=new ArrayCollection();
private var rndNo:Number=0;

private var sPopup:SummaryPopup;
private var selIndx:int=0;

private var sortFieldArray:Array=new Array();
private var sortFieldDataSet:Array=new Array();
private var sortFieldSelectedItem:Array=new Array();
[Bindable]
private var tempColl:ArrayCollection=new ArrayCollection();
[Bindable]
private var fundCodeArrColl:ArrayCollection=new ArrayCollection();

//Default Sort Column 1     
public static const FUND_CODE: String = "fund_code";
//Default Sort Column 2 
public static const ACCOUNTING_CLOSING_TYPE: String = "closing_type";
//Default Sort Column 3 
public static const CLOSING_DATE: String = "closing_date";

public function closeHandler(event:CloseEvent):void
{
	//dispatchEvent(new Event("querySubmit"));
	this.sendReq();
	sPopup.removeMe();
}

public function deleteFundCode(obj:Object):void
{
	var params:Object=new Object;
	params['fundCode']=obj.fundCode;
	params['method']="deleteFundCode";
	params['deleteFundCodeIndex']=obj.index;
	fundCodeQueryRequest.send(params);
}

public function editFundCode(obj:Object):void
{
	var params:Object=new Object;
	params['fundCode']=obj["fundCode"];
	params['method']="editFundCode";
	params['editFundCodeIndex']=obj["index"];
	fundCodeQueryRequest.send(params);
}

public function getFundCodeIndex(data:Object):Boolean
{
	//Alert.show("data[index]="+data["index"]+" editFundCodeIndex="+editFundCodeIndex);
	if (data["index"] == editFundCodeIndex)
	{
		return false;
	}
	else
	{
		return true;
	}
}

/* private function handleAdd(event:MouseEvent):void{
	 XenosAlert.info("Add Closing Configuration");
 }*/

public function openAddEntryPopUp():void
{

	var parentApp:UIComponent=UIComponent(this.parentApplication);
	sPopup=SummaryPopup(PopUpManager.createPopUp(parentApp, SummaryPopup, true));
	sPopup.addEventListener(CloseEvent.CLOSE, closeHandler, false, 0, true);
	sPopup.title=this.parentApplication.xResourceManager.getKeyValue('fam.closing.entry.window.title');
	sPopup.width=parentApp.width - 400;
	sPopup.height=parentApp.height - 240;
	PopUpManager.centerPopUp(sPopup);
	sPopup.moduleUrl="assets/appl/fam/CloseEntry.swf?commandFormId=" + commandFormId+"&closingMonth="+this.closingDate.text;

}

/**
* This method sends the HttpService for reset operation.
*
*/

public function resetQuery():void
{
	var reqObj:Object=new Object();
	reqObj["method"]="resetQuery";
	closeEntryDeleteResetQueryRequest.send(reqObj);
}


public function submitQuery():void
{
	if (!multipleFundSelector.isAllFundSelected())
	{
		// check if fund list is empty or fund code is in edit mode
		if (fundCodeArrColl.length == 0)
		{
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.closeentry.error.fundcode.empty'));
			return;
		}
		// check if fund code is in edit mode
		if (editFundCodeIndex != -1)
		{
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.closeentry.error.fundcode.edit'));
			return;
		}
	}
	
	if (multipleFundSelector.isAllFundSelected())
	{
		// check if fund list is empty or fund code is in edit mode
		if (XenosStringUtils.isBlank(closingDate.text))
		{
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.label.error.closemonth'));
			return;
		}
		// check if fund code is in edit mode
		if (XenosStringUtils.isBlank(this.userId.employeeText.text))
		{
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.label.error.empty.user.id'));
			return;
		}
	}
	
	//Reset Page No
	qh.resetPageNo();
	//Set the request parameters
	
    var myModel:Object={
                    closeEntry:{                                 
                         transClosingDate: this.closingDate.text
                    }
     }; 
	var closeEntryDeleteValidator:FamCloseEntryDeleteValidator=new FamCloseEntryDeleteValidator();
	closeEntryDeleteValidator.source=myModel;
	closeEntryDeleteValidator.property="closeEntry";

	var validationResult:ValidationResultEvent=closeEntryDeleteValidator.validate();
	if (validationResult.type == ValidationResultEvent.INVALID) {
		var errorMsg:String=validationResult.message;
		//trace(errorMsg);
		XenosAlert.error(errorMsg);
	} else {
		sendReq();
		qh.commandFormIdForPreference = famClosingQueryResult.commandFormIdForPreference;
	}
}

public function sendReq():void {
	var requestObj:Object=populateRequestParams();
	closeEntryDeleteQueryRequest.request=requestObj;
	closeEntryDeleteQueryRequest.send();
}

private function LoadResultPage(event:ResultEvent):void
{
	//changeColumnOrder(event);
	 var rs:XML = XML(XenosHTTPServiceForSpring.getXmlResult(event));
	/* XenosAlert.info(rs.toXMLString()); */
	var cmdChildObj:XML =
     <commandFormId>{commandFormId}</commandFormId>
	if (null != event)
	{
		if (rs.child("row").length() > 0)
		{
			errPage.clearError(event);
			queryResult.removeAll();
			try
			{
				for each (var rec:XML in rs.row)
				{
					rec.appendChild(cmdChildObj);                    	
                    queryResult.addItem(rec);					
				}

				changeCurrentState();
				qh.setOnResultVisibility();

				qh.setPrevNextVisibility((rs.prevTraversable == "true") ? true : false, (rs.nextTraversable == "true") ? true : false);
				qh.PopulateDefaultVisibleColumns();
				addButton.visible=true;
				app.submitButtonInstance = addButton;
				this.addButton.setFocus();
			}
			catch (e:Error)
			{
				//XenosAlert.error(e.toString() + e.message);
				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.label.query.noresult'));
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
			app.submitButtonInstance = addButton;
			this.addButton.setFocus();
			changeCurrentState(); 
			errPage.removeError(); //clears the errors if any
			queryResult.removeAll(); // clear previous data if any as there is no result now.
			queryResult.refresh();
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('fam.label.query.noresult'));
		}

	}
}


/**
 * This method should be called on creationComplete of the datagrid
 */
private function bindDataGrid():void
{
	qh.dgrid=famClosingQueryResult;
}

private function changeCurrentState():void
{
	currentState="result";
	/* viewCncl.itemRenderer=new RendererFectory(CloseEntryDeleteRenderer,"QUERY");   */
	app.submitButtonInstance = null;
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
	closeEntryDeleteQueryRequest.request=reqObj;
	closeEntryDeleteQueryRequest.send();
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
	closeEntryDeleteQueryRequest.request=reqObj;
	closeEntryDeleteQueryRequest.send();
}

/**
* This is for the Print button which at a  time will print all the data
* in the dataprovider of the Datagrid object
*/
private function doPrint():void
{
/* var printObject:XenosPrintView = new XenosPrintView();
printObject.frmPrintHeader.lbl.text = "Cam Movement Query";
printObject.pDataGrid.dataProvider = movementSummary.dataProvider;
PrintDG.printAll(printObject); */
}

/**
 * Extract the value of the colum cell removing the prefix added at '0'th index.
 */
private function extractPrecisionedValue(item:Object, column:DataGridColumn):String
{
	var strData:String=item[column.dataField];
	if (!XenosStringUtils.isBlank(strData) && strData.charAt(0) == "F")
	{
		if (strData.length == 1)
			return XenosStringUtils.EMPTY_STR;
		else
		{
			return strData.substring(1);
		}

	}
	else
	{
		return item[column.dataField];
	}
}

/**
* This will generate the Pdf report for the entire query result set
* and will open in a separate window.
*/
private function generatePdf():void
{
	var url:String="fam/closeEntryDeleteQuery.spring?method=generatePDF&commandFormId=" + commandFormId;
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
 * This will generate the Xls report for the entire query result set
 * and will open in a separate window.
 */
private function generateXls():void
{
	var url:String="fam/closeEntryDeleteQuery.spring?method=generateXLS&commandFormId=" + commandFormId;
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
* this method will be called when user click on Select Fund or All Fund
*/
/* private function handleFundChange(event:ItemClickEvent):void
{
	if (event.currentTarget.selectedValue == "selecttedFunds")
	{
		//Alert.show("selectted  Funds");
		closedMonth.styleName='';
		userIdLabel.styleName='';
		fundCodeLablel.styleName='ReqdLabel'
		if (addFundCodeBtn.enabled == false)
		{
			addFundCodeBtn.enabled=true;
		}

	}
	else if (event.currentTarget.selectedValue == "allFund")
	{
		//Alert.show("all  Fund");
		closedMonth.styleName='ReqdLabel';
		userIdLabel.styleName='ReqdLabel';
		fundCodeLablel.styleName='';
		addFundCodeBtn.enabled=false;
	}
} */

/**
* This method works as the result handler of the Initialization/Reset Http Services.
*
*/
private function initPage(event:ResultEvent):void
{
	var i:int=0;



	errPage.clearError(event); //clears the errors if any 

	var commandForm:Object=event.result.closingQueryCommandForm;
	commandFormId=commandForm.commandFormId;
	closingDate.text=commandForm.fromDate != null ? commandForm.fromDate : "";
	this.userId.employeeText.text=commandForm.userId != null ? commandForm.userId : "";
	multipleFundSelector.fundCodeSummary.enabled=true;
	multipleFundSelector.fundPopUp.fundCode.text="";
	this.multipleFundSelector.reset();
	handleFundCodeResult(event);

	//XenosAlert.error("OK");
	// Setting the values of Transaction type... start
	initColl.removeAll();

	if (commandForm.closeTypeList.item != null)
	{

		if (commandForm.closeTypeList.item is ArrayCollection)
		{
			initColl=commandForm.closeTypeList.item as ArrayCollection;

		}
		else
			initColl.addItem(commandForm.closeTypeList.item);
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: "", value: ""});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}

	closeType.dataProvider=tempColl;
	//Setting the values of Transaction type...  end
       
	// Setting the values of status... start
	initColl.removeAll();
	if (commandForm.statusList.item != null)
	{
		if (commandForm.statusList.item is ArrayCollection)
			initColl=commandForm.statusList.item as ArrayCollection;
		else
			initColl.addItem(commandForm.statusList.item);
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: "", value: ""});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);

	}
	status.dataProvider=tempColl;
    // Setting Sort Order combo boxes
    populateSortOrderCombos();
}

/**
* This method will be called at the time of the loading this module and pressing the reset button.
*
*/
private function initPageStart():void
{
	// Setting Sort Order combo boxes
	app.submitButtonInstance = submit;
    populateSortOrderCombos();
    multipleFundSelector.setFocus();
	if (!initCompFlg)
	{
		rndNo=Math.random();
		var req:Object=new Object();
		req.SCREEN_KEY=12120;
		initializeCloseEntryDeleteQuery.request=req;
		initializeCloseEntryDeleteQuery.url="fam/closeEntryDeleteQuery.spring?method=initialExecute&menuType=y&rnd=" + rndNo;
		initializeCloseEntryDeleteQuery.send();

	}
	else
	{
		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.initiate'));
	}


}

// Populates Sort Order Combo Boxes
    private function populateSortOrderCombos() : void  {   
    	
        tempColl = new ArrayCollection();
        fillWithSortColumns(tempColl);
        sortField1.dataProvider = tempColl;
        sortFieldArray[0]= sortField1;
	    sortFieldDataSet[0]=tempColl;	  
	    sortFieldSelectedItem[0] = tempColl.getItemAt(1);  //Set the default 	
        
        tempColl = new ArrayCollection();
        fillWithSortColumns(tempColl);
        sortField2.dataProvider = tempColl;
        sortFieldArray[1]= sortField2;
	    sortFieldDataSet[1]=tempColl;
	    sortFieldSelectedItem[1] = tempColl.getItemAt(2);  //Set the default 
        
        tempColl = new ArrayCollection();
        fillWithSortColumns(tempColl);
        sortField3.dataProvider = tempColl;
        sortFieldArray[2]= sortField3;
	    sortFieldDataSet[2]=tempColl;
	    sortFieldSelectedItem[2] = tempColl.getItemAt(3); //Set the default 
               
        csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
        csd.init();
    }
    
    // Fills the collection with default values
    private function fillWithSortColumns(tempColl:ArrayCollection):void
    {
        tempColl.addItem({label:" ", value: " "});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('fam.label.closed.month'), value: CLOSING_DATE});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('fam.label.close.type'), value: ACCOUNTING_CLOSING_TYPE});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('fam.closingquery.result.label.fundcode'), value: FUND_CODE});
    }

/**
  * This is the method to pass the Collection of data items
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
* This method will populate the request parameters for the
* submitQuery call and bind the parameters with the HTTPService
* object.
*/
private function populateRequestParams():Object
{

	var reqObj:Object=new Object();
	reqObj["SCREEN_KEY"]=12121;
	reqObj["method"]="submitQuery";

	reqObj["isAllFundSelected"]=this.multipleFundSelector.isAllFundSelected();
	reqObj["fundCode"]=this.multipleFundSelector.fundPopUp.fundCode.text;
	reqObj["closingDateCrit"]=this.closingDate.text;
	reqObj["closeType"]=this.closeType.selectedItem != null ? this.closeType.selectedItem.value : "";
	reqObj["status"]=this.status.selectedItem != null ? this.status.selectedItem.value : "";
	reqObj["userId"]=this.userId.employeeText.text;
	reqObj["sortField1"]= this.sortField1.selectedItem != null?StringUtil.trim(this.sortField1.selectedItem.value):XenosStringUtils.EMPTY_STR;       
	reqObj["sortField2"]= this.sortField2.selectedItem != null?StringUtil.trim(this.sortField2.selectedItem.value):XenosStringUtils.EMPTY_STR;       
	reqObj["sortField3"]= this.sortField3.selectedItem != null?StringUtil.trim(this.sortField3.selectedItem.value):XenosStringUtils.EMPTY_STR;

	return reqObj;
}

private function saveScreenCriteria():void
{
	var params:Object=new Object;
	initializeCloseEntryDeleteQuery.url="fam/closeEntryDeleteQuery.spring?method=saveFormCriteria&commandFormId=" + commandFormId;
	initializeCloseEntryDeleteQuery.send();
	//params['method']="saveFormCriteria";
	//initializeCloseEntryDeleteQuery.send(params);
}


private function sortOrder1Update():void
{
	csd.update(sortField1.selectedItem, 0);
}

private function sortOrder2Update():void
{
	csd.update(sortField2.selectedItem, 1);
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
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.closeentry.error.fundcode.empty'));
			return;
		}
		// validation for trying to add more than 10 fund code
		if (fundCodeArrColl.length == 10)
		{
			// validation for trying to add duplicated fund code
			if (isDuplicatedFundCode(fundCode))
			{
				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.closeentry.error.fundcode.duplicated'));
				return;
			}
			if(editFundCodeIndex == -1) {
				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.closeentry.error.fundcode.maxadded'));
				return;
			}
		}
		// validation for trying to add duplicated fund code
		if (editFundCodeIndex == -1)
		{
			if (isDuplicatedFundCode(fundCode))
			{
				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.closeentry.error.fundcode.duplicated'));
				return;
			}
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

//This method sets data to 'MultipleFundSelector' component from Server sent XML
    private function handleFundCodeResult(event: ResultEvent):void{
    	 errPage.clearError(event);
    	var errorInfoList:ArrayCollection=new ArrayCollection();
    	if (event.result!= null && event.result.XenosErrors!= null && 
    	event.result.XenosErrors.Errors != null) {
		   if (event.result.XenosErrors.Errors.error != null){
			 
			 if (event.result.XenosErrors.Errors.error is ArrayCollection) {
				 errorInfoList=event.result.XenosErrors.Errors.error as ArrayCollection;
			 } else { 
				 errorInfoList.addItem(event.result.XenosErrors.Errors.error);
			  }
		   }
		   errPage.showError(errorInfoList);
		   return;
	    }
	  
    	   var commandForm: Object=event.result.closingQueryCommandForm;
    	   
    	   // Set 'editFundCodeIndex' from Server sent XML 
    	   editFundCodeIndex = commandForm.editFundCodeIndex ;
    	   
    	   // Stores elements of type 'String' i.e. Fund Code from Server sent XML
    	   tempColl = new ArrayCollection() ; 
    	      	  
    	   // Get rid of all previously stored items
    	   fundCodeArrColl.removeAll();
    	   
    	   // Fill up 'tempColl' from Server sent XML
    	   if(commandForm.fundCodeList != null && commandForm.fundCodeList.fundCode != null){          
             if (commandForm.fundCodeList.fundCode is ArrayCollection) {
           	    tempColl= commandForm.fundCodeList.fundCode as ArrayCollection ;           	  
             } else {
           	    tempColl.addItem(commandForm.fundCodeList.fundCode);           	   
             }
             
            // Fill up 'fundCodeArrColl' which is displayed in the Grid of 'MultipleFundSelector'           
            for(i=0; i< tempColl.length; i++) {
            	var obj:Object=new Object();
            	obj["fundCode"] = tempColl[i];
            	obj["index"] = i;
            	fundCodeArrColl.addItem(obj);            	
      		}    		
            
         }       
         // Set Fund Code if 'Edit' has been issued otherwise clear the TextInput.
         if(editFundCodeIndex>=0 && fundCodeArrColl.length>0){
         	multipleFundSelector.setFundCode(fundCodeArrColl.getItemAt(editFundCodeIndex)["fundCode"]);         
           }else{
         	multipleFundSelector.setFundCode(XenosStringUtils.EMPTY_STR);         	
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
	for each (var o:Object in fundCodeArrColl)
	{
		if (o.fundCode == value)
		{
			return true;
		}
	}
	return false;
}