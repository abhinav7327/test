
package com.nri.rui.slr.renderers
{
	
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.containers.SummaryPopup;
	import com.nri.rui.core.controls.XenosAlert;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;

	public class ActionDetailRenderer extends Text
	{
		var column : DataGridColumn=null;
		public function ActionDetailRenderer()
		{
			super();
			
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
				//removeEventListener(MouseEvent.CLICK,handleMouseClick);
			}
			
		}
		
		public function handleMouseClick(event:MouseEvent):void {
			
			var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
			sPopup.title = this.parentApplication.xResourceManager.getKeyValue('slr.label.axndetails');
			sPopup.width = 700;
    		sPopup.height = 500;
			PopUpManager.centerPopUp(sPopup);		
			var actionPkStr : String = data.actionPk;
			sPopup.moduleUrl = "assets/appl/slr/ActionDetailView.swf?&actionPk="+actionPkStr;
		}
	}
}
