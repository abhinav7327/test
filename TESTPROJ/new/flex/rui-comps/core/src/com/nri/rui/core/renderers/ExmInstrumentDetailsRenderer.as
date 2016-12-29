
package com.nri.rui.core.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.utils.XenosPopupUtils;
	
	import flash.events.MouseEvent;
	
	import mx.controls.AdvancedDataGrid;
	import mx.controls.Text;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.core.UIComponent;
	import mx.utils.StringUtil;


	public class ExmInstrumentDetailsRenderer extends Text
	{
		public function ExmInstrumentDetailsRenderer()
		{
			super();
			//addEventListener(MouseEvent.CLICK, handleMouseClick);
		}
		
		override public function set data(value:Object):void{
			super.data = value;
			//visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
			if(null != value)
			    setVisibleProp();
		}
		
		private function setVisibleProp():void{
			
			var visibleFlag : Boolean = (StringUtil.trim(data.instrumentPk) == Globals.EMPTY_STRING ) ? false :true;
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
			
			var instPkStr : String ;
			if(listData){
					var adg : AdvancedDataGrid = AdvancedDataGrid(listData.owner);
					var column : AdvancedDataGridColumn = adg.columns[listData.columnIndex];
					instPkStr = data[column.dataField];
					
				} 			
			//var instPkStr : String = data.instrumentPk;
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			XenosPopupUtils.showInstrumentDetails(instPkStr,parentApp);
					
		}
		override public function validateProperties():void{
			super.validateProperties();
			if (listData)
			{	
				var adg : AdvancedDataGrid = AdvancedDataGrid(listData.owner);
				var column:AdvancedDataGridColumn =	adg.columns[listData.columnIndex];
				var dataTips:Boolean = adg.showDataTips;
				if (column.showDataTips == true)
					dataTips = true;
				if (column.showDataTips == false)
					dataTips = false;

				if (dataTips)
				{
					if (!(data is AdvancedDataGridColumn) && (textWidth > width 
						|| column.dataTipFunction || column.dataTipField 
						|| adg.dataTipFunction || adg.dataTipField))
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