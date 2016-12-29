/*
 *
 *
 *$Author: anubhavg $
*/


package com.nri.rui.core.containers
{
	
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.*;
	
	import mx.containers.HDividedBox;
	import mx.containers.dividedBoxClasses.*;
	import mx.controls.Button;
	import mx.core.mx_internal;
	import mx.events.ResizeEvent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	use namespace mx_internal;
	
	//Styles
	/**
	 *  Name of the class used as DividerSkin when splitting the window.
	 */
	[Style(name="dividerSkin", type="Class", inherit="no")]
	/**
	 * Upskin of the Button placed in the DividedBar
	 */
	[Style(name="upSkin", type="Class", inherit="no")]
	/**
	 * DownSkin of the Button placed in the DividedBar
	 */
	[Style(name="downSkin", type="Class", inherit="no")]
	/**
	 * OverSkin of the Button placed in the DividedBar
	 */
	[Style(name="overSkin", type="Class", inherit="no")]
	/**
	 * SelectedDownSkin of the Button placed in the DividedBar
	 */
	[Style(name="selectedDownSkin", type="Class", inherit="no")]
	/**
	 * SelectedOverSkin of the Button placed in the DividedBar
	 */
	[Style(name="selectedOverSkin", type="Class", inherit="no")]
	/**
	 * SelectedUpSkin of the Button placed in the DividedBar
	 */
	[Style(name="selectedUpSkin", type="Class", inherit="no")]
	/**
	 * Width of the Button placed in the DividedBar
	 */
	[Style(name="buttonWidth", type="Number", inherit="no")]
	/**
	 * CornerRadius of the Button placed in the DividedBar
	 */ 
	[Style(name="cornerRadius", type="Number", inherit="no")]
	/**
	 * Thickness of the Divided Bar. By default it is 10
	 */	
	[Style(name="dividerThickness", type="Number", inherit="no")]
	/**
	 * The border colour of the dividedBar
	 */
	[Style(name="barBorderColor", type="uint", inherit="no")]
	/**
	  *  The fill Colours of the Divider Bar
	  */	
	[Style(name="barFillColors", type="Array", inherit="no")]
	/**

	 * Enhanced horizontal divided box.
	 * The divider comes along with an icon button which can be clicked to collapse
	 * the left side of the divided box. The same icon can be clicked again to restore
	 * the divided box to the original state.
	 * Usage :
	 * <mx:Style source="BlueXP.css"/>
	 * 
	 * <CollapsibleHDividedBox width="100%" height="100%" direction="horizontal" showButton="true" liveDragging="true" styleName="ExtendedDividerBoxButtonH"> 
	 * 
	 */
	public class CollapsibleHDividedBox extends mx.containers.HDividedBox {


		//create the gradient and apply tothe box controle
		private var fillType:String = GradientType.LINEAR;
		private var alphas:Array = [1,1];
		private var ratios:Array = [0,255];
		private var spreadMethod:String = SpreadMethod.PAD;
		
		/** The image button */
		private var _button:Button;
		
		/** Last position of the horizontal divider */
		private var lastX:int=0;
		
		/** Flag to represent the state */
		private var lastPos:Boolean = true;
		
		private var mBoxDivider:Array = new Array();
		
		/** Image used when left side is collapsed */
		[Embed(source="../../../../../assets/arrowClose.png")]
		private var Arrow_Close:Class;
		/** Image for normal state */
		[Embed(source="../../../../../assets/arrowOpen.png")]
		private var Arrow_Open:Class;
		
		[Embed(source="../../../../../assets/navGrip.png")]
		private static var DEFAULT_DIVIDER_SKIN_HORIZONTAL:Class;
		
		private static var DEFAULT_BUTTON_WIDTH:Number = 30;
		private static var DEFAULT_DIVIDER_THICKNESS:Number = 10;
		private static var DEFAULT_BAR_BORDER_COLOR:uint = 0xAAAAAA;
		private static var DEFAULT_BAR_FILL_COLORS:Array = [0xFFFFFF,0xFFFFFF];
		/** Flag to indicate whether the mouse is over the image button */
		private var _isOverBtn:Boolean = false;
		private var _showButton:Boolean=true;
		private var _barBorderColor:uint;
		private var _barFillColors:Array;
		
		private static var classConstructed:Boolean = classConstruct();
		/**
		 * Define and prepare default styles.
		 */
		private static function classConstruct():Boolean
		{
			//------------------------
		    //  type selector
		    //------------------------
			var selector:CSSStyleDeclaration = StyleManager.getStyleDeclaration("CollapsibleHDividedBox");
			if(!selector)
			{
				selector = new CSSStyleDeclaration();
			}
			// these are default names for secondary styles. these can be set in CSS and will affect
			// all windows that don't have an override for these styles.
			selector.defaultFactory = function():void
			{
				this.dividerSkin = DEFAULT_DIVIDER_SKIN_HORIZONTAL;
				this.buttonWidth = DEFAULT_BUTTON_WIDTH;
				this.dividerThickness = DEFAULT_DIVIDER_THICKNESS;
				this.barBorderColor = DEFAULT_BAR_BORDER_COLOR;
				this.barFillColors = DEFAULT_BAR_FILL_COLORS;
				this.cornerRadius = 0;
				
			}
			// apply it all
			StyleManager.setStyleDeclaration("CollapsibleHDividedBox", selector, false);
			return true;
		}	
		
		/**
		 * Default Constructor
		 */
		public function CollapsibleHDividedBox() {
			super();
			
		}
		
		public function set showButton(value:Boolean):void{
			_showButton=value
		}
		
		public function get showButton():Boolean{
			return _showButton;	
		}
		/**
		 * This method is executed when the mouse is over the divider.
		 * This method has been overriden to stop changing the cursor
		 * if the mouse is over the button.
		 * @param BoxDivider
		 */
		override mx_internal function changeCursor(divider:BoxDivider):void{
			//ignore if we are over a button
			if (_showButton && _isOverBtn) {
				return;
			}
			super.mx_internal::changeCursor(divider);
		}
		
		/**
		 * This method is executed when the mouse is pressed on the divider.
		 * This method has been overriden to stop the divider drag
		 * if the mouse is prseed on the button.
		 * @param BoxDivider
		 */
		override mx_internal function startDividerDrag(divider:BoxDivider, trigger:MouseEvent):void{
			//ignore if we are over a button
			if (_showButton && _isOverBtn) {
				return;
			}
			super.mx_internal::startDividerDrag(divider,trigger);
		}

		/**
		 * This method is executed when the mouse moves over the image button.
		 * A boolean flag is set to true to indicate the mouse is over the button.
		 * @param Event
		 */
		private function handleMouseOver(event:Event) : void {
			_isOverBtn = true;
		}
		
		/**
		 * This method is executed when the mouse moves out of the image button.
		 * The boolean flag set in handleMouseOver(event:Event) is reset in this method.
		 * @param Event
		 */
		private function handleMouseOut(event:Event) : void {
			_isOverBtn = false;
		}
		
		/**
		 * This method handles the toggling of the component's state.
		 * @param Event
		 */
		private function handleButtonClick(event:Event) : void {
			var divbar:BoxDivider = getDividerAt(0);
			if (lastPos) {
				
				lastX = divbar.x;
				divbar.x=0;
				lastPos = false;
				
			} else {
				
				divbar.x=lastX;
				lastPos=true;
				
			}
		}
		private function handleResize(event:ResizeEvent):void{
			
			//Alert.show("resize xalld");
			if(!_showButton){return;}
			
			if (event.currentTarget.width != event.oldWidth || event.currentTarget.height != event.oldHeight){
			
					var divbar:BoxDivider = getDividerAt(0);
				
					var tempButton:Button = Button(divbar.getChildByName("SplitterButton"));
					
					if (tempButton){
						if (direction == "vertical"){
							tempButton.x = (unscaledWidth/2) - (tempButton.width/2);
						}
						else{
							tempButton.y = (unscaledHeight/2) - (tempButton.height/2);
						}
						
					}	
				
			}
			
			
		}	
		/**
		 * This method is called whenever the component's display is changed in any way.
		 * @param unscaledWidth
		 * @param unscaledHeight
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if (mBoxDivider.length == 0){ 
				var _hasbutton:Boolean=true;//default true if no indexs
			var divbar:BoxDivider = getDividerAt(0);
			divbar.addEventListener("resize",handleResize);
			mBoxDivider.push(divbar);
					
			if(_showButton && _hasbutton){
				_button = new Button();
				_button.name = "SplitterButton";
				//set al styles and skins
				_button.width = getStyle("buttonWidth");
				_button.height= getStyle("dividerThickness");
				_button.toggle =true;
				
				_button.setStyle("cornerRadius",getStyle("cornerRadius"));
				
				_button.setStyle("downSkin",getStyle("downSkin"));
				_button.setStyle("overSkin",getStyle("overSkin"));
				_button.setStyle("upSkin",getStyle("upSkin"));
				
				//no divider skin just the button
				divbar.setStyle("dividerSkin",null);
				
				//For Horizontal
				_button.height = getStyle("buttonWidth");
				_button.width= getStyle("dividerThickness")+1;
				_button.y = (unscaledHeight/2) - (_button.height/2);
				
				_button.setStyle("icon",Arrow_Close);
				_button.setStyle("selectedOverIcon",Arrow_Open);
				_button.setStyle("selectedUpIcon",Arrow_Open);
				_button.setStyle("selectedDownIcon",Arrow_Open);

				_button.setStyle("selectedDownSkin",getStyle("selectedDownSkin"));
				_button.setStyle("selectedOverSkin",getStyle("selectedOverSkin"));
				_button.setStyle("selectedUpSkin",getStyle("selectedUpSkin"));
			}

			_button.addEventListener(MouseEvent.CLICK, handleButtonClick);
			_button.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
			_button.addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
			
			divbar.addChild(_button);
			
		}
		
			Draw_Gradient_Fill();
		}
		
		private function Draw_Gradient_Fill():void{
			
			graphics.clear();
				
			for(var i:int=0;i < mBoxDivider.length;i++) {
					
				if (!_barFillColors){
					_barFillColors = getStyle("barFillColors");
					
					if (!_barFillColors){
						//Alert.show("Color fill");
						_barFillColors =[0xFAE38F,0xEE9819]; // if no style default to orange
					}
				}
				
				if (!_barBorderColor){
					_barBorderColor = getStyle("barBorderColor");
					if (!_barBorderColor){
						_barBorderColor =0xEE9819; // if no style default to orange
					}
				}
				
				graphics.lineStyle(1,_barBorderColor);
				
				var divwidth:Number = mBoxDivider[i].getStyle("dividerThickness");
				if (divwidth==0){divwidth=10;}
				
				var matr:Matrix = new Matrix();
				
				if (direction == "vertical"){
					matr.createGradientBox(mBoxDivider[i].width,divwidth,Math.PI/2, mBoxDivider[i].x, mBoxDivider[i].y);
					
					graphics.beginGradientFill(fillType, _barFillColors, alphas, ratios, matr,spreadMethod);
					graphics.drawRect(mBoxDivider[i].x,mBoxDivider[i].y,mBoxDivider[i].width,divwidth);
				}
				else{
					matr.createGradientBox(divwidth,mBoxDivider[i].height ,0, mBoxDivider[i].x, mBoxDivider[i].x+10);
					graphics.beginGradientFill(fillType, _barFillColors, alphas, ratios, matr,spreadMethod);
					graphics.drawRect(mBoxDivider[i].x,mBoxDivider[i].y,divwidth, parent.height);
				}
				
								
			}			
		}

	}
}