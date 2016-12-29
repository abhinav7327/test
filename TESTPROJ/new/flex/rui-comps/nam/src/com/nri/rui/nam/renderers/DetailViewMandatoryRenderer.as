
package com.nri.rui.nam.renderers
{
	import com.nri.rui.core.utils.XenosStringUtils;
	import mx.controls.Label;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.states.SetStyle;
	import mx.controls.listClasses.*;
	
	public class DetailViewMandatoryRenderer extends Label
	{
		private const TRUE_COLOR:uint = 0xFF0000; // Red
		private const FALSE_COLOR:uint = 0x000000; // Black
		private const STS_TRUE:String = "true"; // true		
		private var mandatory:String = "";
		public function DetailViewMandatoryRenderer()
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
			this.mandatory= value.mandatory;
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
			if(XenosStringUtils.equals(mandatory,STS_TRUE)){
                	setStyle("color", TRUE_COLOR);
                }
                else{
                	setStyle("color",FALSE_COLOR);
            	}
            }
        }
	}
}