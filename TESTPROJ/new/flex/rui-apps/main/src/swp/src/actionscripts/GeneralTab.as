

import com.nri.rui.core.Globals;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.swp.validator.TradeGeneralEntryValidator;

import mx.collections.ArrayCollection;
import mx.events.ValidationResultEvent;
import mx.utils.StringUtil;
import com.nri.rui.core.controls.XenosAlert;

[Bindable]public var xml:XML;

	//Items returning through context - Non display objects for accountPopup
	[Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
	[Bindable]public var productTypeList:ArrayCollection = new ArrayCollection();
	[Bindable]public var notionalExchangeFlagList:ArrayCollection = new ArrayCollection();

	[Bindable] private var terminationMode : Boolean = false ;
	
	override public function initPage(response:XML):void {
		var obj:Object=new Object();	
		xml = response as XML;
		//XenosAlert.info("Mode1 : " + xml.modeOfOperation);
		//XenosAlert.info("Mode2 : " + mode);
		
		if (XenosStringUtils.equals(xml.modeOfOperation , "TERMINATION")) {
			terminationMode = true ;
		}
		
		//setting Fund Account no
		fundAccountNo.accountNo.text = xml.trade.fundAccountNoStr ;
		
		// Populate Product Type drop down
	    productTypeList.removeAll();
	    productTypeList.addItem({label:"SELECT", value:""});
	    for each(obj in xml.swapFormListValues.productType.item){
	    	productTypeList.addItem(obj);
	    }
	    productType.selectedIndex = getIndexOfLabelValueBean(productTypeList, xml.trade.productTypeLbl);
		checkProductType();
		
		//setting Account no
		accountNo.accountNo.text = xml.trade.accountNoStr ;
		
		// Populate Notional Exchange Flag drop down
	    notionalExchangeFlagList.removeAll();
	    notionalExchangeFlagList.addItem({label:"SELECT", value:""});
	    for each(obj in xml.swapFormListValues.notionalExchangeFlagList.item){
	    	notionalExchangeFlagList.addItem(obj);
	    }
	    notionalExchangeFlag.selectedIndex = getIndexOfLabelValueBean(notionalExchangeFlagList, xml.trade.notionalExchangeFlag);
	    
	    //setting Trade Date
	    tradeDateStr.text = xml.trade.tradeDateStr ;
	    
	    //setting Effective Date
		effectiveDateStr.text = xml.trade.effectiveDateStr ;
		
		//setting Maturity Date
		maturityDateStr.text = xml.trade.maturityDateStr ;
		
		//setting External Reference No
		externalRefNo.text = xml.trade.externalReferenceNo ;
		
	    //setting Remarks
	    remarks.text = xml.trade.remarks ;
	    
	    if (XenosStringUtils.equals(mode , "amend")) {
	    	fundAccountNo.enabled = false ;
			//fundAccountNo.accountNo.enabled = false ;
			//fundAccountNo.accountPopup.enabled = false ;
			productType.enabled = false ;
			accountNo.enabled = false ;
			//accountNo.accountNo.enabled = false ;
			//accountNo.accountPopup.enabled = false ;
		}
		
		if(terminationMode){
			terminationDateStr.text = xml.trade.terminationDateStr ;
		}
	}
	/**
	 * validate general tab
	 */    
	override public function  validate():ValidationResultEvent {
	    var validator:TradeGeneralEntryValidator = new TradeGeneralEntryValidator();
	    var model:Object = populateRequest();
	    return validator.validate(model);  	
	}
	/**
	 * populate general tab
	 */
	override public function populateRequest():Object {
		
		var reqObj:Object = new Object();
		reqObj.srcTabNo = "1";
		
		reqObj["TERMINATION_MODE"] = terminationMode;
		if (!terminationMode) {
			reqObj['SCREEN_KEY'] 					   = 12031;//need to change during amend
			reqObj['tradeObj.fundAccountNoStr']        = StringUtil.trim(fundAccountNo.accountNo.text);
			reqObj['tradeObj.productTypeLbl']          = StringUtil.trim(this.productType.selectedItem != null? this.productType.selectedItem.value: "");
			reqObj['tradeObj.accountNoStr']            = StringUtil.trim(accountNo.accountNo.text);
			reqObj['tradeObj.notionalExchangeFlag']    = StringUtil.trim(this.notionalExchangeFlag.selectedItem != null? this.notionalExchangeFlag.selectedItem.value: "");
			reqObj['tradeObj.tradeDateStr']            = StringUtil.trim(tradeDateStr.text);
			reqObj['tradeObj.effectiveDateStr']        = StringUtil.trim(effectiveDateStr.text);
		    reqObj['tradeObj.maturityDateStr']         = StringUtil.trim(maturityDateStr.text);
		    reqObj['tradeObj.externalReferenceNo']     = StringUtil.trim(externalRefNo.text);
		    reqObj['tradeObj.remarks']                 = StringUtil.trim(remarks.text);
		} else {
			reqObj['tradeObj.tradeDateStr']            = StringUtil.trim(tradeDateStr.text);
			reqObj['tradeObj.effectiveDateStr']        = StringUtil.trim(effectiveDateStr.text);
		    reqObj['tradeObj.maturityDateStr']         = StringUtil.trim(maturityDateStr.text);
			reqObj['tradeObj.terminationDateStr']      = StringUtil.trim(terminationDateStr.text);
		}
		return reqObj;
	}

	override public function reset():void {
	}

	/**
	  * This is the method to pass the Collection of data items
	  * through the context to the account popup. This will be implemented as per specifdic  
	  * requriment. 
	  */
	private function populateActContext():ArrayCollection {
		//pass the context data to the popup
		var myContextList:ArrayCollection = new ArrayCollection(); 
		  
		//passing act type                
		var actTypeArray:Array = new Array(1);
		actTypeArray[0]="T|B";
		myContextList.addItem(new HiddenObject("actTypeContext",actTypeArray));    
		          
		//passing counter party type                
		var cpTypeArray:Array = new Array(1);	
		cpTypeArray[0]="BROKER";
		myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
		
		//passing account status                
		var actStatusArray:Array = new Array(1);
		actStatusArray[0]="OPEN";
		myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
		return myContextList;
	}
	
	/**
	  * This is the method to pass the Collection of data items
	  * through the context to the fund account popup. This will be implemented as per specifdic  
	  * requriment. 
	  */
	private function populateFundActContext():ArrayCollection {
	    //pass the context data to the popup
	    var myContextList:ArrayCollection = new ArrayCollection(); 
	      
	    //passing act type                
	    var actTypeArray:Array = new Array(1);
	    actTypeArray[0]="T|B";
	    myContextList.addItem(new HiddenObject("actTypeContext",actTypeArray));    
	              
	    //passing counter party type                
	    var cpTypeArray:Array = new Array(1);
	    cpTypeArray[0]="INTERNAL";
	    myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
	    
	    //passing account status                
	    var actStatusArray:Array = new Array(1);
	    actStatusArray[0]="OPEN";
	    myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
	    return myContextList;
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
	 * Check Product Type selection and based on that 
	 * sets the Notional Exchange Flag value
	 * */
	private function checkProductType():void {
		var selVal:String = productType.selectedItem.label;
		
		if(XenosStringUtils.equals(selVal,Globals.IRS_LABEL)) {
			notionalExchangeFlag.selectedIndex = 2;
			notionalExchangeFlag.enabled = false;
		} else {
			notionalExchangeFlag.selectedIndex = 0;
			notionalExchangeFlag.enabled = true;
		}
	}