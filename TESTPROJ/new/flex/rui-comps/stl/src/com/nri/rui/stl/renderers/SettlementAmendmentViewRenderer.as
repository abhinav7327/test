
package com.nri.rui.stl.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.containers.SummaryPopup;
	
	import flash.events.MouseEvent;
	
	import mx.controls.DataGrid;
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;


	public class SettlementAmendmentViewRenderer extends Text {
		
		protected var clientStlInfoPkStr:String;
		protected var viewMode:String;
		
		public function SettlementAmendmentViewRenderer() {
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		override public function set data(value:Object):void {
			super.data = value;
			if(data.settlementFor == "SECURITY_TRADE" || data.settlementFor == "CORPORATE_ACTION" || data.settlementFor == "SLR_TRADE"){
			    setVisibleProp(true);
			}else{
			    setVisibleProp(false);
			}
		}
		
		private function setVisibleProp(flag:Boolean):void {
			var visibleFlag : Boolean = (StringUtil.trim(text) != Globals.EMPTY_STRING && flag == true) ? true : false;
			buttonMode = visibleFlag;
			useHandCursor = visibleFlag;
			mouseChildren = !visibleFlag;
			if(visibleFlag) {
				setStyle("color",0x007ac8);
				setStyle("textDecoration","underline");
				addEventListener(MouseEvent.CLICK, handleMouseClick);
			} else {
				if(hasEventListener(MouseEvent.CLICK))
					removeEventListener(MouseEvent.CLICK,handleMouseClick);
					
				setStyle("color",0x000000);
				setStyle("textDecoration","normal");
			}
		}
		
		public function handleMouseClick(event:MouseEvent):void {
		    						
			var sPopup : SummaryPopup;	
    		sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
    		    		
    		//Title
    		if(data.settlementFor == "SECURITY_TRADE") {
         		sPopup.title = this.parentApplication.xResourceManager.getKeyValue('stl.amendment.view.title.securitytrade');
         	} else if (data.settlementFor == "CORPORATE_ACTION") {
         		sPopup.title = this.parentApplication.xResourceManager.getKeyValue('stl.amendment.view.title.corporateaction');
         	} else if (data.settlementFor == "SLR_TRADE") {
         		sPopup.title = this.parentApplication.xResourceManager.getKeyValue('stl.amendment.view.title.slrtrade');
         	}
    		
            //set the width and height of the popup
            sPopup.width = 850;
    		sPopup.height = 500;    		
    		PopUpManager.centerPopUp(sPopup);        		
    		
    		var queryString:String="csiPk="+data.clientSettlementInfoPk+"&settlementFor="+data.settlementFor+"&mode=view";
    		
    		//Setting the Module path with some parameters which will be needed in the module for internal processing.                                                       
    		if(data.settlementFor == "SECURITY_TRADE") {
         		sPopup.moduleUrl = "assets/appl/stl/SettlementAmendmentSecurityTrade.swf"+ Globals.QS_SIGN +queryString;
         	} else if (data.settlementFor == "CORPORATE_ACTION") {
         		sPopup.moduleUrl = "assets/appl/stl/SettlementAmendmentCorporateAction.swf"+ Globals.QS_SIGN +queryString;
         	} else if (data.settlementFor == "SLR_TRADE") {
         		sPopup.moduleUrl = "assets/appl/stl/SettlementAmendmentSlrTrade.swf"+ Globals.QS_SIGN +queryString;
         	}
		} 
		
		override public function validateProperties():void{
			super.validateProperties();
			if (listData) {	
				var dg :DataGrid = DataGrid(listData.owner);
				var column:DataGridColumn =	dg.columns[listData.columnIndex];
				var dataTips:Boolean = dg.showDataTips;
				
				if (column.showDataTips == true)
					dataTips = true;
				if (column.showDataTips == false)
					dataTips = false;

				if (dataTips) {
					if (!(data is DataGridColumn) && (textWidth > width 
						|| column.dataTipFunction || column.dataTipField 
						|| dg.dataTipFunction || dg.dataTipField)) {
						toolTip = column.itemToDataTip(data);
					} else {
						toolTip = null;
					}
				} else {
					toolTip = null;
				}
			}
		}
	}
}