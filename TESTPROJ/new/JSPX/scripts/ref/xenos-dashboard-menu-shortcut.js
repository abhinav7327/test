//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
// MenuShortcut
function xenos$DBD$MenuShortcut(parent) {
	// inherit
    this.inherit = xenos$DBD$Content;
    this.inherit(parent, 'xenos$DBD$MenuShortcut');
    // self
    var self = this;
    // attributes
    this.json;
	// shortcuts
	this.shortcuts = {};
    // preparation
    this.prepareActivity = function () {
		this.feeds = {};	
		this.shortcuts = {};
		var feeds = self.json.value[0].feeds;		
		self.feeds = feeds;
        for (i in feeds) {
			feeds[i].originalName = feeds[i].name;
			self.shortcuts[feeds[i].pk] = feeds[i];
		}
	};
		
	// content updater
	this.saveNames = function(update) {
		if (update) {
			self.updateNames();
		} else {
			self.discardNames();
		}
    };

	// update content
	this.updateNames = function(callback, delegator) {
		jQuery.each(self.shortcuts, function(pk, feed) {
			self.updateName(pk, callback, delegator);
		});
	};
	
	// discard update
	this.discardNames = function() {
		jQuery.each(self.shortcuts, function(pk, feed) {
			feed.name = feed.originalName;
			feed.dirty = false;
		});
	};
	
    this.api = function (url, data, ajaxType, callback) {
		//Sending info to the server
		xenos$Handler$default.generic(undefined, {
            requestUri: xenos.context.path + url,
			requestType: xenos$Handler$default.requestType.asynchronous,
			contentType: xenos$Handler$default.contentType.json,
			settings: {
				type: ajaxType,
				contentType: 'application/json',
				data: data
			},
			onJsonContent: callback
		});
	}
		
	this.checkSaver = function(){
		var allClean = true;
		$.each(self.shortcuts, function(pk, feed) {
			if (feed.dirty) {
				allClean = false;
				return false;
			}
		});
		if (allClean)
		  $('#content').saverOff(self.saveNames);
	}
		
	this.updateName = function(pk, errorCallback, callback, delegator) {
		var feed = self.shortcuts[pk];
		if (feed.dirty) {
			var data = '{' +
				'"feedPk":[' + pk + '],' +
				'"workSpacePk":' + self.parent.parent.pk +','+
				'"widgetPk":' +self.parent.pk+','+
				'"feedName":"' +encodeURIComponent(feed.name)+'",'+
				'"widgetType": "MENU_SHORTCUT"'+ 
			'}';
						
			self.api('/secure/ref/menushortcutfeed/edit.json',data,'POST',function(e, options, target, content){
				if(!content.success) {
					xenos.postNotice(xenos.notice.type.error, content.value[0]);
					if(errorCallback){
						errorCallback.call();
					}
					return;
				}
				feed.originalName = feed.name;
				feed.dirty = false;
				self.checkSaver();
				xenos.postNotice('info',xenos$DBD$i18n.shortcut.shortcut_rename);	
			});
		}
	};
    // rendition
    this.renderer = new xenos$DBD$MenuShortcut$renderer(this);
}

// MenuShortcut
function xenos$DBD$MenuShortcut$renderer(object) {
    // inherit
    this.inherit = xenos$DBD$Content$renderer;
    this.inherit(object);
    // self
    var self = this;
	
	 // editable
	  self.object.onEditable = function() {
		var $widget = jQuery('#Widget' + self.object.parent.selector);
		var $contentHolder = $widget.find('.contentHolder');
		$widget.find('.menuShortcut-edit-ico-holder').show();
		$widget.find('.menuShortcut-close-ico-holder').show();
		
		/* Implementation of Drag Drop Feature of Menu Items */
		/* Making Items Draggable */
        $('#app-menu a[href*="/"]').closest('li').draggable({
			containment: '#wrapper',
			revert: 'invalid',
            helper: function (e) {
				var el = $(e.target);
				var text = $(e.target).text();
				var parentEl = $(e.target).closest('li');
				var parent = parentEl.parent().closest('li');
                var i = 0;
                while (true) {
					i++;
                    if (parent.length === 0 || i > 10) {
                        break;
                    }
					text = parent.children('a').text() + ' > ' + text;
					parent = parent.parent().closest('li');
				}
				var parentElClone = parentEl.clone();
				parentElClone.addClass('menushortcut');
                parentElClone.find('a').text(text).css('cursor', 'move');
				return parentElClone;
			}
		});
		/* Making Shortcut Holder Droppable */
		$widget.droppable({
			activeClass: "dropzone",
			hoverClass: "hoverdropzone",
			accept: "li",
            drop: function (event, ui) {
				var menupk = $(ui.helper).attr('menupk'); 
				var feedName = ui.helper.text();
                if (self.object.shortcuts[menupk]) {
                    xenos.postNotice('error', xenos.utils.evaluateMessage(xenos$DBD$i18n.widget.duplicate_shortcut,[$.trim(feedName)]));
					return;
				}
				$( this ).find( ".placeholder" ).remove();
				var data = '{' +
							'"feedPk":[' + menupk + '],' +
							'"workSpacePk":' + self.object.parent.parent.pk +','+
							'"widgetPk":' +self.object.parent.pk+','+
							'"feedName":"' +$.trim(feedName)+'",'+
							'"widgetType": "MENU_SHORTCUT"'+ 
				'}';
				self.object.api('/secure/ref/menushortcutfeed/addfeed.json',data,'POST',function(e, options, $target, content) {
					var data = {
							pk: parseInt(menupk),
							name: $.trim(feedName),
							feedUrl: $(ui.helper.html()).attr('href'),
							dynamic: true
					}
					self.addShortcut(data);
					data.dynamic = false;
					self.object.shortcuts[data.pk] = data;
					self.object.feeds.push(data);
					$contentHolder.jScrollPane({showArrows: true});
                    xenos.postNotice('info', xenos.utils.evaluateMessage(xenos$DBD$i18n.widget.add_shortcut_successful,[$.trim(feedName)]));
                });
			}
		});
	  };
	  // uneditable
	  self.object.onUneditable = function() {
		var $widget = jQuery('#Widget' + self.object.parent.selector);
		$widget.find('.menuShortcut-edit-ico-holder').hide();
		$widget.find('.menuShortcut-close-ico-holder').hide();
		
		$('#app-menu a[href*="/"]').closest('li').draggable('destroy');
		$widget.droppable('destroy');
	  };
	
    this.shortcutMarkup = '<div class="row" pk="${pk}"><div class="menuShortcut" rel="${pk}"><a href="${feedUrl}" class="shortcutLabel" title="${name}">${name}</a><span><input class="editSavedQueryName" type="text" maxlength="60" value="${name}" feedpk="${pk}" style="display:none;"></span><div class="menuShortcut-save-ico-holder" style="display:none;"><span feedpk="${pk}" title="Update" class="menuShortcut-save-ico">Q</span></div><div class="menuShortcut-edit-ico-holder"><span feedname="${name}" title="Edit Title" class="menuShortcut-edit-ico">Y</span></div><div class="menuShortcut-close-ico-holder"><span feedpk="${pk}" title="Delete" class="menuShortcut-close-ico">h</span></div></div>';


    
	// edit name
    this.editName = function (pk, name, callback, delegator) {
        // fixed name
        if (!name || name == '') return false;

        // edited
        var feed = self.object.shortcuts[pk];
        if (feed.name == name) return false;

        feed.name = name;

        feed.dirty = true;
        if (callback) callback.call(delegator ? delegator : self, feed);

        return true;
    };
	
	
    this.hideEditName = function (e) {
        var $widget = $('#Widget' + self.object.parent.selector);

        var $editName =  $widget.find('input[style*="block"].editSavedQueryName');
        if ($editName.length == 0 || e.target == $editName[0]) return;

        var name = $.trim($editName.val());

        if (self.editName($editName.attr('feedPk'), name)) {
            $('#content').saverOn(self.object.saveNames);
        } else {
			if (name == '') {
				name = self.object.shortcuts[$editName.attr('feedPk')].name;
			}
            $editName.parent().siblings('.menuShortcut-save-ico-holder').css('display', 'none');
            $editName.parent().siblings('.menuShortcut-edit-ico-holder').css('display', 'block');
        }

		$editName.val(name);
		$editName.parent().siblings('a')[0].innerHTML = self.object.escapeHtml(name);
        $editName.parent().siblings('a')[0].title = name;
		
        $editName.css('display', 'none');
        $editName.parent().siblings('a').css('display', 'block');
    };
	
	
	
    this.addShortcut = function (details) {
		var me = this;
		var parentSel = '.contentHolder';
        if (details.dynamic) {
			parentSel = '.jspPane'
		}
        var $widget = $('#Widget' + self.object.parent.selector);
        var shortcut = $.tmpl(this.shortcutMarkup, details).appendTo($widget.find(parentSel));
		var link = shortcut.find('.menuShortcut a');
		if(link.attr('href').indexOf('personalization/export') == -1){
			if(link.attr('href').indexOf('.action') == -1){
				link.on('click',function(e){
					e.preventDefault();
					if($(e.target).parents('.widgetHolder').hasClass('editable')){
						return;
					}
					xenos$Handler$asynchronous.generic(e);
			});
			}else{
				link.click(function(e){
					e.preventDefault();
					if ($.browser.msie) {
						link.colorbox({iframe:true, title:xenos.i18n.title.legacy, width:"98%", height:"98%"});
					} else {
						jAlert(xenos.i18n.message.window_not_supported, 'Alert');
					}
				});
			}
		}
        shortcut.find('.menuShortcut-close-ico').click(function (e) {
			var shortcutPk = $(this).attr('feedpk');
            var url = '/secure/ref/menushortcutfeed/remove/' + self.object.parent.parent.pk + '/' + self.object.parent.pk + '/' + shortcutPk + '.json';
            me.object.api(url, {}, 'GET', function () {
				delete self.object.shortcuts[shortcutPk];
				
				//Remove rec from feeds
				for(i in self.object.feeds){
					if(self.object.feeds[i].pk == shortcutPk){
						delete self.object.feeds[i];
						console.log(self.object.feeds);
						break;
					}
				}
				
				$(e.target).closest('.row').remove();
				self.object.checkSaver();
                xenos.postNotice('info', xenos$DBD$i18n.shortcut.shortcut_remove);
			});
		});
        shortcut.find('.menuShortcut-edit-ico').click(function (e) {
			var row = $(e.target).closest('.row');
			row.find('.menuShortcut-save-ico-holder').css('display', 'block');
            row.find('.menuShortcut-edit-ico-holder').css('display', 'none');
			row.find('.editSavedQueryName').css('display', 'block').focus();
            row.find('.shortcutLabel').css('display', 'none');
			
			
		});
        shortcut.find('.menuShortcut-save-ico').click(function (e) {
			var shortcutPk = $(this).attr('feedpk');			
			var row = $(e.target).closest('.row');
			var errorHandler = function() {
				$target = $(e.target);
				var feed = self.object.shortcuts[shortcutPk];
				$target.parent().siblings('a').text(feed.originalName);
				$target.parent().siblings('a').attr('title',feed.originalName);
				feed.name = feed.originalName;
				feed.dirty = false;
				self.object.checkSaver();
			}
			me.object.updateName(shortcutPk, errorHandler);
			row.find('.menuShortcut-save-ico-holder').css('display', 'none');
			row.find('.menuShortcut-edit-ico-holder').css('display', 'block');
			});
		shortcut.find('a').css('color', self.object.parent.linkColor);
	}
	
	
	// update
	this.update = function(){
		var $widget = $('#Widget' + self.object.parent.selector);
		 $widget.find('.contentHolder .row a').css('color', self.object.parent.linkColor);
		 $widget.find('.contentHolder .row span').css('color', self.object.parent.foreColor);
	}

    // render
    this.render = function (unprepared) {
		var me = this;
        var $widget = $('#Widget' + self.object.parent.selector);
		var $contentHolder = $widget.find('.contentHolder');
		$widget.addClass('menushortcuts');
		
		/* Render Existing Shortcuts */
        for (i in self.object.feeds) {
			this.addShortcut(self.object.shortcuts[self.object.feeds[i].pk]);
		}
		
		$contentHolder.css('height', 280);
		$contentHolder.jScrollPane({showArrows: true});
		
		$(document).on('mousedown', self.hideEditName);
    };
	
	// dispose
	this.dispose = function() {
		jQuery(document).off('mousedown', self.hideEditName);
	};
}