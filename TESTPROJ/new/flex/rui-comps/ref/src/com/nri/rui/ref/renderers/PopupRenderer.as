
package com.nri.rui.ref.renderers
{
	import com.nri.rui.core.Globals;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.ComboBase;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.listClasses.ListData;
	import mx.core.FlexVersion;
	import mx.core.IDataRenderer;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.managers.IFocusManagerComponent;
		
	use namespace mx_internal;
	
	[Event(name="dataChange", type="mx.events.FlexEvent")]
	
	
	
	/**
	 * This acts as a base class for itemeditors/renderers which open a popup e.g CountryPopup
	 * The user has to override the showPopUp() method.
	 * @author amitp
	 * 
	 */	
	public class PopupRenderer extends ComboBase
                       implements IDataRenderer, IDropInListItemRenderer,
                       IFocusManagerComponent, IListItemRenderer
	{
		        
		[Embed(source="../../../../../../assets/popup_icon.png")]
		[Bindable]
		private var icoView:Class;
		
		
		
		
		private var _listData:BaseListData;
		
	    [Bindable("dataChange")]
	    [Inspectable(environment="none")]	  
	    public function get listData():BaseListData
	    {
	        return _listData;
	    }
	
	    public function set listData(value:BaseListData):void
	    {
	        _listData = value;
	    }
		
		private var _data:Object;

	    [Bindable("dataChange")]
	    [Inspectable(environment="none")]	
	    public function get data():Object
	    {
	        return _data;
	    }
	
	    
	    public function set data(value:Object):void
	    {
	        _data = value;       
	 
	        if (_listData && _listData is DataGridListData)
	             this.text = _data[DataGridListData(_listData).dataField];
	        else if (_listData is ListData && ListData(_listData).labelField in _data)
	             this.text = _data[ListData(_listData).labelField];
	        else if (_data is String)	             
	             this.text = _data as String;
	              
	        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
	    }
		
		public function PopupRenderer()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteHandler);
			
		}
		private function creationCompleteHandler(e:Event):void{
			this.editable=true;			
			this.restrict=Globals.INPUT_PATTERN;
			this.textInput.addEventListener(FlexEvent.VALUE_COMMIT,valueCommitHandler,false,0,true);
			
			//set button icon
			//this.setStyle("icon",icoView);	
					
			downArrowButton.setStyle("icon",icoView);
			downArrowButton.setStyle("paddingLeft",0);
			downArrowButton.setStyle("paddingRight",0);
			downArrowButton.setStyle("paddingTop",0);
			downArrowButton.setStyle("paddingBottom",0);
			downArrowButton.width=21;
			downArrowButton.height=23;
			removeEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteHandler);
		}
		
		 override protected function downArrowButton_buttonDownHandler(
                                    event:FlexEvent):void
	    {
	        
	        callLater(showPopUp);
	
	    }
	    
	     /**
     *  @private
     */
    override protected function measure():void
    {
        // skip base class, we do our own calculation here
        // super.measure();
        var buttonWidth:Number = downArrowButton.getExplicitOrMeasuredWidth();
        var buttonHeight:Number = downArrowButton.getExplicitOrMeasuredHeight();        
		
        measuredMinWidth = measuredWidth = 15*measureText("A").width + 8 + 2 + buttonWidth;
        if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)
            measuredMinWidth = measuredWidth += getStyle("paddingLeft") + getStyle("paddingRight");
        measuredMinHeight = measuredHeight = textInput.getExplicitOrMeasuredHeight();
    }

    
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        var w:Number = unscaledWidth;
        var h:Number = unscaledHeight;

        var arrowWidth:Number = downArrowButton.getExplicitOrMeasuredWidth();
        var arrowHeight:Number = downArrowButton.getExplicitOrMeasuredHeight();

        downArrowButton.setActualSize(arrowWidth, arrowHeight);
        downArrowButton.move(w - arrowWidth, Math.round((h - arrowHeight) / 2));

        textInput.setActualSize(w - arrowWidth - 2, h);
    }

	    
	    private function valueCommitHandler(e:FlexEvent):void{
	    	text=this.textInput.text;
	    	if (_listData && _listData is DataGridListData)
	    	{
	             _data[DataGridListData(_listData).dataField]=this.text ;
	             var dprovider:Object=DataGrid(_listData.owner).dataProvider;
	             ArrayCollection(dprovider).refresh();
	     	}	    	
	    	dispatchEvent(e);
	    	
	    }
	    
	    
	    /* override protected function get arrowButtonStyleFilters():Object
	    {
	    	var filter:Object={"icon":"icon"};	    	
	        return filter;
	    } */
	    
	    
	     /*
         * Method to overriden by subclass
         */
         protected function showPopUp():void {            
           
           
        }

	}
}