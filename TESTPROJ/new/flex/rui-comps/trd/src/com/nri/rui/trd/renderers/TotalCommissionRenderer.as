
package com.nri.rui.trd.renderers
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.renderers.ImgSummaryRenderer;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.controls.DataGrid;
	import mx.controls.Label;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.EventPriority;
	import mx.utils.StringUtil;

	public class TotalCommissionRenderer extends ImgSummaryRenderer implements IDropInListItemRenderer {
		
		private var _listData:BaseListData;
		
		public function TotalCommissionRenderer(){
			super();
		}
		
		private function rolloverHandler(event:MouseEvent):void{
			if(data.total == 'Total'){
				event.preventDefault();
				event.stopImmediatePropagation();
				event.stopPropagation();
			}
			
		}
		
		private function rolloutHandler(event:MouseEvent):void{
			if(data.total == 'Total'){
				event.preventDefault();
				event.stopImmediatePropagation();
				event.stopPropagation();
			}
		}
		
		override public function get listData():BaseListData
		{
			return _listData;
		}
		
		override public function set listData(value:BaseListData):void
		{
			_listData = value;
		}
		
		override public function set data(value:Object):void {
			super.data = value;
			if(data.total == 'Total'){
				this.addEventListener(MouseEvent.ROLL_OVER,rolloverHandler,false,500);
				this.addEventListener(MouseEvent.ROLL_OUT,rolloutHandler,false,500);
				if(this.getChildByName('lbl') != null)
					this.removeChild(this.getChildByName('lbl'));
				var totalLbl:Label = new Label();
				totalLbl.text = data.total;
				totalLbl.name = 'lbl';
				totalLbl.setStyle("color",0x000000);
				totalLbl.setStyle("textDecoration","normal");
				totalLbl.setStyle("fontWeight","bold");
				this.addChild(totalLbl);
				this.sView.visible = false;
				this.sView.includeInLayout = false;
			}else{
				this.removeEventListener(MouseEvent.ROLL_OVER,rolloverHandler);
				this.removeEventListener(MouseEvent.ROLL_OUT,rolloutHandler);
				if(this.getChildByName('lbl') != null)
					this.removeChild(this.getChildByName('lbl'));
				this.sView.visible = true;
				this.sView.includeInLayout = true;
			}
		}
	 }
}