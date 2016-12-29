// ActionScript file

import com.nri.rui.cam.validators.SecurityInOutValidator;
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.OnDataChangeUtil;
import com.nri.rui.core.utils.XenosStringUtils;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.events.ValidationResultEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;



[Bindable]
private var app:XenosApplication=XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);

[Bindable]
private var mode:String="entry";
[Bindable]
private var marketPricePkStr:String="";
[Bindable]
private var camEntryPk:String="";
[Bindable]
private var inOutType:String="";
[Bindable]
private var inOut:String="";
[Bindable]
private var acctBalanceTypeVisibleFlag:Boolean=false;
[Bindable]
public var remarkStr:String="";
[Bindable]
private var rs:XML=new XML();
[Bindable]
private var spotCalculationDate:String="";

private const SECURITY_ENTRY_IN:String="I";
private const SECURITY_ENTRY_OUT:String="O";
private const CAMENTRY_REMARKS_LENGTH:int=100;
private var keylist:ArrayCollection=new ArrayCollection();

/*****/
//Items returning through context - Non display objects for accountPopup
[Bindable]
public var returnContextItem:ArrayCollection=new ArrayCollection();

private function changeCurrentState():void
{
	//hdbox1.selectedChild = this.rslt;
	//currentState = "result";
	vstack.selectedChild=rslt;
}

public function loadAll():void
{
	security.instrumentId.width=25 * security.instrumentId.measureText("A").width;
	security.instrumentId.minWidth=25 * security.instrumentId.measureText("A").width;
	parseUrlString();
	super.setXenosEntryControl(new XenosEntry());
	//XenosAlert.info("mode : "+mode);
	if (this.mode == 'entry')
	{
		this.dispatchEvent(new Event('entryInit'));
		this.fundActPopUp.accountNo.setFocus();

		vstack.selectedChild=qry;
	}
	else if (this.mode == 'amend')
	{
		this.dispatchEvent(new Event('amendEntryInit'));
		this.amendAdjustmentreason.setFocus();
		this.entryForm.includeInLayout=false;
		this.entryForm.visible=false;
		this.ws1.visible=false;
		this.amendForm.includeInLayout=true;
		this.amendForm.visible=true;

		vstack.selectedChild=qry;
	}
	else
	{
		this.dispatchEvent(new Event('cancelEntryInit'));
	}
}

/**
 * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
 *
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
				if (tempA[0] == "mode")
				{
					mode=tempA[1];
				}
				else if (tempA[0] == "camEntryPk")
				{
					this.camEntryPk=tempA[1];
				}
				else if (tempA[0] == "inOutType")
				{
					this.inOutType=tempA[1];
				}
			}
		}
		else
		{
			mode="entry";
		}

	}
	catch (e:Error)
	{
		trace(e);
	}
}

override public function preEntryInit():void
{
	var reqObject:Object=new Object();
	reqObject.rnd=Math.random();

	if (StringUtil.trim(inOutType) == SECURITY_ENTRY_IN)
	{
		super.getInitHttpService().url="cam/camSecurityEntryDispatch.action?method=initEntry&&inOutType=I&&mode=entry";
		initLabel.text=this.parentApplication.xResourceManager.getKeyValue('cam.securityinentry.header');
		reqObject.SCREEN_KEY=249;
	}
	else if (StringUtil.trim(inOutType) == SECURITY_ENTRY_OUT)
	{
		super.getInitHttpService().url="cam/camSecurityOutEntryDispatch.action?method=initEntry&&inOutType=O&&mode=entry";
		initLabel.text=this.parentApplication.xResourceManager.getKeyValue('cam.securityoutentry.header');
		reqObject.SCREEN_KEY=256;
	}
	else
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('cam.securityentry.prompt.specify.inout'));

	super.getInitHttpService().request=reqObject;
}


override public function preAmendInit():void
{
	initLabel.text=this.parentApplication.xResourceManager.getKeyValue('cam.securityamend.header');
	var rndNo:Number=Math.random();
	super.getInitHttpService().url="cam/camSecurityAmendDispatch.action?method=amendEntryDetails";
	var reqObject:Object=new Object();
	reqObject.rnd=rndNo;
	//reqObject.method= "amendEntryDetails";
	reqObject.mode=this.mode;
	reqObject.camEntryPk=this.camEntryPk;
	reqObject.SCREEN_KEY=257;
	super.getInitHttpService().request=reqObject;
}

override public function preCancelInit():void
{
	this.back.includeInLayout=false;
	this.back.visible=false;
	changeCurrentState();
	var rndNo:Number=Math.random();
	super.getInitHttpService().url="cam/camSecurityCancelDispatch.action?rnd=" + rndNo;
	var reqObject:Object=new Object();
	//reqObject.rnd = rndNo;
	reqObject.method="deleteEntryDetails";
	reqObject.mode=this.mode;
	reqObject.camEntryPk=this.camEntryPk;
	reqObject.SCREEN_KEY=382;
	super.getInitHttpService().request=reqObject;
}

private function addCommonKeys():void
{
	keylist=new ArrayCollection();

	keylist.addItem("camSecEntry.inOutDateStr");
	keylist.addItem("camSecEntry.gleLedgerCode");
	keylist.addItem("actionFormList.gleLedgerCodeList.item");
	keylist.addItem("camSecEntry.reasonCode");
	keylist.addItem("actionFormList.reasonCodeList.item");
	keylist.addItem("camSecEntry.inOut");
	keylist.addItem("camSecEntry.acctBalanceTypeVisibleFlag");
	keylist.addItem("camSecEntry.accountBalanceTypeStr");

}

override public function preEntryResultInit():Object
{
	addCommonKeys();
	return keylist;
}

override public function preAmendResultInit():Object
{
	//addCommonKeys();

	keylist=new ArrayCollection();

	keylist.addItem("camSecEntry.referenceNo");
	keylist.addItem("camSecEntry.accountDisplayNo");
	keylist.addItem("camSecEntry.inOut");
	keylist.addItem("camSecEntry.inOutDisplayDate");
	keylist.addItem("camSecEntry.securityCode");
	keylist.addItem("camSecEntry.amountDisplayValue");
	keylist.addItem("camSecEntry.bookValueStr");
	keylist.addItem("actionFormList.reasonCodeList.item");
	keylist.addItem("camSecEntry.reasonCode");
	keylist.addItem("camSecEntry.debitLedgerId");
	keylist.addItem("camSecEntry.creditLedgerId");
	keylist.addItem("camSecEntry.custodianBank");
	keylist.addItem("camSecEntry.ourSettleAccountNo");
	keylist.addItem("camSecEntry.bcBookValue");
	keylist.addItem("camSecEntry.accruedIntPaid");
	keylist.addItem("camSecEntry.issueCcy");
	keylist.addItem("camSecEntry.remarks");
	keylist.addItem("camSecEntry.statementDescription");
	keylist.addItem("camSecEntry.accountShortName");
	keylist.addItem("camSecEntry.securityName");
	keylist.addItem("camSecEntry.ourSettleAccountName");
	keylist.addItem("camSecEntry.custodianBankName");
	keylist.addItem("camSecEntry.acruedIntPaidBC");
	keylist.addItem("camSecEntry.baseCcy");
	keylist.addItem("camSecEntry.bcAccruedIntPaid");
	keylist.addItem("camSecEntry.spotCalcDate");
	keylist.addItem("camSecEntry.calculatedSpotRate");
	keylist.addItem("camSecEntry.spotCalcDisplayDate");

	return keylist;
}

override public function preCancelResultInit():Object
{
	addCommonResultKes();
	keylist.addItem("camSecEntry.referenceNo");
	return keylist;
}


private function commonInit(mapObj:Object):void
{

	var initcol:ArrayCollection;
	var index:int=0;
	this.security.instrumentId.text="";
	this.fundActPopUp.accountNo.text="";
	this.bankPopUp.finInstCode.text="";
	this.actPopUp.accountNo.text="";
	this.quantity.text="";
	this.bookValueStr.text="";
	this.remarks.text="";
	this.description.text="";
	this.spotCalcDateStr.text="";
	this.bookValueBcStr.text="";
	this.accruedIntPaidLcStr.text="";
	this.accruedIntPaidBcStr.text="";
	//this.inputPrice.text = "";

	errPage.clearError(super.getInitResultEvent());

	if (mapObj[keylist.getItemAt(0)] != null)
	{
		this.inOutDateStr.selectedDate=DateUtils.toDate(mapObj[keylist.getItemAt(0)].toString());

	}

	initcol=new ArrayCollection();

	initcol.addItem({label: " ", value: " "});
	index=-1;
	for each (var item:Object in(mapObj[keylist.getItemAt(2)] as ArrayCollection))
	{
		initcol.addItem(item);
	}
	/* gleledger.dataProvider = initcol; */
	//gleledger.selectedIndex = index !=-1 ? index+1 : 0;

	initcol=new ArrayCollection();

	initcol.addItem({label: " ", value: " "});
	index=-1;
	for each (item in(mapObj[keylist.getItemAt(4)] as ArrayCollection))
	{
		initcol.addItem(item);

	}
	adjustmentreason.dataProvider=initcol;
	//adjustmentreason.selectedIndex = index !=-1 ? index+1 : 0;

	this.inOut=mapObj[keylist.getItemAt(5)].toString();
	acctBalanceTypeVisibleFlag=mapObj[keylist.getItemAt(6)].toString() == "true" ? true : false;

	fundActPopUp.accountNo.addEventListener(FlexEvent.VALUE_COMMIT, onChangeFundAccountNo);
	bankPopUp.finInstCode.addEventListener(FlexEvent.VALUE_COMMIT, onChangeCustodianBank);
	actPopUp.accountNo.addEventListener(FlexEvent.VALUE_COMMIT, onChangeOurSettleAc);
	security.instrumentId.addEventListener(FlexEvent.VALUE_COMMIT, onChangeSecurity);

}

private function commonAmendInit(mapObj:Object):void
{

	var initcol:ArrayCollection;
	var index:int=0;

	errPage.clearError(super.getInitResultEvent());

	//XenosAlert.info("amendSecurity" + mapObj[keylist.getItemAt(4)].toString() + "  " + keylist.getItemAt(4));

	this.amendRefNo.text=mapObj[keylist.getItemAt(0)].toString();
	this.amendFundAccount.text=mapObj[keylist.getItemAt(1)].toString();
	this.amendFundAccountName.text=mapObj[keylist.getItemAt(18)].toString();
	this.amendSecInDate.text=mapObj[keylist.getItemAt(3)].toString();
	this.amendSecurity.text=mapObj[keylist.getItemAt(4)].toString();
	this.amendSecurityName.text=mapObj[keylist.getItemAt(19)].toString();
	this.amendQuantity.text=mapObj[keylist.getItemAt(5)].toString();
	this.amendBookValue.text=mapObj[keylist.getItemAt(6)].toString();

	this.inOut=mapObj[keylist.getItemAt(2)].toString();

	initcol=new ArrayCollection();

	initcol.addItem({label: " ", value: " "});
	index=-1;
	for each (var item:Object in(mapObj[keylist.getItemAt(7)] as ArrayCollection))
	{
		initcol.addItem(item);
		if (mode == "amend")
		{
			if (item.value == mapObj[keylist.getItemAt(8)].toString())
			{
				index=(mapObj[keylist.getItemAt(7)] as ArrayCollection).getItemIndex(item);
			}
		}
	}
	amendAdjustmentreason.dataProvider=initcol;
	amendAdjustmentreason.selectedIndex=index != -1 ? index + 1 : 0;

	this.amendDebitLedger.text=mapObj[keylist.getItemAt(9)].toString();
	this.amendCreditLedger.text=mapObj[keylist.getItemAt(10)].toString();

	this.amendCustBank.text=mapObj[keylist.getItemAt(11)].toString();
	this.amendCustBankName.text=mapObj[keylist.getItemAt(21)].toString();
	this.amendOurSettleAc.text=mapObj[keylist.getItemAt(12)].toString();
	this.amendOurSettleAcName.text=mapObj[keylist.getItemAt(20)].toString();
	/* this.amendLedgerCode.text = mapObj[keylist.getItemAt(13)].toString();
	this.amendLedgerName.text = mapObj[keylist.getItemAt(14)].toString(); */
	this.amendIssueCcy.text=mapObj[keylist.getItemAt(15)].toString();
	this.amendRemarks.text=mapObj[keylist.getItemAt(16)].toString();
	this.amendStmtDesc.text=mapObj[keylist.getItemAt(17)].toString();
	this.amendBaseCcy.text=mapObj[keylist.getItemAt(23)].toString();
	this.amendBookValueBC.text=mapObj[keylist.getItemAt(13)].toString();
	this.amendAccruedIntLc.text=mapObj[keylist.getItemAt(14)].toString();
	this.amendAccruedIntBc.text=mapObj[keylist.getItemAt(24)].toString();
	this.amendSpotCalcDate.text=mapObj[keylist.getItemAt(27)].toString();
	this.amendCalcSpotRate.text=mapObj[keylist.getItemAt(26)].toString();

}

override public function postEntryResultInit(mapObj:Object):void
{
	app.submitButtonInstance=submit;
	fundActPopUp.accountNo.setFocus();
	commonInit(mapObj);
	uWarnLabel.includeInLayout=false;
	uWarnLabel.visible=false;
	setFieldLabels();
}

public function setFieldLabels():void
{
	if (this.inOut == this.SECURITY_ENTRY_IN)
	{
		lblInOutDateStr.text=this.parentApplication.xResourceManager.getKeyValue('cam.securityinentry.label.securityindate');
		lblAmendSecInDate.text=this.parentApplication.xResourceManager.getKeyValue('cam.securityinentry.label.securityindate');
		lblAmendAdjustmentreason.text=this.parentApplication.xResourceManager.getKeyValue('cam.securityinentry.label.securityinreason');
		lbluConfSecInDate.text=this.parentApplication.xResourceManager.getKeyValue('cam.securityinentry.label.securityindate');
		lbluConfSecInReason.text=this.parentApplication.xResourceManager.getKeyValue('cam.securityinentry.label.securityinreason');
	}
	else
	{
		lblInOutDateStr.text=this.parentApplication.xResourceManager.getKeyValue('cam.securityinentry.label.securityoutdate');
		lblAmendSecInDate.text=this.parentApplication.xResourceManager.getKeyValue('cam.securityinentry.label.securityoutdate');
		lblAmendAdjustmentreason.text=this.parentApplication.xResourceManager.getKeyValue('cam.securityinentry.label.securityoutreason');
		lbluConfSecInDate.text=this.parentApplication.xResourceManager.getKeyValue('cam.securityinentry.label.securityoutdate');
		lbluConfSecInReason.text=this.parentApplication.xResourceManager.getKeyValue('cam.securityinentry.label.securityoutreason');
	}
}

override public function postAmendResultInit(mapObj:Object):void
{
	commonAmendInit(mapObj);
	setFieldLabels();
	if (this.inOut == this.SECURITY_ENTRY_IN)
		this.parentDocument.title=this.parentApplication.xResourceManager.getKeyValue('cam.security.in.amend.header');
	else
		this.parentDocument.title=this.parentApplication.xResourceManager.getKeyValue('cam.security.out.amend.header');

	app.submitButtonInstance=submit;
}

private function commonResultPart(mapObj:Object):void
{

	this.uConfFundAccount.text=mapObj[keylist.getItemAt(0)].toString();
	this.uConfFundAccountName.text=mapObj[keylist.getItemAt(19)].toString();
	this.inOut=mapObj[keylist.getItemAt(1)].toString();
	this.uConfSecInDate.text=mapObj[keylist.getItemAt(2)].toString();
	this.uConfSecurity.text=mapObj[keylist.getItemAt(3)].toString();
	this.uConfSecurityName.text=mapObj[keylist.getItemAt(20)].toString();

	if (mapObj[keylist.getItemAt(5)].toString() == null || mapObj[keylist.getItemAt(5)].toString() == ' ' || mapObj[keylist.getItemAt(5)].toString() == "" || mapObj[keylist.getItemAt(5)].toString() == " ")
	{
		this.uConfQuantity.text=mapObj[keylist.getItemAt(6)].toString();
	}
	else
	{
		this.uConfQuantity.text=mapObj[keylist.getItemAt(5)].toString();
	}

	this.uConfBookValue.text=mapObj[keylist.getItemAt(7)].toString();
	this.uConfSecInReason.text=mapObj[keylist.getItemAt(8)].toString();
	this.uConfDebitLedger.text=mapObj[keylist.getItemAt(9)].toString();
	this.uConfCreditLedger.text=mapObj[keylist.getItemAt(10)].toString();
	this.uConfCustBank.text=mapObj[keylist.getItemAt(11)].toString();
	this.uConfCustBankName.text=mapObj[keylist.getItemAt(22)].toString();
	this.uConfOurSettleAc.text=mapObj[keylist.getItemAt(12)].toString();
	this.uConfOurSettleAcName.text=mapObj[keylist.getItemAt(21)].toString();
	this.uConfBookValueBC.text=mapObj[keylist.getItemAt(13)].toString();
	this.uConfAcruedIntPaidLc.text=mapObj[keylist.getItemAt(14)].toString();
	this.uConfIssueCcy.text=mapObj[keylist.getItemAt(15)].toString();
	this.uConfRemarks.text=mapObj[keylist.getItemAt(16)].toString();
	this.uConfStmtDesc.text=mapObj[keylist.getItemAt(17)].toString();
	this.uConBaseCcy.text=mapObj[keylist.getItemAt(24)].toString();
	this.uConfSpotCalcDate.text=mapObj[keylist.getItemAt(25)].toString();
	this.uConfSpotRate.text=mapObj[keylist.getItemAt(26)].toString();
	this.uConfAcruedIntPaidBC.text=mapObj[keylist.getItemAt(23)].toString()

/* this.uConFAcruedIntPaidBC=mapObj[keylist.getItemAt(22)].toString();   */


}

override public function postCancelResultInit(mapObj:Object):void
{

	commonResultPart(mapObj);
	this.uConfRefNo.text=mapObj[keylist.getItemAt(27)].toString();
	//uConfLabel.text="Market Price Cancel";
	uConfSubmit.includeInLayout=false;
	uConfSubmit.visible=false;
	cancelSubmit.visible=true;
	cancelSubmit.includeInLayout=true;
	setFieldLabels();
	if (this.inOut == this.SECURITY_ENTRY_IN)
		this.parentDocument.title=this.parentApplication.xResourceManager.getKeyValue('cam.security.in.cancel.header');
	else
		this.parentDocument.title=this.parentApplication.xResourceManager.getKeyValue('cam.security.out.cancel.header');

	app.submitButtonInstance=cancelSubmit;
	this.cancelSubmit.setFocus();
}

private function addCommonResultKes():void
{
	keylist=new ArrayCollection();

	keylist.addItem("camSecEntry.formattedAccountNo");
	keylist.addItem("camSecEntry.inOut");
	keylist.addItem("camSecEntry.inOutDateStr");
	keylist.addItem("camSecEntry.securityCode");
	keylist.addItem("forUpdate");
	keylist.addItem("camSecEntry.amountDisplayValue");
	keylist.addItem("camSecEntry.amountStr");
	keylist.addItem("camSecEntry.formatingBookValueStr");
	keylist.addItem("camSecEntry.reasonCodeForDisplay");
	keylist.addItem("camSecEntry.debitLedgerId");
	keylist.addItem("camSecEntry.creditLedgerId");
	keylist.addItem("camSecEntry.custodianBank");
	keylist.addItem("camSecEntry.ourSettleAccountNo");
	keylist.addItem("camSecEntry.bookValueBC");
	keylist.addItem("camSecEntry.acruedIntPaid");
	keylist.addItem("camSecEntry.issueCcy");
	keylist.addItem("camSecEntry.remarks");
	keylist.addItem("camSecEntry.statementDescription");
	keylist.addItem("camSecEntry.warningMessage");
	keylist.addItem("camSecEntry.accountShortName");
	keylist.addItem("camSecEntry.securityName");
	keylist.addItem("camSecEntry.ourSettleAccountName");
	keylist.addItem("camSecEntry.custodianBankName");
	keylist.addItem("camSecEntry.acruedIntPaidBC");
	keylist.addItem("camSecEntry.baseCcy");
	keylist.addItem("camSecEntry.spotCalcDate");
	keylist.addItem("camSecEntry.calcSpotRate");

}

private function commonResult(mapObj:Object):void
{
	back.enabled=true;
	uConfSubmit.enabled=true;
	if (mapObj != null)
	{
		if (mapObj["errorFlag"].toString() == "error")
		{
			//result = mapObj["errorMsg"] .toString();
			if (mode != "cancel")
			{
				errPage.showError(mapObj["errorMsg"]);
			}
			else
			{
				XenosAlert.error(mapObj["errorMsg"]);
			}
		}
		else if (mapObj["errorFlag"].toString() == "noError")
		{

			errPage.clearError(super.getSaveResultEvent());
			commonResultPart(mapObj);
			changeCurrentState();

			app.submitButtonInstance=uConfSubmit;
			uConfSubmit.setFocus();

		}
		else
		{
			errPage.removeError();
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cam.securityentry.prompt.no.data'));
		}
	}
}



private function setValidator():void
{

	var validateModel:Object={securityInOutEntry: {accountNo: this.fundActPopUp.accountNo.text, inOutDateStr: this.inOutDateStr.text, securityCode: this.security.instrumentId.text, amountStr: this.quantity.text, bankCode: this.bankPopUp.finInstCode.text, ourSettleAccountNo: this.actPopUp.accountNo.text,
		//acctBalanceTypeVisibleFlag:
		//accountBalanceTypeStr:
				bookValueStr: this.bookValueStr.text, spotCalcDate: this.spotCalcDateStr.text, bookValueBC: this.bookValueBcStr.text, reasonCode: this.adjustmentreason.selectedItem != null ? this.adjustmentreason.selectedItem.value : "", inOutType: this.inOut, accruedIntStr: this.accruedIntPaidBcStr.text}, securityInOutAmend: {accountNo: this.amendFundAccount.text, inOutDateStr: this.amendSecInDate.text, securityCode: this.amendSecurity.text, amountStr: this.amendQuantity.text, bankCode: this.amendCustBank.text, ourSettleAccountNo: this.amendOurSettleAc.text,
				//acctBalanceTypeVisibleFlag:
				//accountBalanceTypeStr:
				bookValueStr: this.amendBookValue.text, reasonCode: this.amendAdjustmentreason.selectedItem != null ? this.amendAdjustmentreason.selectedItem.value : "", inOutType: this.inOut}};
	super._validator=new SecurityInOutValidator();
	super._validator.source=validateModel;
	if (this.mode == "entry")
	{
		super._validator.property="securityInOutEntry";
	}
	else if (this.mode == "amend")
	{
		super._validator.property="securityInOutAmend";
	}
}

override public function preEntry():void
{
	setValidator();
	var requestObj:Object=populateRequestParams();
	//XenosAlert.info("preEntry ");
	if (StringUtil.trim(inOutType) == SECURITY_ENTRY_IN)
	{
		super.getSaveHttpService().url="cam/camSecurityEntryDispatch.action?method=doConfirm";
		requestObj['SCREEN_KEY']=250;
	}
	else if (StringUtil.trim(inOutType) == SECURITY_ENTRY_OUT)
	{
		super.getSaveHttpService().url="cam/camSecurityOutEntryDispatch.action?method=doConfirm";
		requestObj['SCREEN_KEY']=250;
	}
	else
	{
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('cam.securityentry.prompt.specify.inout'));
	}

	super.getSaveHttpService().request=requestObj;
}

override public function preAmend():void
{
	setValidator();
	super.getSaveHttpService().url="cam/camSecurityAmendDispatch.action?method=doConfirm";

	var reqObj:Object=new Object();

	reqObj['entry.reasonCode']=this.amendAdjustmentreason.selectedItem != null ? this.amendAdjustmentreason.selectedItem.value : "";
	reqObj['entry.remarks']=this.amendRemarks.text;
	reqObj['entry.statementDescription']=this.amendStmtDesc.text;
	reqObj['SCREEN_KEY']=250;

	super.getSaveHttpService().request=reqObj;

}

override public function preCancel():void
{
	//setValidator();
	super._validator=null;
	super.getSaveHttpService().url="cam/camSecurityCancelDispatch.action?rnd=" + Math.random();
	var reqObj:Object=new Object();
	reqObj.method="doDeleteConfirm";
	reqObj.mode=this.mode;
	reqObj.SCREEN_KEY=383;
	super.getSaveHttpService().request=reqObj;
}


override public function preEntryResultHandler():Object
{
	addCommonResultKes();
	return keylist;
}

override public function preAmendResultHandler():Object
{
	addCommonResultKes();
	return keylist;
}

override public function preCancelResultHandler():Object
{
//            addCommonResultKes();    
	keylist.removeAll();
	keylist.addItem("camSecEntry.referenceNo");

	return keylist;
}

override public function postCancelResultHandler(mapObj:Object):void
{
	submitUserConfResult(mapObj);

	if (mapObj != null && mapObj["errorFlag"].toString() != "error")
	{
		if (this.inOut == this.SECURITY_ENTRY_IN)
			this.parentDocument.title=this.parentApplication.xResourceManager.getKeyValue('cam.security.in.cancel.header') + " - " + this.parentApplication.xResourceManager.getKeyValue('cam.common.header.user.confirm');
		else
			this.parentDocument.title=this.parentApplication.xResourceManager.getKeyValue('cam.security.out.cancel.header') + " - " + this.parentApplication.xResourceManager.getKeyValue('cam.common.header.user.confirm');

		uConfLabel.includeInLayout=true;
		uConfLabel.visible=true;
		cancelSubmit.visible=false;
		cancelSubmit.includeInLayout=false;
		uCancelConfSubmit.visible=true;
		uCancelConfSubmit.includeInLayout=true;
		sConfSubmit.includeInLayout=false;
		sConfSubmit.visible=false;
		sConfLabel.includeInLayout=false;
		sConfLabel.visible=false;

		uConfRefNo.text=mapObj[keylist.getItemAt(0)].toString();

		app.submitButtonInstance=uCancelConfSubmit;
		uCancelConfSubmit.setFocus();
	}

}

override public function postEntryResultHandler(mapObj:Object):void
{

	commonResult(mapObj);
	uConfLabel.includeInLayout=true;
	uConfLabel.visible=true;
	uConfImg.includeInLayout=false;
	uConfImg.visible=false;
	if (StringUtil.trim(inOutType) == SECURITY_ENTRY_IN)
	{
		usrCnfMessage.text=this.parentApplication.xResourceManager.getKeyValue('cam.securityinentry.header') + " - " + this.parentApplication.xResourceManager.getKeyValue('cam.common.header.user.confirm');
	}
	else if (StringUtil.trim(inOutType) == SECURITY_ENTRY_OUT)
	{
		usrCnfMessage.text=this.parentApplication.xResourceManager.getKeyValue('cam.securityoutentry.header') + " - " + this.parentApplication.xResourceManager.getKeyValue('cam.common.header.user.confirm');
		if (mapObj[keylist.getItemAt(18)] != null && StringUtil.trim(mapObj[keylist.getItemAt(18)].toString()))
		{
			outBalConfLabel.includeInLayout=true;
			outBalConfLabel.visible=true;
			this.outBalCnfMessage.text=mapObj[keylist.getItemAt(18)].toString();
		}
		else
		{
			outBalConfLabel.includeInLayout=false;
			outBalConfLabel.visible=false;
		}
	}
	else
	{
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('cam.securityentry.prompt.specify.inout'));
	}
	//usrCnfMessage.text ="Security In Entry - User Confirmation ";
}

override public function postAmendResultHandler(mapObj:Object):void
{
	commonResult(mapObj);
	if (this.inOut == this.SECURITY_ENTRY_IN)
		this.parentDocument.title=this.parentApplication.xResourceManager.getKeyValue('cam.security.in.amend.header') + " - " + this.parentApplication.xResourceManager.getKeyValue('cam.common.header.user.confirm');
	else
		this.parentDocument.title=this.parentApplication.xResourceManager.getKeyValue('cam.security.out.amend.header') + " - " + this.parentApplication.xResourceManager.getKeyValue('cam.common.header.user.confirm');

}



override public function preEntryConfirm():void
{
	var reqObj:Object=new Object();
	if (StringUtil.trim(this.inOut) == SECURITY_ENTRY_IN)
	{
		super.getConfHttpService().url="cam/camSecurityEntryDispatch.action?method=doSave";
		reqObj['SCREEN_KEY']=251;
	}
	else if (StringUtil.trim(this.inOut) == SECURITY_ENTRY_OUT)
	{
		super.getConfHttpService().url="cam/camSecurityOutEntryDispatch.action?method=doSave";
		reqObj['SCREEN_KEY']=251;
	}
	else
	{
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('cam.securityentry.prompt.specify.inout'));
	}

	//reqObj.method= "confirmEntry";
	super.getConfHttpService().request=reqObj;
}

override public function preAmendConfirm():void
{
	var reqObj:Object=new Object();
	super.getConfHttpService().url="cam/camSecurityAmendDispatch.action?method=doSave";
	//reqObj.method= "doSave";
	reqObj['SCREEN_KEY']=251;
	super.getConfHttpService().request=reqObj;
}

override public function preCancelConfirm():void
{
	var reqObj:Object=new Object();
	super.getConfHttpService().url="cam/camSecurityCancelDispatch.action?rnd=" + Math.random();
	reqObj.method="doSave";
	reqObj.SCREEN_KEY=384;
	super.getConfHttpService().request=reqObj;
}

override public function preEntryConfirmResultHandler():Object
{
	addCommonResultKes();

	keylist.addItem("camSecEntry.referenceNo");

	return keylist;
}

override public function postConfirmEntryResultHandler(mapObj:Object):void
{
	submitUserConfResult(mapObj);
	if (mapObj != null && mapObj["errorFlag"].toString() != "error")
	{
		uConfLabel.includeInLayout=true;
		uConfLabel.visible=true;
		uConfImg.includeInLayout=false;
		uConfImg.visible=false;

		//usrCnfMessage.text ="Security In Entry - System Confirmation ";

		if (StringUtil.trim(inOutType) == SECURITY_ENTRY_IN)
		{
			usrCnfMessage.text=this.parentApplication.xResourceManager.getKeyValue('cam.securityinentry.header') + " - " + this.parentApplication.xResourceManager.getKeyValue('cam.common.header.sys.confirm');
		}
		else if (StringUtil.trim(inOutType) == SECURITY_ENTRY_OUT)
		{
			usrCnfMessage.text=this.parentApplication.xResourceManager.getKeyValue('cam.securityoutentry.header') + " - " + this.parentApplication.xResourceManager.getKeyValue('cam.common.header.sys.confirm');
			outBalConfLabel.includeInLayout=false;
			outBalConfLabel.visible=false;
		}
		else
		{
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('cam.securityentry.prompt.specify.inout'));
		}
	}

}

override public function preConfirmAmendResultHandler():Object
{
	return preEntryConfirmResultHandler();
}

override public function postConfirmAmendResultHandler(mapObj:Object):void
{
	submitUserConfResult(mapObj);
	if (mapObj != null && mapObj["errorFlag"].toString() != "error")
	{
		if (this.inOut == this.SECURITY_ENTRY_IN)
			this.parentDocument.title=this.parentApplication.xResourceManager.getKeyValue('cam.security.in.amend.header') + " - " + this.parentApplication.xResourceManager.getKeyValue('cam.common.header.sys.confirm');
		else
			this.parentDocument.title=this.parentApplication.xResourceManager.getKeyValue('cam.security.out.amend.header') + " - " + this.parentApplication.xResourceManager.getKeyValue('cam.common.header.sys.confirm');
		;
	}


}

override public function preConfirmCancelResultHandler():Object
{
	keylist=new ArrayCollection();
	keylist.addItem("camSecEntry.referenceNo");
	keylist.addItem("camSecEntry.cxlRefNo");

	return keylist;
}

override public function postConfirmCancelResultHandler(mapObj:Object):void
{
	submitUserConfResult(mapObj);

	if (mapObj != null && mapObj["errorFlag"].toString() != "error")
	{
		if (this.inOut == this.SECURITY_ENTRY_IN)
			this.parentDocument.title=this.parentApplication.xResourceManager.getKeyValue('cam.security.in.cancel.header') + " - " + this.parentApplication.xResourceManager.getKeyValue('cam.common.header.sys.confirm');
		else
			this.parentDocument.title=this.parentApplication.xResourceManager.getKeyValue('cam.security.out.cancel.header') + " - " + this.parentApplication.xResourceManager.getKeyValue('cam.common.header.sys.confirm');

		cancelSubmit.visible=false;
		cancelSubmit.includeInLayout=false;
		uCancelConfSubmit.visible=false;
		uCancelConfSubmit.includeInLayout=false;
		uConfLabel.includeInLayout=false;
		uConfLabel.visible=false;

		txnMessage.text=this.parentApplication.xResourceManager.getKeyValue('inf.label.confirm.txn') + this.parentApplication.xResourceManager.getKeyValue('inf.label.refno') + " : " + mapObj[keylist.getItemAt(0)].toString() + ". " + this.parentApplication.xResourceManager.getKeyValue('inf.label.cxl.refno') + " : " + mapObj[keylist.getItemAt(1)].toString() + ".";
		uConfRefNo.text=mapObj[keylist.getItemAt(0)].toString();

		app.submitButtonInstance=sConfSubmit;
		sConfSubmit.setFocus();
	}



}

private function submitUserConfResult(mapObj:Object):void
{
	//var mapObj:Object = mkt.userConfResultEvent(event);
	if (mapObj != null)
	{
		if (mapObj["errorFlag"].toString() == "error")
		{
			//XenosAlert.error(mapObj["errorMsg"].toString());
			if (mode != "cancel")
			{
				errPage.showError(mapObj["errorMsg"]);
				vstack.selectedChild=qry;
				if (this.mode == "entry")
				{
					uWarnLabel.includeInLayout=false;
					uWarnLabel.visible=false;
				}
			}
			else if (mode == "cancel")
			{
				errPageCancel.showError(mapObj["errorMsg"]);
				errPageCancel.visible=true;
				errPageCancel.includeInLayout=true;
			}
		}
		else if (mapObj["errorFlag"].toString() == "noError")
		{
			if (mode != "cancel")
				errPage.clearError(super.getConfResultEvent());
			this.back.includeInLayout=false;
			this.back.visible=false;
			uConfSubmit.enabled=true;
			uConfLabel.includeInLayout=false;
			uConfLabel.visible=false;
			uConfSubmit.includeInLayout=false;
			uConfSubmit.visible=false;
			sConfLabel.includeInLayout=true;
			sConfLabel.visible=true;
			sConfSubmit.includeInLayout=true;
			sConfSubmit.visible=true;
			if (this.mode != "cancel")
			{
				txnMessage.text=this.parentApplication.xResourceManager.getKeyValue('inf.label.confirm.txn') + this.parentApplication.xResourceManager.getKeyValue('inf.label.refno') + " : " + mapObj[keylist.getItemAt(27)].toString() + ".";
				uConfRefNo.text=mapObj[keylist.getItemAt(27)].toString();

				app.submitButtonInstance=sConfSubmit;
				sConfSubmit.setFocus();
			}

			//enable top row
			sRefNoRow.includeInLayout=true;
			sRefNoRow.visible=true;

		}
		else
		{
			errPage.removeError();
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cam.common.prompt.error.occurred'));
		}
	}
}

/**
* This method will populate the request parameters for the
* submitQuery call and bind the parameters with the HTTPService
* object.
*/
private function populateRequestParams():Object
{

	var reqObj:Object=new Object();

	//reqObj.method= "doConfirm";//method=doConfirm

	//reqObj['entry.prefix'] = 
	reqObj['entry.accountNo']=this.fundActPopUp.accountNo.text;
	reqObj['entry.custodianBank']=this.bankPopUp.finInstCode.text;
	//reqObj['entry.ourSettlePrefix'] = 
	reqObj['entry.ourSettleAccountNo']=this.actPopUp.accountNo.text;
	reqObj['entry.securityCode']=this.security.instrumentId.text;
	reqObj['entry.amountStr']=this.quantity.text;
	reqObj['entry.form']="BOOK ENTRY";

	reqObj['entry.inOutDateStr']=this.inOutDateStr.text;
	reqObj['entry.bookValueStr']=this.bookValueStr.text;
	reqObj['entry.bookValueBC']=this.bookValueBcStr.text;
	reqObj['entry.acruedIntPaidBC']=this.accruedIntPaidBcStr.text;
	reqObj['entry.acruedIntPaid']=this.accruedIntPaidLcStr.text;
	/*  reqObj['entry.gleLedgerCode'] = this.gleledger.selectedItem != null? this.gleledger.selectedItem.value : ""; */
	reqObj['entry.reasonCode']=this.adjustmentreason.selectedItem != null ? this.adjustmentreason.selectedItem.value : "";
	//reqObj['entry.debitLedgerId'] = 
	//reqObj['entry.creditLedgerId'] = 
	reqObj['entry.remarks']=this.remarks.text;
	reqObj['entry.statementDescription']=this.description.text;
	reqObj['entry.spotCalcDate']=this.spotCalcDateStr.text;
	reqObj['entry.acruedIntPaid']=this.accruedIntPaidLcStr.text;

	if (acctBalanceTypeVisibleFlag == true)
		reqObj['entry.accountBalanceTypeStr']=0;

	reqObj['security']="SECURITY";
	reqObj['cash']="CASH";
	reqObj['rnd']=Math.random();



	return reqObj;
}

override public function preResetEntry():void
{
	var rndNo:Number=Math.random();
	var reqObject:Object=new Object();
	reqObject.method="resetEntry";
	if (StringUtil.trim(this.inOut) == SECURITY_ENTRY_IN)
	{
		super.getResetHttpService().url="cam/camSecurityEntryDispatch.action?rnd=" + rndNo;
		reqObject.SCREEN_KEY=249;
	}
	else if (StringUtil.trim(this.inOut) == SECURITY_ENTRY_OUT)
	{
		super.getResetHttpService().url="cam/camSecurityOutEntryDispatch.action?rnd=" + rndNo;
		reqObject.SCREEN_KEY=256;
	}
	else
	{
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('cam.securityentry.prompt.specify.inout'));
	}
	super.getResetHttpService().request=reqObject;
}

override public function preResetAmend():void
{
	var rndNo:Number=Math.random();
	super.getResetHttpService().url="cam/camSecurityAmendDispatch.action?method=amendEntryDetails&rnd=" + rndNo;
	var reqObject:Object=new Object();
	//reqObject.rnd = rndNo;
	//reqObject.method= "amendEntryDetails";
	reqObject.mode=this.mode;
	reqObject.camEntryPk=this.camEntryPk;
	super.getResetHttpService().request=reqObject;
}

override public function doEntrySystemConfirm(e:Event):void
{
	super.preEntrySystemConfirm();
	this.dispatchEvent(new Event('entryReset'));
	this.back.includeInLayout=true;
	this.back.visible=true;
	uConfLabel.includeInLayout=true;
	uConfLabel.visible=true;
	uConfSubmit.includeInLayout=true;
	uConfSubmit.visible=true;
	sConfLabel.includeInLayout=false;
	sConfLabel.visible=false;
	sConfSubmit.includeInLayout=false;
	sConfSubmit.visible=false;

	//hdbox1.selectedChild = this.qry;
	// this.currentState="entryState";
	sRefNoRow.includeInLayout=false;
	sRefNoRow.visible=false;

	vstack.selectedChild=qry;
	super.postEntrySystemConfirm();

}

override public function doAmendSystemConfirm(e:Event):void
{
	//this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
	this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
}

override public function doCancelSystemConfirm(e:Event):void
{
	//this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
	this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
}

private function doBack():void
{
	//hdbox1.selectedChild = this.qry;
	//this.currentState="entryState";
	vstack.selectedChild=qry;
	if (this.mode == "amend")
	{
		if (this.inOut == this.SECURITY_ENTRY_IN)
			this.parentDocument.title=this.parentApplication.xResourceManager.getKeyValue('cam.security.in.amend.header');
		else
			this.parentDocument.title=this.parentApplication.xResourceManager.getKeyValue('cam.security.out.amend.header');
	}
	if (this.mode == "entry")
	{
		uWarnLabel.includeInLayout=false;
		uWarnLabel.visible=false;
	}
	app.submitButtonInstance=submit;
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
* This method is used to enable the Book Value LC field
*
*/
/* private function enablebookValueBcStr():void{

	if(bookValueChkBx.selected){

		bookValueBcStr.editable=true;
	}
	else{

		bookValueBcStr.text="";
		bookValueBcStr.editable=false;    	}

}  */


/**
 * This method must be executed before the click event.
 * Used to initializde the mandatory values.
 */
private function populateOurBankContext():ArrayCollection
{
	//pass the context data to the popup
	var myContextList:ArrayCollection=new ArrayCollection();

	//passing account no                
	var accountNoArray:Array=new Array(1);
	accountNoArray[0]=this.fundActPopUp.accountNo.text;
	myContextList.addItem(new HiddenObject("accountNo", accountNoArray));

	ourBankPopup.fundAcNo=fundActPopUp.accountNo.text;
	ourBankPopup.recContextItem=myContextList;
	return myContextList;
}

/**
 * This is the method to pass the Collection of data items
 * through the context to the account popup. This will be implemented as per specifdic
 * requriment.
 */
private function populateSettleAccountContext():ArrayCollection
{
	//pass the context data to the popup
	var myContextList:ArrayCollection=new ArrayCollection();
	//passing counter party type                
	var cpTypeArray:Array=new Array(1);
	cpTypeArray[0]="BANK/CUSTODIAN";
	myContextList.addItem(new HiddenObject("invCPTypeContext", cpTypeArray));

	var actType:Array=new Array(2);
	actType[0]="S";
	actType[1]="B";
	myContextList.addItem(new HiddenObject("actTypeContext", actType));

	//passing account status                
	var actStatusArray:Array=new Array(1);
	actStatusArray[0]="OPEN";
	myContextList.addItem(new HiddenObject("statusContext", actStatusArray));

	return myContextList;
}

/**
 * This is the method to pass the Collection of data items
 * through the context to the FinInst popup.
 */
private function populateFinInstRole():ArrayCollection
{
	//pass the context data to the popup
	var myContextList:ArrayCollection=new ArrayCollection();

	var bankRoleArray:Array=new Array(4); //Bank/Custodian|Central Depository|Security Broker|Stock Exchange
	bankRoleArray[0]="Bank/Custodian";
	bankRoleArray[1]="Central Depository";
	bankRoleArray[2]="Security Broker";
	bankRoleArray[3]="Stock Exchange";

	myContextList.addItem(new HiddenObject("bankRoles", bankRoleArray));

	return myContextList;
}

/**
 * Formatting amount
 */
private function quantityHandler():void
{

//        var vResult:ValidationResultEvent;
//        var tmpStr:String = quantity.text;
//        vResult = numVal.validate();
//        
//        if (vResult.type==ValidationResultEvent.VALID) {
//            quantity.text=numberFormatter.format(quantity.text);            
//        }else{
//            quantity.text = tmpStr;           
//        }
}

/**
* Formatting amount
*/
private function bookValueHandler():void
{

//        var vResult:ValidationResultEvent;
//        var tmpStr:String = bookValueStr.text;
//        vResult = numVal2.validate();
//        
//        if (vResult.type==ValidationResultEvent.VALID) {
//            bookValueStr.text=numberFormatter.format(bookValueStr.text);            
//        }else{
//            bookValueStr.text = tmpStr;           
//        }
}

/**
* This is the focusOut handler of the Fund Account No.
*/
private function inputHandler():void
{

	var fundAcStr:String=fundActPopUp.accountNo.text;
	if (!XenosStringUtils.isBlank(fundAcStr))
	{

		var req:Object=new Object();
		req['entry.accountNo']=fundAcStr;
		if (StringUtil.trim(inOutType) == SECURITY_ENTRY_IN)
		{
			loadBankAndBankAccountForFund.request=req;
			loadBankAndBankAccountForFund.send();
		}
		else
		{
			loadBankAndBankAccountForFundForOut.request=req;
			loadBankAndBankAccountForFundForOut.send();
		}
	}
	else
	{
		// Remove the custodian Bank and the Our settle A/c
		if (errPage.isError())
		{
			//disableBankAndFinInst();
		}
		else
		{
			bankPopUp.finInstCode.text="";
			actPopUp.accountNo.text="";
		}
	}
}

/**
 * This method will populate Bank and bank Account once a Fund Code is chosen.
 * If multiple Banks are associated witha fundCode, then user has to select one
 * from the bank popup correspoding the Fund Code. If a single bank is associated
 * with a Fund, the bank is shown and made non-editable. If it has a single account,
 * account is shown and made non-editable. If multiple accounts are present,
 * user has to choose one from the Account popup.
 */
private function populateBankAndBankAccount(event:ResultEvent):void
{
	rs=XML(event.result);

	if (null != event)
	{
		if (rs.child("Errors").length() > 0)
		{
			// i.e. Must be error, display it .
			var errorInfoList:ArrayCollection=new ArrayCollection();
			//populate the error info list                  
			for each (var error:XML in rs.Errors.error)
			{
				errorInfoList.addItem(error.toString());
			}
			uWarnLabel.includeInLayout=false;
			uWarnLabel.visible=false;
			errPage.showError(errorInfoList); //Display the error
				//disableBankAndFinInst();
				//submit.enabled = false;
		}
		else
		{
			// Clear the error
			errPage.removeError();
			if (rs.camSecEntry.warningMultipleBank != null && !XenosStringUtils.isBlank(rs.camSecEntry.warningMultipleBank))
			{
				uWarnLabel.includeInLayout=true;
				uWarnLabel.visible=true;
				usrWarnMessage.text=StringUtil.trim(rs.camSecEntry.warningMultipleBank);

				bankPopUp.finInstCode.text="";
				actPopUp.accountNo.text="";
			}


			if (rs.entry.warningMultipleBank == null || StringUtil.trim(rs.camSecEntry.warningMultipleBank) == "")
			{

				uWarnLabel.includeInLayout=false;
				uWarnLabel.visible=false;

				bankPopUp.finInstCode.text=rs.camSecEntry.custodianBank;
				actPopUp.accountNo.text=rs.camSecEntry.ourSettleAccountNo;
			}

		}
	}
	else
	{
		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cam.common.prompt.event.null'));
	}
}

/**
* This is the click handler of the Book Value Generate button.
*/
private function generateBookValue():void
{

	var requestObj:Object=populateRequestParams();
	requestObj.method="loadCalaculateBookValue";
	onClickBookValueGenerate.request=requestObj;

	var validateModel:Object={bookValueGenerate: {validateBookValue: "true", validateBookValueBC: "false", calculationMode: "localBv", accountNo: this.fundActPopUp.accountNo.text, inOutDateStr: this.inOutDateStr.text, securityCode: this.security.instrumentId.text, amountStr: this.quantity.text, inOutType: this.inOut}}

	var validateSecIO:SecurityInOutValidator=new SecurityInOutValidator();
	validateSecIO.source=validateModel;
	validateSecIO.property="bookValueGenerate";
	var validationResult:ValidationResultEvent=validateSecIO.validate();

	if (validationResult.type == ValidationResultEvent.INVALID)
	{
		var errorMsg:String=validationResult.message;
		XenosAlert.error(errorMsg);

	}
	else
	{
		//Set the button disabled to prevent multiple submissions
		//submit.enabled = false; 
		//var rndNo:int= Math.random(); 
		onClickBookValueGenerate.url="cam/camSecurityEntryDispatch.action?rnd=" + Math.random();
		onClickBookValueGenerate.send();
	}

}

/**
* This is the click handler of the Book Value BC Generate button.
*/
private function generateBookValueBC():void
{

	var requestObj:Object=populateRequestParams();
	requestObj.method="loadCalaculateBookValueBC";
	onClickBookValueBCGenerate.request=requestObj;
	var validateModel:Object={bookValueGenerate: {validateBookValue: "false", validateBookValueBC: "true", calculationMode: "baseBv", spotCalcDate: this.spotCalcDateStr.text, accountNo: this.fundActPopUp.accountNo.text, inOutDateStr: this.inOutDateStr.text, securityCode: this.security.instrumentId.text, amountStr: this.quantity.text, inOutType: this.inOut}}

	var validateSecIOBC:SecurityInOutValidator=new SecurityInOutValidator();
	validateSecIOBC.source=validateModel;
	validateSecIOBC.property="bookValueGenerate";
	var validationResultBC:ValidationResultEvent=validateSecIOBC.validate();
	if (validationResultBC.type == ValidationResultEvent.INVALID)
	{
		var errorMsgBC:String=validationResultBC.message;
		XenosAlert.error(errorMsgBC);
	}
	else
	{
		//Set the button disabled to prevent multiple submissions
		//submit.enabled = false; 
		//var rndNo:int= Math.random(); 
		
		
		if (StringUtil.trim(inOutType) == SECURITY_ENTRY_IN) {
			onClickAccruedIntBCGenerate.url="cam/camSecurityEntryDispatch.action?rnd=" + Math.random();
		} else if (StringUtil.trim(inOutType) == SECURITY_ENTRY_OUT) {
			onClickAccruedIntBCGenerate.url="cam/camSecurityOutEntryDispatch.action?rnd=" + Math.random();
		}

		onClickBookValueBCGenerate.send();
	}

}

/**
* This is the click handler of the Accrued Interest Paid BC Generate button.
*/
private function calculateAccruedIntPaidBC():void
{

	var requestObj:Object=populateRequestParams();
	requestObj.method="loadCalculateAcruedIntPaidBC";
	onClickAccruedIntBCGenerate.request=requestObj;
	var validateModel:Object={acruedIntValueGenerate: {validateBookValue: "false", validateBookValueBC: "flase", validateAcruedIntBC: "true", calculationMode: "baseAcruedInt", spotCalcDate: this.spotCalcDateStr.text, accountNo: this.fundActPopUp.accountNo.text, inOutDateStr: this.inOutDateStr.text, securityCode: this.security.instrumentId.text, amountStr: this.quantity.text, inOutType: this.inOut}}

	var validateSecIOBC:SecurityInOutValidator=new SecurityInOutValidator();
	validateSecIOBC.source=validateModel;
	validateSecIOBC.property="acruedIntValueGenerate";
	var validationResultBC:ValidationResultEvent=validateSecIOBC.validate();
	if (validationResultBC.type == ValidationResultEvent.INVALID)
	{
		var errorMsgBC:String=validationResultBC.message;
		XenosAlert.error(errorMsgBC);
	}
	else
	{
		//Set the button disabled to prevent multiple submissions
		//submit.enabled = false; 
		//var rndNo:int= Math.random(); 
		if (StringUtil.trim(inOutType) == SECURITY_ENTRY_IN) {
			onClickAccruedIntBCGenerate.url="cam/camSecurityEntryDispatch.action?rnd=" + Math.random();
		} else if (StringUtil.trim(inOutType) == SECURITY_ENTRY_OUT) {
			onClickAccruedIntBCGenerate.url="cam/camSecurityOutEntryDispatch.action?rnd=" + Math.random();
		}
		onClickAccruedIntBCGenerate.send();
	}

}

/**
 * This method will populate book value calculated.
 */
private function populateWithBookValueGenerated(event:ResultEvent):void
{
	rs=XML(event.result);

	if (null != event)
	{
		if (rs.child("Errors").length() > 0)
		{
			// i.e. Must be error, display it .
			var errorInfoList:ArrayCollection=new ArrayCollection();
			//populate the error info list                  
			for each (var error:XML in rs.Errors.error)
			{
				errorInfoList.addItem(error.toString());
			}
			errPage.showError(errorInfoList); //Display the error
				//disableBankAndFinInst();
				//submit.enabled = false;
		}
		else
		{
			// Clear the error
			errPage.removeError();
			//XenosAlert.info("Book Value : " + rs.camSecEntry.bookValueStr);                             
			bookValueStr.text=rs.camSecEntry.bookValueStr;
		}
	}
	else
	{
		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cam.common.prompt.event.null'));
	}
}


/**
* This method will populate book value BC calculated.
*/
private function populateWithBookValueBCGenerated(event:ResultEvent):void
{
	rs=XML(event.result);

	if (null != event)
	{
		if (rs.child("Errors").length() > 0)
		{
			// i.e. Must be error, display it .
			var errorInfoList:ArrayCollection=new ArrayCollection();
			//populate the error info list                  
			for each (var error:XML in rs.Errors.error)
			{
				errorInfoList.addItem(error.toString());
			}
			errPage.showError(errorInfoList); //Display the error
				//disableBankAndFinInst();
				//submit.enabled = false;
		}
		else
		{
			// Clear the error
			errPage.removeError();
			//XenosAlert.info("Book Value : " + rs.camSecEntry.bookValueStr);                             
			bookValueBcStr.text=rs.camSecEntry.bookValueBC;
			//this.spotCalcDateStr.text=rs.camSecEntry.spotCalcDate;
		

			/* if (XenosStringUtils.equals(this.spotCalcDateStr.text, XenosStringUtils.EMPTY_STR))
			{
				spotCalcDateStr.text="";
			} */
		}
	}
	else
	{
		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cam.common.prompt.event.null'));
	}
}

/**
 * This method will populate Acrued Int Paid BC calculated.
 */
private function populateAcruedIntPaidBCGenerated(event:ResultEvent):void
{
	rs=XML(event.result);

	if (null != event)
	{
		if (rs.child("Errors").length() > 0)
		{
			// i.e. Must be error, display it .
			var errorInfoList:ArrayCollection=new ArrayCollection();
			//populate the error info list                  
			for each (var error:XML in rs.Errors.error)
			{
				errorInfoList.addItem(error.toString());
			}
			errPage.showError(errorInfoList); //Display the error
				//disableBankAndFinInst();
				//submit.enabled = false;
		}
		else
		{
			// Clear the error
			errPage.removeError();
			//XenosAlert.info("Book Value : " + rs.camSecEntry.bookValueStr);                             
			// bookValueBcStr.text = rs.camSecEntry.bookValueBC;
			accruedIntPaidBcStr.text=rs.camSecEntry.acruedIntPaidBC;
			//this.spotCalculationDate=rs.camSecEntry.spotCalcDate;

			/* if (XenosStringUtils.equals(this.spotCalcDateStr.text, XenosStringUtils.EMPTY_STR))
			{   
			   spotCalcDateStr.text="";
			} */

		}
	}
	else
	{
		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cam.common.prompt.event.null'));
	}
}


private function onChangeFundAccountNo(event:Event):void
{
	OnDataChangeUtil.onChangeFundAccountNo(fundaccountname, fundActPopUp.accountNo.text);
}

private function onChangeCustodianBank(event:Event):void
{
	OnDataChangeUtil.onChangeBankCode(custodianbankname, bankPopUp.finInstCode.text);
}

private function onChangeOurSettleAc(event:Event):void
{
	OnDataChangeUtil.onChangeAccountNo(oursettleacname, actPopUp.accountNo.text);
}

private function onChangeSecurity(event:Event):void
{
	OnDataChangeUtil.onChangeSecurityCode(securityname, security.instrumentId.text);
}

private function submitUConf(mode:String):void
{
	back.enabled=false;
	uConfSubmit.enabled=false;
	if (mode == 'entry')
		this.dispatchEvent(new Event('entryConf'));
	else
		this.dispatchEvent(new Event('amendEntryConf'));

}

