
package com.nri.rui.oms.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.utils.XenosPopupUtils;
	
	import flash.events.MouseEvent;
	
	import mx.controls.DataGrid;
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import mx.utils.StringUtil;

	public class OrderDetailsRenderer extends Text
	{
		
		public function OrderDetailsRenderer()
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
				//removeEventListener(MouseEvent.CLICK,handleMouseClick);
			}
			
		}
		
		public function handleMouseClick(event:MouseEvent):void {
			
			var ordPkStr : String = data.orderPk;
			var ordRefNoStr : String = data.orderReferenceNumber;
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			XenosPopupUtils.showOrderSummary(ordPkStr,ordRefNoStr,parentApp);
		}
		override public function validateProperties():void{
			super.validateProperties();
			if (listData)
			{	
				var dg :DataGrid = DataGrid(listData.owner);
				var column:DataGridColumn =	dg.columns[listData.columnIndex];
				var dataTips:Boolean = dg.showDataTips;
				if (column.showDataTips == true)
					dataTips = true;
				if (column.showDataTips == false)
					dataTips = false;

				if (dataTips)
				{
					if (!(data is DataGridColumn) && (textWidth > width 
						|| column.dataTipFunction || column.dataTipField 
						|| dg.dataTipFunction || dg.dataTipField))
					{
						toolTip = column.itemToDataTip(data);
					}
					else
					{
						toolTip = null;
					}
				}
				else
				{
					toolTip = null;
				}

			}
		}
	}
}