

package com.nri.rui.exm.renderers
{	        

    import com.nri.rui.core.Globals;
    import com.nri.rui.core.containers.SummaryPopup;
    
    import flash.events.MouseEvent;
    
    import mx.controls.Image;
    import mx.core.UIComponent;
    import mx.events.CloseEvent;
    import mx.managers.PopUpManager;

	public class EditRenderer extends Image
	{
		
  		[Embed(source="../../../../../../assets/icon_view.png")]
		[Bindable]
		private var icoSummary:Class;
		public function EditRenderer()
		{
			super();
			source=icoSummary;	
			super.setStyle("horizontalAlign","center");
			buttonMode=true;
			useHandCursor=true;
			addEventListener(MouseEvent.CLICK, handleMouseClick);
		}
		
		
		public function handleMouseClick(event:MouseEvent):void {
			
			var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
			//sPopup.addEventListener("RefreshParentWindow",refreshParentWindow);
			sPopup.title = "Edit Exm Message";
			sPopup.width = parentApplication.width - 100;
    		sPopup.height = parentApplication.height - 50;
			PopUpManager.centerPopUp(sPopup);
			sPopup.addEventListener(CloseEvent.CLOSE,closeHandler,false,0,true);		
			var messagePkStr : String = data.messagePk;
			var messageTypeStr : String = data.messageType;
			var queueIdStr : String = data.queueId;
			//XenosAlert.info("sPopup.moduleUrl "+ExmConstraints.EXM_MESSAGE_XML_VIEW_SWF+Globals.QS_SIGN+ExmConstraints.MESSAGE_ID+Globals.EQUALS_SIGN+messageIdStr+Globals.AND_SIGN+ExmConstraints.MESSAGE_TYPE+Globals.EQUALS_SIGN+messageTypeStr);
			sPopup.moduleUrl = "assets/appl/exm/EditExmMessage.swf"+Globals.QS_SIGN+"messagePk"+Globals.EQUALS_SIGN+messagePkStr+Globals.AND_SIGN+"messageType"+Globals.EQUALS_SIGN+messageTypeStr+Globals.AND_SIGN+"qId"+Globals.EQUALS_SIGN+queueIdStr+Globals.AND_SIGN+"mode"+Globals.EQUALS_SIGN+"edit";
			
		}
		
		/**
    	 * Event Handler for the custom event "OkSystemConfirm"
    	 */
    	public function closeHandler(event:CloseEvent):void {
            this.parentDocument.dispatchEvent(new Event("querySubmit")); 
        }

	}
}