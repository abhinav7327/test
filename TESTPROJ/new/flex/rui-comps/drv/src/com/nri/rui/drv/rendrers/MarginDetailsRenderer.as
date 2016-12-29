
package com.nri.rui.drv.rendrers
{
    import mx.controls.Text;
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.containers.SummaryPopup;
    import com.nri.rui.core.controls.XenosAlert;
    
    import flash.events.MouseEvent;
    
    import mx.controls.DataGrid;
    import mx.controls.Text;
    import mx.controls.dataGridClasses.DataGridColumn;
    import mx.controls.dataGridClasses.DataGridListData;
    import mx.core.UIComponent;
    import mx.managers.PopUpManager;
    import mx.utils.StringUtil;

    /**
     * ItemRenderer to view the Margin Details from the Derivative Margin Query Result page
     */ 
    public class MarginDetailsRenderer extends Text
    {
        private const BLUE_COLOR:uint = 0x0000FF; // Blue  
        private const MARGIN_DETAILS_SWF : String = "assets/appl/drv/MarginDetailView.swf";
        
        public function MarginDetailsRenderer()
        {
            super();
            //addEventListener(MouseEvent.CLICK, handleMouseClick);
        }
        /**
         * Overridden the updateDisplayList method to display the columns values
         * in different colors, in button mode, with Hand cursor etc.
         * 
         */ 
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
             /* visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
             //To show the underline with hand cursor
             buttonMode = true;
             useHandCursor = true;
             mouseChildren = false;
             
             //setting color depending on positive or negative value
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
    		
    		sPopup.title = this.parentApplication.xResourceManager.getKeyValue('drv.margin.title') + " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.view');
            //set the width and height of the popup
            sPopup.width = 575;
    		sPopup.height = 250;
 
    		sPopup.horizontalScrollPolicy="auto";
    		sPopup.verticalScrollPolicy="auto";
    		PopUpManager.centerPopUp(sPopup);
    
            var marginPk : String = data.marginPk;
    		
    		//Setting the Module path with some parameters which will be needed in the module for internal processing.
    		sPopup.moduleUrl = MARGIN_DETAILS_SWF + Globals.QS_SIGN + "marginPk" + Globals.EQUALS_SIGN + marginPk+ Globals.AND_SIGN + "tradeRefNo" + Globals.EQUALS_SIGN + data.tradeReferenceNo+"&mode=marginquery";
    	}
        
    }
}