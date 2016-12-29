
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.controls.XenosEntry;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.smr.validator.SecurityRegistrationEntryValidator;
 
 import flash.events.Event;
 
 import mx.collections.ArrayCollection;
 import mx.controls.Alert;
 import mx.controls.ComboBox;
 import mx.events.CloseEvent;
 import mx.events.DropdownEvent;
 import mx.events.ListEvent;
 import mx.events.ValidationResultEvent;
 import mx.rpc.events.ResultEvent;
 import mx.utils.StringUtil;
 
// ActionScript file for Security Registration Entry
[Bindable]private var mode : String = "securityentry";

[Bindable]private var  rowNoStr : String = XenosStringUtils.EMPTY_STR; 

[Bindable]private var  bbUniqueIdStr : String = XenosStringUtils.EMPTY_STR; 
[Bindable]private var  isNew : String = XenosStringUtils.EMPTY_STR; 
private var keylist:ArrayCollection = new ArrayCollection();
[Bindable]
private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
[Bindable]public var queryResult:XML = new XML();
[Bindable]private var marketTypeValues:ArrayCollection;
[Bindable]public var codeTypeList:ArrayCollection;
[Bindable]private var listedMarkets:ArrayCollection;
[Bindable]private var couponTypeValues:ArrayCollection;
[Bindable]private var couponInfoSummaryResult:ArrayCollection = new ArrayCollection();
[Bindable]private var instrumentIdList:ArrayCollection = new ArrayCollection();
private var validMarket:Boolean = true;
private var bbInstrumentTree:XMLList = app.cachedItems.bbInstrumentTree;
[Bindable]public var treeXml:XML = new XML(bbInstrumentTree.toString());
private var parentNode:String = XenosStringUtils.EMPTY_STR;
private var hiddenDiscountCouponType:int;
private var hiddenFloatingFixFlag:int;
[Bindable]public var memoSummaryResult:ArrayCollection;
[Bindable]public var memoValueList:ArrayCollection;
[Bindable]private var editedMemoList:XML = new XML();
[Bindable]private var optionTypeValues:ArrayCollection=null;
[Bindable]private var callPutFlagValues:ArrayCollection=null;
[Bindable]public var investmentSectorList:ArrayCollection;
[Bindable]public var mutualFundCategoryList:ArrayCollection;
[Bindable]public var investmentBondCategoryList:ArrayCollection;
[Bindable]public var euroYenBondFlagList:ArrayCollection;
[Bindable]private var  investmentSectorDisp : String = XenosStringUtils.EMPTY_STR;
[Bindable]private var  investBondCategoryDisp : String = XenosStringUtils.EMPTY_STR;
[Bindable]private var  mutualFundCategoryDisp : String = XenosStringUtils.EMPTY_STR;
[Bindable]private var  euroYenBondFlagDisp : String = XenosStringUtils.EMPTY_STR; 
public function loadAll():void{
	parseUrlString();
    super.setXenosEntryControl(new XenosEntry());
    if(this.mode == 'securityentry'){
         this.dispatchEvent(new Event('entryInit'));
    }
}

/**
 * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
 * 
 */
 public function parseUrlString():void {
 	 try {
 	 		parentNode = XenosStringUtils.EMPTY_STR;
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
                    }else if(tempA[0] == "rowNum"){
                        this.rowNoStr = tempA[1];
                    }else if(tempA[0] == "bbUniqueId"){
                        this.bbUniqueIdStr = tempA[1];
                    }else if(tempA[0] == "isNew"){
                        this.isNew = tempA[1];
                    }    
                }                    	
            }else{
            	mode = "securityentry";
            }                 

        } catch (e:Error) {
            trace(e);
        }               
 } 
 
 override public function preEntryInit():void{ 
 	var rndNo:Number= Math.random(); 
 	super.getInitHttpService().url = "smr/securityRegistrationEntryDispatch.action?rnd=" + rndNo; 
 	var reqObj:Object = new Object();
 //	trace("isNew : "+isNew);
 	if(isNew == 'true'){
 		reqObj.method = "doAddNew";
 	}else{
 		reqObj.method = "doAddFromBB";
	 	reqObj.bbUniqueId = bbUniqueIdStr;
	 	reqObj.rowNum = rowNoStr;
 	}	 
    super.getInitHttpService().request  = reqObj;
 }

  private function addCommonKeys():void{        	
    	keylist = new ArrayCollection();
    	keylist.addItem("securityEntry");
    	//keylist.addItem("accruedInterestCalcTypeValues.item");
    	keylist.addItem("accruedInterestCalcTypeValuesWrapper.accruedInterestCalcTypeValues");
    	keylist.addItem("floatingFixFlagValues.item");
    	keylist.addItem("discountCouponTypeValue.item");
    	keylist.addItem("couponTypeValues.item");
    	keylist.addItem("bbInstrumentCodeTypes.item");
    	keylist.addItem("instrumentCrossRefsWrapper.instrumentCrossRefs"); 
 		keylist.addItem("memoValuesWrapper.memoValues"); 
 		keylist.addItem("memosWrapper.memos"); 
 		keylist.addItem("optionTypeValues.item"); 
 		keylist.addItem("callPutFlagValues.item");
 		keylist.addItem("investmentSectorList.item");
 		keylist.addItem("mutualFundCategoryList.item");
 		keylist.addItem("investmentBondCategoryList.item");
 		keylist.addItem("euroYenBondFlagList.item");
 		keylist.addItem("investmentSectorDisp");	 
 		keylist.addItem("investBondCategoryDisp");	 
 		keylist.addItem("mutualFundCategoryDisp");
 		keylist.addItem("euroYenBondFlagDisp");	 	 
   }
 override public function preEntryResultInit():Object{
	addCommonKeys(); 
	return keylist;
 }
 override public function postEntryResultInit(mapObj:Object): void{
    
    var initcol:ArrayCollection = new ArrayCollection();
    var defaultFinalCpnStr :String = "SHORT";
    var index:int=0;
	var selindex:int=0;
	var found:Boolean = false;
	var namSecurityType:String = XenosStringUtils.EMPTY_STR;
	
	hiddenFloatingFixFlag = 0;
	hiddenDiscountCouponType =0;
    app.submitButtonInstance = submit;
    //trace("mapObj :"+mapObj[keylist.getItemAt(0)]);
    queryResult = new XML(mapObj[keylist.getItemAt(0)]) ;
    //trace("instrumentName: " + queryResult.instrumentType);
    namSecurityType = queryResult.namSecurityType;	
    /* instrumentType.itemCombo.text = 
  			getInstrumentType(bbInstrumentTree, 
  					queryResult.instrumentType);
    				 */
  	//trace("tree :"+bbInstrumentTree.toXMLString());
    //	trace("text :"+instrumentType.itemCombo.text);
    var memoArray :ArrayCollection= mapObj[keylist.getItemAt(8)] as ArrayCollection;
    //trace(memoArray);
    //Determine the parent NOde
    if(isNew =='false'){
    	instrumentType.itemCombo.text = 
  			getInstrumentType(bbInstrumentTree, 
  					queryResult.instrumentType, namSecurityType);
    				
    	parentNode = getParentNode(instrumentType.itemCombo.text);
    }
    //trace("parentNode : "+parentNode);
    var accIntCalTypeCol:ArrayCollection = new ArrayCollection();
    //Acc Int Calc Types
    // initcol.addItem({label:" ", value: " "});
     initcol.addItem("");
     accIntCalTypeCol.addItem(" ");
    for each(var item:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
		initcol.addItem(item);
		accIntCalTypeCol.addItem(item);
	}
	this.accIntCalType.dataProvider = initcol;
	//trace("accruedInterestConv :" + queryResult.accruedInterestConv);
	//if(isNew=='false' && getParentNode(instrumentType.itemCombo.text) == "FI"){
	
	if(isNew=='false' && parentNode == "FI" && XenosStringUtils.equals(queryResult.discountCouponType,"COUPON")){
		var accIntCalc:String = queryResult.accruedInterestConv;
		if(XenosStringUtils.isBlank(accIntCalc)){
			accIntCalc="DEFAULT";
		}
		//trace("accIntCalc :"+accIntCalc);
		this.accIntCalType.selectedIndex =getIndexOfLabelValueBean(accIntCalTypeCol,accIntCalc) ;
	}else{
		this.accIntCalType.selectedIndex = 0;
	}
	
	//Rate Types
	 initcol=new ArrayCollection();
	initcol.addItem({label:" ", value: " "});
	selindex=0;
	index=0;
	for each(var item:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
		initcol.addItem(item);
		if(isNew == 'false'){
			if(XenosStringUtils.equals(item.value,queryResult.floatingFixFlag)){
				selindex = index;
				found = true;
			} 
			index++;
		}
	}
	//trace("found Rate Type "+found+":"+(found==true));
	hiddenFloatingFixFlag = selindex+1;
	this.rateType.dataProvider = initcol;
	this.rateType.selectedIndex = (found == true)? hiddenFloatingFixFlag:0;
	
	//Bond Type
    initcol=new ArrayCollection();
	initcol.addItem({label:" ", value: " "});
	selindex=0;
	index=0;
	found = false;
	for each(var item:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
		initcol.addItem(item);
		if(isNew == 'false'){
			//trace("add/update " + item.value);
			if(XenosStringUtils.equals(item.value,queryResult.discountCouponType)){
				selindex = index;
				found = true;
			} 
			index++;
		}
		//trace("selindex :"+selindex);
	}
	//trace("found bond Type "+found+":"+(found==true));
	hiddenDiscountCouponType=selindex+1;
	this.bondType.dataProvider = initcol;
	this.bondType.selectedIndex = (found == true)? (hiddenDiscountCouponType):0;
	
	//Initial and Final COupon Types
	couponTypeValues=new ArrayCollection();
	couponTypeValues.addItem({label:" ", value: " "});
	index=0;
	selindex=0;
//	trace("default cpn type :"+defaultFinalCpnStr);
	for each(var item:Object in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
		var cpnType:String = queryResult.finalCouponType;
		couponTypeValues.addItem(item);
		if(XenosStringUtils.isBlank(cpnType)) {
			selindex = 1;
		} else {
		 	if(XenosStringUtils.equals(item.value,cpnType)){
				selindex = index;
			} 
			index++;
		}
	}
	
	//this.initialCouponType.dataProvider = initcol;
	//this.initialCouponType.selectedIndex =0;
	//this.finalcpntype.selectedIndex = 0;
	if(XenosStringUtils.equals(queryResult.discountCouponType, "DISCOUNT")) {
		this.finalcpntype.selectedIndex = 0; 
	} else {
		this.finalcpntype.selectedIndex = (selindex+1); 
	}
    //trace("queryResult :"+queryResult);
    
    //Instrument Code Types
    codeTypeList=new ArrayCollection();
	codeTypeList.addItem({label:" ", value: " "});
	for each(var item:Object in (mapObj[keylist.getItemAt(5)] as ArrayCollection)){
		codeTypeList.addItem(item);
	}
	this.codetype.dataProvider = codeTypeList;
	this.codetype.selectedIndex =0;
  
  	//Instrument Cross Refs
  	instrumentIdList = new ArrayCollection();
  	instrumentIdList.removeAll(); 
  	for each (var rec1:Object in (mapObj[keylist.getItemAt(6)] as ArrayCollection)) {
		rec1.isDeleteEnabled = true;					
		instrumentIdList.addItem(rec1);
	 }
	instrumentIdList.refresh();
	
  	//Populate the fields
  	issuecntry.countryCode.text = queryResult.cntryOfIncorporation;
  	cntrydomicile.countryCode.text = queryResult.countryOfDomicile;
  	issueccy.ccyText.text= queryResult.crncy;
  	dvdccy.ccyText.text = queryResult.dvdCrncy;
  	redempccy.ccyText.text = queryResult.redempCrncy;
  	cpnccy.ccyText.text = queryResult.cpnCrncy; 
  	listedmarket.finInstCode.text = queryResult.listedMarket;
  	investmentCountryCode.countryCode.text = queryResult.investCountryCode;
  	
  	
  	if(isNew == 'false'){
  		//resetAllClassNames();
  		if(parentNode == 'FI'){
  			changeClassNameForBond(queryResult.discountCouponType);
  			changeClassNameForRate(queryResult.floatingFixFlag);
  		}else if(parentNode=='FUT' || parentNode=='OPT'){
  			changeClassNameForDrv(parentNode);
  		}
  	}
  	instrumentType.itemCombo.addEventListener(DropdownEvent.CLOSE, instrumentTypeChangeHandler);
  
  	//Memo List
  	memoValueList = new ArrayCollection();
  	memoValueList.addItem(" ");
	for each(var xmlObj:Object in (mapObj[keylist.getItemAt(7)] as ArrayCollection)){
		memoValueList.addItem(xmlObj);
	}
	memoData.selectedIndex=0;
	memoSummaryResult=new ArrayCollection();
	for each(var xmlObj:Object in (mapObj[keylist.getItemAt(8)] as ArrayCollection)){
		memoSummaryResult.addItem(xmlObj);
	}
	//Option List	
	optionTypeValues = new ArrayCollection();
	optionTypeValues.addItem({label: "" , value : ""});
	for each(var xmlObj1:Object in (mapObj[keylist.getItemAt(9)] as ArrayCollection)){
		optionTypeValues.addItem(xmlObj1);
	}	
	//Call Put Flag
	callPutFlagValues = new ArrayCollection();
	callPutFlagValues.addItem({label: "" , value : ""});
	for each(var xmlObj2:Object in (mapObj[keylist.getItemAt(10)] as ArrayCollection)){
		callPutFlagValues.addItem(xmlObj2);
	}
	//Investment sector list
	investmentSectorList = new ArrayCollection();
	investmentSectorList.addItem({label: "" , value : ""});
	for each(var xmlObj3:Object in (mapObj[keylist.getItemAt(11)] as ArrayCollection)){
		investmentSectorList.addItem(xmlObj3);
	}	
	//mutual Fund category List
 	mutualFundCategoryList = new ArrayCollection();
	mutualFundCategoryList.addItem({label: "" , value : ""});
	for each(var xmlObj4:Object in (mapObj[keylist.getItemAt(12)] as ArrayCollection)){
		mutualFundCategoryList.addItem(xmlObj4);
	}
	//Investment Bond category 	
	investmentBondCategoryList = new ArrayCollection();
	investmentBondCategoryList.addItem({label: "" , value : ""});
	for each(var xmlObj5:Object in (mapObj[keylist.getItemAt(13)] as ArrayCollection)){
		investmentBondCategoryList.addItem(xmlObj5);
	}
	//Euro yen Bond flag
 	euroYenBondFlagList = new ArrayCollection();
	euroYenBondFlagList.addItem({label: "" , value : ""});
	for each(var xmlObj6:Object in (mapObj[keylist.getItemAt(14)] as ArrayCollection)){
		euroYenBondFlagList.addItem(xmlObj6);
	}
 }

 private function resetAllClassNames():void{
 	issueDateLbl.styleName = "";
	maturityDateLbl.styleName = "";
	redmpnCcyLbl.styleName = "";
	paymentFreqLbl.styleName = "";
	cpnCcyLbl.styleName = "";
	acrIssueDtLbl.styleName = "";
	accIntCalTypeLbl.styleName = "";
	firstPaymentDtLbl.styleName = "";
	//initCpnTypeLbl.styleName = "";
	finalCpnTypeLbl.styleName = "";
	rateTypeLbl.styleName = "";
	
	fixedCouponRateLbl.styleName = "";
 	effDtFromLbl.styleName = "";
 	recordDtLbl.styleName = "";
 	rateLbl.styleName = "";
 		
	drvstartdtLbl.styleName = "";
 	ticksizeLbl.styleName = "";
 	drvexpdtLbl.styleName = "";
 	drvundrlyingsecLbl.styleName = "";
 	drvcontractdtLbl.styleName = "";
 	optId.includeInLayout=false;
 	optId.visible=false;
 }	
 private function changeClassNameForDrv(parent : String):void{
 	drvstartdtLbl.styleName = "ReqdLabel";
 	ticksizeLbl.styleName = "ReqdLabel";
 	drvexpdtLbl.styleName = "ReqdLabel"; 	
 	drvcontractdtLbl.styleName = "ReqdLabel";
 	if(parent=='OPT'){
 		optId.includeInLayout=true;
 		optId.visible=true;
 		ticksizeLbl.styleName = "";
 		drvundrlyingsecLbl.styleName = "ReqdLabel";
 		drvcontractdtLbl.styleName = "";
 	}else{
 		optId.includeInLayout=false;
 		optId.visible=false;
 	}
 }
 
 private function changeClassNameForBond(bondType:String):void{
 	
 	//trace("bondType : "+bondType);
 	/* if(XenosStringUtils.isBlank(bondType)){
 		bondType = StringUtil.trim(this.bondType.selectedItem.value);
 	} */
 	if(bondType == 'COUPON'){
 		issueDateLbl.styleName = "ReqdLabel";
		maturityDateLbl.styleName = "ReqdLabel";
		redmpnCcyLbl.styleName = "ReqdLabel";
		paymentFreqLbl.styleName = "ReqdLabel";
		cpnCcyLbl.styleName = "ReqdLabel";
		acrIssueDtLbl.styleName = "ReqdLabel";
		accIntCalTypeLbl.styleName = "ReqdLabel";
		firstPaymentDtLbl.styleName = "ReqdLabel";
		//initCpnTypeLbl.styleName = "ReqdLabel";
		finalCpnTypeLbl.styleName = "ReqdLabel";
		rateTypeLbl.styleName = "ReqdLabel";

 	}else if(bondType == 'DISCOUNT'){
 		issueDateLbl.styleName = "";
		maturityDateLbl.styleName = "";
		redmpnCcyLbl.styleName = "ReqdLabel";
		paymentFreqLbl.styleName = "";
		cpnCcyLbl.styleName = "";
		acrIssueDtLbl.styleName = "";
		accIntCalTypeLbl.styleName = "";
		firstPaymentDtLbl.styleName = "";
		//initCpnTypeLbl.styleName = "";
		finalCpnTypeLbl.styleName = "";
		rateTypeLbl.styleName = "";
 	}else{
 		issueDateLbl.styleName = "";
		maturityDateLbl.styleName = "";
		redmpnCcyLbl.styleName = "";
		paymentFreqLbl.styleName = "";
		cpnCcyLbl.styleName = "";
		acrIssueDtLbl.styleName = "";
		accIntCalTypeLbl.styleName = "";
		firstPaymentDtLbl.styleName = "";
		//initCpnTypeLbl.styleName = "";
		finalCpnTypeLbl.styleName = "";
		rateTypeLbl.styleName = "";
		
 	}
 }
 
 private function changeClassNameForRate(rateType:String):void{
 	
 	var bondTypeStr : String = StringUtil.trim(this.bondType.selectedItem.value);
 	/* if(XenosStringUtils.isBlank(rateType)){
 		rateType = StringUtil.trim(this.rateType.selectedItem.value);
 	} */
 	//trace("rateType : "+rateType+" :bond :"+bondTypeStr);
 	if(bondTypeStr=="COUPON" && rateType == 'FIX'){
 		fixedCouponRateLbl.styleName = "ReqdLabel";
 		effDtFromLbl.styleName = "";
 		recordDtLbl.styleName = "";
 		rateLbl.styleName = "";
 	}else if(bondTypeStr=="COUPON" && rateType == 'FLOAT'){
 		fixedCouponRateLbl.styleName = "";
 		effDtFromLbl.styleName = "ReqdLabel";
 		recordDtLbl.styleName = "";
 		rateLbl.styleName = "ReqdLabel";
 	}else{
 		fixedCouponRateLbl.styleName = "";
 		effDtFromLbl.styleName = "";
 		recordDtLbl.styleName = "";
 		rateLbl.styleName = "";
 	}
 }
 
 public function instrumentTypeChangeHandler(event:DropdownEvent):void{
 	//XenosAlert.info("data chng"+instrumentType.itemCombo.text);
 	var parent:String=getParentNode(instrumentType.itemCombo.text);
 	
 	//XENOSCD-8744 --> XGA-1466
 	if(instrumentType.itemCombo.text == "ST : P-NOTE"){
 		listedmarket.finInstCode.text="";
 	} 	
 	
 	parentNode=parent;
 	resetAllClassNames();
 	if(parent == "FUT" || parent == "OPT"){
 			
 		changeClassNameForDrv(parent);
 	}else if(parent == "FI" || parent == "MM"){
 		var bondTypeStr : String = StringUtil.trim(this.bondType.selectedItem.value);
 		var rateTypeStr : String = StringUtil.trim(this.rateType.selectedItem.value);
 		changeClassNameForBond(bondTypeStr);
 		changeClassNameForRate(rateTypeStr);
 	}
 	
 }
 	
 	
 private function getInstrumentType(tree:XMLList, instrumentName:String, namSecurityType:String='*'):String {
 	
 	//trace("namSecurityType :"+namSecurityType+tree.descendants(namSecurityType).length());
 	//trace("instrumentName :"+instrumentName);
 	var instrumentType:String = null;
 	if (instrumentName == null || instrumentName == "") {
 		return "";
 	}
 	var treeList :XMLList = tree.descendants(namSecurityType);
 	
 	for each (var xml1:XML in treeList) {
 		//trace(xml1.toXMLString()+" : "+xml1.descendants().length());
 		for each (var xml:XML in xml1.descendants()) {
 			//trace("child :"+xml.toXMLString());
			if (xml.attribute("bbvalue").toString() == instrumentName) {
				instrumentType = xml.attribute("value").toString();
				break;
			}
		}
 	} 
 	if(instrumentType == null && XenosStringUtils.equals("EQ",namSecurityType)){
 		//trace("HERE........");
 		for each (var xml1:XML in tree.descendants("FUND")) {
 			//trace(xml1.toXMLString()+" : "+xml1.descendants().length());
 			for each (var xml:XML in xml1.descendants()) {
 				//trace("child :"+xml.toXMLString());
				if (xml.attribute("bbvalue").toString() == instrumentName) {
					instrumentType = xml.attribute("value").toString();
					break;
				}
			}
 		}
 	}
 	//trace("instrumentType: " + instrumentType);
 	//trace("bbInstrumentTree" + bbInstrumentTree);
 	if (instrumentType == null) {
 		bbInstrumentTree = new XMLList(new XML(tree).appendChild( 
 			'<N/A label="N/A : ' + instrumentName + '" value="N/A : ' + instrumentName + '" name="' + instrumentName + '" bbvalue="'+ instrumentName + '" />'));
 		instrumentType = "N/A : " + instrumentName;
 	}
 	//trace("bbInstrumentTree" + bbInstrumentTree);
 	treeXml = new XML(bbInstrumentTree.toString());
 	
 	return instrumentType;
 } 
 /**
 * It calculates the Instrument Type based on the value of the node passed.
 * and stores the parent instrument type.
 */
 public function getParentNode(valueStr:String):String{
 		//bbInstrumentTree.descendants().(@value === valueStr)
 		//trace("value :"+valueStr+" : "+	bbInstrumentTree.descendants().length());
 		if(XenosStringUtils.isBlank(valueStr)){
 			return null;
 		}
 		var parentXml :XML = null;
 		for each(var xmlChild :XML in bbInstrumentTree.descendants()){
 			//trace(xmlChild.toXMLString() +" : "+String(xmlChild.@value).toUpperCase());
 			if(String(xmlChild.@value).toUpperCase() == valueStr.toUpperCase()){
 				parentXml = xmlChild.parent();
 				//("parentXml :"+parentXml.name().toString());
 				break;
 			}
 		}
 		if(parentXml == null){
 			XenosAlert.error("Please select a valid value from the Instrument Type tree.");
 			//trace("do we return..");
 			return null;
 		}else{
 			return parentXml.name().toString();
 		}
 }
 
 override public function preEntryResultHandler():Object
 {
 	addCommonKeys();
 	return keylist;
 }
 override public function preEntry():void{
 	
 	//var requestObj:Object = populateRequestParams();
 	if(!validMarket)
 		super.getSaveHttpService().request["securityEntry.listedMarket"]="OTHERS";
 	validMarket = true;
 	super.getSaveHttpService().url = "smr/securityRegistrationEntryDispatch.action?method=doAddConfirm";
 	super.getSaveHttpService().method="POST";  
 	//super.getSaveHttpService().request  = requestObj;
 }
 
 private function doMarketValidation():void{
 	var requestObj:Object = populateRequestParams();
 	validateMarketService.url = "smr/securityRegistrationEntryDispatch.action?method=doValidateMarket";
 	validateMarketService.request = requestObj;
 	doValidateAndSubmit();
 }
 
 private function validateMarketServiceResult(event:ResultEvent){
 	var rs:XML = XML(event.result);
 	if(rs.child("Errors").length()>0) {
 		validMarket = false;
 		XenosAlert.confirm(this.parentApplication.xResourceManager.getKeyValue('smr.market.msg.error.invalid.cofirmation'),confirmHandler);	
 	}else{
 		this.dispatchEvent(new Event('entrySave'));
 	}
 }
 
 private function confirmHandler(event:CloseEvent):void{
 	if(event.detail == Alert.YES){
 		this.dispatchEvent(new Event('entrySave'));
 	}else if(event.detail == Alert.NO){
 		validMarket = true;
 		return;
 	}
 }
 
 private function populateRequestParams():Object{
 	
 	var requestObj :Object = new Object();
// 	trace("redemp :" +redempccy.text);
 	//requestObj["securityEntry.securityName"] = sname.text;
 	//requestObj["securityEntry.securityDescription"] = securitydesc.text;
 	var s:String = instrumentType.itemCombo.text;
 	if(!XenosStringUtils.isBlank(s)){
 		var params:Array = s.split(":"); 
 		if(params.length !=2){
 			//trace("params length :"+params.length);
    		//XenosAlert.error(Application.application.xResourceManager.getKeyValue('smr.error.invalid.instrumentType'));
    	}else{
    		
	    	 if(XenosStringUtils.isBlank(parentNode)){
	    	 //	trace("parentNode :"+parentNode);
	    	//	XenosAlert.error(Application.application.xResourceManager.getKeyValue('smr.error.invalid.instrumentType'));
	    	  }else{
	 			requestObj["securityEntry.instrumentType"] = StringUtil.trim(params[1].toString());
	 			requestObj["securityEntry.actualSecurityType"] = StringUtil.trim(params[0].toString());
	    	 }
    	}
 	}
 	requestObj["securityEntry.officialName"] = officialName.text;
 	//requestObj["securityEntry.securityType"] = instrumenttype.text;
 	//requestObj["securityEntry.issuerSubgroup"] = issuersubgroup.text;
 	requestObj["securityEntry.cntryOfIncorporation"] = issuecntry.countryCode.text;
 	//requestObj["securityEntry.country"] = country.text ;
 	requestObj["securityEntry.crncy"] = issueccy.ccyText.text;
 	//requestObj["securityEntry.ticker"] = ticker.text ;
 	//requestObj["securityEntry.tickerAndExchangeCode"] = tickerexchngcode.text;
 	//requestObj["securityEntry.exchCode"] = exchangecode.text;
 	//requestObj["securityEntry.idMicPrimExch"] = isoMarket.text;
 	requestObj["securityEntry.listedMarket"] = listedmarket.finInstCode.text;
 	requestObj["securityEntry.listedMarketCr"] = listedmarket.finInstCode.text;
 	requestObj["securityEntry.issueDate"] = issuedate.text;
 	requestObj["securityEntry.intAccDtStr"] = accrissuedate.text ;
 	requestObj["securityEntry.shortName"] = shortname.text;
  	requestObj["securityEntry.currentShareOutstandingStr"] = currentshareoutstanding.text;
 	requestObj["securityEntry.lastPriceStr"] = lastprice.text; 
 	requestObj["securityEntry.eqyDvdSh12mStr"] = dividend.text;
 	requestObj["securityEntry.dvdCrncy"] = dvdccy.ccyText.text;
 	requestObj["securityEntry.votingRightsStr"] = votingrights.text ;
 	requestObj["securityEntry.pxRoundLotSizeStr"] = roundlotsize.text;
 	requestObj["securityEntry.dvdExDtStr"] = dvdexdate.text;
 	requestObj["securityEntry.curMktCapitalizationStr"] = mrktcapitalization.text;
 	requestObj["securityEntry.eqyFreeFloatPctStr"] = freefloatperct.text;
 	requestObj["securityEntry.pxVolumeStr"] = volume.text;
 	requestObj["securityEntry.maturityDateStr"] = maturitydate.text;
 	//requestObj["securityEntry.couponRateStr"] = couponrate.text ;
 	requestObj["securityEntry.nxtCpnDtStr"] = nxtcpndate.text;
 	requestObj["securityEntry.amtIssuedStr"] = amtissued.text; 
 	requestObj["securityEntry.amtOutstandingStr"] = amtoutstanding.text ; 
 	requestObj["securityEntry.dayCntStr"] = daybasis.text;
 	requestObj["securityEntry.firstCpnDtStr"] = firstpaymentdt.text;
 	requestObj["securityEntry.prevCpnDtStr"] = prevpaymentdt.text;
 	requestObj["securityEntry.cpnFreqStr"] = paymentfrequency.text;
 	requestObj["securityEntry.cpnTyp"] = accrualtypecode.text;
 	requestObj["securityEntry.cpnCrncy"] = cpnccy.ccyText.text;
 	requestObj["securityEntry.countryOfDomicile"] = cntrydomicile.countryCode.text;
 	//requestObj["securityEntry.calcTypDes"] = calctype.text ;
 	//requestObj["securityEntry.calcTypDesEuro"] = calctype.text ;
 	requestObj["securityEntry.issuePxStr"] = issueprice.text;
 	requestObj["securityEntry.redempValStr"] = redemptionvalue.text;
 	requestObj["securityEntry.redempCrncy"] = redempccy.ccyText.text;
 	requestObj["securityEntry.minTradingUnitStr"] = mintradingunit.text;
 	//requestObj["securityEntry.eqListedMkt"] = listedmarket.text;
 	requestObj["securityEntry.listingDateStr"] = listeddate.text;
 	requestObj["securityEntry.floatingFixFlag"] = StringUtil.trim(this.rateType.selectedItem.value);
 	requestObj["securityEntry.discountCouponType"] = StringUtil.trim(this.bondType.selectedItem.value);
 	requestObj["securityEntry.effectiveStartDateStr"] = effdatefrom.text;
 	requestObj["securityEntry.recordDaysStr"] = recordDays.text;
 	requestObj["securityEntry.recordDateStr"] = recordDate.text;
 	//requestObj["securityEntry.curCpnRateStr"] = curcpnrate.text;
 	//requestObj["securityEntry.initialCouponType"] = StringUtil.trim(this.initialCouponType.selectedItem.value);
 	requestObj["securityEntry.initialCouponType"] = XenosStringUtils.EMPTY_STR;
 	var finalCpnType :String =StringUtil.trim(this.finalcpntype.selectedItem.value);
 	requestObj["securityEntry.finalCouponType"] = StringUtil.trim(this.finalcpntype.selectedItem.value);
 	if(XenosStringUtils.equals("LONG",finalCpnType)){
 		requestObj["securityEntry.finalCouponDateStr"] = XenosStringUtils.EMPTY_STR;
 	}else{
 		requestObj["securityEntry.finalCouponDateStr"] = finalcpndate.text;
 	}
 	requestObj["securityEntry.accruedInterestConv"] = StringUtil.trim(this.accIntCalType.selectedItem.toString()); 
 	requestObj["securityEntry.sector"] = indSector.text;
 	requestObj["securityEntry.industryGroup"] = indGroup.text;
 	requestObj["securityEntry.industry"] = industry.text;
 	requestObj["securityEntry.subIndustry"] = subindustry.text;
 	requestObj["securityEntry.contractSizeStr"] = contractSize.text;
 	//if(StringUtil.trim(this.rateType.selectedItem.value) == "FIX"){
 		requestObj["securityEntry.couponRateStr"] = fixcouponrate.text ;
 	//}else if(StringUtil.trim(this.rateType.selectedItem.value) == "FLOAT"){
 		requestObj["securityEntry.curCpnRateStr"] = couponrate.text ;
 	//}
 	if(!XenosStringUtils.isBlank(altShortName.text) && !XenosStringUtils.isBlank(altOfficialName.text)){
 		requestObj["securityEntry.altCharsetCode"] = altLanguageCode.text;
 		requestObj["securityEntry.altShortName"] = altShortName.text;
 		requestObj["securityEntry.altOfficialName"] = altOfficialName.text;
 	}
 	requestObj["securityEntry.startDateStr"] = drvstartdate.text;
 	requestObj["securityEntry.expiryDateStr"] = drvexpdate.text;
 	requestObj["securityEntry.tickSizeStr"] = ticksize.text;
 	requestObj["securityEntry.contractDate"] = contractdate.text;
 	requestObj["securityEntry.underlyingInstrumentCode"] = underlyingInstrumentCode.instrumentId.text;
 	requestObj['securityEntry.callPutFlag'] = this.callPutFlag.selectedItem != null ? this.callPutFlag.selectedItem.value : "";
	requestObj['securityEntry.optionType'] = this.optionType.selectedItem != null ? this.optionType.selectedItem.value : "";
	requestObj['securityEntry.strikePriceStr'] = this.strikePriceStr.text;
	requestObj["securityEntry.investCountryCode"] = investmentCountryCode.countryCode.text;
	requestObj["securityEntry.investmentSector"] = StringUtil.trim(this.investmentSector.selectedItem.value);
	requestObj["securityEntry.mutualFundCategory"] = StringUtil.trim(this.mutualFundCategory.selectedItem.value);
	requestObj["securityEntry.investBondCategory"] = StringUtil.trim(this.investmentBondCategory.selectedItem.value);
	requestObj["securityEntry.euroYenBondFlag"] = StringUtil.trim(this.euroYenBondFlag.selectedItem.value);
	trace("strike :"+this.strikePriceStr.text);
	
 	return requestObj;
 }
 private function doValidateAndSubmit():void{
    var validateModel:Object={
        	securityEntry:{
        		instrumentType:this.instrumentType.itemCombo.text,
        		issueccy:this.issueccy.ccyText.text,
        		contractSize:this.contractSize.text,
        		shortname:this.shortname.text,
        		officialname:this.officialName.text,
        		countrycode:this.issuecntry.countryCode.text,
        		investmentCountryCode:this.investmentCountryCode.countryCode.text,
        		countrybbdom:this.cntrydomicile.countryCode.text,
        		altShortname:this.altShortName.text,
        		altOfficialName:this.altOfficialName.text,
        		parentInstrumentType:parentNode,
        		drvStartDt:this.drvstartdate.text,
        		drvExpDt:this.drvexpdate.text,
        		drvTickSize:this.ticksize.text,
        		drvContractDt:this.contractdate.text,
        		drvUnderlyingSecurity:this.underlyingInstrumentCode.instrumentId.text,
        		drvStrikePrice:this.strikePriceStr.text,
        		drvOptFlag:this.optionType.selectedItem != null ? this.optionType.selectedItem.value : "",
        		drvCallPutFlag:this.callPutFlag.selectedItem != null ? this.callPutFlag.selectedItem.value : ""
        		       		
        	}
    };
    
    var secRegEntryValidator:SecurityRegistrationEntryValidator =new SecurityRegistrationEntryValidator();
        secRegEntryValidator.source=validateModel;
        secRegEntryValidator.property="securityEntry";
    var validationResult:ValidationResultEvent =secRegEntryValidator.validate();
    if(validationResult.type==ValidationResultEvent.INVALID){
        var errorMsg:String=validationResult.message;
        XenosAlert.error(errorMsg);
    }else {
    	//if (!XenosStringUtils.isBlank(validateMarketService.request["securityEntry.listedMarket"])) {
        	validateMarketService.send();
     	//}else{
     	//	this.dispatchEvent(new Event('entrySave'));
     	//}
    }  
 }
 override public function postEntryResultHandler(mapObj:Object):void
 {
	commonResult(mapObj);
	/* uConfLabel.includeInLayout = true;
    uConfLabel.visible = true; */
 }
 
 private function commonResult(mapObj:Object):void{
 	if(mapObj!=null){
 		if(mapObj["errorFlag"].toString() == "error"){
 			errPage.showError(mapObj["errorMsg"]);	
 		}else if(mapObj["errorFlag"].toString() == "noError"){
 			errPage.clearError(super.getSaveResultEvent());
 			commonResultPart(mapObj);
			changeCurrentState();
			
			app.submitButtonInstance = uConfSubmit;
			//uConfSubmit.setFocus();
 		}else{
 			errPage.removeError();
 			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
 		}
 	}
 }
 override public function preEntryConfirmResultHandler():Object
 {
    addCommonKeys();    
    return keylist;
 }
 override public function postConfirmEntryResultHandler(mapObj:Object):void
 {    
    	softWarn.removeWarning();
    	submitUserConfResult(mapObj);
    	app.submitButtonInstance = sConfSubmit;
 }
 
 private function submitUserConfResult(mapObj:Object):void{
 	if(mapObj!=null){    
 		if(mapObj["errorFlag"].toString() == "error"){
 			uerrPage.showError(mapObj["errorMsg"]);
 		}else if(mapObj["errorFlag"].toString() == "noError"){
 			uerrPage.clearError(super.getConfResultEvent());
 			this.uConfBack.includeInLayout = false;
            this.uConfBack.visible = false;
            uConfSubmit.includeInLayout = false;
            uConfSubmit.visible= false;
            uConfLabel.includeInLayout = false;
            uConfLabel.visible = false;
            sConfLabel.includeInLayout = true;
            sConfLabel.visible = true;
            sConfSubmit.includeInLayout = true;
            sConfSubmit.visible = true;
 		}else{
                uerrPage.removeError();
                
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('smr.msg.common.info.erroroccurred'));
            }    
 	}
 }
 override public function preEntryConfirm():void
{
	var reqObj :Object = new Object();
	super.getConfHttpService().url = "smr/securityRegistrationEntryDispatch.action?";  
	reqObj.method= "doSave";
    
    super.getConfHttpService().request  =reqObj;
 	super.getConfHttpService().method="POST";
}
override public function doEntrySystemConfirm(e:Event):void
{
	//this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
}
 private function commonResultPart(mapObj:Object):void{
 	queryResult = new XML(mapObj[keylist.getItemAt(0)]) ;  		
	investmentSectorDisp = mapObj[keylist.getItemAt(15)];
	investBondCategoryDisp = mapObj[keylist.getItemAt(16)];
	mutualFundCategoryDisp = mapObj[keylist.getItemAt(17)]; 
	euroYenBondFlagDisp = mapObj[keylist.getItemAt(18)];
	softWarn.showWarning(mapObj["softWarning"]); 
 }
 private function changeCurrentState():void{
 	vstack.selectedChild = confirmView;        
 }
 private function doBack():void{
 	vstack.selectedChild = entryView;
 	uerrPage.removeError();
 	softWarn.removeWarning();
    app.submitButtonInstance = submit;    
 }
 
private function doinstrumentCodeAdd():void{
	if(XenosStringUtils.isBlank(instrumentId.text)){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.instrumentcode'));
	}
	else{
		var reqObj:Object=new Object();
		reqObj.instrumentCodeType=StringUtil.trim(this.codetype.selectedItem.value);
		reqObj.instrumentCodeTypeUI=StringUtil.trim(this.codetype.selectedItem.label);
		reqObj.securityId=instrumentId.text;
		addInstrumentService.url="smr/securityRegistrationEntryDispatch.action?method=addInstrumentCode";
		addInstrumentService.request=reqObj;
		addInstrumentService.send();
	}
}

private function addInstrumentServiceResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	//trace("instrumentCrossRefsWrapper"+rs.toXMLString());
	if (null != event) {
		 if(rs.child("instrumentCrossRefsWrapper").length()>0) {
			errPage.clearError(event);			
            instrumentIdList.removeAll(); 
			try {
				
			    for each ( var rec:XML in rs.instrumentCrossRefsWrapper.instrumentCrossRefs) {
			    	rec.isDeleteEnabled = true;					
				/* 	if(this.mode=="amend" && (rec.instrumentCodeType.toString()==rs.defaultInstrumentCodeType.toString())){
						rec.isDeleteEnabled = false;
					}	 */		    	
 				    instrumentIdList.addItem(rec); 				    
			    }		   
            	instrumentIdList.refresh();
            	
            	/* for(var i:int=0;i<codeTypeList.length;i++){
            		if(rs.defaultInstrumentCodeType.toString()==codeTypeList.getItemAt(i).toString()){
            			codetype.selectedIndex=i;
            			break;
            		}
            	} */
            	
            	instrumentId.text="";
            	codetype.selectedIndex =0;
            	//enterpriseDefault.selected=false;
			}catch(e:Error){			    
			    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    }
		 } else if(rs.child("Errors").length()>0) {
           	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);//Display the error
		 } else {
		 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		 	instrumentIdList.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
}

public function doinstrumentCodeEdit(data:Object):void{
	editInstrumentService.url="smr/securityRegistrationEntryDispatch.action?method=editInstrumentCode";
	var reqObj:Object=new Object();
	reqObj.rowNo=instrumentIdList.getItemIndex(data);
	editInstrumentService.request=reqObj;
	editInstrumentService.send();
}
private function editInstrumentServiceResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if (null != event) {
		 if(rs.child("instrumentCrossRefsWrapper").length()>0) {
			errPage.clearError(event);			
            instrumentIdList.removeAll(); 
			try {
				
			    for each ( var rec:XML in rs.instrumentCrossRefsWrapper.instrumentCrossRefs) {
					rec.isDeleteEnabled = true;					
				/* 	if(this.mode=="amend" && (rec.instrumentCodeType.toString()==rs.defaultInstrumentCodeType.toString())){
						rec.isDeleteEnabled = false;
					}		 */    	
 				    instrumentIdList.addItem(rec); 				    
			    }			    
			    			    		   
            	instrumentIdList.refresh();
            	for(var i:int=0;i<codeTypeList.length;i++){
            		if(rs.instrumentCodeType.toString()==codeTypeList.getItemAt(i).value){
            			codetype.selectedIndex=i;
            			break;
            		}
            	}
            	
            	instrumentId.text=rs.securityId.toString();
            	//enterpriseDefault.selected=(rs.default.toString()=='true')?true:false;
			}catch(e:Error){			    
			    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    }
		 } else if(rs.child("Errors").length()>0) {
           	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);//Display the error
		 } else {
		 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		 	instrumentIdList.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
}
public function doinstrumentCodeDelete(data:Object):void{
	editInstrumentService.url="smr/securityRegistrationEntryDispatch.action?method=deleteInstrumentCode";
	var reqObj:Object=new Object();
	reqObj.rowNo=instrumentIdList.getItemIndex(data);
	editInstrumentService.request=reqObj;
	editInstrumentService.send();
} 

private function visibleInstrumentInfo():void{
	/* if(XenosStringUtils.isBlank(shortname.text)){			
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('smr.error.blank.shortname'));
		visibleInstrumentInfoBtn.selected=false;
	}else if(XenosStringUtils.isBlank(officialName.text)){		
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('smr.error.blank.offname'));
		visibleInstrumentInfoBtn.selected=false;
	}else if(visibleInstrumentInfoBtn.selected){
		ws.includeInLayout=true;
		ws.visible=true;
	}else if(!visibleInstrumentInfoBtn.selected){
		ws.includeInLayout=false;
		ws.visible=false;
	} */
}
public function bondTypeChangeHandler(event:ListEvent):void {
	
	/* var indexVal:String = (this.couponFrequency.selectedItem != null) ? this.couponFrequency.selectedItem.value:"";
	principalPaymentFreqStr.selectedIndex = getIndexOfLabelValueBean(principalPaymentFreqValues, indexVal );
     */
    //trace("bondType label :"+ this.bondType.selectedItem.label+" value :"+this.bondType.selectedItem.value);
	if (this.bondType.selectedItem.label == "COUPON") {
		// Show Coupon Fields
		gridForCouponTypeCoupon.visible = true;
		gridForCouponTypeCoupon.includeInLayout = true;
		//changeClassName();
	}else {
		 // Hide Coupon Fields 
		var alertStr:String = checkNonDiscountFields();
				 
        // Some bond fields are set which are not allowed in DISCOUNT bond    
        if(!XenosStringUtils.isBlank(alertStr)) { 
        	//Revert Back the Bond Type as COUPON since coupon releated field is present
        	var bondTypes :ArrayCollection = this.bondType.dataProvider as ArrayCollection;
          this.bondType.selectedIndex =  getIndexOfLabelValueBean(bondTypes, "COUPON" );

        }else{
        	gridForCouponTypeCoupon.visible = false;
			gridForCouponTypeCoupon.includeInLayout = false;
			
		}
		//changeClassName();
		
	}
	changeClassName();
}

// Function for Changing Color of Labels to Mandetory RED for discountCouponType = 'COUPON'
private function changeClassName():void {
	var bondTypeStr:String = StringUtil.trim(this.bondType.selectedItem.value);
	/* if (bondTypeStr == 'COUPON')
	{   // Coupon Type = 'COUPON'
		issueDateLbl.styleName = "ReqdLabel";
		maturityDateLbl.styleName = "ReqdLabel";
		redmpnCcyLbl.styleName = "ReqdLabel";

	}else if (bondTypeStr == 'DISCOUNT'){
		//Discount Coupon Type 
		issueDateLbl.styleName = "";
		maturityDateLbl.styleName = "";
		redmpnCcyLbl.styleName = "ReqdLabel";
			
	}else{
		// Nothing is chosen
		issueDateLbl.styleName = "";
		maturityDateLbl.styleName = "";
		redmpnCcyLbl.styleName = "";
	} */
	changeClassNameForBond(bondTypeStr);
}
public function rateTypeChangeHandler(event:ListEvent):Boolean {
	//replaced changeFixFloat func. in javascript
	 var fixedCouponRateStr:String;
	 //var couponRateCount:int;
	 var couponRateStr:String;
	// var couponResetDate:String;
	 var effDateStr : String;
	 var recDateStr : String;
	 var rateTypeStr :String = StringUtil.trim(ComboBox(event.currentTarget).selectedItem.value);
	if (ComboBox(event.currentTarget).selectedItem.label == "Fixed") {
		//couponRateCount = couponInfoSummaryResult.length;
		effDateStr = effdatefrom.text;
		recDateStr = recordDate.text;
		couponRateStr = couponrate.text;
		
        if(!XenosStringUtils.isBlank(effDateStr))
        {
        	//trace("hiddenFloatingFixFlag : "+hiddenFloatingFixFlag);
            rateType.selectedIndex  = hiddenFloatingFixFlag; 
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('smr.instrument.msg.error.invalid.effdateforfix'));
            this.effdatefrom.setFocus();
            return false;
        }
        if(!XenosStringUtils.isBlank(recDateStr))
        {
        	//trace("hiddenFloatingFixFlag : "+hiddenFloatingFixFlag);
            rateType.selectedIndex  = hiddenFloatingFixFlag; 
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('smr.instrument.msg.error.invalid.recordDateforfix'));
            this.recordDate.setFocus();
            return false;
        }
        if(!XenosStringUtils.isBlank(couponRateStr))
        {
        	//trace("hiddenFloatingFixFlag : "+hiddenFloatingFixFlag);
            rateType.selectedIndex  = hiddenFloatingFixFlag; 
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('smr.instrument.msg.error.invalid.rateStr'));
            this.couponrate.setFocus();
            return false;
        }
       // floatingBaseRateStr = (this.floatingBaseRate.selectedItem != null) ? this.floatingBaseRate.selectedItem.value:"";
        /* if(!XenosStringUtils.isBlank(floatingBaseRateStr)) {
            rateType.selectedIndex   = hiddenFloatingFixFlag;   
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.floatbaserateforfix'));
            this.floatingBaseRate.setFocus();
            return false;
        }
        
        couponResetDate = this.couponResetDate.text;  
        if(!XenosStringUtils.isBlank(couponResetDate)) {
            rateType.selectedIndex   = hiddenFloatingFixFlag;    
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.couponresetdateforfix'));
            this.couponResetDate.setFocus();
           return false;
            
        } */
		fixedCouponRateLbl.visible = true;
		fixedCouponRateLbl.includeInLayout = true;
		fixcouponrate.visible = true;
		fixcouponrate.includeInLayout = true;
		
		floatingCpnRateLbl.visible = false;
		floatingCpnRateLbl.includeInLayout = false;
		couponrate.visible = false;
		couponrate.includeInLayout = false;
		
		rateFloatcoupon1.visible = false;
		rateFloatcoupon1.includeInLayout = false; 
		
		/* ws5.percentWidth = 0;
		ws.percentWidth = 100;
		ws5.visible = false;
		ws5.includeInLayout = false; */
		
		
	}else if (ComboBox(event.currentTarget).selectedItem.label == "Floating") {
		
		 // Check if Fixed coupon rate is entered.
      
        fixedCouponRateStr = this.fixcouponrate.text;
        if(!XenosStringUtils.isBlank(fixedCouponRateStr)) {
           rateType.selectedIndex   = hiddenFloatingFixFlag;    
           XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('smr.instrument.msg.error.invalid.fixrateStr'));
           this.fixcouponrate.setFocus(); 
           return false;
        }    
        
		fixedCouponRateLbl.visible = false;
		fixedCouponRateLbl.includeInLayout = false;
		fixcouponrate.visible = false;
		fixcouponrate.includeInLayout = false;
		
		floatingCpnRateLbl.visible = true;
		floatingCpnRateLbl.includeInLayout = true;
		couponrate.visible = true;
		couponrate.includeInLayout = true;
		 
		rateFloatcoupon1.visible = true;
		rateFloatcoupon1.includeInLayout = true; 
		
		/* ws.percentWidth = 30;
		ws5.percentWidth = 70;
		ws5.visible = true;
		ws5.includeInLayout = true;
		ws5.opened = true; */
	}else{
		effDateStr = effdatefrom.text;
		recDateStr = recordDate.text;
		//couponRateCount = couponInfoSummaryResult.length;
        if(!XenosStringUtils.isBlank(effDateStr)) {
            rateType.selectedIndex   = hiddenFloatingFixFlag;    
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('smr.instrument.msg.error.invalid.other.effDateforfloat'));
            this.effdatefrom.setFocus();
            return false;
        }
       if(!XenosStringUtils.isBlank(recDateStr)) {
            rateType.selectedIndex   = hiddenFloatingFixFlag;    
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('smr.instrument.msg.error.invalid.other.recordDateforfloat'));
            this.recordDate.setFocus();
            return false;
        }
        fixedCouponRateStr = this.fixcouponrate.text;
        if(!XenosStringUtils.isBlank(fixedCouponRateStr)) {
           rateType.selectedIndex   = hiddenFloatingFixFlag;    
           XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('smr.instrument.msg.error.invalid.fixrateforothers'));
           this.fixcouponrate.setFocus();
           return false;
        }     
        
        couponRateStr = couponrate.text;
        if(!XenosStringUtils.isBlank(couponRateStr)) {
            rateType.selectedIndex   = hiddenFloatingFixFlag;   
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('smr.instrument.msg.error.invalid.floatbaserateforothers'));
            this.couponrate.setFocus();
            return false;
        } 
		
		/* couponResetDate = this.couponResetDate.text;  
        if(!XenosStringUtils.isBlank(couponResetDate)) {
            rateType.selectedIndex   = hiddenFloatingFixFlag;    
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.couponresetdatefornotfloat'));
            this.couponResetDate.setFocus();
           return false;
            
        } */
              
		fixedCouponRateLbl.visible = false;
		fixedCouponRateLbl.includeInLayout = true;
		fixcouponrate.visible = false;
		fixcouponrate.includeInLayout = true;
		
		floatingCpnRateLbl.visible = false;
		floatingCpnRateLbl.includeInLayout = false;
		couponrate.visible = false;
		couponrate.includeInLayout = false;
		
	 	rateFloatcoupon1.visible = false;
		rateFloatcoupon1.includeInLayout = false; 
		
		/* ws5.percentWidth = 0;
		ws.percentWidth = 100;
		ws5.visible = false;
		ws5.includeInLayout = false; */
	
	}
	changeClassNameForRate(rateTypeStr);
	return true;
}
/**
 * Calculates the index of a label value bean given its value, within a given 
 * array collection of such beans.
 * Returns 0 if the value is null or empty string.
 */
private function getIndexOfLabelValueBean(collection:ArrayCollection, value:String):int {
	var index:int = 0;
	if (value == null || value == XenosStringUtils.EMPTY_STR) {
		return index;
	}
	for (var count:int = 0; count < collection.length; count++) {
		var bean:Object = collection.getItemAt(count);
		//trace("bean :"+bean);
		if (bean == value) {
			index = count;
			break;
		}
	}
	return index;
}
private function checkNonDiscountFields():String
{
	var alertStr:String = "";
	var couponFrequency:String = this.paymentfrequency.text;
    if(!XenosStringUtils.isBlank(couponFrequency) ){
		
		
		/*  if(validator != null){
		 	validator.results.push(new ValidationResult(true, 
                    	"couponFrequency", "couponFrequency", "Cannot enter Coupon Payment Frequency for Bond Type other than COUPON."));
		 }else{ */
		 	 alertStr += "Cannot enter Coupon Payment Frequency for Bond Type other than COUPON\n";
		/*  } */
	}
	if(!XenosStringUtils.isBlank(this.cpnccy.ccyText.text) ){
		/* if(validator != null){
		 	validator.results.push(new ValidationResult(true, 
                    	"couponCcy", "couponCcy", "Cannot enter Coupon Currency for Bond Type other than COUPON."));
		 }else{ */
			alertStr += "Cannot enter Coupon Currency for Bond Type other than COUPON\n";
		/*  } */
	} 
	
	if(!XenosStringUtils.isBlank(this.accrissuedate.text) ){
		/*  if(validator != null){
		 	validator.results.push(new ValidationResult(true, 
                    	"accIntStartDate", "accIntStartDate", "Cannot enter Accrued Interest Init Date for Bond Type other than COUPON."));
		 }else{ */
			 alertStr += "Cannot enter Accrued Interest Init Date for Bond Type other than COUPON\n";
		 /* } */
	}  
	
	var accIntCalType:String = (this.accIntCalType.selectedItem != null) ? this.accIntCalType.selectedLabel : "";
	
	if(!XenosStringUtils.isBlank(accIntCalType) ){
		/* if(validator != null){
		 	validator.results.push(new ValidationResult(true, 
                    	"accIntCalType", "accIntCalType", "Cannot enter Accrued Interest Calculation Type for Bond Type other than COUPON."));
		 }else{ */
			alertStr += "Cannot enter Accrued Interest Calculation Type for Bond Type other than COUPON\n";
		 /* } */
	}  
    
    var rateType:String = (this.rateType.selectedItem != null) ? this.rateType.selectedItem.value : "";
    if(!XenosStringUtils.isBlank(rateType) ){
		/* if(validator != null){
		 	validator.results.push(new ValidationResult(true, 
                    	"rateType", "rateType", "Cannot enter Rate Type for Bond Type other than COUPON."));
		 }else{ */
			alertStr += "Cannot enter Rate Type for Bond Type other than COUPON\n";
		 /* } */
	}
	
    //var initialCouponType:String = (this.initialCouponType.selectedItem != null) ? this.initialCouponType.selectedItem.value : "";
   // if(!XenosStringUtils.isBlank(initialCouponType) ){
		/* if(validator != null){
		 	validator.results.push(new ValidationResult(true, 
                    	"initialCouponType", "initialCouponType", "Cannot enter Initial Coupon Type for Bond Type other than COUPON."));
		 }else{ */
		//	alertStr += "Cannot enter Initial Coupon Type for Bond Type other than COUPON\n";
		 /* } */
	//}
	
	if(!XenosStringUtils.isBlank(this.firstpaymentdt.text) ){
		/* if(validator != null){
		 	validator.results.push(new ValidationResult(true, 
                    	"initialCouponDate", "initialCouponDate", "Cannot enter Initial Coupon Date for Bond Type other than COUPON."));
		 }else{ */
			alertStr += "Cannot enter Initial Coupon Date for Bond Type other than COUPON\n";
		/*  } */
	}
	if(!XenosStringUtils.isBlank(this.finalcpndate.text) ){
		/* if(validator != null){
		 	validator.results.push(new ValidationResult(true, 
                    	"finalCouponDate", "finalCouponDate", "Cannot enter Final Coupon Date for Bond Type other than COUPON."));
		 }else{ */
			alertStr += "Cannot enter Final Coupon Date for Bond Type other than COUPON\n";
		 /* } */
	}
	var finalCouponType:String = (this.finalcpntype.selectedItem != null) ? this.finalcpntype.selectedItem.value : "";
	if(!XenosStringUtils.isBlank(finalCouponType) ){
		 /* if(validator != null){
		 	validator.results.push(new ValidationResult(true, 
                    	"finalCouponType", "finalCouponType", "Cannot enter Final Coupon Type for Bond Type other than COUPON."));
		 }else{ */
			 alertStr += "Cannot enter Final Coupon Type for Bond Type other than COUPON\n";
		 /* } */
	}
	if(alertStr != ""){
   	 XenosAlert.error(alertStr);
   	 return 'error';
    }else{
     return '';
    } 
}
/**
* Stores the current value of the discountCouponType field such that if 
* a validation error occurs the user previous value will be selected.
*/
private function storeCurrentCouponValue(event:FocusEvent):void {

   
   hiddenDiscountCouponType = bondType.selectedIndex;
}

/**
* Stores the current value of the floatingFixFlag field such that if 
* a validation error occurs the user previous value will be selected.
*/
private function storeCurrentRateTypeValue(event:FocusEvent):void {
   hiddenFloatingFixFlag = this.rateType.selectedIndex;
}
 /**
   * This is the method to pass the Collection of data items
   * through the context to the FinInst popup. This will be implemented as per specifdic  
   * requirement. 
   */
 private function populateFinInstRole():ArrayCollection {
	//pass the context data to the popup
	 var myContextList:ArrayCollection = new ArrayCollection(); 

	 var bankRoleArray : Array = new Array(1);
	 bankRoleArray[0] = "Stock Exchange";
	 myContextList.addItem(new HiddenObject("bankRoles",bankRoleArray));
	 var codeTypeArray : Array = new Array(1);
	 codeTypeArray[0] = "ISO";
	 myContextList.addItem(new HiddenObject("codeType",codeTypeArray));
	 return myContextList;
 }
 
 /**
 * To add Memo Information
 */
private function addMemo():void{
	if(XenosStringUtils.isBlank(memoData.text)){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('smr.instrument.msg.error.missing.memo'));
		return;
	}
	addMemoService.request = populateMemo();
	addMemoService.url = "smr/securityRegistrationEntryDispatch.action?method=addMemo";
	addMemoService.send();
}
public function editMemo(data:Object):void{
	var reqObj : Object = new Object();
	reqObj.rowNo = memoSummaryResult.getItemIndex(data);
	memoSummaryResult.removeItemAt(reqObj.rowNo);
	//data.isVisible=false;
	memoSummaryResult.refresh();
	//XenosAlert.info("url mode:" + _urlMode);
	editMemoService.url = "smr/securityRegistrationEntryDispatch.action?method=editMemo";
	editMemoService.request = reqObj;
	editMemoService.send();
}

public function deleteMemo(data:Object):void{
	var reqObj : Object = new Object();
	reqObj.rowNo = memoSummaryResult.getItemIndex(data);
	deleteMemoService.url = "smr/securityRegistrationEntryDispatch.action?method=deleteMemo"
	deleteMemoService.request = reqObj;
	deleteMemoService.send();
}
private function populateMemo():Object{
				
	var reqObj : Object = new Object();
	
	reqObj['memo'] = StringUtil.trim(this.memoData.selectedItem.toString());
	reqObj['description1'] = this.description1.text != null ? this.description1.text : "";
	reqObj['description2'] = this.description2.text != null ? this.description2.text : "";
	
	return reqObj;
}
/**
* This method works as the result handler of the Submit Query Http Services for Memos.
* 
*/
public function memoResultHandler(event:ResultEvent):void {
    var rs:XML = XML(event.result);

	if (null != event) {
		 if(rs.child("memosWrapper").length()>0) {
		 	
			errPage.clearError(event);
			// if(this.mode != "AMEND")
            memoSummaryResult.removeAll(); 
			try {
			    for each ( var rec:XML in rs.memosWrapper.memos) {
			    	rec.isVisible = true;
 				    memoSummaryResult.addItem(rec);
			    }
				memoData.selectedIndex=0;
			    description1.text = "";
			    description2.text ="";
			   
            	memoSummaryResult.refresh();
            	
            	trace("memoResult :"+memoSummaryResult);	
			}catch(e:Error){
			    //XenosAlert.error(e.toString() + e.message);
			    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    }
		 } else if(rs.child("Errors").length()>0) {
           
		 	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);//Display the error
		 } else {
		 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		 	memoSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
}

/**
* This method works as the result handler of the Submit Query Http Services for Memos.
* 
*/
public function memoEditResultHandler(event:ResultEvent):void {
    var rs:XML = XML(event.result);

	if (null != event) {
		if(rs.child("memosWrapper").length()>0){
			
			editedMemoList = rs;
			
			for(var i:int=0; i<memoValueList.length; i++){			
				if(memoValueList.getItemAt(i).toString() == rs.memo.toString()){
					memoData.selectedIndex = i;
				}
			}
			
			description1.text=rs.description1.toString();
			description2.text=rs.description2.toString();
			
		} else if(rs.child("Errors").length()>0) {
            //some error found
		 	memoSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);//Display the error
		 } else {
		 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		 	memoSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
    
}