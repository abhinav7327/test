//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
(function($) {
	var scripts = [ {
		path : xenos.context.path + '/scripts/jquery.event.drag-2.0.min.js'
	}, {
		path : xenos.context.path + '/scripts/slick.core.js'
	}, {
		path : xenos.context.path + '/scripts/slick.dataview.js'
	}, {
		path : xenos.context.path + '/scripts/slick.grid.js'
	}, {
		path : xenos.context.path + '/scripts/xenos.rowselectionmodel.js'
	}, {
		path : xenos.context.path + '/scripts/xenos.grid.js'
	}, {
		path : xenos.context.path + '/scripts/xenos.editable.grid.js'
	}, {
		path : xenos.context.path + '/scripts/slick.formatters.js'
	}, {
		path : xenos.context.path + '/scripts/xenos.formatters.js'
	}, {
		path : xenos.context.path + '/scripts/slick.editors.js'
	}, {
		path : xenos.context.path + '/scripts/xenos.editors.js'
	}, {
		path : xenos.context.path + '/scripts/xenos.slick.editrowplugin.js'
	}, {
		path : xenos.context.path + '/scripts/slick.autotooltips.js'
	}, {
		path : xenos.context.path + '/scripts/slick.compositeeditor.js'
	}, {
		path : xenos.context.path + '/scripts/popqueryForm.js'
	}, {
		path : xenos.context.path + '/scripts/inf/datevalidation.js'
	}, {
		path : xenos.context.path + '/scripts/ref/wizard.js'
	}, {
		path : xenos.context.path + '/scripts/inf/utilValidator.js'
	}, {
		path : xenos.context.path + '/scripts/inf/utilCommons.js'
	}, {
		path : xenos.context.path + '/scripts/xenos-treeview.js'
	}, {
		path : xenos.context.path + '/scripts/jquery.elastislide.js'
	}, {
		path : xenos.context.path + '/scripts/xenos-multiselect.js'
	}, {
		path : xenos.context.path + '/scripts/ref/xenos-preferences.js'
	}, {
		path : xenos.context.path + '/scripts/xenos-datepicker.js'
	}, {
		path : xenos.context.path + '/scripts/xenos.authorization.history.js'
	}, {
		path : xenos.context.path + '/scripts/xenos.more.js'
	} ];

	xenos
			.loadScript(
					scripts,
					{
						ordered : true,
						success : function() {
							var fundCodeResult = [], rowId = 0, item = {}, fundCodeGrid = null, fundCodeList = [], rowIdx = -1;

							var fundCodeColumns = [ {
								name : "Code",
								field : "code",
								id : "code",
								sortable : false
							} ];
							var fundCodeConf = {
								editMode : 'both',
								editCallback : fundCodeEditHandler,
								deleteCallback : fundCodeDeleteHandler,
								forceFitColumns : true
							};

							fundCodeGrid = $('#fundCodeGrid').xenoseditablegrid(
									fundCodeResult, fundCodeColumns,
									fundCodeConf);
							$('#addFundCodeBtn').bind('click',
									fundCodeAddHandler);
							$('#updateFundCodeBtn').bind('click',
									fundCodeUpdateHandler);
							$('#cancelFundCodeBtn').bind('click',
									fundCodeCancelHandler);
							
							/**
							 * Handler required for Ajax call to the server side
							 */
							var xenos$Handler$RequestHandler = xenos$Handler$function({
								get : {
									contentType : 'json',
									requestType : xenos$Handler$default.requestType.asynchronous
								},
								settings : {
									beforeSend : function(request) {
										request.setRequestHeader('Accept',
												'application/json');
										request.setRequestHeader(
												'Content-Type',
												'application/json');
									},
									type : 'POST'
								}
							});
							
							/**
							 * Handler for Add button of the grid.
							 */
							function fundCodeAddHandler(e) {
								rowIdx = -1;
								addOrUpdateGrid(e);
							}

							/**
							 * Handler for Edit action of the grid.
							 */
							function fundCodeEditHandler(rowIndex, dataContext) {
								rowIdx = rowIndex;
								populateFundCodeForm(rowIndex);
								$('.editBtnFundCode').css('display', 'block');
								$('.addBtnFundCode').css('display', 'none');
							}

							/**
							 * Handler for Delete action of the grid.
							 */
							function fundCodeDeleteHandler(rowIndex,
									dataContext) {
								var result = fundCodeGrid.getData();
								result.splice(rowIndex, 1);
								fundCodeGrid.clearData();
								for ( var i in result) {
									item = {};
									rowId += 1;
									item.id = "xenos_" + rowId;
									item.code = result[i].code;
									fundCodeGrid.addOrUpdateRow(item, {});
								}
								$('.editBtnFundCode').css('display', 'none');
								$('.addBtnFundCode').css('display', 'block');
							}

							/**
							 * Handler for Save button of the grid 
							 * when an fund code of the grid is edited.
							 */
							function fundCodeUpdateHandler(e) {
								addOrUpdateGrid(e);
							}

							/**
							 * Handler for Cancel button of the grid 
							 * when an fund code of the grid is edited.
							 */
							function fundCodeCancelHandler(e) {
								upsertFundCode('cancel', null);
								$('.editBtnFundCode').css('display', 'none');
								$('.addBtnFundCode').css('display', 'block');
							}

							/**
							 * Function called for validating the fund code
							 * and also update the grid after successful validation.
							 */
							function addOrUpdateGrid(e) {
								var code = $('#fund').val().toUpperCase();
								var result = fundCodeGrid.getData();
								var codeList = [];
								var flag = false;
								for ( var i in result) {
									codeList[i] = result[i].code;
									if (code === result[i].code && i != rowIdx) {
										flag = true;
										break;
									}
								}
								var reqObj = {
									"fundCode" : code,
									"fundCodeList" : codeList,
									"rowIndex" : rowIdx
								};

								if (code === '' || code === null) {
									xenos.postNotice(xenos.notice.type.error,
											"Please provide a Fund Code");
								} else if (flag) {
									xenos.postNotice(xenos.notice.type.error,
											"Fund Code already added");
								} else {
									var requestUrl = xenos.context.path
											+ "/secure/ref/fundCode/selector/verify";

									xenos$Handler$RequestHandler
											.generic(
													e,
													{
														requestUri : requestUrl,
														settings : {
															data : JSON
																	.stringify(reqObj)
														},
														onJsonContent : function(
																e, options,
																$target,
																content) {
															if (content.modelMap.success == true) {
																xenos.utils
																		.clearGrowlMessage();
																var index = content.modelMap.value[0].rowIndex;
																if (index === -1) {
																	item = {};
																	rowId += 1;
																	item.id = "xenos_"
																			+ rowId;
																	item.code = content.modelMap.value[0].fundCode;
																	fundCodeGrid
																			.addOrUpdateRow(
																					item,
																					{});
																	$('#fund')
																			.val(
																					'');
																} else {
																	upsertFundCode(
																			'save',
																			content.modelMap.value[0].fundCode);
																	$(
																			'.editBtnFundCode')
																			.css(
																					'display',
																					'none');
																	$(
																			'.addBtnFundCode')
																			.css(
																					'display',
																					'block');
																}
															} else {
																xenos.utils
																		.displayGrowlMessage(
																				xenos.notice.type.error,
																				content.modelMap.value);
															}
														}
													});

								}

							}

							/**
							 * Populate the fund code textbox on editing a fund code from the grid.
							 */
							function populateFundCodeForm(i) {
								$('#fund').val(fundCodeGrid.getData()[i].code);
								$('#fund').focus();
							}

							/**
							 * Add the new data in the grid
							 * or update the existing grid data.
							 */
							function upsertFundCode(mode, data) {
								var result = fundCodeGrid.getData();
								if (mode === 'save') {
									result[rowIdx].code = data;
								}
								fundCodeGrid.clearData();
								for ( var i in result) {
									item = {};
									rowId += 1;
									item.id = "xenos_" + rowId;
									item.code = result[i].code;
									fundCodeGrid.addOrUpdateRow(item, {});
								}
								$('#fund').val('');
							}
						}
					});

	/**
	 * Function called on change of the radio button.
	 */
	fundSelection = function(e) {
		if (e === "few") {
			$('#addFundCodeBtn').removeAttr('disabled');
			$('#fundCodeGrid').show();
		} else {
			$('#addFundCodeBtn').attr('disabled', 'disabled');
			$('#fundCodeGrid').hide();
		}
	}

})(jQuery);
