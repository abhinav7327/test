
package com.nri.rui.cax.renderers
{	        
	import com.nri.rui.core.containers.SummaryPopup;
	import com.nri.rui.core.controls.XenosAlert;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.Image;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;

	public class ImgViewRenderer extends Image
	{
		
  		[Embed(source="../../../../../assets/popup_icon.png")]
		[Bindable]
		private var icoSummary:Class;
		
		 public function ImgViewRenderer()
        {            
            super();            
			source=icoSummary;
			super.toolTip="View";
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
			
			sPopup.title = this.parentApplication.xResourceManager.getKeyValue('cax.title.entitlement.view');
			sPopup.width = 500;
    		sPopup.height = 300;    		
			PopUpManager.centerPopUp(sPopup);
			sPopup.dataObj = data;			
			sPopup.moduleUrl = "assets/appl/cax/EntitlementView.swf";
    	
    	} 
		
	}
}

