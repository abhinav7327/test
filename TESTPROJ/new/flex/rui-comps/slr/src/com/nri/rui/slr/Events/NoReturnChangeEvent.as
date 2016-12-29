package com.nri.rui.slr.Events
{
    import flash.events.Event;

    public class NoReturnChangeEvent extends Event
    {
        public var rowNum:Number;
        public var itemValue:Object;
        public static var DATA_CHANGE_SELECTED_EVENT:String = "DataChangeEvent";
        public static var HOLD_QTY_CHANGE_EVENT:String = "HoldQtyChangeEvent";
        public function NoReturnChangeEvent(type:String, rowNum:Number, item:Object, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            //TODO: implement function
            super(type, bubbles, cancelable);
            this.rowNum = rowNum;
            this.itemValue = item;
        }
        override public function clone():Event {
		 	return new NoReturnChangeEvent(DATA_CHANGE_SELECTED_EVENT,rowNum, itemValue, true);
		}
        
    }
}