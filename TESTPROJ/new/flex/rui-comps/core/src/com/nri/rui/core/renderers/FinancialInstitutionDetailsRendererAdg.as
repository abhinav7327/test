
package com.nri.rui.core.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.utils.XenosPopupUtils;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Text;
	import mx.core.UIComponent;
	import mx.utils.StringUtil;
	
		
	public class FinancialInstitutionDetailsRendererAdg extends Text
	{
		//private var _data:DataGridColumn;
		public function FinancialInstitutionDetailsRendererAdg()
		{
			super();
			//addEventListener(MouseEvent.CLICK, handleMouseClick);
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			 super.updateDisplayList(unscaledWidth, unscaledHeight);
				/* if(listData){
					var dg : AdvancedDataGrid = AdvancedDataGrid(listData.owner);
					var column : AdvancedDataGridColumn = dg.columns[listData.columnIndex];
					text = data[column.dataField];
				} */
			 //visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
			 //To show the underline with hand cursor
			 
			 
			
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
			
			var bankPk : String = data.bankPk;
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			
			XenosPopupUtils.showFinInstDetails(bankPk,parentApp);
		}
		
		override public function validateProperties():void{
			super.validateProperties();
			/* if (listData)
			{	
				var dg :AdvancedDataGrid = AdvancedDataGrid(listData.owner);
				var column:AdvancedDataGridColumn =	dg.columns[listData.columnIndex];
				var dataTips:Boolean = dg.showDataTips;
				if (column.showDataTips == true)
					dataTips = true;
				if (column.showDataTips == false)
					dataTips = false;

				if (dataTips)
				{
					if (!(data is AdvancedDataGridColumn) && (textWidth > width 
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

			} */
		}
	}

}