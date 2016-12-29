//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
/**
 * xenos-Grid Plugin Definition
 **/ (function ($) {
    /**
     * @param {this}              container   Container node to create the grid in.
     * @param {Array,Object}      data        An array of data objects for databinding.
     * @param {Array}             columns     An array of column definitions.
     * @param {Object}            settings    Grid settings.
     **/
    $.fn.xenoseditablegrid = function (data, columns, settings) {
	
		var xenos$Handler$Editablegrid = xenos$Handler$function({
			get: {
				contentType: 'json',
				requestType: xenos$Handler$default.requestType.asynchronous
			},	
			settings: {
				beforeSend: function(request) {
					request.setRequestHeader('Accept', 'text/html;type=ajax');
				},
				type: 'POST'
			}
		});
		
		var cached = xenos$Cache.get('globalPrefs');
		var evenRowColor,oddRowColor,cxlColorEven,cxlColorOdd;
		if(cached === undefined){
			// for new tab open sometimes cached may not be populated as
			// preference been fetched through ajax call and there is no assurence that 
			// everytime the result will come before loading of this js file
			evenRowColor = '#F9F9F9';
			oddRowColor = '#E5E9ED';
			cxlColorEven = '#ffe0e8';
			cxlColorOdd = '#fcedf1';
		}else{
			evenRowColor = cached.zebraColorEven ? xenos.utils.escapeHtml(cached.zebraColorEven):'#F9F9F9';
			oddRowColor =  cached.zebraColorOdd ? xenos.utils.escapeHtml(cached.zebraColorOdd):'#E5E9ED';
			cxlColorEven = cached.cxlColorEven ? xenos.utils.escapeHtml(cached.cxlColorEven):'#ffe0e8';
			cxlColorOdd = cached.cxlColorOdd ? xenos.utils.escapeHtml(cached.cxlColorOdd):'#fcedf1';
		}
		
		// default settings
		var defaultSettings = {
			rowHeight: 25,
			headerHeight: 50,
			editable: false,
			enableAddRow: false,
			enableCellNavigation: true,
			asyncEditorLoading: false,
			autoEdit: true,
			forceFitColumns : true,
			evenRowColor:evenRowColor,
			oddRowColor:oddRowColor,
			cxlColorEven:cxlColorEven,
			cxlColorOdd:cxlColorOdd,
			resolveBgColor:settings.resolveBgColor,
			sortable:false,
			enableTextSelectionOnCells: true,
			editEnableCallback : function(columnName, dataContext) { return true;},
			editMode : 'none', //Possible values 'none', 'both', 'edit', 'delete'
			editCallback : function(rowIndex, dataContext) {},
			deleteCallback : function(rowIndex, dataContext) {},
			dataItemColumnValueExtractor : function(item, columnDef){
				var isJson = (item.hasOwnProperty('_requestType') && item._requestType ==='JSON');
				var isPreviouslyEscaped = item.hasOwnProperty('_escapedFrom');
				if(isJson && (!isPreviouslyEscaped || (isPreviouslyEscaped && (item['_escapedFrom'] === "JSON")))){
					item['_escapedFrom'] = "JSON";
					return  xenos.utils.escapeHtml(item[columnDef.field]);
				}
				item['_escapedFrom'] = "MARKUP";
				return  xenos.utils.escapeHtml(xenos.utils.evaluateToXml(item[columnDef.field]));
			},
			autoAdjustColumnWidth : !(settings.autoAdjustColumnWidth===false)
		};
		
		settings = jQuery.extend({}, defaultSettings, settings);
		
		var heading = settings.heading || " ";
		
        var pageHeader = '{{if heading}}<div class="xenos-grid-pager">' +
							'<div class="pagerWrap">' +
								'<div class="prevNextarea left">' +
								'<span>'+ heading +'</span>'+
								'</div>' +
							'</div>' +
						'</div>{{/if}}';
		
				
        var dataView = new Slick.Data.DataView(),
			container = this,
			pageTemplate = $.template(null, pageHeader),
			grid = null;
		
		/*
		*Return entire grid data
		*/
		function getGridData(){
			return dataView.getItems();
		}
		
		/*
		*Return no of rows
		*/
		function countGridRows(){
			return dataView.getItems().length;
		}
		
		/*
		* Add or update row in the grid.
		*/
		function addOrUpdateRow(newItem, dataMap){
			newItem._requestType="JSON";
			var isNewRecord = true;
			var rowItem;
			var data = dataView.getItems();
			var rowIndex;
			if(dataMap){
				outer : for(rowIndex in dataView.getItems()){
					var rowItem = data[rowIndex];
					inner : for(var key in dataMap){
						if(rowItem[key] == dataMap[key]){
							isNewRecord = false;
							break outer;
						}
					}
				}
			}
			if(isNewRecord){
				var item = {"id": "xenos_" + (Math.round(Math.random()*10000))};
				$.extend(item,newItem);											
				dataView.addItem(item);
				//grid.focusLastRow();
			} else {
				newItem.id=rowItem.id;
				data[rowIndex] = newItem;
				dataView.setItems([]);
				dataView.setItems(data);
				grid.focusLastRow();
			}
		}
		/*
		* Clear All data in the Data grid
		*/
		function clearGridData(){
			dataView.setItems([]);
		}
		
		function destroy(){
			grid.destroy();
		}
		
       /* function setToolbar() {
			$('.xenos-grid',container.parent()).prepend($.tmpl(pageTemplate,settings));
        } */
		
        function setToolbar() {
			$('.xenos-grid',container.parent()).prepend($.tmpl(pageTemplate,settings));
			resizeViewPort(null);
			$(window).resize(resizeViewPort);
        }
                       
		var resizeViewPort = function(e){
			$('.xenos-grid',container.parent()).height(container.height());
			$('.slick-viewport',container.parent()).height($('.xenos-grid',container.parent()).height()-25);
		};
		
		//////////////////////////////////////////////////////////////////////////////////////////////
        // Initialization

        function init() {
			if(settings.editMode != 'none'){
				var rowEditSelector = new Slick.EditRow();
				var colDef = rowEditSelector.getColumnDefinition();
				colDef.editEnableCallback = settings.editEnableCallback;
				colDef.editMode = settings.editMode;
				columns.splice(0,0,colDef);
			}
			dataView.setItems(data);
			
			//Honroring the getItemMetadata (Helps style particular rows) in case defined
			if (settings.getItemMetadata) {
				dataView.getItemMetadata = settings.getItemMetadata;
			}
			
			grid = new Slick.Grid(container, dataView, columns, settings);
			$(container).data("gridInstance", grid);
			grid.setSelectionModel(new Slick.RowSelectionModel());
			setToolbar();
			if(settings.editMode != 'none'){
				grid.registerPlugin(rowEditSelector);
			}
			grid.registerPlugin(new Slick.AutoTooltips());
			
			grid.focusLastRow	=	function(){
				var lastRow	=	dataView.getItems().length-1;
				if(lastRow != -1){
					var lastRowItem	=	dataView.getItems()[lastRow];
					grid.setActiveCell(dataView.getItems().length-1,0);					
				}
			};
			
			dataView.onRowCountChanged.subscribe(function(e, args) {
				grid.setOptions({enableAddRow: false});
				grid.updateRowCount();
				grid.render();
			});
			
			//Register Grid Events
            grid.onColumnsResized.subscribe(resizeViewPort);
            grid.onColumnsReordered.subscribe(resizeViewPort);
			
			if(settings.editMode == 'none'){
			   emptyColumnCheck();
			}
			
			//grid.focusLastRow();
		}
		
		function emptyColumnCheck(){
			//Avoiding Resize functionality when there is no data.
			if(data.length === 0){
				return;
			}
			var headerColumns = $('.slick-header-column',$(container));
			var flag = [];
			var updateGrid = false;
			for(i=0;i<headerColumns.length;i++){
				flag[i] = true;
				$.each($('.l'+i,$(container)),function(ind,el){
					if($(el).text() != ''){
						flag[i] = false;
						if(grid.getColumns()[i].originalWidth)
							grid.getColumns()[i].width = grid.getColumns()[i].originalWidth;
							
						return false;
					}
				});
				if(flag[i] && grid.getColumns()[i]){
					grid.getColumns()[i].originalWidth = grid.getColumns()[i].width;
					grid.getColumns()[i].width = 30;
					updateGrid = true;
				}
			}
			if(updateGrid){
				grid.setColumns(grid.getColumns(),true);
			}
		}
		
		init();
		
		return {'getData' : getGridData,
		        'countRows' : countGridRows,
				'addOrUpdateRow' : addOrUpdateRow,
				'clearData' : clearGridData,
				'destroy' : destroy,
				'instance':grid};
    }
}(jQuery));