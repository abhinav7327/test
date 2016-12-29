
 
package com.nri.rui.gle.renderers
{
    import mx.controls.Label;
    import mx.controls.dataGridClasses.DataGridColumn;
    import mx.controls.dataGridClasses.DataGridListData;
    import mx.utils.StringUtil;
    
    /**
    *    ItemRenderer for displaying the DataGrid column's value(may be formatted in some way). 
    * 
    */
    public class GleTransactionStatusRenderer extends Label
    {
        private const COLOR_BLACK:uint = 0x000000; // Black
        private const COLOR_RED:uint = 0xFF0000; // Red 
        
        public function GleTransactionStatusRenderer()
        {
            super();
        }
        private var _data:DataGridColumn;

		override public function get data():Object
		{
			return _data;
		}

		override public function set data(value:Object):void
		{
			_data = value as DataGridColumn;
			if(listData){
				if(listData is DataGridListData){
                var dataField:String = DataGridListData(listData).dataField ;
                
                 if(StringUtil.trim(String(value[dataField])).toLocaleUpperCase()=="CANCEL"){
               		text="CXL";
               		setStyle("color",  COLOR_RED) ;
	               }else{
	               		text="";
	               		setStyle("color",  COLOR_BLACK) ;
	               }
    			}
              
            } 
            
            
			
		}
        /**
         * This method overrides the updateDisplayList method to set the color 
         * of the DataGrid column's element to Red if it is negative number else
         * set the color to Black.
         */
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
                       
        }

    }
}