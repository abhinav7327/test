
package com.nri.rui.ref.renderers
{ 
	import mx.controls.TextArea;
	public class BatchExecutionQueryDetailErrorLogRenderer extends TextArea
	{
		public function BatchExecutionQueryDetailErrorLogRenderer()
		{
			super();
			super.wordWrap = true;
			super.horizontalScrollPolicy = "off";
			super.editable = false ;
			super.height = 70;
		}
		override public function set data(value:Object):void{
			super.data = value;
		}

	}
}