// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.XenosStringUtils;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.events.ValidationResultEvent;
import mx.formatters.DateFormatter;
import mx.managers.IPopUpManager;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;
   
   			
 private var iPopUpManager:IPopUpManager;

[Bindable]private var monthValues:ArrayCollection;
[Bindable]private var dayValues:ArrayCollection;
[Bindable]private var settlingDates:ArrayCollection;
[Bindable]private var marketTypeValues:ArrayCollection;
[Bindable]public var xmlResponse:XML;
[Bindable]private var listedMarkets:ArrayCollection;
private var noOfDaysinMonth:Object={1:31,2:28,3:31,4:30,5:31,6:30,7:31,8:31,9:30,10:31,11:30,12:31};
[Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
[Bindable]private var csdEligibles:ArrayCollection;
[Bindable]private var setlProhibitedDates:ArrayCollection;
[Bindable]private var callableFlagValues:ArrayCollection;
[Bindable]private var callables:ArrayCollection;
[Bindable]private var ratingAgencyPkNameMap:ArrayCollection;
[Bindable]private var ratingList:ArrayCollection;
[Bindable]private var ratingValues:ArrayCollection;
[Bindable]private var complianceValues:ArrayCollection;
[Bindable]private var compliances:ArrayCollection;
[Bindable]private var underwriters:ArrayCollection;
[Bindable]private var urlModeBind:String="Entry";
override public function populateRequest():Object{
	var reqObj:Object = new Object();
	reqObj['instrumentPage.callableFlag']=	callableFlag.selectedItem.value.toString();
	reqObj['instrumentPage.reopenDateStr']=reopendate.text;
	reqObj['instrumentPage.ipoPaymentDateStr']=ipopaymentdate.text;
	reqObj['instrumentPage.publicOfferStartDateStr']=publicofferstartdate.text;
	reqObj['instrumentPage.publicOfferEndDateStr']=publicofferenddate.text;
	reqObj['instrumentPage.quantityPerUnitStr']=quantityPerUnit.text;
	if(this.mode == "entry")
		reqObj['SCREEN_KEY'] = 20;
	else 
		reqObj['SCREEN_KEY'] = 25;
	
	return reqObj;
}

override public function reset():void {
	
}

override public function set mode(modeStr:String):void{
	super.mode=modeStr;
	if(modeStr=="amend"){
		urlModeBind="Amend";
	}
	else if(modeStr=="entry"){
		urlModeBind="Entry";
	}
}
override public function  initPage(responseObj:XML):void {
	xmlResponse = responseObj as XML;
	
	try{
		errPage.removeError();
	}
	catch(e:Error){
		
	}
	//have to populate from form
	settlingDates=new ArrayCollection();
	if(xmlResponse.child("settlingDatesWrapper").length()>0) {
	    for each ( var rec:XML in xmlResponse.settlingDatesWrapper.settlingDates) {			    	
 		    settlingDates.addItem(rec);
	    }
	}
	monthValues=new ArrayCollection();
	monthValues.addItem({label:"",value:""});
	for each(var obj:Object in xmlResponse.monthValues.item){
		monthValues.addItem(obj);
	}
	dayValues=new ArrayCollection();
	dayValues.addItem({label:"",value:""});
	for each(var obj:Object in xmlResponse.dayValues.item){
		dayValues.addItem(obj);
	}
	
	//have to populate from form
	listedMarkets=new ArrayCollection();
	if(xmlResponse.child("listedMarketsWrapper").length()>0) {
	    for each ( var rec:XML in xmlResponse.listedMarketsWrapper.listedMarkets) {			    	
 		    listedMarkets.addItem(rec);
	    }
	}
	
	marketTypeValues=new ArrayCollection();
	marketTypeValues.addItem({label:"",value:""});
	for each(var obj:Object in xmlResponse.marketTypeValues.item){
		marketTypeValues.addItem(obj);
	}
	
	//have to populate from form
	csdEligibles=new ArrayCollection();
	 if(xmlResponse.child("csdEligiblesWrapper").length()>0) {
	    for each ( var rec:XML in xmlResponse.csdEligiblesWrapper.csdEligibles) {			    	
 		    csdEligibles.addItem(rec); 				    
	    }		
	 }
	
	setlProhibitedDates=new ArrayCollection();
	if(xmlResponse.child("setlProhibitedDatesWrapper").length()>0) {
		var obj:Object;
	    for each (var rec:XML in xmlResponse.setlProhibitedDatesWrapper.setlProhibitedDates) {
	    	obj=new Object();	
	    	obj.setlProhibitedDates=rec;	    	
 		    setlProhibitedDates.addItem(obj); 				    
	    }
	}	
	
	callableFlagValues=new ArrayCollection();	
	for each(var obj:Object in xmlResponse.instrumentPage.callableFlagValues.item){
		callableFlagValues.addItem(obj);
	}
	
	callableFlag.selectedIndex=getIndexOfLabelValueBean(callableFlagValues,xmlResponse.instrumentPage.callableFlag.toString());
	
	//have to populate
	callables=new ArrayCollection();
	 if(xmlResponse.child("callablesWrapper").length()>0) {			
	    for each ( var rec:XML in xmlResponse.callablesWrapper.callables) {			    	
 		    callables.addItem(rec); 				    
	    }			    
	 }
	 //Fire callable change
	callableFlagChange();
	
	complianceValues=new ArrayCollection();
	complianceValues.addItem("");
	for each(var obj:Object in xmlResponse.complianceValuesWrapper.complianceValues){
		complianceValues.addItem(obj);
	}
	//populate from action form
	compliances=new ArrayCollection();
	 if(xmlResponse.child("compliancesWrapper").length()>0) {	
		var obj:Object;
	    for each ( var rec:XML in xmlResponse.compliancesWrapper.compliances) {
	    	obj=new Object();
	    	obj.compliances=rec;			    	
 		    compliances.addItem(obj); 				    
	    }		
	}
	
	//populate fom actionform
	underwriters=new ArrayCollection();
	 if(xmlResponse.child("underwritersWrapper").length()>0) {
	    for each ( var rec:XML in xmlResponse.underwritersWrapper.underwriters) {			    	
 		    underwriters.addItem(rec); 				    
	    }	
	}	
	
	
	ratingAgencyPkNameMap=new ArrayCollection();	
	ratingAgencyPkNameMap.addItem({label:"",value:""});
	if(xmlResponse.child("ratingAgencyPkNameMap").length()>0) {
		for each(var obj:Object in xmlResponse.ratingAgencyPkNameMap.item){
			ratingAgencyPkNameMap.addItem(obj);
		}
	}
	
	ratingList=new ArrayCollection();	
	ratingList.addItem("");
	if(xmlResponse.child("ratingsWrapper").length()>0) {
		for each(var obj:Object in xmlResponse.ratingsWrapper.ratings){
			ratingList.addItem(obj.toString());
		}
	}
	
	//populate fom actionform	
	ratingValues=new ArrayCollection();
	if(xmlResponse.child("ratingValuesWrapper").length()>0) {	
	    for each ( var rec1:XML in xmlResponse.ratingValuesWrapper.ratingValues) {			    	
 		    ratingValues.addItem(rec1); 				    
	    }			    	    			    		   
   		ratingValues.refresh();
	}

	//set date fields
	reopendate.text=xmlResponse.instrumentPage.reopenDateStr.toString();
	ipopaymentdate.text=xmlResponse.instrumentPage.ipoPaymentDateStr.toString();
	publicofferstartdate.text=xmlResponse.instrumentPage.publicOfferStartDateStr.toString();
	publicofferenddate.text=xmlResponse.instrumentPage.publicOfferEndDateStr.toString();
	quantityPerUnit.text=xmlResponse.instrumentPage.quantityPerUnitStr.toString();
}

override public function  validate():ValidationResultEvent{
	
	return new ValidationResultEvent(ValidationResultEvent.VALID);        	
} 

private function monthValueChanged(e:Event):void{
	var selectedMonth:String=monthValue.selectedItem['value'].toString();
	if(!XenosStringUtils.isBlank(selectedMonth)){
		var i:int;
		dayValues=new ArrayCollection();
		dayValues.addItem({label:"",value:""});
		for(i=1;i<=noOfDaysinMonth[selectedMonth];i++){
			dayValues.addItem({label:i,value:i});
		}
	}	
}

private function addSettlingDate():void{
	var reqObj:Object=new Object();
	var selectedMonth:String=monthValue.selectedItem['value'].toString();
	var selectedDay:String=dayValue.selectedItem['value'].toString();
	if(XenosStringUtils.isBlank(selectedMonth) ){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.recordmonth'));
	}
	else if(XenosStringUtils.isBlank(selectedDay))
	{
		var errMsg:String="Settling Day not entered.\nNULL Settling Day means last day of ";
		dayValue.selectedIndex=noOfDaysinMonth[selectedMonth];
		selectedDay=dayValue.selectedItem['value'].toString();
		
		var dateObj:Date=new Date();
		dateObj.setMonth(selectedMonth,1);
		var dfmt:DateFormatter=new DateFormatter();
		dfmt.formatString="MMMM";		
		errMsg+=dfmt.format(dateObj)+" "+selectedMonth+"/"+selectedDay;
		XenosAlert.error(errMsg);
		reqObj.settlingMonth=selectedMonth;
		reqObj.settlingDay=selectedDay;
		addSettlingDateService.request=reqObj;
		addSettlingDateService.send();
	}
	else{
		reqObj.settlingMonth=selectedMonth;
		reqObj.settlingDay=selectedDay;
		addSettlingDateService.request=reqObj;
		addSettlingDateService.send();
	}
}

private function validateNumber(event:FocusEvent):void{
	numVal1.source = TextInput(event.currentTarget);
	numVal1.handleNumericField(numberFormatter);
}

private function addSettlingDateServiceResult(event:ResultEvent):void{
	 var rs:XML = XML(event.result);

	if (null != event) {
		 if(rs.child("settlingDatesWrapper").length()>0) {
			errPage.clearError(event);			
            settlingDates.removeAll(); 
			try {
			    for each ( var rec:XML in rs.settlingDatesWrapper.settlingDates) {			    	
 				    settlingDates.addItem(rec);
			    }			    
			    dayValue.selectedIndex=0;
			    monthValue.selectedIndex=0;			   
            	settlingDates.refresh();
            	
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
		 	settlingDates.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
}

public function editSettlingDate(data:Object):void{
	var reqObj:Object=new Object();
	reqObj.rowNo=settlingDates.getItemIndex(data);
	editSettlingDateService.request=reqObj;
	editSettlingDateService.send();	
}


public function deleteSettlingDate(data:Object):void{
	var reqObj:Object=new Object();
	reqObj.rowNo=settlingDates.getItemIndex(data);
	deleteSettlingDateService.request=reqObj;
	deleteSettlingDateService.send();	
}

private function addListedMarketServiceResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if (null != event) {
		 if(rs.child("listedMarketsWrapper").length()>0) {
			errPage.clearError(event);			
            listedMarkets.removeAll(); 
			try {
				
			    for each ( var rec:XML in rs.listedMarketsWrapper.listedMarkets) {			    	
 				    listedMarkets.addItem(rec); 				    
			    }			    
			    			    		   
            	listedMarkets.refresh();
            	marketType.selectedIndex=0;
            	marketTree.itemCombo.selectedIndex=0;
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
		 	listedMarkets.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
}

private function editListedMarketServiceResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if (null != event) {
		 if(rs.child("listedMarketsWrapper").length()>0) {
			errPage.clearError(event);			
            listedMarkets.removeAll(); 
			try {
				
			    for each ( var rec:XML in rs.listedMarketsWrapper.listedMarkets) {			    	
 				    listedMarkets.addItem(rec); 				    
			    }			    
			    
			    marketTree.text=rs.market.toString();	
			    
			    for(var i:int=0;i<marketTypeValues.length;i++){
			    	if(marketTypeValues.getItemAt(i).value.toString()==rs.marketType.toString()){
			    		marketType.selectedIndex=i;
			    		break;
			    	}
			    }		    		   
            	listedMarkets.refresh();
            	
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
		 	listedMarkets.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
}

private function editSettlingDateServiceResult(event:ResultEvent):void{
	 var rs:XML = XML(event.result);

	if (null != event) {
		 if(rs.child("settlingDatesWrapper").length()>0) {
			errPage.clearError(event);			
            settlingDates.removeAll(); 
			try {
				
			    for each ( var rec:XML in rs.settlingDatesWrapper.settlingDates) {			    	
 				    settlingDates.addItem(rec); 				    
			    }
			    
			    monthValue.selectedIndex=int(new Number(rs['settlingMonth'].toString()));	
				monthValueChanged(null);
				dayValue.selectedIndex=int(new Number(rs['settlingDay'].toString()));
						    		   
            	settlingDates.refresh();
            	
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
		 	settlingDates.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
}

private function addListedMarket():void{
	var reqObj:Object=new Object();
	var selectedMarket:String=marketTree.itemCombo.text;
	var marketType:String=marketType.selectedItem.value;
	var errMsg:String="";
	if(XenosStringUtils.isBlank(selectedMarket)){
		errMsg+="Please enter a valid Market\n";
	} 
	if(XenosStringUtils.isBlank(marketType)){
		errMsg+="Please enter a valid Market Type\n";
	}
	if(XenosStringUtils.isBlank(errMsg)){
		reqObj.market=selectedMarket;
		reqObj.marketType=marketType;
		addListedMarketService.request=reqObj;
		addListedMarketService.send();
	}
	else{
		XenosAlert.error(errMsg);
	}
}


public function editListedMarket(data:Object):void{
	var reqObj:Object=new Object();
	reqObj.rowNo=listedMarkets.getItemIndex(data);
	editListedMarketService.request=reqObj;
	editListedMarketService.send();	
}

public function deleteListedMarket(data:Object):void{
	var reqObj:Object=new Object();
	reqObj.rowNo=listedMarkets.getItemIndex(data);
	deleteListedMarketService.request=reqObj;
	deleteListedMarketService.send();	
}

public function populateCSDContext():ArrayCollection{
	 var myContextList:ArrayCollection = new ArrayCollection(); 
    //passing counter party type                
    var settleActTypeArray:Array = new Array(1);
    settleActTypeArray[0]="Central Depository";                   
    myContextList.addItem(new HiddenObject("csdRoles",settleActTypeArray));    
    return myContextList;
}


private function addCSD():void{
	var reqObj:Object=new Object();
	
	if(XenosStringUtils.isBlank(csdPopup.finInstCode.text)){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.csd'));
	} 
	else{
		reqObj.csd=csdPopup.finInstCode.text;		
		addCSDService.request=reqObj;
		addCSDService.send();
	}
	
}


public function editCSD(data:Object):void{
	var reqObj:Object=new Object();
	reqObj.rowNo=csdEligibles.getItemIndex(data);
	editCSDService.request=reqObj;
	editCSDService.send();	
}

public function deleteCSD(data:Object):void{
	var reqObj:Object=new Object();
	reqObj.rowNo=csdEligibles.getItemIndex(data);
	deleteCSDService.request=reqObj;
	deleteCSDService.send();	
}

private function addCSDServiceResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if (null != event) {
		 if(rs.child("csdEligiblesWrapper").length()>0) {
			errPage.clearError(event);			
            csdEligibles.removeAll(); 
			try {
				
			    for each ( var rec:XML in rs.csdEligiblesWrapper.csdEligibles) {			    	
 				    csdEligibles.addItem(rec); 				    
			    }			    
			    			    		   
            	csdEligibles.refresh();
            	csdPopup.finInstCode.text="";
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
		 	csdEligibles.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
}

private function editCSDServiceResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if (null != event) {
		 if(rs.child("csdEligiblesWrapper").length()>0) {
			errPage.clearError(event);			
            csdEligibles.removeAll(); 
			try {
				
			    for each ( var rec:XML in rs.csdEligiblesWrapper.csdEligibles) {			    	
 				    csdEligibles.addItem(rec); 				    
			    }			    
			    			    		   
            	csdEligibles.refresh();
            	csdPopup.finInstCode.text=rs.csd.toString();
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
		 	csdEligibles.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
}

private function addProDate():void{
	var reqObj:Object=new Object();
	
	if(!DateUtils.isValidDate(stlProhibitedDate.text)){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.stldate'));
	} 
	else{
		reqObj.setlProhibitedDate=stlProhibitedDate.text;		
		addstlProDateService.request=reqObj;
		addstlProDateService.send();
	}
	
}


public function editProDate(data:Object):void{
	var reqObj:Object=new Object();
	reqObj.rowNo=setlProhibitedDates.getItemIndex(data);
	editstlProDateService.request=reqObj;
	editstlProDateService.send();	
}

public function deleteProDate(data:Object):void{
	var reqObj:Object=new Object();
	reqObj.rowNo=setlProhibitedDates.getItemIndex(data);
	deletestlProDateService.request=reqObj;
	deletestlProDateService.send();	
}

private function addstlProDateServiceResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if (null != event) {
		 if(rs.child("setlProhibitedDatesWrapper").length()>0) {
			errPage.clearError(event);			
            setlProhibitedDates.removeAll(); 
			try {
				var obj:Object;
			    for each ( var rec:XML in rs.setlProhibitedDatesWrapper.setlProhibitedDates) {
			    	obj=new Object();	
			    	obj.setlProhibitedDates=rec;	    	
 				    setlProhibitedDates.addItem(obj); 				    
			    }			    
			    			    		   
            	setlProhibitedDates.refresh();
            	stlProhibitedDate.text="";
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
		 	setlProhibitedDates.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
}

private function editstlProDateServiceResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if (null != event) {
		 if(rs.child("setlProhibitedDatesWrapper").length()>0) {
			errPage.clearError(event);			
            setlProhibitedDates.removeAll(); 
			try {
				var obj:Object;
			    for each ( var rec:XML in rs.setlProhibitedDatesWrapper.setlProhibitedDates) {			    	
 				    obj=new Object();	
			    	obj.setlProhibitedDates=rec;	    	
 				    setlProhibitedDates.addItem(obj); 			    
			    }			    
			    			    		   
            	setlProhibitedDates.refresh();
            	stlProhibitedDate.text=rs.setlProhibitedDate.toString();
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
		 	setlProhibitedDates.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
}

private function callableFlagChange():void{
	if(callableFlag.selectedItem.value.toString()=="Y"){
		callableVbox.visible=true;
	}
	if(callableFlag.selectedItem.value.toString()=="N"){
		callableVbox.visible=false;
	}
}

private function addCallable():void{
	var reqObj:Object=new Object();
	var errMsg:String="";
	if(!DateUtils.isValidDate(callstdate.text)){
		errMsg+="Please enter a valid Call Start date\n";
	} 
	/* if(XenosStringUtils.isBlank(calPrice.text)){
		errMsg+="Please enter a valid Call Price";
	} */
	if(!XenosStringUtils.isBlank(errMsg)){
		XenosAlert.error(errMsg);
	} 
	else{
		reqObj.callStartDate=callstdate.text;
		reqObj.callEndDate=callenddate.text;	
		reqObj.callPrice=calPrice.text;	
		reqObj['instrumentPage.callableFlag']=	callableFlag.selectedItem.value.toString();
		addCallableService.request=reqObj;
		addCallableService.send();
	}
	
}


public function editCallable(data:Object):void{
	var reqObj:Object=new Object();
	reqObj.rowNo=callables.getItemIndex(data);
	editCallableService.request=reqObj;
	editCallableService.send();	
}

public function deleteCallable(data:Object):void{
	var reqObj:Object=new Object();
	reqObj.rowNo=callables.getItemIndex(data);
	deleteCallableService.request=reqObj;
	deleteCallableService.send();	
}

private function addCallableServiceResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if (null != event) {
		 if(rs.child("callablesWrapper").length()>0) {
			errPage.clearError(event);			
            callables.removeAll(); 
			try {
				
			    for each ( var rec:XML in rs.callablesWrapper.callables) {			    	
 				    callables.addItem(rec); 				    
			    }			    
			    			    		   
            	callables.refresh();
            	callstdate.text="";
            	callenddate.text="";
            	calPrice.text="";
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
		 	callables.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
}

private function editCallableServiceResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if (null != event) {
		 if(rs.child("callablesWrapper").length()>0) {
			errPage.clearError(event);			
            callables.removeAll(); 
			try {
				
			    for each ( var rec:XML in rs.callablesWrapper.callables) {			    	
 				    callables.addItem(rec); 				    
			    }			    
			    			    		   
            	callables.refresh();
            	callstdate.text=rs.callStartDate.toString();
            	callenddate.text=rs.callEndDate.toString();
            	calPrice.text=rs.callPrice.toString();
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
		 	callables.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
}

private function addCompliance():void{
	var reqObj:Object=new Object();
	
	if(XenosStringUtils.isBlank(compliance.selectedLabel)){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.complience'));
	} 
	else{
		reqObj.compliance=compliance.selectedLabel;		
		addComplianceService.request=reqObj;
		addComplianceService.send();
	}
	
}


public function editCompliance(data:Object):void{
	var reqObj:Object=new Object();
	reqObj.rowNo=compliances.getItemIndex(data);
	editComplianceService.request=reqObj;
	editComplianceService.send();	
}

public function deleteCompliance(data:Object):void{
	var reqObj:Object=new Object();
	reqObj.rowNo=compliances.getItemIndex(data);
	deleteComplianceService.request=reqObj;
	deleteComplianceService.send();	
}

private function addComplianceServiceResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if (null != event) {
		 if(rs.child("compliancesWrapper").length()>0) {
			errPage.clearError(event);			
            compliances.removeAll(); 
			try {
				var obj:Object;
			    for each ( var rec:XML in rs.compliancesWrapper.compliances) {
			    	obj=new Object();
			    	obj.compliances=rec;			    	
 				    compliances.addItem(obj); 				    
			    }			    
			    			    		   
            	compliances.refresh();
            	compliance.selectedIndex=0;
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
		 	compliances.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
}

private function editComplianceServiceResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if (null != event) {
		 if(rs.child("csdEligiblesWrapper").length()>0) {
			errPage.clearError(event);			
            compliances.removeAll(); 
			try {
				
			   var obj:Object;
			    for each ( var rec:XML in rs.compliancesWrapper.compliances) {
			    	obj=new Object();
			    	obj.compliances=rec;			    	
 				    compliances.addItem(obj); 				    
			    }				    
			    			    		   
            	compliances.refresh();
            	for(var i:int=0;i<complianceValues.length;i++){
            		if(complianceValues.getItemAt(i).toString()==rs.compliance.toString()){
            			compliance.selectedIndex=i;
            			break;
            		}
            	}
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
		 	compliances.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
}
public function populateUnderWriterCtx():ArrayCollection{
	 var myContextList:ArrayCollection = new ArrayCollection(); 
    //passing counter party type                
    var settleActTypeArray:Array = new Array(1);
    settleActTypeArray[0]="Under Writer";                   
    myContextList.addItem(new HiddenObject("underwriterRolesAsContext",settleActTypeArray));    
    return myContextList;
}

private function addUnderWriter():void{
	var reqObj:Object=new Object();
	
	if(XenosStringUtils.isBlank(underWriterPopup.finInstCode.text)){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.invalid.underwriter'));
	} 
	else{
		reqObj.underwriter=underWriterPopup.finInstCode.text;		
		addUnderWriterService.request=reqObj;
		addUnderWriterService.send();
	}
	
}


public function editUnderWriter(data:Object):void{
	var reqObj:Object=new Object();
	reqObj.rowNo=underwriters.getItemIndex(data);
	editUnderWriterService.request=reqObj;
	editUnderWriterService.send();	
}

public function deleteUnderWriter(data:Object):void{
	var reqObj:Object=new Object();
	reqObj.rowNo=underwriters.getItemIndex(data);
	deleteUnderWriterService.request=reqObj;
	deleteUnderWriterService.send();	
}

private function addUnderWriterServiceResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if (null != event) {
		 if(rs.child("underwritersWrapper").length()>0) {
			errPage.clearError(event);			
            underwriters.removeAll(); 
			try {
				
			    for each ( var rec:XML in rs.underwritersWrapper.underwriters) {			    	
 				    underwriters.addItem(rec); 				    
			    }			    
			    			    		   
            	underwriters.refresh();
            	underWriterPopup.finInstCode.text="";
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
		 	underwriters.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
}

private function editUnderWriterServiceResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if (null != event) {
		 if(rs.child("underwritersWrapper").length()>0) {
			errPage.clearError(event);			
            underwriters.removeAll(); 
			try {
				
			    for each ( var rec:XML in rs.underwritersWrapper.underwriters) {			    	
 				    underwriters.addItem(rec); 				    
			    }			    
			    			    		   
            	underwriters.refresh();
            	underWriterPopup.finInstCode.text=rs.underwriter.toString();
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
		 	underwriters.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
}


private function addRating():void{
	var reqObj:Object=new Object();
	var ratingAgencyStr:String=StringUtil.trim(ratingAgency.selectedItem.value.toString());
	var ratingStr:String=StringUtil.trim(rating.selectedLabel);
	var errMsg:String="";
	if(XenosStringUtils.isBlank(ratingAgencyStr)){
		errMsg+="Please enter a valid Rating Agency\n";
	} 
	if(XenosStringUtils.isBlank(ratingStr)){
		errMsg+="Please enter a valid Rating";
	} 
	
	if(!XenosStringUtils.isBlank(errMsg)){
		XenosAlert.error(errMsg);
	}
	else{
		reqObj.ratingAgency=ratingAgencyStr;		
		reqObj.rating=ratingStr;		
		addRatingService.request=reqObj;
		addRatingService.send();
	}
	
}


public function editRating(data:Object):void{
	var reqObj:Object=new Object();
	reqObj.rowNo=ratingValues.getItemIndex(data);
	editRatingService.request=reqObj;
	editRatingService.send();	
}

public function deleteRating(data:Object):void{
	var reqObj:Object=new Object();
	reqObj.rowNo=ratingValues.getItemIndex(data);
	deleteRatingService.request=reqObj;
	deleteRatingService.send();	
}

private function addRatingServiceResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if (null != event) {
		 if(rs.child("ratingValuesWrapper").length()>0) {
			errPage.clearError(event);			
            ratingValues.removeAll(); 
			try {
				
			    for each ( var rec:XML in rs.ratingValuesWrapper.ratingValues) {			    	
 				    ratingValues.addItem(rec); 				    
			    }			    
			    			    		   
           		ratingValues.refresh();
            	ratingAgency.selectedIndex=getIndexOfLabelValueBean(ratingAgencyPkNameMap,rs.ratingAgency.toString());
            	rating.selectedIndex=getIndex(ratingList,rs.rating.toString());
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
		 	ratingValues.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
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
		if (bean['value'] == value) {
			index = count;
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
private function getIndex(collection:ArrayCollection, value:String):int {
	var index:int = 0;
	if (value == null || value == XenosStringUtils.EMPTY_STR) {
		return index;
	}
	for (var count:int = 0; count < collection.length; count++) {
		if (String(collection.getItemAt(count)) == value) {
			index = count;
			break;
		}
	}
	return index;
}

private function setRating(e:Event):void{
	var ratingAgencyStr:String=StringUtil.trim(ratingAgency.selectedItem.value.toString());
	var reqObj:Object=new Object();
	reqObj.ratingAgency=ratingAgencyStr;
	setRatingService.request=reqObj;
	setRatingService.send();
}
private function setRatingServiceResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if (null != event) {
		//No error
		 if(rs.child("Errors").length()<=0) {
			errPage.clearError(event);			
            ratingList.removeAll();
            ratingList.addItem(""); 
			try {	
				if(rs.child("ratingsWrapper").length()>0) {
					for each(var obj:Object in rs.ratingsWrapper.ratings){
						ratingList.addItem(obj.toString());
					}
				}	    		   
           		
			}catch(e:Error){			    
			    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    }
		 } else {
           	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);//Display the error
		 } 
    }
}
