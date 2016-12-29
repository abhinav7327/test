//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
//
// xenos
//  - Dashboard business feed infrastructure
//


// Object
function xenos$DBD$SavedQuery(parent) {
  // inherit
  this.inherit = xenos$DBD$Content;
  this.inherit(parent, 'xenos$DBD$SavedQuery');
  // self
  var self = this;


  // attributes

  self.parent.hasGraph = false;


  // feeds
  this.count = 0;

  this.feeds = {};
  this.feedsOrder = {};

  // has feeds
  this.hasFeeds = function() {
    return self.count != 0;
  };

  this.feedByPk = function(pk) {
    return self.feeds[pk];
  };


  // preparation
  this.prepareActivity = function() {
    // reset first
    this.feeds = {};
    this.feedsOrder = {};

    jQuery.each(this.json.value[0].feeds, function(order, rawFeed) {
      var feed = {
        pk: rawFeed.pk,
        selector: self.parent.parent.pk + 'x' + self.parent.pk + 'x' + rawFeed.pk,
        name: rawFeed.name,
        originalName: rawFeed.name,
        order: order,
        maiden: true,
        viewUri: rawFeed.feedUrl
      };

      // prepare
      self.count++;

      self.feeds[feed.pk] = feed;
      self.feedsOrder[order] = feed.pk;
    });
  };


  // rendition
  this.renderer = new xenos$DBD$SavedQuery$renderer(this);


  // other functions

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
    jQuery.each(self.feeds, function(pk, feed) {
      self.updateName(pk, callback, delegator);
    });
  };

  // discard update
  this.discardNames = function() {
    jQuery.each(self.feeds, function(pk, feed) {
      feed.name = feed.originalName;
      feed.dirty = false;
    });
  };


  this.updateName = function(pk, callback, delegator, errorCallback) {
    var feed = self.feeds[pk];
    if (feed.dirty) {
		var savedQryName = $.trim(feed.name);
    	if(savedQryName==''){
			xenos.postNotice(xenos.notice.type.error, xenos.i18n.utilcommonvalidationmessage.provide_criteria);
			return;
		}
		var maxLength = 30;
		if(savedQryName.length>maxLength){
			xenos.postNotice(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos.i18n.message.invalid_namelength,[maxLength]));
			return;
		}
      var data = ''
          + '{'
          +   '"feedPk": [' + pk + '],'
          +   '"workSpacePk": ' + self.parent.parent.pk + ','
          +   '"widgetPk": ' + self.parent.pk + ','
          +   '"feedName": "' + encodeURIComponent(savedQryName) + '",'
          +   '"widgetType": "SAVED_QUERY"'
          + '}';

      jQuery.ajax({
        url: xenos.context.path + "/secure/ref/savedqueryfeed/edit.json",
        type: 'POST',
        contentType: 'application/json',
        data: data,
        success: function(content) {
		  if(!content.success) {
			xenos.postNotice(xenos.notice.type.error, content.value[0]);
			if(errorCallback){
				errorCallback.call();
			}
			return;
		  }
          feed.originalName = savedQryName;
          feed.dirty = false;
          xenos.postNotice(xenos.notice.type.info, savedQryName + xenos$DBD$i18n.saved_query.saved_query_renamed);
          if (callback) callback.call(delegator ? delegator : self, self);
        }
      });
    }
  };


  // edit name
  this.editName = function(pk, name, callback, delegator) {
    // fixed name
    if (!name || name == '') return false;

    // edited
    var feed = self.feeds[pk];
    if (feed.name == name) return false;

    feed.name = name;

    feed.dirty = true;
    if (callback) callback.call(delegator ? delegator : self, feed);

    return true;
  };


  // add feeds
  this.addFeeds = function(feedsPk, callback, delegator) {
	    if (feedsPk.length == 0) return false;

	    var uri = xenos.context.path + '/secure/ref/savedqueryfeed/addfeed.json';

    var json = ''
        + '{'
        + '"feedPk": '
        + '[';

    for (var p = 0, length = feedsPk.length, lengthMinus1 = feedsPk.length - 1; p < length; p++) {
      json += feedsPk[p].pk;

      if (p < lengthMinus1)
        json += ',';
    }

    json += ''
        + '],'
        + '"workSpacePk": ' + self.parent.parent.pk + ','
        + '"widgetPk": ' + self.parent.pk + ','
        + '"widgetType": "' + self.parent.widgetType + '"'
        + '}';


    jQuery.ajax({
      url: uri,
      type: 'POST',
      contentType: 'application/json',
      data: json,
      success: function(json) {
        var messages = [];

        if (!json.success) {
		  if(json.value[0]) {
			messages.push(json.value[0]);
		  } else {
			  jQuery.each(feedsPk, function(p, pk) {
				var feed = self.parent.feeds[pk.displayRowNum];
				messages.push(xenos$DBD$i18n.saved_query.saved_query_not_added + feed.name);
			  });
		  }
          xenos.postNotice(xenos.notice.type.error, messages);
          return;
        }

		//updating the feeds after add to get the newly created custom_saved_query pk
		jQuery.getJSON(self.parent.contentUri, function(response) {
			
			if (!response.success) {		
				if(response.value[0]) {
					messages.push(response.value[0]);
				} else {
				  jQuery.each(feedsPk, function(p, pk) {
					var feed = self.parent.feeds[pk.displayRowNum];
					messages.push(xenos$DBD$i18n.saved_query.saved_query_not_added + feed.name);
				  });
				}
				xenos.postNotice(xenos.notice.type.error, messages);
				return;
			}
			
        // prepare
        jQuery.each(feedsPk, function(p, pk) {
          var feed = self.parent.feeds[pk.displayRowNum];

          // prepare
          feed.selector = self.parent.parent.pk + 'x' + self.parent.pk + 'x' + feed.pk;

          feed.order = self.count++;
          feed.maiden = true;
		  feed.viewUri = response.value[0].feeds[feed.order].feedUrl;
          self.feeds[feed.pk] = feed;
          self.feedsOrder[feed.order] = feed.pk;

          messages.push(feed.name + xenos$DBD$i18n.saved_query.saved_query_added);
        });

        xenos.postNotice(xenos.notice.type.info, messages);
        if (callback) callback.call(delegator ? delegator : self, feedsPk);
		});
      }
    });

    return true;
  };

	// remove feed
	this.removeFeed = function(feedPk, callback, delegator) {
		var feed = self.feedByPk(feedPk);
		// First check the feed whether it is present.
		if (feed) {
			var uri = xenos.context.path + '/secure/ref/savedqueryfeed/remove/' + self.parent.parent.pk + '/' + self.parent.pk + '/' + feedPk + '.json';
			jQuery.getJSON(uri, function(json) {
				if (!json.success) {
					console.log(json);
					xenos.postNotice(xenos.notice.type.error, xenos$DBD$i18n.saved_query.saved_query_not_removed + feed.name);
					return;
				}
				
				// remove from feeds
				self.removeAndReorderFeed(feedPk);
				
				xenos.postNotice(xenos.notice.type.info, feed.name + xenos$DBD$i18n.saved_query.saved_query_removed);
				if (callback) callback.call(delegator ? delegator : self, feed);
			});
		}
		return true;
	};
  
	/**
	 * Remove a feed from the feed array and reorder the remaining feeds.
	 */
	this.removeAndReorderFeed = function(feedPk){
		var feed = self.feedByPk(feedPk);
		self.count--;
		delete self.feeds[feedPk];
		for (var newOrder = 0; newOrder < self.count; newOrder++) {
			if (newOrder >= feed.order) {
				self.feedsOrder[newOrder] = self.feedsOrder[newOrder + 1];
				self.feeds[self.feedsOrder[newOrder]].order = newOrder;
			}
		}
		delete self.feedsOrder[self.count];
	};
	
	/**
	 * Remove a saved query from widget only.
	 */
	this.removeDirtyFeed = function(feedPk, callback) {
		var feed = self.feedByPk(feedPk);
		self.removeAndReorderFeed(feedPk);
		if (callback) callback.call(self, feed);
	};
	
	/**
	 * Refresh a saved query widget.
	 */
	this.refresh = function() {
		var _func = function(row) {
			self.renderer.fixSaver();
			$(row).remove();
		};
		var $widget = jQuery('#Widget' + self.parent.selector);
		$widget.find('.addFeed.contentArea').remove();
		$widget.find('.addFeedButton').parent().parent().addClass('addButtonOpc');
		jQuery.each($widget.find('.contentHolder').find('.row'), function(rowOrder, row){
			self.removeDirtyFeed($(row).attr('pk'), _func(row));
		});
		$widget.find('.contentHolder').jScrollPane({showArrows: true});
		self.prepareActivity();
		self.renderer.render(true);
		if(!self.parent.parent.parent.editable){
			$widget.find('.saveQuery-edit-ico-holder').hide();
			$widget.find('.saveQuery-close-ico-holder').hide();
		}
	};
}


// Renderer
function xenos$DBD$SavedQuery$renderer(object) {
  // inherit
  this.inherit = xenos$DBD$Content$renderer;
  this.inherit(object);
  // self
  var self = this;


  // editable
  self.object.onEditable = function() {
    var $widget = jQuery('#Widget' + self.object.parent.selector);
    $widget.find('.saveQuery-edit-ico-holder').show();
    $widget.find('.saveQuery-close-ico-holder').show();
  };
  // uneditable
  self.object.onUneditable = function() {
    var $widget = jQuery('#Widget' + self.object.parent.selector);
    $widget.find('.saveQuery-edit-ico-holder').hide();
    $widget.find('.saveQuery-close-ico-holder').hide();
  };


  // hide edit name
  this.hideEditName = function(e) {
    var $widget = jQuery('#Widget' + self.object.parent.selector);

    var $editName = $widget.find('input[style*="block"]');
    if ($editName.length == 0 || e.target == $editName[0]) return;

    var name = $.trim($editName.val());
    if (self.object.editName($editName.attr('feedPk'), name)) {
	  $editName.val(name);
      jQuery('#content').saverOn(self.object.saveNames);
    } else {
		if (name == '') {
			name = self.object.feeds[$editName.attr('feedPk')].name;
			$editName.val(name);
		}
		if(self.object.feeds[$editName.attr('feedPk')].name == name) {
			$editName.val(name);
		}
		
		$editName.parent().siblings('.saveQuery-save-ico-holder').css('display', 'none');
		$editName.parent().siblings('.saveQuery-edit-ico-holder').css('display', 'block');
    }

    $editName.parent().siblings('a')[0].innerHTML = self.object.escapeHtml(name);
    $editName.parent().siblings('a')[0].title = name;
	
	//Check whether duplicate save query criteria name is exist in same widget or not.
	var targetFeed = self.object.feeds[$editName.attr('feedPk')];
	 var dupplicateName = false;
	 $.each(self.object.feeds, function(index, feed){
		if(targetFeed.pk != feed.pk){
			if(!feed.dirty){
				if(feed.name == targetFeed.name){
					dupplicateName = true;
					return false;
				}
			}
		}
	 });
	 
	 //If duplicate save query doesn't exist then only update the corresponding URL.
	 if(!dupplicateName){
		var url = $editName.parent().siblings('a')[0].href;
		$editName.parent().siblings('a')[0].href = encodeURI(url);
	}
    $editName.css('display', 'none');
    $editName.parent().siblings('a').css('display', 'block');
  };

  // fix saver
  this.fixSaver = function() {
    var allClean = true;
    jQuery.each(self.object.feeds, function(pk, feed) {
      if (feed.dirty) {
        allClean = false;
        return false;
      }
    });

    if (allClean) {
      jQuery('#content').saverOff(self.object.saveNames);
    } else {
      jQuery('#content').saverOn(self.object.saveNames);
    }
  };


  this.doRender = function(action, phase) {
    // override add feed title
    self.object.parent.renderer.addFeedHandle().attr('title', 'Add query');

    // primary handle
    var $widget = jQuery('#Widget' + self.object.parent.selector);


    // look and feel
    jQuery.each(self.object.feedsOrder, function(order, pk) {
      var feed = self.object.feeds[pk];
      if (action == 'render' || feed.maiden) {
        feed.maiden = false;

        var markup = ''
            + '<div pk="' + feed.pk + '"class="row">'
            + '  <div class="savedQuery">';
		
		// build full URL for saved query
		var saved_query_url = xenos.context.path + feed.viewUri + "&fragments=content";
		var escapedName = self.object.escapeHtml(feed.name);

        markup += ''
            + '<a class="savedQueryName"  href="' + encodeURI(saved_query_url) + '" title="' + escapedName + '" style="color:' + self.object.parent.linkColor + ';">' + escapedName + '</a>'
            + '<span><input class="editSavedQueryName" maxlength="30" type="text" value="' + escapedName + '" feedPk="' + feed.pk + '" style="display:none;"/></span>'
            + '<div class="saveQuery-save-ico-holder" style="display:none;"><span feedPk="' + feed.pk + '" title="Update this query" class="saveQuery-save-ico">Q</span></div>'
            + '<div class="saveQuery-edit-ico-holder"><span feedName="' + escapedName + '" title="Edit this query name" class="saveQuery-edit-ico">Y</span></div>'
            + '<div class="saveQuery-close-ico-holder"><span feedPk="' + feed.pk + '" title="Remove this query" class="saveQuery-close-ico">h</span></div>';

        markup += ''
            + '  </div>'
            + '  <div class="clear"></div>'
            + '</div>';


        var $markup = jQuery(markup);
        if ($widget.find('.jspPane').length == 0) {
          $widget.find('.contentHolder').children().last().before($markup);
        } else {
          $widget.find('.jspPane').children().last().before($markup);
        }


        /**/
        /**/

          // Code for browser checking
          // View handler
        $markup.find('.savedQuery a').on('click', {resultType: "saved_query"}, _handleSavedQueryWidgetLinkClick);

        /**/
        /**/
      }
    });


    $widget.find('.contentHolder .row a').css('color', self.object.parent.linkColor);
    $widget.find('.contentHolder .row span').css('color', self.object.parent.foreColor);


    $widget.find('.saveQuery-edit-ico').off('click');
    $widget.find('.saveQuery-edit-ico').on('click', function(e) {
      var $target = jQuery(e.target);
      $target.parent().css('display', 'none');
      $target.parent().siblings('.saveQuery-save-ico-holder').css('display', 'block');

      $target.parent().siblings('a').css('display', 'none');
      var $editName = $target.parent().siblings('span').children('.editSavedQueryName');

      $editName.css('display', 'block');
      $editName.focus();

      $editName.off('mousedown selectstart');
      $editName.on('mousedown selectstart', function(e) {
        e.stopPropagation();
      });
    });
    jQuery(document).on('mousedown', self.hideEditName);


    $widget.find('.saveQuery-save-ico').off('click');
    $widget.find('.saveQuery-save-ico').on('click', function(e) {
      var $target = jQuery(e.target);
	  $target.parent().css('display', 'none');
	  $target.parent().siblings('.saveQuery-edit-ico-holder').css('display', 'block');
	  var errorHandler = function() {
			var feed = self.object.feeds[$target.attr('feedPk')];
			$target.parent().siblings('a').text(self.object.escapeHtml(feed.originalName));
			$target.parent().siblings('a').attr('title',self.object.escapeHtml(feed.originalName));
			$target.parent().siblings('span').children('.editSavedQueryName').val(self.object.escapeHtml(feed.originalName));
			feed.name = feed.originalName;
			feed.dirty = false;
			self.fixSaver();
	  }
      self.object.updateName($target.attr('feedPk'), self.fixSaver, self, errorHandler);
    });


    $widget.find('.saveQuery-close-ico').off('click');
    $widget.find('.saveQuery-close-ico').on('click', function(e) {
      // get the confirmation
      jConfirm(xenos$DBD$i18n.saved_query.confirm_saved_query_remove, null, function(confirmation) {
        if (confirmation) {
          var _function = function() {
            self.fixSaver();
            $(e.target).parent().parent().parent().remove();

            $widget.find('.contentHolder').jScrollPane({showArrows: true});
          };
          self.object.removeFeed($(e.target).attr('feedPk'), _function, self);
        }
      });
    });


    // scroll pane & chart
    var $contentHolder = $widget.find('.contentHolder');
    $contentHolder.css('height', 280);
    $contentHolder.jScrollPane({showArrows: true});
  };


  this.render = function(unprepared) {
    self.doRender('render', unprepared);
  };

  this.update = function(unprepared) {
    self.doRender('update', unprepared);
  };


  this.dispose = function() {
    jQuery(document).off('mousedown', self.hideEditName);
  };
}
