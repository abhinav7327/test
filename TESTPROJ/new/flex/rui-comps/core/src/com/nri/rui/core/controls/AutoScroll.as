package com.nri.rui.core.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import flexlib.containers.WindowShade;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.core.Container;
	import mx.modules.Module;
			    
	public class AutoScroll
	{
		private static var obj:Object;
		private static var  objContainer:Object;
		
		public function AutoScroll()
		{
		}
		
		public static function set currentObjContainer(value:Object):void
		{
			objContainer = value;
		}
		
		public static function set currentObj(value:Object):void
		{
			obj = value;
		}
		
		public static function updateDisplayList(evt : Event) : void 
	    {
    		var focusItem : DisplayObject;
    		var container : Container;
    		if(objContainer==null)
    		{
    			
    			container = Container(evt.currentTarget);
            	container= Container(container.parent);
            	
      		}
    		else if(objContainer is Module)
    		
    			container = objContainer as Module;
    		else if(objContainer is Canvas)
    		
    			container = objContainer as Canvas;
            //container= Container(containerparent);
            
            if(obj is WindowShade)
            	focusItem = DisplayObject(obj as WindowShade);
            	
            if(container.verticalScrollBar && focusItem) {
            	
    			var scrollbarRange : int = container.verticalScrollBar.maxScrollPosition;
				var newPos : int = Math.min(scrollbarRange, focusItem.y);
				container.verticalScrollPosition = newPos;   
				objContainer=null;         		
    		} 
        }
	}
}