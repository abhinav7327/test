
 
import com.nri.rui.core.utils.XenosStringUtils;

import mx.collections.ArrayCollection;
import mx.events.ValidationResultEvent;
import mx.utils.StringUtil;

[Bindable] public var xml:XML;
 
override public function populateRequest():Object {
	
	return this.cbWarrantPopulator.populateRequest();
	
} 
	
override public function initPage(response:XML):void {
	xml = response as XML;
	
	return this.cbWarrantPopulator.initPage(xml);
}
	
override public function reset():void {
	this.cbWarrantPopulator.reset();
}	

override public function validate():ValidationResultEvent{
	return this.cbWarrantPopulator.validate();
}
