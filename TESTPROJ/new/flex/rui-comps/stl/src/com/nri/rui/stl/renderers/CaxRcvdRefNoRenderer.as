
package com.nri.rui.stl.renderers {
	
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.utils.XenosPopupUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import flash.events.MouseEvent;
	
	import mx.controls.DataGrid;
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import mx.utils.StringUtil;


	public class CaxRcvdRefNoRenderer extends Text {
			
		public function CaxRcvdRefNoRenderer() {
			super();
		}
		
		override public function set data(value:Object):void{
			super.data = value;
/*			if(data.typeOfRecord == "S"){
                this.text = data.settlementReferenceNo;
            } else { //if(item.typeOfRecord == "R")
                if(data.messageStatus == "FORCE_MATCHED")
                    this.text =  data.rcvdCompNoticeRefNo;   //verify this case
                else
                    this.text =  data.rcvdCompNoticeRefNo;
            }*/
            this.text = data.settlementReferenceNo;
		    setVisibleProp();
		}
		
		private function setVisibleProp():void {
			
			var visibleFlag : Boolean = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
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
		     var parentApp :UIComponent = UIComponent(this.parentApplication);
             if(data.settlementInfoPk != "-1"){
                var viewMode:String = "Instruction"; // Must be specified                
                XenosPopupUtils.showSettlementDetails(data.settlementInfoPk,
                                                      parentApp,
                                                      this.parentApplication.xResourceManager.getKeyValue('stl.stlqry.label.settlementviewheader'),
                                                      viewMode);
             }
/*		 	 if(data.typeOfRecord == "S"){
                 if(data.settlementInfoPk != "-1"){
                    var viewMode:String = "Instruction"; // Must be specified                
                    XenosPopupUtils.showSettlementDetails(data.settlementInfoPk,
									                      parentApp,
									                      this.parentApplication.xResourceManager.getKeyValue('stl.stlqry.label.settlementviewheader'),
									                      viewMode);
                 }
             } else { //if(item.typeOfRecord == "R")
                if(data.receivedCompNoticeInfoPk != "-1"){                   
                    XenosPopupUtils.showCaxReceiveNoticeDetail(data.receivedCompNoticeInfoPk,parentApp);
                 }
             }*/
					
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
						|| dg.dataTipFunction || dg.dataTipField))
					{
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