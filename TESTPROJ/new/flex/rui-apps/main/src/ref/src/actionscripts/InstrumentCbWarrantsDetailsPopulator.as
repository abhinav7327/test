
 
import com.nri.rui.core.utils.XenosStringUtils;

import mx.collections.ArrayCollection;
import mx.events.ValidationResultEvent;
import mx.utils.StringUtil;


[Bindable] private var linkTypeValues:ArrayCollection = null;
[Bindable] private var detachTypeValues:ArrayCollection = null;
[Bindable] private var contingentValues:ArrayCollection = null;
[Bindable] private var convertibleFlagValues:ArrayCollection = null;
[Bindable] public var xml:XML;
[Bindable] public var mode:String;
[Bindable] public var isCb:Boolean = false;
[Bindable] private var dynaTitle:String;
 
public function populateRequest():Object {
	
	var request:Object = new Object();
	
	request['instrumentPage.linkType'] = StringUtil.trim(linkedTypeList.selectedItem.toString()); 
	request['instrumentPage.subscriptionCode'] = subscriptionCodeBox.instrumentId.text; 
	request['instrumentPage.conversionBaseQty'] = conversionBaseQtyStr.text; 
	request['instrumentPage.conversionAllotedQty'] = conversionAllotedQtyStr.text; 
	request['instrumentPage.convertible'] = StringUtil.trim(convertibleFlagList.selectedItem.value); 
	request['instrumentPage.contingent'] = StringUtil.trim(contingentList.selectedItem.value);
	 
	request['instrumentPage.conversionStartDateStr'] = conversionStartDateStr.text; 
	request['instrumentPage.conversionEndDateStr'] = conversionEndDateStr.text;
	request['instrumentPage.conversionPriceStr'] = conversionPriceStr.text;
  	request['instrumentPage.conversionPriceCcy'] = conversionPriceCcyBox.ccyText.text;
	request['instrumentPage.conversionForexRateStr'] = conversionForexRateStr.text;
	request['instrumentPage.warrantDetachType'] = StringUtil.trim(detachTypeList.selectedItem.value);  

	if(this.mode == "entry")
		request['SCREEN_KEY'] = 20;
	else 
		request['SCREEN_KEY'] = 25;
		
	return request;
} 
	
public function initPage(response:XML):void {
	xml = response as XML;
	
	//Linked Type
	linkTypeValues = new ArrayCollection();
	linkTypeValues.addItem(" ");
	for each(var obj:Object in xml.instrumentPage.linkTypeValuesWrapper.linkTypeValue) {
		linkTypeValues.addItem(obj);
	}
	linkedTypeList.selectedIndex = getIndex(linkTypeValues, xml.instrumentPage.linkType);
	
	//Underlying Security Code
	subscriptionCodeBox.instrumentId.text = xml.instrumentPage.subscriptionCode;
	
	//Conversion Base Qty
	conversionBaseQtyStr.text = xml.instrumentPage.conversionBaseQty;
	
	//Conversion Allotted Qty
	conversionAllotedQtyStr.text = xml.instrumentPage.conversionAllotedQty;
	
	//Convertible Flag
	convertibleFlagValues = new ArrayCollection();
	for each(var obj3:Object in xml.instrumentPage.convertibleFlagValuesList.item) {
		convertibleFlagValues.addItem(obj3);
	}
	convertibleFlagList.selectedIndex = getIndexOfLabelValueBean(convertibleFlagValues, xml.instrumentPage.convertible);
	
	//Contingent
	contingentValues = new ArrayCollection();
	contingentValues.addItem({label:" ", value:" "});
	for each(var obj2:Object in xml.instrumentPage.contingentValuesList.item) {
		contingentValues.addItem(obj2);
	}
	contingentList.selectedIndex = getIndexOfLabelValueBean(contingentValues, xml.instrumentPage.contingent);
	
	//Conversion Start Date
	conversionStartDateStr.text = xml.instrumentPage.conversionStartDateStr;
	
	//Conversion End Date
	conversionEndDateStr.text = xml.instrumentPage.conversionEndDateStr;
	
	//Conversion Price
	conversionPriceStr.text = xml.instrumentPage.conversionPriceStr;
	
	//Conversion Price Ccy
	conversionPriceCcyBox.ccyText.text = xml.instrumentPage.conversionPriceCcy;
	
	//Conversion Forex Rate
	conversionForexRateStr.text = xml.instrumentPage.conversionForexRateStr;
	
	//Detach Type
	detachTypeValues = new ArrayCollection();
	detachTypeValues.addItem({label:" ", value:" "});
	for each(var obj1:Object in xml.instrumentPage.warrantDetachTypeValuesList.item) {
		detachTypeValues.addItem(obj1);
	}
	detachTypeList.selectedIndex = getIndexOfLabelValueBean(detachTypeValues, xml.instrumentPage.warrantDetachType);
	
}

	
public function reset():void {
}	

public function validate():ValidationResultEvent{
	return new ValidationResultEvent(ValidationResultEvent.VALID);
}


private function validateNumber(event:FocusEvent):void{
	numVal1.source = TextInput(event.currentTarget);
	numVal1.handleNumericField(numberFormatter);
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
