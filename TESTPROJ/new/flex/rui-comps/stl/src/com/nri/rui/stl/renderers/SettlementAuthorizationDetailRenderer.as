
package com.nri.rui.stl.renderers
{
	import com.nri.rui.core.utils.XenosPopupUtils;
	
	import flash.events.MouseEvent;
	
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;


	public class SettlementAuthorizationDetailRenderer extends SettlementDetailRenderer
	{
		
		public function SettlementAuthorizationDetailRenderer()
		{
			super();			
		}	
		
		
		 public override function handleMouseClick(event:MouseEvent):void {
						
			stlPkStr = data.settlementInfoPk;
			viewMode = "Instruction";
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			XenosPopupUtils.showSettlementDetails(stlPkStr,
												  parentApp,
												  this.parentApplication.xResourceManager.getKeyValue('stl.stlqry.label.settlementviewheader'),
												  viewMode);
					
		} 		
	}
}
