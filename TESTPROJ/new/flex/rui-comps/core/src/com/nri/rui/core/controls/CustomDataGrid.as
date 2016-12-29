// ActionScript file
package com.nri.rui.core.controls
{
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import flash.display.Sprite;
    import flash.events.ContextMenuEvent;
    import flash.system.System;
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
    
    import mx.collections.ArrayCollection;
    import mx.controls.DataGrid;
    import mx.controls.Label;
    import mx.controls.dataGridClasses.DataGridColumn;
    import mx.controls.dataGridClasses.DataGridItemRenderer;
    import mx.core.UITextField;
    import mx.effects.*;
    import mx.events.FlexEvent;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    
    /**
     * This CustomDataGrid class is extended from DataGrid class.
     * This class has all the features of a normal DataGrid with two extra feature.
     * 1. cell data can be copied using 'CopyField' item in context menu. 
     * 2. rowColorFunction can be given by user. This feature enable user to color a row
     *       selectively.
     */ 
    public class CustomDataGrid extends DataGrid{
        [Bindable]
        var copyTextStr:String = XenosStringUtils.EMPTY_STR;;
        
        private var _rowColorFunction:Function;
		
        [Bindable]
        public var nonPersonalizedColumnsArray:Array = new Array();
		
		private var _screenId:String;
		
        public function CustomDataGrid(){
            trace("CustomDataGrid");
            super();
            initializeContext();
            this.addEventListener(FlexEvent.CREATION_COMPLETE, initGrid, false, 2, true);
            //contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,contextHandler,false,100);
        }
        
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
		
        public function set screenId(screenId:String):void
        {
            this._screenId = screenId;
        }
        
        public function get screenId():String
        {
            return this._screenId;
        }        
        
        /**
         * This method intialize the context menu.
         * It hides the default items and add 'CopyField' item to the menu.
         * MENU_ITEM_SELECT event is attached to the custom item.
         * MENU_SELECT event is attached to the cotext menu.
         */ 
        public function initializeContext():void{
            var context:ContextMenu = new ContextMenu();
            var item:ContextMenuItem = new ContextMenuItem("CopyField",false);
            item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,copyText);
            context.hideBuiltInItems();
            context.customItems.push(item);
            contextMenu = context;
            contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,contextHandler,false,100);
        }
        
        /**
         * This is the event handler of MENU_SELECT event.
         * This method get the String to be copied from DataGridItemRenderer
         * and set the item to system clipboard.
         */ 
        private function contextHandler(event:ContextMenuEvent):void{
            var item:ContextMenuItem = contextMenu.customItems.pop();
            copyTextStr = XenosStringUtils.EMPTY_STR;
            item.enabled = true;
            contextMenu.customItems.push(item);
            if(!(event.mouseTarget is DataGridItemRenderer))
            {
                if(event.mouseTarget is UITextField){
                    copyTextStr    = UITextField(event.mouseTarget).text;
                }
                else
                {
                    try{
                        copyTextStr = Label(event.mouseTarget).text;
                    }catch(e:Error){
                        var item:ContextMenuItem = contextMenu.customItems.pop();
                        item.enabled = false;
                        contextMenu.customItems.push(item);
                    }
                }    
                    
            }
            else
            {
                copyTextStr = DataGridItemRenderer(event.mouseTarget).listData.label;
            }
        }
        
        /**
         * Set the copyTextStr to System clipboard.
         */     
        private function copyText(event:ContextMenuEvent):void{
                if(!XenosStringUtils.isBlank(copyTextStr))
                    System.setClipboard(copyTextStr);
            }
            
        
        private var displayWidth:Number; // I wish this was protected, or internal so I didn't have to recalculate it myself.        
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
        
        /**
         * This handler is called after creationcomplete event is fired
         * on this data grid.
         * 
         */ 
        public function initGrid(e:FlexEvent):void{
        	trace("within initGrid");
        	// store the original column configuration for future restore operation
        	 nonPersonalizedColumnsArray = new Array();
	    	 for each(var col:DataGridColumn in this.columns){
		    	 	var config:Object = new Object();
		    	 	config.field = String(col.dataField);
		    	 	config.width = col.width;
		    	 	config.hidden = !col.visible;
		 			nonPersonalizedColumnsArray.push(config);
	     	 } 
	     	
	     	// If a non-blank screenId is specified for the custom data grid send for the screen personalize service  
	     	if(!XenosStringUtils.isBlank(screenId) && !XenosStringUtils.equals(screenId, XenosStringUtils.EMPTY_STR)){ 
        	   sendPersonalizeService();
            }
        }
        
       
         /**
          * Configure the http service for getting the saved preference.
          * Send the service to get the personalized data.
          * @return void.
          */  
         public function sendPersonalizeService():void{
			var reqObj:Object = new Object();
			
			var prefArray:Array = new Array();
			var index:int = 0;
			for each(var col:DataGridColumn in this.columns){
				var colArr:Array = new Array();
				colArr.push(col.dataField);
				colArr.push(index);
				colArr.push(col.visible);
				colArr.push(col.width);
				prefArray.push(colArr);
				index++;
			}
			reqObj.pref = prefArray;
			trace("screenId: " + screenId);
			reqObj.screenId = screenId;
         	var rnd:Number = Math.random();
         	//var p_service:HTTPService = new HTTPService();
         	var p_service:XenosHTTPService = new XenosHTTPService();
         	p_service.url = "ref/preferencesDispatch.action?method=getPreference&rnd=" + rnd;
         	p_service.resultFormat = "xml";
         	p_service.method = "POST";
			p_service.request = reqObj;
         	p_service.addEventListener(ResultEvent.RESULT, getPersonalizeResult);
         	p_service.addEventListener(FaultEvent.FAULT, faultHandler);
         	p_service.send();
         }
        
        /**
         * Get the personalize data from the server and pass the
         * data for grid personalization.
         */   
        public function getPersonalizeResult(event:ResultEvent){
	 		var res:XML = XML(event.result);
	 		personalizeGrid(res);
	 		
	 		//Alert.show("result :: " + res);
     	}
     	public function faultHandler(event:FaultEvent){
     		//Alert.show(event.message.toString());
     	}
     	
     	 /**
         * Redraw the data grid according to the pref saved by the current user. 
         * @param (prefXML) XML
         * 
         */
     	private function personalizeGrid(prefXML:XML):void{
     		if(XMLList(prefXML.columns.column).length() <= 1)
	      		return;
     		
			var columnArray:Array = this.columns;
     		var changedArray:Array = new Array();
	      	
	      	this.horizontalScrollPolicy = "on";
	      	DataGridColumn(columnArray[0]).width = 40;
	      	changedArray.push(columnArray[0]);
	      	for each(var column:XML in prefXML.columns.column){
	      		var currentIndex;
	      		for(var indx:int=0; indx<columnArray.length; indx++){
	      			if(columnArray[indx].dataField == column.@field){
	      				currentIndex = indx;
	      				break;
	      			}
	      		}
	      		
	      		var visibleFlag = column.@visible == "true" ? true : false;
	      		if(visibleFlag)
	      			DataGridColumn(columnArray[currentIndex]).width = Number(column.@width);
	      		//else
	      			//DataGridColumn(columnArray[currentIndex]).width = 0;
	      		DataGridColumn(columnArray[currentIndex]).visible = visibleFlag;
	      		changedArray.push(columnArray[currentIndex]);
	      	}
	      	//this.horizontalScrollPolicy = "off";
	      	this.columns = changedArray;
	      	//this.parentDocument.qh.queryResultHeader.setStyle("backgroundColor", 0xD3F4CE);
	      	this.invalidateProperties();
	      	this.invalidateDisplayList();
     	}
        
    }
}