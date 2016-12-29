
 
package com.nri.rui.ncm.renderers
{
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.containers.SummaryPopup;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.ncm.NcmConstants;
    
    import flash.events.MouseEvent;
    
    import mx.controls.DataGrid;
    import mx.controls.Text;
    import mx.controls.dataGridClasses.DataGridColumn;
    import mx.core.UIComponent;
    import mx.managers.PopUpManager;
    import mx.utils.StringUtil;
    import mx.core.Application;
    
    /**
     * ItemRenderer for displaying the movement records in a Popup style 
     * causing a particular balance position. 
     * 
     */
    public class ReferenceNoRenderer extends Text
    {
    	protected var path : String = "";
    	protected var viewMode : String = "";
        
        public function ReferenceNoRenderer()
        {            
            super();
           // addEventListener(MouseEvent.CLICK, handleMouseClick);
        }
        /**
         * Overridden the updateDisplayList method to display the columns values
         * in different colors, in button mode, with Hand cursor etc.
         * 
         */ 
         override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
    		 super.updateDisplayList(unscaledWidth, unscaledHeight);
    			/* if(listData){
    				var dg : DataGrid = DataGrid(listData.owner);
    				var column : DataGridColumn = dg.columns[listData.columnIndex];
    				text = data[column.dataField];
    			}
    		 visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
    		 //To show the underline with hand cursor
    		 buttonMode = true;
    		 useHandCursor = true;
    		 mouseChildren = false;
    		 setStyle("color",0x007ac8);
             //Setting underline to indicate someting will happen on click 
    		 setStyle("textDecoration","underline"); */
    		 
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
    	
    	/**
    	 * Mouse Click event handler to open a popup with initialization and passing values.
    	 * 
    	 */ 
         public function handleMouseClick(event:MouseEvent):void {
    			
    		var sPopup : SummaryPopup;	
    		sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
    		
    		
    		 var balanceType : String = this.parentDocument.balanceType;
    		 var sourceComponentId : String = data.sourceComponentId;
    		 var transactionType : String = data.transactionType;
    		 
    		
    		
    		//Open the different details page according to the criteria
    		
    		if ((balanceType == "projected_balance") || (balanceType == "actual_balance")) {
    			if(sourceComponentId == "NCM"){    			
    				sPopup.title = Application.application.xResourceManager.getKeyValue('ncm.depository.detail.header');
					sPopup.width = 720;
					sPopup.height = 340;
					PopUpManager.centerPopUp(sPopup);		
					var ncmEntryPk : String = data.entryPk;
					sPopup.moduleUrl = NcmConstants.ADJUSTMENET_QRY_DETAILS_SWF+Globals.QS_SIGN+NcmConstants.NCM_ENTRY_PK+Globals.EQUALS_SIGN+ncmEntryPk;
    			}else if(sourceComponentId == "STL"){
    				
    				if(transactionType != "UNKNOWN_COMPLETION"){
    					
    					sPopup.title = Application.application.xResourceManager.getKeyValue('ncm.settlement.detail.header');
						sPopup.width = 700;
    					sPopup.height = 445;
						PopUpManager.centerPopUp(sPopup);
						var settleInfoPk : String = data.clientSettleInfoPk;
						
						path = "NCM";
						viewMode = "Instruction";
						
						sPopup.moduleUrl = Globals.SETTLEMENT_DETAILS_SWF+Globals.QS_SIGN															   
										   +NcmConstants.PATH+Globals.EQUALS_SIGN+path
										   +Globals.AND_SIGN+NcmConstants.VIEW_MODE+Globals.EQUALS_SIGN+viewMode
										   +Globals.AND_SIGN+Globals.SETTLEMENT_INFO_PK+Globals.EQUALS_SIGN+settleInfoPk;
						
						
    				}
    				
    			}
    		}else if(balanceType =="fail_balance"){
    			sPopup.title = "Settlement Details";
						sPopup.width = 700;
    					sPopup.height = 445;
						PopUpManager.centerPopUp(sPopup);
						var settlePk : String = data.settlementInfoPk;
						viewMode = "Instruction";
						
						sPopup.moduleUrl = Globals.SETTLEMENT_DETAILS_SWF+Globals.QS_SIGN
										   +Globals.SETTLEMENT_INFO_PK+Globals.EQUALS_SIGN+settlePk
										   +Globals.AND_SIGN+NcmConstants.VIEW_MODE+Globals.EQUALS_SIGN+viewMode;
    			
    		
    		}
    		
    	} 
    }
    
}