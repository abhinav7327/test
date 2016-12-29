
package com.nri.rui.ref.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.utils.XenosPopupUtils;
	import com.nri.rui.core.controls.XenosAlert;
	
	import flash.events.MouseEvent;
	
	//import mx.controls.DataGrid;
	import mx.controls.Text;
	//import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import mx.utils.StringUtil;

	public class IntraReconDetailsRenderer extends Text
	{
		
		public function IntraReconDetailsRenderer()
		{
			super();
			//addEventListener(MouseEvent.CLICK, handleMouseClick);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			 super.updateDisplayList(unscaledWidth, unscaledHeight);
				
		}
		
		override public function set data(value:Object):void{
			super.data = value;
			setVisibleProp();
		}
		
		private function setVisibleProp():void{
			
			var visibleFlag : Boolean = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
			buttonMode = visibleFlag;
			useHandCursor = visibleFlag;
			mouseChildren = !visibleFlag;
			if(visibleFlag){
				setStyle("color",0x007ac8);
				setStyle("textDecoration","underline");
				addEventListener(MouseEvent.CLICK, handleMouseClick);
			}
			else{
				if(hasEventListener(MouseEvent.CLICK))
					removeEventListener(MouseEvent.CLICK,handleMouseClick);
				setStyle("color",0x000000);
				setStyle("textDecoration","normal");
				
			}
			
		}
		
		public function handleMouseClick(event:MouseEvent):void {
			
			var intraReconPk : String = data.intraReconPk;
			var method : String  = "doView";
			var reportName : String  = data.reportName;
			var reportId : String  = data.reportId;
			//XenosAlert.info(method + reportName + reportId);
			
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			XenosPopupUtils.showIntraReconSummary(intraReconPk,method,reportName,reportId,parentApp);
		}
		override public function validateProperties():void{
			super.validateProperties();
		}	
	}
}