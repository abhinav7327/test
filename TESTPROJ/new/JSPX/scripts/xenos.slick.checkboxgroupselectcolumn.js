//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
(function($) {
    // register namespace
    $.extend(true, window, {
        "Slick": {
            "CheckboxGroupSelectColumn": CheckboxGroupSelectColumn
        }
    });


    function CheckboxGroupSelectColumn(options) {
        var _grid;
        var _self = this;
        var _selectedRowsLookup = {};
		var _defalutCols =[];
		var _defaults = {
            columnId: "_checkbox_selector",
            cssClass: null,
            toolTip: "Select/Deselect All",
            width: 25
        };

        var _options = $.extend(true,{},_defaults,options);

        function init(grid) {
            _grid = grid;
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
			var dataArr = _grid.getData();
			 if (dataArr.getItems) {
				dataArr = dataArr.getItems();
			 }
			 var non_selects = $.grep(dataArr, function (r) {
				 return (r.isConsEnabled === false);
			 }).length;
			 console.log(non_selects);
			if ((selectedRows.length + _defalutCols.length) == _grid.getDataLength() - non_selects) {
                _grid.updateColumnHeader(_options.columnId, "<input type='checkbox' checked='checked'>", _options.toolTip);
            }
            else {
                _grid.updateColumnHeader(_options.columnId, "<input type='checkbox'>", _options.toolTip);
            }
        }

        function handleClick(e, args) {
        	// clicking on a row select checkbox
				var checkVal = _grid.getSelectedRows();
			  if($(e.target).is(':checked') && $(e.target).val()>0){
				for (i=1; i<=$(e.target).val(); i++)
				   checkVal.push(args.row+i);
				 _grid.setSelectedRows(checkVal);
				}
		
            if (_grid.getColumns()[args.cell].id === _options.columnId && $(e.target).is(":checkbox")) {
                if(_grid.onCheckBoxClick)
                    _grid.onCheckBoxClick(e, args);
                // if editing, try to commit
                if (_grid.getEditorLock().isActive() && !_grid.getEditorLock().commitCurrentEdit()) {
                    e.preventDefault();
                    e.stopImmediatePropagation();
                    return;
                }

                if (_selectedRowsLookup[args.row]) {
                	_grid.setSelectedRows($.grep(_grid.getSelectedRows(),function(n) { return n != args.row }));
                }
                else {
                	_grid.setSelectedRows(_grid.getSelectedRows().concat(args.row));
                }
                e.stopPropagation();
                e.stopImmediatePropagation();
            }
        }

        function handleHeaderClick(e, args) {
        	if(!$(e.target).is(":checkbox")){
                return;
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
						if(jQuery.inArray(i, _defalutCols) == -1){
							if(_grid.getDataItem(i).isConsEnabled !== false) {
								rows.push(i);							
							 }   
						}else{
                        //rows.push(i);
						}
					}
                    _grid.setSelectedRows(rows);
                }
                else {
                    _grid.setSelectedRows([]);
                }
                e.stopPropagation();
                e.stopImmediatePropagation();
            }
        }

        function getColumnDefinition() {
            return {
                id: _options.columnId,
                name: "<input type='checkbox'>",
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

      /*   function checkboxSelectionFormatter(row, cell, value, columnDef, dataContext) {
            if (dataContext) {
                return _selectedRowsLookup[row]
                    ? "<input type='checkbox' checked='checked'>"
                    : "<input type='checkbox'>";
            }
            return null;
        } */
		
		function checkboxSelectionFormatter(row, cell, value, columnDef, dataContext) {
		if(dataContext.groupFlag && dataContext.headvalue == 0){
			if(_grid == undefined){
				_defalutCols.push(row);
				/* var checkDef = _grid.getSelectedRows();
				var pos= checkDef.indexOf(row);
				checkDef.splice(pos,1);
				_grid.setSelectedRows(checkDef); */
				}
			return null;
		}
      if (dataContext.render) {
		if(_selectedRowsLookup[row]){
			dataContext.render = false;
			return "<input type='checkbox' checked='checked' class='checkboxadd' value = '"+ dataContext.headvalue+"'>";
			}
		if(dataContext.groupFlag && dataContext.headvalue == 0){
			return null;
		}
		if(dataContext.isConsEnabled === false) {
			return null;
		}
        if(dataContext.groupFlag && dataContext.headvalue > 0){
			dataContext.render = false;
			return "<input type='checkbox' class='checkboxadd' value = '"+ dataContext.headvalue+"'>";
		}else{
			return null;
		}
      }else{
			return _selectedRowsLookup[row]
            ? "<input type='checkbox' checked='checked' class='checkboxadd' value = '"+ dataContext.headvalue+"'>"
            : "<input type='checkbox' class='checkboxadd' value = '"+ dataContext.headvalue+"'>";
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