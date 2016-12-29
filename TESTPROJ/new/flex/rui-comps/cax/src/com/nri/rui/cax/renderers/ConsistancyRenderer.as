
package com.nri.rui.cax.renderers
{
	import com.nri.rui.core.controls.XenosAlert;
	
	import mx.controls.Label;
	import mx.controls.dataGridClasses.DataGridColumn;

	public class ConsistancyRenderer extends Label
	{
		private const INCON_COLOR:uint = 0xFF0000; // Red
		private const CON_COLOR:uint = 0x007ac8; // Blue
		public function ConsistancyRenderer()
		{
			super();
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			setVisibleProp();
		}
		/**
         * This method overrides the updateDisplayList method to set the label 
         * of the DataGrid column's element to "Y" if it is Concistant else
         * set the label to "N" in red if it is Inconcistant.
         */
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
                                   
        }
        
        private function setVisibleProp():void{
			//XenosAlert.info("ownerLocationConsistency "+data.ownerLocationConsistency);
                if(data.ownerLocationConsistency == "Y"){                    
                    setStyle("color", CON_COLOR);
                }else if(data.ownerLocationConsistency == "N"){
                    setStyle("color", INCON_COLOR);
                }
			
			
		}
	}
}