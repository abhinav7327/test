
 
package com.nri.rui.core.renderers
{
    import mx.controls.Label;
    import mx.controls.dataGridClasses.DataGridColumn;
    import mx.controls.dataGridClasses.DataGridListData;
    import com.nri.rui.core.utils.XenosStringUtils;    
    
    /**
    *    ItemRenderer for displaying the DataGrid column's Numbers(may be formatted in some way) 
    *    in RED if they are Negative else in Black if Positive. 
    * 
    */
    public class NegativeNumberRenderer extends Label
    {
        private const POSITIVE_COLOR:uint = 0x000000; // Black
        private const NEGATIVE_COLOR:uint = 0xFF0000; // Red 
        private const NEGATIVE_SIGN : String = "-";
        
        public function NegativeNumberRenderer()
        {
            super();
        }
        private var _data:DataGridColumn;

		override public function get data():Object
		{
			return _data;
		}

		override public function set data(value:Object):void {
			_data = value as DataGridColumn;
			
			 if(listData){
               text = DataGridListData(listData).label ;
    		 }
		}
        /**
         * This method overrides the updateDisplayList method to set the color 
         * of the DataGrid column's element to Red if it is negative number else
         * set the color to Black.
         */
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