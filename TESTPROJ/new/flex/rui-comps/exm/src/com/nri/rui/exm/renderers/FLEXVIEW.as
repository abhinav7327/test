

package com.nri.rui.exm.renderers
{	        import flash.events.MouseEvent;
            import com.nri.rui.core.Globals;
		    import com.nri.rui.core.containers.SummaryPopup;
		    import com.nri.rui.core.controls.XenosAlert;
            import mx.controls.Image;
            import mx.core.UIComponent;
            import mx.managers.PopUpManager;
            import mx.controls.Alert;
            import com.nri.rui.exm.ExmConstraints;
            import flash.events.TimerEvent;

	public class FLEXVIEW extends Image
	{
		
  		[Embed(source="../../../../../../assets/icon_view.png")]
		[Bindable]
		private var icoSummary:Class;
		public function FLEXVIEW()
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
			sPopup.addEventListener("RefreshParentWindow",refreshParentWindow);
			sPopup.title = "Update XML message";
			sPopup.width = parentApplication.width - 100;
    		sPopup.height = parentApplication.height - 100;
			PopUpManager.centerPopUp(sPopup);		
			var messageIdStr : String = data.messageId;
			var messageTypeStr : String = data.messageType;
			var queueIdStr : String = data.queueId;
			//XenosAlert.info("sPopup.moduleUrl "+ExmConstraints.EXM_MESSAGE_XML_VIEW_SWF+Globals.QS_SIGN+ExmConstraints.MESSAGE_ID+Globals.EQUALS_SIGN+messageIdStr+Globals.AND_SIGN+ExmConstraints.MESSAGE_TYPE+Globals.EQUALS_SIGN+messageTypeStr);
			sPopup.moduleUrl = "assets/appl/exm/MessageFlexView.swf"+Globals.QS_SIGN+"messageId"+Globals.EQUALS_SIGN+messageIdStr+Globals.AND_SIGN+"messageType"+Globals.EQUALS_SIGN+messageTypeStr+Globals.AND_SIGN+"qId"+Globals.EQUALS_SIGN+queueIdStr+Globals.AND_SIGN+"mode"+Globals.EQUALS_SIGN+"flex";
			
			this.parentDocument.autoRefresh.selected=false;
			this.parentDocument.refreshButton.enabled=true;
			this.parentDocument.myTimer.stop();
			
		}
		
		/**
        	 * Event Handler for the custom event "OkSystemConfirm"
        	 */
        	public function refreshParentWindow(event:Event):void {
        	    this.parentDocument.myTimer.dispatchEvent(new TimerEvent("timer"));
            }

	}
}