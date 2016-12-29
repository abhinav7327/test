// ActionScript file

package com.nri.rui.bkg.renderers
{
	
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.containers.SummaryPopup;
	
	import flash.events.MouseEvent;
	
	import mx.controls.DataGrid;
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;

	public class BkgTrdDetailRenderer extends Text
	{
		var column : DataGridColumn=null;
		public function BkgTrdDetailRenderer()
		{
			super();
			//addEventListener(MouseEvent.CLICK, handleMouseClick);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
    		 super.updateDisplayList(unscaledWidth, unscaledHeight);
    			/* if(listData){
    				var dg : DataGrid = DataGrid(listData.owner);
    				column = dg.columns[listData.columnIndex];
    				
    			}
    		 visible = (StringUtil.trim(text) == Globals.EMPTY_STRING ) ? false :true;
    		 //To show the underline with hand cursor
    		 buttonMode = true;
    		 useHandCursor = true;
    		 mouseChildren = false;
    		 
    		 //setting color depending on positive or negative value
    		 if(listData){               
                text = DataGridListData(listData).label;                
                setStyle("color",0x007ac8);          
             }
             //Setting underline to indicate someting will happen on click 
    		 setStyle("textDecoration","underline"); */
    		 
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
			sPopup.title = this.parentApplication.xResourceManager.getKeyValue('bkg.detail.label');
			sPopup.width = 700;
    		sPopup.height = 460;
			PopUpManager.centerPopUp(sPopup);		
			var bankingTrdPkStr : String = data.bankingTradePk;
			sPopup.moduleUrl = Globals.BKG_TRADE_DETAILS_SWF+Globals.QS_SIGN+Globals.BKG_TRADE_PK+Globals.EQUALS_SIGN+bankingTrdPkStr;
		}
	}
}
