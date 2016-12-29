package com.nri.rui.ref.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.containers.SummaryPopup;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Text;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;
	public class ApplicationRoleDetailRenderer extends Text
	{
		public function ApplicationRoleDetailRenderer()
		{
			super();
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
    		 super.updateDisplayList(unscaledWidth, unscaledHeight);    			
    		 
    	}
    	
    	override public function set data(value:Object):void{
			super.data = value;
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
		
		
    		/**
        	 * Mouse Click event handler to open a popup with initialization and passing values.
        	 * 
        	 */ 
            public function handleMouseClick(event:MouseEvent):void {
        			
        		var sPopup : SummaryPopup;	
        		sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
                sPopup.title = this.parentApplication.xResourceManager.getKeyValue('ref.applrole.title.renderer');
        		// this.parentApplication.xResourceManager.getKeyValue('rec.xenos.cash.label.adjustment') + " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.entry'); //"Adjustment Entry";
                //set the width and height of the popup
                sPopup.width = 950;
        		sPopup.height = 650;    		
        		PopUpManager.centerPopUp(sPopup);
        
        		
        		//Setting the Module path with some parameters which will be needed in the module for internal processing.                                                       
        		sPopup.moduleUrl = "assets/appl/ref/ApplicationRoleEntry.swf" + Globals.QS_SIGN + "mode" + Globals.EQUALS_SIGN + "view" + Globals.AND_SIGN + "appRolePk"+ Globals.EQUALS_SIGN + data.applRolePk;
        	}
	}
}