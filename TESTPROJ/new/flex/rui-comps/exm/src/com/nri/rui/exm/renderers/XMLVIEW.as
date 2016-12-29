

package com.nri.rui.exm.renderers
{	        import flash.events.MouseEvent;
            import com.nri.rui.core.Globals;
		    import com.nri.rui.core.containers.SummaryPopup;
		    import com.nri.rui.core.controls.XenosAlert;
            import mx.controls.Image;
            import mx.core.UIComponent;
            import mx.managers.PopUpManager;

            import com.nri.rui.exm.ExmConstraints;

	public class XMLVIEW extends Image
	{
		
  		[Embed(source="../../../../../../assets/icon_view.png")]
		[Bindable]
		private var icoSummary:Class;
		public function XMLVIEW()
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
			
			sPopup.title = "XML VIEW";
			sPopup.width = parentApplication.width - 100;
    		        sPopup.height = parentApplication.height - 100;
			PopUpManager.centerPopUp(sPopup);		
					
			var messageIdStr : String = data.messagePk;
			//XenosAlert.info("sPopup.moduleUrl "+ExmConstraints.EXM_MESSAGE_XML_VIEW_SWF+Globals.QS_SIGN+ExmConstraints.MESSAGE_ID+Globals.EQUALS_SIGN+messageIdStr);
			sPopup.moduleUrl = "assets/appl/exm/MessageXmlView.swf"+Globals.QS_SIGN+"messageId"+Globals.EQUALS_SIGN+messageIdStr+Globals.AND_SIGN+"mode"+Globals.EQUALS_SIGN+"xml";
		}

	}
}