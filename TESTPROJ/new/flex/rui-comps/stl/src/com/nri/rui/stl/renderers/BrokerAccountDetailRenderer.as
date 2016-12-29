
package com.nri.rui.stl.renderers
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.renderers.AccountDetailsRenderer;
	import com.nri.rui.core.utils.XenosPopupUtils;
	
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	
	public class BrokerAccountDetailRenderer extends AccountDetailsRenderer
	{
		public function BrokerAccountDetailRenderer()
		{
			super();
		}
		override public function handleMouseClick(event:MouseEvent):void {
			var brkAccountPk:Number = new Number(data.brokerAccountPk);
			if(brkAccountPk>0) {
				var parentApp :UIComponent = UIComponent(this.parentApplication);
				XenosPopupUtils.showAccountSummary(data.brokerAccountPk,parentApp);
			} else {
				XenosAlert.info(this.parentApplication
									.xResourceManager
									.getKeyValue('stl.label.broker.account.not.registered'));
			}
		}
	}
}