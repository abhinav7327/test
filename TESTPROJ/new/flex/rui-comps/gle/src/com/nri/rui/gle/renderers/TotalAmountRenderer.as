package com.nri.rui.gle.renderers{
	
 import mx.controls.Label;
 import mx.controls.listClasses.*;

    public class TotalAmountRenderer extends Label {

//        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
//            super.updateDisplayList(unscaledWidth, unscaledHeight);
//            if(data.shortName=="Sub Total:" || data.shortName=="Grand Total:")
//            	setStyle("fontWeight","bold");
//            else
//            	 setStyle("fontWeight","normal");
//        }
        override public function set data(value:Object):void{            
            if(value != null){
                text = value.shortName;
                if(value.shortName=="Sub Total:" || value.shortName=="Grand Total:")
                  	setStyle("fontWeight","bold");
                else
                    setStyle("fontWeight","normal");
            }
        }
    }
}