package com.nri.rui.ref.renderers
{
	import com.nri.rui.core.Globals;
	import com.nri.rui.core.utils.XenosPopupUtils;
	import flash.events.MouseEvent;
	import mx.controls.DataGrid;
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import mx.utils.StringUtil;
	
	public class DocumentAttributesRenderer extends Text
	{
	
	  [Bindable] public var _mode:String = "QUERY";
		
		public function DocumentAttributesRenderer()
		{
			super();
			
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			 super.updateDisplayList(unscaledWidth, unscaledHeight);
			
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
				
			}
			
		}
		
		/**
		 * Handle the popUp for Document Summary or Document Action Summary when user clicked on Document Id 
		 */
		public function handleMouseClick(event:MouseEvent):void {
			// Used when user open Document Id details in View Mode			
			var legalAgreementPk :String= data.legalAgreementPk;
			
			// Used when user open Document Id details in Entry Mode		
			var accountAgreementPkStr:String =data.accountAgreementPkStr;
			var hiddenAccountNo:String = data.hiddenAccountNo;
			var accountNo:String =data.accountNo;
			
			var parentApp :UIComponent = UIComponent(this.parentApplication);
		
			if(_mode=="ENTRY"){
			XenosPopupUtils.showDocumentActionSummary(accountAgreementPkStr,hiddenAccountNo,accountNo,_mode,parentApp);
			}else{
			XenosPopupUtils.showDocumentSummary(legalAgreementPk,parentApp);
			}
			
		}
		
		
		override public function validateProperties():void{
			super.validateProperties();
			if (listData)
			{	
				var dg :DataGrid = DataGrid(listData.owner);
				var column:DataGridColumn =	dg.columns[listData.columnIndex];
				var dataTips:Boolean = dg.showDataTips;
				if (column.showDataTips == true)
					dataTips = true;
				if (column.showDataTips == false)
					dataTips = false;

				if (dataTips)
				{
					if (!(data is DataGridColumn) && (textWidth > width 
						|| column.dataTipFunction || column.dataTipField 
						|| dg.dataTipFunction || dg.dataTipField))
					{
						toolTip = column.itemToDataTip(data);
					}
					else
					{
						toolTip = null;
					}
				}
				else
				{
					toolTip = null;
				}

			}
		}
	}
}