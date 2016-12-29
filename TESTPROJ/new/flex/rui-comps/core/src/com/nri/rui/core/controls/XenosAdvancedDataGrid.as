package com.nri.rui.core.controls
{
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import flash.display.Sprite;
    import flash.events.ContextMenuEvent;
    import flash.system.System;
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
    
    import mx.collections.ArrayCollection;
    import mx.controls.AdvancedDataGrid;
    import mx.controls.Label;
    import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
    import mx.controls.advancedDataGridClasses.AdvancedDataGridItemRenderer;
    import mx.core.UITextField;
    import mx.effects.*;

    public class XenosAdvancedDataGrid extends AdvancedDataGrid
    {
        [Bindable]
         var copyTextStr:String = XenosStringUtils.EMPTY_STR;;
         
        public function XenosAdvancedDataGrid()
        {
            //TODO: implement function
            super();
            initializeContext();
        }
        
        private var _columnListArray:Array  = new Array();
        
         public function set ColumnListArray(value:Array):void
        {
            this._columnListArray = value;
        }
        
        public function get ColumnListArray():Array
        {
            return this._columnListArray;
        }
        
          public function get VisibleColumns():Array
        {
            var arrColumns:Array = new Array();
            for each(var adgc:AdvancedDataGridColumn in this.columns)
            {
                if(adgc.visible)
                    arrColumns.push(adgc);
            }
            return arrColumns;
        }
        
          private var _rowColorFunction:Function;
        
        /**
         * A user-defined function that will return the correct color of the
         * row. Usually based on the row data.
         * 
         * expected function signature:
         * public function F(item:Object, defaultColor:uint):uint
         **/
        public function set rowColorFunction(f:Function):void
        {
            this._rowColorFunction = f;
        }
        
        public function get rowColorFunction():Function
        {
            return this._rowColorFunction;
        }
        
            
        private var displayWidth:Number; 
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);            
            if (displayWidth != unscaledWidth - viewMetrics.right - viewMetrics.left)
            {
                displayWidth = unscaledWidth - viewMetrics.right - viewMetrics.left;
            }
        }
        

        /**
         *  Draws a row background 
         *  at the position and height specified using the
         *  color specified.  This implementation creates a Shape as a
         *  child of the input Sprite and fills it with the appropriate color.
         *  This method also uses the <code>backgroundAlpha</code> style property 
         *  setting to determine the transparency of the background color.
         * 
         *  @param s A Sprite that will contain a display object
         *  that contains the graphics for that row.
         *
         *  @param rowIndex The row's index in the set of displayed rows.  The
         *  header does not count, the top most visible row has a row index of 0.
         *  This is used to keep track of the objects used for drawing
         *  backgrounds so a particular row can re-use the same display object
         *  even though the index of the item that row is rendering has changed.
         *
         *  @param y The suggested y position for the background
         * 
         *  @param height The suggested height for the indicator
         * 
         *  @param color The suggested color for the indicator
         * 
         *  @param dataIndex The index of the item for that row in the
         *  data provider.  This can be used to color the 10th item differently
         *  for example.
         */
        override protected function drawRowBackground(s:Sprite, rowIndex:int,
                                                y:Number, height:Number, color:uint, dataIndex:int):void
        {
            if( this.rowColorFunction != null )
            {
                if( dataIndex < (this.dataProvider as ArrayCollection).length )
                {
                    var item:Object = (this.dataProvider as ArrayCollection).getItemAt(dataIndex);
                    color = this.rowColorFunction.call(this, item, color);
                }
            }
            
            super.drawRowBackground(s, rowIndex, y, height, color, dataIndex);
        }
        
        public function DataBind(columnDataList:Object):void
        {
             if(columnDataList == null || columnDataList is ArrayCollection)
             {    
                this.columns = this._columnListArray;
                
                 this.dataProvider = columnDataList;
                 //Alert.show(ArrayCollection(this.dataProvider)[0].accountNo.toString());
            }
         }
         public function initializeContext():void{
            var context:ContextMenu = new ContextMenu();
            var item:ContextMenuItem = new ContextMenuItem("CopyField",false);
            item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,copyText);
            context.hideBuiltInItems();
            context.customItems.push(item);
            contextMenu = context;
            contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,contextHandler,false,100);
        }
        private function contextHandler(event:ContextMenuEvent):void{
            //Alert.show(event.mouseTarget+"");
            var item:ContextMenuItem = contextMenu.customItems.pop();
             copyTextStr = XenosStringUtils.EMPTY_STR;
            item.enabled = true;
            contextMenu.customItems.push(item);
            if(!(event.mouseTarget is AdvancedDataGridItemRenderer)){
                
                if(event.mouseTarget is UITextField)    
                    copyTextStr    = UITextField(event.mouseTarget).text;
                else{
                    try{
                        copyTextStr = Label(event.mouseTarget).text;
                    }catch(e:Error){
                        //System.setClipboard(XenosStringUtils.EMPTY_STR);
                        var item:ContextMenuItem = contextMenu.customItems.pop();
                        item.enabled = false;
                        contextMenu.customItems.push(item);
                    }
                }    
                    
            }else{
                //var row:int = AdvancedDataGridItemRenderer(event.mouseTarget).listData.rowIndex;
                //var column:int = AdvancedDataGridItemRenderer(event.mouseTarget).listData.columnIndex;
                //copyTextStr = (ArrayCollection(dataProvider).getItemAt(row))[columns[column].dataField];
                //XenosAlert.info("column no : "+ column);
                copyTextStr = AdvancedDataGridItemRenderer(event.mouseTarget).listData.label;
            }
        }
            
        private function copyText(event:ContextMenuEvent):void{
            if(!XenosStringUtils.isBlank(copyTextStr))
                System.setClipboard(copyTextStr);
        }        
        /**
         * Returns the client sorting fields 
         * @return sorting fields array.
         * 
         */
        public function getSortFields():Array{
            if(collection != null && collection.sort != null)            
                return collection.sort.fields;
            else
                return null;
        }
        
    }
}