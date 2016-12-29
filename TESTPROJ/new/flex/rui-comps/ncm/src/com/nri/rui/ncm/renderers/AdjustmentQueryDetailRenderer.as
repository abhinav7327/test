
package com.nri.rui.ncm.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.containers.SummaryPopup;
	import com.nri.rui.core.utils.XenosStringUtils;
	import com.nri.rui.ncm.NcmConstants;
	
	import flash.events.MouseEvent;
	
	import mx.controls.DataGrid;
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;
	import mx.core.Application;
	
	public class AdjustmentQueryDetailRenderer extends Text
	{
		public function AdjustmentQueryDetailRenderer()
		{
			super();
			//addEventListener(MouseEvent.CLICK, handleMouseClick);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			 super.updateDisplayList(unscaledWidth, unscaledHeight);
				/* if(listData){
					var dg : DataGrid = DataGrid(listData.owner);
					var column : DataGridColumn = dg.columns[listData.columnIndex];
					text = data[column.dataField];
				}
			 visible = (StringUtil.trim(text) == XenosStringUtils.EMPTY_STR ) ? false :true;
			 //To show the underline with hand cursor
			 buttonMode = true;
			 useHandCursor = true;
			 mouseChildren = false;
			 setStyle("color",0x007ac8);
			 setStyle("textDecoration","underline");  */
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
			
			var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
			
			sPopup.title = Application.application.xResourceManager.getKeyValue('ncm.adjustment.query.header');
			sPopup.width = 780;
			sPopup.height = 400;
			PopUpManager.centerPopUp(sPopup);		
			var ncmEntryPk : String = data.ncmEntryPk;
			sPopup.moduleUrl = NcmConstants.ADJUSTMENET_QRY_DETAILS_SWF+Globals.QS_SIGN+NcmConstants.NCM_ENTRY_PK+Globals.EQUALS_SIGN+ncmEntryPk;
			
		}
	}
}