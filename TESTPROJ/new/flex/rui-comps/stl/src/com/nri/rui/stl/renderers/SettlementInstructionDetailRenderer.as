
package com.nri.rui.stl.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.containers.SummaryPopup;
	import com.nri.rui.core.utils.XenosPopupUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import flash.events.MouseEvent;
	
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;


	public class SettlementInstructionDetailRenderer extends SettlementDetailRenderer
	{
		
		public function SettlementInstructionDetailRenderer()
		{
			super();
			//addEventListener(MouseEvent.CLICK, handleMouseClicks);
		}
		
		/* override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			 super.updateDisplayList(unscaledWidth, unscaledHeight);
				if(listData){
					var dg : DataGrid = DataGrid(listData.owner);
					var column : DataGridColumn = dg.columns[listData.columnIndex];
					var settlementRefNo:String = data.settlementReferenceNo;
					var versionNum:String = data.versionNo;
					text = settlementRefNo + "-" + versionNum;
				}
				
			 visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
			 //To show the underline with hand cursor
			 buttonMode = true;
			 useHandCursor = true;
			 mouseChildren = false;
			 
			 setStyle("color",0x007ac8);
			 setStyle("textDecoration","underline");
			 
			 
		} */
		
		
		
		
		 public override function handleMouseClick(event:MouseEvent):void {
						
			stlPkStr = data.settlementInfoPk;
			var stlPk: Number = new Number(stlPkStr);
			if(stlPk > 0){
				viewMode = "Instruction";
				var parentApp :UIComponent = UIComponent(this.parentApplication);
				XenosPopupUtils.showSettlementDetails(stlPkStr,
													  parentApp,
													  this.parentApplication.xResourceManager.getKeyValue('stl.stlqry.label.settlementviewheader'),
													  viewMode);
			}else{
				var sPopup : SummaryPopup;   
				var parentAppCe :UIComponent = UIComponent(this.parentApplication); 
	            sPopup= SummaryPopup(PopUpManager.createPopUp(parentAppCe,SummaryPopup,false));
	            sPopup.title = this.parentApplication.xResourceManager.getKeyValue('stl.authorization.label.cashentryviewheader');
	            sPopup.width = 1000;
	            sPopup.height = 550;
	            PopUpManager.centerPopUp(sPopup);
	            
	            sPopup.moduleUrl = "assets/appl/stl/CashTransferAuthDetail.swf" + Globals.QS_SIGN + "cashEntryPk" + Globals.EQUALS_SIGN + data.cashEntryPk;
			}
		} 
		/* override public function validateProperties():void{
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
		} */
	}
}
