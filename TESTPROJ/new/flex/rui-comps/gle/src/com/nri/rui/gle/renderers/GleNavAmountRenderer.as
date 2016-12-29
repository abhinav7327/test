
package com.nri.rui.gle.renderers
{
	import com.nri.rui.core.Globals;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.nri.rui.core.containers.SummaryPopup;
	import mx.controls.DataGrid;
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;

	public class GleNavAmountRenderer extends Text
	{	
		private var sPopup : SummaryPopup;	
		
		public function GleNavAmountRenderer()
		{
			super();
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
			
			//var sPopup : SummaryPopup;	
        		sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
        		
        		sPopup.addEventListener(CloseEvent.CLOSE,closeHandler,false,0,true);
        		sPopup.title = this.parentApplication.xResourceManager.getKeyValue('gle.navquery.label.currencywiseledgerdetailnavsummaryresult');  //"Cash Balance Detail Query Result Summary";
                
                sPopup.width = parentApplication.width - 50;
        		sPopup.height = parentApplication.height - 100;    		
        		
        		PopUpManager.centerPopUp(sPopup);
        
                var resultPk : String = data.navCalcSummaryPk;
                var assetsOrLiability:String;
                
                if(listData){
					var dg : DataGrid = DataGrid(listData.owner);
					var column : DataGridColumn = dg.columns[listData.columnIndex];
					assetsOrLiability = column.dataField;
					
				}
                                
                sPopup.moduleUrl = "assets/appl/gle/GleNavQueryDetailView.swf" + Globals.QS_SIGN + "resultPk" + Globals.EQUALS_SIGN + resultPk + Globals.AND_SIGN + "assetsOrLiability" + Globals.EQUALS_SIGN + assetsOrLiability;
			
			
		}
		
		/**
         * Event Handler for the custom event "OkSystemConfirm"
         */
        public function closeHandler(event:Event):void {
        	sPopup.removeMe();
        }
	}
}