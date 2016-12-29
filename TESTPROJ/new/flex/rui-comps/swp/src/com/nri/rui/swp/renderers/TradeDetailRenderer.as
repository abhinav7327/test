package com.nri.rui.swp.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.containers.SummaryPopup;
	
	import flash.events.MouseEvent;
	
	import mx.controls.DataGrid;
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;

	public class TradeDetailRenderer extends Text {
  		
		//var column : DataGridColumn=null;
		
		public function TradeDetailRenderer() {
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
    		 super.updateDisplayList(unscaledWidth, unscaledHeight);
    	}
    	
    	override public function set data(value:Object) : void {
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
			
			var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
			
			sPopup.title = this.parentApplication.xResourceManager.getKeyValue('swp.details.title');
			sPopup.width = this.parentApplication.width - 100;
    		sPopup.height = this.parentApplication.height - 100;
			PopUpManager.centerPopUp(sPopup);		
			var tradePkStr : String = data.tradePk;
			sPopup.moduleUrl = Globals.SWP_TRADE_DETAILS_SWF + Globals.QS_SIGN + Globals.TRADE_PK
							   + Globals.EQUALS_SIGN + tradePkStr ;
			
		}
	}
}
