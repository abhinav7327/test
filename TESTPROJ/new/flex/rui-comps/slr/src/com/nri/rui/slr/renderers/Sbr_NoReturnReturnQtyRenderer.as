package com.nri.rui.slr.renderers
{
    import com.nri.rui.slr.Events.NoReturnChangeEvent;
    
    import mx.controls.DataGrid;
    import mx.controls.Label;
    import mx.events.FlexEvent;

    public class Sbr_NoReturnReturnQtyRenderer extends Label
    {
        private var _data:Object;
		
		private var currentId:Number;
		
        public function Sbr_NoReturnReturnQtyRenderer()
        {
            //TODO: implement function
            super();
            addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
        }
        override public function set data(value:Object):void
		{
		    super.data=value;
			this.currentId  = value.rowNum;
			_data=value;
			this.text = value.returnQtyStr;
		}
	
		override public function get data():Object {
			return this._data;
		}
		private function handleItemChange(myChange:NoReturnChangeEvent):void {
			if (myChange.rowNum != currentId) return;// Because this method will be called for all itemrendereres in all the rows.
			//Only the appropriate itemrenderer should react
			this.data = myChange.itemValue;
			this.text = data.returnQtyStr;
			//trace("ReturnQuantityEventFired for " + currentId);
			this.parentDocument.invalidateDisplayList();			
		}
		private function onCreationComplete(evt:FlexEvent):void {
			(listData.owner as DataGrid).addEventListener(NoReturnChangeEvent.DATA_CHANGE_SELECTED_EVENT,handleItemChange);
		}
    }
}