package com.nri.rui.core.controls
{
	import mx.controls.Label;
	import mx.core.UITextField;
	import flash.display.DisplayObject;
	import mx.events.FlexEvent;
	import com.nri.rui.core.utils.XenosStringUtils;

	public class XenosLabel extends Label
	{
		private var _isWrapReq:Boolean = false;
		
		public function get isWrapReq():Boolean{
			return _isWrapReq;
		}
		
		public function set isWrapReq(wrap:Boolean):void{
			_isWrapReq = wrap;
		}
		public function XenosLabel()
		{
			//TODO: implement function
			super();
			truncateToFit = false;
			visible = false;
			includeInLayout = false;
			this.addEventListener(FlexEvent.VALUE_COMMIT, showControl);
		}
		
		override protected function createChildren():void
		{
			// Create a UITextField to display the label.
			if(isWrapReq){
				if (!textField)
				{
					textField = new UITextField();
					textField.styleName = this;
					addChild(DisplayObject(textField));
				} 
				super.createChildren();
				textField.multiline = true;
				textField.wordWrap = true;
				this.height = (measureText("W").height + 5) * Math.ceil(Number(measureText(text).width/this.width));
			}
		}
		
		private function showControl(e:FlexEvent):void{
			if(!XenosStringUtils.isBlank(this.text)){
				visible = true;
				includeInLayout = true;
				if(isWrapReq){
					if(textField != null){
						this.height = (measureText("W").height + 5) * Math.ceil(Number(measureText(text).width/this.width));
					}
				}
			}else{
				visible = false;
				includeInLayout = false;
			}
			
		}
		
	}
}