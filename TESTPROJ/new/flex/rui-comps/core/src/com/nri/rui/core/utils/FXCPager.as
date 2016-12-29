package com.nri.rui.core.utils
{
    import flash.events.Event;
    
    import mx.collections.ArrayCollection;
    import mx.collections.ICollectionView;
    import mx.collections.IList;
    import mx.collections.ListCollectionView;
    import mx.core.UIComponent;
    import mx.events.CollectionEvent;
    import mx.events.CollectionEventKind;
    
    [Bindable]
    public class FXCPager extends UIComponent{
        private var _index:int                  = 0;
        private var _pageSize:int               = 10;
        private var _pageData:ArrayCollection   = new ArrayCollection();
        private var collection:ICollectionView;
        
        private function refreshDataProvider(event:Event= null):void{
            var data:ArrayCollection = collection as ArrayCollection;
            if(data != null){
                this.pageData = new ArrayCollection( data.source.slice((this.pageIndex * this.pageSize),(this.pageIndex * this.pageSize) + this.pageSize) );
            }
        }
        
        public function set pageData(value:ArrayCollection):void{
            this._pageData = value;
        }
        
        public function get pageData():ArrayCollection{
            return _pageData;
        }
        
        public function set pageIndex(value:int):void{
            this._index = value;
            this.refreshDataProvider();
        }
        
        public function get pageIndex():int{
            return _index;
        }
        
        public function set pageSize(value:int):void{
            this._pageSize = value;
            this.refreshDataProvider();
        }
        
        public function get pageSize():int{
            return _pageSize;
        }
        
        [Bindable("collectionChange")]
        [Inspectable(category="Data", defaultValue="undefined")]
    
        public function get dataProvider():Object {
            return collection;
        }

        /**
         *  @private
         */
        public function set dataProvider(value:Object):void{
            if (collection) {
                collection.removeEventListener(CollectionEvent.COLLECTION_CHANGE, this.refreshDataProvider);
            }
            if (value is Array){
                collection = new ArrayCollection(value as Array);
            }else if (value is ICollectionView) {
                collection = ICollectionView(value);
            }else if (value is IList){
                collection = new ListCollectionView(IList(value));
            }else{
                // convert it to an array containing this one item
                var tmp:Array = [];
                if (value != null)
                    tmp.push(value);
                collection = new ArrayCollection(tmp);
            }
 
            collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, this.refreshDataProvider, false, 0, true);
    
            var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            event.kind = CollectionEventKind.RESET;
            this.refreshDataProvider(event);
            dispatchEvent(event);
        }
    }
}