





package com.nri.rui.stl.renderers {
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.containers.SummaryPopup;
	import com.nri.rui.core.controls.XenosAlert;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import mx.controls.DataGrid;
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;


	public class CompletionDetailsRenderer extends Text {

        [Bindable] private var str:String = "";     
        [Bindable] private var mode:String = ""; 
        
		public function CompletionDetailsRenderer() {
            super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			 super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		override public function set data(value:Object):void{
			super.data = value;
			//visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
			str = data.completionTp;
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
			} else {
				if(hasEventListener(MouseEvent.CLICK))
					removeEventListener(MouseEvent.CLICK,handleMouseClick);
				setStyle("color",0x000000);
				setStyle("textDecoration","normal");
				//removeEventListener(MouseEvent.CLICK,handleMouseClick);
			}
			
		}
		
		public function handleMouseClick(event:MouseEvent):void {
            trace("Mode : " + parentDocument.mode);
            
            mode = parentDocument.mode;
            var parentApp : UIComponent = UIComponent(this.parentApplication);
            var sPopup : SummaryPopup;  
            if (mode == "ADD" || mode == "CAX_RECEIVE_NOTICE") {
		        str = data.completionTp;
	            if (str == null || str == "") {
	                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.entry.select.completiontype.first'));
	                return;
	            }
	            var completionArray:Array = new Array(this.parentDocument.queryResult.length);
	            completionArray[data.rowNo] = str;
	            
	            /*var stlInfoPkArray:Array = new Array();
	            for(var x:int=0; x < this.parentDocument.queryResult.length; x++ ) {
	            	stlInfoPkArray.push(this.parentDocument.queryResult[x].settlementInfoPk);
	            }*/
				
	            sPopup = SummaryPopup(PopUpManager.createPopUp(parentApp, SummaryPopup, false));
	            sPopup.title = this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.entry.completiondetails');
	            sPopup.width = 800;
	            sPopup.height = 550;
	            PopUpManager.centerPopUp(sPopup);
	            sPopup.owner = DisplayObjectContainer(parentDocument);
	            sPopup.moduleUrl = Globals.SETTLEMENT_COMPLETION_DETAILS_ENTRY_SWF + 
	                Globals.QS_SIGN + "index" + Globals.EQUALS_SIGN + data.rowNo + 
	                Globals.AND_SIGN + "arrayLength" + Globals.EQUALS_SIGN + this.parentDocument.queryResult.length +
	                Globals.AND_SIGN + "completionArray" + Globals.EQUALS_SIGN + completionArray +
	                Globals.AND_SIGN + "completionType" + Globals.EQUALS_SIGN + str +
	                Globals.AND_SIGN + "stlInfoPk" + Globals.EQUALS_SIGN + data.settlementInfoPk;
	            
            } else if (mode == "DELETE") {
            	
	            if (data.selected == false) {
	                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.query.select.record.first'));
	                return;
	            }
	                                    
	            sPopup = SummaryPopup(PopUpManager.createPopUp(parentApp, SummaryPopup, false));
	            sPopup.title = this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.entry.remarks');
	            sPopup.width = 700;
	            sPopup.height = 445;
	            PopUpManager.centerPopUp(sPopup);
	            sPopup.owner = DisplayObjectContainer(parentDocument);
	            sPopup.moduleUrl = Globals.SETTLEMENT_COMPLETION_DETAILS_ENTRY_SWF + 
	                Globals.QS_SIGN + "index" + Globals.EQUALS_SIGN + data.rowNo +
	                Globals.AND_SIGN + "stlInfoPk" + Globals.EQUALS_SIGN + data.settlementInfoPk;
            }
		} 
		
		override public function validateProperties():void {
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