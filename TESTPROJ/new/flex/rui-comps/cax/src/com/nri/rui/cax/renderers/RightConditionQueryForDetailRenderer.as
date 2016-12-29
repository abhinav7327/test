
package com.nri.rui.cax.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.containers.SummaryPopup;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.Text;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;
	import com.nri.rui.core.controls.XenosAlert;
	public class RightConditionQueryForDetailRenderer extends Text
	{
		[Bindable] public var _mode:String = Globals.EMPTY_STRING;
		
		public function RightConditionQueryForDetailRenderer()
		{
			super();
			//addEventListener(MouseEvent.CLICK, handleMouseClick);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			 super.updateDisplayList(unscaledWidth, unscaledHeight);
				/* if(listData){
					var dg : DataGrid = DataGrid(listData.owner);
					var column : DataGridColumn = dg.columns[listData.columnIndex];
					text = data[column.dataField];
				}
			
			 visible = (StringUtil.trim(text) == XenosStringUtils.EMPTY_STR ) ? false :true;
			 //To show the underline with hand cursor
			 buttonMode = true;
			 useHandCursor = true;
			 mouseChildren = false;
			 setStyle("color",0x007ac8);
			 setStyle("textDecoration","underline");  */
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
			
			if(_mode == 'detailsEntry'){
				var officeId:String=this.parentDocument.officeId;
				var fundCategory:String=this.parentDocument.fundCategory;
				var sPopup : SummaryPopup;	
				sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
				// to refresh the query result page after entitlement entry
				sPopup.addEventListener("OkSystemConfirm",handleOkSystemConfirm);
				sPopup.title = this.parentApplication.xResourceManager.getKeyValue('cax.entitlement.entry');
				sPopup.width = parentApplication.width - 100;    		
				sPopup.height = parentApplication.height - 125;
				PopUpManager.centerPopUp(sPopup);		
				var rightsConditionPk : String = data.rightsConditionPk;
				sPopup.moduleUrl = Globals.RIGHTS_DETAILS_ENTRY_NEW_SWF + Globals.QS_SIGN + Globals.CONDITION_PK + Globals.EQUALS_SIGN+rightsConditionPk
									+Globals.AND_SIGN+"lmOfficeId"+Globals.EQUALS_SIGN+officeId+Globals.AND_SIGN+"fundCategory"+Globals.EQUALS_SIGN+fundCategory;
				//sPopup.moduleUrl = Globals.RIGHTS_DETAILS_ENTRY_NEW_SWF;
			}else if(_mode == 'adjustment'){
				var sPopup : SummaryPopup;	
				sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
				// to refresh the query result page after entitlement entry
				sPopup.addEventListener("OkSystemConfirm",handleOkSystemConfirm);
				sPopup.title = this.parentApplication.xResourceManager.getKeyValue('cax.adjustment.entry');
				sPopup.width = parentApplication.width - 100;    		
				sPopup.height = parentApplication.height - 125;
				PopUpManager.centerPopUp(sPopup);		
				var rightsConditionPk : String = data.rightsConditionPk;
				if(data.subEventTypeDescription == 'Merger'){
					sPopup.moduleUrl =  Globals.RIGHTS_DETAILS_ADJUSTMENT_MERGER_SWF+ Globals.QS_SIGN + Globals.CONDITION_PK + Globals.EQUALS_SIGN+rightsConditionPk;
				}
				else{
					sPopup.moduleUrl = Globals.RIGHTS_DETAILS_ADJUSTMENT_SWF + Globals.QS_SIGN + Globals.CONDITION_PK + Globals.EQUALS_SIGN+rightsConditionPk;
				}
				//sPopup.moduleUrl = Globals.RIGHTS_DETAILS_ENTRY_NEW_SWF;
			} else {
				var sPopup : SummaryPopup;	
				sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
				// to refresh the query result page after entitlement entry
				sPopup.addEventListener("OkSystemConfirm",handleOkSystemConfirm);
				sPopup.title = this.parentApplication.xResourceManager.getKeyValue('cax.entitlement.bulkamend.title');
				sPopup.width = parentApplication.width - 100;    		
				sPopup.height = parentApplication.height - 10;
				PopUpManager.centerPopUp(sPopup);		
				var rightsConditionPk : String = data.rightsConditionPk;
				var officeId:String=this.parentDocument.officeId;
				var fundCategory:String=this.parentDocument.fundCategory;
				sPopup.moduleUrl = Globals.ENTITLEMENT_BULK_AMEND_SWF + Globals.QS_SIGN + Globals.CONDITION_PK + Globals.EQUALS_SIGN+rightsConditionPk
									+Globals.AND_SIGN+"lmOfficeId"+Globals.EQUALS_SIGN+officeId+Globals.AND_SIGN+"fundCategory"+Globals.EQUALS_SIGN+fundCategory;
			}
			
			
		}
		
		    /**
        	 * Event Handler for the custom event "OkSystemConfirm"
        	 */
        	public function handleOkSystemConfirm(event:Event):void {          		          
                this.parentDocument.submitQuery();
            }		
		
	}
}