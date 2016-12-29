

package com.nri.rui.cam.renderers
{
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.controls.Label;
	
	/**
	 * ItemRenderer for displaying the DataGrid column's Number field in RED.
	 */
	public class RowColorRenderer extends Label
	{
        private const POSITIVE_COLOR:uint = 0x000000; // Black
        private const NEGATIVE_COLOR:uint = 0xFF0000; // Red 
        private const NEGATIVE_SIGN : String = "-";
        private const ZERO_BALANCE : String = "F0.00";

		public function RowColorRenderer() {
			super();
		}
		
        /**
         * This method overrides the updateDisplayList method to set the color 
         * of the DataGrid column's element to Red if it is negative number else
         * set the color to Black.
         */
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            var sign : String = data.displayBalanceInRed;
            var bookvalue : String = data.formattedBookValue;
    		
    		if(XenosStringUtils.equals(bookvalue, ZERO_BALANCE)){
    		 	setStyle("color", POSITIVE_COLOR);
    		}
            if (XenosStringUtils.equals(sign, NEGATIVE_SIGN)) {
                setStyle("color", NEGATIVE_COLOR) ;
            } else {
                setStyle("color", POSITIVE_COLOR);
            }
        }

	}
}