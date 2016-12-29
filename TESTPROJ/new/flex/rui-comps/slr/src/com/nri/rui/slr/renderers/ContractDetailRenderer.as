
package com.nri.rui.slr.renderers
{
	
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.containers.SummaryPopup;
	import com.nri.rui.core.controls.XenosAlert;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;

	public class ContractDetailRenderer extends Text
	{
		var column : DataGridColumn=null;
		public function ContractDetailRenderer()
		{
			super();
			
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
			sPopup.title = this.parentApplication.xResourceManager.getKeyValue('slr.contract.label.contractactiondetails');
			sPopup.width = 850;
    		sPopup.height = 550;
			PopUpManager.centerPopUp(sPopup);		
			var contractPkStr : String = data.contractPk;
			sPopup.moduleUrl = "assets/appl/slr/ContractQueryDetailView.swf?&contractPk=" +contractPkStr;
		}
	}
}
