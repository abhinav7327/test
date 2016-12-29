
package com.nri.rui.oms.renderers
{
	import com.nri.rui.ref.popupImpl.FundPopup;
	import com.nri.rui.ref.renderers.PopupRenderer;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	/**
	 * This class should be used as ItemEditor in DataGrid.
	 */
	 	
	public class FundPopUpRenderer extends PopupRenderer
	{
		
		[Bindable]
        //Items returning through context - Non display objects
        public var retContextItem:ArrayCollection = new ArrayCollection();
        
        [Bindable]
        //Items receiving through context - Non display objects
        public var recContextItem:ArrayCollection = new ArrayCollection();
		
				
		public function FundPopUpRenderer()
		{
			super();			
		}
		
	    
	   
	     /*
	     * Override showPopUp() in parent
         * Open the Fund  PopUp Window.
         * Cast the return value of the createPopUp() method
         * to fund maintenance, the name of the component containing
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
            var fundPopUp:FundPopup=FundPopup
            (PopUpManager.createPopUp( UIComponent(this.parentApplication), FundPopup , true));
            //Center the Popup Window in the Application's container
            PopUpManager.centerPopUp(fundPopUp);
            /* Pass a reference to the AutoComplete control
             * to the PopUpWindow container so that the 
             * PopUpWindow container can return data to the main application.
             */
            fundPopUp.owner=this;
            fundPopUp.retTxtInput = this.textInput;
            // Pass a reference to the returnning context items
            fundPopUp.returnContextItems = retContextItem;
            // Pass a reference to the popup context items
            fundPopUp.receiveCtxItems = recContextItem;
            //initialize the holiday popup
            fundPopUp.initPopup();
           
        }

	}
}
