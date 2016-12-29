/*

$LastChangedDate$
$Author: sanjoys $
*/



package com.nri.rui.core.controls {
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.net.SharedObject;
import flash.ui.Keyboard;

import mx.collections.ArrayCollection;
import mx.collections.IViewCursor;
import mx.collections.ListCollectionView;
import mx.controls.ComboBox;
import mx.core.UIComponent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the <code>filterFunction</code> property changes.
 *
 *  You can listen for this event and update the component
 *  when the <code>filterFunction</code> property changes.</p>
 * 
 *  @eventType flash.events.Event
 */
[Event(name="filterFunctionChange", type="flash.events.Event")]

/**
 *  Dispatched when the <code>typedText</code> property changes.
 *
 *  You can listen for this event and update the component
 *  when the <code>typedText</code> property changes.</p>
 * 
 *  @eventType flash.events.Event
 */
[Event(name="typedTextChange", type="flash.events.Event")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="editable", kind="property")]

/**
 *  The AutoComplete control is an enhanced 
 *  TextInput control which pops up a list of suggestions 
 *  based on characters entered by the user. These suggestions
 *  are to be provided by setting the <code>dataProvider
 *  </code> property of the control.
 *  @mxml
 *
 *  <p>The <code>&lt;fc:AutoComplete&gt;</code> tag inherits all the tag attributes
 *  of its superclass, and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;fc:AutoComplete
 *    <b>Properties</b>
 *    keepLocalHistory="false"
 *    lookAhead="false"
 *    typedText=""
 *    filterFunction="<i>Internal filter function</i>"
 *
 *    <b>Events</b>
 *    filterFunctionChange="<i>No default</i>"
 *    typedTextChange="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample ../../../../../../docs/com/adobe/flex/extras/controls/example/AutoCompleteCountriesData/AutoCompleteCountriesData.mxml
 *
 *  @see mx.controls.ComboBox
 *
 */
	public class AutoComplete extends ComboBox {

		// creating a HttpService Object for sending request based on interaction
		private var httpService:HTTPService=null;
		//--------------------------------------------------------------------------
		//
		//  Constructor
	    //
	    //--------------------------------------------------------------------------

	    /**
	     *  Constructor.
	     */
		public function AutoComplete()
		{
		    super();

		    //Make ComboBox look like a normal text field
		    editable = true;
		    if(keepLocalHistory)
			    addEventListener("focusOut",focusOutHandler);

		    setStyle("arrowButtonWidth",0);
			setStyle("fontWeight","normal");
			setStyle("cornerRadius",0);
			setStyle("paddingLeft",0);
			setStyle("paddingRight",0);
			rowCount = 7;

			httpService = new XenosHTTPService();
			httpService.addEventListener("result", httpResult);
			httpService.addEventListener("fault", httpFault);
			httpService.useProxy = false;
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 */
		private var cursorPosition:Number=0;

		/**
		 *  @private
		 */
		private var prevIndex:Number = -1;

		/**
		 *  @private
		 */
		private var removeHighlight:Boolean = false;	

		/**
		 *  @private
		 */
		private var showDropdown:Boolean=false;

		/**
		 *  @private
		 */
		private var showingDropdown:Boolean=false;

		/**
		 *  @private
		 */
		private var tempCollection:Object;

		/**
		 *  @private
		 */
		private var usingLocalHistory:Boolean=false;

		/**
		 *  @private
		 */
		private var dropdownClosed:Boolean=true;

		//--------------------------------------------------------------------------
		//
		//  Overridden Properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  editable
		//----------------------------------
		/**
		 *  @private
		 */
		override public function set editable(value:Boolean):void
		{
		    //This is done to prevent user from resetting the value to false
		    super.editable = true;
		}
		/**
		 *  @private
		 */
		override public function set dataProvider(value:Object):void
		{
			super.dataProvider = value;
			if(!usingLocalHistory)
				tempCollection = value;
		}

		//----------------------------------
		//  labelField
		//----------------------------------
		/**
		 *  @private
		 */
		override public function set labelField(value:String):void
		{
			super.labelField = value;

			invalidateProperties();
			invalidateDisplayList();
		}


		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------


		//----------------------------------
		//  filterFunction
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the filterFunction property.
		 */
		private var _filterFunction:Function = defaultFilterFunction;

		/**
		 *  @private
		 */
		private var filterFunctionChanged:Boolean = true;

		[Bindable("filterFunctionChange")]
		[Inspectable(category="General")]

		/**
		 *  A function that is used to select items that match the
		 *  function's criteria. 
		 *  A filterFunction is expected to have the following signature:
		 *
		 *  <pre>f(item:~~, text:String):Boolean</pre>
		 *
		 *  where the return value is <code>true</code> if the specified item
		 *  should displayed as a suggestion. 
		 *  Whenever there is a change in text in the AutoComplete control, this 
		 *  filterFunction is run on each item in the <code>dataProvider</code>.
		 *  
		 *  <p>The default implementation for filterFunction works as follows:<br>
		 *  If "AB" has been typed, it will display all the items matching 
		 *  "AB~~" (ABaa, ABcc, abAc etc.).</p>
		 *
		 *  <p>An example usage of a customized filterFunction is when text typed
		 *  is a regular expression and we want to display all the
		 *  items which come in the set.</p>
		 *
		 *  @example
		 *  <pre>
		 *  public function myFilterFunction(item:~~, text:String):Boolean
		 *  {
		 *     public var regExp:RegExp = new RegExp(text,"");
		 *     return regExp.test(item);
		 *  }
		 *  </pre>
		 *
		 */
		public function get filterFunction():Function
		{
			return _filterFunction;
		}

		/**
		 *  @private
		 */
		public function set filterFunction(value:Function):void
		{
			//An empty filterFunction is allowed but not a null filterFunction
			if(value!=null)
			{
				_filterFunction = value;
				filterFunctionChanged = true;

				invalidateProperties();
				invalidateDisplayList();

				dispatchEvent(new Event("filterFunctionChange"));
			}
			else
				_filterFunction = defaultFilterFunction;
		}

		//----------------------------------
		//  filterFunction
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the keepLocalHistory property.
		 */
		private var _keepLocalHistory:Boolean = false;

		/**
		 *  @private
		 */
		private var keepLocalHistoryChanged:Boolean = true;

		[Bindable("keepLocalHistoryChange")]
		[Inspectable(category="General")]

		/**
		 *  When true, this causes the control to keep track of the
		 *  entries that are typed into the control, and saves the
		 *  history as a local shared object. When true, the
		 *  completionFunction and dataProvider are ignored.
		 *
		 *  @default "false"
		 */
		public function get keepLocalHistory():Boolean
		{
			return _keepLocalHistory;
		}

		/**
		 *  @private
		 */
		public function set keepLocalHistory(value:Boolean):void
		{
			_keepLocalHistory = value;
		}

		//----------------------------------
		//  lookAhead
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the lookAhead property.
		 */
		private var _lookAhead:Boolean=false;

		/**
		 *  @private
		 */
		private var lookAheadChanged:Boolean;

		[Bindable("lookAheadChange")]
		[Inspectable(category="Data")]

		/**
		 *  lookAhead decides whether to auto complete the text in the text field
		 *  with the first item in the drop down list or not. 
		 *
		 *  @default "false"
		 */
		public function get lookAhead():Boolean
		{
			return _lookAhead;
		}

		/**
		 *  @private
		 */
		public function set lookAhead(value:Boolean):void
		{
			_lookAhead = value;
			lookAheadChanged = true;
		}

		//----------------------------------
		//  typedText
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the typedText property.
		 */
		private var _typedText:String="";
		/**
		 *  @private
		 */
		private var typedTextChanged:Boolean;

		[Bindable("typedTextChange")]
		[Inspectable(category="Data")]

		/**
		 *  A String to keep track of the text changed as 
		 *  a result of user interaction.
		 */
		public function get typedText():String
		{
		    return _typedText;
		}

		/**
		 *  @private
		 */
		public function set typedText(input:String):void
		{
		    _typedText = input;
		    typedTextChanged = true;

		    invalidateProperties();
			invalidateDisplayList();
			dispatchEvent(new Event("typedTextChange"));
		}

	    //--------------------------------------------------------------------------
	    //
	    //  Overridden methods
	    //
	    //--------------------------------------------------------------------------

		/**
		 *  @private
		 */
		override protected function commitProperties():void
		{
		    super.commitProperties();

		    if(!dropdown)
				selectedIndex=-1;

		    if(dropdown)
			{
			    if(typedTextChanged)
			    {
				    cursorPosition = textInput.selectionBeginIndex;

					updateDataProvider();

				    //In case there are no suggestions there is no need to show the dropdown
				    if(collection.length==0 || typedText==""|| typedText==null)
				    {
					dropdownClosed=true;
					showDropdown=false;
				    }
					else
					{
						showDropdown = true;
						selectedIndex = 0;
				}
			    }
			}
		}

		/**
		 *  @private
		 */
		override protected function focusOutHandler(event:FocusEvent):void
		{
			super.focusOutHandler(event)
			if(keepLocalHistory && dataProvider.length==0)
				addToLocalHistory();
		}
		/**
		 *  @private
		 */
		override public function getStyle(styleProp:String):*
		{
			if(styleProp != "openDuration")
				return super.getStyle(styleProp);
			else
			{
			if(dropdownClosed)
				return super.getStyle(styleProp);
			else
				return 0;
			}
		}
		/**
		 *  @private
		 */
		override protected function keyDownHandler(event:KeyboardEvent):void
		{
		    super.keyDownHandler(event);

		    if(!event.ctrlKey)
			{
			    //An UP "keydown" event on the top-most item in the drop-down
			    //or an ESCAPE "keydown" event should change the text in text
			    // field to original text
			    if(event.keyCode == Keyboard.UP && prevIndex==0)
				{
				    textInput.text = _typedText;
				    textInput.setSelection(textInput.text.length, textInput.text.length);
				    selectedIndex = -1; 
				}
			    else if(event.keyCode==Keyboard.ESCAPE && showingDropdown)
				{
				    textInput.text = _typedText;
				    textInput.setSelection(textInput.text.length, textInput.text.length);
				    showingDropdown = false;
				    dropdownClosed=true;
				}
				else if(event.keyCode == Keyboard.ENTER)
				{
					if(keepLocalHistory && dataProvider.length==0)
						addToLocalHistory();
				}
				else if(lookAhead && event.keyCode ==  Keyboard.BACKSPACE 
				|| event.keyCode == Keyboard.DELETE)
				    removeHighlight = true;
			}
			else
			    if(event.ctrlKey && event.keyCode == Keyboard.UP)
				dropdownClosed=true;

		    prevIndex = selectedIndex;
		}

		/**
		 *  @private
		 */
		override protected function measure():void
		{
		    super.measure();
		    measuredWidth = mx.core.UIComponent.DEFAULT_MEASURED_WIDTH;
		}

		/**
		 *  @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number, 
							      unscaledHeight:Number):void
		{

		    super.updateDisplayList(unscaledWidth, unscaledHeight);

			//An UP "keydown" event on the top-most item in the drop 
			//down list otherwise changes the text in the text field to ""
		    if(selectedIndex == -1)
			textInput.text = typedText;

		    if(dropdown)
			{
			    if(typedTextChanged)
				{
				    //This is needed because a call to super.updateDisplayList() set the text
				    // in the textInput to "" and thus the value 
				    //typed by the user losts
				    if(lookAhead && showDropdown && typedText!="" && !removeHighlight)
					{
						var label:String = itemToLabel(collection[0]);
						var index:Number =  label.toLowerCase().indexOf(_typedText.toLowerCase());
						if(index==0)
						{
						    textInput.text = _typedText+label.substr(_typedText.length);
						    textInput.setSelection(textInput.text.length,_typedText.length);
						}
						else
						{
						    textInput.text = _typedText;
						    textInput.setSelection(cursorPosition, cursorPosition);
						    removeHighlight = false;
						}

					}
				    else
					{
					    textInput.text = _typedText;
					    textInput.setSelection(cursorPosition, cursorPosition);
					    removeHighlight = false;
					}

				    typedTextChanged= false;
				}
			    else if(typedText)
				//Sets the selection when user navigates the suggestion list through
				//arrows keys.
					textInput.setSelection(_typedText.length,textInput.text.length);
			}
		    if(showDropdown && !dropdown.visible)
		    {
			//This is needed to control the open duration of the dropdown
			super.open();
			showDropdown = false;
			showingDropdown = true;

			if(dropdownClosed)
				dropdownClosed=false;
		    }
		}


		/**
		 *  @private
		 */
		override protected function textInput_changeHandler(event:Event):void
		{
		    super.textInput_changeHandler(event);
		    //Stores the text typed by the user in a variable
		    typedText=text;
		    // XenosAlert.info("Typed");
		    fetchData();
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 *  If keepLocalHistory is enabled, stores the text typed 
		 * 	by the user in the local history on the client machine
		 */
		private function addToLocalHistory():void
		{
		if (id != null && id != "" && text != null && text != "")
		{
		    var so:SharedObject = SharedObject.getLocal("AutoCompleteData");

		    var savedData : Array = so.data.suggestions;
		    //No shared object has been created so far
		    if (savedData == null)
			savedData = new Array();

		     var i:Number=0;
		     var flag:Boolean=false;
		     //Check if this entry is there in the previously saved shared object data
		     for(i=0;i<savedData.length;i++)
					if(savedData[i]==text)
					{
						flag=true;
						break;
					}
		     if(!flag)
		     {
			//Also ensure it is not there in the dataProvider
			     for(i=0;i<collection.length;i++)
				if(defaultFilterFunction(itemToLabel(ListCollectionView(collection).getItemAt(i)),text))
						{
							flag=true;
							break;
						}
		     }
			if(!flag)
				savedData.push(text);

		   so.data.suggestions = savedData;
		   //write the shared object in the .sol file
		       so.flush();
		}
		}	
		/**
		 *  @private
		 */
		private function defaultFilterFunction(element:*, text:String):Boolean 
		{
		    var label:String = itemToLabel(element);
		    return (label.toLowerCase().substring(0,text.length) == text.toLowerCase());
		}
		/**
		 *  @private
		 */

		private function templateFilterFunction(element:*):Boolean 
		{
			var flag:Boolean=false;
			if(filterFunction!=null)
				flag=filterFunction(element,typedText);
			return flag;
		}

		/**
		 *  @private
		 *  Updates the dataProvider used for showing suggestions
		 */
		private function updateDataProvider():void
		{
			dataProvider = tempCollection;
			collection.filterFunction = templateFilterFunction;
			collection.refresh();

		    //In case there are no suggestions, check there is something in the localHistory
		    if(collection.length==0 && keepLocalHistory)
		    {
		    var so:SharedObject = SharedObject.getLocal("AutoCompleteData");
				usingLocalHistory = true;
		    dataProvider = so.data.suggestions;
		    usingLocalHistory = false;
				collection.filterFunction = templateFilterFunction;
				collection.refresh();
		    }
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Custom Attriutes
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 *  URL for the typedText property.
		 */
		private var _url:String="";
		[Inspectable(category="Data")]

		/**
		 *  A String to keep track of the text changed as 
		 *  a result of user interaction.
		 */
		public function get mapping():String
		{
		    return _url;
		}

		/**
		 *  @private
		 */
		public function set mapping(input:String):void
		{
		    _url = input;
		}

		/**
		 *  @private
		 *  Storage for the typedText property.
		 */
		private var _cache:Boolean=false;
		[Inspectable(category="Data")]

		/**
		 *  A String to keep track of the text changed as 
		 *  a result of user interaction.
		 */
		public function get cache():Boolean
		{
		    return _cache;
		}

		/**
		 *  @private
		 */
		public function set cache(input:Boolean):void
		{
		    _cache = input;
		}

		/**
		 * @private 
		 * Maximum no of character for database hit
		 */
		private var _maxCharLimitToHit:int=0;
		[Inspectable(category="Data")]
		/**
		 *  A String to keep track of the text changed as 
		 *  a result of user interaction.
		 */
		public function get maxCharLimit():int {
		    return _maxCharLimitToHit;
		}

		/**
		 *  @private
		 */
		public function set maxCharLimit(input:int):void {
		    _maxCharLimitToHit = input;
		}

		/**
		 * @private 
		 * Field Name based on which data need to be fetched
		 */
		private var _fieldName:String="";
		[Inspectable(category="Data")]
		/**
		 *  A String to keep track of the text changed as 
		 *  a result of user interaction.
		 */
		public function get fieldName():String {
		    return _fieldName;
		}

		/**
		 *  @private
		 */
		public function set fieldName(input:String):void {
		    _fieldName = input;
		}

		/**
		 * @private 
		 * Maximum no of character for database hit
		 */
		private var _timeGap:Number=6000;
		[Inspectable(category="Data")]
		/**
		 *  A String to keep track of the text changed as 
		 *  a result of user interaction.
		 */
		public function get hitTimeInSec():Number {
		    return _timeGap;
		}

		/**
		 *  @private
		 */
		public function set hitTimeInSec(input:Number):void {
		    _timeGap = input * 1000;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Capturing result and fault event
		//
		//--------------------------------------------------------------------------

		/**
		 * @public 
		 * This function is capturing the result event.
		 * This will return the result as array collection, so the component will change to combo box.
		 */
		 /*
		  * Tech details: 
		  * 1. If no record found it will show alert.
		  * 2. If one record found then Result event does not give array collection, 
		  * so else part create array collection of single record and store it in data provider.
		  * 3. For more than one record Result event give array collection, iterate through cursor interface
		  * and store it in new collection and mapped it to data provide.
		  */
		public function httpResult(event:ResultEvent):void {

		   var resultCollection:ArrayCollection = new ArrayCollection();
		   var dataCursor:IViewCursor;
		   
		   if(event.result != null){
		       if(event.result.rows != null) {
		           if(event.result.rows.row != null) {
            		   if(event.result.rows.row is ArrayCollection) {
            		       dataCursor = ArrayCollection (event.result.rows.row).createCursor();
            		       while (! dataCursor.afterLast ){
            		           //add the value of <code><value>val</value></code>
            		           resultCollection.addItem(dataCursor.current.value);
            		           dataCursor.moveNext();
            		       }
                       } else {
                          resultCollection.removeAll();                           
                          resultCollection.addItem(event.result.rows.row.value); 
                       }
                    } else {
                        XenosAlert.error("No Result Found !");
                    }
                } else {
                    XenosAlert.error("No Result Found !");
                }
            } else {
                XenosAlert.error("No Result Found !");
            }
		   dataProvider = resultCollection;           
		}

	    /**
		 * @public 
		 * This function is capturing the fault event
		 */
	    public function httpFault(event:FaultEvent):void {
			var faultstring:String = event.fault.faultString;
			XenosAlert.info(faultstring);
		}

		
		//--------------------------------------------------------------------------
		//
		//  Method that make a database hit through specified URL
		//
		//--------------------------------------------------------------------------
		
		private var isDataFetched:Boolean=false;
		private var previousTypedText:String="";
		private var currentTypedText:String="";
		private var currentHit:Number = (new Date()).time;
		private var lastHit:Number = (new Date()).time;
	
		/**
		 * @public
		 * This function sends a request to action servlet to fetch the required data for 
		 * List item
		 */
		public function fetchData():void {
			currentTypedText = typedText;
			if (_cache == true && isDataFetched == false) {
				httpService.url = _url;
				httpService.send();
				isDataFetched = true;
				currentHit = (new Date()).time;
				// XenosAlert.info("Time Diff is " + (currentHit - lastHit) + " Last Hit:" + lastHit + "Current Hit: " + currentHit);
			}
			if (_cache == false && typedText.length > _maxCharLimitToHit && previousTypedText != currentTypedText) {
				currentHit = (new Date()).time;
				if (_fieldName.length > 0 && (currentHit - lastHit) > _timeGap) {
					lastHit = currentHit;
					httpService.url = _url + "&" + _fieldName + "=" + typedText + "*";
					httpService.send();
					previousTypedText = currentTypedText;
				}			
			}
		}
	}	
}