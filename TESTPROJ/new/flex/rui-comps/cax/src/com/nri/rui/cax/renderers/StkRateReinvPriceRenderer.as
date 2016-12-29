// ActionScript file


package com.nri.rui.cax.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.containers.SummaryPopup;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Text;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import mx.utils.StringUtil;
	
	public class StkRateReinvPriceRenderer extends Text
	{
		[Bindable] public var _mode = "rateentry";
		
		private var sPopup : SummaryPopup;
		
		public function StkRateReinvPriceRenderer()
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
			
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
			
			var corporateActionId : String = data.corporateActionId;
			
			if(this._mode == "rateentry") {
				if(corporateActionId == "OPTIONAL_STOCK_DIV") {
					sPopup.title = this.parentApplication.xResourceManager.getKeyValue('cax.stock.div.entry.page');
				} else {
					sPopup.title = this.parentApplication.xResourceManager.getKeyValue('cax.re-inv.price.entry.page');
				}
			} else {
				if(corporateActionId == "OPTIONAL_STOCK_DIV") {
					sPopup.title = this.parentApplication.xResourceManager.getKeyValue('cax.stock.div.cancel.page');
				} else {
					sPopup.title = this.parentApplication.xResourceManager.getKeyValue('cax.re-inv.price.cancel.page');
				}
			}
			sPopup.addEventListener(CloseEvent.CLOSE,handleOkSystemConfirm,false,0,true);
			//sPopup.title = "Corporate Action Events View";
			sPopup.width = parentApplication.width - 100;    		
			sPopup.height = parentApplication.height - 125;
			PopUpManager.centerPopUp(sPopup);		
			var rightsConditionPk : String = data.rightsConditionPk;
			sPopup.moduleUrl = Globals.CAX_STOCK_RATE_ENTRY_SWF + Globals.QS_SIGN + Globals.RIGHTS_CONDITION_PK + Globals.EQUALS_SIGN + rightsConditionPk + Globals.AND_SIGN + "mode" + Globals.EQUALS_SIGN + this._mode + Globals.AND_SIGN + "corporateActionId" + Globals.EQUALS_SIGN + corporateActionId;
		}
		
		/**
		 * Event Handler for the custom event "OkSystemConfirm"
		 */
		public function handleOkSystemConfirm(event:CloseEvent):void {
			this.parentDocument.submitQuery();
			sPopup.removeMe();
			/*this.parentDocument.currentState = "";
			if(_mode == "amend")
				this.parentDocument.dispatchEvent(new Event("amendReset"));
			else if(_mode == "cancel")
				this.parentDocument.dispatchEvent(new Event("cancelReset"));*/
		}

	}
}