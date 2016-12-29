// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.drv.validators.DrvTradeDetailsValidator;
import com.nri.rui.drv.validators.DrvTradeValidator;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.ValidationResultEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

			
	  
	[Bindable] private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     
    [Bindable]private var mode : String = "entry";
    [Bindable]private var drvTradePkStr : String = "";
    [Bindable]public var remarkStr : String = "";
    [Bindable]public var pageStatus : String = "init";
     private var keylist:ArrayCollection = new ArrayCollection();
    [Bindable]private var contractVoAttbList:ArrayCollection = new ArrayCollection();
    [Bindable]private var tradeVoAttbList:ArrayCollection = new ArrayCollection();
    [Bindable]private var taxFeeSummaryResult:ArrayCollection = new ArrayCollection();
    [Bindable]private var marginSummaryResult:ArrayCollection = new ArrayCollection();
    [Bindable]private var editedMargin:XML = new XML();
    
	[Bindable]public var settlementAcPkStr:TextInput= new TextInput();
	[Bindable]public var bankPkStr:TextInput= new TextInput();
	[Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
  
	private function changeCurrentState():void{
		//hdbox1.selectedChild = this.rslt;
		//currentState = "result";
		vstack.selectedChild = rslt;
	 }
	 
    public function loadAll():void{
   	   parseUrlString();
   	   super.setXenosEntryControl(new XenosEntry());
   	   if(this.mode == 'entry'){
   	   	 this.dispatchEvent(new Event('entryInit'));
   	   	 this.securityId.setFocus();
   	   	 vstack.selectedChild = qry;
   	   	 this.othersws.visible = false;
   	   	 this.othersws.includeInLayout = false;
   	   	 this.ssiws.visible = false;
   	   	 this.ssiws.includeInLayout = false;
   	   	 this.reset.visible = true;
   	   	 this.reset.includeInLayout = true;
   	   } else if(this.mode == 'amend'){
   	   	 this.dispatchEvent(new Event('amendEntryInit'));
   	   	 this.securityId.setFocus();
   	   	 vstack.selectedChild = qry;
   	   } else { 
   	   	 app.submitButtonInstance = cancelSubmit;
   	     this.dispatchEvent(new Event('cancelEntryInit'));
   	   }
   	     
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
            //XenosAlert.info("Load Url : "+ this.loaderInfo.url.toString());
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
                        //XenosAlert.info("movArray param = " + tempA[1]);
                        mode = tempA[1];
                    }else if(tempA[0] == "tradePk"){
                        this.drvTradePkStr = tempA[1];
                    } 
                }                    	
            }else{
            	mode = "entry";
            }                 

        } catch (e:Error) {
            trace(e);
        }               
    }
            
    override public function preEntryInit():void{
    	pageStatus = "init";            	
        var rndNo:Number= Math.random();          	
    	super.getInitHttpService().url = "drv/drvTradeEntryDetails.action?method=initialExecute&&mode=entry&&menuType=Y&SCREEN_KEY=10052&rnd=" + rndNo;
    		
    }
    
    override public function preAmendInit():void{     
    	pageStatus = "entry";
    	initLabel.text = this.parentApplication.xResourceManager.getKeyValue('drv.label.trdamend');     	
        var rndNo:Number= Math.random(); 
    	super.getInitHttpService().url = "drv/drvTradeAmendDetails.action?";
    	var reqObject:Object = new Object();
    	reqObject.rnd = rndNo;
    	reqObject.method= "doAmend";
  		reqObject.mode=this.mode;
  		reqObject.tradePk = this.drvTradePkStr;
  		reqObject['SCREEN_KEY'] = "10055";
  		super.getInitHttpService().request = reqObject;
    }
    
    override public function preCancelInit():void{            	
        this.back.includeInLayout = false;
	    this.back.visible = false;
	    changeCurrentState(); 			             	
        var rndNo:Number= Math.random(); 
    	super.getInitHttpService().url = "drv/drvTradeCancelDetails.action??";
    	var reqObject:Object = new Object();
    	reqObject.rnd = rndNo;
    	reqObject.method= "doCancel";
  		reqObject.mode=this.mode;
  		reqObject.tradePk = this.drvTradePkStr;
  		reqObject['SCREEN_KEY'] = "10056";
  		super.getInitHttpService().request = reqObject;
    }  
        
    private function addCommonKeys():void{       	
    	keylist = new ArrayCollection();
    	keylist.addItem("actionMode");
    	keylist.addItem("dropDownListValues.openClosePositionList.item");
    	keylist.addItem("dropDownListValues.calculationTypeList.item");
    	keylist.addItem("dropDownListValues.taxFeeIdList.item");
    	keylist.addItem("dropDownListValues.marginTypeList.item");
    	keylist.addItem("dropDownListValues.drvSettlementTypeList.item");
    	keylist.addItem("dropDownListValues.settlementBasisList.item");
    	keylist.addItem("margin.baseDateStr");
    	keylist.addItem("dropDownListValues.executionOfficeList.item");
    	keylist.addItem("dropDownListValues.instructionSuppressFlagList.item");
    	keylist.addItem("defaultExecutionOffice");
    	
    }
        
    override public function preEntryResultInit():Object{
    	addCommonKeys(); 
    	return keylist;
    }
    
    override public function preAmendResultInit():Object{
    	addCommonKeys();
    	keylist.addItem("contractVo.otherAttributes.entry");
    	keylist.addItem("tradeVo.otherAttributes.entry");
    	
    	keylist.addItem("taxFeeList");
    	keylist.addItem("marginList");
    	keylist.addItem("ssiInfo");  
    	
    	keylist.addItem("tradeVo.openCloseFlag");
    	keylist.addItem("tradeVo.buySellOrientation");
    	keylist.addItem("tradeVo.calculationType");
    	keylist.addItem("tradeVo.remarks");
    	keylist.addItem("contractVo.drvSettlementType");  
    	keylist.addItem("contractVo.settlementBasis");    		
    	keylist.addItem("tradeVo.instructionSuppressFlag");   		
    	return keylist;
    }
    
    override public function preCancelResultInit():Object{
    	addCommonResultKes();         	
    	return keylist;
    }
        
        
    private function commonInit(mapObj:Object):void{
    	
    	var tempColl: ArrayCollection = new ArrayCollection();
    	var initColl:ArrayCollection = new ArrayCollection();
    	var executionOfficeDefault:String = mapObj["defaultExecutionOffice"];
    	var selIndx:int = 0;
    	this.securityId.instrumentId.text = "";
    	this.tradeDate.text = "";
    	this.valueDate.text = "";
    	this.fundAccountNo.accountNo.text = "";
    	this.exeBrkAccountNo.accountNo.text = "";
    	this.brkAccountNo.accountNo.text = "";
    	this.price.text = "";
    	this.quantity.text = "";
    	this.executionMarket.text = "";
    	this.tradeCcy.ccyText.text = "";
    	this.exchangeRate.text = "";
    	this.remarks.text = "";    	
    	
    	this.exposure.text = "";
    	this.exposureInIssueCcy.text = "";
    	this.netAmount.text = "";
    	this.settlementType.text = "";
    	
    	this.settlementMode.text = "";
    	this.ourBankStr.text = "";
    	this.ourSettleAccountStr.text = "";
    	this.instructionReqdStr.text = "";
    	this.autoTransmissionReqdStr.text = "";
    	this.bankPkStr.text = "";
    	this.settlementAcPkStr.text = "";
    	
    	this.taxFeeSummaryResult.removeAll();
    	this.marginSummaryResult.removeAll();
    	this.taxFeeSummaryResult.refresh();
    	this.marginSummaryResult.refresh();    	
    	
    	errPage.clearError(super.getInitResultEvent());
    	
    	this.openClosePosition.dataProvider = mapObj[keylist.getItemAt(1)] as ArrayCollection;
    	
    	this.calculationType.dataProvider = mapObj[keylist.getItemAt(2)] as ArrayCollection;
    	
    	this.taxFeeId.dataProvider = mapObj[keylist.getItemAt(3)] as ArrayCollection;
    	
    	this.marginType.dataProvider = mapObj[keylist.getItemAt(4)] as ArrayCollection;
    	
    	this.settlementBasis.dataProvider = mapObj[keylist.getItemAt(6)] as ArrayCollection;
    	
    	this.baseDate.text = mapObj[keylist.getItemAt(7)].toString();
    	
    	tempColl = new ArrayCollection();
	    if(mapObj["dropDownListValues.executionOfficeList.item"] is ArrayCollection){
	    		initColl = mapObj["dropDownListValues.executionOfficeList.item"] as ArrayCollection;
		    	for each(var item4:Object in initColl){
		            if(XenosStringUtils.equals(item4.label,executionOfficeDefault )){                    
		                    selIndx = initColl.getItemIndex(item4);
			   	}
			   	tempColl.addItem(item4);
			}
	    	}
		this.executionOffice.dataProvider = tempColl;
		this.executionOffice.selectedIndex = selIndx; 
    	
    	this.inxSuppressFlag.dataProvider=mapObj[keylist.getItemAt(9)] as ArrayCollection;
    	this.inxSuppressFlag.selectedIndex=0;
    	
//    	this.taxfeews.opened = false;
//    	this.marginws.opened = false;
//    	this.othersws.opened = false;
//    	this.ssiws.opened = false;
    	
    	app.submitButtonInstance = submit;    		    		    	
    }
    
    override public function postEntryResultInit(mapObj:Object): void{
    	commonInit(mapObj);
    	this.marginType.selectedIndex = 0;
    }
    
    override public function postAmendResultInit(mapObj:Object): void{
    	commonInit(mapObj);
    	contractVoAttbList = mapObj[keylist.getItemAt(11)] as ArrayCollection;
    	tradeVoAttbList = mapObj[keylist.getItemAt(12)] as ArrayCollection;
    	
	 	
	 	this.securityId.instrumentId.text = getVoAttbValue(contractVoAttbList,'securityId');
	 	this.tradeDate.text = getVoAttbValue(tradeVoAttbList,'tradeDate');
	 	this.valueDate.text = getVoAttbValue(tradeVoAttbList,'valueDate');
	 	this.fundAccountNo.accountNo.text = getVoAttbValue(contractVoAttbList,'inventoryAccountNo');
	 	this.exeBrkAccountNo.accountNo.text = getVoAttbValue(tradeVoAttbList,'executionBrokerAccountNo');
	 	this.brkAccountNo.accountNo.text = getVoAttbValue(contractVoAttbList,'cpAccountNo');
	 	this.price.text = getVoAttbValue(tradeVoAttbList,'price');
	 	this.quantity.text = getVoAttbValue(tradeVoAttbList,'tradeQuantity');
	 	this.executionMarket.text = getVoAttbValue(tradeVoAttbList,'executionMarket');
	 	this.tradeCcy.ccyText.text = getVoAttbValue(tradeVoAttbList,'tradingCcy');
	 	this.exchangeRate.text = getVoAttbValue(tradeVoAttbList,'exchangeRate');
	 	this.remarks.text = mapObj[keylist.getItemAt(19)].toString();
	 	
	 	this.exposure.text = getVoAttbValue(tradeVoAttbList,'principalAmount');
	 	this.exposureInIssueCcy.text = getVoAttbValue(tradeVoAttbList,'principalAmountInIssueCcy');
	 	this.netAmount.text = getVoAttbValue(tradeVoAttbList,'netAmount');
	 	this.settlementType.text = getVoAttbValue(contractVoAttbList,'drvSettlementType');
	 	//this.settlementBasis.text = getVoAttbValue(contractVoAttbList,'settlementBasis');
	 	// Set Settlement Basis
	 	var settlementBasis:String = mapObj[keylist.getItemAt(21)].toString();
	 	if(XenosStringUtils.equals(settlementBasis, "E")){
	 		this.settlementBasis.selectedIndex = 0;
	 	} else {
	 		this.settlementBasis.selectedIndex = 1;
	 	}
        this.settlementBasis.enabled = false;
        
	 	// Set Calculation Type
	 	var calType:String = mapObj[keylist.getItemAt(18)].toString();
	 	if(XenosStringUtils.equals(calType, "D")){
	 		this.calculationType.selectedIndex = 0;
	 	} else {
	 		this.calculationType.selectedIndex = 1;
	 	}
	 	
	 	// Set Instruction Suppress Flag Type
	 	var inxFlag:String = mapObj[keylist.getItemAt(22)].toString();
	 	if(XenosStringUtils.equals(inxFlag, "N")){
	 		this.inxSuppressFlag.selectedIndex = 0;
	 	} else {
	 		this.inxSuppressFlag.selectedIndex = 1;
	 	}
	 	
	 		
	    	
	 	
	 	// Set open Close Flag
	 	var openCloseFlag:String = mapObj[keylist.getItemAt(16)].toString();
	 	var buySellOrientationFlag:String = mapObj[keylist.getItemAt(17)].toString();
	 	var openCloseList:ArrayCollection = this.openClosePosition as ArrayCollection;
	 	if(XenosStringUtils.equals(openCloseFlag, "O")){
	 		if(XenosStringUtils.equals(buySellOrientationFlag, "FB")){
	 			this.openClosePosition.selectedIndex = 0;
	 		} else {
	 			this.openClosePosition.selectedIndex = 1;
	 		}
	 	} else {
	 		if(XenosStringUtils.equals(buySellOrientationFlag, "FB")){
	 			this.openClosePosition.selectedIndex = 3;
	 		} else {
	 			this.openClosePosition.selectedIndex = 2;
	 		}
	 	}
        
        
	 	
	 	// load Tax fee list.
	 	var taxFeeListArr:ArrayCollection = mapObj[keylist.getItemAt(13)] as ArrayCollection
	 	if(taxFeeListArr != null) {					
        	taxFeeSummaryResult.removeAll(); 
			try {
			    for each ( var rec1:XML in taxFeeListArr) {
			    	rec1.isVisible = true;
 				    taxFeeSummaryResult.addItem(rec1);
			    }
            	taxFeeSummaryResult.refresh();
            	taxFeeSummary.visible = true;
            	taxFeeSummary.includeInLayout = true;
			}catch(e:Error){
			    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.error.load.taxfee'));
		    }
		 }
		 
		// load Margin list.
	 	var marginListArr:ArrayCollection = mapObj[keylist.getItemAt(14)] as ArrayCollection
	 	if(marginListArr != null) {					
        	marginSummaryResult.removeAll(); 
			try {
			    for each ( var rec2:XML in marginListArr) {
			    	rec2.isVisible = true;
 				    marginSummaryResult.addItem(rec2);
			    }
            	marginSummaryResult.refresh();
            	marginSummary.visible = true;
            	marginSummary.includeInLayout = true;
			}catch(e:Error){
			    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.error.load.margin'));
		    }
		 }
		 
		 this.marginType.selectedIndex = 1;
		 
		 // Load SSI Info
		 var ssiInfo:Object = mapObj[keylist.getItemAt(15)];
		 //XenosAlert.info("ssiInfo"+ssiInfo);
		 if(ssiInfo != null){
			 this.settlementMode.text = ssiInfo[0].settlementMode;
			 this.ourBankStr.text = ssiInfo[0].ourBankStr;
			 this.ourSettleAccountStr.text = ssiInfo[0].ourSettleAccountStr;
			 this.instructionReqdStr.text = ssiInfo[0].instructionReqdStr;
			 this.autoTransmissionReqdStr.text = ssiInfo[0].autoTransmissionReqdStr;
			 this.settlementAcPkStr.text = ssiInfo[0].ourSettleAccountPk;
			 this.bankPkStr.text = ssiInfo[0].ourBankPk;
		 }
	 	
	 	this.securityId.instrumentPopup.visible = false;
    	this.securityId.instrumentId.editable = false;
    	this.securityId.instrumentId.enabled = false;
    	this.fundAccountNo.accountPopup.visible = false;
    	this.fundAccountNo.accountNo.editable = false;
    	this.fundAccountNo.accountNo.enabled = false;
    	this.brkAccountNo.accountPopup.visible = false;
    	this.brkAccountNo.accountNo.editable = false;
    	this.brkAccountNo.accountNo.enabled = false;
    	this.exposure.editable = false;
	 	this.exposureInIssueCcy.editable = false;
	 	this.netAmount.editable = false;
	 	this.settlementType.editable = false;
	 	this.settlementBasis.editable = false;
	 	
	 	this.marginRefNoCol.visible = true;
    	
    }
    private function commonResultPart(mapObj:Object):void{
    	    	
    	contractVoAttbList = mapObj[keylist.getItemAt(0)] as ArrayCollection;
    	tradeVoAttbList = mapObj[keylist.getItemAt(1)] as ArrayCollection;
	 	
	 	this.uConfSecurityId.text = getVoAttbValue(contractVoAttbList,'securityId');
	 	this.uConfSecurityName.text = getVoAttbValue(contractVoAttbList,'securityShortName');
	 	this.uConfOpenClosePosition.text = getVoAttbValue(tradeVoAttbList,'openCloseFlagStr');
	 	this.uConfTradeDate.text = getVoAttbValue(tradeVoAttbList,'tradeDate');
	 	this.uConfValueDate.text = getVoAttbValue(tradeVoAttbList,'valueDate');
	 	this.uConfFundAccountNo.text = getVoAttbValue(contractVoAttbList,'inventoryAccountNo');
	 	this.uConfFundAccountName.text = getVoAttbValue(contractVoAttbList,'inventoryAccountName');
	 	this.uConfExeBrkAccountNo.text = getVoAttbValue(tradeVoAttbList,'executionBrokerAccountNo');
	 	this.uConfExeBrkAccountName.text = getVoAttbValue(tradeVoAttbList,'executionBrokerAccountName');
	 	this.uConfBrkAccountNo.text = getVoAttbValue(contractVoAttbList,'cpAccountNo');
	 	this.uConfBrkAccountName.text = getVoAttbValue(contractVoAttbList,'cpAccountName');
	 	this.uConfPrice.text = getVoAttbValue(tradeVoAttbList,'price');
	 	this.uConfQuantity.text = getVoAttbValue(tradeVoAttbList,'tradeQuantity');
	 	this.uConfExexcutionMarket.text = getVoAttbValue(tradeVoAttbList,'executionMarket');
	 	this.uConfTradeCcy.text = getVoAttbValue(tradeVoAttbList,'tradingCcy');
	 	this.uConfExchangerate.text = getVoAttbValue(tradeVoAttbList,'exchangeRate');
	 	this.uConfCalculationType.text = getVoAttbValue(tradeVoAttbList,'calculationType');
	 	this.uConfExecutionOffice.text=getVoAttbValue(tradeVoAttbList,'executionOffice');
	 	this.uConfInxSuppressFlag.text=getVoAttbValue(tradeVoAttbList,'instructionSuppressFlag');
	 	this.uConfRemarks.text = mapObj[keylist.getItemAt(3)].toString();
	 	
	 	this.uConfExposure.text = getVoAttbValue(tradeVoAttbList,'principalAmount');
	 	this.uConfExposureInIssueCcy.text = getVoAttbValue(tradeVoAttbList,'principalAmountInIssueCcy');
	 	this.uConfNetAmount.text = getVoAttbValue(tradeVoAttbList,'netAmount');
	 	this.uConfSettlementType.text = getVoAttbValue(contractVoAttbList,'drvSettlementType');
	 	this.uConfSettlementBasis.text = getVoAttbValue(contractVoAttbList,'settlementBasis');
	 	
	 	this.uConfSettlementMode.text = mapObj[keylist.getItemAt(4)].toString();
	 	this.uConfOurBankStr.text = mapObj[keylist.getItemAt(5)].toString();
	 	this.uConfOurSettleAccountStr.text = mapObj[keylist.getItemAt(6)].toString();
	 	this.uConfInstructionReqdStr.text = mapObj[keylist.getItemAt(7)].toString();
	 	this.uConfAutoTransmissionReqdStr.text = mapObj[keylist.getItemAt(8)].toString();
	 	
	 	this.executionMarket.text = getVoAttbValue(tradeVoAttbList,'executionMarket');
	 	this.tradeCcy.ccyText.text =  getVoAttbValue(tradeVoAttbList,'tradingCcy');
	 	this.exchangeRate.text = getVoAttbValue(tradeVoAttbList,'exchangeRate');
	 	this.exposure.text = getVoAttbValue(tradeVoAttbList,'principalAmount');
	 	this.exposureInIssueCcy.text = getVoAttbValue(tradeVoAttbList,'principalAmountInIssueCcy');
	 	this.netAmount.text = getVoAttbValue(tradeVoAttbList,'netAmount');
	 	this.settlementType.text = getVoAttbValue(contractVoAttbList,'drvSettlementType');
	 	this.valueDate.text = getVoAttbValue(tradeVoAttbList,'valueDate');
	 	softWarn.showWarning(mapObj["softWarning"])
	 	
	 	// Set Calculation Type
	 	var calType:String = mapObj[keylist.getItemAt(2)].toString();
	 	if(XenosStringUtils.equals(calType, "D")){
	 		this.calculationType.selectedIndex = 0;
	 	} else {
	 		this.calculationType.selectedIndex = 1;
	 	}
        
	 	// Set Settlement Basis
	 	var settlementBasis:String = mapObj[keylist.getItemAt(10)].toString();
	 	var settlementBasisList:ArrayCollection = this.settlementBasis as ArrayCollection;
	 	var selIndx3:int = 0;
   		for each(var item3:Object in settlementBasisList){
            //Get the default value object's index
            if(XenosStringUtils.equals(item3.value,settlementBasis)){                    
                selIndx3 = settlementBasisList.getItemIndex(item3);
            }            
        }
        this.settlementBasis.selectedIndex = selIndx3;
	 	if(this.mode == "entry"){	 		
		 	var contractMode:String = mapObj[keylist.getItemAt(14)].toString();
	        if(contractMode == "EXIST"){
	        	this.settlementBasis.enabled = false;
	        }
	    } else if(this.mode == "amend"){
	    	this.settlementBasis.enabled = false;
	    }
	    
	 	// load Tax fee list.
	 	var taxFeeListArr:ArrayCollection = mapObj[keylist.getItemAt(11)] as ArrayCollection
	 	if(taxFeeListArr != null) {					
        	taxFeeSummaryResult.removeAll(); 
			try {
			    for each ( var rec1:XML in taxFeeListArr) {
			    	rec1.isVisible = true;
 				    taxFeeSummaryResult.addItem(rec1);
			    }
            	taxFeeSummaryResult.refresh();
            	taxFeeSummary.visible = true;
            	taxFeeSummary.includeInLayout = true;
			}catch(e:Error){
			    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.error.load.taxfee'));
		    }
		 }
		 
		// load Margin list.
	 	var marginListArr:ArrayCollection = mapObj[keylist.getItemAt(12)] as ArrayCollection
	 	if(marginListArr != null) {					
        	marginSummaryResult.removeAll(); 
			try {
			    for each ( var rec2:XML in marginListArr) {
			    	rec2.isVisible = true;
 				    marginSummaryResult.addItem(rec2);
			    }
            	marginSummaryResult.refresh();
            	marginSummary.visible = true;
            	marginSummary.includeInLayout = true;
			}catch(e:Error){
			    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.error.load.margin'));
		    }
		 }
		 
	 	this.exposure.editable = false;
	 	this.exposureInIssueCcy.editable = false;
	 	this.netAmount.editable = false;
	 	this.settlementType.editable = false;
	 	this.settlementBasis.editable = false;
	 	
    }
        override public function postCancelResultInit(mapObj:Object): void{
        		
            commonResultPart(mapObj);
        	uConfSubmit.includeInLayout = false;
        	uConfSubmit.visible = false;
        	cancelSubmit.visible = true;
        	cancelSubmit.includeInLayout = true;
        }
        
        private function addCommonResultKes():void{
        	keylist = new ArrayCollection();
	    	keylist.addItem("contractVo.otherAttributes.entry");
	    	keylist.addItem("tradeVo.otherAttributes.entry");
	    	keylist.addItem("tradeVo.calculationType");
	    	keylist.addItem("tradeVo.remarks");
	    	
	    	keylist.addItem("ssiInfo.settlementMode");
	    	keylist.addItem("ssiInfo.ourBankStr");
	    	keylist.addItem("ssiInfo.ourSettleAccountStr");
	    	keylist.addItem("ssiInfo.instructionReqdStr");
	    	keylist.addItem("ssiInfo.autoTransmissionReqdStr");
	    	
	    	keylist.addItem("contractVo.drvSettlementType");  
	    	keylist.addItem("contractVo.settlementBasis");
	    	
	    	keylist.addItem("taxFeeList");
	    	keylist.addItem("marginList");
	    	keylist.addItem("ssiInfo");
        }
        
        private function commonResult(mapObj:Object):void{
	    	if(mapObj!=null){    		
		    	if(mapObj["errorFlag"].toString() == "error"){
		    		if(mode != "cancel"){
		    		  errPage.showError(mapObj["errorMsg"]);		    			
		    		}else{
		    			XenosAlert.error(mapObj["errorMsg"]);
		    		}
		    	}else if(mapObj["errorFlag"].toString() == "noError"){
		    		
		    	 errPage.clearError(super.getSaveResultEvent());			    			
	             commonResultPart(mapObj);
	             //XenosAlert.info("Page Status : " + pageStatus);
		    	 if(pageStatus == "init"){
		    	 	pageStatus = "entry";
		    	 	this.othersws.visible = true;
		   	   	    this.othersws.includeInLayout = true;
		   	   	    this.ssiws.visible = true;
		   	   	    this.ssiws.includeInLayout = true;
		    	 	this.initBack.includeInLayout = true;
   	   				this.initBack.visible = true;
   	   				this.reset.visible = false;
   	   				this.reset.includeInLayout = false;
		    	 } else if(pageStatus == "entry"){
		    	 	pageStatus = "entryconfirm";
		    	 	changeCurrentState();
		    	 } else {
		    	 	this.othersws.visible = false;
		    	 	this.othersws.includeInLayout = false;
		    	 	this.ssiws.visible = false;
		    	 	this.ssiws.includeInLayout = false;
		    	 }
		    	}else{
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    	}    		
	    	}
        }
        
    	private function setValidator():void{
			var validateModel:Object={
                            drvTradeEntry:{                                
                                securityId:this.securityId.instrumentId.text,
								openClosePosition:this.openClosePosition.selectedItem != null ? this.openClosePosition.selectedItem.value : "",
								tradeDate:this.tradeDate.text,
								fundAccountNo:this.fundAccountNo.accountNo.text,
								exeBrkAccountNo:this.exeBrkAccountNo.accountNo.text,
								brkAccountNo:this.brkAccountNo.accountNo.text,
								price:this.price.text,
								quantity:this.quantity.text
                            }
                           }; 
	         super._validator = new DrvTradeDetailsValidator();
	         super._validator.source = validateModel ;
	         super._validator.property = "drvTradeEntry";
		}
		 override public function preEntry():void{
		 	setValidator();
		 	//XenosAlert.info("preEntry ");
		 	super.getSaveHttpService().url = "drv/drvTradeEntryDetails.action?"; 
            super.getSaveHttpService().request = populateRequestParams();
            super.getSaveHttpService().method = 'POST';
		 }
		 
		 override public function preAmend():void{
		 	setValidator();
		 	super.getSaveHttpService().url = "drv/drvTradeAmendDetails.action?";
            super.getSaveHttpService().request  =populateRequestParams();
		 } 
		 override public function preCancel():void{
		 	//setValidator();
		 	super._validator = null;
		 	super.getSaveHttpService().url = "drv/drvTradeCancelDetails.action?";
		 	 var reqObj:Object = new Object();
		 	 reqObj.method="doCancelConfirm";
		 	 reqObj.mode=this.mode;
		 	 reqObj['SCREEN_KEY'] = "10050";
            super.getSaveHttpService().request  =reqObj;
		 }
		 
		 
		override public function preEntryResultHandler():Object
		{
			 addCommonResultKes();
			 keylist.addItem("contractMode");
			 return keylist;
		}
		
		override public function preAmendResultHandler():Object
		{
			addCommonResultKes();
			return keylist;
		} 
		
		override public function postCancelResultHandler(mapObj:Object):void
		{
			submitUserConfResult(mapObj);
			if(mapObj!=null){    
    			if( !XenosStringUtils.equals( mapObj["errorFlag"].toString() , "error") ){
    				app.submitButtonInstance = uCancelConfSubmit;
					this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('drv.label.trd.cancel.userconf');
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
		        	usrCnfMessage.text =this.parentApplication.xResourceManager.getKeyValue('drv.alert.value.drvtrade.cancel');
		       }
		   }
		} 
		
		override public function postEntryResultHandler(mapObj:Object):void
		{
			commonResult(mapObj);
			uConfLabel.includeInLayout = true;
			uConfLabel.visible = true;
			uConfImg.includeInLayout =false;
			uConfImg.visible =false;
			usrCnfMessage.text = this.parentApplication.xResourceManager.getKeyValue('drv.label.trd.entry.userconf');
		}
		
		override public function postAmendResultHandler(mapObj:Object):void
		{
			commonResult(mapObj);
			uConfLabel.includeInLayout = true;
			uConfLabel.visible = true;
			usrCnfMessage.text =this.parentApplication.xResourceManager.getKeyValue('drv.label.trd.amend.userconf');
		}
		 
		 
		
		override public function preEntryConfirm():void
		{
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "drv/drvTradeEntryDetails.action?"; 
			reqObj.method= "doEntrySave";
			reqObj['SCREEN_KEY'] = "10054";
            super.getConfHttpService().request  =reqObj;
            actionBtnPanel.enabled =false;
		}
		
		override public function preAmendConfirm():void
		{
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "drv/drvTradeAmendDetails.action?";  
			reqObj.method= "doAmendSave";
			reqObj['SCREEN_KEY'] = "10047";
            super.getConfHttpService().request  =reqObj;
            actionBtnPanel.enabled =false;
		}
		
		override public function preCancelConfirm():void
		{
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "drv/drvTradeCancelDetails.action?";  
			reqObj.method= "doCancelSave";
			reqObj['SCREEN_KEY'] = "10051";
            super.getConfHttpService().request  =reqObj;
            actionBtnPanel.enabled =false;
		}
		override public function preEntryConfirmResultHandler():Object
		{
			keylist = new ArrayCollection();
	    	keylist.addItem("tradeVo.parent.contractReferenceNo");
	    	keylist.addItem("tradeVo.tradeReferenceNo");
	    	keylist.addItem("tradeVo.versionNo");
	    	return keylist;
		}
		override public function postConfirmEntryResultHandler(mapObj:Object):void
		{					 	
			submitUserConfResult(mapObj);
			uConfLabel.includeInLayout = true;
			uConfLabel.visible = true;
			uConfImg.includeInLayout =false;
			uConfImg.visible =false;
			usrCnfMessage.text = this.parentApplication.xResourceManager.getKeyValue('drv.label.trd.entry.sysconf');
			tradeRefConfMessage.text= this.parentApplication.xResourceManager.getKeyValue('drv.label.tradereferenceno')+" : "+ mapObj[keylist.getItemAt(1)]+" - "+mapObj[keylist.getItemAt(2)];
			contractRefConfMessage.text= this.parentApplication.xResourceManager.getKeyValue('drv.label.contractreferenceno')+" : "+ mapObj[keylist.getItemAt(0)];
			this.cancelRefConfMessage.includeInLayout = false;
			this.cancelRefConfMessage.visible = false
			this.softWarn.visible=false;
			actionBtnPanel.enabled =true;
		}
		override public function preConfirmAmendResultHandler():Object
		{
			keylist = new ArrayCollection();
	    	keylist.addItem("tradeVo.parent.contractReferenceNo");
	    	keylist.addItem("tradeVo.tradeReferenceNo");
	    	keylist.addItem("tradeVo.versionNo");
	    	return keylist;
		}
		override public function postConfirmAmendResultHandler(mapObj:Object):void
		{
			submitUserConfResult(mapObj);
			this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('drv.label.trd.amend.sysconf');
			tradeRefConfMessage.text= this.parentApplication.xResourceManager.getKeyValue('drv.label.tradereferenceno')+" : "+ mapObj[keylist.getItemAt(1)]+" - "+mapObj[keylist.getItemAt(2)];
			contractRefConfMessage.text= this.parentApplication.xResourceManager.getKeyValue('drv.label.contractreferenceno')+" : "+ mapObj[keylist.getItemAt(0)];
			this.cancelRefConfMessage.includeInLayout = false;
			this.softWarn.visible=false;
			this.cancelRefConfMessage.visible = false
			actionBtnPanel.enabled =true;

		}
		override public function preConfirmCancelResultHandler():Object
		{
			keylist = new ArrayCollection();
	    	keylist.addItem("tradeVo.parent.contractReferenceNo");
	    	keylist.addItem("tradeVo.tradeReferenceNo");
	    	keylist.addItem("tradeVo.versionNo");
	    	keylist.addItem("tradeVo.cancelReferenceNo");
	    	return keylist;
		}
		override public function postConfirmCancelResultHandler(mapObj:Object):void
		{
			submitUserConfResult(mapObj);
			this.sConfLabel.height = 100;
			this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('drv.label.trd.cancel.sysconf');
			tradeRefConfMessage.text= this.parentApplication.xResourceManager.getKeyValue('drv.label.tradereferenceno')+" : "+ mapObj[keylist.getItemAt(1)]+" - "+mapObj[keylist.getItemAt(2)];
			contractRefConfMessage.text= this.parentApplication.xResourceManager.getKeyValue('drv.label.contractreferenceno')+" : "+ mapObj[keylist.getItemAt(0)];
			cancelRefConfMessage.text= this.parentApplication.xResourceManager.getKeyValue('drv.label.cxlreferenceno')+" : "+ mapObj[keylist.getItemAt(3)];

        	cancelSubmit.visible = false;
        	cancelSubmit.includeInLayout = false;
        	uCancelConfSubmit.visible = false;
        	uCancelConfSubmit.includeInLayout = false;
        	uConfLabel.includeInLayout = false;
			uConfLabel.visible = false;
			actionBtnPanel.enabled =true;
	}
		
	private function submitUserConfResult(mapObj:Object):void{
    	//var mapObj:Object = mkt.userConfResultEvent(event);
    	if(mapObj!=null){    
    		//XenosAlert.info("object status : "+mapObj["errorFlag"].toString());		
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		//XenosAlert.error(mapObj["errorMsg"].toString());
	    		uConfSubmit.enabled = false;
	    		uConfSubmit.includeInLayout = false;
	    		uConfLabel.includeInLayout = false;
			   	uConfLabel.visible = false;
		    	usrConfErrPage.showError(mapObj["errorMsg"]);
		    	
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    		if(mode!="cancel"){
	    			errPage.clearError(super.getConfResultEvent());
	    		}
    			usrConfErrPage.clearError(super.getConfResultEvent());
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
	    	}else{
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
    	if(this.mode == 'entry'){
	    	if(pageStatus == "init"){   	
	    		reqObj.method= "doInitialEntry";
	    		reqObj['SCREEN_KEY'] = "10052";
	    		
	    	}else{   	
	    		reqObj.method= "doEntryConfirm";
	    		reqObj['SCREEN_KEY'] = "10053";
	    	}
	    }
	    if(this.mode == 'amend'){
    		reqObj.method= "doAmendConfirm";
    		reqObj['SCREEN_KEY'] = "10046";
	    }
    			
		reqObj['mapContractVO(securityId)'] = this.securityId.instrumentId.text;
		reqObj['mapTradeVO(openCloseFlag)'] = this.openClosePosition.selectedItem != null ? this.openClosePosition.selectedItem.value : "";
		reqObj['mapTradeVO(tradeDate)'] = this.tradeDate.text;
		reqObj['mapTradeVO(valueDate)'] = this.valueDate.text;
		reqObj['mapContractVO(inventoryAccountNo)'] = this.fundAccountNo.accountNo.text;
		reqObj['mapTradeVO(executionBrokerAccountNo)'] = this.exeBrkAccountNo.accountNo.text;
		reqObj['mapContractVO(cpAccountNo)'] = this.brkAccountNo.accountNo.text;
		reqObj['mapTradeVO(price)'] = this.price.text;
		reqObj['mapTradeVO(tradeQuantity)'] = this.quantity.text;
		reqObj['mapTradeVO(executionMarket)'] = this.executionMarket.itemCombo != null ? this.executionMarket.itemCombo.text : "";
		reqObj['mapTradeVO(tradingCcy)'] = this.tradeCcy.ccyText.text;
		reqObj['mapTradeVO(exchangeRate)'] = this.exchangeRate.text;
		reqObj['mapTradeVO(executionOffice)'] = this.executionOffice.selectedItem != null ? this.executionOffice.selectedItem.value : "";
		reqObj['tradeVo.calculationType'] = this.calculationType.selectedItem != null ? this.calculationType.selectedItem.value : "";
		reqObj['tradeVo.remarks'] = this.remarks.text;
		
		reqObj['tradeVo.instructionSuppressFlag'] = this.inxSuppressFlag.selectedItem != null ? this.inxSuppressFlag.selectedItem.value : "";
		reqObj['contractVo.settlementBasis'] = this.settlementBasis.selectedItem != null ? this.settlementBasis.selectedItem.value : "";
		
		reqObj['ssiInfo.settlementMode'] = this.settlementMode.text;
		reqObj['ssiInfo.ourBankStr'] = this.ourBankStr.text;
		reqObj['ssiInfo.ourSettleAccountStr'] = this.ourSettleAccountStr.text;
		reqObj['ssiInfo.instructionReqdStr'] = this.instructionReqdStr.text;
		reqObj['ssiInfo.autoTransmissionReqdStr'] = this.autoTransmissionReqdStr.text;
		reqObj['ssiInfo.settlementAcPkStr'] = this.settlementAcPkStr.text;
		reqObj['ssiInfo.bankPkStr'] = this.bankPkStr.text;
		
    	return reqObj;
    }
    
   override public function preResetEntry():void
   {
   	  
		       var rndNo:Number= Math.random();
		  		super.getResetHttpService().url = "drv/drvTradeEntryDetails.action?method=initialExecute&rnd=" + rndNo; 
   }
   override public function preResetAmend():void
   {
   	  
		       var rndNo:Number= Math.random();
		  		super.getResetHttpService().url = "drv/drvTradeAmendDetails.action?method=doAmend&tradePk="+ this.drvTradePkStr+"&rnd=" + rndNo; 
   }
   
   
	override public function doEntrySystemConfirm(e:Event):void
	{
		 pageStatus = "init";
		 super.preEntrySystemConfirm();
		 this.dispatchEvent(new Event('entryReset'));
		 this.back.includeInLayout = true;
		 this.back.visible = true;
		 uConfLabel.includeInLayout = true;
		 uConfLabel.visible = true;
		 uConfSubmit.includeInLayout = true;
		 uConfSubmit.visible = true;
		 app.submitButtonInstance = uConfSubmit;
		 sConfLabel.includeInLayout = false;
		 sConfLabel.visible = false;
		 sConfSubmit.includeInLayout = false;
		 sConfSubmit.visible = false;
		 this.othersws.visible = false;
   	   	 this.othersws.includeInLayout = false;
   	   	 this.ssiws.visible = false;
   	   	 this.ssiws.includeInLayout = false;
   	   	 this.initBack.includeInLayout = false;
		 this.initBack.visible = false;
   	   	 this.reset.visible = true;
   	   	 this.reset.includeInLayout = true;
       	 vstack.selectedChild = qry;	
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
  
    private function doBack():void{
    	usrConfErrPage.clearError(super.getConfResultEvent());
		//hdbox1.selectedChild = this.qry;
   	   	//this.currentState="entryState";
   	   	if(pageStatus == "entryconfirm"){
   	   		vstack.selectedChild = qry;
   	   		if(this.mode == "entry"){
	   	   		this.initBack.includeInLayout = true;
	   	   		this.initBack.visible = true;
	   	   	} else {
	   	   		this.initBack.includeInLayout = false;
	   	   		this.initBack.visible = false;
	   	   		this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('drv.label.trdamend.page');
	   	   	}
   	   		this.othersws.visible = true;
   	   	    this.othersws.includeInLayout = true;
   	   	    this.ssiws.visible = true;
   	   	    this.ssiws.includeInLayout = true;
   	   		pageStatus = "entry";
   	   	} else 	if(pageStatus == "entry"){
   	   		vstack.selectedChild = qry;
   	   		this.othersws.visible = false;
	   	   	this.othersws.includeInLayout = false;
	   	   	this.ssiws.visible = false;
	   	   	this.ssiws.includeInLayout = false;
   	   		this.initBack.includeInLayout = false;
   	   		this.initBack.visible = false;
   	   		this.reset.includeInLayout = true;
   	   		this.reset.visible = true;
   	   		pageStatus = "init";  	   		
   	   	} else {
   	   		vstack.selectedChild = qry;
   	   		this.othersws.visible = false;
   	   	    this.othersws.includeInLayout = false;
   	   	    this.ssiws.visible = false;
   	   	    this.ssiws.includeInLayout = false;
   	   		pageStatus = "init";
   	   	}	
    }  	
  

    /**

     * Formatting price

     */

     private function priceHandler():void{
     	   
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
	
	   /**
        * To add Tax Fee Information
        */
        private function addTaxFee():void{
        	if(taxFeeId.selectedItem == null || taxFeeId.selectedItem.value == ""){
        		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.error.select.taxfeeid'));
        		return;
        	}
        	if(XenosStringUtils.isBlank(taxFeeAmount.text)){
        		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.error.missing.taxfee'));
        		return;
        	}
        	addTaxFeeService.request = populateTaxFeeParam();
        	if(this.mode == 'entry')
        		addTaxFeeService.url = "drv/drvTradeEntryDetails.action?method=addTaxFee";
        	else if(this.mode == 'amend')
        		addTaxFeeService.url = "drv/drvTradeAmendDetails.action?method=addTaxFee";
        	else
        		addTaxFeeService.url = "drv/drvTradeCancelDetails.action?method=addTaxFee";
        	addTaxFeeService.send();
        }
        
        public function deleteTaxFee(data:Object):void{
        	var reqObj : Object = new Object();
        	reqObj.rowNoForTaxFee = taxFeeSummaryResult.getItemIndex(data);
        	
        	if(this.mode == 'entry')
        		deleteTaxFeeService.url = "drv/drvTradeEntryDetails.action?method=deleteTaxFee";
        	else if(this.mode == 'amend')
        		deleteTaxFeeService.url = "drv/drvTradeAmendDetails.action?method=deleteTaxFee";
        	else
        		deleteTaxFeeService.url = "drv/drvTradeCancelDetails.action?method=deleteTaxFee";
        	
        	deleteTaxFeeService.request = reqObj;
        	deleteTaxFeeService.send();
        }
        
        private function populateTaxFeeParam():Object{
        	var reqObj : Object = new Object();
	    	reqObj['taxFee.taxFeeId'] = this.taxFeeId.selectedItem != null ? this.taxFeeId.selectedItem.value : "";
	    	
	    	reqObj['taxFee.taxFeeAmountStr'] = this.taxFeeAmount.text;
	    	
	    	return reqObj;
        }
        
      /**
	    * This method works as the result handler of the Submit Query Http Services.
	    * 
	    */
	    public function TaxFeeAddResult(event:ResultEvent):void {
	        var rs:XML = XML(event.result);
			if (null != event) {
				 if(rs.child("taxFeeList").length()>0) {
					errPage.clearError(event);
					// if(this.mode != "AMEND")
		            	taxFeeSummaryResult.removeAll(); 
					try {
					    for each ( var rec:XML in rs.taxFeeList) {
					    	rec.isVisible = true;
		 				    taxFeeSummaryResult.addItem(rec);
					    }
					    taxFeeGrid.visible = true;
					    taxFeeGrid.includeInLayout = true;
					    taxFeeAmount.text = "";
		            	taxFeeSummaryResult.refresh();
		            	taxFeeSummary.visible = true;
		            	taxFeeSummary.includeInLayout = true;
					}catch(e:Error){
					    //XenosAlert.error(e.toString() + e.message);
					    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				    }
				 } else if(rs.child("Errors").length()>0) {
	                //some error found
				 	//countryCodeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
	                //populate the error info list 			 	
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	errPage.showError(errorInfoList);//Display the error
				 } else {
				 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				 	taxFeeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
				 	errPage.removeError(); //clears the errors if any
				 }
	        }	     	        
	    } 
	    
      /**
	    * This method works as the result handler of the Submit Query Http Services.
	    * 
	    */
	    public function TaxFeeDeleteResult(event:ResultEvent):void {
	        var rs:XML = XML(event.result);
			if (null != event) {
				 if(rs.child("taxFeeList").length()>0) {
					errPage.clearError(event);
		            	taxFeeSummaryResult.removeAll(); 
					try {
					    for each ( var rec:XML in rs.taxFeeList) {
					    	rec.isVisible = true;
		 				    taxFeeSummaryResult.addItem(rec);
					    }
					    taxFeeGrid.visible = true;
					    taxFeeGrid.includeInLayout = true;
					    taxFeeAmount.text = "";
		            	taxFeeSummaryResult.refresh();
		            	taxFeeSummary.visible = true;
		            	taxFeeSummary.includeInLayout = true;
					}catch(e:Error){
					    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				    }
				 } else if(rs.child("Errors").length()>0) {
	                //some error found
				 	//countryCodeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
	                //populate the error info list 			 	
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	errPage.showError(errorInfoList);//Display the error
				 } else {
				 	taxFeeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
				 	errPage.removeError(); //clears the errors if any
				 }
	        }
	        
	        
	    }  
	    
	  /**
        * To add Margin Information
        */
        private function addMargin():void{
        	if(XenosStringUtils.isBlank(baseDate.text)){
        		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.alert.value.basedate.notnull'));
        		return;
        	}
        	if(marginType.selectedItem == null || marginType.selectedItem.value == ""){
        		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.error.select.margintype'));
        		return;
        	}
        	if(XenosStringUtils.isBlank(marginAmount.text)){
        		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('drv.error.missing.marginamt'));
        		return;
        	}
        	
        	addMarginService.request = populateMarginParam();
        	
        	if(this.mode == 'entry')
        		addMarginService.url = "drv/drvTradeEntryDetails.action?method=addMargin";
        	else if(this.mode == 'amend')
        		addMarginService.url = "drv/drvTradeAmendDetails.action?method=addMargin";
        	else
        		addMarginService.url = "drv/drvTradeCancelDetails.action?method=addMargin";
        	
        	addMarginService.send();
        }
        public function deleteMargin(data:Object):void{
        	var reqObj : Object = new Object();
        	reqObj.rowNoForMargin = marginSummaryResult.getItemIndex(data);
        	
        	if(this.mode == 'entry')
        		deleteMarginService.url = "drv/drvTradeEntryDetails.action?method=deleteMargin";
        	else if(this.mode == 'amend')
        		deleteMarginService.url = "drv/drvTradeAmendDetails.action?method=deleteMargin";
        	else
        		deleteMarginService.url = "drv/drvTradeCancelDetails.action?method=deleteMargin";
        	
        	deleteMarginService.request = reqObj;
        	deleteMarginService.send();
        }
        public function editMargin(data:Object):void{
        	var reqObj : Object = new Object();
        	reqObj.rowNoForMargin = marginSummaryResult.getItemIndex(data);
        	
        	if(this.mode == 'entry')
        		editMarginService.url = "drv/drvTradeEntryDetails.action?method=editMargin";
        	else if(this.mode == 'amend')
        		editMarginService.url = "drv/drvTradeAmendDetails.action?method=editMargin";
        	else
        		editMarginService.url = "drv/drvTradeCancelDetails.action?method=editMargin";
        	
        	editMarginService.request = reqObj;
        	editMarginService.send();
        } 
        
        private function populateMarginParam():Object{
        	var reqObj : Object = new Object();
	    	reqObj['margin.marginType'] = this.marginType.selectedItem != null ? this.marginType.selectedItem.value : "";	    	
	    	reqObj['margin.baseDateStr'] = this.baseDate.text;
	    	reqObj['margin.marginCcyStr'] = this.marginCcy.ccyText.text;
	    	reqObj['margin.marginAmountStr'] = this.marginAmount.text;
	    	
	    	return reqObj;
        }
        
      /**
	    * This method works as the result handler of the Submit Query Http Services.
	    * 
	    */
	    public function MarginAddResult(event:ResultEvent):void {
	        var rs:XML = XML(event.result);
			if (null != event) {
				 if(rs.child("marginList").length()>0) {
					errPage.clearError(event);
					// if(this.mode != "AMEND")
		            	marginSummaryResult.removeAll(); 
					try {
					    for each ( var rec:XML in rs.marginList) {
					    	rec.isVisible = true;
		 				    marginSummaryResult.addItem(rec);
					    }
					    marginGrid.visible = true;
					    marginGrid.includeInLayout = true;
					    marginAmount.text = "";
					    marginCcy.ccyText.text = "";
					    baseDate.text = "";
					    marginType.prompt = "Select";
		            	marginSummaryResult.refresh();
		            	marginSummary.visible = true;
		            	marginSummary.includeInLayout = true;
					}catch(e:Error){
					    //XenosAlert.error(e.toString() + e.message);
					    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				    }
				 } else if(rs.child("Errors").length()>0) {
	                //some error found
				 	//countryCodeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
	                //populate the error info list 			 	
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	errPage.showError(errorInfoList);//Display the error
				 } else {
				 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				 	marginSummaryResult.removeAll(); // clear previous data if any as there is no result now.
				 	errPage.removeError(); //clears the errors if any
				 }
	        }	        
	    }
      /**
	    * This method works as the result handler of the Submit Query Http Services.
	    * 
	    */
	    public function MarginDeleteResult(event:ResultEvent):void {
	        var rs:XML = XML(event.result);
			if (null != event) {
				 if(rs.child("marginList").length()>0) {
					errPage.clearError(event);
					// if(this.mode != "AMEND")
		            	marginSummaryResult.removeAll(); 
					try {
					    for each ( var rec:XML in rs.marginList) {
					    	rec.isVisible = true;
		 				    marginSummaryResult.addItem(rec);
					    }
					    marginGrid.visible = true;
					    marginGrid.includeInLayout = true;
		            	marginSummaryResult.refresh();
		            	marginSummary.visible = true;
		            	marginSummary.includeInLayout = true;
					}catch(e:Error){
					    //XenosAlert.error(e.toString() + e.message);
					    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				    }
				 } else if(rs.child("Errors").length()>0) {
	                //some error found
				 	//countryCodeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
	                //populate the error info list 			 	
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	errPage.showError(errorInfoList);//Display the error
				 } else {
				 	marginSummaryResult.removeAll(); // clear previous data if any as there is no result now.
				 	errPage.removeError(); //clears the errors if any
				 }
	        }	        
	    }      
	    
      /**
	    * This method works as the result handler of the Submit Query Http Services.
	    * 
	    */
	    public function MarginEditResult(event:ResultEvent):void {
	        var rs:XML = XML(event.result);
	
			if (null != event) {
				if(rs.child("marginList").length()>0) {
					errPage.clearError(event);
		            	marginSummaryResult.removeAll(); 
					try {
					    for each ( var rec:XML in rs.marginList) {
					    	rec.isVisible = true;
		 				    marginSummaryResult.addItem(rec);
					    }
					    marginGrid.visible = true;
					    marginGrid.includeInLayout = true;
		            	marginSummaryResult.refresh();
		            	marginSummary.visible = true;
		            	marginSummary.includeInLayout = true;
					}catch(e:Error){
					    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				    }
				 } else {
				 	marginSummaryResult.removeAll();
				 	marginSummaryResult.refresh();
				 }
				if(rs.child("margin").length()>0){
					editedMargin = rs;
					this.baseDate.text = editedMargin.margin.baseDateStr;
					this.marginAmount.text = editedMargin.margin.marginAmountStr;
					this.marginCcy.ccyText.text = editedMargin.margin.marginCcyStr;
					if(XenosStringUtils.equals(editedMargin.margin.marginType, "I")){
						this.marginType.selectedIndex = 0;
					} else {
						this.marginType.selectedIndex = 1;
					}
				} else if(rs.child("Errors").length()>0) {
	                //some error found
				 	marginSummaryResult.removeAll(); // clear previous data if any as there is no result now.
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
	                //populate the error info list 			 	
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	errPage.showError(errorInfoList);//Display the error
				 } else {
				 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				 	marginSummaryResult.removeAll(); // clear previous data if any as there is no result now.
				 	errPage.removeError(); //clears the errors if any
				 }
	        }   
	    }
	    
	    private function resetSsi():void {
	    	resetSsiInfoService.request = populateMarginParam();
	    	
	    	if(this.mode == 'entry')
        		resetSsiInfoService.url = "drv/drvTradeEntryDetails.action?method=resetSsiInfo";
        	else if(this.mode == 'amend')
        		resetSsiInfoService.url = "drv/drvTradeAmendDetails.action?method=resetSsiInfo";
        	else
        		resetSsiInfoService.url = "drv/drvTradeCancelDetails.action?method=resetSsiInfo";
	    	
        	resetSsiInfoService.send();
	    }
	    
	   /**
	    * This method works as the result handler of the Submit Query Http Services.
	    * 
	    */
	    public function ResetSsiInfoResult(event:ResultEvent):void {
	        this.settlementMode.text = "";
	    	this.ourBankStr.text = "";
	    	this.ourSettleAccountStr.text= "";
	    	this.instructionReqdStr.text = "";
	    	this.autoTransmissionReqdStr.text = ""; 
	    	this.bankPkStr.text = "";
	    	this.settlementAcPkStr.text = "";    
	    } 
	     
	    private function selectSsi():void {
	    	var ssiRulePopUp:SsiPopUp
                   = SsiPopUp(PopUpManager.createPopUp( UIComponent(this.parentApplication), SsiPopUp , true));
			
                PopUpManager.centerPopUp(ssiRulePopUp);
                
                var recItem:ArrayCollection = new ArrayCollection();
                
                var securityIdArray:Array = new Array(1);
 		   	  	securityIdArray[0]= this.securityId.instrumentId.text;
 		   	  	recItem.addItem(new HiddenObject("securityId",securityIdArray));
 		   	  	
 		   	  	var tradingCcyArray:Array = new Array(1);
 		   	  	tradingCcyArray[0]= this.tradeCcy.ccyText.text;
 		   	  	recItem.addItem(new HiddenObject("tradingCcy",tradingCcyArray));
 		   	  	
 		   	  	var cpAccArray:Array = new Array(1);
 		   	  	cpAccArray[0]= this.brkAccountNo.accountNo.text;
 		   	  	recItem.addItem(new HiddenObject("cpAccountNo",cpAccArray));
 		   	  	
                var fundAccArray:Array = new Array(1);
 		   	  	fundAccArray[0]= this.fundAccountNo.accountNo.text;
 		   	  	recItem.addItem(new HiddenObject("inventoryAccountNo",fundAccArray));
 		   	  	
 		   	  	ssiRulePopUp.showCloseButton=true; 		   	  	
    	       
    	       ssiRulePopUp.receiveCtxItems = recItem;
    	       
    	       ssiRulePopUp.retSettlementMode = settlementMode;
    	       ssiRulePopUp.retOurBankStr = ourBankStr;
    	       ssiRulePopUp.retOurSettleAccountStr = ourSettleAccountStr;
    	       ssiRulePopUp.retInstructionReqdStr = instructionReqdStr;
    	       ssiRulePopUp.retAutoTransmissionReqdStr = autoTransmissionReqdStr;
    	       ssiRulePopUp.retSettlementAcPkStr = settlementAcPkStr;
    	       ssiRulePopUp.retBankPkStr = bankPkStr;
    	       
    	       ssiRulePopUp.initSsiInfoPopup();
	    }  
	    
	    /**
	      * This is the method to pass the Collection of data items
	      * through the context to the account popup. This will be implemented as per specifdic  
	      * requriment. 
	      */
	    private function populateContext():ArrayCollection {
	        //pass the context data to the popup
	        var myContextList:ArrayCollection = new ArrayCollection(); 
	      
	        //passing account type
	        var acTypeArray:Array = new Array(1);
	            acTypeArray[0]="T|B";            
	        myContextList.addItem(new HiddenObject("invActTypeContext",acTypeArray));  
	        
	        //passing counter party type                
	        var cpTypeArray:Array = new Array(1);
	            cpTypeArray[0]="INTERNAL";
	            //cpTypeArray[1]="CLIENT";
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
	    private function populateInvActContext():ArrayCollection {
	        //pass the context data to the popup
	        var myContextList:ArrayCollection = new ArrayCollection(); 
	      
	        //passing account type
	        var acTypeArray:Array = new Array(1);
	            acTypeArray[0]="T|B";
	            
	        myContextList.addItem(new HiddenObject("invActTypeContext",acTypeArray));
	        
	        //passing counter party type                
	        var cpTypeArray:Array = new Array(1);
	            cpTypeArray[0]="BROKER";
	            
	        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
	        return myContextList;
	    }
	    
	    private function reCalculateAmounts():void{
	    	var req : Object = new Object();
	    	var rndNo:Number = Math.random(); 
	    	req = populateRequestParams();
            reCalculateAmountService.request = req;
            var validateModel:Object={
                            drvTradeEntry:{                                
                                securityId:this.securityId.instrumentId.text,
								openClosePosition:this.openClosePosition.selectedItem != null ? this.openClosePosition.selectedItem.value : "",
								tradeDate:this.tradeDate.text,
								valueDate:this.valueDate.text,
								fundAccountNo:this.fundAccountNo.accountNo.text,
								exeBrkAccountNo:this.exeBrkAccountNo.accountNo.text,
								brkAccountNo:this.brkAccountNo.accountNo.text,
								price:this.price.text,
								quantity:this.quantity.text
                            }
                           };
            var drvTrdEntryValidator:DrvTradeValidator = new DrvTradeValidator();
			drvTrdEntryValidator.source = validateModel;
			drvTrdEntryValidator.property = "drvTradeEntry";
			var validationResult:ValidationResultEvent = drvTrdEntryValidator.validate();
			
			if(validationResult.type==ValidationResultEvent.INVALID){
	            var errorMsg:String = validationResult.message;
	            XenosAlert.error(errorMsg);
	        }else{
	        	
	        	if(this.mode == 'entry')
	        		reCalculateAmountService.url = "drv/drvTradeEntryDetails.action?method=doReCalculateAmounts&rnd=" + rndNo;
	        	else if(this.mode == 'amend')
	        		reCalculateAmountService.url = "drv/drvTradeAmendDetails.action?method=doReCalculateAmounts&rnd=" + rndNo;
	        	else
	        		reCalculateAmountService.url = "drv/drvTradeCancelDetails.action?method=doReCalculateAmounts&rnd=" + rndNo;
	        	
            	reCalculateAmountService.send(); 
	        }
	    }
	    
	    private function reCalculateAmountResultHandler(event:ResultEvent):void{

	    	var rs:XML = XML(event.result);
			if (null != event) {
				 if(rs.child("tradeVo").length()>0) {
					errPage.clearError(event);
					tradeVoAttbList = new ArrayCollection();
					try {
					    for each ( var rec:XML in rs.tradeVo) {
					    	rec.isVisible = true;
					    	for each ( var rec1:XML in rs.tradeVo.otherAttributes) {
						    	rec1.isVisible = true;
			 				    for each ( var rec2:XML in rs.tradeVo.otherAttributes.entry) {
							    	rec2.isVisible = true;
				 				    tradeVoAttbList.addItem(rec2);
							    }
						    }
					    }
					    this.tradeCcy.ccyText.text =  getVoAttbValue(tradeVoAttbList,'tradingCcy');
					 	this.exchangeRate.text = getVoAttbValue(tradeVoAttbList,'exchangeRate');
					 	this.exposure.text = getVoAttbValue(tradeVoAttbList,'principalAmount');
					 	this.exposureInIssueCcy.text = getVoAttbValue(tradeVoAttbList,'principalAmountInIssueCcy');
					 	this.netAmount.text = getVoAttbValue(tradeVoAttbList,'netAmount');
					}catch(e:Error){
					    //XenosAlert.error(e.toString() + e.message);
					    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				    }
	    		} else if(rs.child("Errors").length()>0) {
	                //some error found
				 	//countryCodeSummaryResult.removeAll(); // clear previous data if any as there is no result now.
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
	                //populate the error info list 			 	
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	errPage.showError(errorInfoList);//Display the error
				 } else {
				 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				 	errPage.removeError(); //clears the errors if any
				 }
	        } 	
	    }
	    
	    
	    
	    
	    
	    
	    
	    
	         