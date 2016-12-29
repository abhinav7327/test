
package com.nri.rui.cax.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.controls.Label;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.dataGridClasses.DataGridListData;
	import com.nri.rui.core.controls.XenosAlert;

	public class FinalizedFlagRenderer extends Label
	{
		private const UCONF_COLOR:uint = 0xFF0000; // Red
		private const SCONF_COLOR:uint = 0x000000; //black
		
		public function FinalizedFlagRenderer()
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
            	text = "No";
            }
		}
		/**
         * This method overrides the updateDisplayList method to set the label 
         * of the DataGrid column's element to "" if it is NORMAL else
         * set the label to CXL in red.
         */
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
	       	if(this.parentDocument.uConfSubmit.includeInLayout) {
	        	setStyle("color", UCONF_COLOR);
	        } else if(this.parentDocument.sConfLabel.includeInLayout) {
	        	 setStyle("color", SCONF_COLOR);
	        }
        }
	}
}