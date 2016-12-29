
package com.nri.rui.ref.renderers
{
	import com.nri.rui.ref.popupImpl.HolidayPopup;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	/**
	 * This class should be used as ItemEditor in DataGrid.
	 */
	 	
	public class HolidayPopupRenderer extends PopupRenderer
	{
		
		[Bindable]
        //Items returning through context - Non display objects
        public var retContextItem:ArrayCollection = new ArrayCollection();
        
        [Bindable]
        //Items receiving through context - Non display objects
        public var recContextItem:ArrayCollection = new ArrayCollection();
		
				
		public function HolidayPopupRenderer()
		{
			super();			
		}
		
	    
	   
	     /*
	     * Override showPopUp() in parent
         * Open the Holiday PopUp Window.
         * Cast the return value of the createPopUp() method
         * to holiday, the name of the component containing
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
            var holidayPopUp:HolidayPopup=HolidayPopup
            (PopUpManager.createPopUp( UIComponent(this.parentApplication), HolidayPopup , true));
            //Center the Popup Window in the Application's container
            PopUpManager.centerPopUp(holidayPopUp);
            /* Pass a reference to the AutoComplete control
             * to the PopUpWindow container so that the 
             * PopUpWindow container can return data to the main application.
             */
            holidayPopUp.owner=this;
            holidayPopUp.retTxtInput = this.textInput;
            // Pass a reference to the returnning context items
            holidayPopUp.returnContextItems = retContextItem;
            // Pass a reference to the popup context items
            holidayPopUp.receiveCtxItems = recContextItem;
            //initialize the holiday popup
            holidayPopUp.initPopup();
           
        }

	}
}
