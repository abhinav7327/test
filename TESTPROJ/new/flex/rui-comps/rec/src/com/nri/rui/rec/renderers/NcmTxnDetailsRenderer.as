
package com.nri.rui.rec.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.utils.XenosPopupUtils;
	
	import flash.events.MouseEvent;
	
	import mx.controls.AdvancedDataGrid;
	import mx.controls.Text;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.core.UIComponent;
	import mx.utils.StringUtil;
	
		
	public class NcmTxnDetailsRenderer extends Text
	{
		public function NcmTxnDetailsRenderer()
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
				}
			 visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
			 //To show the underline with hand cursor
			 buttonMode = true;
			 useHandCursor = true;
			 mouseChildren = false;
			 
			 setStyle("color", 0x007ac8);
			 setStyle("textDecoration", "underline"); */
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
			
			var module : String = data.module;
			var triTransactionPk :String = data.trgTxnPk;
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			
			if ( module =="STL01"||module =="STL02"){
			    XenosPopupUtils.showSettlementDetails(triTransactionPk, 
			    									  parentApp,
			    									  this.parentApplication.xResourceManager.getKeyValue('rec.label.settlement.detail.header'),
			    									  "Instruction");
			}else if(module == "NCM"){
				XenosPopupUtils.showNcmAdjustmentDetails(triTransactionPk,parentApp);
			}else if(module == "CAM"){
				XenosPopupUtils.showCamSecurityDetails(triTransactionPk,parentApp);
			}else if (module == "TRD"){	
			 XenosPopupUtils.showTrdTradeDetails(triTransactionPk,parentApp);
			}else if(module =="CAX02"){
				XenosPopupUtils.showCaxRightsDetails(triTransactionPk,parentApp);
			}else if(module =="CAX05"){
				XenosAlert.info("No Detail Screen Available for CAX05");
			}
			
			
		}
		
		override public function validateProperties():void{
			super.validateProperties();
			if (listData)
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

			}
		}
	}

}
