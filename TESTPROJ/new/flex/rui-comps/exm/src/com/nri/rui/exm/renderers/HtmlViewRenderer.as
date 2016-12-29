

package com.nri.rui.exm.renderers
{	
            import com.nri.rui.core.Globals;
            import com.nri.rui.core.containers.SummaryPopup;
            import com.nri.rui.core.controls.XenosAlert;
            import com.nri.rui.exm.ExmConstraints;
            
            import flash.events.MouseEvent;
            import flash.net.URLRequest;
            import flash.net.URLRequestMethod;
            import flash.net.navigateToURL;
            
            import mx.containers.VBox;
            import mx.controls.Image;
            import mx.core.UIComponent;
            import mx.managers.PopUpManager;

	public class HtmlViewRenderer extends VBox
	{
		
  		[Embed(img.source="../../../../../../assets/icon_view.png")]
		[Bindable]
		private var icoSummary:Class;
		public function HtmlViewRenderer()
		{
			super();
			var img:Image = new Image();
			img.source=icoSummary;	
			//img.source = "../../../../../../assets/icon_view.png";
			addChild(img);
			super.setStyle("horizontalAlign","center");
			super.setStyle("verticalAlign","middle");
			img.buttonMode=true;
			img.useHandCursor=true;
			img.addEventListener(MouseEvent.CLICK, handleMouseClick);
		}
		
		
		public function handleMouseClick(event:MouseEvent):void {
			
            var messagePkStr : String = data.messagePk;           				
			
			var url : String = "exm/browseExm.action?method=viewHtml&messagePk="+messagePkStr;
			
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