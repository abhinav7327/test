
 
package com.nri.rui.fam.renderers
{
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.containers.SummaryPopup;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.utils.XenosPopupUtils;
    import com.nri.rui.fam.FamConstants;
    
    import flash.events.MouseEvent;
    
    import mx.controls.DataGrid;
    import mx.controls.Text;
    import mx.controls.dataGridClasses.DataGridColumn;
    import mx.core.UIComponent;
    import mx.managers.PopUpManager;
    import mx.utils.StringUtil;
    
    /**
     * ItemRenderer for displaying the Transaction records in a Popup style 
     * causing a particular Gle Movement. 
     * 
     */
    public class SuspendedTransactionDetailRenderer extends Text
    {
        public function SuspendedTransactionDetailRenderer(){
			super();
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			 super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		override public function set data(value:Object):void{
			super.data = value;
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
			}
		}
    	
    	/**
    	 * Mouse Click event handler to open a popup with initialization and passing values.
    	 * 
    	 */ 
        public function handleMouseClick(event:MouseEvent):void {
            
            var trgTransactionPk : String = data.trgTransactionPk;
           	var editedModule : String = data.messageType;
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			if ( editedModule =="STL01"||editedModule =="STL02"){
			var viewMode:String ="Instruction"
			    XenosPopupUtils.showSettlementDetails(trgTransactionPk,
			    									  parentApp,
			    									  this.parentApplication.xResourceManager.getKeyValue('fam.label.settlement.detail.header'),
			    									  viewMode);
			}else if(editedModule == "NCM"){
				XenosPopupUtils.showNcmAdjustmentDetails(trgTransactionPk,parentApp);
			}else if(editedModule == "CAM"){
				XenosPopupUtils.showCamSecurityDetails(trgTransactionPk,parentApp);
			}else if (editedModule == "TRD"){	
			 	XenosPopupUtils.showTrdTradeDetails(trgTransactionPk,parentApp);
			}else if(editedModule =="CAX02"){
				XenosPopupUtils.showCaxRightsDetails(trgTransactionPk,parentApp);
			}else if(editedModule =="CAX05"){
				XenosPopupUtils.showCaxExerciseDetails(trgTransactionPk,parentApp);
			}else if(editedModule =="DRV"){
				showDrvDetail(trgTransactionPk,parentApp);
			}else if(editedModule =="FRX"){
				showFrxDetail(trgTransactionPk,parentApp);
			}else if(editedModule =="BKG"){
				showBkgDetail(trgTransactionPk,parentApp);
			}
    	}
    	
    	 /**
         * 
         */
        private static function showDrvDetail(drvTradePk : String, parentApplication:UIComponent):void {
            
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
            
            sPopup.title = "DRV Trade Detail View";
            sPopup.width = 830;
            sPopup.height = 550;
            PopUpManager.centerPopUp(sPopup);
            
            sPopup.moduleUrl = FamConstants.DRV_DETAILS_SWF+Globals.QS_SIGN+    
                                FamConstants.DRV_TRADE_PK+Globals.EQUALS_SIGN+drvTradePk;
            
            
        }
         /**
         * 
         */
        private static function showFrxDetail(frxTradePk : String, parentApplication:UIComponent):void {
            
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
            
            sPopup.title = "FRX Trade Detail View";
            sPopup.width = 830;
            sPopup.height = 550;
            PopUpManager.centerPopUp(sPopup);
            
            sPopup.moduleUrl = FamConstants.FRX_DETAILS_SWF+Globals.QS_SIGN+    
                                FamConstants.FRX_TRADE_PK+Globals.EQUALS_SIGN+frxTradePk;
            
            
        }
         /**
         * 
         */
        private static function showBkgDetail(bkgTradePk : String, parentApplication:UIComponent):void {
            
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
            
            sPopup.title = "BKG Trade Detail View";
            sPopup.width = 830;
            sPopup.height = 550;
            PopUpManager.centerPopUp(sPopup);
            
            sPopup.moduleUrl = FamConstants.BKG_DETAILS_SWF+Globals.QS_SIGN+    
                                FamConstants.BKG_TRADE_PK+Globals.EQUALS_SIGN+bkgTradePk;
            
            
        }
        
        override public function validateProperties():void{
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
		}
    }
    
}