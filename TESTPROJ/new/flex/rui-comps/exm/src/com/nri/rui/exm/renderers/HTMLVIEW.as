

package com.nri.rui.exm.renderers
{	
            import flash.events.MouseEvent;
            import com.nri.rui.core.Globals;
		    import com.nri.rui.core.containers.SummaryPopup;
		    import com.nri.rui.core.controls.XenosAlert;
            import mx.controls.Image;
            import mx.core.UIComponent;
            import mx.managers.PopUpManager;

            import com.nri.rui.exm.ExmConstraints;
			import flash.events.MouseEvent;
			import flash.net.URLRequest;
            import flash.net.URLRequestMethod;
			import flash.net.navigateToURL;

	public class HTMLVIEW extends Image
	{
		
  		[Embed(source="../../../../../../assets/icon_view.png")]
		[Bindable]
		private var icoSummary:Class;
		public function HTMLVIEW()
		{
			super();
			source=icoSummary;	
			super.setStyle("horizontalAlign","center");
			buttonMode=true;
			useHandCursor=true;
			addEventListener(MouseEvent.CLICK, handleMouseClick);
		}
		
		
		public function handleMouseClick(event:MouseEvent):void {
			
				
			var messageIdStr : String = data.messageId;
			var messageTypeStr : String = data.messageType;
			var queueIdStr : String = data.queueId;
			var url : String = "exm/messageBrowser.action?method=viewDetails&"+"action"+Globals.EQUALS_SIGN+messageIdStr+Globals.AND_SIGN+"messageType"+Globals.EQUALS_SIGN+messageTypeStr+Globals.AND_SIGN+"qId"+Globals.EQUALS_SIGN+queueIdStr+Globals.AND_SIGN+"mode"+Globals.EQUALS_SIGN+"html"+Globals.AND_SIGN+"rui"+Globals.EQUALS_SIGN+"RUI";
			
            var request:URLRequest = new URLRequest(url);
             request.method = URLRequestMethod.POST;
	         try {
	                navigateToURL(request,"_blank");
	            }
	            catch (e:Error) {
	                // handle error here
	                trace(e);
	            }
		}

	}
}