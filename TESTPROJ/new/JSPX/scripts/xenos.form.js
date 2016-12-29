//$Id$
//$Author: dipteshc $
//$Date: 2016-12-26 18:37:43 $
/**
 * Form Personalize
 **/ (function ($) {
	 $.fn.xenosform = function (options) {
		 /* Variables
		  *	topItems		List of names of all the fields present in the top area of the form.
		  *	moreItems		List of names of all the fields present in the more area of the form.
		  *	formItems		List of names of all the fields present in the form.
		  *	topItemsPref	List of names of all the fields saved in preference in order for top items.
		  *	moreItemsPref	List of names of all the fields saved in preference in order for more items.
		  *	topItemsRem		List of names of all the fields removed from the top items area of form
							and added to the removed zone.
		  *	moreItemsRem	List of names of all the fields removed from the more items area of form
							and added to the removed zone.
		  *	recievedItem	Flag used by drag drop to handle append/remove operation.
		  *	formClone		When in personalize mode, formClone is used to do remove/append operation
		  *	formOrig		When in personalize mode, formOrig holds all the original fields.
		  *	connector		Value of connector changes depending on the elements that is being 
							dragged/dropped, it helps define the droppable zone for an element.
		  *	host			Context Path.
		  *	screenId		Screen Id.
		  *	versionNo		Version No.
		  */

		 var container = this,
		 beforeSubmit,
		 connectWith;
		 if(options && options.beforeSubmit){
			 beforeSubmit = options.beforeSubmit;
		 }
		 if(options && options.connectWith){
			 connectWith = options.connectWith;
		 } else {
			 connectWith = '.topitems,.moreitems';
		 }

		 var beforeReset=function(){};
		 if(options && options.beforeReset){
			 beforeReset = options.beforeReset;
		 }

		 function updateFields(){
			 //Handling of Special Input Fields
			 //Datepicker
			 xenos.loadScript([{path: xenos.context.path + '/scripts/inf/datevalidation.js'},
			                   {path: xenos.context.path + '/scripts/xenos-datepicker.js'}], {
				 success: function() {
					 $('input.dateinput',container).xenosdatepicker();					
					 $(document).trigger('tabIndex');
				 }
			 });

			 xenos.loadScript([
			                   {path: xenos.context.path + '/scripts/inf/jquery.fancytree-all.min.js'},
			                   {path: xenos.context.path + '/scripts/xenos-treeview2.js'}
			                   ], {
				 success: function() {
					 //Instrument Type Tree
					 $('input.instrumentType',container).treeview2({
						 contentName: 'instrumentJson',
						 type: "Instrument Type"
					 });

					 //Market Tree
					 $('input.market',container).treeview2({
						 contentName: 'marketJson',
						 type: "market"
					 });

					 //Strategy Code
					 $('input.strategyCode',container).treeview2({
						 contentName: 'strategyCodeTree',
						 type: "Strategy Code"
					 });
				 }
			 });

			 xenos.loadScript([{path: xenos.context.path + '/scripts/xenos-autocomplete.js'}], {
				 success: function() {	    	
					 //Account Number
					 $('input.accountNo',container).xenosautocomplete({
						 requestContext: function($target){
							 var $popElm = $target.parent().siblings('div.popupBtn').find('input');
							 var actcptypecontext = $popElm.attr('actCPTypeContext')
							 return{
								 type: 'AccountTypeAhead',
								 actType: $popElm.attr('actTypeContext') || 'T|B',
								 CPType: (actcptypecontext ?  actcptypecontext.replace("BANK/CUSTODIAN","BROKER") : actcptypecontext )|| 'CLIENT|INTERNAL|BROKER'
							 }
						 },
						 minLength: 2,
						 delay: 400,
						 appendTo: $('div#footer>div#autocompletecontainer')
					 });

					 //Inventory Account Number
					 $('input.invAccountNo',container).xenosautocomplete({
						 requestContext: function($target){
							 var $popElm = $target.parent().siblings('div.popupBtn').find('input');
							 return {
								 type: 'AccountTypeAhead',
								 actType: $popElm.attr('invActTypeContext') || 'T|B',
								 CPType:  $popElm.attr('invCPTypeContext') || 'INTERNAL'
							 }
						 },
						 minLength: 2,
						 delay: 400,
						 appendTo: $('div#footer>div#autocompletecontainer')
					 });

					 //Sales Code
					 $('input.salesCode',container).xenosautocomplete({
						 requestContext: {
							 type: 'SalesTypeAhead'
						 },
						 minLength: 1,
						 delay: 400,
						 appendTo: $('div#footer>div#autocompletecontainer')
					 });
				 }
			 });
		 }

		 //Detach All Elements from form
		 var topItems = getFieldNames('topitems',container),
		 moreItems = getFieldNames('moreitems',container),
		 formItems = [],
		 topItemsPref = [],
		 moreItemsPref = [],
		 topItemsRem = [],
		 moreItemsRem = [],
		 recievedItem = false,
		 persFlag = false,
		 formClone = null,
		 formOrig = null,
		 connector = '.topitems',
		 host = xenos.context.path,
		 screenId = $('[name=screenId]').val(),
		 versionNo = $('[name=versionNo]').val();

		 // communication handler
		 var handler = xenos$Handler$function({
			 get: {
				 requestType: xenos$Handler$default.requestType.asynchronous,
				 target: function(e) {
					 return ('#content');
				 }
			 },
			 settings: {
				 beforeSend: function(request) {
					 request.setRequestHeader('Accept', 'text/html;type=ajax');
				 },
				 type: 'POST'
			 }
		 });
		 /*
		This function checks whether the mandatory fields are not empty
		while saving the query from Query Criteria Screen. If any of the
		mandatory field is empty then an informative message is shown.
		  */
		 function mandatoryFieldCheck(){
			 var infoMessage = [];
			 $.each($('.required'),function(ind,el){
				 var fieldName =  $(el).html();
				 var fieldVal = $(el).closest('.formItem').find('select,input').val();
				 if($.trim(fieldVal) == ""){
					 infoMessage.push(xenos.utils.evaluateMessage(xenos.i18n.utilcommonvalidationmessage.mandatoryfield_empty,[fieldName]));
				 }
			 })
			 return infoMessage;
		 }
		 /*
		 This function checks whether the sort fields are duplicately
		 specified for the save query. If there is one or more than 
		 one pair of duplicate sort fields, then an informative message
		 is shown.
		  */
		 function duplicateSortFieldCheck(){
			 var infoMessage = "";
			 var flag = false;
			 var sortFieldValueList = [];
			 $.each($('.orderCount'),function(ind,el){
				 var fieldVal = $(el).closest('.formItem').find('select,input').val();
				 for(var i = 0; i<sortFieldValueList.length; i++){
					 if(sortFieldValueList[i] != "" && sortFieldValueList[i] == fieldVal){
						 flag = true;
					 }
				 }
				 if(flag){
					 infoMessage = xenos.i18n.utilcommonvalidationmessage.duplicate_sort_criteria;
					 return infoMessage;
				 }else{
					 sortFieldValueList.push(fieldVal);
				 }
			 })
			 return infoMessage;
		 }

		 /* Save Query */
		 function querySave(e) {
			 e.preventDefault();	
			 var mandatoryFieldCheckInfoMsg = mandatoryFieldCheck();
			 var duplicateSortFieldInfoMsg = duplicateSortFieldCheck();
			 if(mandatoryFieldCheckInfoMsg == "" && duplicateSortFieldInfoMsg == ""){
				 jPrompt('Saved Criteria name?', '', null, function(name){
					 if(name === null){
						 return;
					 }
					 name = $.trim(name);
					 var maxLength = 30;
					 if(name.length > maxLength) {
						 xenos.postNotice(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos.i18n.message.invalid_namelength,[maxLength]));
						 return;
					 }
					 if (name != null && name != '') {
						 var form = $('#queryForm');
						 var commandFormId = '.json?commandFormId=' + $('[name=commandFormId]').val();
						 var fragmentName = '&fragments=content';
						 var saveCriteria = '&criteria=save';
						 //var criteriaName = '&criteriaName=' + name;

						 //form.attr("criteriaName",name);
						 $('[name=criteriaName]').val(name);

						 $.ajax({
							 type: "POST",
							 //url: encodeURI(form.attr('action') + commandFormId + fragmentName + saveCriteria + criteriaName),
							 url: host + encodeURI(form.attr('action') + commandFormId + fragmentName + saveCriteria),
							 data: form.serialize(),
							 beforeSend: function (req) {
								 req.setRequestHeader("Accept", "application/json;type=ajax");
							 },
							 success: function (jqXHR) {
								 //jAlert('Query Saved', null);
								 if(jqXHR.success == false){
									 xenos.postNotice(xenos.notice.type.error, jqXHR.value);
								 }else{
									 xenos.postNotice(xenos.notice.type.info, xenos.i18n.message.query_saved);
								 }
							 }
						 });
					 }else {
						 xenos.postNotice(xenos.notice.type.info, xenos.i18n.utilcommonvalidationmessage.provide_criteria);
					 }
				 });
			 }else{
				 if(mandatoryFieldCheckInfoMsg != ""){
					 xenos.postNotice(xenos.notice.type.info, mandatoryFieldCheckInfoMsg);	
				 }
				 if(duplicateSortFieldInfoMsg != ""){
					 xenos.postNotice(xenos.notice.type.info, duplicateSortFieldInfoMsg);
				 }
			 }
		 }

		 /*Reset Form*/
		 function resetQueryPage(e){
			 e.preventDefault();

			 if($(this).parents(".ui-dialog").size()>0){
				 container = $(this).closest(".ui-dialog-content");
				 isDialog = true;
			 }else{
				 container = $("#content");
			 }

			 var form = $('#queryForm',container);
			 var commandFormId = '?commandFormId=' + $('[name=commandFormId]',container).val();
			 var fragmentName = '&fragments=content';

			 beforeReset();

			 /*Reset Special Fields
			  *   TODO: Remove Special fields reset as it is going to be a server side reset.
			  * */
			 //$('.ui-multiselect-input .ui-icon-close',container).trigger('click');

			 handler.generic(undefined,{
				 requestUri: host + form.attr('resetAction')+commandFormId + fragmentName,
				 onHtmlContent: function(e, options, $target, content) {
					 //Do Nothing
				 },
				 settings: {
					 complete : function(jqXHR,textStatus){
						if(jqXHR.status === 999) {
							return;
						}
						 container.html(jqXHR.responseText);
						 //during reset if xenos$onReady is not defined then invoke this for the particular page
						 //call on load methods
						 if (typeof xenos$onReady !== 'undefined') {
							 xenos$onReady.call(this);
							 xenos$onReady = function(){};
						 }
					 }
				 }
			 });
		 }

		 /* Submit Form Handler */
		 function submitFormHandler(e){
			 var btn = $(e.target);
			 var isDialog = false;
			 // handle for main query screen and saved query screen
			 var container;
			 if($(this).parents(".ui-dialog").size()>0){
				 container = $(this).closest(".ui-dialog-content");
				 isDialog = true;
			 }else{
				 container = $("#content");
			 }

			 var duplicateSortFieldInfoMsg = duplicateSortFieldCheck(); 			
			 if(duplicateSortFieldInfoMsg != ""){
				 xenos.postNotice(xenos.notice.type.info, duplicateSortFieldInfoMsg);
				 return false;
			 }

			 disableFormButtons(e);
			 xenos.utils.clearGrowlMessage();
			 e.preventDefault();
			 var form = $('#queryForm',container);
			 var commandFormId = '?commandFormId=' + $('[name=commandFormId]',container).val();
			 var fragmentName = '&fragments=content';
			 
			 var $cache = $('div#footer>div#xenos-cache-container>span#cache');
			 var menu_pk = $cache.data('menuPk');
             $cache.removeData();
             $cache.data('menuPk',menu_pk);

			 handler.generic(undefined,{
				 requestUri: host + form.attr('action')+commandFormId + fragmentName,
				 onHtmlContent: function(e, options, $target, content) {
					 //Do Nothing
				 },
				 settings: {
					 data : form.serialize(),
					 complete : function(jqXHR,textStatus){
						 enableFormButtons(e);
						 if(jqXHR.status == 408){
							 return;
						 }
						 if(jqXHR.status == 999){
							 return;
						 }
						 $('.result-tab',container).addClass('active');
						 container.html(jqXHR.responseText);
						 if(isDialog){
							 $('#formContainer').removeClass('paddingFour');
							 if ($('#queryForm',container).length == 0) {
								 //add action url value in container
								 container.attr('action',$('#queryResultForm',container).attr('action'));
								 container.attr('preaction',$('#queryResultForm',container).attr('preaction'));
								 var filter=grid_result_settings.pagingInfo.filter;
								 if(typeof filter === 'undefined'){filter=false;}
								 var collapseExpandFunction=grid_result_settings.onClickCallbackHandler;
								 if(typeof collapseExpandFunction === 'undefined'){collapseExpandFunction=false;}
								 var disablePagingInfo = false;
								 if(grid_result_settings.pagingInfo.disable === true){disablePagingInfo=true;}
								 //Grid Settings for Opening result screen in a dialog
								 var gridsettings = {
										 enableToolbar:true,
										 consolidateActionFlag:false,
										 onClickCallbackHandler:collapseExpandFunction,
										 buttons:{
											 print:true,	
											 xls:true,	
											 pdf:true,	
											 columnPicker:false,	
											 save:false
										 },
										 pagingInfo:{
											 isNext : grid_result_settings.pagingInfo.isNext,
											 filter : filter,
											 disable:disablePagingInfo
										 },
										 urls:grid_result_settings.urls,
										 yOffset:90,
										 height:$('#dashboard').innerHeight(),
										 isDialog:true
								 };
								 $('.xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, gridsettings);					
							 }
						 }else{
							 // Close the error message when user move to other page
							 $.each($('#growlDock .growlBox'),function(ind,el){
								 $(el).find('#growlBoxClose').trigger('click');
							 });
							 //Chek the return page if return page equal query result then render grid.
							 if ($('#queryForm',container).length == 0) {
								 $('#queryResultForm .tabs .active',container).addClass('result-tab');
								 $('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
							 }
						 }
					 }
				 }
			 });
		 }

		 /* Submit Form */
		 function submitForm(e) {
			 e.preventDefault();
			 if(beforeSubmit && !beforeSubmit()) return false;
			 if(persFlag === false){
				 submitFormHandler(e);
			 }
		 }
		 /* Disable Form Buttons */
		 function disableFormButtons(e) {
			 $(e.target).attr('disabled', 'disabled');
			 $('.resetBtn','#content').find('.inputBtnStyle').attr('disabled', 'disabled');
			 $('.persBtn','#content').find('.inputBtnStyle').attr('disabled', 'disabled');
			 $('#qrySave','#content').attr('disabled', 'disabled');
			 $('.backBtn','#content').find('.inputBtnStyle').attr('disabled', 'disabled');
		 }
		 /* Enable Form Buttons */
		 function enableFormButtons(e) {
			 $(e.target).removeAttr('disabled');
			 $('.resetBtn','#content').find('.inputBtnStyle').removeAttr('disabled');
			 $('.persBtn','#content').find('.inputBtnStyle').removeAttr('disabled');
			 $('#qrySave','#content').removeAttr('disabled');
			 $('.backBtn','#content').find('.inputBtnStyle').removeAttr('disabled');
		 }
		 /* load previous Form */
		 function loadPreviousForm(e) {
			 var btn = $(e.target);
			 var isDialog = false;
			 // handle for main query screen and saved query screen
			 var container;
			 if($(this).parents(".ui-dialog").size()>0){
				 container = $(this).closest(".ui-dialog-content");
				 isDialog = true;
			 }else{
				 container = $("#content");
			 }
			 $(e.target).attr('disabled', true);
			 e.preventDefault();
			 var form = $('#queryForm',container);
			 var commandFormId = '?commandFormId=' + $('[name=commandFormId]',container).val();
			 var fragmentName = '&fragments=content';
			 $.ajax({
				 type: "POST",
				 url: xenos.context.path + form.attr('preaction') + commandFormId + fragmentName,
				 data: form.serialize(),
				 beforeSend: function (req) {
					 req.setRequestHeader("Accept", "text/html;type=ajax");
				 },
				 complete: function (jqXHR) {
					 btn.removeAttr('disabled');
					 $('.result-tab',container).addClass('active');
					 container.html(jqXHR.responseText);
					 //if(btn.parents(".ui-dialog").size()>0){
					 if(isDialog){
						 $('#formContainer').removeClass('paddingFour');
						 if ($('#queryForm',container).length == 0) {
							 //add action url value in container
							 container.attr('action',$('#queryResultForm',container).attr('action'));
							 container.attr('preaction',$('#queryResultForm',container).attr('preaction'));
							 var filter=grid_result_settings.pagingInfo.filter;
							 if(typeof filter === 'undefined'){filter=false;}
							 var collapseExpandFunction=grid_result_settings.onClickCallbackHandler;
							 if(typeof collapseExpandFunction === 'undefined'){collapseExpandFunction=false;}
							 var disablePagingInfo = false;
							 if(grid_result_settings.pagingInfo.disable === true){disablePagingInfo=true;}
							 //container.html($('#queryResultForm',container).html());
							 //Grid Settings for Opening result screen in a dialog
							 var gridsettings = {
									 enableToolbar:true,
									 consolidateActionFlag:false,
									 onClickCallbackHandler:collapseExpandFunction,
									 buttons:{
										 print:true,	
										 xls:true,	
										 pdf:true,	
										 columnPicker:false,	
										 save:false
									 },
									 pagingInfo:{
										 isNext : grid_result_settings.pagingInfo.isNext,
										 filter : filter,
										 disable:disablePagingInfo
									 },
									 urls:grid_result_settings.urls,
									 yOffset:90,
									 height:$('#dashboard').innerHeight(),
									 isDialog:true
							 };
							 $('.xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, gridsettings);					
						 }
					 }else{
						 //Chek the return page if return page equal query result then render grid.
						 if ($('#queryForm',container).length == 0) {
							 $('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
						 }
					 }
				 }
			 });
		 }
		 //Error Message Handler
		 function handleError(response){
			 if($('.xenosError').length !=0){
				 xenos.postNotice(xenos.notice.type.error, xenos.utils.getErrorMessage(container.closest('#queryForm')), true);
			 }
		 }

		 /*Returns difference between two arrays, should be included in the utils*/
		 /* Not used to be removed in future releases */
		 function arrayDiff(fullset, partialset) {
			 return jQuery.grep(fullset, function (item) {
				 return jQuery.inArray(item, partialset) < 0;
			 });
		 }

		 function saveHandler(save){
			 if (save) {
				 // save
				 savePref();
			 } else {
				 // do nothing
			 }
		 }

		 function enableSave(ev,ui){
			 if(($('.topitems .formItem').length ===0 || $('.moreitems .formItem').length ===0) && !($('.moreitems').length ===0)){
				 $(this).sortable('cancel');
				 xenos.postNotice('info',xenos.i18n.utilcommonvalidationmessage.minimum_item);
				 return;
			 }else{
				 $('.savePref input').removeAttr('disabled');
				 $('#content').saverOn(saveHandler);
			 }
		 }

		 function disableSave(){
			 $('.savePref input').attr('disabled','true');
			 $('#content').saverOff(saveHandler);
		 }

		 function disableReset() {
			 $('.resetPref input').attr("disabled", "true");
			 $('#content').saverOff(saveHandler);
		 }

		 function enableReset(ev, ui) {
			 if (($('.topitems .formItem').length === 0 || $('.moreitems .formItem').length === 0)
					 && !($('.moreitems').length === 0)) {
				 $(this).sortable('cancel');
				 return;
			 } else {
				 enablePrefReset();
			 }
		 }

		 function enablePrefReset() {
			 $('.resetPref input').removeAttr('disabled');
		 }

		 /* Return Array of names of all the fields present within the className */
		 function getFieldNames(className){
			 var fieldNames = [],
			 selectorString = '.'+className+' [name]';
			 $.each($(selectorString,container), function (index, el) {
				 fieldNames.push($(el).attr('name'));
			 });
			 return fieldNames;
		 }

		 /* Method is executed whenever a draggable field from the delete zone is dropped anywhere*/
		 function dragStop(ev, ui) {
			 if (recievedItem === true) {
				 recievedItem = false;
				 $(this).remove();
			 }
		 }
		 /* Method is executed when you start dragging a draggable field from the delete zone */
		 function dragStart() {
			 $(this).addClass('added-now');
		 }

		 /* returns the parameter required, when making a set of elements draggable */
		 function getDraggableArgs(connector) {
			 return {
				 revert: "invalid",
				 helper: 'clone',
				 containment: '.formContent',
				 //connector,
				 connectToSortable: connectWith,
				 appendTo: '.tmp-drag-holder',
				 scroll: false,
				 zIndex: 99999,
				 stop: dragStop,
				 start: dragStart
			 };
		 }

		 function restoreAllItems(e){
			 $(this).parent().find('.restore').trigger('click');
			 if(typeof Xenos$Restore$PostHook === 'function') {
				 Xenos$Restore$PostHook.call(this,e);
			}

		 }



		 function manageDelItemsBox() {
			 if ($('.deltopitems',container).children().size() == 2) {
				 $('.deltopitems',container).hide();
			 } else {
				 $('.deltopitems',container).show();
			 }
			 if ($('.delmoreitems',container).children().size() == 2) {
				 $('.delmoreitems',container).hide();
			 } else {
				 $('.delmoreitems',container).show();

			 }
		 }

		 //Handler, called when restore icon is clicked on any element.
		 function restoreFormItem(ev) {
			 ev.stopPropagation();
			 var formItem = $(ev.target).closest('.formItem');
			 var formItemClone = formItem.clone();
			 if (formItem.parent().is('.delmoreitems')) {
				 connector = '.moreitems';
				 formItemClone.insertBefore('.moreitems .clear-block',container);
			 } else {
				 connector = '.topitems';
				 var elContainer = container.find('.topitems .clear-block',container);
				 formItemClone.insertBefore(elContainer);
			 }
			 formItemClone.removeAttr('style');
			 $('.restore', formItemClone).removeClass('restore').addClass('remove').attr('title', 'Remove this field');
			 formItem.remove();
			 setRemoveHoverState();
			 manageDelItemsBox();
			 enableSave();
		 }

		 //Henadler, called when remove icon is clicked on any element.
		 function removeFormItem(ev) {
			 ev.stopPropagation();
			 var formItem = $(ev.target).closest('.formItem');
			 var formItemClone = formItem.clone();
			 /* Flag to detect if the form item can be removed or not. */
			 var allowRemove = false;
			 if ($(ev.target).hasClass('typemore')) {
				 //Check if only one item exists
				 if($('.moreitems .formItem').length === 1){
					 xenos.postNotice('info',xenos.i18n.utilcommonvalidationmessage.minimum_item);
				 }else{
					 allowRemove = true;
					 connector = '.moreitems';
					 formItemClone.insertBefore('.delmoreitems .clear-block',container);
				 }
			 } else {
				 //Check if only one item exists
				 if($('.topitems .formItem:visible').length === 1){
					 xenos.postNotice('info',xenos.i18n.utilcommonvalidationmessage.minimum_item);
				 }else{
					 allowRemove = true;
					 connector = '.topitems';
					 formItemClone.insertBefore('.deltopitems .clear-block',container);
				 }
			 }
			 if(allowRemove === true){
				 formItemClone.draggable(getDraggableArgs(connector));
				 $('.remove', formItemClone).removeClass('remove').addClass('restore').attr('title', 'Restore this field');
				 formItem.remove();
				 manageDelItemsBox();
				 enableSave();
			 }
		 }

		 function addFormItem(el) {
			 var formItem = $(el).closest('.formItem');
			 var cloneFormItem = formItem.clone(true);
			 formItem.replaceWith(cloneFormItem);
			 $('.topitems .restore,.moreitems .restore', '.formItemArea').removeClass('restore').addClass('remove');
			 if(cloneFormItem.parent().hasClass('moreitems')){
				 $('span',cloneFormItem).addClass('typemore');
			 }else{
				 $('span',cloneFormItem).removeClass('typemore');
			 }
			 $('.added-now').removeClass('.added-now');
		 }

		 function swapElements() {
			 $.each($('.formItem', container), function (index, el) {
				 var itemName = $('input,select', el).attr('name');
				 var origItem = $('[name="' + itemName + '"]', formOrig).closest('.formItem').detach();
				 if (origItem.size() > 0) {
					 $(el).replaceWith(origItem);
				 }
			 });
			 $('.topitems,.moreitems').sortable("destroy");
			 submitState();
		 }

		 //Clearing all input fields in the delete section
		 function clearDeltItemInputs(){
			 //Handling Special Multiselect input fields
			 $('.delmoreitems,.deltopitems').find('.ui-multiselect-item .ui-icon-close').trigger('click');

			 $('.delmoreitems,.deltopitems').find(':input').each(function() {
				 switch(this.type) {
				 case 'password':
				 case 'select-multiple':
				 case 'select-one':
				 case 'text':
				 case 'textarea':
					 $(this).val('');
				 case 'checkbox':
				 case 'radio':
					 this.checked = false;
				 }
			 });
		 }
		 function submitState() {
			 $('.deltopitems,.delmoreitems').hide();
			 $('.persBtn input').removeAttr('disabled');
			 //List of elements after changes.
			 var topItemsUp = [],
			 moreItemsUp = [];
			 $.each($('.topitems [name]'), function (index, el) {
				 topItemsUp.push($(el).attr('name'));
			 });
			 $.each($('.moreitems [name]'), function (index, el) {
				 moreItemsUp.push($(el).attr('name'));
			 });
			 $('.formItem .remove').hide();
			 $('.formItemBlock').removeClass('xenos-sort-enabled');
			 $('.formItemBlock input,.formItemBlock select').removeAttr('disabled');
			 $('.prefBtnBlock').hide();
			 $('.formBtnBlock').show();
			 $('#qrySave').show();



			 //Handling of icons
			 $('.topitems .restore,.moreitems .restore').removeClass('restore').addClass('remove');
			 $('.remove', '.topitems,.moreitems').hide();

			 //Clearing Deleted Items
			 clearDeltItemInputs();
		 }

		 function resetPref(e) {
			 e.preventDefault();
			 var form = $('#queryForm', container);
			 var commandFormId = '?commandFormId=' + $('[name=commandFormId]', container).val();
			 var fragmentName = '&fragments=content';
			 var resetPrefUrl = host + '/secure/ref/personalized/user/screenconfig/queryscreen/reset.json';
			 jConfirm(xenos.i18n.message.reset_your_preference, null, function(confirmation) {
				 if (confirmation) {
					 xenos.utils.removePreference(resetPrefUrl, screenId, versionNo, function(data, textStatus,  jqXHR) {
						if(jqXHR.status === 999) {
							return;
						}
						 if(!data.success) {
							 xenos.postNotice('error',xenos.i18n.message.preference_reset_error);
							 return;
						 } else {	
							 xenos.postNotice('success', xenos.i18n.message.preference_reset_message);
							 disableSave();
							 swapElements();
							 if ($(this).parents(".ui-dialog").size() > 0) {
								 container = $(this).closest(".ui-dialog-content");
								 isDialog = true;
							 } else {
								 container = $("#content");
							 }
							 var form = $('#queryForm', container);
							 var commandFormId = '?commandFormId=' + $('[name=commandFormId]', container).val();
							 var fragmentName = '&fragments=content';
							 handler.generic(undefined, {
								 requestUri: host + form.attr('resetPrefAction') + commandFormId + fragmentName,
								 onHtmlContent : function(e, options, $target, content) {
									 if (content.success === false) {
										 xenos.postNotice(xenos.notice.type.error, content.value[0], true);
									 } else {
										 container.html(content);
									 }
								 }
							 });
						 }
					 });				
				 }
			 });           
		 }

		 function savePref() {
			 var prefDetails = xenos.utils.encodeValue({
				 topItems: getFieldNames('topitems'),
				 moreItems: getFieldNames('moreitems'),
				 delTopItems:getFieldNames('deltopitems'),
				 delMoreItems:getFieldNames('delmoreitems')
			 });
			 var savePrefUrl = host + '/secure/ref/personalized/user/screenconfig/queryscreen/save.json?';
			 xenos.utils.savePreference(prefDetails, savePrefUrl, screenId, versionNo,function(data, textStatus,  jqXHR){
				if(jqXHR.status === 999) {
					return;
				}
				 if(!data.success){
					 xenos.postNotice('error',data.value);
					 return;
				 }
				 xenos.postNotice('success',xenos.i18n.message.preference_save_message);
				 swapElements();
				 topItemsPref = getFieldNames('topitems');
				 moreItemsPref = getFieldNames('moreitems');
				 $('.topitems .formItem,.moreitems .formItem').removeAttr('style');
				 disableSave();
				 enableReset();
				 persFlag = false;
				 if(options && $.isFunction(options.afterRendering)){
					 options.afterRendering(container.closest('#queryForm'));
				 }
				 applyTabIndex();
				 $('input,select','.formItemArea' ).first().focus();
			 });
		 }

		 function openForm(errorFlag){
			 $('.formContent').show();
			 $('input,select','.formItemArea' ).first().focus();
			 $('.formItem .remove','.moreitems,.delmoreitems').addClass('typemore');
			 handleError();
			 updateFields();

			 if(options && $.isFunction(options.afterRendering)){
				 options.afterRendering(container.closest('#queryForm'));
			 }
			 // initSortCriteria();
			 setMenuPkInCache();
			 if(errorFlag) {
				 $(".formContent :input").prop("disabled", true);
			 }
		 }

		 function setMenuPkInCache() {
			 var $cache = $('div#footer>div#xenos-cache-container>span#cache');
			 $cache.data('menuPk',$('#queryForm').find('#menuPk').val());
		 }

		 function loadPref() {
			 //Do some checks if no data in pref then do not reset form
			 // Read data from Pref.
			 xenos.loadScript([{path: xenos.context.path + '/scripts/ref/xenos-preferences.js'}, 
			                   {path: xenos.context.path + '/scripts/xenos.more.js'}], {
				 success: function() {	    	
					 $.ajax({
						 url: host + '/secure/ref/personalized/user/screenconfig/queryscreen/load/' + screenId + '/'+versionNo+'.json?&',
						 type: 'GET',
						 error: function () {
							 openForm(true);
						 },
						 success: function (data) {
							 if(data.success){
								 var contents = xenos.utils.decodeValue(data.value);
								 if (contents) {
									 //needs improvement
									 for (i in contents.topItems) {
										 topItemsPref.push(contents.topItems[i]);
									 }
									 for (i in contents.moreItems) {
										 moreItemsPref.push(contents.moreItems[i]);
									 }
									 for (i in contents.delTopItems) {
										 topItemsRem.push(contents.delTopItems[i]);
									 }
									 for (i in contents.delMoreItems) {
										 moreItemsRem.push(contents.delMoreItems[i]);
									 }
									 resetForm(data.userPreferenceExists, data.enterprisePreferenceExists);
									 clearDeltItemInputs();
									 enableReset();
								 }
								 openForm(false);
								 //enable toggling for more items
								 container.xenosmore({mode:'query'});
							 } else {
								 openForm(true);
							 }
						 }
					 });
				 }
			 });
		 }

		 function delButtonHandler(e) {
			 $('.deltopitems .formItem').draggable(getDraggableArgs('.topitems'));
			 $('.delmoreitems .formItem').draggable(getDraggableArgs('.moreitems'));
		 }

		 function resetForm(userPrefExists, entPrefExists) {
			 //Keep the form top/more items in the variable but do not Detach them here.
			 var formTopItems = $('.topitems .formItem', container);
			 var formMoreItems = $('.moreitems .formItem', container);

			 //formItems are the application level items & topItemsPref are the merged items of user and enterprise level preference
			 //hence No. of formItems >= topItemsPref
			 //Hence if there is no enterprise level preference but has user level preference, 
			 //then we need to pick the extra formItem(s) from application level which are not in topItemsPref
			 var extraApplicationFormTopItems=[];
			 var extraApplicationFormMoreItems=[];

			 if(userPrefExists && !entPrefExists){
				 $.each(formTopItems, function (index, el) {
					 var elemName = $.trim($('[name]', formTopItems[index])[0].name);
					 if($.inArray(elemName, topItemsPref) < 0 && $.inArray(elemName, moreItemsPref)  < 0 && $.inArray(elemName, topItemsRem)  < 0 && $.inArray(elemName, moreItemsRem) < 0){
						 extraApplicationFormTopItems.push(el);
					 }
				 });
				 $.each(formMoreItems, function (index, el) {
					 var elemName = $.trim($('[name]', formMoreItems[index])[0].name);
					 if($.inArray(elemName, moreItemsPref) < 0 && $.inArray(elemName, topItemsPref) < 0 && $.inArray(elemName, moreItemsRem) < 0 && $.inArray(elemName, topItemsRem) < 0){
						 extraApplicationFormMoreItems.push(el);
					 }
				 });
			 }

			 //Now Detach All Elements from the form
			 formItems = $('.topitems .formItem,.moreitems .formItem,.deltopitems .formItem,.delmoreitems .formItem',container).detach();
			 var extraTopItems = $('.topitems',container).children().detach();
			 var extraMoreItems = $('.moreitems',container).children().detach();
			 $.each(topItemsPref, function (index, el) {
				 $('[name=' + el + ']', formItems).closest('.formItem').appendTo($('.topitems',container));
			 });
			 $('.topitems',container).append(extraTopItems);
			 $.each(moreItemsPref, function (index, el) {
				 $('[name=' + el + ']', formItems).closest('.formItem').appendTo($('.moreitems',container));
			 });
			 $('.moreitems',container).append(extraMoreItems);
			 //Prepare Preference Deleted Items Container
			 var extraTopItemsRem = $('.deltopitems',container).children().detach();
			 var extraMoreItemsRem = $('.delmoreitems',container).children().detach();
			 $.each(topItemsRem, function (index, el) {
				 $('[name=' + el + ']', formItems).closest('.formItem').appendTo($('.deltopitems',container));
			 });
			 $.each(moreItemsRem, function (index, el) {
				 $('[name=' + el + ']', formItems).closest('.formItem').appendTo($('.delmoreitems',container));
			 });

			 $('.deltopitems',container).append(extraApplicationFormTopItems).append(extraTopItemsRem);
			 $('.delmoreitems',container).append(extraApplicationFormMoreItems).append(extraMoreItemsRem);
		 }

		 function cancelPref() {
			 persFlag = false;
			 container.html(formOrig);
			 //container.find('.formItemArea').append(formOrig);			
			 submitState();
			 disableSave();
			 //disableReset();
		 }

		 function disable() {
			 disableSave();
			 disableReset();
		 }

		 function personalize(ev) {
			 persFlag = true;
			 formClone = container.children().clone();
			 formOrig = container.children().detach();
			 container.append(formClone).find('.topitems,.moreitems').sortable({
				 placeholder: "field-state-highlight",
				 items: '.formItem',
				 connectWith: connectWith,
				 stop: function (ev, ui) {
					 recievedItem = true;
					 addFormItem(ev.target);
					 ev.stopPropagation();
				 },
				 update:enableSave
			 });

			 var el = $(ev.target);
			 var	formActionArea = el.closest('#formActionArea');
			 el.attr('disabled', true);
			 delButtonHandler();
			 $('.deltopitems,.delmoreitems',container).show();
			 delButtonHandler();
			 container.find('.formItem .remove', '.topitems,.moreitems').show();
			 $('.topitems,.moreitems',container).sortable("enable");
			 $('.formItemBlock',container).addClass('xenos-sort-enabled');
			 $('.formItemBlock input,.formItemBlock select',container).attr('disabled', true);
			 //Disbale Multiselect : Special Case as Multiselect is not a normal form input		
			 $('[multiple="multiple"]', container).closest('.formItem').addClass('disabled');
			 container.find('input,select', formOrig).attr('disabled', true);

			 $('.deltopitems .remove,.delmoreitems .remove',container).show().removeClass('remove').addClass('restore');
			 formActionArea.find('.prefBtnBlock').show();
			 formActionArea.find('.formBtnBlock').hide();
			 formActionArea.find('#qrySave').hide();
			 manageDelItemsBox();

			 //Enable Restore All button
			 //$('.restoreAllBtn').removeAttr('disabled');
			 container.parent().find('.restoreAllBtn').removeAttr('disabled').bind('click',restoreAllItems);

			 //enable toggling for more items
			 container.xenosmore({mode:'query', applyFor:'personalization'});
			 
			 /* fix for restore button position should be at first always */
			  $('.delFormItems').each(function(){
				  if($(this).children('.formItem.ui-draggable').length > 0){
					var restoreBtn = $(this).children('input.restoreAllBtn');
					$(this).prepend(restoreBtn);
				 }
			  });
		 }

		 function setRemoveHoverState() {
			 $('span.remove').bind('mouseenter', function () {
				 $(this).parent(".formItem").css('background', '#ec8d7e');
			 }).bind('mouseleave', function () {
				 $(this).parent(".formItem").removeAttr('style');
			 }).bind('click', function () {
				 $(this).parent(".formItem").removeAttr('style');
			 });
		 }

		 function applyTabIndex() {
			 var ctx = '#content';
			 var inclusionList = 'input, select, .ui-multiselect-input, textarea, button, submit';
			 var exclusionList = 'input[type=hidden], input[tgt], .ui-datepicker-trigger, .treeInitBtnIco, .treeResetBtnIco';

			 $(inclusionList, ctx).not(exclusionList).each(function(i) {
				 var $input = $(this);
				 $input.attr("tabindex", i+1);
			 });
		 }

		/*
		* Function to filter next available items in the sort field based on the selected item.
		*/
		 /*
		 function filterSortList(e) {
			 var selectedValue = $(e.target).val();
			 var dropDowns = $(e.target).parents('.formSortArea .formItem').nextAll().find('select');
			 // var firstSelect = $(e.target).parents('.formItem').nextAll().find('select').first();
		      
		      var currentValueArray = [];
		      dropDowns.each(function(idx, field) {
		    	  if($.trim($(field).val()).length > 0){
		    		  currentValueArray.push($(field).val());
		    		  }
		    	  });
		      
		      $(this).data('options', container.parent().find('.formSortArea #sortField1').find('option').clone());
		      var str = new Array();
		      var selected = $(e.target).parents('.formSortArea .formItem').prevAll().find("select option:selected");
		      selected.each(function () {
		    	  if($(this).val() !== '') {
		    		  str.push($(this).val());
		    		  }
		    	  });
		      str.push($(this).val());
		      
		      var options = $(this).data('options').filter(function() {
		    	  return $.inArray(this.value,str) == -1;
		    	  });
		      
		      dropDowns.children().remove();
		      options.each(function() {
		    	  dropDowns.append(this);
		    	  });
		      
		      dropDowns.each(function(index, field){
		    	  $(field).val(currentValueArray[index] == selectedValue ? '' : currentValueArray[index]);
		      });
		      
		 }
		 */
		 


		 // var sortFieldOptions = [];

		 /*
		 function initSortCriteria() {
			 var sortFieldCtx = $(container).parent().find('.formSortArea');
			 var sortFieldArray = $(sortFieldCtx).find('select');  // Init sort field array

			 sortFieldArray.each(function(fieldIndex, sortField) {
				 var options = $(sortField).find('option');

				 if(sortFieldOptions.length == 0) {
					 sortFieldOptions = options; 
				 }				

			 });
		 }
		 */

		 var _xenosForm = container.data('xenosForm');
		 if(!_xenosForm){
			 container.data('xenosForm',true);
			 $(function () {
				 xenos.loadScript([
				                   {path: xenos.context.path + '/scripts/xenos-utils.js'},
				                   {path: xenos.context.path + '/scripts/xenos-hotkeys.js'},
				                   {path: xenos.context.path + '/scripts/xenos-windowmanager.js'},
				                   {path: xenos.context.path + '/scripts/xenos-detail-dialog.js'}
				                   ], {
					 success: function() {
						 if(container.parents('#queryForm').find('#resultVisited').val() === 'true') {
							 container.parents('#queryForm').find('.tabs .result-tab').addClass('visited');
						 }
						 $(document).on('tabIndex', applyTabIndex);
						 loadPref();
						 //Binding Button Handlers
						 if(container.closest('.ui-dialog').length > 0){
							 container.parent().find('.remove,.restore,.savePref,.cancelPref,.resetPref,#qrySave,.persBtn,.deltopitems,.delmoreitems').remove();
						 }else{
							 //Adding restore/remove event handlers
							 $('.formItem .remove').die().live('click', removeFormItem);
							 $('.deltopitems .restore,.delmoreitems .restore').die().live('click', restoreFormItem);
						 }
						 container.parent().find('.persBtn').find("input[disabled!='disabled']").bind('click', personalize);
						 container.parent().find('.submitBtn').find("input[disabled!='disabled']").bind('click', submitForm);
						 container.parent().find('.backBtn').bind('click', loadPreviousForm);
						 container.parent().find('.resetBtn').find("input[disabled!='disabled']").bind('click', resetQueryPage);
						 container.parent().find('.savePref input').bind('click', savePref);
						 container.parent().find('.cancelPref input').bind('click', cancelPref);
						 container.parent().find('.resetPref input').bind('click', resetPref);
						 container.parent().find("input[id='qrySave'][disabled!='disabled']").bind('click',querySave);
						 // container.parent().find('.formSortArea .sortItems').find('select').bind('change',filterSortList);
						 container.closest('#queryForm').find('.formTabErrorIco').unbind('click');
						 container.closest('#queryForm').find('.formTabErrorIco').bind('click', handleError);
						 container.parent().find('div.formItemBlock.more').hide();
						 setRemoveHoverState();

						 //Set the screen title on title bar of the browser 
						 //when we open a query screen in new tab then queryFormTitleText is not resolved from response; so we resolve the element when it will be rendered
						 $('.applicationTitle:first ').text($('.queryFormTitleText:first h1').text());

						 //Assigning shortcuts for form items
						 xenos.utils.afterFormRenderScuts();
						 
						 /*
						 if($('.formSortArea .formItem').find('select').length > 0) {
							 $('.formSortArea .formItem').find('select').each(function(){
								 $(this).trigger('change');
							 });
						 }
						 */
					 }
				 });
			 });
		 }

	 };

 }(jQuery));