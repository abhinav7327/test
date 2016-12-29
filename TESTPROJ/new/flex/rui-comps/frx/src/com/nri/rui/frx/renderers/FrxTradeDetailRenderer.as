
package com.nri.rui.frx.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.containers.SummaryPopup;
	
	import flash.events.MouseEvent;
	
	import mx.controls.DataGrid;
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;

	public class FrxTradeDetailRenderer extends Text
	{
		
		public function FrxTradeDetailRenderer()
		{
			super();
			//addEventListener(MouseEvent.CLICK, handleMouseClick);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			 super.updateDisplayList(unscaledWidth, unscaledHeight);
				/* if(listData){
					var dg : DataGrid = DataGrid(listData.owner);
					var column : DataGridColumn = dg.columns[listData.columnIndex];
					text = data[column.dataField];
				}
			 visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
			 //To show the underline with hand cursor
			 buttonMode = true;
			 useHandCursor = true;
			 mouseChildren = false;
			  
			 setStyle("color",0x007ac8);
			 setStyle("textDecoration","underline"); */
		}
		
		override public function set data(value:Object):void{
			super.data = value;
			//visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
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
			
			var sPopup:SummaryPopup = SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
	    		
	    		sPopup.title = Application.application.xResourceManager.getKeyValue('frx.detail.title');
	            //set the width and height of the popup
	            sPopup.width = parentApplication.width - 125;
	    		sPopup.height = parentApplication.height - 150;
	 
	    		sPopup.horizontalScrollPolicy="auto";
	    		sPopup.verticalScrollPolicy="auto";
	    		PopUpManager.centerPopUp(sPopup);
	    
	            var forexTradePk : String = data.frxTrdPk;
	    		
	    		//Setting the Module path with some parameters which will be needed in the module for internal processing.
	    		sPopup.moduleUrl = Globals.FRX_TRADE_DETAILS_SWF + Globals.QS_SIGN + "frxTradePk" + Globals.EQUALS_SIGN + forexTradePk;
			
		}
		
	}
}