// ActionScript file

package com.nri.rui.trd.renderers
{
	
	import com.nri.rui.core.containers.SummaryPopup;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.controls.Image;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;

	public class TradeRcvdConfDetailRenderer extends Image
	{
		
  		[Embed(source="../../../../../../assets/icon_view.png")]
		[Bindable]
		private var icoSummary:Class;
		public function TradeRcvdConfDetailRenderer()
		{
			super();
			source=icoSummary;	
			super.setStyle("horizontalAlign","center");
			super.setStyle("width","10");
			super.setStyle("height","10");
			//super.toolTip="Received Confirmation Detail";
			buttonMode=true;
			useHandCursor=true;
			addEventListener(MouseEvent.CLICK, handleMouseClick);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			 super.updateDisplayList(unscaledWidth, unscaledHeight);
				if(listData){
					var dg : DataGrid = DataGrid(listData.owner);
					var column : DataGridColumn = dg.columns[listData.columnIndex];
					
				}	 
		}
		
		public function handleMouseClick(event:MouseEvent):void {
			
			var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
			
			sPopup.title = "Received Confirmation Trade Details";
			sPopup.width = 650;
    		sPopup.height = 420;
			/* sPopup.horizontalScrollPolicy="off";
			sPopup.verticalScrollPolicy="off"; */
			PopUpManager.centerPopUp(sPopup);		
			//var rcvdConfPkStr : String = data.receivedConfirmationPk;
			sPopup.moduleUrl = "assets/appl/trd/TradeRcvdConfDetail.swf?rowNum="+listData.rowIndex.toString();
			
		}
	}
}
