// ActionScript file

package com.nri.rui.trd.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.containers.SummaryPopup;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.controls.Label;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;

	public class AdvTradeDetailRenderer extends Label
	{
		private var column : DataGridColumn=null;
		public function AdvTradeDetailRenderer()
		{
			super();
		}
		/**
         * Overridden the updateDisplayList method to display the columns values
         * in different colors, in button mode, with Hand cursor etc.
         */ 
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
			var sPopup : SummaryPopup;	
			var allocTradePkStr : String="";
			if(listData){
    		     var dg : DataGrid = DataGrid(listData.owner);
    			 column = dg.columns[listData.columnIndex];
    		 }
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
			if(column.dataField == "allocationTradePk"){				
			    sPopup.title = Application.application.xResourceManager.getKeyValue('trd.alloc.trade.detail');
			    allocTradePkStr=data.allocationTradePk;
			}else if(column.dataField == "tradePk"){								
			    sPopup.title = Application.application.xResourceManager.getKeyValue('trd.conf.trade.detail');
			    allocTradePkStr=data.tradePk;
			}
			sPopup.width = 650;
    		sPopup.height = 420;
			PopUpManager.centerPopUp(sPopup);
			sPopup.moduleUrl = Globals.TRADE_DETAILS_SWF+Globals.QS_SIGN+Globals.TRADE_PK+Globals.EQUALS_SIGN+allocTradePkStr+Globals.AND_SIGN+"MODE"+Globals.EQUALS_SIGN+"QUERY";
			
		}
	}
}