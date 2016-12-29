
package com.nri.rui.rec.renderers
{	        
	import flash.events.FocusEvent;
	
	import mx.controls.TextArea;

	public class RemarksEntryRenderer extends TextArea
	{
		
  		private var isRmksModified:Boolean = false;
  		private var rmksLength:int = 1000;
		
		 public function RemarksEntryRenderer()
        {            
            super();   
            this.editable = true;
            this.maxChars = rmksLength;
            this.styleName = "ReqdLabel";
			addEventListener(FocusEvent.FOCUS_OUT , changeHandler);
			addEventListener(FocusEvent.FOCUS_IN , changeHandler);

        }

		override public function set data(value:Object):void{
			super.data = value;
			if(!isRmksModified && data != null)
				this.text = data.remarks;
		}

    	/**
    	 * Mouse Click event handler to open a popup with initialization and passing values.
    	 * 
    	 */ 
         public function changeHandler(event:FocusEvent):void {
         	isRmksModified = true; 
         	if(listData){
	    		 parentDocument.rmksArray[listData.rowIndex] = text;
    		 }
    	
    	} 
		
	}
}

