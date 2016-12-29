package com.nri.rui.rec.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.renderers.InstrumentDetailsRenderer;
	
	import flash.events.MouseEvent;
	
	import mx.utils.StringUtil;

	public class InstrumentDetailsRenderer extends com.nri.rui.core.renderers.InstrumentDetailsRenderer
	{
		public function InstrumentDetailsRenderer()
		{
			super();
		}
		
		override public function set data(value:Object):void{
			super.data = value;
			//visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
			setVisibleProp();
		}
		
		private function setVisibleProp():void{
			
			var visibleFlag : Boolean = (StringUtil.trim(data.instrumentPk) == Globals.EMPTY_STRING ) ? false :true;
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
				//removeEventListener(MouseEvent.CLICK,handleMouseClick);
			}
			
		}
	}
}