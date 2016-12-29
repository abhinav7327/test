// ActionScript file

package com.nri.rui.trd.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.containers.SummaryPopup;
	
	import flash.events.MouseEvent;
	
	import mx.controls.DataGrid;
	import mx.controls.Label;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;

	public class TradeAllocConfRenderer extends Label
	{
		private var column : DataGridColumn=null;
		public function TradeAllocConfRenderer()
		{
			super();
			addEventListener(MouseEvent.CLICK, handleMouseClick);
		}
		/**
         * Overridden the updateDisplayList method to display the columns values
         * in different colors, in button mode, with Hand cursor etc.
         * 
         */ 
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
    		 super.updateDisplayList(unscaledWidth, unscaledHeight);
    		 if(listData){
    		     var dg : DataGrid = DataGrid(listData.owner);
    			 column = dg.columns[listData.columnIndex];
    		 }
    		 visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
    		 //To show the underline with hand cursor
    		 buttonMode = true;
    		 useHandCursor = true;
    		 mouseChildren = false;
    		      
             setStyle("color",0x007ac8);              
             //Setting underline to indicate someting will happen on click 
    		 setStyle("textDecoration","underline");
    		 
    	}
		public function handleMouseClick(event:MouseEvent):void {
			
			var sPopup : SummaryPopup;	
			var allocTradePkStr : String="";
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
			if(column.headerText=="Allocation Ref. No."){				
			    sPopup.title = "Allocation Trade Details";
			    allocTradePkStr=data.allocationTradePk;
			}else if(column.headerText=="Confirmation Ref. No."){								
			    sPopup.title = "Confirmation Trade Details";
			    allocTradePkStr=data.tradePk;
			}
			sPopup.width = 650;
    		sPopup.height = 420;
			PopUpManager.centerPopUp(sPopup);
			sPopup.moduleUrl = Globals.TRADE_DETAILS_SWF+Globals.QS_SIGN+Globals.TRADE_PK+Globals.EQUALS_SIGN+allocTradePkStr+Globals.AND_SIGN+"MODE"+Globals.EQUALS_SIGN+"QUERY";
			
		}
	}
}