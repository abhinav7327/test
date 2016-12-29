package com.nri.rui.gle.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.containers.SummaryPopup;
	import com.nri.rui.gle.GleConstraints;
	
	import flash.events.MouseEvent;
	
	import mx.controls.DataGrid;
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
    import mx.utils.StringUtil;

	public class LedgerDetailsRenderer extends Text
	{
		public function LedgerDetailsRenderer()
		{
			super();
			//addEventListener(MouseEvent.CLICK, handleMouseClick);
		}
		/**
         * Overridden the updateDisplayList method to display the columns values
         * in different colors, in button mode, with Hand cursor etc.
         * 
         */ 
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
    		 super.updateDisplayList(unscaledWidth, unscaledHeight);
    			
    		 /* visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
    		 //To show the underline with hand cursor
    		 buttonMode = true;
    		 useHandCursor = true;
    		 mouseChildren = false; */
    		 
    		 //setting color depending on positive or negative value
    		               
                /* setStyle("color", BLUE_COLOR); */      
             //setStyle("color",0x007ac8);  
             //Setting underline to indicate someting will happen on click 
    		 //setStyle("textDecoration","underline");
    		 
    	}
    	
    	override public function set data(value:Object):void{
			super.data = value;
			//visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
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
				//removeEventListener(MouseEvent.CLICK,handleMouseClick);
			}
			
		}
    	
		public function handleMouseClick(event:MouseEvent):void {
			
			var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
			
			sPopup.title = "Gle Ledger Details";
			sPopup.width = parentApplication.width - 100;
    		sPopup.height = 420;
			PopUpManager.centerPopUp(sPopup);		
			var ledgerPkStr : String = data.ledgerPkStr;
			sPopup.moduleUrl = GleConstraints.GLE_LEDGER_DETAILS_SWF+Globals.QS_SIGN+GleConstraints.LEDGER_PK+Globals.EQUALS_SIGN+ledgerPkStr;
			
		}
	}
}