//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
(function($) {
	function SlickColumnPicker(columns,grid,options)
	{
		var $menu;
		var isDirty;
		var colPkr = {};
		var defaults = {
			fadeSpeed: 250
		};
    var visibleColumns = [];

        this.destroy = function(){
            $('html').unbind("click."+options.containerId);
            $menu.unbind("click."+options.containerId);
            $(".pagerWrap .queryColumns").off('click.'+options.containerId);
            $menu.remove();
            if ( typeof $xenos$excelColumnPicker$destroy === 'function' ) {
              $xenos$excelColumnPicker$destroy();
            }
        };

        var htmlClickHandler = function(e,t) {
            if($(e.target).closest('.slick-columnpicker').size()>0){
                return;
            }else{
                $menu.fadeOut(options.fadeSpeed);
            }
        }

        function init() {
            if(options.isPopUpQuery === undefined){
                $(".pagerWrap .queryColumns").on('click.'+options.containerId,handleHeaderContextMenu);
                if ( typeof $xenos$excelColumnPicker$init === 'function' ) {
                  $xenos$excelColumnPicker$init();
                }
                $('html').bind('click.'+options.containerId,htmlClickHandler);
                options = $.extend({}, defaults, options);
                if ($menu)
                  $menu.remove();
                $menu = $("<ul class='slick-columnpicker' style='display:none;position:absolute;z-index:100000;' />").appendTo(document.body);
                $menu.bind("click."+options.containerId, updateColumn);
            }
        }

    function getColumnByIdWithIndex(id) {
      for (var i in columns) {
          if (columns[i].id === id) {
              return {'column': columns[i], 'index': i};
          }
      }
    }
		function handleHeaderContextMenu(e, args)
		{
			e.stopPropagation();
			e.preventDefault();
      var obj;
      var cont = $menu;
			// Check whether column picker is opened. If so, then just close the column picker and return.
			if ($menu.is(':visible')) {
				$menu.fadeOut(options.fadeSpeed);
				return;
			}
      if (typeof $xenos$excelColumnPicker$hideIfVisible === 'function') {
        $xenos$excelColumnPicker$hideIfVisible();
      }
      visibleColumns = [];
      //clone the visible columns first
      for(var ind in grid.getColumns()) {
        visibleColumns.push(grid.getColumns()[ind]);
      }
      var defaultInvisibleColumns = options.defaultInvisibleColumns() || [];
      for (var i in defaultInvisibleColumns) {
        obj = getColumnByIdWithIndex(defaultInvisibleColumns[i]);
        if ( !isExists(visibleColumns, obj.column.id).exist ) {
            visibleColumns.splice(obj.index, 0, obj.column);
          }
      }
      var exists;
      for( var i in columns ) {
        if ( !isExists(visibleColumns, columns[i].id).exist ) {
          visibleColumns.splice(i, 0, columns[i]);
        }
      }
      if ($menu.find('.jspPane').size() != 0) {
        $menu.find('.jspPane').empty();
        cont = $menu.find('.jspPane');
      } else {
        $menu.empty();
      }
      
      var $li, $input;
      for (var i=0; i<visibleColumns.length; i++) {
        $li = $("<li />").appendTo(cont);

        $input = $("<input type='checkbox' />")
            .attr("id", "columnpicker_" + i)
            .attr("columnId", visibleColumns[i].id)
            .data("id", visibleColumns[i].id)
            .appendTo($li);

        if (grid.getColumnIndex(visibleColumns[i].id) != null)
          $input.attr("checked","checked");
        
        $("<label for='columnpicker_" + i + "' />")
          .html(visibleColumns[i].name)
          .appendTo($li);
          
        //empty or undefined
        var enterpriseVal=grid.enterprisePrefVal;
        if(grid.enterprisePrefVal == undefined){
        
        } else if((jQuery.inArray(visibleColumns[i].id,enterpriseVal)) == -1){
           $li.css('display','none');				  
        } 
        
        //First position is set for consolidate screen so it should not be disabled
        
        if((visibleColumns[i].hasOwnProperty('excludeFromColumnPicker') && visibleColumns[i]['excludeFromColumnPicker']=== true) || ($.trim(visibleColumns[i].name)=="")){
          $li.css('display','none');
        }
      }
      $("<div class='hrBorder'></div>").appendTo(cont);
      $li = $('<li id="autoresize-par"></li>').appendTo(cont);
      $input = $("<input type='checkbox' id='autoresize' />").appendTo($li);
      $("<label for='autoresize'>Force Fit Columns</label>").appendTo($li);
      if (grid.getOptions().forceFitColumns)
        $input.attr("checked", "checked");

      $li = $('<li id="syncresize-par"></li>').appendTo(cont);
      $input = $("<input type='checkbox' id='syncresize' />").appendTo($li);
      $("<label for='syncresize'>Synchronous Resizing</label>").appendTo($li);
      if (grid.getOptions().syncColumnCellResize)
        $input.attr("checked", "checked");
        
      colPkr.contentHeight = $menu.height();
      colPkr.populated = true;

			colPkr.btn = $('.queryColumns');
			colPkr.top = colPkr.btn.offset().top+colPkr.btn.height()+2;
			colPkr.left = colPkr.btn.offset().left-$menu.width()+7;
			colPkr.maxHeight = $('#footer').offset().top-colPkr.btn.offset().top-colPkr.btn.height()-3;
			colPkr.needScroll = colPkr.contentHeight+7 > colPkr.maxHeight;
			colPkr.height = colPkr.contentHeight;
			colPkr.api = $menu.data('jsp');
			if (colPkr.needScroll) {
				colPkr.height = colPkr.maxHeight;
			} else if (colPkr.api) {
				colPkr.height += 11;
			}
			$menu
				.css('top', colPkr.top)
				.css("left", colPkr.left)
				.css('height', colPkr.height)
				.fadeIn(options.fadeSpeed);
			if (colPkr.api) {
				colPkr.api.reinitialise();
			} else if (colPkr.needScroll) {
				$menu.jScrollPane({showArrows:true});
			}
		}

		function updateColumn(e)
		{
			if (e.target.id == 'autoresize') {
				if (e.target.checked) {
					grid.setOptions({forceFitColumns: true});
					grid.autosizeColumns();
				} else {
					grid.setOptions({forceFitColumns: false});
					var col = grid.getColumns();
					for (var i in col) {
						col[i].width = getColumnByIdWithIndex(col[i].id).column.width;
					}
					grid.setColumns(col);
				}
                if(options.saveEnableCallback){
                    options.saveEnableCallback(grid);
					jQuery('.slick-columnpicker').data("isDirty",true);
                    //options.forceFitGrid(grid);
                }
				return;
			}

			if (e.target.id == 'syncresize') {
				if (e.target.checked) {
					grid.setOptions({syncColumnCellResize: true});
				} else {
					grid.setOptions({syncColumnCellResize: false});
				}
                if(options.saveEnableCallback){
                    options.saveEnableCallback(grid);
					jQuery('.slick-columnpicker').data("isDirty",true);
                }
				return;
			}

			if ($(e.target).is(":checkbox")) {
				if ($menu.find('li:not(#autoresize-par,#syncresize-par) :checkbox:visible:checked').length == 0) {
					$(e.target).attr("checked","checked");
					return;
				}

				var selectedColumnId = $(e.target).attr('columnId');
				var currentVisibleColumns = grid.getColumns();
				var currentVisibleColumnsCp = currentVisibleColumns.slice(0);
				if($(e.target).is(":checked")){
					putIfAbsent(currentVisibleColumnsCp, selectedColumnId, visibleColumns);
				} else {
					removeIfExist(currentVisibleColumnsCp, selectedColumnId);
				}

                grid.setColumns(currentVisibleColumnsCp);
				jQuery('.slick-columnpicker').data("isDirty",true);
			}
		}
		init();

		/**
		* This API is used to check the given columnId [selectedColumnId] is in the given column array [columnArray].
		* @param {Array}              columnArray   		The column array in which given column will be checked for existance.
		* @param {String}             selectedColumnId   	The selected column (from column picker) to be checked to the columns array.
		*/
		function hasElement(columnArray, selectedColumnId) {
			return isExists(columnArray, selectedColumnId).exist;
		}
		
		/**
		* This API is used to return the index position of the given columnId [selectedColumnId] in the given column array [columnArray].
		* @param {Array}              columnArray   		The column array in which given column will be checked for existance.
		* @param {String}             selectedColumnId   	The selected column (from column picker) to be checked to the columns array.
		*/
		function indexOf(columnArray, selectedColumnId) {
			return isExists(columnArray, selectedColumnId).index;
		}
		
		/**
		* This API is used to check the given columnId [selectedColumnId] is existed the given column array [columnArray].
		* @param {Array}              columnArray   		The column array in which given column will be checked for existance.
		* @param {String}             selectedColumnId   	The selected column (from column picker) to be checked to the columns array.
		*/
		function isExists (columnArray, selectedColumnId) {
			var has = false, ind=-1;
			$.each(columnArray, function(index, column){
				if(column.id == selectedColumnId){
					has = true;
					ind = index;
					return false;
				}
			});
			return {'exist' : has, 'index' :  ind};
		}
		
		/**
		* This API is used to remove the given columnId [selectedColumnId] from the given column array [columnArray].
		* @param {Array}              columnArray   		The column array from which given column will be removed.
		* @param {String}             selectedColumnId   	The selected column (from column picker) to be removed from the columns array.
		*/
		function removeIfExist(columnArray, selectedColumnId){
			var ind = indexOf(columnArray, selectedColumnId);
			if(ind != -1){
				columnArray.splice(ind,1);
			}
		}
		
		/**
		* This API is used to add the given columnId [selectedColumnId] to the given column array [columnArray].
		* @param {Array}              columnArray   		The column array from which given column will be added.
		* @param {String}             selectedColumnId   	The selected column (from column picker) to be added to the columns array.
		*/
		function putIfAbsent(columnArray, selectedColumnId) {
      var source = arguments[2] || columns;
      var position = source[0].id === 'cnslAct' ? 1 : 0;
			var index = indexOf(columnArray, selectedColumnId);
			if(index == -1){
				var tmpInd = indexOf(source, selectedColumnId);
        for (var i = position ; i < source.length && i < tmpInd; i++ ) {
          if ($menu.find('input[columnId=' + source[i].id +']:checked').size() > 0)
            position++;
        }
				columnArray.splice(position, 0, source[tmpInd]);
			}
		}
	}
	// Slick.Controls.ColumnPicker
	$.extend(true, window, { Slick: { Controls: { ColumnPicker: SlickColumnPicker }}});
})(jQuery);
