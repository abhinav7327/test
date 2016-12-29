package com.nri.rui.core.controls
{
	import flash.events.Event;
    
    import mx.collections.ArrayCollection;
    import mx.controls.Button;
    import mx.controls.ToggleButtonBar;
    import mx.events.CollectionEvent;
    import mx.events.FlexEvent;
    import mx.events.ItemClickEvent;
    
    import com.nri.rui.core.utils.FXCPager;

    public class FXCPagerBar extends ToggleButtonBar{
        
        public var maxVisiblePages:Number   = 10;
        
        private var showFirstNav:Boolean    = false;
        private var showLastNav:Boolean     = false;
        
        private var _pager:FXCPager;
        private var _totalPages:Number      = 0;
        
        public function FXCPagerBar():void{
            super();
            this.addEventListener(ItemClickEvent.ITEM_CLICK, this.navigatePage);
        }
        
        public function set pager(value:FXCPager):void{
            this._pager = value;
            this.createNavBar(this.totalPages);
        }
        
        public function get pager():FXCPager{
            return this._pager;
        }
        
        public function set totalPages(value:Number):void{
            this._totalPages = value;
            this.createNavBar(this.totalPages);
        }
        
        public function get totalPages():Number{
            return this._totalPages;
        }
        
        private function navigatePage(event:ItemClickEvent):void{
            pager.pageIndex = event.item.data;
            
            var lb:String = event.item.label.toString();
            if( lb.indexOf("<") > -1 || lb.indexOf(">") > -1 ){
                this.createNavBar(totalPages,event.item.data);
                event.target.selectedIndex = event.item.data == 0?0:2;
            }
        }
        
        private function createNavBar(pages:uint = 1,set:uint = 0):void{dataProvider = new ArrayCollection();
            if( pages > 1 ){
                dataProvider.addItem({label:"<<",data:0});
                if( (set - maxVisiblePages ) >= 0 ){
                    dataProvider.addItem({label:"<",data:set - maxVisiblePages});
                }else{
                    dataProvider.addItem({label:"<",data:0});
                }
                
                for( var x:uint = 0; x < maxVisiblePages; x++){
                    if(x + set < totalPages){
                        var pg:uint = x + set;
                        dataProvider.addItem({label: pg + 1,data: pg});
                    }
                }
                
                dataProvider.addItem({label:">",data:pg + 1});
                dataProvider.addItem({label:">>",data:pages - maxVisiblePages});
                
                this.showFirstNav = set == 0;
                this.showLastNav = pg >= pages - 1;
                
                
                this.invalidateDisplayList();
            }
        }
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            
            this.callLater(this.updateControls);
            
        }
        
        private function updateControls(event:Event=null):void{
            if(this.numChildren > 0){
                if( this.showFirstNav ){
                    Button(this.getChildAt(0)).enabled = false;
                    Button(this.getChildAt(1)).enabled = false;
                }
                
                if( this.showLastNav ){
                    Button(this.getChildAt(dataProvider.length-2)).enabled = false;
                    Button(this.getChildAt(dataProvider.length-1)).enabled = false;
                }
            }
        }
    }
}