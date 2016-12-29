
package com.nri.rui.rec.renderers
{	        
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.containers.SummaryPopup;
	
	import flash.events.MouseEvent;
	
	import mx.controls.DataGrid;
	import mx.controls.Image;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;

	public class ImgSwiftRenderer extends Image
	{
		
  		[Embed(source="../../../../../assets/popup_icon.png")]
		[Bindable]
		private var icoSummary:Class;
		
		 public function ImgSwiftRenderer()
        {            
            super();            
			source=icoSummary;
			super.toolTip="Image file for Swift Message";
			super.setStyle("horizontalAlign","center");
			buttonMode=true;
			useHandCursor=true;
			addEventListener(MouseEvent.CLICK, handleMouseClick);
        }

		
		 /**
         * Overridden the updateDisplayList method to display the columns values
         * in different colors, in button mode, with Hand cursor etc.
         * 
         */ 
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
    		 super.updateDisplayList(unscaledWidth, unscaledHeight);
    			if(listData){    				
    				var dg : DataGrid = DataGrid(listData.owner);
    				var column : DataGridColumn = dg.columns[listData.columnIndex];
    			}
    	}
    	/**
    	 * Mouse Click event handler to open a popup with initialization and passing values.
    	 * 
    	 */ 
         public function handleMouseClick(event:MouseEvent):void { 
    		
    		var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
			
			sPopup.title = "Raw File Viewer";
			sPopup.width = parentApplication.width - 100;
    		sPopup.height = parentApplication.height - 100;
			PopUpManager.centerPopUp(sPopup);
			sPopup.moduleUrl = "assets/appl/rec/RawFileView.swf"+Globals.QS_SIGN+"RowNum"+Globals.EQUALS_SIGN+listData.rowIndex.toString();
    	
    	} 
		
	}
}

