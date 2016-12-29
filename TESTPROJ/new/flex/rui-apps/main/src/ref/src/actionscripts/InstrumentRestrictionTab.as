

import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;

import mx.collections.ArrayCollection;
import mx.events.ValidationResultEvent;
import mx.rpc.events.ResultEvent;

[Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);

[Bindable]private var xmlResponse:XML = new XML();
[Bindable]private var editedRestrictionList:XML = new XML();

[Bindable]private var restrictionSummaryResult:ArrayCollection;
[Bindable]public var restrictionValueList:ArrayCollection;


override public function populateRequest():Object{
	var reqObj:Object = new Object();
	if(this.mode == "entry")
		reqObj['SCREEN_KEY'] = 20;
	else 
		reqObj['SCREEN_KEY'] = 25;
	
	return reqObj;
}

override public function reset():void {	
	
}

override public function  initPage(responseObj:XML):void{
	//reset();
	//trace("initPage1" + this);
	xmlResponse = responseObj as XML;
	
	errPage.removeError();
	
	restrictionValueList = new ArrayCollection();
	restrictionValueList.addItem({label: " " , value : " "});
	for each(var xmlObj:Object in xmlResponse.restrictionValues.item){
		restrictionValueList.addItem(xmlObj);
	}
	
	//for reset
	restrictionData.selectedIndex=0;
	startDate.text = XenosStringUtils.EMPTY_STR;
	endDate.text = XenosStringUtils.EMPTY_STR;
	
	//Security code
	securitycode.text = xmlResponse.defaultInstrumentCode;
	
	//Instrument Code type 
	instrumentcodetype.text = xmlResponse.instrumentPage.instrumentType;
	
	//Short name
	shortname.text = xmlResponse.defaultShortName;
	
	//have to populate from form
	restrictionSummaryResult=new ArrayCollection();
	if(xmlResponse.child("restrictionsWrapper").length()>0) {
	    for each ( var rec:XML in xmlResponse.restrictionsWrapper.restrictions) {			    	
 		    restrictionSummaryResult.addItem(rec);
	    }
	}
}


private function loadAll():void{
//	reset();
//	instrumentType.setFocus();
}

override public function  validate():ValidationResultEvent{
	
	return new ValidationResultEvent(ValidationResultEvent.VALID);        	
}

/**
 * To add Restriction Information
 */
private function addRestriction():void{
	if(XenosStringUtils.isBlank(restrictionData.text)){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.missing.restriction'));
		return;
	}else if(XenosStringUtils.isBlank(startDate.text)){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.instrument.msg.error.missing.startdate'));
		return;
	}
	addRestrictionService.request = populateRestriction();
	 if(this.mode == "amend")
		addRestrictionService.url = "ref/instrumentAmendDispatch.action?method=addRestriction"
	else 
		addRestrictionService.url = "ref/instrumentEntryDispatch.action?method=addRestriction"
	addRestrictionService.send();
}

public function editRestriction(data:Object):void{
	var reqObj : Object = new Object();
	reqObj.rowNo = restrictionSummaryResult.getItemIndex(data);
	restrictionSummaryResult.removeItemAt(reqObj.rowNo);
	//data.isVisible=false;
	restrictionSummaryResult.refresh();
	 if(this.mode == "amend")
		editRestrictionService.url = "ref/instrumentAmendDispatch.action?method=editRestriction"
	else 
		editRestrictionService.url = "ref/instrumentEntryDispatch.action?method=editRestriction"
	editRestrictionService.request = reqObj;
	editRestrictionService.send();
}

 public function deleteRestriction(data:Object):void{
	var reqObj : Object = new Object();
	reqObj.rowNo = restrictionSummaryResult.getItemIndex(data);
	 if(this.mode == "amend")
		deleteRestrictionService.url = "ref/instrumentAmendDispatch.action?method=deleteRestriction"
	else 
		deleteRestrictionService.url = "ref/instrumentEntryDispatch.action?method=deleteRestriction"
	deleteRestrictionService.request = reqObj;
	deleteRestrictionService.send();
}


/**
* This method works as the result handler of the Submit Query Http Services for Restrictions.
* 
*/
public function RestrictionResult(event:ResultEvent):void {
    var rs:XML = XML(event.result);

	if (null != event) {
		 if(rs.child("restrictionsWrapper").length()>0) {
		 	
			errPage.clearError(event);
			// if(this.mode != "AMEND")
            	restrictionSummaryResult.removeAll(); 
			try {
			    for each ( var rec:XML in rs.restrictionsWrapper.restrictions ) {
			    	rec.isVisible = true;
 				    restrictionSummaryResult.addItem(rec);
			    }
			    restrictionData.selectedIndex=0;
			    startDate.text = "";
			    endDate.text ="";
			   
            	restrictionSummaryResult.refresh();
            	
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
		 	restrictionSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
    
    
}

/**
* This method works as the result handler of the Submit Query Http Services for Restrictions.
* 
*/
public function RestrictionEditResult(event:ResultEvent):void {
    var rs:XML = XML(event.result);

	if (null != event) {
		if(rs.child("restrictionsWrapper").length()>0){
			
			editedRestrictionList = rs;
			
			for(var i:int=0; i<restrictionValueList.length; i++){
				if(restrictionValueList.getItemAt(i).value == rs.resSelectedItem.toString()){
					restrictionData.selectedIndex = i;
				}
			}
			
			startDate.text=rs.startDate.toString();
			endDate.text=rs.endDate.toString();
			
		} else if(rs.child("Errors").length()>0) {
            //some error found
		 	restrictionSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);//Display the error
		 } else {
		 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		 	restrictionSummaryResult.removeAll(); // clear previous data if any as there is no result now.
		 	errPage.removeError(); //clears the errors if any
		 }
    }
    
    
}

private function populateRestriction():Object{
	var reqObj : Object = new Object();
	reqObj['resSelectedItem'] = this.restrictionData.selectedItem != null ? this.restrictionData.selectedItem.value : "";
	
	reqObj['startDate'] = this.startDate.text != null ? this.startDate.text : "";
	
	reqObj['endDate'] = this.endDate.text != null ? this.endDate.text : "";
	
	return reqObj;
}
