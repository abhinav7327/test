//$Id$
//$Author: dipteshc $
//$Date: 2016-12-27 11:27:16 $

/**
 * xenos-Grid Plugin Definition
 **/ (function ($) {
    /**
     * @param {this}              container   Container node to create the grid in.
     * @param {Array,Object}      data        An array of data objects for databinding.
     * @param {Array}             columns     An array of column definitions.
     * @param {Object}            settings    Grid settings.
     **/
    $.fn.xenosgrid = function (data, columns, settings) {
        /**
         *    Paging in Grid
         **/
        if (settings.enableToolbar) {
            if (typeof settings.pagingInfo.isNext == 'undefined') throw "Please define isNext, to make sure to enable/disable next button";
        }
        //Setting Defaults
        if (settings.emptyColumnCheck !== false) {
            settings.emptyColumnCheck = true;
        } else {
        	settings.emptyColumnCheck = true;
        }
        if(settings.multiHeader && settings.multiHeader==true){
			settings.emptyColumnCheck = false;
		}
        var cmdParam;
        if (settings.isPopUpQuery) {
            //cmdParam = '&commandFormId=' + $('[name=commandFormId]',$(this).closest('#popFormContainer')).val();
            cmdParam = '&commandFormId=' + $('[name=commandFormId]', $(this).last().closest('#popFormContainer')).val();
        } else {
            cmdParam = '&commandFormId=' + $('[name=commandFormId]').val();
        }
        //Done for report generation (If result grid is shown within popup with PDF/XLS enabled)
        if (settings.isNormalResultGridInPopUp) {
            cmdParam = '&screenName=' + settings.screenName + '&commandFormId=' + $('.ui-dialog.topMost [name=commandFormId]').val();
        }

        var dataView = new Slick.Data.DataView(),
            dataId = 0,
            container = this,
            isNext = settings.pagingInfo.isNext,
            isPrevious = (settings.pagingInfo.isPrevious && settings.pagingInfo.isPrevious == true) ? true : false,
            isDialog = settings.isDialog ? true : false,
            isPopUpQuery = settings.isPopUpQuery ? true : false,
            filter = settings.pagingInfo.filter,
            pageNo = settings.pagingInfo.pageNo ? settings.pagingInfo.pageNo : 1,
            prevButton = null,
            nextButton = null,
            prefSaveButton = null,
            prefResetButton = null,
            lock = false,
            host = xenos.context.path,
            urls = settings.urls,
            cmdFormParam = cmdParam,
            pageTemplate = $.template(null, '<div class="xenos-grid-pager"><div class="pagerWrap">{{if !pagingInfo.disable}}<div class="prevNextarea left">{{if !pagingInfo.disablePager}}<span class="prev ' + (isPrevious ? '' : 'disable') + '"></span><span class="left pagenoText">Page</span><span class="pageno left">' + pageNo + '</span>{{if pagingInfo.url}}<div class="pagecounter">of&nbsp;<div class="info"><span class="pager-progress" style="display:block;"></span></div></div>{{/if}}<span class="next ' + (isNext ? '' : 'disable') + '"></span><div style="width:16px;height:16px;float:left;"><span class="igv-grid-progress"></span></div>{{/if}}{{if pagingInfo.url}}<div class="recordcounter">&nbsp;Records:&nbsp;<div class="info"><span class="pager-progress" style="display:block;"></span></div></div>{{/if}}{{if pagingInfo.refresh}}<span class="refresh"></span>{{/if}}</div>{{/if}}<div class="btnsArea right">{{if buttons.print}}<div class="left marginRight"><a title="Print" class="printBtn paddingLeft"></a></div>{{/if}}{{if buttons.pdf}}<div class="left marginRight"><a  title="PDF" class="pdfBtn"></a></div>{{/if}}{{if buttons.xls}}<div class="left marginRight"><a title="XLS(All Fields)" class="excelBtn"></a></div>{{/if}}{{if buttons.xlsPref}}<div class="left marginRight"><a title="XLS(Xls Report Prefs Fields)" class="excelBtnCurrent paddingLeft"></a></div><div class="left separater marginRight"></div><div class="left marginRight"><a title="Save Xls Report Prefs" class="xlsColumnPicker save-excel-report-prefs-btn"></a></div><div class="left marginRight"><a title="Clear Xls Report Prefs" class="resetXlsReportPref clear-excel-report-prefs-btn"></a></div>{{/if}}{{if buttons.save}}<div class="left separater marginRight"></div><div class="left marginRight"><a title="Save" class="save-btn saveBtn disable"></a></div>{{/if}} <div class="left marginRight"><a title="Reset Preference" class="queryColumnsReset clear-excel-report-prefs-btn"></a></div>{{if buttons.columnPicker}}<div class="left separater marginRight"></div><div class="left marginRight queryColmTop"><a title="Columns" class="queryColumns paddingLeft"></a></div>{{/if}}</div></div></div>'),

            screenId = ($.trim(settings.screenId) !== null && $.trim(settings.screenId) !== '') ? settings.screenId : $('[name=screenId]').val(),
            versionNo = $('[name=versionNo]').val(),
            ajaxType = 'POST',
            yOffset = settings.yOffset ? settings.yOffset : 0,
            allowIdGeneration = ( settings.allowIdGeneration || settings.allowIdGeneration == undefined) ? true : false,
            headerHeight = settings.headerHeight ? settings.headerHeight : 50,
            enableHeader = settings.enableHeader ? true : false,
            headerText = (settings.headerInfo && settings.headerInfo.headerText) ? settings.headerInfo.headerText : "",
			displayAlwaysColumnIdArray = (settings.displayAlwaysColumnIdArray) ? settings.displayAlwaysColumnIdArray : [],
			defaultInvisibleColumns = settings.defaultInvisibleColumns || [],
            checkboxSelector,
            isJson = false,
            columnPickerObj,
            containerId = 'xenosgrid-' + ++xenos.utils.gridCounter;
            container = container.last();
			defaultColsWidth = {};
	    
		checkConsolidationActionEnabled(data);
		var oringinalForceFitColumns = settings.forceFitColumns ? settings.forceFitColumns : false;
		var originalDefaultColumns = defaultInvisibleColumns;
        container.attr("id", containerId);
        var containerSelector = '#' + containerId;

        var heightOfHeaderAndFooter = function (container, pop) {
            var $header = pop ? $('.popResultGridHeader', container) : $('.resultGridHeader', container);
            var $footer = pop ? $('.popResultGridFooter', container) : $('.resultGridFooter', container);
            var height = $header.outerHeight(true) + $footer.outerHeight(true);
            return height == 0 ? 0 : height + 8;
        };

        if (settings.isPopUpQuery) {
            var gridHeight = settings.height ? settings.height : $(container).closest('.ui-dialog').height() - heightOfHeaderAndFooter(container, true) - 4;
            var gridWidth = settings.width ? settings.width : '100%';
        }
        else {
            var gridHeight = settings.height ? settings.height : $('#content').height() - 60 - heightOfHeaderAndFooter('#content');
            var gridWidth = settings.width ? settings.width : '100%';
        }

        function generateId(records) {
            for (i in records) {
                records[i].id = dataId++;
            }
            return records;
        }

        function saveHandler(save) {
            if (save) {
                // save
                saveResultPreference();
            }
        }

		function enableResetPref() {
			if(prefResetButton) {
				prefResetButton.removeClass('disable');
			}
		}
		
		function disableResetPref() {
			if(prefResetButton) {
				prefResetButton.addClass('disable');
			}
		}
		
        function enableSave(grid) {
            if (grid) {
                var options = grid.getOptions();
                if (options.isPopUpQuery || options.isDialog || options.isTemp || !(options.buttons && options.buttons.save)) {
                    return;
                }
                if (prefSaveButton) {
                    prefSaveButton.removeClass('disable');
                }
                if (settings.saverTarget) {
                    jQuery(settings.saverTarget).saverOn(saveHandler);
                } else {
                    jQuery('#content').saverOn(saveHandler);
                }
            }
        }

        function disableSave() {
            if (prefSaveButton) {
                prefSaveButton.addClass('disable');
            }
            if (settings.saverTarget) {
                jQuery(settings.saverTarget).saverOff(saveHandler);
            } else {
                jQuery('#content').saverOff(saveHandler);
            }
        }

        //Adding Prefs Urls to the url Object
        urls.savePref = '/secure/ref/personalized/user/screenconfig/resultscreen/save.json?'
        urls.loadPref = '/secure/ref/personalized/user/screenconfig/resultscreen/load/' + screenId + '/' + versionNo + '.json?';
        urls.enterprisePref = '/secure/ref/personalized/enterprise/screenconfig/resultscreen/load/' + screenId + '/' + versionNo + '.json?';
        //Modifying urls to embed the form id.
        for (var i in urls) {
            urls[i] = host + urls[i] + cmdFormParam;
        }

        //Updating the next and previous buttons after every page change.
        function updatePager() {
            if (isNext) {
                nextButton.removeClass('disable');
            } else {
                nextButton.addClass('disable');
            }
            if (isPrevious) {
                prevButton.removeClass('disable');
            } else {
                prevButton.addClass('disable');
            }
            //Setting the Page Number
            if (prevButton.siblings('.pageno').length == 1) {
                prevButton.siblings('.pageno').html(pageNo);
            } else if (nextButton.siblings('.pageno').length == 1) {
                nextButton.siblings('.pageno').html(pageNo);
            }
        }

        var onSortHandler = function (e, args) {
            var sortCol, sortDir, comparer = function (a, b) {
                    var x = a[sortcol] || "",
                        y = b[sortcol] || "";
                    return (x == y ? 0 : (x > y ? 1 : -1));
                },
                numberComparer = function (a, b) {
                     var x = 0, y = 0;
                    
                    // Enable to see the difference in data-type of the same variable on pagination
                    // console.log(typeof a[sortcol]);
                    // console.log(typeof b[sortcol]);
                    
                    if(typeof a[sortcol] === 'string'){
                      x = parseFloat(a[sortcol].replace(/,/g, '')||0);
                    } else if(typeof a[sortcol] === 'number') {
                      x = parseFloat(a[sortcol]||0);
                    }
                    
                    if(typeof b[sortcol] === 'string'){
                      y = parseFloat(b[sortcol].replace(/,/g, '')||0);
                    } else if(typeof b[sortcol] === 'number') {
                      y = parseFloat(b[sortcol]||0);
                    }
                    
                    return (x == y ? 0 : (x > y ? 1 : -1));
                },
                filtedEmptyStringComparer = function (a, b) {

                };
            sortdir = args.sortAsc ? 1 : -1;
            sortcol = args.sortCol.field;
            // using native sort with comparer
            // preferred method but can be very slow in IE with huge datasets

            if (args.sortCol.cssClass == "xenos-grid-number") {
                dataView.sort(numberComparer, args.sortAsc);
            } else {
                dataView.sort(comparer, args.sortAsc);
            }
            
            $('#' + containerId).data('sortArgs', args);

        };
        
        function autoGridSorter() {
            var args = $('#' + containerId).data('sortArgs') || false;
            if(args) {
                var colId = args.sortCol.id;
                grid.setSortColumn(colId, args.sortAsc);
                dataView.reSort();
            }
        }

        var onRowsChangedHandler = function (e, args) {
            grid.invalidateRows(args.rows);
            grid.render();
        };
        //Defining Sorters for Grid.
        function gridSorter(grid, dataView) {
            grid.onSort.subscribe(onSortHandler);
            dataView.onRowsChanged.subscribe(onRowsChangedHandler);
        }

        //Open Report
        function openReport(ev) {
        	var menuPk = $('div#footer>div#xenos-cache-container>span#cache').data('menuPk');
			var url = ev.data.url + '&menuPk=' + menuPk;
			xenos$Handler$default.generic(undefined, {
                requestUri:url,
                requestType: xenos$Handler$default.requestType.synchronous,
				target: '_blank',
                settings: {type: ajaxType},
                contentType: xenos$Handler$default.contentType.json,
                onJsonContent: function (e, options, $target, content) {
                    //Do nothing
                }
            });
			/*$.fileDownload(url, {
					successCallback: function(url) {		 
					  // NO OPERATION
					},
					failCallback: function(responseHtml, url) {
						if($(responseHtml).find('#login').html() != null) {
							xenos.context.handleSessionOut('','',{sessionOutFlag: true});
							return false;
						}
						if($(responseHtml).find(".uncaughtExceptionTxt").html() != null){ 
						    // For Jasper report  
							xenos.postNotice(xenos.notice.type.warning, xenos.i18n.message.reuest_timeout , true , 5000);
						}else if($(responseHtml).find("u").html()=="Error in generating report"){
							xenos.postNotice(xenos.notice.type.error, xenos.i18n.error.report_generation , true , 5000);
						}else{ // For Report generated using Repro  
							var errorMessages = $(responseHtml).html();
							if(errorMessages == null){
								xenos.postNotice(xenos.notice.type.error, xenos.i18n.error.generic , true , 5000);
							}else if(errorMessages.length == 0) {
								xenos.postNotice(xenos.notice.type.error, xenos.i18n.error.generic , true , 5000);
							}else {
								xenos.postNotice(xenos.notice.type.warning, xenos.i18n.message.reuest_timeout , true , 5000);
							}
						}
					}
				});*/
				return false;
        }


        function ajaxErorHandling(xhr, textStatus, errorThrown) {
            if (xhr.status == 404) throw "xenos Grid expecting a valid Url"
            if (textStatus == 'timeout') throw "Server not responding"
            $('.xenos-grid-progress').hide();
            lock = false;
        }


        function continueUpdate(data){
			isJson = true;
            if(allowIdGeneration){
                dataView.setItems(generateId(data.value));
            } else {
                dataView.setItems(data.value);
            }
            isNext = data.isNext;
            isPrevious = data.isPrevious;
            //Clear Selections in case Selection Model Exist.
            if (grid.getSelectionModel())
                grid.setSelectedRows([]);

            grid.resizeCanvas();
        }

        function updateData(data) {
			checkConsolidationActionEnabled(data.value);
            if (settings.events && settings.events.onDataUpdate) {
                settings.events.onDataUpdate(data, continueUpdate);
            } else {
                continueUpdate(data);
            }
        }

        //Function to handle warning message in grid
        function checkEndReached(allData) {
            if (allData.isTruncated) {
                var markup = ''
                    + '<div class="xenosErrormsg">'
                    + '    <div id="xenosErrormsgClose"></div>'
                    + '    <div class="xenosErrorBoxBg">'
                    + '        <div class="left errorIcon"></div>'
                    + '        <div class="content">'
                    + '            <ul>'
                    + '                <li>' + xenos.title.truncateMessage + '</li>'
                    + '            </ul>'
                    + '        </div>'
                    + '    </div>'
                    + '    <div class="btmShadow"></div>'
                    + '</div>';

                var div = container.closest('.formContent').prepend(markup);
            } else {
                return;
            }
        }
		
		//It prompts the user about selected records before pagination
        function navigationHandler(ev){    
            if(!($(ev.target).hasClass("disable")) && grid.getSelectionModel() && grid.getSelectedRows() && grid.getSelectedRows().length > 0){
                jConfirm(xenos.i18n.message.selection_discard, null, function(confirm) {
                    if(!confirm) {
                        return false;
                    }
                    else{
                    	grid.setSelectedRows([]);
                        ev.data.navigateFunc();
                        
                    }
                });
            }
            else{
                ev.data.navigateFunc();
            }  
        }
		
		function refreshPage(evt) {
			var url = container.closest('#queryResultForm').attr('action');
			if($.trim(url) != "" && !lock){
				lock = true;
				url = url.slice(1,url.lastIndexOf('/'));
				$(evt.target).addClass('disable');
				xenos$Handler$default.generic(undefined, {
                    requestUri: [[xenos.context.path,url,'result.json?fetch=refresh'].join('/'),cmdFormParam].join(''),
                    requestType: xenos$Handler$default.requestType.asynchronous,
                    contentType: xenos$Handler$default.contentType.json,
					settings: {type: ajaxType},
					target: '#content',
                    onJsonContent: function (e, options, $target, content) {
                       updateData(content);
					   if (settings.emptyColumnCheck) {
                            emptyColumnCheck();
                        }
						lock = false;
						autoGridSorter();
						$(evt.target).removeClass('disable');
                    }
                });
			}
		}
		
		
        function nextPage() {
            if (isNext && !lock) {
                lock = true;
                $('body').xenosloader({});
                xenos$Handler$default.generic(undefined, {
                    requestUri: urls.nextPage,
                    requestType: xenos$Handler$default.requestType.asynchronous,
                    contentType: xenos$Handler$default.contentType.json,
                    settings: {
                        type: ajaxType,
                        data: {pageNo: pageNo}
                    },
                    onJsonContent: function (e, options, $target, content) {
                        checkEndReached(content);
                        updateData(content);
                        pageNo = content.pageNo;
                        updatePager();
                        $('body').find('.detail-loader').remove();
                        lock = false;
                        autoGridSorter();
                        if (settings.emptyColumnCheck) {
                            emptyColumnCheck();
                        }
                    }
                });
            }
        }

        function prevPage() {
            if (isPrevious && !lock) {
                lock = true;
                $('body').xenosloader({});
                xenos$Handler$default.generic(undefined, {
                    requestUri: urls.prevPage,
                    requestType: xenos$Handler$default.requestType.asynchronous,
                    contentType: xenos$Handler$default.contentType.json,
                    settings: {
                        type: ajaxType,
                        data: {pageNo: pageNo}
                    },
                    onJsonContent: function (e, options, $target, content) {
                        updateData(content);
                        pageNo = content.pageNo;
                        updatePager();
                        $('body').find('.detail-loader').remove();
                        lock = false;
                        autoGridSorter();
                        if (settings.emptyColumnCheck) {
                            emptyColumnCheck();
                        }
                    }
                });
            }
        }
        
        function resetResultPreference(e) {
			if (prefResetButton) {
                if (prefResetButton.hasClass('disable')) {
                    return;
                }
            }
        	var url = xenos.context.path + '/secure/ref/personalized/user/screenconfig/resultscreen/reset.json';
        	jConfirm(xenos.i18n.message.reset_your_preference, null, function(confirm) {
        		if(confirm) {
        			xenos.utils.removePreference(url, screenId, versionNo, function(data, textStatus,  jqXHR) {
        				if(!data.success) {
        					xenos.postNotice('error',xenos.i18n.message.preference_reset_error);
        					return;
        				} else {
							grid.setOptions({forceFitColumns: oringinalForceFitColumns});
                            grid.setOptions({syncColumnCellResize: false});
							var colsToShow = [];	
								for( var column in columns ) {
								  if (originalDefaultColumns.indexOf(columns[column].id) == -1) {
										columns[column].width = defaultColsWidth[columns[column].id];
										colsToShow.push(columns[column]);
								  }
									
								}
							grid.setColumns(colsToShow);
							//restoreOriginalWidth();
        					//displayGrid();
							disableSave();
							disableResetPref();
        					xenos.postNotice('success', xenos.i18n.message.preference_reset_message);
        				}
        			});
        		}
        	});
        }

        function saveResultPreference(e) {
            if (prefSaveButton) {
                if (prefSaveButton.hasClass('disable')) {
                    return;
                }
            }
            var columns = grid.getColumns();
            var pref = [],
                data = {};
            for (var i in columns) {
                //Ignoring Checkbox column fields
				columns[i].actualWidth = defaultColsWidth[columns[i].id];
				if (!(columns[i].id == '_checkbox_selector')) {
                    pref.push(columns[i]);
                }
            }
            data.pref = pref;
            data.forceFitColumns = grid.getOptions().forceFitColumns;
            data.syncColumnCellResize = grid.getOptions().syncColumnCellResize;
            xenos.utils.saveResultPreference(data, urls.savePref, screenId, versionNo, function (data, textStatus,  jqXHR) {
				if(!data.success){
					xenos.postNotice(xenos.notice.type.error,data.value);
					return;
				}
                xenos.postNotice(xenos.notice.type.success, xenos.i18n.message.preference_save_message);
                disableSave();
				enableResetPref();
            });
        }

        function getColumnById(id) {
            for (var i in columns) {
                if (columns[i].id === id) {
                    return columns[i];
                    break;
                }
            }
        }

        function setToolbar(settings) {
            if (!settings.buttons) {
                settings.buttons = {};
            }
            /*
             * Since print functionality on result summary page is not working in GC,
             * it is decided to remove the print icon from the result summary page. This
             * could be done by changing all query result summary page. To make this change
             * centrally we have forcefully set the value here as false.
             */
            settings.buttons['print'] = false;
            container.prepend($.tmpl(pageTemplate, settings));
            //hide the preference reset icon in case of detail window
            $(container).parents('.topMost').find('.detailCont').find('.queryColumnsReset').css('display','none');
            //hide the preference reset icon for popup result grid
			$(container).parents('.topMost #popUpQueryResultForm').find('.pop-xenos-grid').find('.queryColumnsReset').css('display','none');

            //Binding Listeners to the Previous and Next Button
            nextButton = $('.next', containerSelector).bind('click.' + containerId, {navigateFunc: nextPage}, navigationHandler);
            prevButton = $('.prev', containerSelector).bind('click.' + containerId, {navigateFunc: prevPage}, navigationHandler);
            $('.pdfBtn', container).bind('click.' + containerId, {url: urls.pdfReport}, openReport);
            $('.pdfBtnCurrent', container).bind('click.' + containerId, {url: urls.pdfCurrent}, openReport);
            $('.excelBtn', container).bind('click.' + containerId, {url: urls.xlsReport}, openReport);
            $('.excelBtnCurrent', container).bind('click.' + containerId, {url: urls.xlsCurrent}, openReport);
            prefSaveButton = $('.save-btn', containerSelector).live('click.' + containerId, {grid: grid}, saveResultPreference);
            prefResetButton = $('.queryColumnsReset', containerSelector).live('click.' + containerId, resetResultPreference);
			container.find('.refresh').bind(['click.',containerId].join('') , refreshPage);

            //Reading page counter
            if (settings.pagingInfo.url) {
				if(!settings.backActionFlag){
                xenos$Handler$default.generic(undefined, {
                    requestUri: xenos.context.path + '/' + settings.pagingInfo.url + '?' + cmdFormParam.substring(1) + "&menuPk=" + $('#queryResultForm').find('#menuPk').val(),
                    requestType: xenos$Handler$default.requestType.asynchronous,
                    settings: {type: ajaxType},
                    contentType: xenos$Handler$default.contentType.json,
                    onJsonContent: function (e, options, $target, content) {
                        $('.pagecounter .info', containerSelector).html(content.modelMap.totalPageNo || 1);
                        $('.recordcounter .info', containerSelector).html(content.modelMap.count);
                    }
                });
				}
				else{
			    		/* Preventing the call to count.json for back operation & setting the 
			    		totalPageNo and totalCount from the preserved values passed through settings.pagingInfo object */ 
				    	$('.pagecounter .info', containerSelector).html(settings.pagingInfo.totalPageNo || 1);
						$('.recordcounter .info', containerSelector).html(settings.pagingInfo.totalCount);	
			    }
				
            }
			
        }

        //Setting the width and height of the grid
        container.height(gridHeight - yOffset);
        container.width(gridWidth);
        var id = undefined;

        var _windowResizeHandler = function (evt) {
            function _func() {
                $('.xenos-grid-pager', container).click();
                var grid = container.data("gridInstance");
                if (grid) {
                    grid.resizeCanvas();
                    if (grid.getOptions().forceFitColumns) {
                        grid.autosizeColumns();
                    }
                    grid.setColumns(grid.getColumns(), true);
                }
            }

            clearTimeout(id);
            id = setTimeout(_func, 200);
        }

        var _dialogResizeHandler = function (evt) {
            var _funcD = function () {
                if (settings.resizeHandler) {
                    settings.resizeHandler(container, grid);
                } else {
                    var innerContainerHeight = container.closest('.ui-dialog').height() - yOffset - heightOfHeaderAndFooter(container, true);
                    container.height(innerContainerHeight);
                    $(".slick-viewport", container).height(innerContainerHeight - 50);

                    if (grid.getOptions().forceFitColumns) {
                        forceFitGrid();
                    } else {
                        grid.resizeCanvas();
                    }
                }
                if (grid) {
                    grid.setColumns(grid.getColumns(), true);
                }
            }
            clearTimeout(id);
            id = setTimeout(_funcD, 200);
        }

        //Resize Handling
        if (isDialog || isPopUpQuery) {
            $(this).closest(".ui-dialog").bind("resize." + containerId, _dialogResizeHandler);
        } else {
            $(window).bind('resize.' + containerId, _windowResizeHandler);
        }

        var cached = xenos$Cache.get('globalPrefs');
        var evenRowColor = cached.zebraColorEven ? xenos.utils.escapeHtml(cached.zebraColorEven) : '#F9F9F9';
        var oddRowColor = cached.zebraColorOdd ? xenos.utils.escapeHtml(cached.zebraColorOdd) : '#E5E9ED';
        var cxlColorEven = cached.cxlColorEven ? xenos.utils.escapeHtml(cached.cxlColorEven) : '#ffe0e8';
        var cxlColorOdd = cached.cxlColorOdd ? xenos.utils.escapeHtml(cached.cxlColorOdd) : '#fcedf1';
        var failColorEven = cached.failColorEven ? xenos.utils.escapeHtml(cached.failColorEven) : '#ffe0e8';
        var failColorOdd = cached.failColorOdd ? xenos.utils.escapeHtml(cached.failColorOdd) : '#fcedf1';

        //Grid Options
        var options = {
            enableCellNavigation: true,
            rowHeight: 23,
            enableTextSelectionOnCells: true,
            headerHeight: headerHeight,
            ckBoxInFirstPos: settings.consolidateActionFlag,
            isPopUpQuery: settings.isPopUpQuery,
            evenRowColor: evenRowColor,
            oddRowColor: oddRowColor,
            cxlColorEven: cxlColorEven,
            cxlColorOdd: cxlColorOdd,
            failColorEven: failColorEven,
            failColorOdd: failColorOdd,
			resolveBgColor:settings.resolveBgColor,
            syncColumnCellResize: false,
            forceFitColumns: settings.forceFitColumns ? settings.forceFitColumns : false,
            rowHeight: settings.rowHeight || 23,
            editable: settings.editable || false,
            enableColumnReorder: (settings.enableColumnReorder == undefined || settings.enableColumnReorder == true) ? true : false,
            isDialog: settings.isDialog,
            isTemp: settings.isTemp,
            buttons: settings.buttons,
            saveEnableCallback: enableSave,
            forceFitGrid: forceFitGrid,
            hasMasterHeader: settings.hasMasterHeader,
            isSelectorRequired: settings.isSelectorRequired === undefined ? true : settings.isSelectorRequired,
            isHeaderColumnRequired: settings.isHeaderColumnRequired === undefined ? true : settings.isHeaderColumnRequired,
			containerId: containerId,
            dataItemColumnValueExtractor: settings.hasOwnProperty('dataItemColumnValueExtractor')?  settings.dataItemColumnValueExtractor : function (item, columnDef) {
                var isPreviouslyEscaped = item.hasOwnProperty('_escapedFrom');
                if (isJson && (!isPreviouslyEscaped || (isPreviouslyEscaped && (item['_escapedFrom'] === "JSON")))) {
                    item['_escapedFrom'] = "JSON";
                    return  xenos.utils.escapeHtml(item[columnDef.field]);
                }
                item['_escapedFrom'] = "MARKUP";
                return  xenos.utils.escapeHtml(xenos.utils.evaluateToXml(item[columnDef.field]));
            },
			autoAdjustColumnWidth : !(settings.autoAdjustColumnWidth===false),
          defaultInvisibleColumns: function() {
              return defaultInvisibleColumns;
          }
        };


        //Handle consolidate flag. If consolidation flag is undefined or false then there should be no consolidation action, otherwise consolidation should be enable
        //Handle consolidate flag. If consolidation flag is undefined or false then there should be no consolidation action, otherwise consolidation should be enable
        if (settings.consolidateActionFlag) {
            //Check first column. If consolidation is enable, first column should be consolidation column.
            if (settings.consolidateAttribute && settings.consolidateAttribute.type === 'check') {
                if (data.length > 0) {
					var checkBoxOptions = {
						headerName 				 : settings.consolidateAttribute.headerName,  //To be passed from the individual page
						toolTip    				 : settings.consolidateAttribute.toolTip, //To be passed from the individual page
						width       			 : settings.consolidateAttribute.width, //To be passed from the individual page
						excludeHeaderCheckBox 	 : settings.consolidateAttribute.excludeHeaderCheckBox ? true : false, //default is false else if defined at page level then set to true
						cssClass				 : "slick-cell-checkboxsel"
					};
					if(settings.consolidateAttribute.checkBoxOptions != undefined){
						checkBoxOptions = $.extend(settings.consolidateAttribute.checkBoxOptions,checkBoxOptions);
					}
                    checkboxSelector = new Slick.CheckboxSelectColumn(checkBoxOptions);
                    columns.unshift(checkboxSelector.getColumnDefinition());
                }  
            }
			else if (settings.consolidateAttribute && settings.consolidateAttribute.type === 'radio') {
                    if (data.length > 0) {
    					var checkBoxOptions = {
    						headerName 				 : settings.consolidateAttribute.headerName,  //To be passed from the individual page
    						toolTip    				 : settings.consolidateAttribute.toolTip, //To be passed from the individual page
    						width       			 : settings.consolidateAttribute.width, //To be passed from the individual page
    						excludeHeaderCheckBox 	 : settings.consolidateAttribute.excludeHeaderCheckBox ? true : false, //default is false else if defined at page level then set to true
    						cssClass				 : "slick-cell-checkboxsel"
    					};
    					if(settings.consolidateAttribute.checkBoxOptions != undefined){
    						checkBoxOptions = $.extend(settings.consolidateAttribute.checkBoxOptions,checkBoxOptions);
    					}
                        checkboxSelector = new Slick.RadioSelectColumn(checkBoxOptions);
                        columns.unshift(checkboxSelector.getColumnDefinition());
                    }
                }  
			else if (settings.consolidateAttribute && settings.consolidateAttribute.type === 'groupCheck') {
                if (data.length > 0) {
                    checkboxSelector = new Slick.CheckboxGroupSelectColumn({
                        cssClass: "slick-cell-checkboxsel"
                    });
                    columns.unshift(checkboxSelector.getColumnDefinition());
                }
            } else {
                var columnDefObj = $.extend({name: "", field: "cnslAct", id: "cnslAct", width: 30, formatter: Slick.Formatters.ConsolidateActFormater,excludeFromColumnPicker:true}, settings.consolidateAttribute);
                columns.unshift(columnDefObj);
            }
        }
        if (allowIdGeneration) {
            dataView.setItems(generateId(data));
        } else {
            dataView.setItems(data);
        }


        if (filter) {
            dataView.setFilter(filter);
        }

        //Honroring the getItemMetadata (Helps style particular rows) in case defined
        if (settings.getItemMetadata) {
            dataView.getItemMetadata = settings.getItemMetadata;
        }

        //Defining and Rendering the Grid
        var grid = new Slick.Grid(container, dataView, columns, options);

        //Set Selection Model and Register Plugin, in case select/select All column is required.
        if (settings.consolidateActionFlag && settings.consolidateAttribute && settings.consolidateAttribute.type === 'check') {
            grid.setSelectionModel(new Slick.RowSelectionModel({selectActiveRow: false}));
            if (data.length > 0) {
                grid.registerPlugin(checkboxSelector);
            }
        }
		else if (settings.consolidateActionFlag && settings.consolidateAttribute && settings.consolidateAttribute.type === 'radio') {
            grid.setSelectionModel(new Slick.RowSelectionModel({selectActiveRow: false}));
            if (data.length > 0) {
                grid.registerPlugin(checkboxSelector);
                }
            }
		else if (settings.consolidateActionFlag && settings.consolidateAttribute && settings.consolidateAttribute.type === 'groupCheck') {
            grid.setSelectionModel(new Slick.RowSelectionModel({selectActiveRow: false}));
            if (data.length > 0) {
                grid.registerPlugin(checkboxSelector);
            }
        }

        grid.registerPlugin(new Slick.AutoTooltips());
		//no records check, when no column present in header then viewPort will be 'slick-viewport' for showing 
        //"No Record Found" text at center
        function noRecordCheck() {
			var viewPort = '.grid-canvas';
            if (data.length === 0) {
				if(!grid.getOptions().isHeaderColumnRequired){
					viewPort = '.slick-viewport';
				}
				$(viewPort, $(container)).html('<div class="noRecord">' + xenos.i18n.message.no_record_found_message + '</div>');
            }
        }

        //Forcefit grid
        function forceFitGrid() {
            grid.resizeCanvas();
            grid.autosizeColumns();

            /*  Fix for IE 8
             *   Issue: Headers get messed up on AutoFit
             */
            if (grid.getOptions().forceFitColumns && $.browser.msie) {
                grid.setColumns(grid.getColumns(), true);
            }
        }

        //Incase of dialog if data is not present then columns are force-fitted inorder to make "No Records Found" message fully visible to the user.
        if (data.length === 0 && isDialog) {
            forceFitGrid();
        }

        //Check and Resize empty columns
        function emptyColumnCheck() {
			var data = grid.getData().getItems() || [];
            //Avoiding Resize functionality when there is no data.
            if (data.length === 0) {
                return;
            }
            var headerColumns = $('.slick-header-column', $(container));
            var flag = [];
            var updateGrid = false;
            for (i = 0; i < headerColumns.length; i++) {
            	if(grid.getColumns()[i].hasOwnProperty('editor')){
					continue;
				}
                flag[i] = true;
				for(j = 0; j < data.length; j++){
					if($.trim(data[j][grid.getColumns()[i].field])){
						flag[i] = false;
                        if (grid.getColumns()[i].originalWidth)
                            grid.getColumns()[i].width = grid.getColumns()[i].originalWidth;
                        break;
					}
				}
                if (flag[i] && grid.getColumns()[i]) {
                    grid.getColumns()[i].originalWidth = grid.getColumns()[i].width;
                    // grid.getColumns()[i].width = 40;
                    updateGrid = true;
                }
            }
            if (updateGrid) {
                grid.setColumns(grid.getColumns(), true);
            }
        }

        var onColumnsReorderedHandler = function (e, args) {
            if (args.forceCall) {
                return;
            } else {
                enableSave(args.grid);
            }
        }
		
		 function evaluateOriginalWidth() {
			$.each(grid.getColumns(), function(colIndex,col) {
				defaultColsWidth[col.id] = col.width;
             });
         } 
		
		/* var restoreOriginalWidth = function() {
			$.each(grid.getColumns(), function(colIndex,col) {
				console.log('Original width===' + col.originalWidth);
				col.width = col.originalwidth;
             });
		} */
         
		
		  var onColumnsDragHandler = function (e, args) {
            if (args.forceCall) {
                return;
            } else {
                enableSave(args.grid);
            }
        }
        
        function displayHeader(){
            $(container).prev().html(headerText);    
            $(container).prev().attr('style', 'margin:0px;').show();
        }
         /**
          * Check if consolidated Action is enabled
          */ 
         function checkConsolidationActionEnabled(data) {
			$.each(data,function(index,row) {
				if(settings.consolidationActionCallback !== undefined){
                     row.isConsEnabled = settings.consolidationActionCallback(row);
                 }	
             });

         }
        //Display Grid
        function displayGrid() {
            if (settings.emptyColumnCheck) {
                emptyColumnCheck();
            }
			
			//Display the header if present
            if(enableHeader){
                displayHeader();
            }
            
            //No Records Check
            noRecordCheck();

            //Displaying the Grid
            $(container).show();

            //Forcefit Grid.
            if (settings.forceFitColumns) {
                forceFitGrid();
            }

            var $cache = $('div#footer>div#xenos-cache-container>span#cache');
			$cache.data('menuPk',$('#queryResultForm').find('#menuPk').val());
            //Subscribe events on Grid
            grid.onColumnsReordered.subscribe(onColumnsReorderedHandler);
			
            grid.onColumnsResized.subscribe(onColumnsDragHandler);

			//After Grid rendering this callback API will be called to add some more activities on Grid
			if(jQuery.isFunction(settings.afterRenderComplete)){
				settings.afterRenderComplete(grid, container.closest('.formContent'));
			}
        }
        
        function setDefaultColumns() {
        	if(!settings.multiHeader || settings.multiHeader===false){
				var colsToShow = [];	
				for( var column in columns ) {
				  if (defaultInvisibleColumns.indexOf(columns[column].id) == -1)
					colsToShow.push(columns[column]);
				}
				grid.setColumns(colsToShow);
			}
        }

        //Render Toolbar with options if enabled
        if (settings.enableToolbar) {
            setToolbar(settings);
        }

        //Initializing the Grid Sorter
        gridSorter(grid, dataView);

        //Initializing the Column Picker
        if (settings.buttons && settings.buttons.columnPicker) {
            columnPickerObj = new Slick.Controls.ColumnPicker(columns, grid, options);
        }

	$(container).data("gridInstance", grid);
	
        var onClickHandler = function (e, args) {
            //cellName maybe required later
	    /*TODO: Cleanup Unnecessary code for CAM, which is not used anymore*/
            var cellName = grid.getColumns()[grid.getCellFromEvent(e).cell].name;
            if ($(e.target).is(".toggle")) {
                var callback = settings.onClickCallbackHandler;
                if (callback && $.isFunction(callback)) {
                    var item = dataView.getItem(args.row);
                    callback(e, item, function (itms) {
                        for (var i = 0; i < itms.length; i++) {
                            dataView.insertItem(dataView.getIdxById(item.id) + 1 + i, itms[i]);
                        }
                        dataView.refresh();
                        grid.invalidate();
                    });
                    e.stopImmediatePropagation();
                }
            }

            var $checkBox = $(e.target).find('input[type=checkbox]');
            if ($checkBox.length > 0) {
                if ($checkBox.is(":checked")) {
                    $checkBox.removeAttr('checked');
                } else {
                    $checkBox.attr('checked', 'checked');
                }
                $checkBox.trigger('click');
            }
        }

        grid.onClick.subscribe(onClickHandler);

        var onHeaderClickHandler = function (e, args) {
            var $checkBox = $(e.target).find('input[type=checkbox]');
            if ($checkBox.length > 0) {
                if ($checkBox.is(":checked")) {
                    $checkBox.removeAttr('checked');
                } else {
                    $checkBox.attr('checked', 'checked');
                }
                $checkBox.trigger('click');
            }
        }
        grid.onHeaderClick.subscribe(onHeaderClickHandler);

        var onMouseEnterHandler = function (e, args) {
            // get the cell form event [cell where the mouse pointer enteres]
            var cell = grid.getCellFromEvent(e);
            if (cell) {
                var node = grid.getCellNode(cell.row, cell.cell);
                // invoke while selecting innerHTML of an editable text cell
                $(node).find("[type='text']").select(function (e1, args1) {
                    // get the id of selected cell
                    var cellId = grid.getColumns()[grid.getCellFromEvent(e).cell].id;
                    $(node).find("[type='text']").bind("keydown.nav", function (e2) {
                        // Check the delete key pressed
                        if (e2.keyCode == 46) {
                            // get the row object
                            var rowData = grid.getDataItem(cell.row);
                            // clear the cell value with the selected cell Id
                            rowData[cellId] = "";
                            e2.stopImmediatePropagation();
                        }
                    });
                    e1.stopImmediatePropagation();
                });
            }
        }

        // xenosCD-1611
        // This API improve delete operation in any editable text field of xenos-grid
        grid.onMouseEnter.subscribe(onMouseEnterHandler);

        var onRowCountChangedHandler = function (e, args) {
            grid.updateRowCount();
            grid.render();
        };

		      // Handler for column re-ordering in result
        var onResultColumnsReordered = function(e, args){
            if(args.forceCall){
                return;
            } else {
                var grid = args.grid;
                var columns = grid.getColumns();
                var reOrderedColumns = [];
                for(var i in columns){
                    var column = columns[i];
                    if($.trim(column.name).length == 0){
                        reOrderedColumns.splice(0, 0, column);
                    } else {
                        reOrderedColumns.push(column);
                    } 
                }
                grid.setColumns(reOrderedColumns, true);
            }
        };
        var onRowsChangedHandler = function (e, args) {
            grid.invalidateRows(args.rows);
            grid.render();
        }
        var onCellChangeHandler = function (e, args) {
            dataView.updateItem(args.item.id, args.item);
        }
        var onColumnsResizedHandler = function (e, args) {
            if (grid) {
                grid.setColumns(grid.getColumns(), true);
            }
        }

        // wire up model events to drive the grid
        dataView.onRowCountChanged.subscribe(onRowCountChangedHandler);

        dataView.onRowsChanged.subscribe(onRowsChangedHandler);

        grid.onCellChange.subscribe(onCellChangeHandler);

        grid.onColumnsResized.subscribe(onColumnsResizedHandler);
        
        // Handler for column re-ordering in popups
        var onPopupColumnsReordered = function(e, args){
            if(args.forceCall){
                return;
            } else {
                var grid = args.grid;
                var columns = grid.getColumns();
                var reOrderedColumns = [];
                for(var i in columns){
                    var column = columns[i];
                    if($.trim(column.name).length == 0){
                        reOrderedColumns.splice(0, 0, column);
                    } else {
                        reOrderedColumns.push(column);
                    } 
                }
                grid.setColumns(reOrderedColumns, true);
            }
        };
		
        if (settings.isPopUpQuery || settings.isTemp || isDialog) {
            if (settings.emptyColumnCheck) {
                emptyColumnCheck();
            }
            $(container).show();
            if (settings.forceFitColumns) {
                forceFitGrid();
            }
            noRecordCheck();
            
            var grid = $(container).data('gridInstance');
            
            grid.onColumnsReordered.subscribe(onPopupColumnsReordered);
            
            // Prevent selector column in popup from being draggable
            $('.slick-header-column', container).mousedown(function(){
                var title = $(this).prop('title') || '';
                if($.trim(title).length == 0){
                    return false;
                }
            });

        } else {
        	 var gridInst = $(container).data('gridInstance');
             gridInst.onColumnsReordered.subscribe(onResultColumnsReordered);
            //Dont Request Personalized Information if any one of Screen Id and versionNo does not exist.
            if (!(screenId && versionNo)) {
            	//No preference is available, we must honor the default column visibility
            	setDefaultColumns();
                displayGrid();
            } else {
					
				//ajax call to load Eneterprise & User preference. In the server side the code is managed to marge the User & Enterprise preference as follows : 
				// Case 1. User preference is present for Screen A but Enterprise preference is not present for A -- then Honor User preference for screen A.
				// Case 2. User preference is not present for Screen A but Enterprise preference present for A -- then Honor Enterprise preference for screen A.
				// Case 3. Both User preference & Enterprise preference present for Screen A -- then Honor User preference for screen A.
				$.ajax({
					url: urls.loadPref,
					type: 'GET',
					error: ajaxErorHandling,
					success: function (prefData) {
						if(!prefData.success){
							xenos.postNotice(xenos.notice.type.error, prefData.value);
							return;
						}
						var gridInfo = xenos.utils.decodeValue(prefData.value[0] || '');
						if (gridInfo) {
								enableResetPref();
								var cols = gridInfo.pref;
								defaultInvisibleColumns = [];
								var ncols = [];
								var ncolsIdArrayTemp = [];
								for (var i in cols) {
									if (typeof cols[i] === 'object') {
										if(!(getColumnById(cols[i].id) == undefined)){
											var col = getColumnById(cols[i].id);
											col.width = parseInt(cols[i].width, 10);
											defaultColsWidth[col.id] = parseInt(cols[i].originalWidth,10);
											ncolsIdArrayTemp.push(col);
											//ncols.push(getColumnById(cols[i]));
											ncols.push(col);											
										}
									}
								}
								if (settings.consolidateActionFlag && settings.consolidateAttribute && settings.consolidateAttribute.type === 'check') {
									//Check first column. If consolidation is enable, first column should be consolidation column.
									if (data.length > 0) {
										ncols.unshift(checkboxSelector.getColumnDefinition());
									}
								} else if (settings.consolidateActionFlag && settings.consolidateAttribute && settings.consolidateAttribute.type === 'groupCheck') {
									//Check first column. If consolidation is enable, first column should be consolidation column.
									if (data.length > 0) {
										ncols.unshift(checkboxSelector.getColumnDefinition());
									}
								}

								//The below code is required for the following reason:-
								//If a Query Result Page has a preference and let's say a column with id 'x' is not present in the Query Result Page
								//but it is present in the User Confirmation/System Confirmation page of the same screen.
								//Now as the User Confirmation page and the Query Result page have the same Screen Id and hence if a user saves the 
								//preference in the Query Result Page and proceeds to the User Confirmation page then this extra column with id 'x' is to be 
								//shown along with the Query Result page's preference
								//Note : The extra column(s) will be shown at the end as passed in the grid result settings array
								
								//Check if the preference save button exists (i.e. if the button doesn't exists then it is not the Query Result page and hence proceed)
								//And also check if the grid result settings are defined with such column id array
								if(!(grid.getOptions().buttons && grid.getOptions().buttons.save) && displayAlwaysColumnIdArray.length > 0){
									//If the grid settings have such column id array then get the column definition from the id
									for(var i in displayAlwaysColumnIdArray){
										var column = getColumnById(displayAlwaysColumnIdArray[i]);
										//check if the grid setting column id is already present in the above prepared 'ncolsIdArrayTemp'
										//If not then only add the extra column else skip
										if(!(column == undefined) && jQuery.inArray(displayAlwaysColumnIdArray[i], ncolsIdArrayTemp) < 0){
											//Push the extra 'column' object in the preference column object 'ncols'
											ncols.push(column);
										}
									}
								}
				                //set invisible columns now...
				                for ( var ind in columns ) {
				                  if (ncols.indexOf(columns[ind]) == -1) {
				                    defaultInvisibleColumns.push(columns[ind].id);
				                  }
				                }
								grid.setColumns(ncols);

								//Fires an event notifying all subscribers.
								if (grid.onSelectedRowsChanged) {
									grid.onSelectedRowsChanged.notify();
								}
							if (gridInfo.forceFitColumns) {
								settings.forceFitColumns = true;
								grid.setOptions({forceFitColumns: true});
							}
							if (gridInfo.syncColumnCellResize) {
								grid.setOptions({syncColumnCellResize: true});
							}
							displayGrid();
						} else {
							//No preference is available, we must honor the default column visibility
							setDefaultColumns();
							evaluateOriginalWidth();
							disableResetPref();
							displayGrid();
						}
					}
				});
				$.ajax({
					url: urls.enterprisePref,
					type: 'GET',
					error: ajaxErorHandling,
					success: function (prefData) {
						if(!prefData.success){
							xenos.postNotice(xenos.notice.type.error, prefData.value);
							return;
						}
						var gridInfo = xenos.utils.decodeValue(prefData.value);
						if (gridInfo) {
							if (gridInfo.pref) {
								var cols = gridInfo.pref;
								var ncols = [];
								for (var i in cols) {
									if (typeof cols[i] === 'string') {
										if(!(getColumnById(cols[i]) == undefined)){
											ncols.push((getColumnById(cols[i])).id);
										}
									}
								}
								grid.enterprisePrefVal = ncols;
							}
						}
					}
				});
			}
        }
        grid.onBeforeDestroy.subscribe(function (e, args) {
            grid.invalidateAllRows();
            $('.next', containerSelector).unbind('click.' + containerId);
            $('.prev', containerSelector).unbind('click.' + containerId);
            $('.pdfBtn', container).unbind('click.' + containerId);
            $('.pdfBtnCurrent', container).unbind('click.' + containerId);
			$('.excelBtnCurrent', container).unbind('click.' + containerId);
            $('.excelBtn', container).unbind('click.' + containerId);
			container.find('.refresh').unbind(['click.',containerId].join(''));
            $(containerSelector).closest(".ui-dialog").unbind("resize." + containerId, _dialogResizeHandler);
            $(window).unbind('resize.' + containerId);
            $('.save-btn', containerSelector).die('click.' + containerId);
            grid.onMouseEnter.unsubscribe(onMouseEnterHandler);
            grid.onHeaderClick.unsubscribe(onHeaderClickHandler);
            grid.onClick.unsubscribe(onClickHandler);
            grid.onColumnsReordered.unsubscribe(onColumnsReorderedHandler);
            grid.onColumnsResized.unsubscribe(onColumnsDragHandler);
            grid.onSort.unsubscribe(onSortHandler);
            if(dataView){
            	dataView.onRowsChanged.unsubscribe(onRowsChangedHandler);
            }
            if (columnPickerObj) {
                columnPickerObj.destroy();
                columnPickerObj = null;
            }
            dataView = null;
            data = null;
        });
        return grid;
    }
}(jQuery));