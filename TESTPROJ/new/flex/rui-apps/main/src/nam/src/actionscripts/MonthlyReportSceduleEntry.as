
// MVR Schedule Entry ActionScript file

import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.nam.validators.MonthlyScheduleEntryValidator;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.events.ValidationResultEvent;
import mx.rpc.events.ResultEvent;

[Bindable]
private var fundCodeDetails:ArrayCollection=new ArrayCollection();
[Bindable]
private var confirmGridDetails:ArrayCollection=new ArrayCollection();
[Bindable]
private var preMonthEndDate:String=new String();


/**
 * Loading the initial configuaration.
 */
public function loadScheduleEntry():void
{
	var rndNo:Number=Math.random();
	var req:Object=new Object();
	req.SCREEN_KEY="13001";
	initScheduleEntry.request=req;
	initScheduleEntry.url="nam/scheduleEntryDispatchAction.action?method=initialExecute&" + rndNo;
	initScheduleEntry.send();
}

/**
 * For Initializing the Monthly Report Schedule Entry Screen.
 * Dispatches an event
 */
private function initPage(event:ResultEvent):void
{
	reset();

	var i:int=0;
	var initColl:ArrayCollection=new ArrayCollection();
	var tempColl:ArrayCollection;
	initColl.removeAll();

	// Temporary/Final List
	if (event.result.scheduleEntryActionForm.tempOrFinalList.item != null)
	{
		if (event.result.scheduleEntryActionForm.tempOrFinalList.item is ArrayCollection)
		{
			initColl=event.result.scheduleEntryActionForm.tempOrFinalList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.scheduleEntryActionForm.tempOrFinalList.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	this.tempOrFinal.dataProvider=tempColl;
	event.result.scheduleEntryActionForm.tempOrFinalList='N';
	this.tempOrFinal.selectedIndex=getIndexOfLabelValueBean(tempColl, event.result.scheduleEntryActionForm.tempOrFinalList);

	//ScheduleType List
	initColl.removeAll();
	if (event.result.scheduleEntryActionForm.scheduleTypeList.item != null)
	{
		if (event.result.scheduleEntryActionForm.scheduleTypeList.item is ArrayCollection)
		{
			initColl=event.result.scheduleEntryActionForm.scheduleTypeList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.scheduleEntryActionForm.scheduleTypeList.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	this.scheduleType.dataProvider=tempColl;
	event.result.scheduleEntryActionForm.scheduleTypeList='TONIGHT';
	this.scheduleType.selectedIndex=getIndexOfLabelValueBean(tempColl, event.result.scheduleEntryActionForm.scheduleTypeList);

	// GenerationDay List
	initColl.removeAll();
	if (event.result.scheduleEntryActionForm.generationDayList != null)
	{
		if (event.result.scheduleEntryActionForm.generationDayList != null)
		{
			if (event.result.scheduleEntryActionForm.generationDayList is ArrayCollection)
				initColl=event.result.scheduleEntryActionForm.generationDayList as ArrayCollection;
			else
				initColl.addItem(event.result.scheduleEntryActionForm.generationDayList);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem("");
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	generationDay.dataProvider=tempColl;

	//Report Pattern List
	initColl.removeAll();
	if (event.result.scheduleEntryActionForm.reportPatternList.item != null)
	{
		if (event.result.scheduleEntryActionForm.reportPatternList.item is ArrayCollection)
		{
			initColl=event.result.scheduleEntryActionForm.reportPatternList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.scheduleEntryActionForm.reportPatternList.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	reportPattern.dataProvider=tempColl;
	this.reportPattern.selectedIndex=1;

	// Report As of Date
	this.reportAsOfDate.text=event.result.scheduleEntryActionForm.asOfDate;
	preMonthEndDate = event.result.scheduleEntryActionForm.asOfDate;
}

private var editMode:String="add";
private var editRowIndex:int;
private var editFund:String;

/**
 * To add both NAM and PX fund code to DataGrid.
 */
private function addFundCode():void
{
	errPageEntry.visible=false;
	errPageEntry.includeInLayout=false;

	if (XenosStringUtils.equals(XenosStringUtils.EMPTY_STR, fundPopUp.fundCode.text))
	{
		XenosAlert.error(Application.application.xResourceManager.getKeyValue("nam.monthlyReport.alert.entry.fundCodeEmt"));
	}
	else
	{
		var rndNo:Number=Math.random();
		addFundCodeService.url="nam/scheduleEntryDispatchAction.action?method=addFundCode&fundCode=" + fundPopUp.fundCode.text + "&" + rndNo;
		addFundCodeService.send();
	}

}

/**
 * To add both NAM and PX fund code to DataGrid.
 * Dispatches an event
 */
private function addFundCodeResultHandler(event:ResultEvent):void
{
	if (null != event.result.scheduleEntryActionForm.fundPk)
	{
		if(!event.result.scheduleEntryActionForm.isFundAccess)
		{
			errPageEntry.visible=true;
			errPageEntry.includeInLayout=true;
			errorLabelEntry.text = "Fund code [ "+this.fundPopUp.fundCode.text+" ] does not have Access for this user";
			return;
		}
		if(undefined == event.result.scheduleEntryActionForm.fundCodePx)
		{
			errPageEntry.visible=true;
			errPageEntry.includeInLayout=true;
			errorLabelEntry.text="Px code not available for [ " + this.fundPopUp.fundCode.text + " ] Fund Code";
			return;
		} 
		
		var isDuplicateFund:Boolean=false;

		for each (var obj:Object in fundCodeDetails)
		{
			if(editMode == 'edit')
			{
				if(editFund == event.result.scheduleEntryActionForm.fundCode)
				{
					break;
				}
			}
			if (obj["fundCode"] == event.result.scheduleEntryActionForm.fundCode)
			{
				isDuplicateFund=true;
			}
		}
		if (isDuplicateFund)
		{
			XenosAlert.error(Application.application.xResourceManager.getKeyValue("nam.monthlyReport.alert.entry.duplicateFund"));
		}
		else
		{
			var result:Object=new Object();
			if (editMode == 'add')
			{
				if (fundCodeDetails.length >= 10)
				{
					XenosAlert.error(Application.application.xResourceManager.getKeyValue("nam.monthlyReport.alert.entry.fundCodeLimit"));
				}
				else
				{
					result["fundCode"]=event.result.scheduleEntryActionForm.fundCode;
					result["fundCodePx"]=event.result.scheduleEntryActionForm.fundCodePx;
					result["fundPk"]=event.result.scheduleEntryActionForm.fundPk;
					result["rowNum"] = fundCodeDetails.length;
					this.fundCodeDetails.addItem(result);
					this.fundPopUp.fundCode.text="";
				}
			}
			else if (editMode == 'edit')
			{
				result["fundCode"]=event.result.scheduleEntryActionForm.fundCode;
				result["fundCodePx"]=event.result.scheduleEntryActionForm.fundCodePx;
				result["fundPk"]=event.result.scheduleEntryActionForm.fundPk;
				result["rowNum"]=editRowIndex;
				fundCodeDetails.setItemAt(result, editRowIndex);
				editMode="add";
				this.fundPopUp.fundCode.text="";
			}
			fundCodeDetails.refresh();
			var index:int=0;
			for each (var item:Object in fundCodeDetails)
			{
				item["rowNum"]=index;
				item["btnVisible"]=true;
				index++;
			}
			fundCodeDetails.refresh();
		}
	}
	else
	{
		errPageEntry.visible=true;
		errPageEntry.includeInLayout=true;
		errorLabelEntry.text="Invalid FundCode [ " + this.fundPopUp.fundCode.text + " ]";
	}
}

/**
 * To Edit the fund code.
 */
public function handleEdit(data:Object):void
{
	this.fundPopUp.fundCode.text=data.fundCode;
	editRowIndex=data.rowNum;
	editFund=data.fundCode;
	editMode="edit";
	errPageEntry.visible=false;
	errPageEntry.includeInLayout=false;
}

/**
 * To delete the fund code.
 */
public function handleDelete(data:Object):void
{
	fundCodeDetails.removeItemAt(data.rowNum);
	fundCodeDetails.refresh();
	var index:int=0;
	for each (var item:Object in fundCodeDetails)
	{
		item["rowNum"]=index;
		item["btnVisible"]=true;
		index++;
	}
	fundCodeDetails.refresh();
	this.fundPopUp.fundCode.text="";
	editMode = "add";
	errPageEntry.visible=false;
	errPageEntry.includeInLayout=false;
}

/**
 * Sumbit
 */
public function doSubmit():void
{
	var validateModel:Object={scheduleEntry:
	{
		fundCodeGrid: this.fundCodeDetails.length.toString(),
		tempOrFinal: this.tempOrFinal.text,
		reportPattern: this.reportPattern.text,
		scheduleType: this.scheduleType.text,
		generationDay: this.generationDay.text
	}};

	var scheduleEntryValidator:MonthlyScheduleEntryValidator=new MonthlyScheduleEntryValidator();
	scheduleEntryValidator.source=validateModel;
	scheduleEntryValidator.property="scheduleEntry";

	// Setting The Validatior 
	var validationResult:ValidationResultEvent=scheduleEntryValidator.validate();
	if (validationResult.type == ValidationResultEvent.INVALID)
	{
		var errorMsg:String=validationResult.message;
		XenosAlert.error(errorMsg);
	}
	else
	{
		var fundCodeSize:String=fundCodeDetails.length.toString();
		var rndNo:Number=Math.random();

		var result:Object=new Object();
		submitFundCodeService.url="nam/scheduleEntryDispatchAction.action?method=doSubmit&fundCodeSize=" + fundCodeSize + "&" + rndNo;
		submitFundCodeService.send();

	}
}

/**
 * Submit result event
 * @param event
 */
private function submitResultHandler(event:ResultEvent):void
{

	var refNoColl:ArrayCollection=new ArrayCollection();
	var initColl:ArrayCollection=new ArrayCollection();

	if (event.result.scheduleEntryActionForm.referenceNoList != null)
	{
		if (event.result.scheduleEntryActionForm.referenceNoList != null)
		{
			if (event.result.scheduleEntryActionForm.referenceNoList is ArrayCollection)
				initColl=event.result.scheduleEntryActionForm.referenceNoList as ArrayCollection;
			else
				initColl.addItem(event.result.scheduleEntryActionForm.referenceNoList);
		}
	}

	for (var i:int=0; i < initColl.length; i++)
	{
		refNoColl.addItem(initColl[i]);
	}

	var isValidDate : Boolean = true;
	if (!XenosStringUtils.isBlank(reportAsOfDate.text)) 
    {
   		 if (!DateUtils.isValidDate(reportAsOfDate.text))
   		 {
   		 	isValidDate = false;
   		 	XenosAlert.error(Application.application.xResourceManager.getKeyValue("nam.error.illegal.date")+" [ "+reportAsOfDate.text+" ]");
    	 }
    }
	if(isValidDate)
	{
		fundCodeDetails.refresh();
		vstack.selectedChild=scheduleConfirmScreen;
		var tempCol:ArrayCollection=fundCodeGrid.dataProvider as ArrayCollection;

		var dataSortField:SortField=new SortField();
		dataSortField.name="rowNum";
		dataSortField.numeric=true;

		var stringDataSort:Sort=new Sort();
		stringDataSort.fields=[dataSortField];

		tempCol.sort=stringDataSort;

		var count:int=0;
		for each (var item:Object in tempCol)
		{
			var result:Object=new Object();

			result["refNo"]=refNoColl.getItemAt(count);
			result["fundCode"]=item["fundCode"];
			result["fundCodePx"]=item["fundCodePx"];
			result["fundPk"]=item["fundPk"];
			result["tempOrFinal"]=this.tempOrFinal.text;
			result["scheduleType"]=this.scheduleType.text;
			result["generationDay"]=this.generationDay.text;
			result["reportPattern"]=this.reportPattern.text;
			result["reportAsOfDate"]=this.reportAsOfDate.text;

			this.confirmGridDetails.addItemAt(result, item["rowNum"]);
			count++;
		}
		this.confirmGridDetails.refresh();
	}
}

/**
 * Confirmation Screen
 */
private function doConfirm():void
{
	var rndNo:Number=Math.random();
	var tempCol:ArrayCollection=confirmationGrid.dataProvider as ArrayCollection;
	var fundPkStrArr:Array=new Array();
	var refNoArr:Array=new Array();
	errPage.visible=false;
	errPage.includeInLayout=false;
	errorLabel.text = "";
	for each (var item:Object in tempCol)
	{
		fundPkStrArr.push(item["fundPk"]);
		refNoArr.push(item["refNo"]);

	}
	var result:Object=new Object();
	result.fundPkStrArr=fundPkStrArr;
	result.tempOrFinal=tempOrFinal.selectedItem.value;
	result.reportPattern=reportPattern.selectedItem.value;
	result.scheduleType=scheduleType.selectedItem.value;
	result.asOfDate=reportAsOfDate.text;
	result.generationDay=generationDay.text;
	result.refNoArr=refNoArr;
	confirmFundCodeService.request=result;
	confirmFundCodeService.url="nam/scheduleEntryDispatchAction.action?method=doConfirm&" + rndNo;
	confirmFundCodeService.send();
}


/**
 * ConfirmResult Screen
 * @param event
 */
private function doConfirmResult(event:ResultEvent):void
{
	if (null != event)
	{
		if (event.result.hasOwnProperty("existschedule"))
		{
			var existSchedule:String=event.result.existschedule;
			errPage.visible=true;
			errPage.includeInLayout=true;
			errorLabel.text="Schedule Already Registered, Duplicate Schedule Entry not allowed for Fund Code [ " + existSchedule.substring(0, existSchedule.length - 2) + " ]";
		}
		else if (event.result.hasOwnProperty("Error"))
		{
			errPage.visible = true;
			errPage.includeInLayout = true;
			errorLabel.text = "Database Write Error";
		}
		else
		{

			hb.visible=true;
			hb.includeInLayout=true;

			uConfLabel.visible=false;
			uConfLabel.includeInLayout=false;

			back.visible=false;
			back.includeInLayout=false;

			sConfLabel.visible=true;
			sConfLabel.includeInLayout=true;

			uConfSubmit.visible=false;
			uConfSubmit.includeInLayout=false;

			sConfSubmit.visible=true;
			sConfSubmit.includeInLayout=true;
		}
	}
}

/**
 * To display entry screen
 */
public function ok():void
{
	vstack.selectedChild=scheduleEntryCanvas;

	this.confirmGridDetails.removeAll();
	this.confirmGridDetails.refresh();

	this.fundCodeDetails.removeAll();
	this.fundCodeDetails.refresh();

	hb.visible=false;
	hb.includeInLayout=false;

	uConfLabel.visible=true;
	uConfLabel.includeInLayout=true;

	back.visible=true;
	back.includeInLayout=true;

	uConfSubmit.visible=true;
	uConfSubmit.includeInLayout=true;

	sConfLabel.visible=false;
	sConfLabel.includeInLayout=false;

	sConfSubmit.visible=false;
	sConfSubmit.includeInLayout=false;

	var rndNo:Number=Math.random();
	initScheduleEntry.url="nam/scheduleEntryDispatchAction.action?method=initialExecute&" + rndNo;
	initScheduleEntry.send();
}

/**
 * To display entry screen.
 */
public function doBack():void
{
	vstack.selectedChild=scheduleEntryCanvas;
	this.confirmGridDetails.removeAll();
	this.confirmGridDetails.refresh();
	errPage.visible=false;
	errPage.includeInLayout=false;

	if (null != confirmationGrid)
	{
		var tempCol:ArrayCollection=confirmationGrid.dataProvider as ArrayCollection;

		for (var i:int=tempCol.length; i > 0; i--)
		{
			confirmationGrid.removeChildAt(i);
		}
	}

	errPageEntry.visible = false;
	errPageEntry.includeInLayout = false;
}

/**
 * Based on Temporary/Final, Report Pattern display.
 */
private function tempOrFinalOnchange():void
{
	if (XenosStringUtils.equals('Y', this.tempOrFinal.selectedItem.value))
	{
		reportPattern.selectedIndex = 14;
		lreportPattern.visible=false;
		lreportPattern.includeInLayout=false;
		reportPattern.visible=false;
		reportPattern.includeInLayout=false;
	}
	else if (XenosStringUtils.equals('N', this.tempOrFinal.selectedItem.value))
	{
		reportPattern.selectedIndex = 1;
		lreportPattern.visible=true;
		lreportPattern.includeInLayout=true;
		reportPattern.visible=true;
		reportPattern.includeInLayout=true;
	}
}

/**
 * Based on Schedule Type as "BUSINESS_DAY/TONIGHT" ,
 * Generation Day and Report As of Date Fields display.
 */
private function scheduleTypeOnchange():void
{
	if (XenosStringUtils.equals('BUSINESS_DAY', this.scheduleType.selectedItem.value))
	{
		reportAsOfDate.text = "";
		lreportAsOfDate.visible=false;
		lreportAsOfDate.includeInLayout=false;
		reportAsOfDate.visible=false;
		reportAsOfDate.includeInLayout=false;

		lgenerationDay.visible=true;
		lgenerationDay.includeInLayout=true;
		generationDay.visible=true;
		generationDay.includeInLayout=true;
	}
	else if (XenosStringUtils.equals('TONIGHT', this.scheduleType.selectedItem.value))
	{
		generationDay.selectedIndex = 0;
		lgenerationDay.visible=false;
		lgenerationDay.includeInLayout=false;
		generationDay.visible=false;
		generationDay.includeInLayout=false;

		lreportAsOfDate.visible=true;
		lreportAsOfDate.includeInLayout=true;
		reportAsOfDate.visible=true;
		reportAsOfDate.includeInLayout=true;
		reportAsOfDate.text = preMonthEndDate;
	}
}

// reset field values
private function reset():void
{
	fundPopUp.fundCode.text="";
	tempOrFinal.selectedIndex=0;
	reportPattern.selectedIndex=0;
	scheduleType.selectedIndex=0;
	reportAsOfDate.text="";
	generationDay.selectedIndex=0;

	this.fundCodeDetails.removeAll();
	this.fundCodeDetails.refresh();

	if (null != fundCodeGrid)
	{
		var tempCol:ArrayCollection=fundCodeGrid.dataProvider as ArrayCollection;

		for (var i:int=tempCol.length; i > 0; i--)
		{
			fundCodeGrid.removeChildAt(i);
		}
	}

	reportAsOfDate.visible = true;
	reportAsOfDate.includeInLayout = true;

	lreportAsOfDate.visible = true;
	lreportAsOfDate.includeInLayout = true;

	lgenerationDay.visible=false;
	lgenerationDay.includeInLayout=false;

	generationDay.visible = false;
	generationDay.includeInLayout = false;

	lreportPattern.visible = true;
	lreportPattern.includeInLayout = true;

	reportPattern.visible = true;
	reportAsOfDate.includeInLayout = true;

	errPageEntry.visible = false;
	errPageEntry.includeInLayout = false;
}


/**
 * Calculates the index of a label value bean given its value, within a given
 * array collection of such beans.
 * Returns 0 if the value is null or empty string.
 */
private function getIndexOfLabelValueBean(collection:ArrayCollection, value:String):int
{
	var index:int=0;
	if (value == null || value == XenosStringUtils.EMPTY_STR)
	{
		return index;
	}
	for (var count:int=0; count < collection.length; count++)
	{
		var bean:Object=collection.getItemAt(count);
		if (bean['value'] == value)
		{
			index=count;
			break;
		}
	}
	return index;
}

