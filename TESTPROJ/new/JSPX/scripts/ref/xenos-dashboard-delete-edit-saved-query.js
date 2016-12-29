//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
// Object
function xenos$DBD$DeleteSavedQuery(parent) {
	// self
	var self = this;
	// Self object
	self.object = parent;
	// feeds
	this.feeds = {};
	this.feedByPk = function(pk) {
		return self.feeds[pk];
	};
	this.rerenderRequired = false;
	// feeds
	this.changedFeeds = {};
	this.changedFeedsByPk = function(pk) {
		return self.changedFeeds[pk];
	};
	// Prepare the Markup for saved query list
	this.prepareMarkup = function (json){
		var markup = '';
		markup +='<div class="savedQueryDialog">'
				+'	<div class="savedQueryHolder">'
				+'		<div class="clear"></div>'
				+'			<div class="scrollable">';
		self.feeds = [];
		jQuery.each(json.value, function(order, feed) {
			self.feeds[feed.pk] = feed.name;
			var escapedName = self.object.escapeHtml(feed.name);
			markup +='<div class="row">'
					+'	<div class="savedQuery">'
					+'		<div class="savedQueryName" ><span id="queryName" title="'+escapedName+'">'+escapedName+'</span></div>'
					+'		<span style="display:none;"><input class="editSavedQueryName" maxlength="30" type="text" value="'+escapedName+'" feedPk="' + feed.pk + '" id="editedName"/></span>'
					+'		<div class="saveIconHolder" style="display:none;"><span class="saveIcon" feedPk="'+feed.pk+'" feedName="'+escapedName+'" title="Save this query">Q</span></div>'
					+'		<div class="editIconHolder"><span class="editIcon" feedPk="'+feed.pk+'" feedName="'+escapedName+'" title="Edit this query">Y</span></div>'
					+'		<div class="deleteIconHolder"><span class="deleteIcon" feedPk="'+feed.pk+'" title="Delete this query">h</span></div>'
					+'		<div class="clear"></div>'
					+'	</div>'
					+'	<div class="bar"></div>'
					+'</div>';
					
		});
		markup +='    </div>'
				+'  </div>'
				+'</div>';
		return markup;
	};
	this.onButtonHover = function($target){
		$target.off('mouseenter mouseleave');
		$target.hover(function() {
			$target.addClass('savedQueryHover');
			$target.attr('title', 'Saved query list');
		},
		function() {
			$target.removeClass('savedQueryHover');
			$target.removeAttr('title');
		});
	};
	// Saved Query List
	this.savedQueryList = function() {
		var $savedQueryList = jQuery('.savedQueryList');
		self.onButtonHover($savedQueryList);
		$savedQueryList.off('click');
		$savedQueryList.on('click', function() {
			var listURI = xenos.context.path + '/secure/ref/savedqueryfeed/listQuery.json';
			jQuery.getJSON(listURI, function(json){
				if (!json.success){
					xenos.postNotice(xenos.notice.type.error, json.value[0], true);
					return;
				}
				var markup = self.prepareMarkup(json);
				var $dialog = jQuery(markup);
				var offset = $savedQueryList.offset();
				$dialog.dialog({
					position: [offset.left + $savedQueryList.outerWidth(true) + 4, offset.top],
					draggable: false,
					title: 'Saved Query List',
					width: 250,
					resizable: false,
					draggable: true,
					modal: true,
					zIndex: 1005,
					dialogClass: 'savedQueryDialogClass',
					open: function(e){
						$('.savedQueryDialogClass').parent().children('.ui-widget-overlay').addClass('popUpOpacity');
						$dialog.find('.scrollable').css('height', $dialog.find('.savedQueryHolder').height());
						$dialog.find('.scrollable').jScrollPane({showArrows: true});
						self.prepareDeleteSavedQuery($dialog);
						self.prepareEditSavedQuery($dialog);
						self.prepareSaveQueryName($dialog);
						jQuery(document).on('mousedown', function (e){
							self.showDialogNormal(e);
							self.closeDialog(e);
						});
						self.rerenderRequired = false;
					},
					close: function(e){
						/** Editing name and delete the saved query operations are supported by
						 *  "saved query list" pop-up. After editing the name of a saved query no
						 *  need to re-render the dashboard as there is no affect on dashboard when
						 *  the name of saved query is changed. So, dashboard should be re-rendered
						 *  only if delete operation is done.
						 */
						if(self.rerenderRequired){
							jQuery.each(self.object.workspaces, function(workspaceOrder, $workspace) {
								jQuery.each($workspace.widgets, function(widgetOrder, $widget) {
									if($widget.widgetType == 'SAVED_QUERY'){
										jQuery.getJSON($widget.contentUri, function(json) {
											if (json.success) {
												if(jQuery('#Widget' + $widget.selector).find('.contentHolder').find('.row').length > json.value[0].feeds.length) {
													$widget.content.json = json;
													$widget.content.refresh();
												}
											}
										});
									}
								});
							});
						}
					}
				});
			});
		});
	};
	// Check for modification not saved before close.
	this.closeDialog = function(e) {
		var $target = jQuery(e.target);
		if($target.hasClass('ui-icon-closethick')){
			var $saveIconHolderList = jQuery('.savedQueryDialog').find('.saveIconHolder').filter(':visible');
			if($saveIconHolderList.length > 0){
				jConfirm(xenos$DBD$i18n.delete_saved_query.saved_query_modified, null, function(confirmation) {
					if(confirmation){
						jQuery('.savedQueryDialog').dialog('close');
					}
					return confirmation;
				});
			}
		}
		return false;
	};
	
	// show saved query dialog in normal mode
	this.showDialogNormal = function(e) {
		var $target = jQuery(e.target);
		if($target.hasClass('editSavedQueryName') || $target.hasClass('saveIcon')){
			return;
		}
		var $editName = jQuery('.savedQueryDialog').find('.editSavedQueryName').filter(':visible');
		var name = $.trim($editName.attr('value'));
		var pk = $editName.attr('feedPk');
		if(self.feedByPk(pk) == name){
			$editName.parent().siblings('.saveIconHolder').css('display', 'none');
			$editName.parent().siblings('.editIconHolder').css('display', 'inline-block');
		} else {
			$editName.parent().siblings('.savedQueryName').html(self.object.escapeHtml(name));
			$editName.parent().siblings('.savedQueryName').attr('title', name);
			$editName.parent().siblings('.saveIconHolder').css('display', 'inline-block');
			$editName.parent().siblings('.editIconHolder').css('display', 'none');
		}
		$editName.parent().css('display', 'none');
		$editName.parent().siblings('.savedQueryName').css('display', 'inline-block');
		return true;
	};
	
	// Save name query action
	this.prepareSaveQueryName = function($dialog){
		$dialog.find('.saveIcon').off('click');
		$dialog.find('.saveIcon').on('click', function(e) {
			var $target = jQuery(e.target);
			var pk = $target.attr('feedPk');
			var originalName = self.feedByPk(pk);
			var $savedQueryName = $target.parent().siblings('.savedQueryName');
			var newName = $target.parent().siblings("span").children('input').attr('value');
			newName = $.trim(newName);
			var escapeNewName = self.object.escapeHtml(newName);
			var escapeNameOrgName = self.object.escapeHtml(originalName);
			if(newName !=""){
				if(originalName != newName){
					var editURI = xenos.context.path + '/secure/ref/savedqueryfeed/editName/'+pk+'/'+newName+'.json';
					var data = ''
							  + '{'
							  +   '"feedPk": [' + pk + '],'
							  +   '"feedName" : "'+encodeURIComponent(newName)+'"'
							  + '}';
					jQuery.ajax({
						url: xenos.context.path + '/secure/ref/savedqueryfeed/editName.json',
						type: 'POST',
						contentType: 'application/json',
						data: data,
						success: function(json) {
							if (!json.success){
								$savedQueryName.html(escapeNameOrgName);
								xenos.postNotice(xenos.notice.type.error, json.value[0], true);
								return;
							}
							$savedQueryName.html(escapeNewName);
							$savedQueryName.attr('title', newName);
							self.feeds[pk] = newName;
							xenos.postNotice(xenos.notice.type.info, xenos.utils.evaluateMessage(xenos$DBD$i18n.delete_saved_query.saved_query_renamed, [originalName, newName]));
						}
					});
				}
			} else {
				$savedQueryName.html(escapeNameOrgName);
				xenos.postNotice(xenos.notice.type.error, xenos$DBD$i18n.delete_saved_query.saved_query_name_blank, true);
			}
			$target.parent().css('display', 'none');
			$savedQueryName.css('display', 'inline-block');
			$target.parent().siblings('span').css('display', 'none');
			$target.parent().siblings('.editIconHolder').css('display', 'inline-block');
		});
		return true;
	};
	
	// Edit saved query action
	this.prepareEditSavedQuery = function($dialog){
		$dialog.find('.editIcon').off('click');
		$dialog.find('.editIcon').click(function(e) {
			var $target = jQuery(e.target);
			$target.parent().css('display', 'none');
			$target.parent().siblings('.savedQueryName').css('display', 'none');
			$target.parent().siblings('.saveIconHolder').css('display', 'inline-block');
			var $span = $target.parent().siblings('span');
			$span.css('display', 'inline-block');
			$span.children('input').attr('value', self.feedByPk($target.attr('feedPk')));
			$span.children('input').focus();
			$span.off('mousedown selectstart');
			$span.on('mousedown selectstart', function(e) {
				e.stopPropagation();
			});
		});
		return true;
	};
	
	// Delete saved query action
	this.prepareDeleteSavedQuery = function($dialog){
		$dialog.find('.deleteIcon').off('click');
		$dialog.find('.deleteIcon').click(function(e) {
			var pk = $(e.target).attr('feedPk');
			var originalName = self.feedByPk(pk);
			var escapeName = self.object.escapeHtml(originalName);
			jConfirm(xenos.utils.evaluateMessage(xenos$DBD$i18n.delete_saved_query.confirm_saved_query_delete, [escapeName]), null, function(confirmation) {
				if (confirmation) {
					var deleteURI = xenos.context.path + '/secure/ref/savedqueryfeed/deleteQuery/'+pk+'.json';
					jQuery.getJSON(deleteURI, function(json){
						if (json.success){
							xenos.postNotice(xenos.notice.type.info, xenos.utils.evaluateMessage(xenos$DBD$i18n.delete_saved_query.saved_query_deleted, [originalName]));
							var $target = jQuery(e.target);
							$target.parent().parent().parent().remove();
							$dialog.find('.scrollable').css('height', $dialog.find('.savedQueryHolder').height());
							$dialog.find('.scrollable').jScrollPane({showArrows: true});
							self.rerenderRequired = true;
						} else {
							xenos.postNotice(xenos.notice.type.error, json.value[0], true);
						}
					});
				}
			});
		});
		return true;
	};
}