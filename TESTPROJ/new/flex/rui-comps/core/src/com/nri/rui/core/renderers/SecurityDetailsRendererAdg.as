
package com.nri.rui.core.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.utils.XenosPopupUtils;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Text;
	import mx.core.UIComponent;
	import mx.utils.StringUtil;
	
		
	public class SecurityDetailsRendererAdg extends Text {
		//private var _data:DataGridColumn;
		public function SecurityDetailsRendererAdg() {
			super();
			//addEventListener(MouseEvent.CLICK, handleMouseClick);
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			 super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		
		
		override public function set data(value:Object):void{
			super.data = value;
			//visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
			setVisibleProp();
		}
		
		private function setVisibleProp():void{
			
			var visibleFlag : Boolean = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
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
		
		public function handleMouseClick(event:MouseEvent):void {
			
			var instPkStr : String = data.instrumentPk;
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			XenosPopupUtils.showInstrumentDetails(instPkStr,parentApp);
			
		}
		
		override public function validateProperties():void {
			super.validateProperties();
			
		}
	}

}