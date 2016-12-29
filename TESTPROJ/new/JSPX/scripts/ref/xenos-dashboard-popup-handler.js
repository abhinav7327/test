//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
//common handler when different query result to be shown in dialog
var _handleWidgetLinkClick = function (e) {
    var resultType = e.data.resultType,
        url = $(e.target).attr('href'),
		dbdFeedPk = $(e.target).closest(".row").attr('pk');
        rqType = "GET",
        qParam = e.target.search,
        urlPrefix = "/dashboard/",
        qParam = qParam + '&query=dashboard&',
    //Find module name from url. As per server side design, module name will alwase be the second parmaeter of URL mapping
        urlArray = url.split(xenos.context.path),
        moduleName = urlArray[0].split('/')[1],
        viewMode = 'dialog',
        responseHandler = function () {};

    if ($(urlArray).get(1)) {
        moduleName = urlArray[1].split('/')[2];
    }
    //Identify View Mode
    if (url.indexOf("viewtype") >= 0) {
        viewMode = 'screen';
    }

    //Condition for Legacy Support
    if (url.indexOf('.action') < 0) {
        e.preventDefault();
		if($(e.target).parents('.widgetHolder').hasClass('editable')){
			return;
		}
        if (viewMode == 'screen') {
            responseHandler = function (resData) {
		if (resData.status == 400 || resData.status == 403 || resData.status == 408 ||resData.status == 0) {
			//Here we just only return. Post notice message will be displayed by Global handler.
			return;
		}
                var container = $("#content");
                container.html(resData.responseText);
				
				function isMultiQueryPage() {
					return (container.find('#isMultiQuery').val() == 'true');
				}
				
				// If "isMultiQuery" element value is "true"
				if(isMultiQueryPage()){

                        	// Get all ".xenos-grid" elements
                            var obj = container.find('#queryResultForm .xenos-grid');

                            // Calculate the grid-height based on the number of grids 
                            var gridHeight = Math.ceil($(container).height()/obj.length) - 60;

                            for(var i = 0; i < obj.length; i++){
                            	// Create the grid on each div with class 'xenos-grid' 	
                                $(obj[i]).xenosmultigrid(grid_result_data[i], grid_result_columns[i], grid_result_settings[i]);

                                // Adjust the height of the divs to prevent unusual grid height
                                $(obj[i]).height(gridHeight);
                            }
				} else if ($('#queryForm', container).length == 0) {
                    $('#queryResultForm .xenos-grid', container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
                }
            }
        } else {
            if (xenos.windowManager.allowDialog()) {
                var title = $(e.target).attr('title') + " " + xenos.title.suffix;
                //Dialog container
                var dialog_id = 'customDialog' + xenos.windowManager.counter;
                var dialogContainer = $('<div id=' + dialog_id + '></div>');
                //Function to handle response
                responseHandler = function (resData) {
                    if (resData.status == 403 || resData.status == 0) {
                        //Here we just only return. Post notice message will be displayed by Global handler.
                        return;
                    }
                    // Dialogr implementation
                    var $dialog = dialogContainer.dialog({
                        title: title,
                        height: $('#dashboard').innerHeight(),
                        width: $('#dashboard').innerWidth(),
                        bgiframe: true,
                        minHeight: 300,
                        minWidth: 500,
                        maximized: false,
                        autoOpen: true,
                        draggable: true,
                        resizable: true,
                        zIndex: 100,
                        beforeClose: function(event, ui) { 
							xenos.windowManager.cleanup();
							var grids = $("[class*=slickgrid_]", $(event.target).parents('div.ui-dialog'));
							$.each(grids, function (ind, grid) {
								$(grid).data("gridInstance").destroy();
							});
						  },
                        close: function (event, ui) {
                            dialogContainer.dialog('destroy');
                            dialogContainer.remove();
                            //Should be handle by grid.
                            $('.slick-columnpicker').remove();
                            //Unregister the Dialog
                            xenos.windowManager.unreg({
                                id: dialog_id,
                                title: title
                            });
                        },
                        open: function (event, ui) {
                            //Registering the Dialog to the Window Manager
                            xenos.windowManager.reg({
                                id: dialog_id,
                                title: title
                            });
                        }
                    });
                    dialogContainer.html("Loading...");

                    //dialogContainer.html(resData.responseText);
                    $('#formContainer').removeClass('paddingFour');
                    if (dialogContainer.find('#queryForm').length == 0) {
                        //store back url
                        var bckUrl = $('#queryResultForm').attr('action');
                        var targetDialog = dialogContainer.closest('.ui-dialog');
                        //dialogContainer.html($('#queryResultForm',targetDialog).html());
                        dialogContainer.html($('.ui-widget-content', targetDialog).html());
                        dialogContainer.html(resData.responseText);
                        //Adjust Width, Height of Grid
                        var yOffset = 0;
                        if (resultType === "saved_query") {
                            yOffset = 90;
                        } else {
                            yOffset = 58;
                            //}
                            if (grid_result_settings.moduleParam) {
                                moduleName = moduleName + '/' + grid_result_settings.moduleParam;
                            }
                            //filter and collapseExpandFunction are not available for all the result screens.Implemented for CAM Movement.
                            var filter = grid_result_settings.pagingInfo.filter;
                            if (typeof filter === 'undefined') {
                                filter = false;
                            }
                            var collapseExpandFunction = grid_result_settings.onClickCallbackHandler;
                            if (typeof collapseExpandFunction === 'undefined') {
                                collapseExpandFunction = false;
                            }
                            var disablePagingInfo = false;
                            if (grid_result_settings.pagingInfo.disable === true) {
                                disablePagingInfo = true;
                            }

                            var gridsettings = {
                                enableToolbar: true,
                                consolidateActionFlag: grid_result_settings.consolidateActionFlag || false,
                                consolidateAttribute: grid_result_settings.consolidateAttribute,
                                requestType: rqType,
                                yOffset: yOffset,
                                onClickCallbackHandler: collapseExpandFunction,
                                emptyColumnCheck: grid_result_settings.emptyColumnCheck || true,
                                buttons: {
                                    print: true,
                                    xls: true,
                                    pdf: true,
                                    columnPicker: false,
                                    save: false
                                },
                                pagingInfo: {
                                    isNext: isNext,
                                    filter: filter,
                                    disable: disablePagingInfo
                                },
                                urls: {
                                    nextPage: urlPrefix + moduleName + '/query/result.json' + qParam + 'fetch=next',
                                    prevPage: urlPrefix + moduleName + '/query/result.json' + qParam + 'fetch=previous',
                                    pdfReport: urlPrefix + moduleName + '/query/report.json' + qParam + 'outputType=pdf',
                                    xlsReport: urlPrefix + moduleName + '/query/report.json' + qParam + 'outputType=xls'
                                },
                                isDialog: true,
                                forceFitColumns: grid_result_settings.forceFitColumns ? grid_result_settings.forceFitColumns : false,
                                height: $('#dashboard').innerHeight(),
                                summaryInfo: grid_result_settings.summaryInfo ? grid_result_settings.summaryInfo : false
                            };

                            //Rendering Grid Now
                            $('.xenos-grid', dialogContainer).xenosgrid(grid_result_data, grid_result_columns, gridsettings);
                            if (resultType !== "saved_query") {
                                $('.formHeader', dialogContainer).hide();
                            }

                            if (typeof xenos$Dialog$Detail$Hook !== 'undefined') {
                                xenos$Dialog$Detail$Hook.call(
                                    this,
                                    jQuery('.ui-dialog.topMost .ui-dialog-content'),
                                    jQuery('.ui-dialog.topMost .ui-dialog-buttonpane')
                                );

                                delete xenos$Dialog$Detail$Hook;
                            }

                            //handle back to query page for saved query
                            if (resultType === "saved_query") {
                                dialogContainer.attr('action', bckUrl);
                            }
                        }
                    }
                }
            }
        }
		
		var xenos$Handler$asynchronous$DBD$popup = xenos$Handler$function({
			get: {
				requestType: xenos$Handler$default.requestType.asynchronous,
				target: '#content'
			},
			settings: {
				beforeSend: function(request) {
					request.setRequestHeader("Accept", "text/html;type=ajax");
				},
				type: 'GET',
				complete: responseHandler
			}
		});
		url = url + "&dbdFeedPk=" + dbdFeedPk + "&leftclick=";
		xenos$Handler$asynchronous$DBD$popup.generic(e, {requestUri: url});
    } else if (jQuery.browser.msie && url.indexOf('.action') >= 0) {
        e.preventDefault();
        // Handle struts MVC (old screen) in IE only
        jQuery('.contentBlockLabel a').colorbox({
            title: xenos.i18n.title.legacy,
            iframe: true,
            width: "98%",
            height: "98%",
            onClosed: function (message) {
                $.colorbox.remove();
            }
        });
    } else {
        e.stopPropagation();
        e.preventDefault();
        jAlert(xenos.i18n.message.window_not_supported, null);
    }
};