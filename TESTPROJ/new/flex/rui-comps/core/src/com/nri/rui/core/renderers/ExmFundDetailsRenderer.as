
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


	public class ExmFundDetailsRenderer extends Text
	{
		public function ExmFundDetailsRenderer()
		{
			super();
			//addEventListener(MouseEvent.CLICK, handleMouseClick);
		}
		
		
		override public function set data(value:Object):void{
			super.data = value;
			//visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
			if(null != value)
			    setVisibleProp(value);

		}
		
		private function setVisibleProp(value:Object):void{
			
			var visibleFlag : Boolean = (StringUtil.trim(value["fundPk"]) == Globals.EMPTY_STRING ) ? false :true;
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
			
			var fundPkStr : String = data.fundPk;
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			XenosPopupUtils.showFundCodeDetails(fundPkStr,parentApp);
			
			
		}
		
		override public function validateProperties():void{
			super.validateProperties();
			if (listData)
			{	
				var adg :AdvancedDataGrid = AdvancedDataGrid(listData.owner);
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