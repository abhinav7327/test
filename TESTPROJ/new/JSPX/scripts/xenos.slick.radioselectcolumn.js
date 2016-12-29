//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
(function($) {
    // register namespace
    $.extend(true, window, {
        "Slick": {
            "RadioSelectColumn": RadioSelectColumn
        }
    });


    function RadioSelectColumn(options) {
        var _grid;
        var _self = this;
        var _selectedRowsLookup = {};
		// Variables to preserve selected rows
        var preserveSelectedRow = [];
        var preserveSelectedRowID = [];
        var _defaults = {
            columnId: "_checkbox_selector",
            cssClass: null,
            toolTip: "Select/Deselect All",
            width: 30
        };

        var _options = $.extend(true,{},_defaults,options);

        function init(grid) {
            _grid = grid;
			 // handleSort API will be triggered by onSort operation of grid column
            _grid.onSort.subscribe(handleSort);
            _grid.onSelectedRowsChanged.subscribe(handleSelectedRowsChanged);
            _grid.onClick.subscribe(handleClick);
        }

        function destroy() {
            _grid.onSelectedRowsChanged.unsubscribe(handleSelectedRowsChanged);
            _grid.onClick.unsubscribe(handleClick);
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

			//If the Header Check Box is to be excluded then no need to update the column header
			if(_options.excludeHeaderCheckBox){
				return;
			}
        }

        function handleClick(e, args) {
            // clicking on a row select checkbox
            if (_grid.getColumns()[args.cell].id === _options.columnId && $(e.target).filter(":radio")) {
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
                    _grid.setSelectedRows($.grep([],function(n) { return n != args.row }));
                }
                else {
                    _grid.setSelectedRows([].concat(args.row));
                }
				
				
				toggleRowSelection(args.row);
                e.stopPropagation();
                e.stopImmediatePropagation();
            }
        }

		    function getColumnDefinition() {
				  return {
					id: _options.columnId,
					name: "",
					toolTip: _options.toolTip,
					field: "sel",
					width: _options.width,
					resizable: false,
					sortable: false,
					cssClass: _options.cssClass,
					formatter: checkboxSelectionFormatter
				  };
				}

				function checkboxSelectionFormatter(row, cell, value, columnDef, dataContext) {
				  if (dataContext) {
					return _selectedRowsLookup[row]
						? "<input type='radio' name='row-select' checked='checked'>"
						: "<input type='radio' name='row-select'>";
				  }
				  return null;
				}
		
		
		    function toggleRowSelection(row) {
				  _grid.setSelectedRows([row]);
				  return true;
				  // if (_selectedRowsLookup[row]) {
				  //   _grid.setSelectedRows($.grep(_grid.getSelectedRows(), function (n) {
				  //     return n != row
				  //   }));
				  // } else {
				  //   _grid.setSelectedRows(_grid.getSelectedRows().concat(row));
				  // }
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
        
        $.extend(this, {
            "init": init,
            "destroy": destroy,

            "getColumnDefinition": getColumnDefinition
        });
    }
})(jQuery);