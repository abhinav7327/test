
package com.nri.rui.frx.renderers
{
	import flash.events.MouseEvent;
	import mx.utils.StringUtil;
	public class FrxTradeNettedDetailRenderer extends FrxTradeDetailRenderer
	{
		public function FrxTradeNettedDetailRenderer()
		{
			super();
		}
		override public function set data(value:Object):void{
			super.data = value;			
			setVisibleProp();
		}
		private function setVisibleProp():void{
			
			var visibleFlag : Boolean = (StringUtil.trim(data.instructionType) == 'MT304') ? true:false;
			buttonMode = visibleFlag;
			useHandCursor = visibleFlag;
			mouseChildren = !visibleFlag;
			if(visibleFlag){
				setStyle("color",0x007ac8);
				setStyle("textDecoration","underline");
				addEventListener(MouseEvent.CLICK, handleMouseClick);
			}
			else{
				if(hasEventListener(MouseEvent.CLICK))
					removeEventListener(MouseEvent.CLICK,handleMouseClick);
				setStyle("color",0x000000);
				setStyle("textDecoration","normal");				
			}
			
		}
	}
}