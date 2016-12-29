/*

$LastChangedDate$
$Author: amitp $  Amitp
*/


package com.nri.rui.core.controls{
	
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.startup.XenosApplication;
	import com.nri.rui.core.utils.CursorUtils;
	import com.nri.rui.core.utils.PopupConstant;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.containers.TitleWindow;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.MoveEvent;
	
	
	//[Event(name="closeWindow", type="mx.events.FlexEvent")]
	//[Event(name="minWindow", type="mx.events.FlexEvent")]
	//[Event(name="maxWindow", type="mx.events.FlexEvent")]
			
	/**
	 *A resizable TitleWindow control for the detail screens. 
	 * @author amitp
	 * 
	 */	
	public class ResizeWindow extends TitleWindow{
		
		private static var resizeObj:Object;
		private static var mouseState:Number = 0;
		private static var mouseMargin:Number = 10;

		
		private var oWidth:Number = 0;
		private var oHeight:Number = 0;
		private var oX:Number = 0;
		private var oY:Number = 0;
		private var oPoint:Point = new Point();
		
		//private var _showWindowButtons:Boolean = false;
		private var _windowMinSize:Number = 50;
		
		/**
	 	 * Constructor.
	 	 * Add mouse envent to this window and application.
	 	 * initialize the old positions.
	 	 */
		public function ResizeWindow(){
			super();
			initPosition(this);
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, oMouseMove);
			this.addEventListener(MouseEvent.MOUSE_OUT, oMouseOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN, oMouseDown);
			
			this.addEventListener(MoveEvent.MOVE, window_moveHandler);
           

			//this.addEventListener(MouseEvent.MOUSE_UP, oMouseUp);
			//this.addEventListener(FlexEvent.CREATION_COMPLETE, addButton);
			
			//Application.application.parent:SystemManager
			Application.application.parent.addEventListener(MouseEvent.MOUSE_UP, oMouseUp);
			Application.application.parent.addEventListener(MouseEvent.MOUSE_MOVE, oResize);
		}
		
		/* public function set showWindowButtons(show:Boolean):void{
			_showWindowButtons = show;
			if(titleBar != null){
				addButton(new FlexEvent(""));
			}
		} */
		
		/* public function get showWindowButtons():Boolean{
			return _showWindowButtons;
		}
		 */
		public function set windowMinSize(size:Number):void{
			if(size > 0){
				_windowMinSize = size;
			}
		}
		
		public function get windowMinSize():Number{
			return _windowMinSize;
		}
		
		private static function initPosition(obj:Object):void{
			obj.oHeight = obj.height;
			obj.oWidth = obj.width;
			obj.oX = obj.x;
			obj.oY = obj.y;
		}
		
		/**
		 * Set the first global point that mouse down on the window.
		 * @param The MouseEvent.MOUSE_DOWN
		 */
		private function oMouseDown(event:MouseEvent):void{
			if(mouseState != PopupConstant.SIDE_OTHER){
				resizeObj = event.currentTarget;
				initPosition(resizeObj);
				oPoint.x = resizeObj.mouseX;
				oPoint.y = resizeObj.mouseY;
				oPoint = this.localToGlobal(oPoint);
			}
		}
		
		/**
		 * Clear the resizeObj and also set the latest position.
		 * @param The MouseEvent.MOUSE_UP
		 */
		private function oMouseUp(event:MouseEvent):void{
			var screenX:Number=Application.application.parent.mouseX;
			var screenY:Number=Application.application.parent.mouseY;
			if(resizeObj != null){				
					initPosition(resizeObj);				
			}			
			resizeObj = null;			
		}
		
		/**
		 * Show the mouse arrow when not draging.
		 * Call oResize(event) to resize window when mouse is inside the window area.
		 * @param The MouseEvent.MOUSE_MOVE
		 */
		private function oMouseMove(event:MouseEvent):void{
			var xPosition:Number = Application.application.parent.mouseX;
			var yPosition:Number = Application.application.parent.mouseY;
			if(xPosition>=5 && xPosition<=screen.width-5 && yPosition<=screen.height-5 && yPosition>=5)
			{
			if(resizeObj == null){	
				
					if(xPosition >= (this.x + this.width - mouseMargin) && yPosition >= (this.y + this.height - mouseMargin)){
						CursorUtils.changeCursor(PopupConstant.LEFT_OBLIQUE_SIZE, -6, -6);
						mouseState = PopupConstant.SIDE_RIGHT | PopupConstant.SIDE_BOTTOM;
					}else if(xPosition <= (this.x + mouseMargin) && yPosition <= (this.y + mouseMargin)){
						CursorUtils.changeCursor(PopupConstant.LEFT_OBLIQUE_SIZE, -6, -6);
						mouseState = PopupConstant.SIDE_LEFT | PopupConstant.SIDE_TOP;
					}else if(xPosition <= (this.x + mouseMargin) && yPosition >= (this.y + this.height - mouseMargin)){
						CursorUtils.changeCursor(PopupConstant.RIGHT_OBLIQUE_SIZE, -6, -6);
						mouseState = PopupConstant.SIDE_LEFT | PopupConstant.SIDE_BOTTOM;
					}else if(xPosition >= (this.x + this.width - mouseMargin) && yPosition <= (this.y + mouseMargin)){
						CursorUtils.changeCursor(PopupConstant.RIGHT_OBLIQUE_SIZE, -6, -6);
						mouseState = PopupConstant.SIDE_RIGHT | PopupConstant.SIDE_TOP;
					}else if(xPosition >= (this.x + this.width - mouseMargin)){
						CursorUtils.changeCursor(PopupConstant.HORIZONTAL_SIZE, -9, -9);
						mouseState = PopupConstant.SIDE_RIGHT;	
					}else if(xPosition <= (this.x + mouseMargin)){
						CursorUtils.changeCursor(PopupConstant.HORIZONTAL_SIZE, -9, -9);
						mouseState = PopupConstant.SIDE_LEFT;
					}else if(yPosition >= (this.y + this.height - mouseMargin)){
						CursorUtils.changeCursor(PopupConstant.VERTICAL_SIZE, -9, -9);
						mouseState = PopupConstant.SIDE_BOTTOM;
					}else if(yPosition <= (this.y + mouseMargin)){
						CursorUtils.changeCursor(PopupConstant.CURSOR_MOVE, -9, -9);
						mouseState = PopupConstant.SIDE_TOP;
					}else{
						mouseState = PopupConstant.SIDE_OTHER;
						CursorUtils.changeCursor(null, 0, 0);
					}
				}
			}
			else
			{				
				if(!event.buttonDown)
			    	{
				    	if(resizeObj!=null)
				    		resizeObj.stopDragging();
						
						resizeObj = null;
			    	}
			}
			
			//Use SystemManager to listen the mouse reize event, so we needn't handle the event at the current object.
			//oResize(event);
		}
		
		/**
		 * Hide the arrow when not draging and moving out the window.
		 * @param The MouseEvent.MOUSE_MOVE
		 */
		private function oMouseOut(event:MouseEvent):void{
			if(resizeObj == null){
				CursorUtils.changeCursor(null, 0, 0);
			}
		}
		
		/**
		 * Resize when the draging window, resizeObj is not null.
		 * @param The MouseEvent.MOUSE_MOVE
		 */
		private function oResize(event:MouseEvent):void{			
			if(resizeObj != null){	
				resizeObj.stopDragging();
				var xPlus:Number = Application.application.parent.mouseX - resizeObj.oPoint.x;
				var yPlus:Number = Application.application.parent.mouseY - resizeObj.oPoint.y;	
				var screenX:Number=Application.application.parent.mouseX;
				var screenY:Number=Application.application.parent.mouseY;				
				if(screenX>=5 && screenX<=screen.width-5 && screenY<=screen.height-5 && screenY>=5)
				{							
				    switch(mouseState){
				    	case PopupConstant.SIDE_RIGHT | PopupConstant.SIDE_BOTTOM:
				    		resizeObj.width = resizeObj.oWidth + xPlus > _windowMinSize ? resizeObj.oWidth + xPlus : _windowMinSize;
			    			resizeObj.height = resizeObj.oHeight + yPlus > _windowMinSize ? resizeObj.oHeight + yPlus : _windowMinSize;
				    		break;
				    	case PopupConstant.SIDE_LEFT | PopupConstant.SIDE_TOP:
			    			resizeObj.x = xPlus < resizeObj.oWidth - _windowMinSize ? resizeObj.oX + xPlus: resizeObj.x;
			    			resizeObj.y = yPlus < resizeObj.oHeight - _windowMinSize ? resizeObj.oY + yPlus : resizeObj.y;
				    		resizeObj.width = resizeObj.oWidth - xPlus > _windowMinSize ? resizeObj.oWidth - xPlus : _windowMinSize;
			    			resizeObj.height = resizeObj.oHeight - yPlus > _windowMinSize ? resizeObj.oHeight - yPlus : _windowMinSize;
				    		break;
				    	case PopupConstant.SIDE_LEFT | PopupConstant.SIDE_BOTTOM:
				    		resizeObj.x = xPlus < resizeObj.oWidth - _windowMinSize ? resizeObj.oX + xPlus: resizeObj.x;
				    		resizeObj.width = resizeObj.oWidth - xPlus > _windowMinSize ? resizeObj.oWidth - xPlus : _windowMinSize;
			    			resizeObj.height = resizeObj.oHeight + yPlus > _windowMinSize ? resizeObj.oHeight + yPlus : _windowMinSize;
				    		break;
				    	case PopupConstant.SIDE_RIGHT | PopupConstant.SIDE_TOP:
				    		resizeObj.y = yPlus < resizeObj.oHeight - _windowMinSize ? resizeObj.oY + yPlus : resizeObj.y;
				    		resizeObj.width = resizeObj.oWidth + xPlus > _windowMinSize ? resizeObj.oWidth + xPlus : _windowMinSize;
			    			resizeObj.height = resizeObj.oHeight - yPlus > _windowMinSize ? resizeObj.oHeight - yPlus : _windowMinSize;
				    		break;
				    	case PopupConstant.SIDE_RIGHT:
				    		resizeObj.width = resizeObj.oWidth + xPlus > _windowMinSize ? resizeObj.oWidth + xPlus : _windowMinSize;
				    		break;
				    	case PopupConstant.SIDE_LEFT:
				    		resizeObj.x = xPlus < resizeObj.oWidth - _windowMinSize ? resizeObj.oX + xPlus: resizeObj.x;
				    		resizeObj.width = resizeObj.oWidth - xPlus > _windowMinSize ? resizeObj.oWidth - xPlus : _windowMinSize;
				    		break;
				    	case PopupConstant.SIDE_BOTTOM:
				    		resizeObj.height = resizeObj.oHeight + yPlus > _windowMinSize ? resizeObj.oHeight + yPlus : _windowMinSize;
				    		break;
				    	case PopupConstant.SIDE_TOP:
				    		resizeObj.y = yPlus < resizeObj.oHeight - _windowMinSize ? resizeObj.oY + yPlus : resizeObj.y;
				    		resizeObj.height = resizeObj.oHeight - yPlus > _windowMinSize ? resizeObj.oHeight - yPlus : _windowMinSize;
				    		break;
				    }
			    }
			    else
			    {			    	
			    	if(!event.buttonDown)
			    	{
				    	if(resizeObj != null){
				    		resizeObj.stopDragging();				
						//initPosition(resizeObj);				
						}
						//trace("resize");
						resizeObj = null;
			    	}
			    }
			   
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Control the window buttons.
		//
		//--------------------------------------------------------------------------
		
		//private var windowMinButton:Button;
		//private var windowMaxButton:Button;
		//private var windowCloseButton:Button;
		
		/**
		 * Add the window buttons and layout them.
		 * @param The FlexEvent.CREATION_COMPLETE
		 */
		/* private function addButton(event:FlexEvent):void{
			if(_showWindowButtons){
				 if(windowMinButton == null){
					windowMinButton = new Button();
					windowMinButton.width=10;
					windowMinButton.height=10;
					windowMinButton.focusEnabled=false;
					windowMinButton.setStyle("upSkin", PopupConstant.WINDOW_MIN_BUTTON_1);
					windowMinButton.setStyle("overSkin", PopupConstant.WINDOW_MIN_BUTTON_2);
					windowMinButton.setStyle("downSkin", PopupConstant.WINDOW_MIN_BUTTON_2);
					windowMinButton.addEventListener(MouseEvent.CLICK, windowMinButton_clickHandler);
					titleBar.addChild(windowMinButton);
				}
				if(windowMaxButton == null){
					windowMaxButton = new Button();
					windowMaxButton.width=10;
					windowMaxButton.height=10;
					windowMaxButton.focusEnabled=false;
					windowMaxButton.setStyle("upSkin", PopupConstant.WINDOW_MAX_BUTTON_1);
					windowMaxButton.setStyle("overSkin", PopupConstant.WINDOW_MAX_BUTTON_2);
					windowMaxButton.setStyle("downSkin", PopupConstant.WINDOW_MAX_BUTTON_2);
					windowMaxButton.addEventListener(MouseEvent.CLICK, windowMaxButton_clickHandler);
					titleBar.addChild(windowMaxButton);
				} 
				if(windowCloseButton == null){
					windowCloseButton = new Button();
					windowCloseButton.width=20;
					windowCloseButton.height=20;
					windowCloseButton.focusEnabled=false;
					windowCloseButton.setStyle("upSkin", PopupConstant.WINDOW_CLOSE_BUTTON_1);
					windowCloseButton.setStyle("overSkin", PopupConstant.WINDOW_CLOSE_BUTTON_2);
					windowCloseButton.setStyle("downSkin", PopupConstant.WINDOW_CLOSE_BUTTON_3);
					windowCloseButton.addEventListener(MouseEvent.CLICK, windowCloseButton_clickHandler);
					titleBar.addChild(windowCloseButton);
				}
				layoutWindowButtons();
			}else{
				 titleBar.removeChild(windowMinButton);
				windowMinButton = null;
				titleBar.removeChild(windowMaxButton);
				windowMaxButton = null; 
				titleBar.removeChild(windowCloseButton);
				windowCloseButton = null;
			}
		}
		 */
		/* private function windowMinButton_clickHandler(event:MouseEvent):void{
			dispatchEvent(new FlexEvent("minWindow"));
		}
		
		private function windowMaxButton_clickHandler(event:MouseEvent):void{
			dispatchEvent(new FlexEvent("maxWindow"));
		} */
		
		/* private function windowCloseButton_clickHandler(event:MouseEvent):void{
			dispatchEvent(new FlexEvent("closeWindow"));
		} */
		
		/* private function layoutWindowButtons():void{
			 if(windowMinButton != null){
				windowMinButton.move(titleBar.width - 10 * 3  - 6 - 6 - 6, (titleBar.height - 10) / 2);
			}
			if(windowMaxButton != null){
				windowMaxButton.move(titleBar.width - 10 * 2  - 6 - 6, (titleBar.height - 10) / 2);
			} 
			if(windowCloseButton != null){
				windowCloseButton.move(titleBar.width - 10 - 20, (titleBar.height - 20) / 2);
			}
		} */
		
		override protected function layoutChrome(unscaledWidth:Number, unscaledHeight:Number):void{
			super.layoutChrome(unscaledWidth, unscaledHeight);
			//layoutWindowButtons();
		}
		   
        protected function window_moveHandler(event:MoveEvent):void
        {
            var window:UIComponent = event.currentTarget as UIComponent;            
            var application:UIComponent = Application.application as UIComponent;
            var bounds:Rectangle = new Rectangle(0, 0, application.width, application.height);
            var windowBounds:Rectangle = window.getBounds(application);
            var x:Number;
            var y:Number;
            if (windowBounds.left + 0.9*windowBounds.width<= bounds.left)
                x = bounds.left-0.9*windowBounds.width;
            else if (windowBounds.right >= bounds.right+ 0.9*windowBounds.width)
                x = bounds.right - 0.1*window.width;
            else
                x = window.x;
            if (windowBounds.top <= bounds.top)
                y = bounds.top;
            else if (windowBounds.bottom >= bounds.bottom+0.9*windowBounds.height)
                y = bounds.bottom - 0.1*window.height;
            else
                y = window.y;
            window.move(x, y);
        }
	}
}