
package com.nri.rui.ref.renderers
{
	import com.nri.rui.ref.popupImpl.CountryPopUp;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	/**
	 * This class should be used as ItemEditor in DataGrid.
	 */
	 	
	public class CountryPopupRenderer extends PopupRenderer
	{
		
		[Bindable]
        //Items returning through context - Non display objects
        public var retContextItem:ArrayCollection = new ArrayCollection();
        
        [Bindable]
        //Items receiving through context - Non display objects
        public var recContextItem:ArrayCollection = new ArrayCollection();
		
				
		public function CountryPopupRenderer()
		{
			super();			
		}
		
	    
	   
	     /*
	     * Override showPopUp() in parent
         * Open the country PopUp Window.
         * Cast the return value of the createPopUp() method
         * to country, the name of the component containing
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
            var countryPopUp:CountryPopUp=CountryPopUp
            (PopUpManager.createPopUp( UIComponent(this.parentApplication), CountryPopUp , true));
            //Center the Popup Window in the Application's container
            PopUpManager.centerPopUp(countryPopUp);
            /* Pass a reference to the AutoComplete control
             * to the PopUpWindow container so that the 
             * PopUpWindow container can return data to the main application.
             */
            countryPopUp.owner=this;
            countryPopUp.retTxtInput = this.textInput;
            // Pass a reference to the returnning context items
            countryPopUp.returnContextItems = retContextItem;
            // Pass a reference to the popup context items
            countryPopUp.receiveCtxItems = recContextItem;
            //initialize the fin inst popup
            countryPopUp.initPopup();
           
        }

	}
}