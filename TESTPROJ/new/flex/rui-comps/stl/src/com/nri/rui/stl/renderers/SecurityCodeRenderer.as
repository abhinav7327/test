
package com.nri.rui.stl.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.utils.XenosPopupUtils;
	
	import flash.events.MouseEvent;
	
	import mx.controls.DataGrid;
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import mx.utils.StringUtil;


	public class SecurityCodeRenderer extends Text
	{
		public function SecurityCodeRenderer()
		{
			super();
			//addEventListener(MouseEvent.CLICK, handleMouseClick);
		}
		
		/**
         *  @private
         */
        override public function set data(value:Object):void {
        	super.data = value;
        	if(listData){
				//var dg : DataGrid = DataGrid(listData.owner);
				//var column : DataGridColumn = dg.columns[listData.columnIndex];
				var instrCode:String = data.instrumentCode;
				if(instrCode == null || instrCode == "")
					text = data.correspondingSecurityId;
				else
					text = data.instrumentCode;
			}
        }
		
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			 super.updateDisplayList(unscaledWidth, unscaledHeight);
			 visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
			 //To show the underline with hand cursor
			 
		}
		
		 /* public function handleMouseClick(event:MouseEvent):void {
						
			var stlPkStr : String = data.settlementInfoPk;
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			XenosPopupUtils.showSettlementDetails(stlPkStr,parentApp);
					
		}  */
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