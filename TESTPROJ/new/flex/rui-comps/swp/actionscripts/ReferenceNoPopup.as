import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.utils.XenosStringUtils;

import mx.collections.ArrayCollection;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

[Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
[Bindable]private var pageNo :int = 1;
[Bindable]private var _mode : String = "";

public function set mode (m : String) : void {
	_mode = m ;
}

/**
 * This API will clear the result page to empty page
 */
public function clearResultPage():void
{	
	summaryResult.removeAll();
	nextPage.enabled = false;
	prevPage.enabled = false;
	pageNo = 1;
}

/**
 * It sets the enable property of the Next and Previous button
 * depending on the result set, whether available or not
 */
public function setPrevNextVisibility(prev:Boolean, next:Boolean):void
{
	this.prevPage.enabled = prev;
	this.nextPage.enabled = next;
	if(prev){
	    prevPage.toolTip ="Previous/"+(pageNo-1);
	}else{
	    prevPage.toolTip = "Previous";
	}
	if(next){
	    nextPage.toolTip ="Next/"+(pageNo+1);
	}else{
	    nextPage.toolTip = "Next";
	}
}

/**
 * Populate the query result information to the account query summary page.
 * @param ResultEvent the result set event object.
 */      
public override function populatePopUpQuerySummaryPage(event:ResultEvent):void
{    
    var rs:XML = XML(event.result);    
    if (null != event) {
	    if(rs.child("row").length()>0) {
	        errPage.clearError(event);
	        summaryResult.removeAll();
	        try {
	            for each ( var rec:XML in rs.row ) {
	                summaryResult.addItem(rec);
	            }
	            changeCurrentState();
	            setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
	            summaryResult.refresh();
	            
	        }catch(e:Error){	            
	            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	        }
	     } else if(rs.child("Errors").length()>0) {
	        //some error found
	        summaryResult.removeAll(); // clear previous data if any as there is no result now.
	        var errorInfoList : ArrayCollection = new ArrayCollection();
	        //populate the error info list              
	        for each ( var error:XML in rs.Errors.error ) {
	           errorInfoList.addItem(error.toString());
	        }
	        errPage.showError(errorInfoList);//Display the error
	     } else {
	        XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	        summaryResult.removeAll(); // clear previous data if any as there is no result now.
	        errPage.removeError(); //clears the errors if any
	     }
    }
}

/**
 * The Fault Event Handler used for error in query result http service
 * @param event The fault Event
 * 
 */        
public function popUpQueryRequestErrorHand(event:FaultEvent):void
{
    var errorMsg : String = this.parentApplication.xResourceManager.getKeyValue('ref.comp.label.error') + event.fault.faultString + 'Error Occured!';
    XenosAlert.error(errorMsg);
}

/**
  * This will return the account number selected from the popup 
  * window to the main application.
  */  
public function returnRefNo():void
{
    if (refNoSummary.selectedItem != null)
	{
		var retReferenceNo : String = new String(refNoSummary.selectedItem.contractReferenceNo); 
		retTxtInput.text = retReferenceNo;
		super.closeWindow();
		focusManager.setFocus(retTxtInput);		
	}
}

/**
  * This will initialize the account pop up query page.
  * @param ResultEvent the result set event object.
  */
public override function populatePopUpQueryPage(event: ResultEvent) : void
{
	var deliveryReceiveFlagList: ArrayCollection = null;
	var fixedFloatingTypeList: ArrayCollection = null;
	var interestRateTypeList: ArrayCollection = null;
	
	var officeIdListArray: ArrayCollection = null;
    var statusList: ArrayCollection = null;
    var productTypeList: ArrayCollection = null;
    var paymentFrequencyList: ArrayCollection = null;
    
    // Populate the delivery receive flag combo
    deliveryReceiveFlagList = new ArrayCollection();
    if(event.result.contractPopupQueryActionForm.deliveryReceiveFlagList.item is ArrayCollection) {
        deliveryReceiveFlagList = event.result.contractPopupQueryActionForm.deliveryReceiveFlagList.item as ArrayCollection;
    } else {
        deliveryReceiveFlagList = new ArrayCollection();
        deliveryReceiveFlagList.addItem(event.result.contractPopupQueryActionForm.deliveryReceiveFlagList.item);
    }
    deliveryReceiveFlag.dataProvider = deliveryReceiveFlagList;
    
    // Populate the fixed-floating list combo
    fixedFloatingTypeList = new ArrayCollection();
    if(event.result.contractPopupQueryActionForm.fixedFloatingTypeList.item is ArrayCollection) {
        fixedFloatingTypeList = event.result.contractPopupQueryActionForm.fixedFloatingTypeList.item as ArrayCollection;
    } else {
        fixedFloatingTypeList = new ArrayCollection();
        fixedFloatingTypeList.addItem(event.result.contractPopupQueryActionForm.fixedFloatingTypeList.item);
    }
    fixedFloatingType.dataProvider = fixedFloatingTypeList;
    
    // Populate the interest rate type combo
    interestRateTypeList = new ArrayCollection();
    if(event.result.contractPopupQueryActionForm.interestRateTypeList.item is ArrayCollection) {
        interestRateTypeList = event.result.contractPopupQueryActionForm.interestRateTypeList.item as ArrayCollection;
    } else {
        interestRateTypeList = new ArrayCollection();
        interestRateTypeList.addItem(event.result.contractPopupQueryActionForm.interestRateTypeList.item);
    }
    interestRateType.dataProvider = interestRateTypeList;
    
    // Populate the product type combo
    productTypeList = new ArrayCollection();
    if(event.result.contractPopupQueryActionForm.productTypeList.item is ArrayCollection) {
        productTypeList = event.result.contractPopupQueryActionForm.productTypeList.item as ArrayCollection;
    } else {
        productTypeList = new ArrayCollection();
        productTypeList.addItem(event.result.contractPopupQueryActionForm.productTypeList.item);
    }
    productType.dataProvider = productTypeList;
    
    // Populate the payment frequency combo
    paymentFrequencyList = new ArrayCollection();
    if(event.result.contractPopupQueryActionForm.paymentFrequencyList.item is ArrayCollection) {
        paymentFrequencyList = event.result.contractPopupQueryActionForm.paymentFrequencyList.item as ArrayCollection;
    } else {
        paymentFrequencyList = new ArrayCollection();
        paymentFrequencyList.addItem(event.result.contractPopupQueryActionForm.paymentFrequencyList.item);
    }
    paymentFrequency.dataProvider = paymentFrequencyList;
   
    // Populate the office id combo
    officeIdListArray = new ArrayCollection();
    var item:Object = new Object();    
    if(event.result.contractPopupQueryActionForm.officeList.officeList is ArrayCollection) {
    	for each(item in event.result.contractPopupQueryActionForm.officeList.officeList)    	
        officeIdListArray.addItem(item);
    } else {        
        officeIdListArray.addItem(event.result.contractPopupQueryActionForm.officeList.officeList);
    }
    officeIdList.dataProvider = officeIdListArray;
    
    // Populate the status combo
    statusList = new ArrayCollection();
    if(event.result.contractPopupQueryActionForm.statusList.item is ArrayCollection) {
        statusList = event.result.contractPopupQueryActionForm.statusList.item as ArrayCollection;
    } else {
        statusList = new ArrayCollection();
        statusList.addItem(event.result.contractPopupQueryActionForm.statusList.item);
    }
    statusCombo.dataProvider = statusList;
    
    //set default values
    contractReferenceNo.text = event.result.contractPopupQueryActionForm.contractReferenceNo;
    fundPopUp.fundCode.text = event.result.contractPopupQueryActionForm.fundCode;
    inventoryAccountNo.accountNo.text = event.result.contractPopupQueryActionForm.inventoryAccountNoStr;
    accountNo.accountNo.text = event.result.contractPopupQueryActionForm.accountNoStr;
    officeIdList.selectedIndex = getIndexOfLabelValueBean(officeIdListArray, event.result.contractPopupQueryActionForm.officeId);
    productType.selectedIndex = getIndexOfLabelValueBean(productTypeList, event.result.contractPopupQueryActionForm.productType);
    deliveryReceiveFlag.selectedIndex = getIndexOfLabelValueBean(deliveryReceiveFlagList, event.result.contractPopupQueryActionForm.deliveryReceiveFlag);
    interestRateType.selectedIndex = getIndexOfLabelValueBean(interestRateTypeList, event.result.contractPopupQueryActionForm.interestRateType);
    fixedFloatingType.selectedIndex = getIndexOfLabelValueBean(fixedFloatingTypeList, event.result.contractPopupQueryActionForm.fixedFloatingType);
    paymentFrequency.selectedIndex = getIndexOfLabelValueBean(paymentFrequencyList, event.result.contractPopupQueryActionForm.paymentFrequency);
    if(!XenosStringUtils.equals(_mode,Globals.TRD_QUERY_MODE)){
    	statusCombo.selectedIndex = getIndexOfLabelValueBean(statusList, Globals.STATUS_NORMAL);
    	statusCombo.enabled = false;
    }else{
    	statusCombo.selectedIndex = getIndexOfLabelValueBean(statusList, event.result.contractPopupQueryActionForm.status);
    	statusCombo.enabled = true;
    }
}

/**
 * This method will populate the request parameters for the
 * submitQuery call and bind the parameters with the HTTPService
 * object.
 */
private function populateRequestParams():Object
{
	var reqObj : Object = new Object();
    reqObj.method = "submitQuery";
    
    reqObj.productType = (this.productType.selectedItem != null) ? this.productType.selectedItem.value : ""; 
    reqObj.officeId = (this.officeIdList.selectedItem != null) ? this.officeIdList.selectedItem.value : "";
    reqObj.fundCode = this.fundPopUp.fundCode.text;
    reqObj.inventoryAccountNoStr = this.inventoryAccountNo.accountNo.text;
    reqObj.accountNoStr = this.accountNo.accountNo.text;    
    reqObj.contractReferenceNo = this.contractReferenceNo.text;
    reqObj.status = (this.statusCombo.selectedItem != null) ? this.statusCombo.selectedItem.value : "";
    reqObj.deliveryReceiveFlag = (this.deliveryReceiveFlag.selectedItem != null) ? this.deliveryReceiveFlag.selectedItem.value : "";
    reqObj.interestRateType = (this.interestRateType.selectedItem != null) ? this.interestRateType.selectedItem.value : "";
    reqObj.fixedFloatingType = (this.fixedFloatingType.selectedItem != null) ? this.fixedFloatingType.selectedItem.value : "";
    reqObj.paymentCurrency = this.paymentCurrency.ccyText.text;
    reqObj.paymentFrequency = (this.paymentFrequency.selectedItem != null) ? this.paymentFrequency.selectedItem.value : "";
    reqObj.unique = new Date().getTime() + ""; 
     
    return reqObj;
}

/**
 * Submit the account query page.
 */
public override function submitQuery():void
{ 
	//Set the request parameters
	var requestObj :Object = populateRequestParams();
	popUpQueryRequestObj.request = requestObj;             
	popUpQueryRequestObj.url = "swp/contractPopupSearch.action"; 
	popUpQueryRequestObj.send();
}

/**
 * Reset the account query page. 
 */
public override function resetQuery():void
{	
	super.initPopup();
	errPage.clearError(null);
	clearResultPage();
	  
	refNoPopupQueryPnl.percentWidth=100;
	resultPnl.percentWidth=100;
	
	//clearing fields
	this.accountNo.accountNo.text = XenosStringUtils.EMPTY_STR;
	this.inventoryAccountNo.accountNo.text = XenosStringUtils.EMPTY_STR;
	this.paymentCurrency.ccyText.text = XenosStringUtils.EMPTY_STR;
	this.fundPopUp.fundCode.text = XenosStringUtils.EMPTY_STR;
	this.contractReferenceNo.text = XenosStringUtils.EMPTY_STR;
}

private function doPrev():void
{
	pageNo--;
	page.text = pageNo+"";
	rndNo= Math.random();
	popUpQueryDoPrevious.resultFormat="xml";
	popUpQueryDoPrevious.url=mapping + "?method=doPrevious&rnd="+ rndNo;
	popUpQueryDoPrevious.send();
}

private function doNextPage():void
{
	pageNo++;
	page.text = pageNo+"";
	rndNo= Math.random();
	popUpQueryDoNext.resultFormat="xml";
	popUpQueryDoNext.url=mapping + "?method=doNext&rnd="+ rndNo;
	popUpQueryDoNext.send();
}

/**
 * The view state handler.
 * This is used to changed the view state between Query and Query Result container. 
 */  
private function changeCurrentState():void
{
    //this.currentState = "qryres";
}

/**
	 * Calculates the index of a label value bean given its value, within a given 
	 * array collection of such beans.
	 * Returns 0 if the value is null or empty string.
	 */
	private function getIndexOfLabelValueBean(collection:ArrayCollection, value:String):int {
	    var index:int = -1;
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