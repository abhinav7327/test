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
    $.fn.xenosmultigrid = function (data, columns, settings) {
        /**
         *    Paging in Grid
         **/
        
        if (settings.enableToolbar) {
            if (typeof settings.pagingInfo.isNext == 'undefined') throw "Please define isNext, to make sure to enable/disable next button";
        }

        if(typeof settings.gridId == 'undefined') throw "Please define unique gridId for each grid.";
        //Setting Defaults
        if (settings.emptyColumnCheck !== false) {
            settings.emptyColumnCheck = true;
        }
        var cmdParam;
        if (settings.isPopUpQuery) {
            cmdParam = '&commandFormId=' + $('#popFormContainer [name=commandFormId]').val();
        } else {
            cmdParam = '&commandFormId=' + $('[name=commandFormId]').val();
        }
        //Done for report generation (If result grid is shown within popup with PDF/XLS enabled)
        if (settings.isNormalResultGridInPopUp) {
            cmdParam = '&screenName=' + settings.screenName + '&commandFormId=' + $('.ui-dialog.topMost [name=commandFormId]').val();
        }

        xenos.utils.gridCounter++;

        var dataView = new Slick.Data.DataView(),
            dataId = 0,
            container = this,
            isNext = settings.pagingInfo.isNext,
            isPrevious = false,
            isDialog = settings.isDialog ? true : false,
            isPopUpQuery = settings.isPopUpQuery ? true : false,
            nextCls = 'next disable',
            filter = settings.pagingInfo.filter,
            pageNo = 1,
            prevButton = null,
            nextButton = null,
            lock = false,
            host = xenos.context.path,
            urls = settings.urls,
            cmdFormParam = cmdParam,
            pageTemplate = $.template(null, '<div class="xenos-grid-pager"><div class="pagerWrap">{{if !pagingInfo.disable}}<div class="prevNextarea left">{{if !pagingInfo.disablePager}}<span class="prev disable">B</span><span class="left pagenoText">Page</span><span class="pageno left">1</span>{{if pagingInfo.url}}<div class="pagecounter">of&nbsp;<div class="info"><span class="pager-progress" style="display:block;"></span></div></div>{{/if}}<span class="next ' + (isNext ? '' : 'disable') + '">C</span><div style="width:16px;height:16px;float:left;"><span class="xenos-grid-progress"></span></div>{{/if}}{{if pagingInfo.url}}<div class="recordcounter">&nbsp;Records:&nbsp;<div class="info"><span class="pager-progress" style="display:block;"></span></div></div>{{/if}}</div>{{/if}}<div class="btnsArea right">{{if buttons.print}}<div class="left marginRight"><a title="Print" class="printBtn paddingLeft">K</a></div>{{/if}}{{if buttons.pdf}}<div class="left marginRight"><a  title="PDF" class="pdfBtn">A</a></div>{{/if}}{{if buttons.xls}}<div class="left marginRight"><a title="XLS" class="excelBtn">G</a></div>{{/if}}{{if buttons.columnPicker}}<div class="left marginRight queryColmTop"><a title="Columns" class="queryColumns paddingLeft gridId-'+settings.gridId+'"></a></div>{{/if}}{{if buttons.save}}<div class="left marginRight"><a title="Save" class="save-btn saveBtn gridId-'+settings.gridId+' disable">i</a></div>{{/if}}</div></div></div>'),
            screenId = ($.trim(settings.screenId) !== null && $.trim(settings.screenId) !== '')? settings.screenId : $('[name=screenId]').val(),
            versionNo = $('[name=versionNo]').val(),
            ajaxType = 'POST',
            yOffset = settings.yOffset ? settings.yOffset : 0,
            allowIdGeneration = ( settings.allowIdGeneration || settings.allowIdGeneration == undefined) ? true : false,
            headerHeight = settings.headerHeight ? settings.headerHeight : 50,
            enableHeader = settings.enableHeader ? true : false,
            headerText = (settings.headerInfo && settings.headerInfo.headerText) ? settings.headerInfo.headerText : "",
            checkboxSelector;

        //Adding unique id to the grids.        
        var containerId = 'xenosmultigrid-' + settings.gridId;
        container.addClass(containerId);
        var containerSelector = '.' + containerId;

        // Actual grid number will be 1 less than supplied gridId since actual grid number will be mapped to grid array index which is 1 less than gridId
        var actualGridNum = settings.gridId-1;

        var heightOfHeaderAndFooter = function (container, pop) {
            var $header = pop ? $('.popResultGridHeader', container) : $('.resultGridHeader', container);
            var $footer = pop ? $('.popResultGridFooter', container) : $('.resultGridFooter', container);
            var height = $header.outerHeight(true) + $footer.outerHeight(true);
            return height == 0 ? 0 : height + 8;
        };

        if (settings.isPopUpQuery) {
            var gridHeight = settings.height ? settings.height : $(container).closest('.ui-dialog').height() - heightOfHeaderAndFooter(container, true);
            var gridWidth = settings.width ? settings.width : '100%';
        }
        else {
            var gridHeight = settings.height ? settings.height : $('#content').height() - 60 - heightOfHeaderAndFooter('#content');
            var gridWidth = settings.width ? settings.width : '100%';
        }

        function generateId(records){
            for(i in records){
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

        function enableSave(gridid) {
            if (settings.isPopUpQuery || settings.isDialog || settings.isTemp || !(settings.buttons && settings.buttons.save)) {
                return;
            }
            $('.saveBtn', containerSelector).filter('.gridId-'+gridid).removeClass('disable');
            $('#content').saverOn(saveHandler);
        }

        function disableSave(gridid) {
            $('.saveBtn', containerSelector).filter('.gridId-'+gridid).addClass('disable');
            $('#content').saverOff(saveHandler);
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

        //Defining Sorters for Grid.
        function gridSorter(grid, dataView) {
            var sortCol, sortDir, comparer = function (a, b) {
                    var x = a[sortcol],
                        y = b[sortcol];
                    return (x == y ? 0 : (x > y ? 1 : -1));
                },
                numberComparer = function (a, b) {
                    var x = parseFloat(a[sortcol].replace(/,/g, '')),
                        y = parseFloat(b[sortcol].replace(/,/g, ''));
                    return (x == y ? 0 : (x > y ? 1 : -1));
                },
                filtedEmptyStringComparer = function (a, b) {

                };
            grid.onSort.subscribe(function (e, args) {
                sortdir = args.sortAsc ? 1 : -1;
                sortcol = args.sortCol.field;
                // using native sort with comparer
                // preferred method but can be very slow in IE with huge datasets

                if (args.sortCol.cssClass == "xenos-grid-number") {
                    dataView.sort(numberComparer, args.sortAsc);
                } else {
                    dataView.sort(comparer, args.sortAsc);
                }

            });
            dataView.onRowsChanged.subscribe(function (e, args) {
                grid.invalidateRows(args.rows);
                grid.render();
            });
        }

        function prepareReportUrl(reportUrl){
            return reportUrl + '&' + 'id=' + settings.gridId;
        }

        //Open Report
        function openReport(ev) {
            //window.open(ev.data.url);
            window.open(prepareReportUrl(ev.data.url));
        }


        function ajaxErorHandling(xhr, textStatus, errorThrown) {
            if (xhr.status == 404) throw "xenos Grid expecting a valid Url"
            if (textStatus == 'timeout') throw "Server not responding"
            $('.xenos-grid-progress').hide();
            lock = false;
        }

        function continueUpdate(data){
            var gridData = data.commandForm.resultViewList[actualGridNum];
            if(allowIdGeneration){
                dataView.setItems(generateId(gridData));
            }else{
                dataView.setItems(gridData);
            }
            isNext = data.isNext[actualGridNum];
            isPrevious = data.isPrevious[actualGridNum];
            //Clear Selections in case Selection Model Exist.
            if (grid.getSelectionModel())
                grid.setSelectedRows([]);

            grid.resizeCanvas();
        }

        function updateData(data) {            
            if(settings.events && settings.events.onDataUpdate){
                settings.events.onDataUpdate(data,continueUpdate);
            }else{
                continueUpdate(data);
            }
        }

        //Function to handle warning message in grid
        function checkEndReached(allData) {
            if (allData.isTruncated[actualGridNum]) {
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

        function nextPage(ev) {
            if (isNext && !lock) {
                lock = true;
                $('.xenos-grid-progress', containerSelector).show();
                xenos$Handler$default.generic(undefined, {
                    requestUri:urls.nextPage + '&' + 'id=' + ev.data.id,
                    requestType:xenos$Handler$default.requestType.asynchronous,
                    contentType:xenos$Handler$default.contentType.json,
                    settings:{
                        type:ajaxType,
                        data:{pageNo:pageNo}
                    },
                    onJsonContent:function (e, options, $target, content) {
                        checkEndReached(content);
                        updateData(content);
                        pageNo = content.pageNo[actualGridNum];
                        updatePager();
                        $('.xenos-grid-progress', containerSelector).hide();
                        lock = false;
                        if (settings.emptyColumnCheck) {
                            emptyColumnCheck();
                        }
                    }
                });
            }
        }

        function prevPage(ev) {
            if (isPrevious && !lock) {
                lock = true;
                $('.xenos-grid-progress', containerSelector).show();
                xenos$Handler$default.generic(undefined, {
                    requestUri:urls.prevPage + '&' + 'id=' + ev.data.id,
                    requestType:xenos$Handler$default.requestType.asynchronous,
                    contentType:xenos$Handler$default.contentType.json,
                    settings:{
                        type:ajaxType,
                        data:{pageNo:pageNo}
                    },
                    onJsonContent:function (e, options, $target, content) {
                        updateData(content);
                        pageNo = content.pageNo[actualGridNum];
                        updatePager();
                        $('.xenos-grid-progress', containerSelector).hide();
                        lock = false;
                        if (settings.emptyColumnCheck) {
                            emptyColumnCheck();
                        }
                    }
                });
            }
        }

       
        function saveResultPreference(e) {
            if ($('.saveBtn', containerSelector).hasClass('disable')) {
                return;
            }

            
            // Ajax call to get any pre-existing preference
            $.ajax({
                url:urls.loadPref,
                type:'GET',
                error:ajaxErorHandling,
                success:function (data) {
                    // Get the existing preference details
                    var existingPref = xenos.utils.decodeValue(data.value);


                    // Prepare the current grid's preference config 
                    var pref = [],
                        data = {},
                        gridData = [],
                        prefData = {},
                        gridId = grid.getOptions().gridId;

                    
                    data.gridId = gridId;

                    var columns = grid.getColumns();            
                    for (var i in columns) {
                        //Ignoring Checkbox column fields
                        if(!(columns[i].id == '_checkbox_selector')){
                            pref.push(columns[i].id);
                        }
                    }

                    data.pref = pref;
                    data.forceFitColumns = grid.getOptions().forceFitColumns;
                    data.syncColumnCellResize = grid.getOptions().syncColumnCellResize;


                    // If there is any existing preference details handle the possible conditions
                    if(existingPref && existingPref.gridData){

                        // If no prior preference exists for current grid but other grids have existing preference
                        if(!isExistingPref(existingPref.gridData, gridId)){
                            gridData.push(data);
                        }


                        for(var i=0; i< existingPref.gridData.length; i++){                            
                            // If prior preferences exists for the current grid replace with new preference details
                            if(existingPref.gridData[i].gridId == gridId){                                
                                gridData.push(data);
                            }else{ 
                                gridData.push(existingPref.gridData[i]);
                            }
                        }
                        
                    }else{
                        // If there is NO existing prefernce details for any of the grids 
                        gridData.push(data);
                    }

                    // Assign the array to object
                    prefData.gridData = gridData;

                    // Save the preferences                                        
                    prefData = xenos.utils.encodeValue(prefData); 
                    xenos.utils.savePreference(prefData, urls.savePref, screenId, versionNo, function () {
                        xenos.postNotice('success', xenos.i18n.message.preference_save_message);
                        disableSave(grid.getOptions().gridId);
                    });
                    
                    
                }
            });
        }


        function isExistingPref(prefArray, currgridid){
            var prefExists = false;

            for(var i = 0; i < prefArray.length; i++){
                if(prefArray[i].gridId == currgridid){
                    prefExists = true;
                    break;
                }
            }

            return prefExists;
        }



        function getColumnById(id) {
            for (var i in columns) {
                if (columns[i].id === id) {
                    return columns[i];
                    break;
                }
            }
        }
        
        function preparePaginginfoUrl(pagingInfoUrl){
            if(pagingInfoUrl != ''){                
                return xenos.context.path + '/' + pagingInfoUrl + '?' + 'id='+ settings.gridId + '&' + cmdFormParam.substring(1)
            }else{
                return xenos.context.path;
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

            //Binding Listeners to the Previous and Next Button
            nextButton = $('.next', containerSelector).bind('click', {id: settings.gridId}, nextPage);
            prevButton = $('.prev', containerSelector).bind('click', {id: settings.gridId}, prevPage);
            $('.pdfBtn', containerSelector).bind('click', {url:urls.pdfReport}, openReport);
            $('.excelBtn', containerSelector).bind('click', {url:urls.xlsReport}, openReport);
            $('.save-btn', containerSelector).die().live('click', {grid:grid}, saveResultPreference);

            //Reading page counter
            if (settings.pagingInfo.url) {
                xenos$Handler$default.generic(undefined, {                    
                    requestUri:preparePaginginfoUrl(settings.pagingInfo.url),
                    requestType:xenos$Handler$default.requestType.asynchronous,
                    settings:{type:ajaxType},
                    contentType:xenos$Handler$default.contentType.json,
                    onJsonContent:function (e, options, $target, content) {
                        $('.pagecounter .info', containerSelector).html(content.xenosModelMap.modelMap.totalPageNo || 1);
                        $('.recordcounter .info', containerSelector).html(content.xenosModelMap.modelMap.count);
                    }
                });
            }
        }

        //Setting the width and height of the grid
        container.height(gridHeight - yOffset);
        container.width(gridWidth);

        //Resize Handling
        if (isDialog || isPopUpQuery) {
            $(this).closest(".ui-dialog").bind("resize", function () {
                if(settings.resizeHandler){
                    settings.resizeHandler(container,grid);
                }else{
                    var innerContainerHeight = container.closest('.ui-dialog').height() - yOffset - heightOfHeaderAndFooter(container, true);
                    container.height(innerContainerHeight);
                    $(".slick-viewport", container).height(innerContainerHeight - 50);
                    if(grid.getOptions().forceFitColumns){
                        forceFitGrid();
                    }else{
                        grid.resizeCanvas();
                    }
                }

            });
        } else {
            $(window).bind('resize', function () {
                //Used to hide Context Menu on Window Resize.
                $('.xenos-grid-pager',container).click();
                //If forcefit columns is true, then just Autofit columns based on size and return
                if(grid && grid.getOptions().forceFitColumns){
                    forceFitGrid();
                    return;
                }
                //If not forcefit, then do resize the grid canvas based on window width or height
                var innerContainerHeight = $('#content').height() - 60 - yOffset - heightOfHeaderAndFooter('#content');
                if (container.closest('.ui-dialog').length) {
                    container.height(innerContainerHeight);
                    $(".slick-viewport").height(innerContainerHeight - 50);
                }
            });
        }

        var cached = xenos$Cache.get('globalPrefs');
        var evenRowColor = cached.zebraColorEven ? cached.zebraColorEven : '#F9F9F9';
        var oddRowColor = cached.zebraColorOdd ? cached.zebraColorOdd : '#E5E9ED';
        var cxlColorEven = cached.cxlColorEven ? cached.cxlColorEven : '#ffe0e8';
        var cxlColorOdd = cached.cxlColorOdd ? cached.cxlColorOdd : '#fcedf1';
        var failColorEven = cached.failColorEven ? cached.failColorEven : '#ffe0e8';
        var failColorOdd = cached.failColorOdd ? cached.failColorOdd : '#fcedf1';

        //Grid Options
        var options = {
            enableCellNavigation:true,
            rowHeight:20,
            enableTextSelectionOnCells:true,
            headerHeight:headerHeight,
            ckBoxInFirstPos:settings.consolidateActionFlag,
            isPopUpQuery:settings.isPopUpQuery,
            evenRowColor:evenRowColor,
            oddRowColor:oddRowColor,
            cxlColorEven:cxlColorEven,
            cxlColorOdd:cxlColorOdd,
            failColorEven:failColorEven,
            failColorOdd:failColorOdd,
			resolveBgColor:settings.resolveBgColor,
            syncColumnCellResize:false,
            forceFitColumns:settings.forceFitColumns ? settings.forceFitColumns : false,
            rowHeight:settings.rowHeight || 20,
            editable:settings.editable || false,
            enableColumnReorder: (settings.enableColumnReorder == undefined || settings.enableColumnReorder == true) ? true : false,
            context: this,            
            gridId:settings.gridId
        };

        //Handle consolidate flag. If consolidation flag is undefined or false then there should be no consolidation action, otherwise consolidation should be enable
        if (settings.consolidateActionFlag) {
            //Check first column. If consolidation is enable, first column should be consolidation column.
            if (settings.consolidateAttribute && settings.consolidateAttribute.type === 'check') {
                checkboxSelector = new Slick.CheckboxSelectColumn({
                    cssClass:"slick-cell-checkboxsel"
                });
                columns.unshift(checkboxSelector.getColumnDefinition());
            } else {
                var columnDefObj = $.extend({name:"", field:"cnslAct", id:"cnslAct", width:30, formatter:Slick.Formatters.ConsolidateActFormater}, settings.consolidateAttribute);
                columns.unshift(columnDefObj);
            }
        }
        if(allowIdGeneration){
            dataView.setItems(generateId(data));
        }else{
            dataView.setItems(data);
        }


        if (filter) {
            dataView.setFilter(filter);
        }

        //Defining and Rendering the Grid
        var grid = new Slick.Grid(container, dataView, columns, options);

        //Set Selection Model and Register Plugin, in case select/select All column is required.
        if (settings.consolidateActionFlag && settings.consolidateAttribute && settings.consolidateAttribute.type === 'check') {
            grid.setSelectionModel(new Slick.RowSelectionModel({selectActiveRow:false}));
            grid.registerPlugin(checkboxSelector);
        }

        grid.registerPlugin(new Slick.AutoTooltips());
        //no records check
        function noRecordCheck() {
            if (data.length === 0) {
                $('.grid-canvas', $(container)).html('<div class="noRecord">' + xenos.i18n.message.no_record_found_message + '</div>');
            }
        }

        //Forcefit grid
        function forceFitGrid() {
            grid.resizeCanvas();
            grid.autosizeColumns();

            /*  Fix for IE 8
             *   Issue: Headers get messed up on AutoFit
             */
            if(grid.getOptions().forceFitColumns && $.browser.msie){
                grid.setColumns(grid.getColumns(), true);
            }
        }

        //Incase of dialog if data is not present then columns are force-fitted inorder to make "No Records Found" message fully visible to the user.
        if (data.length === 0 && isDialog) {
            forceFitGrid();
        }

        //Check and Resize empty columns
        function emptyColumnCheck() {
            //Avoiding Resize functionality when there is no data.
            if (data.length === 0) {
                return;
            }
            var headerColumns = $('.slick-header-column', $(container));
            var flag = [];
            var updateGrid = false;
            for (i = 0; i < headerColumns.length; i++) {
                flag[i] = true;
                $.each($('.l' + i, $(container)), function (ind, el) {
                    if ($(el).text() != '') {
                        flag[i] = false;
                        if (grid.getColumns()[i].originalWidth)
                            grid.getColumns()[i].width = grid.getColumns()[i].originalWidth;

                        return false;
                    }
                });
                if (flag[i] && grid.getColumns()[i]) {
                    grid.getColumns()[i].originalWidth = grid.getColumns()[i].width;
                    grid.getColumns()[i].width = 40;
                    updateGrid = true;
                }
            }
            if (updateGrid) {
                grid.setColumns(grid.getColumns(), true);
            }
        }

        function displayHeader(){
            $(container).prev().html(headerText);    
            $(container).prev().attr('style', 'margin:0px;').show();
        }

        //Display Grid
        function displayGrid() {
            if (settings.emptyColumnCheck) {
                emptyColumnCheck();
            }

            if(settings.enableHeader){
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

            //Subscribe events on Grid
            grid.onColumnsReordered.subscribe(function (e, args) {
                if (args.forceCall) {
                    return;
                } else {
                    enableSave(grid.getOptions().gridId);                    
                }
            });

        }

        function getByGridId(id){
            return (grid.getOptions.gridId == id) ? grid : null;
        }

        //Binding Listeners on Forcefit and Synchronize options
        $('input[id="autoresize-'+grid.getOptions().gridId+'"]').die().live('click', function () {
            enableSave($(this).data('gridId'));
            forceFitGrid();
        });

        $('input[id="syncresize-'+grid.getOptions().gridId+'"]').die().live('click', function () {
            enableSave($(this).data('gridId'));   
        });

        //Render Toolbar with options if enabled
        if (settings.enableToolbar) {
            setToolbar(settings);
        }

        //Initializing the Grid Sorter
        gridSorter(grid, dataView);

        //Initializing the Column Picker
        if(settings.buttons && settings.buttons.columnPicker){
            new Slick.Controls.MultiGridColumnPicker(columns, grid, options);
        }

        $(container).data("gridInstance", grid);

        grid.onClick.subscribe(function (e, args) {
            //cellName may require lettar
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
        });

        // wire up model events to drive the grid
        dataView.onRowCountChanged.subscribe(function (e, args) {
            grid.updateRowCount();
            grid.render();
        });

        dataView.onRowsChanged.subscribe(function (e, args) {
            grid.invalidateRows(args.rows);
            grid.render();
        });

        grid.onCellChange.subscribe(function (e, args) {
            dataView.updateItem(args.item.id, args.item);
        });


        if (settings.isPopUpQuery || settings.isTemp || isDialog) {
            if (settings.emptyColumnCheck) {
                emptyColumnCheck();
            }
            $(container).show();
            if (settings.forceFitColumns) {
                forceFitGrid();
            }
            noRecordCheck();

        } else {
            //Dont Request Personalized Information if Screen Id does not exist.
            if (!screenId) {
                displayGrid();
                return;
            }
			//ajax call to load Eneterprise & User preference. In the server side the code is managed to marge the User & Enterprise preference as follows : 
			// Case 1. User preference is present for Screen A but Enterprise preference is not present for A -- then Honor User preference for screen A.
			// Case 2. User preference is not present for Screen A but Enterprise preference present for A -- then Honor Enterprise preference for screen A.
			// Case 3. Both User preference & Enterprise preference present for Screen A -- then Honor User preference for screen A.
            $.ajax({
                url:urls.loadPref,
                type:'GET',
                error:ajaxErorHandling,
                success:function (data) {
                    var prefInfo = xenos.utils.decodeValue(data.value);                    
                    if (prefInfo && prefInfo.gridData) {                        
                        for (var i in prefInfo.gridData) {
                                var gridInfo = prefInfo.gridData[i];

                                if(gridInfo.gridId == grid.getOptions().gridId){                                    
                                    if (gridInfo.pref) {
                                        var cols = gridInfo.pref;
                                        var ncols = [];
                                        for (var i in cols) {
                                            if (typeof cols[i] === 'string') {
												if(!(getColumnById(cols[i]) == undefined)){
													ncols.push((getColumnById(cols[i])));
												}
                                            }
                                        }
                                        if (settings.consolidateActionFlag && settings.consolidateAttribute && settings.consolidateAttribute.type === 'check') {
                                            //Check first column. If consolidation is enable, first column should be consolidation column.
                                            ncols.unshift(checkboxSelector.getColumnDefinition());
                                        }
                                        grid.setColumns(ncols, true);
                                    }
                                    if (gridInfo.forceFitColumns) {
                                        settings.forceFitColumns = true;
                                        grid.setOptions({forceFitColumns:true});
                                    }
                                    if (gridInfo.syncColumnCellResize) {
                                        grid.setOptions({syncColumnCellResize:true});
                                    }
                                    
                                    displayGrid();
                                }else{
                                    displayGrid();
                                }
                            }

                    } else {
                        displayGrid();
                    }
                }
            });
            $.ajax({
                url:urls.enterprisePref,
                type:'GET',
                error:ajaxErorHandling,
                success:function (data) {

                    var prefInfo = xenos.utils.decodeValue(data.value);                    
                    if (prefInfo && prefInfo.gridData) {
                        for (var i in prefInfo.gridData) {
                            var gridInfo = prefInfo.gridData[i];
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

                    }


                }
            });
        }
        return grid;
    }
}(jQuery));