
// ActionScript file for Fund File Query
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.nam.validators.FundConfigEntryValidator;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.ValidationResultEvent;
import mx.rpc.events.ResultEvent;

[Bindable]
public var app:XenosApplication=XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
private var initCompFlg:Boolean=false;

//For check box
[Bindable]
public var selectAllBind:Boolean=false;
public var rowNum:ArrayCollection=new ArrayCollection();
[Bindable]
public var selectedRdArray:Array=new Array();
private var tempArray:Array=new Array();
private var rowNumArray:Array=new Array();
private var rndNo:int=0;
private var csd:CustomizeSortOrder=null;

[Bindable]
private var tempMode:String;
[Bindable]
private var fundPkStr:String="";
[Bindable]
private var fundCodeStr:String="";

[Bindable]
private var accInfoReqFlagOldVal:String="";
[Bindable]
private var gxodwFlagOldVal:String="";
[Bindable]
private var smartPortReqOldVal:String="";
[Bindable]
private var isFamFundExist:String="";

/**
 * Loading the initial configuaration.
 */
private function loadAll():void
{
	parseUrlString();
	vstack.selectedChild=fundConfigAmendCanvas;
	var requestObj:Object=new Object();
	requestObj.fundPk=fundPkStr;
	requestObj.fundCode=fundCodeStr;
	loadFundConfigDetail.url="nam/fundConfigAmendDispatch.action?method=loadFundConfigurationDetail&" + rndNo;
	loadFundConfigDetail.request=requestObj;
	loadFundConfigDetail.send();
}

/**
 * parseUrlString
 */
public function parseUrlString():void
{
	try
	{
		// Remove everything before the question mark, including
		// the question mark.
		var myPattern:RegExp=/.*\?/;
		var s:String=this.loaderInfo.url.toString();
		//XenosAlert.info("Load Url : "+ this.loaderInfo.url.toString());
		s=s.replace(myPattern, "");
		// Create an Array of name=value Strings.
		var params:Array=s.split(Globals.AND_SIGN);
		// Print the params that are in the Array.
		var keyStr:String;
		var valueStr:String;
		var paramObj:Object=params;

		// Set the values of the salutation.
		if (params != null)
		{
			for (var i:int=0; i < params.length; i++)
			{
				var tempA:Array=params[i].split("=");
				if (tempA[0] == "fundPk")
				{
					this.fundPkStr=tempA[1];
				}
				else if (tempA[0] == "fundCode")
				{
					this.fundCodeStr=tempA[1];
				}
			}
		}
	}
	catch (e:Error)
	{
		trace(e);
	}
}

/**
 * For Initializing the Fund Configuration Amend Screen.
 * Dispatches an event
 */
private function initPage(event:ResultEvent):void
{
	this.resetFormValues();
	var i:int=0;
	var initColl:ArrayCollection=new ArrayCollection();
	var tempColl:ArrayCollection;
	var selIndx:int=0;

	initColl.removeAll();
	//	1. Setting values of the Fund Code, Fund Name and Office Id
	this.fundCode.text=event.result.fundConfigEntryActionForm.fundCode;
	this.fundName.text=event.result.fundConfigEntryActionForm.fundName;
	this.baseCurrency.ccyText.text=event.result.fundConfigEntryActionForm.baseCurrency;

	if (event.result.fundConfigEntryActionForm.officeIdValues != null)
	{
		if (event.result.fundConfigEntryActionForm.officeIdValues.officeId != null)
		{
			if (event.result.fundConfigEntryActionForm.officeIdValues.officeId is ArrayCollection)
				initColl=event.result.fundConfigEntryActionForm.officeIdValues.officeId as ArrayCollection;
			else
				initColl.addItem(event.result.fundConfigEntryActionForm.officeIdValues.officeId);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem("");
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}

	officeIdList.dataProvider=tempColl;
	officeIdList.selectedIndex=getIndex(tempColl, event.result.fundConfigEntryActionForm.officeId);

	//2. Setting values of the Fund Category
	initColl.removeAll();
	if (event.result.fundConfigEntryActionForm.fundCategoryList.item != null)
	{
		if (event.result.fundConfigEntryActionForm.fundCategoryList.item is ArrayCollection)
		{
			initColl=event.result.fundConfigEntryActionForm.fundCategoryList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.fundConfigEntryActionForm.fundCategoryList.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	this.fundCategoryList.dataProvider=tempColl;
	this.fundCategoryList.selectedIndex=getIndexOfLabelValueBean(tempColl, event.result.fundConfigEntryActionForm.fundCategory);

	//3. Setting values of the Default Underlying Asset Flag(FX)
	initColl.removeAll();
	if (event.result.fundConfigEntryActionForm.defUnAssetFlagFXList.item != null)
	{
		if (event.result.fundConfigEntryActionForm.defUnAssetFlagFXList.item is ArrayCollection)
		{
			initColl=event.result.fundConfigEntryActionForm.defUnAssetFlagFXList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.fundConfigEntryActionForm.defUnAssetFlagFXList.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	this.defaultUnderlyingAssertFlagFX.dataProvider=tempColl;
	if (event.result.fundConfigEntryActionForm.defaultUndAssetFlagFX == undefined)
	{
		event.result.fundConfigEntryActionForm.defaultUndAssetFlagFX='OTHERS';
	}
	this.defaultUnderlyingAssertFlagFX.selectedIndex=getIndexOfLabelValueBean(tempColl, event.result.fundConfigEntryActionForm.defaultUndAssetFlagFX);

	//4. Setting values of the Default Actual/Interim Flag
	initColl.removeAll();
	if (event.result.fundConfigEntryActionForm.actIntrimFlagList.item != null)
	{
		if (event.result.fundConfigEntryActionForm.actIntrimFlagList.item is ArrayCollection)
		{
			initColl=event.result.fundConfigEntryActionForm.actIntrimFlagList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.fundConfigEntryActionForm.actIntrimFlagList.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	this.actualIntrimFlag.dataProvider=tempColl;
	if (event.result.fundConfigEntryActionForm.actualIntrimFlag == undefined)
	{
		event.result.fundConfigEntryActionForm.actualIntrimFlag='A';
	}
	this.actualIntrimFlag.selectedIndex=getIndexOfLabelValueBean(tempColl, event.result.fundConfigEntryActionForm.actualIntrimFlag);

	//5. Setting values of the Auto Completion for MT566 Reqd
	initColl.removeAll();
	if (event.result.fundConfigEntryActionForm.autoCompForMT566List.item != null)
	{
		if (event.result.fundConfigEntryActionForm.autoCompForMT566List.item is ArrayCollection)
		{
			initColl=event.result.fundConfigEntryActionForm.autoCompForMT566List.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.fundConfigEntryActionForm.autoCompForMT566List.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	this.autoCompletionForMT566Reqd.dataProvider=tempColl;
	if (event.result.fundConfigEntryActionForm.autoComplForMT566Reqd == undefined)
	{
		event.result.fundConfigEntryActionForm.autoComplForMT566Reqd='N';
	}
	this.autoCompletionForMT566Reqd.selectedIndex=getIndexOfLabelValueBean(tempColl, event.result.fundConfigEntryActionForm.autoComplForMT566Reqd);

	//6. Setting values of the Accounting Info Required
	initColl.removeAll();
	if (event.result.fundConfigEntryActionForm.accInfoRequiredList.item != null)
	{
		if (event.result.fundConfigEntryActionForm.accInfoRequiredList.item is ArrayCollection)
		{
			initColl=event.result.fundConfigEntryActionForm.accInfoRequiredList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.fundConfigEntryActionForm.accInfoRequiredList.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	this.accountingInfoRequired.dataProvider=tempColl;
	if (event.result.fundConfigEntryActionForm.accInfoRequired == undefined)
	{
		if (XenosStringUtils.equals('OTHERS', this.fundCategoryList.text))
		{
			event.result.fundConfigEntryActionForm.accInfoRequired='Y';
		}
		else if (XenosStringUtils.equals('TSTAR', this.fundCategoryList.text))
		{
			event.result.fundConfigEntryActionForm.accInfoRequired='N';
		}
	}
	this.accountingInfoRequired.selectedIndex=getIndexOfLabelValueBean(tempColl, event.result.fundConfigEntryActionForm.accInfoRequired);


	//7. Setting values of the GX/ODW Required
	initColl.removeAll();
	if (event.result.fundConfigEntryActionForm.gxOdwRequiredList.item != null)
	{
		if (event.result.fundConfigEntryActionForm.gxOdwRequiredList.item is ArrayCollection)
		{
			initColl=event.result.fundConfigEntryActionForm.gxOdwRequiredList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.fundConfigEntryActionForm.gxOdwRequiredList.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	this.gXODWRequired.dataProvider=tempColl;
	if (event.result.fundConfigEntryActionForm.gxOdwRequired == undefined)
	{
		event.result.fundConfigEntryActionForm.gxOdwRequired='Y';
	}
	this.gXODWRequired.selectedIndex=getIndexOfLabelValueBean(tempColl, event.result.fundConfigEntryActionForm.gxOdwRequired);

	//8. Setting values of the Smart Port Required
	initColl.removeAll();
	if (event.result.fundConfigEntryActionForm.smartPortReqList.item != null)
	{
		if (event.result.fundConfigEntryActionForm.smartPortReqList.item is ArrayCollection)
		{
			initColl=event.result.fundConfigEntryActionForm.smartPortReqList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.fundConfigEntryActionForm.smartPortReqList.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	this.smartPortRequired.dataProvider=tempColl;
	if (event.result.fundConfigEntryActionForm.smartPortRequired == undefined)
	{
		event.result.fundConfigEntryActionForm.smartPortRequired='Y';
	}
	this.smartPortRequired.selectedIndex=getIndexOfLabelValueBean(tempColl, event.result.fundConfigEntryActionForm.smartPortRequired);

	//9. Setting values of the DEX Required
	initColl.removeAll();
	if (event.result.fundConfigEntryActionForm.dexRequiredList.item != null)
	{
		if (event.result.fundConfigEntryActionForm.dexRequiredList.item is ArrayCollection)
		{
			initColl=event.result.fundConfigEntryActionForm.dexRequiredList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.fundConfigEntryActionForm.dexRequiredList.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	this.dEXRequired.dataProvider=tempColl;
	if (event.result.fundConfigEntryActionForm.dexRequired == undefined)
	{
		event.result.fundConfigEntryActionForm.dexRequired='N';
	}
	this.dEXRequired.selectedIndex=getIndexOfLabelValueBean(tempColl, event.result.fundConfigEntryActionForm.dexRequired);

	//10. Setting values of  Balance to NBL
	initColl.removeAll();
	if (event.result.fundConfigEntryActionForm.balanceToNBLList.item != null)
	{
		if (event.result.fundConfigEntryActionForm.balanceToNBLList.item is ArrayCollection)
		{
			initColl=event.result.fundConfigEntryActionForm.balanceToNBLList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.fundConfigEntryActionForm.balanceToNBLList.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	this.balanceToNBL.dataProvider=tempColl;
	if (event.result.fundConfigEntryActionForm.balanceToNBL == undefined)
	{
		event.result.fundConfigEntryActionForm.balanceToNBL='Y';
	}
	this.balanceToNBL.selectedIndex=getIndexOfLabelValueBean(tempColl, event.result.fundConfigEntryActionForm.balanceToNBL);

	//11. Setting values of  Shariah Flag
	initColl.removeAll();
	if (event.result.fundConfigEntryActionForm.shariahFlagList.item != null)
	{
		if (event.result.fundConfigEntryActionForm.shariahFlagList.item is ArrayCollection)
		{
			initColl=event.result.fundConfigEntryActionForm.shariahFlagList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.fundConfigEntryActionForm.shariahFlagList.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	this.shariahFlag.dataProvider=tempColl;
	if (event.result.fundConfigEntryActionForm.shariahFlag == undefined)
	{
		event.result.fundConfigEntryActionForm.shariahFlag='N';
	}
	this.shariahFlag.selectedIndex=getIndexOfLabelValueBean(tempColl, event.result.fundConfigEntryActionForm.shariahFlag);

	//12. Setting values of  Official Name
	this.officialName.text=event.result.fundConfigEntryActionForm.officialName;

	//13. Setting values of  Report Date Format
	initColl.removeAll();
	if (event.result.fundConfigEntryActionForm.reportDateFormatList.item != null)
	{
		if (event.result.fundConfigEntryActionForm.reportDateFormatList.item is ArrayCollection)
		{
			initColl=event.result.fundConfigEntryActionForm.reportDateFormatList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.fundConfigEntryActionForm.reportDateFormatList.item);

		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	this.reportDateFormat.dataProvider=tempColl;
	if (event.result.fundConfigEntryActionForm.reportDateFormat == undefined)
	{
		event.result.fundConfigEntryActionForm.reportDateFormat='MM/DD';
	}
	this.reportDateFormat.selectedIndex=getIndexOfLabelValueBean(tempColl, event.result.fundConfigEntryActionForm.reportDateFormat);

	//14. Setting values of  Business Start Date
	if(undefined != event.result.fundConfigEntryActionForm.businessStartDateStr)
	{
		this.businessStartDate.text=event.result.fundConfigEntryActionForm.businessStartDateStr;
	}

	//15. Setting values of  Business End Date
	if(undefined != event.result.fundConfigEntryActionForm.businessEndDateStr)
	{
		this.businessEndDate.text=event.result.fundConfigEntryActionForm.businessEndDateStr;
	}
	
	//16. Setting values of  Investment Start Date
	if(undefined != event.result.fundConfigEntryActionForm.investmentStartDateStr)
	{
		this.investStartDate.text=event.result.fundConfigEntryActionForm.investmentStartDateStr;
	}

	//17. Setting values of  CRIMS Suppress Reqd
	initColl.removeAll();
	if (event.result.fundConfigEntryActionForm.crimsSuppReqdList.item != null)
	{
		if (event.result.fundConfigEntryActionForm.crimsSuppReqdList.item is ArrayCollection)
		{
			initColl=event.result.fundConfigEntryActionForm.crimsSuppReqdList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.fundConfigEntryActionForm.crimsSuppReqdList.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	this.crimSuppressReqd.dataProvider=tempColl;
	if (event.result.fundConfigEntryActionForm.crimsSuppressReqd == undefined)
	{
		event.result.fundConfigEntryActionForm.crimsSuppressReqd='N';
	}
	this.crimSuppressReqd.selectedIndex=getIndexOfLabelValueBean(tempColl, event.result.fundConfigEntryActionForm.crimsSuppressReqd);

	//18. Setting values of  Balance Suppress Reqd
	initColl.removeAll();
	if (event.result.fundConfigEntryActionForm.balSuppressReqdList.item != null)
	{
		if (event.result.fundConfigEntryActionForm.balSuppressReqdList.item is ArrayCollection)
		{
			initColl=event.result.fundConfigEntryActionForm.balSuppressReqdList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.fundConfigEntryActionForm.balSuppressReqdList.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	this.balanceSuppressReqd.dataProvider=tempColl;
	this.balanceSuppressReqd.selectedIndex=getIndexOfLabelValueBean(tempColl, event.result.fundConfigEntryActionForm.balSuppressReqd);

	//19. Setting values of  MT54X rule for short account Reqd
	initColl.removeAll();
	if (event.result.fundConfigEntryActionForm.mt54XShortAccReqdList.item != null)
	{
		if (event.result.fundConfigEntryActionForm.mt54XShortAccReqdList.item is ArrayCollection)
		{
			initColl=event.result.fundConfigEntryActionForm.mt54XShortAccReqdList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.fundConfigEntryActionForm.mt54XShortAccReqdList.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	this.mT54XRuleForShortAccReqd.dataProvider=tempColl;
	if (event.result.fundConfigEntryActionForm.mt54XShortAccReqd == undefined)
	{
		event.result.fundConfigEntryActionForm.mt54XShortAccReqd='N';
	}
	this.mT54XRuleForShortAccReqd.selectedIndex=getIndexOfLabelValueBean(tempColl, event.result.fundConfigEntryActionForm.mt54XShortAccReqd);

	//20. Setting values of FPS Adjustment 
	initColl.removeAll();
	if (event.result.fundConfigEntryActionForm.adjustmentForList.item != null)
	{
		if (event.result.fundConfigEntryActionForm.adjustmentForList.item is ArrayCollection)
		{
			initColl=event.result.fundConfigEntryActionForm.adjustmentForList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.fundConfigEntryActionForm.adjustmentForList.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	this.fpsAdjustment.dataProvider=tempColl;

	if (event.result.fundConfigEntryActionForm.fpsAdjustment == undefined)
	{
		event.result.fundConfigEntryActionForm.fpsAdjustment=0;
	}
	this.fpsAdjustment.selectedIndex=getIndexOfLabelValueBean(tempColl, event.result.fundConfigEntryActionForm.fpsAdjustment);
	
	//21. Setting values of SBA Required Flag 
	initColl.removeAll();
	if (event.result.fundConfigEntryActionForm.sbaRequiredFlagList.item != null)
	{
		if (event.result.fundConfigEntryActionForm.sbaRequiredFlagList.item is ArrayCollection)
		{
			initColl=event.result.fundConfigEntryActionForm.sbaRequiredFlagList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.fundConfigEntryActionForm.sbaRequiredFlagList.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	this.sbaRequiredFlag.dataProvider=tempColl;

	if (event.result.fundConfigEntryActionForm.sbaRequiredFlag == undefined)
	{
		event.result.fundConfigEntryActionForm.sbaRequiredFlag='N';
	}
	this.sbaRequiredFlag.selectedIndex=getIndexOfLabelValueBean(tempColl, event.result.fundConfigEntryActionForm.sbaRequiredFlag);
	accInfoReqFlagOldVal = event.result.fundConfigEntryActionForm.accInfoRequired;
	gxodwFlagOldVal = event.result.fundConfigEntryActionForm.gxOdwRequired;
	smartPortReqOldVal = event.result.fundConfigEntryActionForm.smartPortRequired;
	isFamFundExist = event.result.fundConfigEntryActionForm.isFundExistinFam;
	
	//22. Setting values of  GST Flag
	initColl.removeAll();
	if (event.result.fundConfigEntryActionForm.gstFlagList.item != null)
	{
		if (event.result.fundConfigEntryActionForm.gstFlagList.item is ArrayCollection)
		{
			initColl=event.result.fundConfigEntryActionForm.gstFlagList.item as ArrayCollection;
		}
		else
		{
			initColl.addItem(event.result.fundConfigEntryActionForm.gstFlagList.item);
		}
	}

	tempColl=new ArrayCollection();
	tempColl.addItem({label: " ", value: " "});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	this.gstFlag.dataProvider=tempColl;
	if (event.result.fundConfigEntryActionForm.gstFlag == undefined)
	{
		event.result.fundConfigEntryActionForm.gstFlag='N';
	}
	this.gstFlag.selectedIndex=getIndexOfLabelValueBean(tempColl, event.result.fundConfigEntryActionForm.gstFlag);

	doValidate();
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

/**
 * Calculates the index of an item, within a given
 * array collection.
 * Returns 0 if the value is null or empty string.
 */
private function getIndex(collection:ArrayCollection, value:String):int
{
	var index:int=0;
	if (value == null || value == XenosStringUtils.EMPTY_STR)
	{
		return index;
	}
	for (var count:int=0; count < collection.length; count++)
	{
		if (String(collection.getItemAt(count)) == value)
		{
			index=count;
			break;
		}
	}
	return index;
}

/**
 * Used to validate fundCategory as "TSTAR/OTHERS"
 */
private function doValidate():void
{
	this.baseCurrency.enabled=false;
	this.baseCurrency.ccyText.enabled=false;
	this.baseCurrency.imgCcy.enabled=false;

	if (XenosStringUtils.equals('TSTAR', this.fundCategoryList.text))
	{
		this.defaultUnderlyingAssertFlagFX.enabled=false;
		this.actualIntrimFlag.enabled=false;
		this.autoCompletionForMT566Reqd.enabled=false;
		this.accountingInfoRequired.enabled=false;
		this.fpsAdjustment.enabled=true;
	}
	else if (XenosStringUtils.equals('OTHERS', this.fundCategoryList.text))
	{
		this.fpsAdjustment.enabled=false;
	}
	loadAccountInfoSubFields();
}

/**
 * Based on fundCategory as "TSTAR/OTHERS" and AccountingInfoRequired flag,
 * the following attributes enabled.
 */
private function loadAccountInfoSubFields():void
{
	var attributeFlag:Boolean=false;
	if (XenosStringUtils.equals('Yes', this.accountingInfoRequired.text))
	{
		attributeFlag=true;
	}
	else
	{
		attributeFlag=false;
	}
	//On Amend Screen
	this.grGxodwAndSmartport.visible=attributeFlag;
	this.grGxodwAndSmartport.includeInLayout=attributeFlag;
	this.grDexReqAndBaltoNBL.visible=attributeFlag;
	this.grDexReqAndBaltoNBL.includeInLayout=attributeFlag;
	this.grShaFlagAndRepDate.visible=attributeFlag;
	this.grShaFlagAndRepDate.includeInLayout=attributeFlag;
	this.grOfficialName.visible=attributeFlag;
	this.grOfficialName.includeInLayout=attributeFlag;
	this.grBusinessDate.visible=attributeFlag;
	this.grBusinessDate.includeInLayout=attributeFlag;
	this.grInvestStarDate.visible=attributeFlag;
	this.grInvestStarDate.includeInLayout=attributeFlag;

	//On User Confirm
	this.ugrGxodwAndSmartport.visible=attributeFlag;
	this.ugrGxodwAndSmartport.includeInLayout=attributeFlag;
	this.ugrDexReqAndBaltoNBL.visible=attributeFlag;
	this.ugrDexReqAndBaltoNBL.includeInLayout=attributeFlag;
	this.ugrShaFlagAndgstFlag.visible=attributeFlag;
	this.ugrShaFlagAndgstFlag.includeInLayout=attributeFlag;
	this.ugrOfficialName.visible=attributeFlag;
	this.ugrOfficialName.includeInLayout=attributeFlag;
	this.ugrBusinessDate.visible=attributeFlag;
	this.ugrBusinessDate.includeInLayout=attributeFlag;
	this.ugrInvestStartDate.visible=attributeFlag;
	this.ugrInvestStartDate.includeInLayout=attributeFlag;
}


private function doReset():void
{
	var requestObj:Object=new Object();
	requestObj.fundPk=fundPkStr;
	requestObj.fundCode=fundCodeStr;
	loadFundConfigDetail.url="nam/fundConfigAmendDispatch.action?method=loadFundConfigurationDetail&" + rndNo;
	loadFundConfigDetail.request=requestObj;
	loadFundConfigDetail.send();
}

private function resetFormValues():void
{
	defaultUnderlyingAssertFlagFX.selectedIndex=0;
	actualIntrimFlag.selectedIndex=0;
	autoCompletionForMT566Reqd.selectedIndex=0;
	accountingInfoRequired.selectedIndex=0;
	gXODWRequired.selectedIndex=0;
	smartPortRequired.selectedIndex=0;
	dEXRequired.selectedIndex=0;
	balanceToNBL.selectedIndex=0;
	shariahFlag.selectedIndex=0;
	gstFlag.selectedIndex=0;
	reportDateFormat.selectedIndex=0;
	crimSuppressReqd.selectedIndex=0;
	balanceSuppressReqd.selectedIndex=0;
	mT54XRuleForShortAccReqd.selectedIndex=0;
	fpsAdjustment.selectedIndex=0;
	sbaRequiredFlag.selectedIndex=0;
	officialName.text = "";
	businessStartDate.text = "";
	businessEndDate.text = "";
	investStartDate.text = "";
	amendErrPage.removeError();
}

/**
 * go to previous page
 *
 */
private function doBack():void
{
	vstack.selectedChild=fundConfigAmendCanvas;
	app.submitButtonInstance=submit;
}

/**
 * doSubmitAmend
 */
private function doSubmitAmend():void
{
	errPage.visible=false;
	errPage.includeInLayout=false;
	var validateModel:Object={fundConfigAmend: 
		{
			fundCategory: this.fundCategoryList.text, 
			defUndAssetFX: this.defaultUnderlyingAssertFlagFX.text, 
			actualIntrimFlag: this.actualIntrimFlag.text, 
			autoCompletionForMT566Reqd: this.autoCompletionForMT566Reqd.text, 
			accountingInfoRequired: this.accountingInfoRequired.text, 
			gXODWRequired: this.gXODWRequired.text, 
			smartPortRequired: this.smartPortRequired.text, 
			dEXRequired: this.dEXRequired.text, 
			balanceToNBL: this.balanceToNBL.text, 
			shariahFlag: this.shariahFlag.text, 
			gstFlag: this.gstFlag.text, 
			offcialName: this.officialName.text, 
			reportDateFormat: this.reportDateFormat.text, 
			businessStartDate: this.businessStartDate.text, 
			businessEndDate: this.businessEndDate.text, 
			investStartDate: this.investStartDate.text,
			crimSuppressReqd: this.crimSuppressReqd.text, 
			balanceSuppressReqd: this.balanceSuppressReqd.text, 
			mT54XRuleForShortAccReqd: this.mT54XRuleForShortAccReqd.text, 
			fpsAdjustment: this.fpsAdjustment.text,
			sbaRequiredFlag: this.sbaRequiredFlag.text
		}};

	var fundConfigEntryValidator:FundConfigEntryValidator=new FundConfigEntryValidator();
	fundConfigEntryValidator.source=validateModel;
	fundConfigEntryValidator.property="fundConfigAmend";

	var showError:ArrayCollection = new ArrayCollection();
	if(XenosStringUtils.equals('Y', isFamFundExist))
	{
		if(XenosStringUtils.equals('Y', accInfoReqFlagOldVal) && XenosStringUtils.equals('N', accountingInfoRequired.selectedItem.value))
		{
			showError.addItem(this.parentApplication.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.error.famTransactionExist', 
						new Array(this.fundCode.text, this.parentApplication.xResourceManager.getKeyValue('nam.fundconfig.label.accountingInfoRequired'))));
		}
		if(XenosStringUtils.equals('Y', accountingInfoRequired.selectedItem.value))
		{
			if(XenosStringUtils.equals('Y', gxodwFlagOldVal) && XenosStringUtils.equals('N', gXODWRequired.selectedItem.value))
			{
				showError.addItem(this.parentApplication.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.error.famTransactionExist', 
						new Array(this.fundCode.text, this.parentApplication.xResourceManager.getKeyValue('nam.fundconfig.label.gxodwRequired'))));
			}
			if(XenosStringUtils.equals('Y', smartPortReqOldVal) && XenosStringUtils.equals('N', smartPortRequired.selectedItem.value))
			{
				showError.addItem(this.parentApplication.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.error.famTransactionExist', 
						new Array(this.fundCode.text, this.parentApplication.xResourceManager.getKeyValue('nam.fundconfig.label.smartPortRequired'))));
			}
		}
	}
	
	var validationResult:ValidationResultEvent=fundConfigEntryValidator.validate();
	if (validationResult.type == ValidationResultEvent.INVALID)
	{
		var errorMsg:String=validationResult.message;
		XenosAlert.error(errorMsg);
	}
	else if(showError.length > 0)
	{
		amendErrPage.showError(showError);
	}
	else
	{
		amendErrPage.removeError();
		vstack.selectedChild=fundConfConfirmation;

		this.ufundCode.text=this.fundCode.text;
		this.ufundName.text=this.fundName.text;
		this.ubaseCurrency.text=this.baseCurrency.ccyText.text;
		this.uofficeIdList.text=this.officeIdList.text;
		this.ufundCategoryList.text=this.fundCategoryList.text;

		this.udefaultUnderlyingAssertFlg.text=this.defaultUnderlyingAssertFlagFX.text;
		this.uactualIntrimFlag.text=this.actualIntrimFlag.text;
		this.uautoCompletionForMT566Reqd.text=this.autoCompletionForMT566Reqd.text;
		this.uaccountingInfoRequired.text=this.accountingInfoRequired.text;
		this.ugXODWRequired.text=this.gXODWRequired.text;
		this.usmartPortRequired.text=this.smartPortRequired.text;
		this.uDEXRequired.text=this.dEXRequired.text;
		this.ubalanceToNBL.text=this.balanceToNBL.text;
		this.ushariahFlag.text=this.shariahFlag.text;
		this.ugstFlag.text=this.gstFlag.text;
		this.uofficialName.text=this.officialName.text;
		this.ureportDateFormat.text=this.reportDateFormat.text;
		this.ubusinessStartDate.text=this.businessStartDate.text;
		this.ubusinessEndDate.text=this.businessEndDate.text;
		this.uinvestStartDate.text = this.investStartDate.text;

		this.ucrimSuppressReqd.text=this.crimSuppressReqd.text;
		this.ubalanceSuppressReqd.text=this.balanceSuppressReqd.text;
		this.umT54XRuleForShortAccReqd.text=this.mT54XRuleForShortAccReqd.text;
		this.uFpsAdjustment.text=this.fpsAdjustment.text;
		this.usbaRequiredFlag.text=this.sbaRequiredFlag.text;

	}
}

/**
 * Confirmation Screen
 */
private function doConfirm():void
{
	var requestObj:Object=new Object();
	requestObj.fundPk=fundPkStr;
	requestObj.defaultUnderlyingAssertFlg=defaultUnderlyingAssertFlagFX.selectedItem.value;
	requestObj.actualIntrimFlag=actualIntrimFlag.selectedItem.value
	requestObj.autoCompletionForMT566Reqd=autoCompletionForMT566Reqd.selectedItem.value;
	requestObj.accountingInfoRequired=accountingInfoRequired.selectedItem.value;
	if (XenosStringUtils.equals('Y', this.accountingInfoRequired.selectedItem.value))
	{
		requestObj.gXODWRequired=gXODWRequired.selectedItem.value;
		requestObj.smartPortRequired=smartPortRequired.selectedItem.value;
		requestObj.dEXRequired=dEXRequired.selectedItem.value;
		requestObj.balanceToNBL=balanceToNBL.selectedItem.value;
		requestObj.shariahFlag=shariahFlag.selectedItem.value;
		requestObj.gstFlag=gstFlag.selectedItem.value;
		requestObj.officialName=officialName.text;
		requestObj.reportDateFormat=reportDateFormat.selectedItem.value;
		requestObj.businessStartDate=businessStartDate.text;
		requestObj.businessEndDate=businessEndDate.text;
		requestObj.investmentStartDate=investStartDate.text;
	}
	requestObj.crimSuppressReqd=crimSuppressReqd.selectedItem.value;
	requestObj.balanceSuppressReqd=balanceSuppressReqd.selectedItem.value;
	requestObj.mT54XRuleForShortAccReqd=mT54XRuleForShortAccReqd.selectedItem.value;
	requestObj.fpsAdjustmentDisplayVal=fpsAdjustment.text;
	requestObj.fpsAdjustment=fpsAdjustment.selectedItem.value;
	requestObj.sbaRequiredFlag=sbaRequiredFlag.selectedItem.value;

	updateFundConfig.url="nam/fundConfigAmendDispatch.action?method=doConfirm&" + Math.random();
	updateFundConfig.request=requestObj;
	updateFundConfig.send();
}

/**
 * ConfirmResult Screen
 * @param event
 */
private function doConfirmResult(event:ResultEvent):void
{
	var rs:XML=XML(event.result);

	if (null != event)
	{
		if (event.result.hasOwnProperty("FundLock"))
		{
			errPage.visible = true;
			errPage.includeInLayout = true;
			errorLabel.text = "Fund Code [ "+this.ufundCode.text+" ] unable to Amend, due to Fund is in Lock State";
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
 * onclick - ok button
 * @param event
 */
private function ok(event:MouseEvent):void
{
	if(sConfLabel.visible)
	{
		this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
	}
}

/**
 * Handle enter event amend screen
 * @param event
 */
public function handleSubmitEntry(event:KeyboardEvent):void
{
	if(event.keyCode == Keyboard.ENTER)
	{
		submit.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
	}
}

/**
 * Handle enter event for user confirmation screnn.
 * @param event
 */
public function handleUserConf(event:KeyboardEvent):void
{
	if(event.keyCode == Keyboard.ENTER)
	{
		uConfSubmit.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
	}
}
			
/**
 * Handle enter event for system confirmation screen.
 * @param event
 */
public function handleSysConf(event:KeyboardEvent):void
{
	if(event.keyCode == Keyboard.ENTER)
	{
		this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
	}
}
