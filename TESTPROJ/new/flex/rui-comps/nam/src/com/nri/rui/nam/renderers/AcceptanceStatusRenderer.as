
package com.nri.rui.nam.renderers
{
	import com.nri.rui.core.utils.XenosStringUtils;
	import mx.controls.Label;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.states.SetStyle;

	public class AcceptanceStatusRenderer extends Label
	{
		private const REJ_COLOR:uint = 0xFF0000; // Red
		private const ACC_COLOR:uint = 0x000000; // Black
		private const STS_ACCEPT:String = "ACCEPTED"; // Accepted
		private const STS_REJECT:String = "REJECTED"; // Rejected
		public function AcceptanceStatusRenderer()
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
		}
		/**
         * This method overrides the updateDisplayList method to set the label
         * of the DataGrid column's element to "" if it is NORMAL else
         * set the label to CXL in red.
         */
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);

            if(listData){
                text = DataGridListData(listData).label ;
			if(XenosStringUtils.equals(text,STS_REJECT) || XenosStringUtils.equals(text,"REJECTED")){
                	text = "REJECTED";
                    setStyle("color", REJ_COLOR);
                }
                else{
                	setStyle("color",ACC_COLOR);
            	}
            }
        }
	}
}