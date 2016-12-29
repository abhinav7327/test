
package com.nri.rui.nam.renderers
{
	import mx.controls.Image;
	import com.nri.rui.core.containers.SummaryPopup;
	import flash.events.MouseEvent;
	import mx.controls.DataGrid;
	import mx.controls.Image;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;

	public class NamFeedDetailViewRenderer extends Image
	{
		[Embed(source="../../../../../assets/popup_icon.png")]
		[Bindable]
		private var icoSummary:Class;
		public function NamFeedDetailViewRenderer()
		{
			super();
			source=icoSummary;
			super.setStyle("horizontalAlign","center");
			super.setStyle("width","10");
			super.setStyle("height","10");
			super.toolTip="Feed Detail View";
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
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
			sPopup.title ="Feed Detail View";
			sPopup.width = 650;
    		sPopup.height = 420;
			PopUpManager.centerPopUp(sPopup);
			var intfFeedDetailPk : String = data.intfFeedDetailPk;
			var destinationSystem : String = data.destinationSystem;
			sPopup.moduleUrl = "assets/appl/nam/NamFeedDetailView.swf?intfFeedDetailPk="+intfFeedDetailPk+"&destinationSystem="+destinationSystem;
		}
	}
}