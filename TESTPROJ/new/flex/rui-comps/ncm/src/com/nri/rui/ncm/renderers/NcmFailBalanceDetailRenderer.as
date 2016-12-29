
package com.nri.rui.ncm.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.utils.XenosPopupUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Text;
	import mx.core.UIComponent;
	import mx.utils.StringUtil;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	
		
	public class NcmFailBalanceDetailRenderer extends Text
	{
        private const POSITIVE_COLOR:uint = 0x000000; // Black
        private const NEGATIVE_COLOR:uint = 0xFF0000; // Red 
        private const NEGATIVE_SIGN : String = "-";
		
		public function NcmFailBalanceDetailRenderer() {
			super();
		}
	
		override public function set data(value:Object):void {
			super.data = value;
			setVisibleProp();
		}
		
		private function setVisibleProp():void {
			var visibleFlag : Boolean = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
			buttonMode = visibleFlag;
			useHandCursor = visibleFlag;
			mouseChildren = !visibleFlag;
			if(visibleFlag && XenosStringUtils.equals(data.description, "Fail Amount")) {
				setStyle("color",0x007ac8);
				setStyle("textDecoration","underline");
				addEventListener(MouseEvent.CLICK, handleMouseClick);
			} else {
				if(hasEventListener(MouseEvent.CLICK))
					removeEventListener(MouseEvent.CLICK,handleMouseClick);
				if(String(text).charAt(0) == NEGATIVE_SIGN) {
					setStyle("color", NEGATIVE_COLOR);
				} else {
					setStyle("color", POSITIVE_COLOR);
				}
				setStyle("textDecoration","normal");
			}
		}
		
		public function handleMouseClick(event:MouseEvent):void {
			
            var dg :DataGrid = DataGrid(listData.owner);
            var dgc:DataGridColumn = DataGridColumn(dg.columns[listData.columnIndex]);
            var drFlag : String = null;
            if (XenosStringUtils.equals(dgc.dataField, "formattedDebitAmount")) {
                drFlag = "D";
            } else {
                drFlag = "R";
            }
			var module : String = data.module;
			var fundCode : String = data.fundCode;
			var ccy : String = data.currency;
			var dateFrom : String = data.defaultDateFrom;
			var bankCode : String = data.bankCode;
			var bankAccountNo : String = data.bankAccountNo;
			var stlPkStr : String = data.settlementInfoPk;
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			
			XenosPopupUtils.showFailBalanceDetails(fundCode, ccy, dateFrom, bankCode, bankAccountNo, drFlag, parentApp);
		}
		
	}
}
