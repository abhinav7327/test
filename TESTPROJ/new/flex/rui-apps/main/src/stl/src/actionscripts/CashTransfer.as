// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.XenosPopupUtils;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.stl.Utility.SettlementUtils;
import com.nri.rui.stl.popupImpl.BankListPopup;
import com.nri.rui.stl.validators.CashTransferEntryValidator;
import com.nri.rui.stl.validators.WireInstructionPopupValidator;

import flash.events.Event;
import flash.events.FocusEvent;

import mx.collections.ArrayCollection;
import mx.controls.TextInput;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.ResourceEvent;
import mx.events.ValidationResultEvent;
import mx.managers.PopUpManager;
import mx.resources.ResourceBundle;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;
import mx.validators.Validator;
	  
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    [Bindable]
    public var retCtxItem:ArrayCollection = new ArrayCollection();
    [Bindable]private var rowNum : String = "";
    [Bindable]private var mode : String = "entry";
    [Bindable]private var csiPk : String = "";
    [Bindable]private var cePk : String = "";
    [Bindable]private var wrType : String = "";
    [Bindable]private var tempObj : Object = null;
    [Bindable]private var bankFlag : String = null;
    [Bindable]private var amtTemp:String = null;
    [Bindable]private var gleLedgerCodeArrFirmReceipt:ArrayCollection = new ArrayCollection();
    [Bindable]private var gleLedgerCodeArrFirmPayment:ArrayCollection = new ArrayCollection();
    [Bindable]private static var iError:int = 0;
    [Bindable]private var tradeDateStr : String = null;
    [Bindable]
    private var clientSettlementInfoVoAttbList:ArrayCollection = new ArrayCollection();
    
    [Bindable]
    private	var settlementInfoVoAttbList:ArrayCollection       = new ArrayCollection();
    
    [Bindable]
    private	var settlementDetailVoAttbList:ArrayCollection     = new ArrayCollection();
    
    [Bindable]private static var strAutoPopulateStaticFlag:String = "";
    
    private var tempFundCode:String = "";
    private var tempCurrency:String = "";
    
    private var keylist:ArrayCollection = new ArrayCollection();
   [Bindable]private var cpStandingRulePk:TextInput = new TextInput();
   [Bindable]private var ownStandingRulePk:TextInput = new TextInput();
   
   /* The following imports sometimes vanish from this file, which leads to build error.
   
	import com.nri.rui.core.controls.XenosEntry;
	import com.nri.rui.stl.popupImpl.BankListPopup;
	import com.nri.rui.stl.validators.WireInstructionPopupValidator;
	import com.nri.rui.stl.validators.CashTransferEntryValidator;
   */ 
    
    public function loadAll():void {
    	parseUrlString();
    	super.setXenosEntryControl(new XenosEntry());
    	app.submitButtonInstance = submit;
    	if(this.mode == 'entry'){
       	   	 this.dispatchEvent(new Event('entryInit'));
       	   	 vstack.selectedChild = qry;
       	   	 this.fundCodeBox.fundCode.setFocus();
	     	 this.qry.addEventListener(FocusEvent.FOCUS_IN,showReturnContext);
	     	 this.toSettleAccount.accountNo.addEventListener(FocusEvent.FOCUS_IN,populateToBankViaAccountPopUp);
	     	 this.fromSettleAccount.accountNo.addEventListener(FocusEvent.FOCUS_IN,populateFromBankViaAccountPopUp);	     	 
	     } else {
	     	this.dispatchEvent(new Event('cancelEntryInit'));
	     }
    }
	
	private function changeCurrentState(strWireType:String):void{
		
		this.vstack.selectedChild = rslt;
		if(this.mode == "entry") {
			this.subVstack.selectedChild = dispEntry;
			this.uConfEntryGrid.removeAllChildren();
			if(this.wireType.selectedItem.value == 'BANK_TO_BANK') {
				this.wireViewStackUConf.selectedChild = bankVst;
				chooseUConfEntryGrid('BANK');
			} else {
				this.wireViewStackUConf.selectedChild = firmVst;
				chooseUConfEntryGrid('FIRM');
			}
		} else if(this.mode == "cancel") {
			this.subVstack.selectedChild = disp;
			this.uConfCancelGrid.removeAllChildren();
			if(strWireType == 'BANK_TO_BANK') {
				this.wireViewStackUConfCancel.selectedChild = bankVstCancel;
				chooseUConfCancelGrid('BANK');
			} else {
				this.wireViewStackUConfCancel.selectedChild = firmVstCancel;
				chooseUConfCancelGrid('FIRM');
			}
		}
	 }
	 
	 /**
	 * Validate Wire Amount 
	 * Wire Amount can't contain more than 15 digit before decimal 
	 * and more than 3 digits after decimal
	 */
	 private function validateWireAmount(txtField:TextInput ):void{
	 	
		var strQty:String = txtField.text;
	 	var digitsAfterDecimalArray:Array = strQty.split(".");
	 	var digitsBeforeDecimal:String = digitsAfterDecimalArray[0];
		var digitsAfterDecimal:String = digitsAfterDecimalArray[1];
		if(Number(digitsBeforeDecimal) > 999999999999999){
			txtField.text = "";
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.fifteendigits.allowed.before.decimalpoint'));
			return;
		}
		else if(Number(digitsAfterDecimal) > 999){
			txtField.text = "";
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.threedigits.allowed.after.decimalpoint'));
			return;
		}
		        	
	 	SettlementUtils.changeNumberFormat(this.wireAmount,'Amount');
	 	return;
	 }
	 
	 private function chooseUConfEntryGrid(str:String):void {
	 	uConfEntryGrid.addChildAt(uConfEntryWireTypeGrid,0);
	 	uConfEntryGrid.addChildAt(uConfEntryFundGrid,1);
	 	uConfEntryGrid.addChildAt(uConfEntryCurrencyGrid,2);
	 	if(str == 'BANK') {
	 	
			uConfEntryGrid.addChildAt(uConfEntryWireAmountValueDateGrid,3);
			uConfEntryGrid.addChildAt(uConfEntryInxTransmissionGrid,4);
			uConfEntryGrid.addChildAt(uConfEntryCorrespondingSecurityIdGrid,5);
			uConfEntryGrid.addChildAt(uConfEntryRemarksGrid,6);
	 	} else {
	 		
	 		uConfEntryGrid.addChildAt(uConfEntryCpAccountNoGrid,3);
	 		uConfEntryGrid.addChildAt(uConfEntryFundAccountNoGrid,4);
	 		uConfEntryGrid.addChildAt(uConfEntryWireAmountValueDateGrid,5);
	 		uConfEntryGrid.addChildAt(uConfEntryGleLedgerCodeTradeDateGrid,6);
	 		uConfEntryGrid.addChildAt(uConfEntryInxTransmissionGrid,7);
	 		uConfEntryGrid.addChildAt(uConfEntryCorrespondingSecurityIdGrid,8);
	 		uConfEntryGrid.addChildAt(uConfEntryRemarksGrid,9);
	 	}
	 }
	 private function chooseUConfCancelGrid(str:String):void {
	 	uConfCancelGrid.addChildAt(uConfCancelWireTypeGrid,0);
	 	uConfCancelGrid.addChildAt(uConfCancelFundCurrencyGrid,1);
	 	uConfCancelGrid.addChildAt(uConfCancelCurrencyGrid,2);
	 	if(str == 'BANK') {
			uConfCancelGrid.addChildAt(uConfCancelWireAmountValueDateGrid,3);
			uConfCancelGrid.addChildAt(uConfCancelInxTransmissionCorrespondingSecurityIdGrid,4);
			uConfCancelGrid.addChildAt(uConfCancelRemarksGrid,5);
	 	} else {
	 		uConfCancelGrid.addChildAt(uConfCancelCpAccountGrid,3);
	 		uConfCancelGrid.addChildAt(uConfCancelFundAccountGrid,4);
	 		uConfCancelGrid.addChildAt(uConfCancelWireAmountValueDateGrid,5);
	 		uConfCancelGrid.addChildAt(uConfCancelGleLedgerCodeTradeDateGrid,6);
	 		uConfCancelGrid.addChildAt(uConfCancelInxTransmissionCorrespondingSecurityIdGrid,7);
	 		uConfCancelGrid.addChildAt(uConfCancelRemarksGrid,8);
	 	}
	 }
    /**
    * At the time of loading the module if the module specific Resource is not loaded then load them
    * 
    */ 
    public function loadResourceBundle():void {
        var locales:String = this.parentApplication.xResourceManager.localeChain[0];
        
        var resourceModuleURL:String = "assets/appl/stl/stlResources_" + locales + ".swf";
           
        var bundle:ResourceBundle = ResourceBundle(resourceManager.getResourceBundle(locales, "stlResources"));
           
        var eventDispatcher:IEventDispatcher = null;
        if(bundle == null) {    
            eventDispatcher = this.parentApplication.xResourceManager.loadResourceModule(resourceModuleURL);
            eventDispatcher.addEventListener(ResourceEvent.ERROR, errorHandler);            
        }        
        this.parentApplication.xResourceManager.update();
    }
    
    private function errorHandler(event:ResourceEvent):void {
        XenosAlert.error("Error Occured while loading STL Resource Bundle :: " + event.errorText);
    }
   
    /**
     * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
     * 
     */ 
    public function parseUrlString():void {
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
            if(params != null) {
                for (var i:int = 0; i < params.length; i++) {
                    var tempA:Array = params[i].split("="); 
                    if (tempA[0] == "mode") {
                        mode = tempA[1];
                    } else if(tempA[0] == "csiPk") {
                        this.csiPk = tempA[1];
                    } else if(tempA[0] == "itemIndex") {
                        this.rowNum = tempA[1];
                    } else if(tempA[0] == "wrType") {
                        this.wrType = tempA[1];
                    } else if(tempA[0] == "cePk"){
                    	this.cePk = tempA[1];
                    }
                }                    	
            } else {
            	mode = "entry";
            }                 

        } catch (e:Error) {
            trace(e);
        }               
    }
            
        override public function preEntryInit():void {
        	var reqObject:Object = new Object();
        	reqObject.rnd = Math.random();
        	reqObject.SCREEN_KEY = 437;
        	super.getInitHttpService().request = reqObject;
        	super.getInitHttpService().url = "stl/wireInstructionDetailsEntryDispatch.action?method=initialExecute&mode=entry";
        
	    }
        
        override public function preCancelInit():void {            	
	        this.back.includeInLayout = false;
		    this.back.visible = false;
		    changeCurrentState(this.wrType); 			             	
	        var rndNo:Number= Math.random(); 
        	var reqObject:Object = new Object();
        	reqObject.rnd = rndNo;
        	reqObject.method= "doDelete";
	  		reqObject.index = this.rowNum;
	  		reqObject.csiPk = this.csiPk;
	  		reqObject.cePk = this.cePk;
	  		reqObject.SCREEN_KEY = 537;
	  		super.getInitHttpService().request = reqObject;
	  		super.getInitHttpService().url = "stl/wireInstructionDetailsCancelDispatch.action?";
        }
        
        private function addCommonKeys():void {        	
	    	keylist = new ArrayCollection();
	    	keylist.addItem("dropDownListValues.wireTypeList.item");
	    	keylist.addItem("dropDownListValues.inxTransmissionList.item");
	    	keylist.addItem("dropDownListValues.firmPaymentLedgerList.item");
	    	keylist.addItem("dropDownListValues.firmReceiptLedgerList.item");
	    	keylist.addItem("tradeDateStr");
        }
        
        override public function preEntryResultInit():Object{
        	addCommonKeys(); 
        	return keylist;
        }
        
        
        override public function preCancelResultInit():Object {
        	this.parentDocument.owner.errPageResultSummary.removeError();
        	addCommonResultKesForCancel();         	
        	return keylist;
        }
        
        
        private function commonInit(mapObj:Object,strCommon:String):void {
        	
        	tempObj = mapObj;
        	
        	if(commonGrid.contains(cpAccountNoGridRow)) {
        		commonGrid.removeChild(cpAccountNoGridRow);
        	}
        	if(commonGrid.contains(gleLedgerTradeDateGridRow)) {
        		commonGrid.removeChild(gleLedgerTradeDateGridRow);
        	}

        	toSettleAccount.accountNo.editable = false;
        	fromSettleAccount.accountNo.editable = false;
        	
        	/*** For WireType ***/
        	var wireTypeArr:ArrayCollection = new ArrayCollection();
        	for each(var itemWire:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)) {
	    		wireTypeArr.addItem(itemWire);
	    	}
	    	wireType.dataProvider  = wireTypeArr;
	    	
	    	/*** For InxTransmission ***/
	    	var inxTransmissionArr:ArrayCollection = new ArrayCollection();
        	for each(var itemInxTrans:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)) {
	    		inxTransmissionArr.addItem(itemInxTrans);
	    	}
	    	inxTransmission.dataProvider  = inxTransmissionArr;
	    	
	    	if(strCommon==null) {
		    	/*** For GleLedgerCode ***/
		    	gleLedgerCodeArrFirmPayment.removeAll();
				gleLedgerCodeArrFirmPayment.addItem({label:" ", value: " "});
				for each(var itemGleLedger:Object in (tempObj[keylist.getItemAt(2)] as ArrayCollection)) {
		    		gleLedgerCodeArrFirmPayment.addItem(itemGleLedger);
		    	}
		    	gleLedgerCodeArrFirmReceipt.removeAll();
		    	gleLedgerCodeArrFirmReceipt.addItem({label:" ", value: " "});
				for each(itemGleLedger in (tempObj[keylist.getItemAt(3)] as ArrayCollection)) {
		    		gleLedgerCodeArrFirmReceipt.addItem(itemGleLedger);
		    	}
		    	if(mapObj[keylist.getItemAt(4)]!=null){
			    	  tradeDateStr = mapObj[keylist.getItemAt(4)].toString();  		
		    	}
	    	}

        }
        
        override public function postEntryResultInit(mapObj:Object): void {
        	commonInit(mapObj,null);
        }
        
        
        private function commonResultPart(mapObj:Object):void {
        	 if(this.mode == "entry") {
        	 	populateConfirmationDetailsForEntry(mapObj);
        	 } else if(this.mode == "cancel") {
        	 	populateConfirmationDetailsForCancel(mapObj);
        	 }
        }
        
        /** This method is for populating User Confirmation Screen for Entry **/
        private function populateConfirmationDetailsForEntry(mapObj:Object):void {
        	
        	clientSettlementInfoVoAttbList = mapObj[keylist.getItemAt(3)] as ArrayCollection;
        	settlementInfoVoAttbList       = mapObj[keylist.getItemAt(4)] as ArrayCollection;
        	settlementDetailVoAttbList     = mapObj[keylist.getItemAt(5)] as ArrayCollection;
        	
        	this.uConfEntryWireType.text = mapObj[keylist.getItemAt(0)].toString();
        	this.uConfEntryFundCode.text      = getVoAttbValue(settlementInfoVoAttbList,'fundCode');
        	this.uConfEntryFundName.text      = getVoAttbValue(settlementInfoVoAttbList,'fundName');
        	this.uConfEntryCurrency.text      = getVoAttbValue(settlementDetailVoAttbList,'currency');
        	
        	this.uConfEntryCpAccountNo.text   = getVoAttbValue(settlementInfoVoAttbList,'account');
        	this.uConfEntryCpAccountName.text = getVoAttbValue(settlementInfoVoAttbList,'cpAccountName');
        	this.uConfEntryFundAccountNo.text        = getVoAttbValue(settlementInfoVoAttbList,'inventoryAccount');
			this.uConfEntryFundAccountName.text        = getVoAttbValue(settlementInfoVoAttbList,'fundAccountName');
			
        	this.uConfEntryWireAmount.text        = getVoAttbValue(settlementDetailVoAttbList,'wireAmount');
        	
        	this.uConfEntryValueDate.text      = getVoAttbValue(settlementInfoVoAttbList,'valueDate');
        	this.uConfEntryGleLedgerCode.text          = getVoAttbValue(clientSettlementInfoVoAttbList,'gleLedgerDisplayName');
        	this.uConfEntryTradeDate.text  = getVoAttbValue(clientSettlementInfoVoAttbList,'tradeDate');
        	this.uConfEntryInxTransmission.text  = mapObj[keylist.getItemAt(2)].toString();
        	this.uConfEntryCorrespondingSecurityId.text         = getVoAttbValue(settlementInfoVoAttbList,'correspondingSecurityId');
        	this.uConfEntryCorrespondingSecurityName.text         = getVoAttbValue(settlementInfoVoAttbList,'correspondingSecurityName');
        	this.uConfEntryRemarks.text           = mapObj[keylist.getItemAt(1)].toString();
        	
        	// For To Bank
        	this.uConfEntryToBank.text = getVoAttbValue(settlementDetailVoAttbList,'cpBank');
        	this.uConfEntryToBankName.text = getVoAttbValue(settlementDetailVoAttbList,'cpBankShortname');
        	this.uConfEntryToSettleAccountLabel.text = getVoAttbValue(settlementDetailVoAttbList,'cpSettleAc');
        	this.uConfEntryToSettleAccountLabelBracket.text = getVoAttbValue(settlementDetailVoAttbList,'toBrkNo');
        	this.uConfEntryToSettleAccountNameLabel.text = getVoAttbValue(settlementDetailVoAttbList,'cpSettleAcName');
        	this.uConfEntryCpSettleAccountNameLabel.text = getVoAttbValue(settlementDetailVoAttbList,'cpSettleAcName');
        	
        	// For From Bank
        	this.uConfEntryFromBank.text = getVoAttbValue(settlementDetailVoAttbList,'ourBank');
        	this.uConfEntryFromBankName.text = getVoAttbValue(settlementDetailVoAttbList,'ourBankShortname');
        	this.uConfEntryFromSettleAccountLabel.text = getVoAttbValue(settlementDetailVoAttbList,'ourSettleAc');
        	this.uConfEntryFromSettleAccountLabelBracket.text = getVoAttbValue(settlementDetailVoAttbList,'fromBrkNo');;
        	this.uConfEntryFromSettleAccountNameLabel.text = getVoAttbValue(settlementDetailVoAttbList,'ourSettleAcName');
        	this.uConfEntryOwnSettleAccountNameLabel.text = getVoAttbValue(settlementDetailVoAttbList,'ourSettleAcName');
        	
        	// For CP Bank
        	this.uConfEntryCpBank.text = getVoAttbValue(settlementDetailVoAttbList,'cpBank');
        	this.uConfEntryCpBankName.text = getVoAttbValue(settlementDetailVoAttbList,'cpBankShortname');
        	this.uConfEntryCpSettleAccountLabel.text = getVoAttbValue(settlementDetailVoAttbList,'cpSettleAc');
        	this.uConfEntryCpSettleAccountLabelBracket.text = getVoAttbValue(settlementDetailVoAttbList,'toBrkNo');
        	this.uConfEntryCpBeneficiaryName.text = mapObj[keylist.getItemAt(6)].toString();
        	
        	// For Our Bank
        	this.uConfEntryOwnBank.text = getVoAttbValue(settlementDetailVoAttbList,'ourBank');
        	this.uConfEntryOwnBankName.text = getVoAttbValue(settlementDetailVoAttbList,'ourBankShortname');
        	this.uConfEntryOwnSettleAccountLabel.text = getVoAttbValue(settlementDetailVoAttbList,'ourSettleAc');
        	this.uConfEntryOwnSettleAccountLabelBracket.text = getVoAttbValue(settlementDetailVoAttbList,'fromBrkNo');
        	
        }
        
        /** This method is for populating User Confirmation Screen for Cancel **/
        private function populateConfirmationDetailsForCancel(mapObj:Object):void {
        	
        	var message: String = mapObj[keylist.getItemAt(7)] != null ? mapObj[keylist.getItemAt(7)].toString() : '';
            if (!XenosStringUtils.isBlank(message)) {
                message = message + ' ' + this.parentApplication.xResourceManager.getKeyValue('stl.label.cashtransfer.cancel.notallowed');
                var errMsg:ArrayCollection = new ArrayCollection();
                errMsg.addItem(message);
                errPageCxl.showError(errMsg);
                cancelSubmit.enabled = false;
        	} else {
        		errPageCxl.removeError();
                cancelSubmit.enabled = true;        		
        	}
	        clientSettlementInfoVoAttbList = mapObj[keylist.getItemAt(3)] as ArrayCollection;
        	settlementInfoVoAttbList       = mapObj[keylist.getItemAt(4)] as ArrayCollection;
        	settlementDetailVoAttbList     = mapObj[keylist.getItemAt(5)] as ArrayCollection;
        	
        	var isPopulateFromCashEntry:Boolean = false;
        	if(!XenosStringUtils.equals(this.csiPk,"0")){
        		if(!XenosStringUtils.equals(this.cePk,"0")){
        			isPopulateFromCashEntry = true;
        		}else{
        			isPopulateFromCashEntry = false;
        		}
        	}else{
        		isPopulateFromCashEntry = true;
        	}
        	if(!isPopulateFromCashEntry){
        		this.uConfCancelWireType.text = mapObj[keylist.getItemAt(0)].toString();
        		this.uConfCancelFundCode.text      = getVoAttbValue(settlementInfoVoAttbList,'fundCode');
	        	this.uConfCancelFundName.text      = getVoAttbValue(settlementInfoVoAttbList,'fundName');
	        	this.uConfCancelCurrency.text      = getVoAttbValue(settlementDetailVoAttbList,'currency');
	        	
	        	this.uConfCancelCpAccountNo.text   = getVoAttbValue(settlementInfoVoAttbList,'account');
	        	this.uConfCancelCpAccountName.text   = getVoAttbValue(settlementInfoVoAttbList,'accountName');
	        	this.uConfCancelFundAccountNo.text        = getVoAttbValue(settlementInfoVoAttbList,'inventoryAccount');
	        	this.uConfCancelFundAccountName.text        = getVoAttbValue(settlementInfoVoAttbList,'inventoryAccountName');
	        	this.uConfCancelWireAmount.text        = getVoAttbValue(settlementDetailVoAttbList,'wireAmount');
	        	
	        	this.uConfCancelValueDate.text      = getVoAttbValue(settlementInfoVoAttbList,'valueDate');
	        	this.uConfCancelGleLedgerCode.text          = getVoAttbValue(clientSettlementInfoVoAttbList,'gleLedgerDisplayName');
	        	this.uConfCancelTradeDate.text  = getVoAttbValue(clientSettlementInfoVoAttbList,'tradeDate');
	        	this.uConfCancelInxTransmission.text  = mapObj[keylist.getItemAt(2)].toString();
	        	this.uConfCancelCorrespondingSecurityId.text         = getVoAttbValue(settlementInfoVoAttbList,'correspondingSecurityId');
	        	this.uConfCancelRemarks.text           = mapObj[keylist.getItemAt(1)].toString();
	        	
	        	// For To Bank
	        	this.uConfCancelToBank.text = getVoAttbValue(settlementDetailVoAttbList,'cpBank');
	        	this.uConfCancelToBankName.text = getVoAttbValue(settlementDetailVoAttbList,'cpBankShortname');
	        	this.uConfCancelToSettleAccountLabel.text = getVoAttbValue(settlementDetailVoAttbList,'cpSettleAc');
	        	this.uConfCancelToSettleAccountNameLabel.text = getVoAttbValue(settlementDetailVoAttbList,'cpSettleAcName');
	        	//this.uConfCancelToSettleAccountLabelBracket.text = getVoAttbValue(settlementDetailVoAttbList,'toBrkNo');
	        	
	        	// For From Bank
	        	this.uConfCancelFromBank.text = getVoAttbValue(settlementDetailVoAttbList,'ourBank');
	        	this.uConfCancelFromBankName.text = getVoAttbValue(settlementDetailVoAttbList,'ourBankShortname');
	        	this.uConfCancelFromSettleAccountLabel.text = getVoAttbValue(settlementDetailVoAttbList,'ourSettleAc');
	        	this.uConfCancelFromSettleAccountNameLabel.text = getVoAttbValue(settlementDetailVoAttbList,'ourSettleAcName');
	        	//this.uConfCancelFromSettleAccountLabelBracket.text = getVoAttbValue(settlementDetailVoAttbList,'fromBrkNo');
	        	
	        	// For CP Bank
	        	this.uConfCancelCpBank.text = getVoAttbValue(settlementDetailVoAttbList,'cpBank');
	        	this.uConfCancelCpBankName.text = getVoAttbValue(settlementDetailVoAttbList,'cpBankShortname');
	        	this.uConfCancelCpSettleAccountLabel.text = getVoAttbValue(settlementDetailVoAttbList,'cpSettleAc');
	        	//this.uConfCancelCpSettleAccountLabelBracket.text = getVoAttbValue(settlementDetailVoAttbList,'toBrkNo');
	        	this.uConfCancelCpBeneficiaryName.text = mapObj[keylist.getItemAt(6)].toString();
	        	
	        	// For Our Bank
	        	this.uConfCancelOwnBank.text = getVoAttbValue(settlementDetailVoAttbList,'ourBank');
	        	this.uConfCancelOwnBankName.text = getVoAttbValue(settlementDetailVoAttbList,'ourBankShortname');
	        	this.uConfCancelOwnSettleAccountLabel.text = getVoAttbValue(settlementDetailVoAttbList,'ourSettleAc');
	        	//this.uConfCancelOwnSettleAccountLabelBracket.text = getVoAttbValue(settlementDetailVoAttbList,'fromBrkNo');
        	}else{
        		//from authorization cash entry
        		this.uConfCancelWireType.text = mapObj["cashEntry.wireType"].toString();
				this.uConfCancelFundCode.text = mapObj["cashEntry.fundCode"].toString();
				this.uConfCancelFundName.text = mapObj["cashEntry.fundName"].toString();
				this.uConfCancelCurrency.text = mapObj["cashEntry.currency"].toString();
				
				this.uConfCancelCpAccountNo.text = mapObj["cashEntry.counterPartyAccountNo"].toString();
				this.uConfCancelCpAccountName.text = mapObj["cashEntry.counterPartyAccountName"].toString();
				this.uConfCancelFundAccountNo.text = mapObj["cashEntry.fundAccountNo"].toString();
				this.uConfCancelFundAccountName.text = mapObj["cashEntry.fundAccountName"].toString();
				this.uConfCancelWireAmount.text = mapObj["cashEntry.formattedWireAmount"].toString();
				
				this.uConfCancelValueDate.text = mapObj["cashEntry.valueDateStr"].toString();
				this.uConfCancelGleLedgerCode.text = mapObj["cashEntry.gleLedgerCode"].toString();
				this.uConfCancelTradeDate.text = mapObj["cashEntry.tradeDateStr"].toString();
				this.uConfCancelInxTransmission.text = mapObj["cashEntry.transmissionReqdFlag"].toString();
				this.uConfCancelCorrespondingSecurityId.text = mapObj["cashEntry.correspondingSecId"].toString();
				this.uConfCancelRemarks.text = mapObj["cashEntry.remarks"].toString();
				
				// For To Bank
				this.uConfCancelToBank.text = mapObj["cashEntry.toBank"].toString();
				this.uConfCancelToBankName.text = mapObj["cashEntry.toBankName"].toString();
				this.uConfCancelToSettleAccountLabel.text = mapObj["cashEntry.toSettleAccount"].toString();
				this.uConfCancelToSettleAccountNameLabel.text = mapObj["cashEntry.toSettleAccountName"].toString();
				
				// For From Bank
				this.uConfCancelFromBank.text = mapObj["cashEntry.fromBank"].toString();
				this.uConfCancelFromBankName.text = mapObj["cashEntry.fromBankName"].toString();
				this.uConfCancelFromSettleAccountLabel.text = mapObj["cashEntry.fromSettleAccount"].toString();
				this.uConfCancelFromSettleAccountNameLabel.text = mapObj["cashEntry.fromSettleAccountName"].toString();
				
				// For CP Bank
				this.uConfCancelCpBank.text = mapObj["cashEntry.cpBank"].toString();
				this.uConfCancelCpBankName.text = mapObj["cashEntry.cpBankName"].toString();
				this.uConfCancelCpSettleAccountLabel.text = mapObj["cashEntry.cpSettleAccountNo"].toString();
				this.uConfCancelCpBeneficiaryName.text = mapObj["cashEntry.beneficiaryName"].toString();
				
				// For Our Bank
				this.uConfCancelOwnBank.text = mapObj["cashEntry.ourBank"].toString();
				this.uConfCancelOwnBankName.text = mapObj["cashEntry.ourBankName"].toString();
				this.uConfCancelOwnSettleAccountLabel.text = mapObj["cashEntry.ourSettleAccountNo"].toString();
        	}
        	
        }
        
        override public function postCancelResultInit(mapObj:Object): void {
        	if(mapObj!=null) {
				var errorArrCol:ArrayCollection = mapObj["Errors.error"] as ArrayCollection;
				if(errorArrCol.length>0) {
					this.parentDocument.owner.errPageResultSummary.showError(errorArrCol);
		            this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
					return;
				} else {
					//XenosAlert.info("postCancelResultInit");
		        	commonResultPart(mapObj);
		        	uConfSubmit.includeInLayout = false;
		        	uConfSubmit.visible = false;
		        	cancelSubmit.visible = true;
		        	cancelSubmit.includeInLayout = true;
		        	app.submitButtonInstance = cancelSubmit;
				}
			}
        }
        
        /** This method is for Entry **/
        private function addCommonResultKes():void {
	    	keylist = new ArrayCollection();
	    	
	    	keylist.addItem("clientSettlementInfoVO.wireType");
	    	keylist.addItem("clientSettlementInfoVO.remarks");
	    	keylist.addItem("settlementInfoVO.transmissionReqdFlag");
	    	keylist.addItem("clientSettlementInfoVO.otherAttributes.entry");
	    	keylist.addItem("settlementInfoVO.otherAttributes.entry");
	    	keylist.addItem("settlementDetailVO.otherAttributes.entry");
	    	keylist.addItem("settlementDetailVO.beneficiaryName");
        }
        
        /** This method is for Cancel **/
        private function addCommonResultKesForCancel():void {
	    	keylist = new ArrayCollection();
	    	keylist.addItem("clientSettlementInfoVO.wireType");
	    	keylist.addItem("clientSettlementInfoVO.remarks");
	    	keylist.addItem("settlementInfoVO.transmissionReqdFlag");
	    	keylist.addItem("clientSettlementInfoVO.otherAttributes.entry");
	    	keylist.addItem("settlementInfoVO.otherAttributes.entry");
	    	keylist.addItem("settlementDetailVO.otherAttributes.entry");
            keylist.addItem("settlementDetailVO.beneficiaryName");
            keylist.addItem("message");
            keylist.addItem("Errors.error");
            keylist.addItem("cashEntry.wireType");
			keylist.addItem("cashEntry.fundCode");
			keylist.addItem("cashEntry.fundName");
			keylist.addItem("cashEntry.currency");
			keylist.addItem("cashEntry.counterPartyAccountNo");
			keylist.addItem("cashEntry.counterPartyAccountName");
			keylist.addItem("cashEntry.fundAccountNo");
			keylist.addItem("cashEntry.fundAccountName");
			keylist.addItem("cashEntry.formattedWireAmount");
			keylist.addItem("cashEntry.valueDateStr");
			keylist.addItem("cashEntry.gleLedgerCode");
			keylist.addItem("cashEntry.tradeDateStr");
			keylist.addItem("cashEntry.transmissionReqdFlag");
			keylist.addItem("cashEntry.correspondingSecId");
			keylist.addItem("cashEntry.remarks");
			keylist.addItem("cashEntry.toBank");
			keylist.addItem("cashEntry.toBankName");
			keylist.addItem("cashEntry.toSettleAccount");
			keylist.addItem("cashEntry.toSettleAccountName");
			keylist.addItem("cashEntry.fromBank");
			keylist.addItem("cashEntry.fromBankName");
			keylist.addItem("cashEntry.fromSettleAccount");
			keylist.addItem("cashEntry.fromSettleAccountName");
			keylist.addItem("cashEntry.cpBank");
			keylist.addItem("cashEntry.cpBankName");
			keylist.addItem("cashEntry.cpSettleAccountNo");
			keylist.addItem("cashEntry.beneficiaryName");
			keylist.addItem("cashEntry.ourBank");
			keylist.addItem("cashEntry.ourBankName");
			keylist.addItem("cashEntry.ourSettleAccountNo");
        }
        /**
		 * This method is used to get value from the map VO 
		 * w.r.t. the given key
		 */ 
		public function getVoAttbValue(attbList:ArrayCollection, attbKey:String):String {
			var attbValue:String = "";
			if(null != attbList){		
				for(var i:int = 0; i<attbList.length; i++){
					var temp:String = XML(attbList.getItemAt(i)).attribute("key");
					if(XenosStringUtils.equals(temp,attbKey)){
						attbValue = attbList[i].value;
						break;
					}
				}					
			}	
			return attbValue;
		}
        private function commonResult(mapObj:Object):void {
	    	if(mapObj!=null) {
		    	if(mapObj["errorFlag"].toString() == "error") {
		    		if(mode != "cancel"){
		    			errPage.showError(mapObj["errorMsg"]);
		    		} else {
		    			XenosAlert.error(mapObj["errorMsg"]);
		    		}
		    	} else if(mapObj["errorFlag"].toString() == "noError") {
			    	 errPage.clearError(super.getSaveResultEvent());			    			
		             commonResultPart(mapObj);
					 changeCurrentState(null);
		    	} else {
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.datanotfound'));
		    	}    		
	    	}
        }
        
       
        
    	private function setValidator(strVldt:String):void {
    		
			var validateModel:Object={
	                            	 cashTransferEntry:{
		                                 fundCode:this.fundCodeBox.fundCode.text,
		                                 currency:this.ccyBox.ccyText.text,
		                                 cpAccountNo:this.cpAccountNo.accountNo.text,
		                                 wireAmount:this.wireAmount.text,
		                                 valueDate:this.valueDate.text,
		                                 gleLedgerCode:this.gleLedgerCode.selectedItem != null ? this.gleLedgerCode.selectedItem.value : "",
		                                 tradeDate:this.tradeDate.text,
		                                 inxTransmission:this.inxTransmission.selectedItem != null ? this.inxTransmission.selectedItem.value : "",
		                                 toBank:this.toBank.text,
		                                 toSettleAccount:this.toSettleAccount.accountNo.text,
		                                 fromBank:this.fromBank.text,
		                                 fromSettleAccount:this.fromSettleAccount.accountNo.text,
		                                 ownBank:this.ownBank.text,
		                                 ownSettleAccount:this.ownSettleAccount.text
		                            }
	                           };
	         super._validator = new CashTransferEntryValidator(strVldt);
	         super._validator.source = validateModel ;
	         super._validator.property = "cashTransferEntry";
		  
		}
		 override public function preEntry():void {
		 	
		 	var validateFlag:String = null;
		 	if(this.wireViewStack.selectedChild == bankDetails) {
		 		validateFlag = "Bank";
		 	} else if(this.wireViewStack.selectedChild == firmBankDetails) {
		 		validateFlag = "Firm";
		 	}
		 	
		 	setValidator(validateFlag);
		 	super.getSaveHttpService().url = "stl/wireInstructionDetailsEntryDispatch.action?";  
            super.getSaveHttpService().request  = populateRequestParams();
		 }
		 
		 override public function preCancel():void {
		 	
		 	super._validator = null;
		 	var reqObj:Object = new Object();
		 	reqObj.method="doConfirmDelete";
		 	reqObj.SCREEN_KEY = 538;
            super.getSaveHttpService().request = reqObj;
            super.getSaveHttpService().url = "stl/wireInstructionDetailsCancelDispatch.action?"; 
		 }
		 
		 
		override public function preEntryResultHandler():Object {
			 addCommonResultKes();
			 return keylist;
		}
		
		
		override public function postCancelResultHandler(mapObj:Object):void {
			submitUserConfResult(mapObj);
			
			this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('stl.label.cashtransfer.cancel.userconfirmation');
			uConfLabel.includeInLayout = true;
			uConfLabel.visible = true;
        	cancelSubmit.visible = false;
        	cancelSubmit.includeInLayout = false;
        	uCancelConfSubmit.visible = true;
        	uCancelConfSubmit.includeInLayout = true;
        	sConfSubmit.includeInLayout = false;
        	sConfSubmit.visible = false;
        	sConfLabel.includeInLayout = false;
        	sConfLabel.visible = false;
	        app.submitButtonInstance = uCancelConfSubmit;
		} 
		
		override public function postEntryResultHandler(mapObj:Object):void {
			commonResult(mapObj);
			
			uConfLabel.includeInLayout = true;
			uConfLabel.visible = true;
			uConfImg.includeInLayout = false;
			uConfImg.visible = false;
			usrCnfMessage.text = this.parentApplication.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.userconfirmation');
			uConfSubmit.visible = true;
			uConfSubmit.includeInLayout = true;
			app.submitButtonInstance = uConfSubmit;
		}
		
		
		override public function preEntryConfirm():void {
			uConfSubmit.enabled = false;
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "stl/wireInstructionDetailsEntryDispatch.action?";  
			reqObj.method= "doConfirmEntry";
			reqObj.SCREEN_KEY = 439;
            super.getConfHttpService().request = reqObj;
		}
		
		override public function preCancelConfirm():void {
			uCancelConfSubmit.enabled = false;
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "stl/wireInstructionDetailsCancelDispatch.action?";  
			reqObj.method = "submitDelete";
			reqObj.SCREEN_KEY = 539;
            super.getConfHttpService().request = reqObj;
		}
		
		override public function preEntryConfirmResultHandler():Object {
			keylist = new ArrayCollection();
	    	keylist.addItem("clientSettlementInfoVO.settlementReferenceNo");
	    	keylist.addItem("clientSettlementInfoVO.versionNo");
	    	return keylist;
		}
		
		override public function postConfirmEntryResultHandler(mapObj:Object):void {
			uConfSubmit.enabled = true;
			submitUserConfResult(mapObj);
			if(iError == 0) {
				uConfLabel.includeInLayout = true;
				uConfLabel.visible = true;
				uConfImg.includeInLayout = false;
				uConfImg.visible = false;
				usrCnfMessage.text = this.parentApplication.xResourceManager.getKeyValue('stl.label.cashtransfer.entry.systemconfirmation');
				this.referenceNoLabel.text = this.parentApplication.xResourceManager.getKeyValue('inf.label.refno')+": "+mapObj[keylist.getItemAt(0)].toString()+"-"+mapObj[keylist.getItemAt(1)].toString();
			}
		}
		
		override public function preConfirmCancelResultHandler():Object {
			keylist = new ArrayCollection();
			keylist.addItem("clientSettlementInfoVO.settlementReferenceNo");
	    	keylist.addItem("clientSettlementInfoVO.cxlReferenceNo");
	    	keylist.addItem("cashEntry.referenceNo");
	    	keylist.addItem("cashEntry.cxlRefNo");
	    	return keylist;
		}
		
		override public function postConfirmCancelResultHandler(mapObj:Object):void {
			uCancelConfSubmit.enabled = true;
			submitUserConfResult(mapObj);
			this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('stl.label.cashtransfer.cancel.systemconfirmation');
        	cancelSubmit.visible = false;
        	cancelSubmit.includeInLayout = false;
        	uCancelConfSubmit.visible = false;
        	uCancelConfSubmit.includeInLayout = false;
        	uConfLabel.includeInLayout = false;
			uConfLabel.visible = false;
			var refNo:String = mapObj[keylist.getItemAt(0)].toString();
			var cxlRefNo:String = mapObj[keylist.getItemAt(1)].toString();
			if(XenosStringUtils.isBlank(cxlRefNo)){
				refNo = mapObj["cashEntry.referenceNo"].toString();
				cxlRefNo = mapObj["cashEntry.cxlRefNo"].toString();
			}
			this.referenceNoLabel.text = this.parentApplication.xResourceManager.getKeyValue('inf.label.refno')+": "+refNo+", "+this.parentApplication.xResourceManager.getKeyValue('inf.label.cxl.refno')+": "+cxlRefNo;
		}
		
		private function submitUserConfResult(mapObj:Object):void {
	    	if(mapObj!=null) {
		    	if(mapObj["errorFlag"].toString() == "error") {
		    		if(mode!="cancel") {
		    			this.vstack.selectedChild = qry;
		    			this.errPage.showError(mapObj["errorMsg"]);
		    		} else {
		    			this.errPageCxl.showError(mapObj["errorMsg"]);
		    			this.uCancelConfSubmit.enabled = false;
		    		}
		    		++iError;
		    	} else if(mapObj["errorFlag"].toString() == "noError") {
		    		
					if(mode!="cancel") {
						errPage.clearError(super.getConfResultEvent());
					}
					iError = 0;
					this.back.includeInLayout = false;
		    		this.back.visible = false;
				    uConfSubmit.enabled = true;	
	                uConfLabel.includeInLayout = false;
	                uConfLabel.visible = false;
	                uConfSubmit.includeInLayout = false;
	                uConfSubmit.visible = false;
	                sConfLabel.includeInLayout = true;
	                sConfLabel.visible = true;
	                sConfSubmit.includeInLayout = true;
	                sConfSubmit.visible = true;   
	                app.submitButtonInstance = sConfSubmit;
					
		    	} else {
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred'));
		    	}    		
	    	}
    	}
    
   /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	
    	reqObj.method = "doSubmit";
    	
    	reqObj['clientSettlementInfoVO.wireType'] = this.wireType.selectedItem != null? this.wireType.selectedItem.value:"";
    	
    	reqObj['mapSiVO(fundCode)']=this.fundCodeBox.fundCode.text;
    	
    	reqObj['mapSdVO(currency)']=this.ccyBox.ccyText.text;
    	
    	reqObj['mapSiVO(inventoryAccount)']=null;
    	
    	if(this.wireAmount.text.search(',') > -1) {
    		var strQtyTemp:String = "";
    		var splitResultsArray:Array = this.wireAmount.text.split(',',20);
    		for(var i:int;i<splitResultsArray.length;++i) {
    			strQtyTemp = strQtyTemp + splitResultsArray[i];
    		}
    		reqObj['mapSdVO(wireAmount)']=strQtyTemp;
    	} else {
    		reqObj['mapSdVO(wireAmount)']=this.wireAmount.text;
    	}
    	amtTemp = this.wireAmount.text;
    	
    	if(this.wireType.selectedItem.value != "BANK_TO_BANK") {
    		reqObj['mapSiVO(account)'] = this.cpAccountNo.accountNo.text;
    		reqObj['mapCsiVO(gleLedgerCode)'] = this.gleLedgerCode.selectedItem != null? this.gleLedgerCode.selectedItem.value:"";
    		reqObj['mapCsiVO(tradeDate)'] = this.tradeDate.text;
    	} else {
    		reqObj['mapSiVO(account)'] = null;
    		reqObj['mapCsiVO(gleLedgerCode)'] = "";
    		reqObj['mapCsiVO(tradeDate)']= "";
    	}
    	
    	reqObj['mapSiVO(valueDate)']=this.valueDate.text;
    	
    	reqObj['settlementInfoVO.transmissionReqdFlag'] = this.inxTransmission.selectedItem != null? this.inxTransmission.selectedItem.value:"";
    	
    	reqObj['mapSiVO(correspondingSecurityId)']=this.security.instrumentId.text;
    	
    	reqObj['mapSiVO(localAccount)']=null;
    	
    	reqObj['clientSettlementInfoVO.remarks'] = this.remarks.text;
    	
    	
    	if(this.wireType.selectedItem.value == 'BANK_TO_BANK') {
    		
    		reqObj['mapSdVO(cpBank)']=this.toBank.text;
    		reqObj['mapSdVO(cpBankShortname)']=this.toBankName.text;
    		reqObj['mapSdVO(cpSettleAc)']=this.toSettleAccount.accountNo.text;
    		
    		reqObj['mapSdVO(ourBank)']=this.fromBank.text;
    		reqObj['mapSdVO(ourBankShortname)']=this.fromBankName.text;
    		reqObj['mapSdVO(ourSettleAc)']=this.fromSettleAccount.accountNo.text;
    		
    	} else {
    		reqObj['mapSdVO(cpBank)']=this.cpBank.text;
    		reqObj['mapSdVO(cpBankShortname)']=this.cpBankName.text;
    		reqObj['mapSdVO(cpSettleAc)']=this.cpSettleAccount.text;
    		reqObj['settlementDetailVO.beneficiaryName'] = this.cpBeneficiaryName.text;
    		reqObj.cpSettleStandingRulePkStr = this.cpStandingRulePk.text;
    		
    		reqObj['mapSdVO(ourBank)']=this.ownBank.text;
    		reqObj['mapSdVO(ourBankShortname)']=this.ownBankName.text;
    		reqObj['mapSdVO(ourSettleAc)']=this.ownSettleAccount.text;
    		reqObj.ownSettleStandingRulePkStr = this.ownStandingRulePk.text;
    	}
    	reqObj.SCREEN_KEY = 438;
    	return reqObj;
    }
    
	override public function preResetEntry():void {
		var rndNo:Number= Math.random();
		super.getResetHttpService().url = "stl/wireInstructionDetailsEntryDispatch.action?method=doReset&rnd=" + rndNo;
	}
	
	override public function postResetEntry():void {
		resetValues();
		
	}
	
	override public function doEntrySystemConfirm(e:Event):void {
		super.preEntrySystemConfirm();
		this.dispatchEvent(new Event('entryReset'));
		this.back.includeInLayout = true;
		this.back.visible = true;
        uConfLabel.includeInLayout = true;
        uConfLabel.visible = true;
        uConfSubmit.includeInLayout = true;
        uConfSubmit.visible = true;
        sConfLabel.includeInLayout = false;
        sConfLabel.visible = false;
        sConfSubmit.includeInLayout = false;
        sConfSubmit.visible = false;
        
        vstack.selectedChild = qry;	
		super.postEntrySystemConfirm();
	}
	
	override public function doCancelSystemConfirm(e:Event):void {
		//this.parentDocument.owner.dispatchEvent(new Event("cancelSubmit"));
		this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
	}
	
	private function resetValues():void {
		
		errPage.removeError();
		
		this.fundCodeBox.fundCode.text        = null;
		this.ccyBox.ccyText.text	          = null;
		this.cpAccountNo.accountNo.text       = null;
		this.wireAmount.text                  = null;
		this.valueDate.selectedDate           = null;
		this.tradeDate.selectedDate           = null;
		this.security.instrumentId.text       = null;
		this.remarks.text                     = null;
		this.toBank.text                      = null;
		this.toBankName.text                  = null;
		this.toSettleAccount.accountNo.text   = null;
		this.toSettleAccountLabel.text        = null;
		this.fromBank.text                    = null;
		this.fromBankName.text                = null;
		this.fromSettleAccount.accountNo.text = null;
		this.fromSettleAccountLabel.text      = null;
		this.cpBank.text                      = null;
		this.cpBankName.text                  = null;
		this.cpSettleAccount.text             = null;
		this.cpSettleAccountLabel.text        = null;
		this.cpBeneficiaryName.text           = null;
		this.ownBank.text                     = null;
		this.ownBankName.text                 = null;
		this.ownSettleAccount.text            = null;
		this.ownSettleAccountLabel.text       = null;
		
		commonInit(tempObj,"RESET");
		wireViewStack.selectedChild = bankDetails;
	}
	
  private function populateContext():ArrayCollection {
  	//pass the context data to the popup
    var myContextList:ArrayCollection = new ArrayCollection();
    //passing counter party type                
    var cpTypeArray:Array = new Array(2);
    cpTypeArray[0]="BANK/CUSTODIAN";
    cpTypeArray[1]="BROKER";
    
	myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));

    //passing account status                
    var actStatusArray:Array = new Array(1);
    actStatusArray[0]="OPEN";
    myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
    return myContextList;
  }
	 /**
	  * This is the method to access the Collection of data items receive
	  * through the context from the account popup. This will be implemented as per specifdic  
	  * requriment. 
	  */
	public function showReturnContext(e:FocusEvent):void {
	    	
	    if(bankFlag != null) {
	    	if(bankFlag == 'toBank') {
	    		populateEntryTextFields(toBank,toBankName,toSettleAccount.accountNo,toSettleAccountLabel,null,null);
		    } else if(bankFlag == 'fromBank') {
		    	populateEntryTextFields(fromBank,fromBankName,fromSettleAccount.accountNo,fromSettleAccountLabel,null,null);
		    } else if(bankFlag == 'cpBank') {
		    	//XenosAlert.info("rulepk :: "+cpStandingRulePk.text);
		    	populateEntryTextFields(cpBank,cpBankName,cpSettleAccount,cpSettleAccountLabel,cpBeneficiaryName,cpStandingRulePk);
		    } else if(bankFlag == 'ourBank') {
		    	populateEntryTextFields(ownBank,ownBankName,ownSettleAccount,ownSettleAccountLabel,null,ownStandingRulePk);
		    } else if(bankFlag == 'fromAccountPopup') {
		    	if(returnContextItem.length > 0) {
		    		populateFromBank();
		    	}
		    } else if(bankFlag == 'toAccountPopup') {
		    	if(returnContextItem.length > 0) {
		    		populateToBank();
		    	}
		    }
	    }
	}
	private function populateEntryTextFields(bankCode:Object,
												bankName:Object,
												accountNo:Object,
												accountNoLabel:Object,
												cpBeneficiaryName:Object,
												standingRulePk:Object):void {
		
		for (var i:int = 0; i<retCtxItem.length; i++) {
	        
	        var itemObject:HiddenObject;
	        
	        itemObject = HiddenObject (retCtxItem.getItemAt(i));
	        
	        var propertyName:String   = itemObject.m_propertyName;
	        var propertyValues:Array = itemObject.m_propertyValues;
	        
	        if(propertyName == 'returnBankCode') {
	        	populateField(bankCode,propertyValues);
            } else if(propertyName == 'returnBankName') {
            	populateField(bankName,propertyValues);
            } else if(propertyName == 'returnAccountNo') {
            	populateField(accountNoLabel,propertyValues);
            	populateField(accountNo,propertyValues);
            } else if(propertyName == 'returnBeneficiaryName') {
            	populateField(cpBeneficiaryName,propertyValues);
            } else if(propertyName == 'returnStandingRulePk') {
            	if(standingRulePk != null)
            		TextInput(standingRulePk).text = propertyValues[0];
            }
	    }
	    retCtxItem.removeAll();
	}
	private function populateField(obj:Object,propValues:Array):void {
		if(obj!=null) {
			for (var j:int = 0; j<propValues.length; j++) {
		        if(obj.id.search('Label')> -1 ) {
		        	obj.text =  "("+propValues[j]+")";
		        } else {
		        	obj.text =  propValues[j];
		        }
		    }
		}
	}
	public function resetBankFlag(obj:Object):void {
		
		if(obj.id == "fromSettleAccount") {
			bankFlag = "fromAccountPopup";
		} else if(obj.id == "toSettleAccount") {
			bankFlag = "toAccountPopup";
		}
	}
	private function populateFromBank():void {
		fromBank.text     = fromSettleAccount.bankCodeTxt.text;
		fromBankName.text = fromSettleAccount.bankNameTxt.text;
		fromSettleAccountLabel.text = null;
	}
	private function populateToBank():void {
		toBank.text     = toSettleAccount.bankCodeTxt.text;
		toBankName.text = toSettleAccount.bankNameTxt.text;
		toSettleAccountLabel.text = null;
	}
	private function populateFromBankViaAccountPopUp(e:FocusEvent):void {
		if(StringUtil.trim(fromSettleAccount.bankCodeTxt.text) != "") {
			fromBank.text = fromSettleAccount.bankCodeTxt.text;
		}
		if(StringUtil.trim(fromSettleAccount.bankNameTxt.text) != "") {
			fromBankName.text = fromSettleAccount.bankNameTxt.text;
		}
		if(StringUtil.trim(fromSettleAccount.bankCodeTxt.text) != ""
			&& StringUtil.trim(fromSettleAccount.bankNameTxt.text) != "") {
			fromSettleAccountLabel.text = null;
		}
	}
	private function populateToBankViaAccountPopUp(e:FocusEvent):void {
		if(StringUtil.trim(toSettleAccount.bankCodeTxt.text) != "") {
			toBank.text = toSettleAccount.bankCodeTxt.text;
		}
		if(StringUtil.trim(toSettleAccount.bankNameTxt.text) != "") {
			toBankName.text = toSettleAccount.bankNameTxt.text;
		}
		if(StringUtil.trim(toSettleAccount.bankCodeTxt.text) != ""
			&& StringUtil.trim(toSettleAccount.bankNameTxt.text) != "") {
			toSettleAccountLabel.text = null;
		}
	}
	/** When Back button is clicked **/
	private function doBack():void {
		vstack.selectedChild = qry;
		app.submitButtonInstance = submit;
	}
	/** When the value of dropdown of Wire Type is changed **/  	
	private function onChangeOfWireType():void {
		commonGrid.removeAllChildren();
		commonGrid.addChildAt(wireTypeGridRow,0);
		commonGrid.addChildAt(fundCodeCcyGridRow,1);
		
		if(this.wireType.selectedItem.value == "BANK_TO_BANK") {
			
			commonGrid.addChildAt(wireAmtValueDateGridRow,2);
			commonGrid.addChildAt(inxTransSecurityGridRow,3);
			commonGrid.addChildAt(remarksGridRow,4);
			
			wireViewStack.selectedChild = bankDetails;
		} else {
			
			commonGrid.addChildAt(cpAccountNoGridRow,2);
			commonGrid.addChildAt(wireAmtValueDateGridRow,3);
			commonGrid.addChildAt(gleLedgerTradeDateGridRow,4);
			commonGrid.addChildAt(inxTransSecurityGridRow,5);
			commonGrid.addChildAt(remarksGridRow,6);			
			populateGleLedgerCodeCombo();
			this.tradeDate.selectedDate = DateUtils.toDate(tradeDateStr);
			wireViewStack.selectedChild = firmBankDetails;
		}
		this.fundCodeBox.fundCode.setFocus();
	}
	
	private function populateGleLedgerCodeCombo():void {
		/*** For GleLedgerCode ***/
    	if(this.wireType.selectedItem.value == "FIRM_PAYMENT") {
			gleLedgerCode.dataProvider  = gleLedgerCodeArrFirmPayment;
		} else if(this.wireType.selectedItem.value == "FIRM_RECEIPT") {
			gleLedgerCode.dataProvider  = gleLedgerCodeArrFirmReceipt;
		}
	}
	
	private function setValidatorForPopUp(flag:String):Boolean {
    		var wireInstructionPopupValidator:Validator;
    		
			var validateModelForPopUp:Object={
				                            	 wireInstruction: {
					                                 fundCode:this.fundCodeBox.fundCode.text,
					                                 currency:this.ccyBox.ccyText.text,
					                                 cpAccountNo:this.cpAccountNo.accountNo.text
					                             }
	                           				}; 
	        wireInstructionPopupValidator = new WireInstructionPopupValidator(flag);
	        wireInstructionPopupValidator.source = validateModelForPopUp;
	        wireInstructionPopupValidator.property = "wireInstruction";
	        var validationResult:ValidationResultEvent = wireInstructionPopupValidator.validate();
	         
	        if(validationResult!=null && (validationResult.type == ValidationResultEvent.INVALID)) {
	        	var errorMsg:String=validationResult.message;
            	XenosAlert.error(errorMsg);
            	return false;
	        }
	        return true;
		}
	
	private function showPopup(bank:Object,bankName:Object,stlAccount:Object,flg:String):void {
		bankFlag = flg;
		var booleanVal:Boolean = setValidatorForPopUp(null);
		if(booleanVal) {
			pop(bank,bankName,stlAccount,null);
		}
	}
	private function showPopupCP(bank:Object,bankName:Object,stlAccount:Object,flg:String):void {
		bankFlag = flg;
		var booleanVal:Boolean = setValidatorForPopUp("CP");
		if(booleanVal) {
			pop(bank,bankName,stlAccount,'CP');
		}
	}
	
	private function pop(bank:Object,bankName:Object,stlAccount:Object,cpFlag:String):void {
		var bnkPopup:BankListPopup=BankListPopup(
										PopUpManager.createPopUp( UIComponent(this.parentApplication), 
										BankListPopup , true));
		
        PopUpManager.centerPopUp(bnkPopup);
        
        /* Pass a reference to the AutoComplete control
         * to the PopUpWindow container so that the 
         * PopUpWindow container can return data to the main application.
         */
        var receiveContextItemsForBnkPopup:ArrayCollection = new ArrayCollection();
        
        // passing fundCode
        var fundCodeArray:Array = new Array(1);
        fundCodeArray[0]=this.fundCodeBox.fundCode.text;         
        receiveContextItemsForBnkPopup.addItem(new HiddenObject("mapSiVO(fundCode",fundCodeArray));
        
        // passing currency
        var currencyArray:Array = new Array(1);
        currencyArray[0]=this.ccyBox.ccyText.text;         
        receiveContextItemsForBnkPopup.addItem(new HiddenObject("mapSdVO(currency",currencyArray));
        
        // passing accountNo
        var strAccntNo:String = this.cpAccountNo.accountNo.text;
        strAccntNo = strAccntNo
						        .replace('#',"%23")
						        .replace('/',"%2F")
						        .replace('-',"%2D")
						        .replace('.',"%2E")
						        .replace('(',"%28")
						        .replace(')',"%29")
						        .replace(',',"%2C");

        var accountNoArray:Array = new Array(1);
        accountNoArray[0] = strAccntNo;
        receiveContextItemsForBnkPopup.addItem(new HiddenObject("mapSiVO(account",accountNoArray));
        
        if(cpFlag!=null) {
        	var cpFlagArray:Array = new Array(1);
	        cpFlagArray[0]="CP";
	        receiveContextItemsForBnkPopup.addItem(new HiddenObject("dispatchFlag",cpFlagArray));
        }
        
        bnkPopup.receiveCtxItems = receiveContextItemsForBnkPopup;
        
        //initialize the bank popup
        bnkPopup.popUpQueryPage.resultFormat = "xml";
	    bnkPopup.initPopup();
	    
	    bnkPopup.returnContextItems = retCtxItem;
	    
	}
	
	private function autoPopulateForm(strAutoPopulateFlag:String):void {
		
		if(StringUtil.trim(this.ccyBox.ccyText.text) != "") {
			
			if(this.wireType.selectedItem.value != 'BANK_TO_BANK') {
				if(StringUtil.trim(strAutoPopulateFlag) == "OWN") {
					emptyOwnBankDetails();
					if(StringUtil.trim(this.fundCodeBox.fundCode.text)!="") {
						fireAutoPopulateOwn();
					}
				} else if(StringUtil.trim(strAutoPopulateFlag) == "CP") {
					emptyCpBankDetails();
					if(StringUtil.trim(this.cpAccountNo.accountNo.text)!="") {
						fireAutoPopulateCP();
					}
				} else if(StringUtil.trim(strAutoPopulateFlag) == "CC") {
					emptyOwnBankDetails();
					emptyCpBankDetails();
					if(StringUtil.trim(this.fundCodeBox.fundCode.text)!="") {
						fireAutoPopulateOwn();
					}
					if(StringUtil.trim(this.cpAccountNo.accountNo.text)!="") {
						fireAutoPopulateCP();
					}
				}
				strAutoPopulateStaticFlag = strAutoPopulateFlag;
			} else if(this.wireType.selectedItem.value == 'BANK_TO_BANK') {
				//XenosAlert.info("*** FUND_CODE: "+tempFundCode+", CURRENCY: "+tempCurrency+" ***");
				if(tempFundCode!=this.fundCodeBox.fundCode.text) {
					emptyFromBankDetails();
					tempFundCode=this.fundCodeBox.fundCode.text;
				}
				if(tempCurrency!=this.ccyBox.ccyText.text) {
					emptyFromBankDetails();
					emptyToBankDetails();
					tempFundCode=this.fundCodeBox.fundCode.text;
					tempCurrency=this.ccyBox.ccyText.text;
				}
			}
		} else {
			if(wireType.selectedItem != null){
				if(this.wireType.selectedItem.value != 'BANK_TO_BANK') {
					emptyOwnBankDetails();
					emptyCpBankDetails();
				} else {
					emptyFromBankDetails();
					emptyToBankDetails();
				}
			}else{
				//do nothing
			}
			
		}
	}
	private function fireAutoPopulateOwn():void {
		var reqObj : Object = new Object();
    	reqObj.method = "populateOwnDetails";
    	reqObj.fund = this.fundCodeBox.fundCode.text;
    	reqObj.ccy = this.ccyBox.ccyText.text;
    	reqObj.wiretype = this.wireType.selectedItem.value;
    	wireInstructionDetailsDispatchReq.request = reqObj;
    	if(this.mode == "entry")
    		wireInstructionDetailsDispatchReq.url="stl/wireInstructionDetailsEntryDispatch.action?";
    	else
    		wireInstructionDetailsDispatchReq.url="stl/wireInstructionDetailsCancelDispatch.action?";
        wireInstructionDetailsDispatchReq.send();
	}
	private function fireAutoPopulateCP():void {
		var reqObj : Object = new Object();
    	reqObj.method = "populateCpOwnDetails";
    	reqObj.fund = this.fundCodeBox.fundCode.text;
    	reqObj.ccy = this.ccyBox.ccyText.text;
    	reqObj.account = this.cpAccountNo.accountNo.text;
    	wireInstructionDetailsDispatchReq.request = reqObj;
    	if(this.mode == "entry")
    		wireInstructionDetailsDispatchReq.url="stl/wireInstructionDetailsEntryDispatch.action?";
    	else
    		wireInstructionDetailsDispatchReq.url="stl/wireInstructionDetailsCancelDispatch.action?";
        wireInstructionDetailsDispatchReq.send();
	}
	private function emptyToBankDetails():void {
		this.toBank.text = null;
		this.toBankName.text = null;
		this.toSettleAccount.accountNo.text = null;
		this.toSettleAccount.bankCodeTxt.text = null;
		this.toSettleAccount.bankNameTxt.text = null;
		this.toSettleAccountLabel.text = null;
	}
	
	private function emptyFromBankDetails():void {
		this.fromBank.text = null;
		this.fromBankName.text = null;
		this.fromSettleAccount.accountNo.text = null;
		this.fromSettleAccount.bankCodeTxt.text = null;
		this.fromSettleAccount.bankNameTxt.text = null;
		this.fromSettleAccountLabel.text = null;
	}
	
	private function emptyOwnBankDetails():void {
		this.ownBank.text = null;
		this.ownBankName.text = null;
		this.ownSettleAccount.text = null;
		this.ownSettleAccountLabel.text = null;
		this.ownStandingRulePk.text = null;
	}
	
	private function emptyCpBankDetails():void {
		this.cpBank.text = null;
		this.cpBankName.text = null;
		this.cpSettleAccount.text = null;
		this.cpSettleAccountLabel.text = null;
		this.cpBeneficiaryName.text = null;
		this.cpStandingRulePk.text = null;
	}
	
	private function populateParticularFields(event:ResultEvent):void {
		
		var rs:XML = XML(event.result);
		if(rs.child("Errors").length()>0) {
			var errorInfoList : ArrayCollection = new ArrayCollection();
			//populate the error info list 			 	
			for each (var err:XML in rs.Errors.error ) {
				errorInfoList.addItem(err.toString());
			}
			errPage.showError(errorInfoList);//Display the error
		}
		
		if(StringUtil.trim(strAutoPopulateStaticFlag) == "CP") {
			if(StringUtil.trim(this.cpAccountNo.accountNo.text) != "") {
				emptyCpBankDetails();
				if(rs.settlementDetailVO.otherAttributes != "") {
					for each(var xml:XML in rs.settlementDetailVO.otherAttributes.entry) {
				        if(xml.attribute('key') == 'cpBank') {
				        	this.cpBank.text = xml.value;
			            } else if(xml.attribute('key') == 'cpBankShortname') {
			            	this.cpBankName.text = xml.value;
			            } else if(xml.attribute('key') == 'cpSettleAc') {
			            	this.cpSettleAccount.text = xml.value;
			            } else if(xml.attribute('key') == 'toBrkNo') {
			            	this.cpSettleAccountLabel.text = xml.value;
			            }
					}
					this.cpBeneficiaryName.text = rs.settlementDetailVO.beneficiaryName;
				}
			}
		} else if(StringUtil.trim(strAutoPopulateStaticFlag) == "OWN") {
			if(StringUtil.trim(this.fundCodeBox.fundCode.text)!="") {
				emptyOwnBankDetails();
				if(rs.settlementDetailVO.otherAttributes != "") {
					for each(var xmlObj:XML in rs.settlementDetailVO.otherAttributes.entry) {
				        if(xmlObj.attribute('key') == 'ourBank') {
				        	this.ownBank.text = xmlObj.value;
			            } else if(xmlObj.attribute('key') == 'ourBankShortname') {
			            	this.ownBankName.text = xmlObj.value;
			            } else if(xmlObj.attribute('key') == 'ourSettleAc') {
			            	this.ownSettleAccount.text = xmlObj.value;
			            } else if(xmlObj.attribute('key') == 'fromBrkNo') {
			            	this.ownSettleAccountLabel.text = xmlObj.value;
			            }
					}
				}
			}
		} else if(StringUtil.trim(strAutoPopulateStaticFlag) == "CC") {
			if(StringUtil.trim(this.fundCodeBox.fundCode.text)!="") {
				emptyOwnBankDetails();
				if(rs.settlementDetailVO.otherAttributes != "") {
					for each(xmlObj in rs.settlementDetailVO.otherAttributes.entry) {
				        if(xmlObj.attribute('key') == 'ourBank') {
				        	this.ownBank.text = xmlObj.value;
			            } else if(xmlObj.attribute('key') == 'ourBankShortname') {
			            	this.ownBankName.text = xmlObj.value;
			            } else if(xmlObj.attribute('key') == 'ourSettleAc') {
			            	this.ownSettleAccount.text = xmlObj.value;
			            } else if(xmlObj.attribute('key') == 'fromBrkNo') {
			            	this.ownSettleAccountLabel.text = xmlObj.value;
			            }
					}
				}
			}
			if(StringUtil.trim(this.cpAccountNo.accountNo.text) != "") {
				emptyCpBankDetails();
				if(rs.settlementDetailVO.otherAttributes != "") {
					for each(xml in rs.settlementDetailVO.otherAttributes.entry) {
				        if(xml.attribute('key') == 'cpBank') {
				        	this.cpBank.text = xml.value;
			            } else if(xml.attribute('key') == 'cpBankShortname') {
			            	this.cpBankName.text = xml.value;
			            } else if(xml.attribute('key') == 'cpSettleAc') {
			            	this.cpSettleAccount.text = xml.value;
			            } else if(xml.attribute('key') == 'toBrkNo') {
			            	this.cpSettleAccountLabel.text = xml.value;
			            }
					}
					this.cpBeneficiaryName.text = rs.settlementDetailVO.beneficiaryName;
				}
			}
		}
	}
	
	private function showPopUpForCashManagement():void {
	    
	    var booleanValCash:Boolean = setValidatorForPopUp(null);
		if(booleanValCash) {
		    XenosPopupUtils.showCashManagementSummaryPopup(
														    this.fundCodeBox.fundCode.text,
														    this.ccyBox.ccyText.text,
														    UIComponent(this.parentApplication)
														    );
		}
	}
	