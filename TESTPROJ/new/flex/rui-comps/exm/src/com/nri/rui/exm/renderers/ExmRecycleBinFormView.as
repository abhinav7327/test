

package com.nri.rui.exm.renderers
{	        import com.nri.rui.core.Globals;
import com.nri.rui.core.containers.SummaryPopup;
import com.nri.rui.exm.ExmConstraints;

import flash.events.MouseEvent;

import mx.controls.Image;
import mx.core.UIComponent;
import mx.managers.PopUpManager;

	public class ExmRecycleBinFormView extends Image
	{
		
		public var sPopup : SummaryPopup;	
		
  		[Embed(source="../../../../../../assets/icon_view.png")]
		[Bindable]
		private var icoSummary:Class;
		public function ExmRecycleBinFormView()
		{
			super();
			source=icoSummary;	
			super.setStyle("horizontalAlign","center");
			buttonMode=true;
			useHandCursor=true;
			addEventListener(MouseEvent.CLICK, handleMouseClick);
		}
		
		
		public function handleMouseClick(event:MouseEvent):void {
			
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
			
			sPopup.title = "Generated Form View";
			sPopup.width = parentApplication.width*60/100;
    		sPopup.height = parentApplication.height*60/100;
			PopUpManager.centerPopUp(sPopup);		
			var messageIdStr : String =data.messageId;
			var messageTypeStr : String = data.messageType;
			var queueIdStr : String = data.queueId;
			sPopup.moduleUrl = ExmConstraints.PARENT_RECYCLE_BIN_MESSAGE_FORM_VIEW_SWF+Globals.QS_SIGN+"messageId"+Globals.EQUALS_SIGN+messageIdStr+Globals.AND_SIGN+"messageType"+Globals.EQUALS_SIGN+messageTypeStr+Globals.AND_SIGN+"qId"+Globals.EQUALS_SIGN+queueIdStr+Globals.AND_SIGN+"mode"+Globals.EQUALS_SIGN+"flex";
			sPopup.owner=this;				
		}
		
		public function romoveCloseIcon():void {
			sPopup.showCloseButton=false;
			sPopup.invalidateDisplayList();
		}
		
	}
}