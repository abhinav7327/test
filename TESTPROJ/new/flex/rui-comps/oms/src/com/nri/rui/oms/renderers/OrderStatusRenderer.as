
package com.nri.rui.oms.renderers {
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.controls.Label;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.dataGridClasses.DataGridListData;

	public class OrderStatusRenderer extends Label {
		private const CXL_COLOR:uint = 0xFF0000; // Red
		
		private const NEW_COLOR:uint = 0x000000; // black
		
		private var _data:DataGridColumn;
		
		public function OrderStatusRenderer() {
			super();
		}

		override public function get data():Object {
			return _data;
		}

		override public function set data(value:Object):void {
			_data = value as DataGridColumn;
			if (listData != null)
				text = DataGridListData (listData).label ;
		}
		
		/**
         * This method overrides the updateDisplayList method to set the colour of status 
         * to red for AMEND, CANCEL orders and black for NEW orders.
         */
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            if (listData) {
                //text = DataGridListData (listData).label ;
                if (XenosStringUtils.equals(text, Globals.STATUS_CANCEL) || XenosStringUtils.equals(text, "AMEND")) {
                    setStyle("color", CXL_COLOR);
                } else if (XenosStringUtils.equals(text, "NEW")) {
                	 setStyle("color", NEW_COLOR);
                }
            }            
        }
		
	}
}