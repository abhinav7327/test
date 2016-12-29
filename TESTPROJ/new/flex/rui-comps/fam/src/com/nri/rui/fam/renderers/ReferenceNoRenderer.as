// ActionScript file

 
 
 
 package com.nri.rui.fam.renderers
{
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.containers.SummaryPopup;
    import com.nri.rui.core.controls.XenosAlert;
    import flash.events.MouseEvent;
    
    import mx.controls.DataGrid;
    import mx.controls.Text;
    import mx.controls.dataGridClasses.DataGridColumn;
    import mx.core.UIComponent;
    import mx.managers.PopUpManager;
    import mx.utils.StringUtil;
    import mx.core.Application;
    import com.nri.rui.core.controls.XenosAlert;
    
    public class ReferenceNoRenderer extends Text
    {
    	protected var path : String = "";
    	protected var viewMode : String = "";
        
        public function ReferenceNoRenderer()
        {            
            super();
        }
        
        
        /**
         * Overridden the updateDisplayList method to display the columns values
         * in different colors, in button mode, with Hand cursor etc.
         * 
         */ 
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
    			
    		var sPopup : SummaryPopup;	
    		sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
    		
    		
    		 var portfolioBalanceType : String = data.portfolioBalanceType;
    		 var openTrgPk : String = data.openTransactionPk;
    		 
    		if (portfolioBalanceType == "DEPO") {   			
    				sPopup.title = Application.application.xResourceManager.getKeyValue('fam.depo.balance.type.referenceno');
					sPopup.width = 700;
					sPopup.height = 445;
					PopUpManager.centerPopUp(sPopup);		
					
					sPopup.moduleUrl = Globals.BKG_TRADE_DETAILS_SWF + Globals.QS_SIGN + Globals.BKG_TRADE_PK + Globals.EQUALS_SIGN + openTrgPk;
  
    		}else if(portfolioBalanceType == "OPEN_NDF"){
    			sPopup.title = Application.application.xResourceManager.getKeyValue('fam.openndf.balance.type.referenceno');
						sPopup.width = 700;
    					sPopup.height = 445;
						PopUpManager.centerPopUp(sPopup);
						
						sPopup.moduleUrl = Globals.FRX_TRADE_DETAILS_SWF+Globals.QS_SIGN
										   + Globals.FRX_TRADE_PK + Globals.EQUALS_SIGN + openTrgPk;
    			
    		
    		} else if (portfolioBalanceType == "DERIVATIVES") {
    			sPopup.title = Application.application.xResourceManager.getKeyValue('fam.derivatives.balance.type.referenceno');
						sPopup.width = 700;
    					sPopup.height = 445;
						PopUpManager.centerPopUp(sPopup);
						var actionMode : String = 'query'; 
						
						sPopup.moduleUrl = Globals.DRV_TRADE_DETAILS_SWF + Globals.QS_SIGN
										   + Globals.DRV_TRADE_PK + Globals.EQUALS_SIGN + openTrgPk + Globals.AND_SIGN + Globals.DRV_ACTION_MODE + Globals.EQUALS_SIGN + actionMode;
    		}
    		
    	} 
    }
    
}
