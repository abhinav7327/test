//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
(function($) {
    // register namespace
    $.extend(true, window, {
        "Slick": {
            "CheckboxSelectColumn": CheckboxSelectColumn
        }
    });


    function CheckboxSelectColumn(options) {
        var _grid;
        var _self = this;
        var _selectedRowsLookup = {};
		// Variables to preserve selected rows
        var preserveSelectedRow = [];
        var preserveSelectedRowID = [];
        var _defaults = {
            columnId: "_checkbox_selector",
            cssClass: null,
			headerName : "<input type='checkbox'>",
            toolTip: "Select/Deselect All",
			excludeHeaderCheckBox : false,
            width: 25,
			showCheckBox : function(item){return true},
			onRowSelectDeselect : function(grid, rowIndex){}
        };

        var _options = $.extend(true,{},_defaults,options);
		function init(grid) {
            _grid = grid;
			// handleSort API will be triggered by onSort operation of grid column
			console.log('Init......');
            _grid.onSort.subscribe(handleSort);
            _grid.onSelectedRowsChanged.subscribe(handleSelectedRowsChanged);
            _grid.onClick.subscribe(handleClick);
            _grid.onHeaderClick.subscribe(handleHeaderClick);
        }

        function destroy() {
            _grid.onSelectedRowsChanged.unsubscribe(handleSelectedRowsChanged);
            _grid.onClick.unsubscribe(handleClick);
            _grid.onHeaderClick.unsubscribe(handleHeaderClick);
        }

        function handleSelectedRowsChanged(e, args) {
            var selectedRows = _grid.getSelectedRows();
            var lookup = {}, row, i;
            for (i = 0; i < selectedRows.length; i++) {
                row = selectedRows[i];
                lookup[row] = true;
                if (lookup[row] !== _selectedRowsLookup[row]) {
                    _grid.invalidateRow(row);
                    delete _selectedRowsLookup[row];
                }
            }
            for (i in _selectedRowsLookup) {
                _grid.invalidateRow(i);
            }
            _selectedRowsLookup = lookup;
            _grid.render();

			 // Count the number of rows that are not selectable.
			// Use in the check to see if all rows are selected.
			 var dataArr = _grid.getData();
			 if (dataArr.getItems) {
				dataArr = dataArr.getItems();
			 }
			 var non_selects = $.grep(dataArr, function (r) {
				 return (r.isConsEnabled === false);
			 }).length;
			if(_options.excludeHeaderCheckBox){
				return;
			}
			if (selectedRows.length && selectedRows.length == _grid.getDataLength()- non_selects) {
				_grid.updateColumnHeader(_options.columnId, "<input type='checkbox' checked='checked'>", _options.toolTip);
            }
            else {
                _grid.updateColumnHeader(_options.columnId, "<input type='checkbox'>", _options.toolTip);
            }
        }

        function handleClick(e, args) {
            // clicking on a row select checkbox
            if (_grid.getColumns()[args.cell].id === _options.columnId && $(e.target).is(":checkbox")) {
                if(_grid.onCheckBoxClick)
                    _grid.onCheckBoxClick(e, args);
                // if editing, try to commit
                if (_grid.getEditorLock().isActive() && !_grid.getEditorLock().commitCurrentEdit()) {
                    e.preventDefault();
                    e.stopImmediatePropagation();
                    return;
                }
                /*IGVRI:2551 -Begin
                 * Background: Adding a Logic to modify flag in dataContext whenever a record is selected & deselected
                 * Modification: Setting flag to true/false depending on whether record is selected/deselected
                 * */
                _grid.getDataItem(args.row).selected = $(e.target).is(":checked");
                /*IGVRI:2551 -End*/
                if (_selectedRowsLookup[args.row]) {
					_grid.setSelectedRows($.grep(_grid.getSelectedRows(),function(n) { return n != args.row }));
                }
                else {
					 _grid.setSelectedRows(_grid.getSelectedRows().concat(args.row));
                }
				
				_options.onRowSelectDeselect(_grid, args.row);
				
                e.stopPropagation();
                e.stopImmediatePropagation();
            }
        }

        function handleHeaderClick(e, args) {
							
			//Return if there is no check box in the header
			if(_options.excludeHeaderCheckBox){
				return;
			}

            if(!$(e.target).is(":checkbox")){
                return;
            }
			/*IGVRI:IGVRI-2561 - Begin
			* Modification: Adding hook for handling click event for checkbox of the header row of the grid.
			* If necessary then implement in the corresponding page.
			* */			
			if(_grid.onHeaderCheckBoxClick && jQuery.isFunction(_grid.onHeaderCheckBoxClick)){
				_grid.onHeaderCheckBoxClick(e, args);
			}
            if (args.column.id == _options.columnId && $(e.target).is(":checkbox")) {
                // if editing, try to commit
                if (_grid.getEditorLock().isActive() && !_grid.getEditorLock().commitCurrentEdit()) {
                    e.preventDefault();
                    e.stopImmediatePropagation();
                    return;
                }

                if ($(e.target).is(":checked")) {
                    var rows = [];
                    for (var i = 0; i < _grid.getDataLength(); i++) {
                        /*IGVRI: -Begin
                         * Background: Adding a Logic to modify flag in dataContext whenever a record is selected & deselected
                         * Modification: Setting flag to true for all records, since Select All is called
                         * */
						 if(_grid.getDataItem(i).isConsEnabled !== false) {
							_grid.getDataItem(i).selected = true;
							rows.push(i);
							//++_checkBoxCount;							
						 }                        
                        /*IGVRI: -End */
                        
                    }
                    _grid.setSelectedRows(rows);
                }
                else {
                    /*IGVRI:2551 -Begin
                    * Background: Adding a Logic to modify flag in dataContext whenever a record is selected & deselected
                    * Modification: Setting flag to false for all records, since Deselect All is called
                    * */
                    
                    /*IGVRI:2551 - End*/
                    _grid.setSelectedRows([]);
                }
                e.stopPropagation();
                e.stopImmediatePropagation();
            }
        }

        function getColumnDefinition() {
            return {
                id: _options.columnId,
                name: _options.headerName,
                toolTip: _options.toolTip,
                field: "sel",
                width: _options.width,
                resizable: false,
                sortable: false,
                cssClass: _options.cssClass,
                formatter: checkboxSelectionFormatter,
				excludeFromColumnPicker:true
            };
        }

        function checkboxSelectionFormatter(row, cell, value, columnDef, dataContext) {
			
			// for showing tooltip correctly from initial screen
			$("div[id$="+_options.columnId+"]",".slick-header-columns").attr('title',_options.toolTip);
            if (dataContext) {
			// Rows can be marked as not selectable.
			if(!_options.showCheckBox(dataContext)){
				return null;
			}
			
			if(dataContext.transmissionReqd=='N'&&dataContext.transmitted=='N'&&dataContext.cxlTransmissionReqd=='N'&&dataContext.cxlTransmitted=='N' && typeof dataContext.authorizationFlag=='undefined')
			{
				return "<input type='checkbox' disabled='true'>";
			}
			if(dataContext.isConsEnabled === false) {
				return null;

			}			
			
			return _selectedRowsLookup[row]
                    ? "<input type='checkbox' checked='checked'>"
                    : "<input type='checkbox'>";
            }
            return null;
        }
		function handleSort(e, args){
        	var grid = args.grid;
        	if(grid.getSelectedRows().length > 0){
				// Preserving Selected Rows
				preserveSelectedRow = grid.getSelectedRows();
				// Preserving Selected Row ID
				preserveSelectedRowID = [];
				for (i = 0; i < preserveSelectedRow.length; i++) {
				    preserveSelectedRowID.push(grid.getDataItem(preserveSelectedRow[i]).id);
				}
				// handleCheckBox API will be triggered when rendering operation of grid is completed after sorting
				grid.onRenderCompleted.subscribe(handleCheckBox);
        	}                
        }
        
        function handleCheckBox(e, args){
        	var grid = args.grid;
            var selectedRows = grid.getSelectedRows();
            var newPosition = [];
            var position, i, j;
            // Iterating all rows of the grid to find the position of the previously selected items (before sort)
            for (i = 0; i < selectedRows.length; i++) {
                 position = -1;
                 for (j = 0; j < grid.getData().getItems().length; j++) {
                    position = $.inArray(grid.getDataItem(j).id, preserveSelectedRowID );
                    if(position >= 0){
                       // Items found and inserting the position into newPosition Array
                       newPosition.push(j);
                    }
                 }  
            }
            // If newPosition is not empty then re-order the selection as per new position.
            if(newPosition.length > 0){
               grid.onRenderCompleted.unsubscribe(handleCheckBox);
               grid.setSelectedRows(newPosition);
            }
            grid.onRenderCompleted.unsubscribe(handleCheckBox);
        }
        $.extend(this, {
            "init": init,
            "destroy": destroy,

            "getColumnDefinition": getColumnDefinition
        });
    }
})(jQuery);