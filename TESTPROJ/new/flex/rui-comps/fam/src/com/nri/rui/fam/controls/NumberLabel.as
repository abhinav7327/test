
 
package com.nri.rui.fam.controls
{
	import mx.controls.Label;
    import com.nri.rui.core.utils.XenosStringUtils; 
    
    /*
     This class adds the feature of displaying negetive number in red color
     and positive number in black color to a Label
    */
	public class NumberLabel extends Label
	{
		private const POSITIVE_COLOR:uint = 0x000000; // Black
        private const NEGATIVE_COLOR:uint = 0xFF0000; // Red 
        private const NEGATIVE_SIGN : String = "-";
        
        public function NumberLabel()
        {
            super();
        }
    
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);                       
            if(!XenosStringUtils.isBlank(text) && text.charAt(0) == NEGATIVE_SIGN){                    
                setStyle("color", NEGATIVE_COLOR) ;
            }else {
                setStyle("color", POSITIVE_COLOR);
            }                        
        }

	}
}