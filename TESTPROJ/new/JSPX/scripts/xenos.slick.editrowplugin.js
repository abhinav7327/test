//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
(function ($) {
  // register namespace
  $.extend(true, window, {
    "Slick": {
      "EditRow": GridActions
    }
  });


  function GridActions(options) {
    var _grid;
    var _self = this;
	var _gridOptions;
    var _defaults = {
      columnId: "actions",
      cssClass: null,
      width: 55
    };

    var _options = $.extend(true, {}, _defaults, options);

    function init(grid) {
      _grid = grid;
	  _gridOptions = _grid.getOptions();
      _grid.onClick.subscribe(handleClick);
    }

    function destroy() {
      _grid.onClick.unsubscribe(handleClick);
    }

    function handleClick(e, args) {
      // clicking on a row edit
      if (_grid.getColumns()[args.cell].id === _options.columnId && ($(e.target).is(".editIco") || $(e.target).is(".deleteIco"))) {
        // if editing, try to commit
        if (_grid.getEditorLock().isActive() && !_grid.getEditorLock().commitCurrentEdit()) {
          e.preventDefault();
          e.stopImmediatePropagation();
          return;
        }
		
		toggleRowSelection(args.row);
		resetEditFlag();
		var item = _grid.getDataItem(args.row);
		if($(e.target).is(".editIco")){
			item['_edit_'] = true;
			_gridOptions.editCallback(args.row, item);
			_grid.invalidateAllRows();
			_grid.render();
		} else if($(e.target).is(".deleteIco")){
			_gridOptions.deleteCallback(args.row, item);
			_grid.invalidateAllRows();
			_grid.render();
		}
        e.stopPropagation();
        e.stopImmediatePropagation();
      }
    }
	
	function toggleRowSelection(row) {
	  _grid.setSelectedRows([row]);
    }
	
	function resetEditFlag(){
		var item;
		for(var i=0 ; i<_grid.getDataLength(); i++){
			item = _grid.getDataItem(i);
			if(item['_edit_']){
				delete item._edit_;
			}
		}
	}

    function getColumnDefinition() {
      return {
        id: _options.columnId,
        name: "Actions",
        field: "sel",
        width: _options.width,
        resizable: false,
        sortable: false,
        cssClass: _options.cssClass,
        formatter: actionFormatter
      };
    }

    function actionFormatter(row, cell, value, columnDef, dataContext) {
	  if(!columnDef.editEnableCallback(columnDef.field, dataContext)){
		return null;
	  }
	  if(dataContext['_edit_'] == true){
		return null;
	  }
      if (dataContext) {
			var editMode = $.isFunction(columnDef.editMode) ? columnDef.editMode.apply(this,[value, columnDef, dataContext]) : columnDef.editMode;
			var str = null;
			if(editMode == 'both'){
				str = "<span class='accEntrySlickIco'><img class='editIco' src='" + xenos.context.path + "/images/namrui/icon/accnt-edit-ico.png'/></span><span class='accEntrySlickIcoLast'><img class='deleteIco rowEditIcon' src='" + xenos.context.path + "/images/namrui/icon/trash-ico-blue.png'/></span>"
			} else if(editMode == 'edit'){
				str = "<span class='accEntrySlickIcoLast'><img class='editIco' src='" + xenos.context.path + "/images/namrui/icon/accnt-edit-ico.png'/></span>";
			} else if(editMode == 'delete'){
				str = "<span class='accEntrySlickIcoLast'><img class='deleteIco' src='" + xenos.context.path + "/images/namrui/icon/trash-ico-blue.png'/></span>";
			}
			return str;
      }
      return null;
    }

    $.extend(this, {
      "init": init,
      "destroy": destroy,

      "getColumnDefinition": getColumnDefinition
    });
  }
})(jQuery);