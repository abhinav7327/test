
package com.nri.rui.oms.renderers
{
	import com.nri.rui.ref.popupImpl.InstrumentPopup;
	import com.nri.rui.ref.renderers.PopupRenderer;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	/**
	 * This class should be used as ItemEditor in DataGrid.
	 */
	 	
	public class SecurityCodePopUpRenderer extends PopupRenderer
	{
		
		[Bindable]
        //Items returning through context - Non display objects
        public var retContextItem:ArrayCollection = new ArrayCollection();
        
        [Bindable]
        //Items receiving through context - Non display objects
        public var recContextItem:ArrayCollection = new ArrayCollection();
		
				
		public function SecurityCodePopUpRenderer()
		{
			super();			
		}
		
	    
	   
	     /*
	     * Override showPopUp() in parent
         * Open the Security Code PopUp Window.
         * Cast the return value of the createPopUp() method
         * to Fund Maintenance, the name of the component containing
         *  the PopupWindow container
         */
        override protected function showPopUp():void {
            if (recContextItem == null){
                recContextItem = new ArrayCollection();
            }
            
            if (retContextItem == null){
                retContextItem = new ArrayCollection();
            }
            //create the fininst popup        
            var instPopUp:InstrumentPopup=InstrumentPopup
            (PopUpManager.createPopUp( UIComponent(this.parentApplication), InstrumentPopup , true));
            //Center the Popup Window in the Application's container
            PopUpManager.centerPopUp(instPopUp);
            /* Pass a reference to the AutoComplete control
             * to the PopUpWindow container so that the 
             * PopUpWindow container can return data to the main application.
             */
            instPopUp.owner=this;
            instPopUp.retTxtInput = this.textInput;
            // Pass a reference to the returnning context items
            instPopUp.returnContextItems = retContextItem;
            // Pass a reference to the popup context items
            instPopUp.receiveCtxItems = recContextItem;
            //initialize the holiday popup
            instPopUp.initPopup();
           
        }

	}
}
