
package com.nri.rui.stl.renderers
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.renderers.FinancialInstitutionDetailsRenderer;
	import com.nri.rui.core.utils.XenosPopupUtils;
	
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	
	public class BrokerBankDetailRenderer extends FinancialInstitutionDetailsRenderer
	{
		public function BrokerBankDetailRenderer()
		{
			super();
		}
		override public function handleMouseClick(event:MouseEvent):void {
			var brkBankPk:Number = new Number(data.brokerBankPk);
			if(brkBankPk>0) {
				var parentApp :UIComponent = UIComponent(this.parentApplication);
				XenosPopupUtils.showFinInstDetails(data.brokerBankPk,parentApp);
			} else {
				XenosAlert.info(this.parentApplication
									.xResourceManager
									.getKeyValue('stl.label.broker.bank.not.registered'));
			}
		}
	}
}