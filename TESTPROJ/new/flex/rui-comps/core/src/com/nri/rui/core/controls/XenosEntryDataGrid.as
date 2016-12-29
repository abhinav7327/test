
package com.nri.rui.core.controls
{
	import com.nri.rui.core.renderers.AddHeaderRenderer;
	import com.nri.rui.core.renderers.AddRemoveBtnRenderer;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	import mx.events.DataGridEvent;
	import mx.events.FlexEvent;
	import mx.events.ValidationResultEvent;
	import mx.validators.Validator;
	
	/*
	 * This class may be used during the entry screen to add rows in the datagrid
	 * by editing. This will add a default column at the beginning to add/delete
	 * the row added.
	 */
	public class XenosEntryDataGrid extends DataGrid
	{
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	
	    /**
	     *  Constructor.
	     */
		public function XenosEntryDataGrid()
		{
			super();
			addEventListener(DataGridEvent.ITEM_EDIT_BEGINNING,editBeginningHandler);
			addEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteHandler);
		}
		private function editBeginningHandler(e:DataGridEvent):void{
			if(e.rowIndex!=this.editedRowIndex){
				e.preventDefault();
			}
		}
		private function creationCompleteHandler(e:FlexEvent):void{
			addDefaultColumn();
			removeEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteHandler);
		}
		
		private function addDefaultColumn():void
		{
			//Add a object
			//(this.dataProvider as ArrayCollection).addItem(new Object());
			
			var dg :DataGridColumn = new DataGridColumn();
			dg.dataField="adddel";
			dg.editable = false;
			//dg.headerText = "Add/Remove";
			dg.headerRenderer = new ClassFactory(AddHeaderRenderer);
			dg.itemRenderer = new ClassFactory(AddRemoveBtnRenderer);
			dg.width=150;			
			dg.minWidth=150;
			
			//dg.resizable=false;
			
			var cols :Array = this.columns;
			cols.unshift(dg);
			this.columns = cols;
			
		}
		
		//--------------------------------------------------
		// Do NOT mention the validatorInstance in mxml.
		// Use validator name for the fully qualified name
		// of the validator class.
		//-------------------------------------------------- 
		public var validatorInstance:Validator;
		
		//----------------------------------
		//  validator if needed
		//----------------------------------
		private var _validatorName:String;
		
		public function get validatorName():String {
			
			return _validatorName;
		}
		
		public function set validatorName(validatorName:String):void {
			
			_validatorName = validatorName;
			
			var classDef:Class = getDefinitionByName(validatorName) as Class;
			validatorInstance = new classDef();
		}
		
		/**
		 * URL for adding record
		 */		
		[Bindable]
		private var _addServiceURL:String;
		
		public function get addServiceURL():String{
			return _addServiceURL;
		}
		
		public function set addServiceURL(url:String):void{
			this._addServiceURL=url;
		}
		
		/**
		 * URL for editing record
		 */		
		[Bindable]
		private var _editServiceURL:String;
		
		public function get editServiceURL():String{
			return _editServiceURL;
		}
		
		public function set editServiceURL(url:String):void{
			this._editServiceURL=url;
		}
		
		[Bindable]
		private var _deleteServiceURL:String;
		
		public function get deleteServiceURL():String{
			return _deleteServiceURL;
		}
		
		public function set deleteServiceURL(url:String):void{
			this._deleteServiceURL=url;
		}
		
		/**
		 * Reference to the xenoserror control 
		 */		
		private var _errorPage:XenosErrors=null;
		
		public function get errorPage():Object{
			return _errorPage;
		}
		
		public function set errorPage(errPage:Object):void{
			this._errorPage=errPage as XenosErrors;
		}
		
		[Bindable]
		public var editedRowIndex:int=-1;
		
		[Bindable]
		private var _dataGridMode:String="entry";
		
		public function get dataGridMode():String{
			return this._dataGridMode;
		}
		public function set dataGridMode(dgmode:String):void{
			this._dataGridMode=dgmode;
		}
		
		
		//stores the data model for non-editable (pre-populated fields during amend mode
		[Bindable]
		private var _amendDataModel:Object=null;
		
		public function get amendDataModel():Object{
			return this._amendDataModel;
		}
		public function set amendDataModel(model:Object):void{
			this._amendDataModel=model;
		}
		
		//stores the actionform property name used for storing edited index / delete index property
		[Bindable]
		private var _editedIndexPropertyName:String="";
		
		public function get editedIndexPropertyName():String{
			return this._editedIndexPropertyName;
		}
		public function set editedIndexPropertyName(propname:String):void{
			this._editedIndexPropertyName=propname;
		}
		
		//Stores the array of column indices which cannot be edited during entry edit
		[Bindable]
		private var _nonEditableColumns:Array=null;
		
		public function get nonEditableColumns():Array{
			return this._nonEditableColumns;
		}
		public function set nonEditableColumns(propname:Array):void{
			this._nonEditableColumns=propname;
		}
		
		//Validates all records before submitting
		//Returns true if valid else false;
		public function validateAllRecords(isMandatoryField:Boolean=true):Boolean{
			var validatorObj:Validator=this.validatorInstance;
			var errorMsg:String="";
			var i:int=0;
			
			if(isMandatoryField && (this.dataProvider as ArrayCollection).length==0){
				XenosAlert.error("No records to submit.");
				return false;
			}
			if(this.editedRowIndex!==-1)
			{
				XenosAlert.error("Cannot submit unsaved data.");
				return false;
			}
			for each(var row:Object in (this.dataProvider as ArrayCollection)){
				//if any object is unsaved
				if(row.isFreshObject as Boolean){
					XenosAlert.error("Cannot submit unsaved data.");
					return false;
				}
			  		i++;
			  		var validationResult:ValidationResultEvent = new ValidationResultEvent(ValidationResultEvent.VALID);
					if(validatorObj!=null) {
						validationResult = validatorObj.validate(row);
					}
					// add the error 
					if(validationResult.type==ValidationResultEvent.INVALID){
			           errorMsg +="[Record "+i+"] : "+validationResult.message+"\n";
			  		}
			  	} 
			  	if(!XenosStringUtils.isBlank(errorMsg))
			  	{
			  		XenosAlert.error(errorMsg);
			  		return false;
			  	} 	
			  	return true;	
			
			
		}
		
		/**
		 *Reset the datagrid 
		 * 
		 */		
		public function reset():void{
			//destroy any currently open itemeditor
			this.destroyItemEditor();			
			(this.dataProvider as ArrayCollection).removeAll();
			(this.dataProvider as ArrayCollection).refresh();
			this.editedRowIndex=-1;
			
			//reset non editable columns of dgrid
			if(this.nonEditableColumns!=null ){
					for each(var index:int in this.nonEditableColumns){
						var dgc:DataGridColumn=this.columns[index] as DataGridColumn;
						dgc.editable=true;
					}
				}
			
			
		}
		
	}
}