
package com.nri.rui.ref.renderers
{
	import com.nri.rui.core.Globals;
	import flash.events.MouseEvent;
	import mx.controls.Text;
	import mx.utils.StringUtil;
	
	import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
   	import flash.net.URLRequestMethod;
	

	public class IntraReconDwnloadRenderer extends Text
	{
		
		public function IntraReconDwnloadRenderer()
		{
			super();
			//addEventListener(MouseEvent.CLICK, handleMouseClick);
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
		
		public function handleMouseClick(event:MouseEvent):void {
			
			var url:String = "download/";//  XenosDownloadServlet ?path="+text+"&type=download
            var request:URLRequest = new URLRequest(url);
            request.method = URLRequestMethod.POST;
            var variables:URLVariables = new URLVariables();
            variables.path = data.filePathAndName;//"/mnt/nas/pdf/CXENT-20090227-134056.xls";
			variables.type = "download";
			//variables.SCREEN_KEY=932;
            request.data = variables;
            try {
            	 navigateToURL(request,"_self");
            
            }  catch (e:Error) {
	                // handle error here
	                trace(e);
	        }
			
		}
		override public function validateProperties():void{
			super.validateProperties();
		}	
	}
}