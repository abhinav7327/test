
package com.nri.rui.slr.renderers
{
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.containers.SummaryPopup;
    
    import flash.events.MouseEvent;
    
    import mx.controls.Text;
    import mx.core.UIComponent;
    import mx.managers.PopUpManager;
    import mx.utils.StringUtil;
    import com.nri.rui.core.utils.XenosStringUtils;

    /**
     * ItemRenderer to view the Trade Details from the Stock Borrow/Return Query Result page
     */ 
    public class Sbr_TradeDetailsRenderer extends Text
    {
        private const BLUE_COLOR:uint = 0x0000FF; // Blue   
        public var _mode:String = "";       
        
        public function Sbr_TradeDetailsRenderer() {
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
        
        override public function set data(value:Object):void {
			super.data = value;
			setVisibleProp();
		}
		
		private function setVisibleProp():void {
			
			var visibleFlag : Boolean = (StringUtil.trim(text) == Globals.EMPTY_STRING) ? false :true;
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
			}
		}
        
        /**
    	 * Mouse Click event handler to open a popup with initialization and passing values.
    	 * 
    	 */ 
        public function handleMouseClick(event:MouseEvent):void {
    			
    		var sPopup : SummaryPopup;	
    		sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
    		
    		sPopup.title = this.parentApplication.xResourceManager.getKeyValue('borrow.label.stockborrowreturntrade') + " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.view');
            //set the width and height of the popup
            sPopup.width = 800;
    		sPopup.height = 470;
 
    		sPopup.horizontalScrollPolicy="auto";
    		sPopup.verticalScrollPolicy="auto";
    		PopUpManager.centerPopUp(sPopup);
    		
            var tradePk : String = data.tradePk;
    		
    		//Setting the Module path with some parameters which will be needed in the module for internal processing.    		
    		sPopup.moduleUrl = Globals.SBR_TRADE_DETAILS_SWF + Globals.QS_SIGN + Globals.TRADE_PK + Globals.EQUALS_SIGN + tradePk;
    	}
    }
}