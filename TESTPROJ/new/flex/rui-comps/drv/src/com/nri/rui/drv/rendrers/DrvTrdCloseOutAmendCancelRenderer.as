
package com.nri.rui.drv.rendrers
{
    import flash.events.Event;
    import flash.events.MouseEvent;
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.containers.SummaryPopup;
    import mx.controls.Text;
    import mx.core.Application;
    import mx.core.UIComponent;
    import mx.events.CloseEvent;
    import mx.managers.PopUpManager;
    import mx.utils.StringUtil;

    /**
     * ItemRenderer to view the Contract Details from the Derivative Trade Query Result page
     */ 
    public class DrvTrdCloseOutAmendCancelRenderer extends Text
    {
         public var _mode = "closeoutentry";
         private var sPopup : SummaryPopup;
        private const BLUE_COLOR:uint = 0x0000FF; // Blue  
        private const CONTRACT_DETAILS_SWF : String = "assets/appl/drv/ContractDetailView.swf";
        
        public function DrvTrdCloseOutAmendCancelRenderer()
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
        			
        			
        		sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
        		//sPopup.addEventListener("RefreshChanges",handleRefreshChanges,false,0,true);
        		if(_mode == "closeoutentry"){        			
        		   sPopup.title =  Application.application.xResourceManager.getKeyValue('drv.label.closeout.entry');
        		}else{
        			sPopup.title = Application.application.xResourceManager.getKeyValue('drv.label.closeout.cxl');
        		}
        		sPopup.addEventListener(CloseEvent.CLOSE,closeHandler,false,0,true);
        		//sPopup.addEventListener(CloseEvent.CLOSE,handleCloseEvent,false,0,true);
        		// this.parentApplication.xResourceManager.getKeyValue('rec.xenos.cash.label.adjustment') + " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.entry'); //"Adjustment Entry";
                //set the width and height of the popup
                sPopup.width = 1180;
        		sPopup.height = 500;    		
        		/* sPopup.horizontalScrollPolicy="off";
        		sPopup.verticalScrollPolicy="off"; */
        		PopUpManager.centerPopUp(sPopup);
                
                // var rowNum : String = this.parentDocument.adjEntryDg.selectedIndex;
                //XenosAlert.info("rowNum = " + rowNum);
        	if(_mode == "closeoutentry"){
        		//Setting the Module path with some parameters which will be needed in the module for internal processing.                                                       
        		sPopup.moduleUrl = "assets/appl/drv/DrvTradeCloseOutEntry.swf" + Globals.QS_SIGN + "mode" + Globals.EQUALS_SIGN + this._mode+ Globals.AND_SIGN + "contractPk"+ Globals.EQUALS_SIGN + data.contractPk+ Globals.AND_SIGN + "rowNo"+ Globals.EQUALS_SIGN + data.rowNo+Globals.AND_SIGN +"contractRefNo"+ Globals.EQUALS_SIGN +data.contractReferenceNo;
        	
        	}else if(_mode == "closeoutcancel"){
        		sPopup.moduleUrl = "assets/appl/drv/DrvTradeCloseOutCancel.swf" + Globals.QS_SIGN + "mode" + Globals.EQUALS_SIGN + this._mode+ Globals.AND_SIGN + "contractPk"+ Globals.EQUALS_SIGN + data.contractPk+Globals.AND_SIGN +"contractRefNo"+ Globals.EQUALS_SIGN +data.contractReferenceNo;
        	}
            }
        	
        	
        	/**
        	 * Event Handler for the custom event "OkSystemConfirm"
        	 */
        	public function closeHandler(event:CloseEvent):void {
        		//this.parentDocument.currentState = "";
                if(_mode == "closeoutentry")
                  this.parentDocument.dispatchEvent(new Event("amendSubmit"));
                else if(_mode == "closeoutcancel")
                  this.parentDocument.dispatchEvent(new Event("cancelSubmit"));
                  
                  sPopup.removeMe();
                //this.parentDocument.submitQuery();
            }
        
        
    }
}