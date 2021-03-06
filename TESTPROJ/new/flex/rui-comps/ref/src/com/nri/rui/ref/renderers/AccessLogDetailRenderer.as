// ActionScript file

package com.nri.rui.ref.renderers
{
	
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.containers.SummaryPopup;
	
	import flash.events.MouseEvent;
	
	import mx.controls.DataGrid;
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;

	public class AccessLogDetailRenderer extends Text
	{
		
  		/* [Embed(source="../../../../../../assets/icon_view.png")]
		[Bindable]
		private var icoSummary:Class; */
		var column : DataGridColumn=null;
		public function AccessLogDetailRenderer()
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
				//removeEventListener(MouseEvent.CLICK,handleMouseClick);
			}
			
		}
		
		public function handleMouseClick(event:MouseEvent):void {
			
			var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
			
			sPopup.title = this.parentApplication.xResourceManager.getKeyValue('ref.accesslog.title.renderer');
			/* sPopup.width = 900;
			sPopup.height = 600; */
			sPopup.width = 650;
    		sPopup.height = 420;
			/* sPopup.horizontalScrollPolicy="off";
			sPopup.verticalScrollPolicy="off"; */
			PopUpManager.centerPopUp(sPopup);		
			var employeePkStr : String = data.employeePk;
			sPopup.moduleUrl = Globals.ACCESS_LOG_DETAILS_SWF+Globals.QS_SIGN+"employeePk"+Globals.EQUALS_SIGN+employeePkStr;
			
		}
	}
}
