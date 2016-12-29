//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
//
// xenos
//  - Dashboard base infrastructure
//


// Object
function xenos$DBD$object(parent, type) {
  // parent and type
  this.parent = parent;
  this.type = type;
  // self
  var self = this;

  // attributes
  this.editable;

  // children
  this.children;
  this.childrenOrder;

  // disposal state
  this.disposed = false;

  this.delegateTo = xenos.delegateTo;
  this.delegateToAll = xenos.delegateToAll;

  this.waitFor = xenos.waitFor;
  this.waitForAll = xenos.waitForAll;


  this.escapeHtml = function(str){
		return xenos.utils.escapeHtml(str);
	}
  
  // utilities
  // toggle editable
  this.toggleEditable = function(flag, action) {
    var _toggleEditable = function() {
      // self
      this.editable = flag;
      if (jQuery.isFunction(this[action]))
        this[action].call(this);

      if (this.prepared)
        this.render('update');

      // children
      xenos.delegateToAll({
        targets: this.children,
        order: this.childrenOrder,
        operation: function() {
          _toggleEditable.call(this);
        }
      });
    };

    setTimeout(function() {_toggleEditable.call(self);}, 0);
  };

  // make editable
  this.makeEditable = function() {
    self.toggleEditable(true, 'onEditable');
  };
  // make uneditable
  this.makeUneditable = function() {
    self.toggleEditable(false, 'onUneditable');
  };


  // preparation
  this.prepareActivity;
  this.prepareHooks = xenos$Dashboard$hook[this.type].prepare;

  this.prepareRequest;
  this.preparing;
  this.prepared;
  this.pendingRender;

  this.prepareClosure = function() {
    self.preparing = false;
    self.prepared = true;

    var _function = function() {
      self.delegateToAll({
        targets: self.prepareHooks,
        delegator: self
      });
    };
    setTimeout(_function, 0);

    if (jQuery.isFunction(self.pendingRender)) {
      self.pendingRender();
      delete self.pendingRender;
    }
  };

  this.prepare = function() {
  
	// already disposed, no need to prepare
	if(self.disposed == true) {
		// reset disposal state, otherwise full dashboard
		// will not be rendered when back to dahsboard
		// from any screen, not by refresh button
		// it's typically required when dasboard fully not loaded
		// and switched to screen(s) and back to dashboard
		self.disposed = false;
		
		// return back
		return;
	}
  
    if (self.preparing || self.prepared) return;
    self.preparing = true;

    var _function = function() {
      if (jQuery.isFunction(self.prepareActivity))
        self.prepareRequest = self.prepareActivity();

      if (self.prepareRequest && jQuery.isFunction(self.prepareRequest.always)) {
        self.prepareRequest.always(function() {
          self.prepareClosure();
        });
      } else {
        self.prepareClosure();
      }
    };
    setTimeout(_function, 0);
  };


  // rendition
  this.renderer;
  this.lazyRenderer;
  this.lazyRenderOption;

  this.renderActivity = function(action, unprepared) {
    if (self.renderer && jQuery.isFunction(self.renderer[action])) {
      self.renderer[action](unprepared);

      // toggle editable
      if (action == 'render' && !unprepared) {
        var _action = self.editable ? 'onEditable' : 'onUneditable';
        if (jQuery.isFunction(self[_action]))
          self[_action].call(self);
      }
    }
  };
  this.renderHooks = xenos$Dashboard$hook[this.type].render;

  this.rendering;
  this.preRendered;
  this.rendered;
  this.pendingConnect;

  this.renderClosure = function(action, unprepared) {
    self.rendering = false;

    if (unprepared) {
      self.preRendered = true;
    } else {
      self.rendered = true;
    }

    var _function = function() {
      self.delegateToAll({
        targets: self.renderHooks,
        parameters: arguments,
        delegator: self
      });
    };
    setTimeout(_function, 0);

    if (!unprepared && jQuery.isFunction(self.pendingConnect)) {
      self.pendingConnect();
      delete self.pendingConnect;
    }
  };

  this.render = function(action, unprepared) {
    if (!unprepared && !self.prepared) {
      self.pendingRender = function() {
        self.render(action, unprepared);
      };
      self.prepare();
      return;
    }

    if (self.rendering || (action == 'render' && self.rendered)) return;
    self.rendering = true;

    var _function = function() {
      self.renderActivity(action, unprepared);
      self.renderClosure(action, unprepared);
    };

    if (action == 'render' && !unprepared && self.lazyRenderer) {
      self.delegateToAll({
        targets: self.children,
        order: self.childrenOrder,
        operation: 'render',
        parameters: ['render', self.lazyRenderOption]
      });

      self.waitForAll({
        targets: self.children,
        state: self.lazyRenderOption ? 'preRendered' : 'rendered',
        timeout: 5,
        callback: _function
      });
    } else {
      _function();
    }
  };


  // connection
  this.connectActivity;
  this.connectHooks = xenos$Dashboard$hook[this.type].connect;

  this.disconnectActivity;
  this.disconnectHooks = xenos$Dashboard$hook[this.type].disconnect;

  this.connecting;
  this.connected;
  this.disconnecting;


  this.connectClosure = function() {
    self.connecting = false;
    self.connected = true;

    var _function = function() {
      self.delegateToAll({
        targets: self.connectHooks,
        delegator: self
      });
    };
    setTimeout(_function, 0);

    _function = function() {
      self.delegateToAll({
        targets: self.children,
        order: self.childrenOrder,
        state: 'connected',
        operation: 'connect',
        timeout: 5
      });
    };
    setTimeout(_function, 0);
  };

  this.connect = function() {
    if (!self.rendered) {
      self.pendingConnect = self.connect;
      self.render('render');
      return;
    }

    if (self.connecting || self.connected) return;
    self.connecting = true;

    var _function = function() {
      if (jQuery.isFunction(self.connectActivity))
        self.connectActivity();

      self.connectClosure();
    };
    setTimeout(_function, 0);
  };

  this.disconnectClosure = function() {
    var _function = function() {
      self.delegateToAll({
        targets: self.disconnectHooks,
        delegator: self
      });
    };
    _function();

    _function = function() {
      self.delegateToAll({
        targets: self.children,
        order: self.childrenOrder,
        operation: 'disconnect'
      });
    };
    _function();

    self.connected = false;
    self.disconnecting = false;
  };
  this.disconnect = function() {
    if (self.disconnecting || !self.connected) return;
    self.disconnecting = true;

    var _function = function() {
      if (jQuery.isFunction(self.disconnectActivity))
        self.disconnectActivity();

      self.disconnectClosure();
    };
    _function();
  };


  // disposition
  this.disposeActivity;
  this.disposeHooks = xenos$Dashboard$hook[this.type].dispose;

  this.disposeClosure = function() {
    var _function = function() {
      self.delegateToAll({
        targets: self.disposeHooks,
        delegator: self
      });
    };
    _function();

    _function = function() {
      self.delegateToAll({
        targets: self.children,
        target: self.childrenOrder,
        operation: 'dispose'
      });
    };
    _function();

    self.preRendered = false;
    self.rendered = false;
  };

  this.dispose = function() {
    if (self.prepareRequest && jQuery.isFunction(self.prepareRequest.abort))
      self.prepareRequest.abort();

    if (self.connected)
      self.disconnect();

    var _function = function() {
      if (self.renderer && jQuery.isFunction(self.renderer.dispose))
        self.renderer.dispose();

      if (jQuery.isFunction(self.disposeActivity))
        self.disposeActivity();

      self.disposeClosure();
    };
    _function();
	
	// rather than dashboard all objects get disposed flag ON
	// so that in case of not loading dashboard fully and 
	// switched to screen(s) randomly and in that case
	// DBD object(s) should not be prepared any more
	if(self.type != "xenos$DBD$Dashboard") {
		console.log("DBD disposed for : " + self.type);
		self.disposed = true;
	}
  };
}


// Renderer
function xenos$DBD$renderer(object) {
  // self
  var self = this;

  // object
  this.object = object;


  // render
  this.render = function(unprepared) {
    // no-op;
  };
  // update
  this.update = function(unprepared) {
    // no-op;
  };

  // dispose
  this.dispose = function() {
    // no-op;
  };
}
//
// xenos
//  - Dashboard object infrastructure
//


// Dashboard
function xenos$DBD$Dashboard(parent) {
  // inherit
  this.inherit = xenos$DBD$object;
  this.inherit(parent, 'xenos$DBD$Dashboard');
  // self
  var self = this;


  // attributes
  this.editable = false;

  // workspaces
  this.count = 0;

  this.workspaces = {};
  this.workspacesName = {};
  this.workspacesOrder = {};

  // has workspaces
  this.hasWorkspaces = function() {
    return self.count > 1;
  };


  // workspace by order
  this.workspaceByOrder = function(order) {
    return self.workspaces[self.workspacesOrder[order]];
  };


  // default workspace
  this.defaultWorkspacePk;
  this.defaultWorkspace = function() {
    return self.workspaces[self.defaultWorkspacePk];
  };

  // selected workspace
  this.selectedWorkspacePk;
  this.selectedWorkspace = function() {
    return self.workspaces[self.selectedWorkspacePk];
  };


  // childrens
  this.children = this.workspaces;
  this.childrenOrder = this.workspacesOrder;


  var _delegateToAll = this.delegateToAll;
  this.delegateToAll = function(options) {
    if (!options.operation || jQuery.isFunction(options.operation)) {
      _delegateToAll(options);
      return;
    }

    if (options.operation == 'render'
        || options.operation == 'disconnect'
        || options.operation == 'dispose') {
      _delegateToAll(options);
    } else {
      if (self.selectedWorkspace())
        self.selectedWorkspace()[options.operation].call(self.selectedWorkspace());
    }
  };


  // preparation
  this.prepareActivity = function() {
    var uri = xenos.context.path + '/secure/ref/dashboard/metadata.json';
    return jQuery.getJSON(uri, function(json) {
      if (!json.success) {
        console.log(json);
        return;
      }

      // workspaces
      jQuery.each(json.value[0].workSpaces, function(order, rawWorkspace) {
        var workspace = new xenos$DBD$Workspace(self);
        workspace.pk = rawWorkspace.workSpacePk;
        workspace.name = self.escapeHtml(rawWorkspace.workSpaceName);
        workspace.order = order;

        // prepare
        self.count++;

        self.workspaces[workspace.pk] = workspace;
        self.workspacesName[order] = workspace.name;
        self.workspacesOrder[order] = workspace.pk;
      });

      // default and selected workspace
      self.defaultWorkspacePk = json.value[0].defaultWorkSpacePk;
      self.selectedWorkspacePk = json.value[0].defaultWorkSpacePk;

      // fix for invalid default workspace
      if (!self.workspaces[self.defaultWorkspacePk]) {
        self.defaultWorkspacePk = self.workspacesOrder[0];
        self.selectedWorkspacePk = self.workspacesOrder[0];

        xenos.postNotice(xenos.notice.type.info, xenos$DBD$i18n.dashboard.no_default_workspace);
      }
    });
  };


  // rendition
  this.renderer = new xenos$DBD$Dashboard$renderer(this);
  this.lazyRenderer = true;
  this.lazyRenderOption = true;


  // other functions

  // add workspace
  this.addWorkspace = function(name, order, callback, delegator) {
    if (!name) return false;

    var uri = xenos.context.path + '/secure/ref/workspace/add.json?name=' + encodeURIComponent(name);
    jQuery.getJSON(uri, function(json) {
      if (!json.success) {
        console.log(json);
        xenos.postNotice(xenos.notice.type.error, xenos$DBD$i18n.dashboard.workspace_not_added + name);
        return;
      }

      var workspace = new xenos$DBD$Workspace(self);
      workspace.pk = json.value[0].workSpacePk;
      workspace.name = name;
      workspace.order = self.count;

      workspace.editable = self.editable;

      // prepare
      self.count++;

      self.workspaces[workspace.pk] = workspace;
      self.workspacesOrder[workspace.order] = workspace.pk;

      if (self.count == 1) {
        // default and selected workspace
        self.defaultWorkspacePk = json.value[0].workSpacePk;
        self.selectedWorkspacePk = json.value[0].workSpacePk;
      }

      xenos.postNotice(xenos.notice.type.info, workspace.name + xenos$DBD$i18n.dashboard.workspace_added);
      if (callback) callback.call(delegator ? delegator : self, workspace);
    });

    return true;
  };

  // remove workspace
  this.removeWorkspace = function(order, callback, delegator) {
    var workspace = self.workspaceByOrder(order);

    var uri = xenos.context.path + '/secure/ref/workspace/remove.json?pk=' + workspace.pk;
    jQuery.getJSON(uri, function(json) {
      if (!json.success) {
        console.log(json);
        xenos.postNotice(xenos.notice.type.error, xenos$DBD$i18n.dashboard.workspace_not_removed + workspace.name);
        return;
      }

      // prepare
      self.count--;

      delete self.workspaces[workspace.pk];

      for (var newOrder = 0; newOrder < self.count; newOrder++)
        if (newOrder >= order) {
          self.workspacesOrder[newOrder] = self.workspacesOrder[newOrder + 1];
          self.workspaces[self.workspacesOrder[newOrder]].order = newOrder;
        }

      delete self.workspacesOrder[self.count];

      xenos.postNotice(xenos.notice.type.info, workspace.name + xenos$DBD$i18n.dashboard.workspace_removed);
      if (callback) callback.call(delegator ? delegator : self, workspace);
    });

    return true;
  };
  
  //Return true if user is on dashboard and have some workspace.
  this.visible = function(){
	  return jQuery('#dashboard').filter(':visible').length > 0;
  };
  
  // Refresh the widgets on the dashboard.
  this.refresh = function(){
	jQuery.each(self.workspaces, function(workspaceOrder, $workspace) {
		jQuery.each($workspace.widgets, function(widgetOrder, $widget) {
			if($widget.content && jQuery.isFunction($widget.content.refresh)){
				jQuery.getJSON($widget.contentUri, function(json) {
					if (json.success) {
						if($widget.content.json.value[0].feeds.length != json.value[0].feeds.length){
							$widget.content.json = json;
							$widget.content.refresh();
						}
					}
				});
			}
		});
	});
  };
  
  //Refresh dash board on tab navigation or selection.
  $(document).ready(function() {
	$(window).on("blur focus", function(e) {
		if ($(this).data("prevType") != e.type) {
			switch (e.type) {
            case "focus":
				if(self.visible()){
					self.refresh();
				}
                break;
            case "blur":
                // no-op
                break;
			}
		}
		$(this).data("prevType", e.type);
	});
  });
}


// Workspace
function xenos$DBD$Workspace(parent) {
  // inherit
  this.inherit = xenos$DBD$object;
  this.inherit(parent, 'xenos$DBD$Workspace');
  // self
  var self = this;


  // attributes
  this.pk;
  this.name;
  this.order;

  this.dirty;

  this.editable = self.parent.editable;


  // widgets
  this.count = 0;

  this.widgets = {};
  this.widgetsOrder = {};
  this.originalWidgetsOrder = {};

  // has widgets
  this.hasWidgets = function() {
    return self.count != 0;
  };


  // widget by order
  this.widgetByOrder = function(order) {
    return self.widgets[self.widgetsOrder[order]];
  };


  // template widgets
  this.templateCount = 0;

  this.templateWidgets = {};
  this.templateWidgetsOrder = {};

  // has template widgets
  this.hasTemplateWidgets = function() {
    return self.templateCount != 0;
  };


  // template widget by order
  this.templateWidgetByOrder = function(order) {
    return self.templateWidgets[self.templateWidgetsOrder[order]];
  };


  // available widgets
  this.availableCount = 0;

  this.availableWidgets = {};
  this.availableWidgetsOrder = {};

  // has available widgets
  this.hasAvailableWidgets = function() {
    return self.availableCount != 0;
  };


  // available widget by order
  this.availableWidgetByOrder = function(order) {
    return self.availableWidgets[self.availableWidgetsOrder[order]];
  };


  // children
  this.children = this.widgets;
  this.childrenOrder = this.widgetsOrder;


  // preparation
  this.prepareActivity = function() {
    var uri = xenos.context.path + '/secure/ref/workspace/metadata/' + this.pk + '.json';
    return jQuery.getJSON(uri, function(json) {
      if (!json.success) {
        console.log(json);
        return;
      }

      // widgets
      jQuery.each(json.value[0].widgets, function(ignored, rawWidget) {
        var widget = new xenos$DBD$Widget(self);
        widget.template = false;
        widget.pk = rawWidget.pk;
        widget.name = rawWidget.name;
        widget.originalName = widget.name;
        widget.order = self.count;
        widget.selector = self.pk + 'x' + widget.pk + 'x' + widget.order;

        widget.user = rawWidget.systemDefined ? (rawWidget.systemDefined == 'N') : false;

        widget.draggable = true;
        widget.resizable = true;
        widget.configurable = true;
        widget.closeable = true;

        widget.backColor = rawWidget.backgroundcolor ? rawWidget.backgroundcolor : '#17954c';
        widget.originalBackColor = widget.backColor;
        widget.foreColor = rawWidget.foregroundcolor ? rawWidget.foregroundcolor : '#ffffff';
        widget.originalForeColor = widget.foreColor;
        widget.linkColor = rawWidget.linkColor ? rawWidget.linkColor : '#ffffff';
        widget.originalLinkColor = widget.linkColor;

        widget.hasGraph = false;
        widget.showGraph = rawWidget.showGraph;
        widget.originalShowGraph = widget.showGraph;

        widget.contentUri = xenos.context.path + rawWidget.dataUrl + '/' + self.pk + '/' + widget.pk + '.json';
        widget.contentInterval = rawWidget.asyncInterval;

        widget.widgetType = rawWidget.widgetType;
        widget.widgetTypePk = rawWidget.widgetTypePk;
        widget.widgetTypeDescription = widget.widgetTypeDesc;

        if (rawWidget.allFeedsUrl && rawWidget.allFeedsUrl != '')
          widget.feedsUri = xenos.context.path + rawWidget.allFeedsUrl + '.json';

        widget.feedAddable = rawWidget.feedSelectable ? (rawWidget.feedSelectable == 'Y') : false;
        widget.feedRemovable = rawWidget.feedUnselectable ? (rawWidget.feedUnselectable == 'Y') : false;
        widget.feedRefreshable = rawWidget.feedRefreshable ? (rawWidget.feedRefreshable == 'Y') : false;
        widget.refreshIntervalMin = rawWidget.refreshIntervalMin ? rawWidget.refreshIntervalMin : 0;

        // prepare
        self.widgets[widget.pk] = widget;
        self.widgetsOrder[self.count] = widget.pk;
        self.originalWidgetsOrder[self.count++] = widget.pk;
      });

      // template widgets
      jQuery.each(json.value[0].availableWidgetTypes, function(ignored, rawWidgetType) {
        if (rawWidgetType.multiWidgetMode && rawWidgetType.multiWidgetMode == 'Y') {
          var widget = new xenos$DBD$Widget(self);
          widget.template = true;
          widget.name = rawWidgetType.widgetTypeDesc;
          widget.originalName = widget.name;
          widget.order = self.templateCount;

          widget.draggable = true;
          widget.resizable = true;
          widget.configurable = true;
          widget.closeable = true;

          widget.backColor = rawWidgetType.backgroundcolor ? rawWidgetType.backgroundcolor : '#17954c';
          widget.originalBackColor = widget.backColor;
          widget.foreColor = rawWidgetType.foregroundcolor ? rawWidgetType.foregroundcolor : '#ffffff';
          widget.originalForeColor = widget.foreColor;
          widget.linkColor = rawWidgetType.linkColor ? rawWidgetType.linkColor : '#ffffff';
          widget.originalLinkColor = widget.linkColor;

          widget.hasGraph = false;
          widget.showGraph = rawWidgetType.showGraph;
          widget.originalShowGraph = widget.showGraph;

          widget.widgetType = rawWidgetType.widgetType;
          widget.widgetTypePk = rawWidgetType.widgetTypePk;
          widget.widgetTypeDescription = rawWidgetType.widgetTypeDesc;

          if (rawWidgetType.allFeedsUrl && rawWidgetType.allFeedsUrl != '')
            widget.feedsUri = xenos.context.path + rawWidgetType.allFeedsUrl + '.json';

          widget.feedAddable = rawWidgetType.feedSelectable ? (rawWidgetType.feedSelectable == 'Y') : false;
          widget.feedRemovable = rawWidgetType.feedUnselectable ? (rawWidgetType.feedUnselectable == 'Y') : false;
          widget.feedRefreshable = rawWidgetType.feedRefreshable ? (rawWidgetType.feedRefreshable == 'Y') : false;
          widget.refreshIntervalMin = rawWidgetType.refreshIntervalMin ? rawWidgetType.refreshIntervalMin : 0;

          // prepare
          self.templateWidgets[widget.widgetType] = widget;
          self.templateWidgetsOrder[self.templateCount++] = widget.widgetType;
        }
      });

      // available widgets
      jQuery.each(json.value[0].availableWidgets, function(ignored, rawWidget) {
        var widget = new xenos$DBD$Widget(self);
        widget.template = false;
        widget.pk = rawWidget.pk;
        widget.name = rawWidget.name;
        widget.originalName = widget.name;
        widget.order = self.availableCount;

        widget.user = rawWidget.systemDefined ? (rawWidget.systemDefined == 'N') : false;

        widget.draggable = true;
        widget.resizable = true;
        widget.configurable = true;
        widget.closeable = true;

        widget.backColor = rawWidget.backgroundcolor ? rawWidget.backgroundcolor : '#17954c';
        widget.originalBackColor = widget.backColor;
        widget.foreColor = rawWidget.foregroundcolor ? rawWidget.foregroundcolor : '#ffffff';
        widget.originalForeColor = widget.foreColor;
        widget.linkColor = rawWidget.linkColor ? rawWidget.linkColor : '#ffffff';
        widget.originalLinkColor = widget.linkColor;

        widget.hasGraph = false;
        widget.showGraph = rawWidget.showGraph;
        widget.originalShowGraph = widget.showGraph;

        widget.contentUri = xenos.context.path + rawWidget.dataUrl + '/' + self.pk + '/' + widget.pk + '.json';
        widget.contentInterval = rawWidget.asyncInterval;

        widget.widgetType = rawWidget.widgetType;
        widget.widgetTypePk = rawWidget.widgetTypePk;
        widget.widgetTypeDescription = widget.widgetTypeDesc;

        if (rawWidget.allFeedsUrl && rawWidget.allFeedsUrl != '')
          widget.feedsUri = xenos.context.path + rawWidget.allFeedsUrl + '.json';

        widget.feedAddable = rawWidget.feedSelectable ? (rawWidget.feedSelectable == 'Y') : false;
        widget.feedRemovable = rawWidget.feedUnselectable ? (rawWidget.feedUnselectable == 'Y') : false;
        widget.feedRefreshable = rawWidget.feedRefreshable ? (rawWidget.feedRefreshable == 'Y') : false;
        widget.refreshIntervalMin = rawWidget.refreshIntervalMin ? rawWidget.refreshIntervalMin : 0;

        // prepare
        self.availableWidgets[widget.pk] = widget;
        self.availableWidgetsOrder[self.availableCount++] = widget.pk;
      });
    });
  };


  // rendition
  this.renderer = new xenos$DBD$Workspace$renderer(this);


  // other functions

  // workspace updater
  this.workspaceUpdater = function(update) {
    if (update) {
      self.updateWorkspace();
    } else {
      self.discardUpdate();
    }
  };


  // update workspace
  this.updateWorkspace = function(callback, delegator) {
    var uri = xenos.context.path + '/secure/ref/widget/reorder.json';


    var json = ''
        + '{'
        + '"workSpacePk": ' + self.pk + ','
        + '"widgetMetaDataDTOs": [';

    jQuery.each(self.widgetsOrder, function(order, pk) {
      order = parseInt(order) + 1;

      json += ''
          + '{'
          + '"pk": ' + pk + ','
          + '"order": ' + order
          + '}';

      if (order < self.count) json += ',';
    });

    json += ''
        + ']'
        + '}';


    jQuery.ajax({
      url: uri,
      type: 'POST',
      contentType: 'application/json',
      data: json,
      success: function(json) {
        if (!json.success) {
          console.log(json);
          xenos.postNotice(xenos.notice.type.error, xenos$DBD$i18n.workspace.workspace_not_saved + self.name);
          return;
        }

        jQuery.each(self.widgets, function(pk, widget) {
          widget.reordered = false;
        });

        self.originalWidgetsOrder = self.widgetsOrder;

        self.dirty = false;

        xenos.postNotice(xenos.notice.type.info, self.name + xenos$DBD$i18n.workspace.workspace_saved);
        if (callback) callback.call(delegator ? delegator : self, workspace);
      }
    });

    return true;
  };

  // discard update
  this.discardUpdate = function() {
    self.widgetsOrder = self.originalWidgetsOrder;
    self.childrenOrder = self.originalWidgetsOrder;

    self.dirty = false;
  };


  // reorder widgets
  this.reorderWidgets = function(widgetsOrder, callback, delegator) {
    // reordered?
    var reordered;
    for (var order = 0; order < self.count; order++) {
      if (self.widgetsOrder[order] != widgetsOrder[order])
        reordered = true;

      // fixed order
      if (widgetsOrder[order]
          && self.widgets[widgetsOrder[order]].order != order) {
        self.widgets[widgetsOrder[order]].order = order;
        self.widgets[widgetsOrder[order]].reordered = true;
      }
    }
    if (!reordered) return false;

    self.widgetsOrder = widgetsOrder;
    self.childrenOrder = widgetsOrder;

    self.dirty = true;

    if (callback) callback.call(delegator ? delegator : self, self);
    return true;
  };


  // add widgets
  this.addWidgets = function(_widgetsOrder, callback, delegator) {
    var adder = function() {
      var order = this;
      var widget
          = order.template
              ? self.templateWidgetByOrder(order.order)
              : self.availableWidgetByOrder(order.order);

      var uri = xenos.context.path;
      if (widget.template) {
        uri += '/secure/ref/widget/new/' + self.pk + '/' + widget.widgetTypePk + '/' + widget.name + '/' + self.count + '.json';
      } else {
        uri += '/secure/ref/widget/add/' + self.pk + '/' + widget.pk + '/' + self.count + '.json';
      }

      jQuery.getJSON(uri, function(json) {
        if (!json.success) {
          console.log(json);
          xenos.postNotice(xenos.notice.type.error, xenos$DBD$i18n.workspace.widget_not_added + widget.name);
          return;
        }

        // from template?
        // need to extract details
        if (order.template) {
          var newWidget = new xenos$DBD$Widget(self);
          newWidget.template = false;
          newWidget.pk = json.value[0].pk;
          newWidget.name = 'Untitled ' + widget.name;
          newWidget.originalName = 'Untitled ' + widget.name;
          newWidget.order = widget.order;

          newWidget.user = json.value[0].systemDefined ? (json.value[0].systemDefined == 'N') : false;

          newWidget.draggable = widget.draggable;
          newWidget.resizable = widget.resizable;
          newWidget.configurable = widget.configurable;
          newWidget.closeable = widget.closeable;

          newWidget.backColor = json.value[0].backgroundcolor;
          newWidget.originalBackColor = newWidget.backColor;

          newWidget.foreColor = widget.foreColor;
          newWidget.originalForeColor = widget.originalForeColor;
          newWidget.linkColor = widget.linkColor;
          newWidget.originalLinkColor = widget.originalLinkColor;

          newWidget.hasGraph = widget.hasGraph;
          newWidget.showGraph = widget.showGraph;
          newWidget.originalShowGraph = widget.originalShowGraph;

          newWidget.contentUri = xenos.context.path + json.value[0].dataUrl + '/' + self.pk + '/' + newWidget.pk + '.json';
          newWidget.contentInterval = json.value[0].asyncInterval;

          newWidget.widgetType = widget.widgetType;
          newWidget.widgetTypePk = widget.widgetTypePk;
          newWidget.widgetTypeDescription = widget.widgetTypeDesc;

          newWidget.feedsUri = widget.feedsUri;
          newWidget.feedAddable = widget.feedAddable;
          newWidget.feedRemovable = widget.feedRemovable;
          newWidget.feedRefreshable = widget.feedRefreshable;
          newWidget.refreshIntervalMin = widget.refreshIntervalMin;

          widget = newWidget;
        }

        // add to widgets
        widget.parent = self;
        widget.order = self.count;
        widget.selector = self.pk + 'x' + widget.pk + 'x' + widget.order;

        widget.editable = self.editable;
        if (widget.content)
          widget.content.editable = widget.editable;

        self.widgets[widget.pk] = widget;
        self.widgetsOrder[self.count] = widget.pk;
        self.originalWidgetsOrder[self.count] = widget.pk;

        self.count++;
        widget.connect();

        // not from template?
        // need to remove from availableWidgets
        if (!order.template) {
          self.availableCount--;

          delete self.availableWidgets[widget.pk];

          for (var newOrder = 0; newOrder < self.availableCount; newOrder++)
            if (newOrder >= order.order) {
              self.availableWidgetsOrder[newOrder] = self.availableWidgetsOrder[newOrder + 1];
              self.availableWidgets[self.availableWidgetsOrder[newOrder]].order = newOrder;
            }

          delete self.availableWidgetsOrder[self.availableCount];
        }

        order.done = true;
        xenos.postNotice(xenos.notice.type.info, widget.name + xenos$DBD$i18n.workspace.widget_added);
        if (callback) callback.call(delegator ? delegator : self, widget);
      });
    };

    jQuery.each(_widgetsOrder, function(o, order) {
      order.adder = adder;
    });
    xenos.delegateToAll({
      targets: _widgetsOrder,
      operation: 'adder',
      state: 'done'
    });

    return true;
  };

  // close widget
  this.closeWidget = function(widgetOrder, callback, delegator) {
    var widget = self.widgetByOrder(widgetOrder);

    var uri = xenos.context.path + '/secure/ref/widget/close/' + self.pk + '/' + widget.pk + '.json';
    jQuery.getJSON(uri, function(json) {
      if (!json.success) {
        console.log(json);
        xenos.postNotice(xenos.notice.type.error, xenos$DBD$i18n.workspace.widget_not_closed + widget.name);
        return;
      }

      // remove from widgets
      self.count--;
      widget.dispose();

      delete self.widgets[widget.pk];

      for (var newOrder = 0; newOrder < self.count; newOrder++)
        if (newOrder >= widgetOrder) {
          self.widgetsOrder[newOrder] = self.widgetsOrder[newOrder + 1];
          self.widgets[self.widgetsOrder[newOrder]].order = newOrder;
        }

      delete self.widgetsOrder[self.count];

      var originalOrder;
      jQuery.each(self.originalWidgetsOrder, function(order, pk) {
        if (pk == widget.pk) {
          originalOrder = order;
          return false;
        }
      });

      for (newOrder = 0; newOrder < self.count; newOrder++)
        if (newOrder >= originalOrder)
          self.originalWidgetsOrder[newOrder] = self.originalWidgetsOrder[newOrder + 1];

      delete self.originalWidgetsOrder[self.count];

      widget.order = self.availableCount;

      // add to availableWidgets
      self.availableCount++;

      self.availableWidgets[widget.pk] = widget;
      self.availableWidgetsOrder[widget.order] = widget.pk;

      // anymore reordered widgets?
      var reordered;
      jQuery.each(self.widgets, function(pk, widget) {
        if (widget.reordered) {
          reordered = widget.reordered;
          return false;
        }
      });
      self.dirty = reordered;

      xenos.postNotice(xenos.notice.type.info, widget.name + xenos$DBD$i18n.workspace.widget_closed);
      if (callback) callback.call(delegator ? delegator : self, widget);
    });

    return true;
  };

  // delete widget
  this.deleteWidget = function(widgetOrder, callback, delegator) {
    var widget = self.availableWidgetByOrder(widgetOrder);

    var uri = xenos.context.path + '/secure/ref/widget/delete/' + widget.pk + '.json';

    jQuery.getJSON(uri, function(json) {
      if (!json.success) {
        console.log(json);
        xenos.postNotice(xenos.notice.type.error, xenos$DBD$i18n.workspace.widget_not_deleted + widget.name);
        return;
      }

      // need to remove from availableWidgets
      self.availableCount--;

      delete self.availableWidgets[widget.pk];

      for (var newOrder = 0; newOrder < self.availableCount; newOrder++)
        if (newOrder >= widgetOrder) {
          self.availableWidgetsOrder[newOrder] = self.availableWidgetsOrder[newOrder + 1];
          self.availableWidgets[self.availableWidgetsOrder[newOrder]].order = newOrder;
        }

      delete self.availableWidgetsOrder[self.availableCount];

      xenos.postNotice(xenos.notice.type.info, widget.name + xenos$DBD$i18n.workspace.widget_deleted);
      if (callback) callback.call(delegator ? delegator : self, widget);
    });
  };
}


// Widget
function xenos$DBD$Widget(parent) {
  // inherit
  this.inherit = xenos$DBD$object;
  this.inherit(parent, 'xenos$DBD$Widget');
  // self
  var self = this;


  // attributes
  this.template;
  this.pk;
  this.name;
  this.originalName;
  this.order;
  this.selector;

  this.backColor;
  this.originalBackColor;
  this.foreColor;
  this.originalForeColor;
  this.linkColor;
  this.originalLinkColor;

  this.hasGraph;
  this.showGraph;
  this.originalShowGraph;

  this.draggable;
  this.resizable;
  this.configurable;
  this.closeable;

  this.dirty;

  this.widgetType;
  this.widgetTypePk;
  this.widgetTypeDescription;

  this.feedsUri;
  this.feedAddable;
  this.feedRemovable;
  this.feedRefreshable;
  this.refreshIntervalMin;
  this.newFeedOrderList = [];
  this.feedReordered = false;
  
  this.editable = self.parent.editable;

  // content
  this.content;
  this.contentUri;
  this.contentInterval;
  this.pollingId;

  // feeds
  this.feeds = {};
  this.feedsFound = false;

  // prepare feeds
  this.prepareFeeds = function() {
    self.feeds = {};
    self.feedsFound = false;
    var displayOrder = -1;
    
    jQuery.getJSON(self.feedsUri, function(json) {
      if (!json.success) {
        console.log(json);
        return;
      }

      // all feeds
      jQuery.each(json.value, function(order, rawFeed) {
    	displayOrder++;
        var feed = {
          pk: rawFeed.pk,
          name: rawFeed.name,
          categoryName: rawFeed.categoryName,
          categoryPk: rawFeed.categoryPk,
          originalName: rawFeed.name,
          maiden: true,
          error: false,
          data: 0,
          dataUri: rawFeed.dataUrl,
          dataInterval: rawFeed.asyncInterval,
          pollingId: 0,
          viewUri: rawFeed.feedUrl
        };
        self.feeds[displayOrder] = feed;
      });

      self.feedsFound = true;
    });
  };


  this.polling = function() {
    jQuery.getJSON(self.contentUri, function(json) {
      if (!json.success) {
        console.log(json);
        self.content.render('update');
        return;
      }

      self.content.prepared = false;
      self.content.json = json;
      self.content.render('update');
    });
  };


  // children
  this.children = {};
  this.childrenOrder = {};


  // preparation
  this.prepareActivity = function() {
    // prepare feeds
    if (self.feedsUri && self.feedAddable)
      self.prepareFeeds();

    return jQuery.getJSON(self.contentUri, function(json) {
      if (!json.success) {
        console.log(json);
        self.content = new xenos$DBD$Content(self);
        return;
      }

      // content
      // implementation
      if (self.widgetType == 'BUSINESS') {
        self.content = new xenos$DBD$BusinessFeed(self);
      } else if (self.widgetType == 'SAVED_QUERY') {
        self.content = new xenos$DBD$SavedQuery(self);
      } else if (self.widgetType == 'TASK_LIST') {
        self.content = new xenos$DBD$TaskFeed(self);
      } else if (self.widgetType == 'MENU_SHORTCUT') {
        self.content = new xenos$DBD$MenuShortcut(self);
      } else {
        self.content = new xenos$DBD$Content(self);
      }

      // plug json
      self.content.json = json;

      self.children['content'] = self.content;
      self.childrenOrder[0] = 'content';
    });
  };


  // rendition
  this.renderer = new xenos$DBD$Widget$renderer(this);


  // connection
  this.connectActivity = function() {
    if (self.contentInterval) {
      setTimeout(function() {self.polling();}, 0);

      if (!self.pollingId)
        self.pollingId = setInterval(function() {self.polling();}, self.contentInterval);
    }
  };

  this.disconnectActivity = function() {
    if (self.pollingId) {
      clearInterval(self.pollingId);
      self.pollingId = 0;
    }
  };


  // other functions

  // widget updater
  this.widgetUpdater = function(update) {
    if (update) {
      self.updateWidget();
    } else {
      self.discardUpdate();
    }
  };


  // update widget
  this.updateWidget = function(callback, delegator) {
    var uri = xenos.context.path + '/secure/ref/widget/save.json';
    
    this.formNewFeedOrderList();
    
	var json = ''
        + '{'
        + '"workSpacePk": ' + self.parent.pk + ','
        + '"widgetMetaDataDTOs": ['
        + '{'
        + '"pk": ' + self.pk + ','
        + '"widgetType": "' + self.widgetType + '",'
        + '"name": "' + encodeURIComponent(self.name) + '",'
        + '"order": ' + self.order + ','
        + '"backgroundcolor": "' + self.backColor + '",'
        + '"foregroundcolor": "' + self.foreColor + '",'
        + '"linkColor": "' + self.linkColor + '",'
        + '"showGraph": ' + self.showGraph + ','
		+ '"newFeedOrderList": [' + self.newFeedOrderList + ']'
        + '}'
        + ']'
        + '}';


    jQuery.ajax({
      url: uri,
      type: 'POST',
      contentType: 'application/json',
      data: json,
      success: function(json) {
        if (!json.success) {
          console.log(json);
          xenos.postNotice(xenos.notice.type.error, xenos$DBD$i18n.widget.widget_not_saved + self.name);
          return;
        }

        self.originalName = self.name;

        self.originalBackColor = self.backColor;
        self.originalForeColor = self.foreColor;
        self.originalLinkColor = self.linkColor;

        self.originalShowGraph = self.showGraph;

        self.dirty = false;

        xenos.postNotice(xenos.notice.type.info, self.name + xenos$DBD$i18n.widget.widget_saved);
        if (callback) callback.call(delegator ? delegator : self, self);
      }
    });
  };

  // discard update
  this.discardUpdate = function() {
    self.name = self.originalName;

    self.backColor = self.originalBackColor;
    self.foreColor = self.originalForeColor;
    self.linkColor = self.originalLinkColor;

    self.showGraph = self.originalShowGraph;

    self.dirty = false;
  };


  // edit name
  this.editName = function(name, callback, delegator) {
    // fixed name
    if (!name || name == '') return false;

    // edited
    if (self.name == name) return false;

    self.name = name;

    self.dirty = true;
    if (callback) callback.call(delegator ? delegator : self, self);

    return true;
  };
  // indicate feed order modification
  this.editFeedOrder = function() {
	self.dirty = true;
	self.feedReordered = true;
  };
	
  // modified feed order
  this.formNewFeedOrderList = function($feedReorderArray) {
	if(self.feedReordered) {
		var $feeds = jQuery('#Widget' + self.selector).find('.row');
		jQuery.each($feeds, function(i) {
			 self.newFeedOrderList[i]=$($feeds[i]).attr('pk'); 
		});
		self.feedReordered = false;
	} else {
		self.newFeedOrderList = [];
	}
  };
  // configure backColor
  this.configureBackColor = function(backColor, callback, delegator) {
    // configured
    if (self.backColor == backColor) return false;

    self.backColor = backColor;

    self.dirty = true;
    if (callback) callback.call(delegator ? delegator : self, self);

    return true;
  };

  // configure foreColor
  this.configureForeColor = function(foreColor, callback, delegator) {
    // configured
    if (self.foreColor == foreColor) return false;

    self.foreColor = foreColor;

    self.dirty = true;
    if (callback) callback.call(delegator ? delegator : self, self);

    return true;
  };

  // configure linkColor
  this.configureLinkColor = function(linkColor, callback, delegator) {
    // configured
    if (self.linkColor == linkColor) return false;

    self.linkColor = linkColor;

    self.dirty = true;
    if (callback) callback.call(delegator ? delegator : self, self);

    return true;
  };

  // configure showGraph
  this.configureShowGraph = function(showGraph, callback, delegator) {
    self.showGraph = showGraph == 'checked';

    self.dirty = true;
    if (callback) callback.call(delegator ? delegator : self, self);

    return true;
  };
}


// Content
function xenos$DBD$Content(parent) {
  // inherit
  this.inherit = xenos$DBD$object;
  this.inherit(parent, 'xenos$DBD$Content');
  // self
  var self = this;


  // attributes
  this.editable = self.parent.editable;

  // content
  this.json;


  // preparation
  this.prepareActivity = function() {
  };


  // rendition
  this.renderer = new xenos$DBD$Content$renderer(this);
}
//
// xenos
//  - Dashboard renderer infrastructure
//


// Controllers
function xenos$DBD$Element$Controllers() {
  // primary handle
  var $controllers = jQuery('.controllers');
  $controllers.css('position','absolute');
  // other handles
  var $control = jQuery('#control');
  var $action = jQuery('.action');
  var $navigation = jQuery('.navigation');


  // primary function
  // handle
  this.handle = function() {
    return $controllers;
  };


  // other function
  // align
  this.align = function() {
    var right_and_left
    	= $control.width()-$controllers.width();
            //- $controllers.outerWidth()
            //- $action.outerWidth(true)
            //- $navigation.outerWidth(true);

    // apply
    $controllers.css('margin-left', right_and_left / 2);
  };
}


// Workspaces
function xenos$DBD$Element$Workspaces() {
  // primary handle
  var $workspaces = jQuery('#workspaces');

  // other handle
  var $container = jQuery('#content');
  var $control = jQuery('#control');


  // primary function
  // handle
  this.handle = function() {
    return $workspaces;
  };


  // other function
  // resize
  this.resize = function() {
    var width
        = $container.width();

    var height
        = parseFloat($container.css('min-height').replace(/[^-\d\.]/g, ''))
            - $control.outerHeight(true);

    // apply
    $workspaces.css('width', width);
    $workspaces.css('height', height);
  };
}


// Lading
function xenos$DBD$Element$Loading() {
  // primary handle
  var $loading = jQuery('.loading');

  // other handle
  var $workspaces = jQuery('#workspaces');


  // primary function
  // handle
  this.handle = function() {
    return $loading;
  };


  // other function
  // align
  this.align = function() {
    var right_and_left
        = $workspaces.width()
            - $loading.outerWidth(true);

    var top_and_bottom
        = $workspaces.height()
            - $loading.outerHeight(true);

    // apply
    $loading.offset({left: right_and_left / 2, top: top_and_bottom / 2});
  };


  // show
  this.show = function() {
    // apply
    $loading.css('display', 'inline-block');
  };

  // hide
  this.hide = function() {
    // apply
    $loading.css('display', 'none');
  };


  // remove
  this.remove = function() {
    // apply
    $loading.remove();
  };
}


// Dashboard
function xenos$DBD$Dashboard$renderer(object) {
  // inherit
  this.inherit = xenos$DBD$renderer;
  this.inherit(object);
  // self
  var self = this;

  // Object for the the function for delete and edit saved query.
  this.deleteSavedQueryObj = new xenos$DBD$DeleteSavedQuery(object);
  
  // attributes

  // flow
  this.flow;


  // fix size
  this.fixSize = function() {
    // primary handle
    var $dashboard = jQuery('#dashboard');

    // other handle
    var controllers = new xenos$DBD$Element$Controllers();
    var workspaces = new xenos$DBD$Element$Workspaces();


    // look and feel
    controllers.align();
    workspaces.resize();

    // flow
    $dashboard.xenosFlow({
      width: workspaces.handle().width(),
      height: workspaces.handle().height()
    });
  };


  // editable
  self.object.onEditable = function() {
    // primary handle
    var $editableWorkspace = jQuery('.editableWorkspace');
    var $addWidget = jQuery('.addWidget');
    var $addWorkspace = jQuery('.addWorkspace');
    var $removeWorkspace = jQuery('.removeWorkspace');
    var $savedQueryList = jQuery('.savedQueryList');

    $editableWorkspace.addClass('editable');
    $addWidget.show();
    $addWorkspace.show();
    $removeWorkspace.show();
    $savedQueryList.show();

    self.fixSize();
  };
  // uneditable
  self.object.onUneditable = function() {
    // primary handle
    var $editableWorkspace = jQuery('.editableWorkspace');
    var $addWidget = jQuery('.addWidget');
    var $addWorkspace = jQuery('.addWorkspace');
    var $removeWorkspace = jQuery('.removeWorkspace');
    var $savedQueryList = jQuery('.savedQueryList');

    $editableWorkspace.removeClass('editable');
    $addWidget.hide();
    $addWorkspace.hide();
    $removeWorkspace.hide();
    $savedQueryList.hide();

    self.fixSize();
  };


  // hide add widget
  this.hideAddWidget = function(e) {
    var $addWidget = jQuery('.addWidgetDialog');
    if ($addWidget.length == 0) return;

    var aw = jQuery(e.target).parents('.ui-dialog').find('.addWidgetDialog').length;
    if (e.target == $addWidget[0] || aw > 0) return;

    $addWidget.dialog('close');
  };


  // fix add widget
  this.fixAddWidget = function(order) {
    var $addWidget = jQuery('.addWidget');

    var workspace = self.object.workspaceByOrder(order);

    $addWidget.off('mouseenter mouseleave');
    $addWidget.hover(
        function() {
          $addWidget.addClass('addWidgetHover');
          $addWidget.attr('title', 'Add widget');
        },
        function() {
          $addWidget.removeClass('addWidgetHover');
          $addWidget.removeAttr('title');
        }
    );

    $addWidget.off('click');
    $addWidget.on('click', function() {
      var dialog = ''
          + '<div class="addWidgetDialog marginFour paddingFour">'
          + '  <div class="addWidgetHolder">';

      dialog += '<div class="non-scrollable">';
      jQuery.each(workspace.templateWidgetsOrder, function(order, pk) {
        var widget = workspace.templateWidgets[pk];
		var escapedName = self.object.escapeHtml(widget.name);

        dialog += ''
            + '    <div class="row">'
            + '      <div class="left contentBlockValue marginRight">'
            + '        <span><input id="addWidgetNoScroll' + widget.order + '" class="AddWidgetId" type="checkbox" value="' + widget.order + '" template="true"/></span>'
            + '      </div>'
            + '      <div class="left contentBlockLabel">'
            + '        <label for="addWidgetNoScroll' + widget.order + '"><span title="' + escapedName + '">' + escapedName + '</span></label>'
            + '      </div>'
            + '      <div class="clear"></div>'
            + '    </div>';
      });

      if (workspace.templateCount != 0) {
        dialog += ''
            + '    <div class="row bar">'
            + '      <div class="left contentBlockValue"></div>'
            + '      <div class="left contentBlockLabel"></div>'
            + '      <div class="clear"></div>'
            + '    </div>';
      }
      dialog += '</div>';

      dialog += '<div class="scrollable">';
      jQuery.each(workspace.availableWidgetsOrder, function(order, pk) {
        var widget = workspace.availableWidgets[pk];
        var escapedName = self.object.escapeHtml(widget.name);

        dialog += ''
            + '    <div class="row">'
            + '      <div class="left contentBlockValue marginRight">'
            + '        <span><input id="addWidgetScroll' + widget.order + '" class="AddWidgetId" type="checkbox" value="' + widget.order + '" template="false"/></span>'
            + '      </div>'
            + '      <div class="left contentBlockLabel">'
            + '        <label for="addWidgetScroll' + widget.order + '"><span title="' + escapedName + '">' + escapedName + '</span></label>'
            + '      </div>';

        if (widget.user) {
          dialog += ''
              + '      <div class="left">'
              + '        <a href="#" title="Delete this widget" class="deleteWidgetButton" order="' + widget.order + '">h</a>'
              + '      </div>';
        }

        dialog += ''
            + '      <div class="clear"></div>'
            + '    </div>';
      });
      dialog += '</div>';

      dialog += ''
          + '  </div>'
          + '  <div class="right" style="margin:4px 0 0 0;">'
      + '    <div class="submitBtn"><input type="button" value="Add" class="AddWidgetDone inputBtnStyle"/></div>'
          + '  </div>'
          + '  <div class="clear"></div>'
          + '</div>';


      var $dialog = jQuery(dialog);


      var offset = $addWidget.offset();
      $dialog.dialog({
        position: [offset.left + $addWidget.outerWidth(true) + 4, offset.top],
        draggable: false,
        title: 'Widgets',
        width: 220,
        resizable: false,
        open: function() {
          $addWidget.addClass('addWidgetActive');
          $dialog.find('.scrollable').css('height', $dialog.find('.addWidgetHolder').height() - $dialog.find('.non-scrollable').outerHeight(true) - 13);
          $dialog.find('.scrollable').jScrollPane({showArrows: true});

          $dialog.find('.deleteWidgetButton').click(function() {
            var widgetOrder = jQuery(this).attr('order');
            // get the confirmation
            jConfirm(xenos$DBD$i18n.workspace.confirm_widget_delete, null, function(confirmation) {
              if (confirmation) {
                self.object.workspaceByOrder(order).deleteWidget(widgetOrder);

                $dialog.dialog('close');
              }
            });
          });

          $dialog.find('.AddWidgetDone').click(function() {
            var availableCount = 0;

            var addWidgetsOrder = [];
            jQuery('.AddWidgetId').each(function() {
              var $this = jQuery(this);
              if ($this.attr('checked') == 'checked') {
                var template = $this.attr('template') == 'true';
                var order = template
                    ? $this.val() : ($this.val() - availableCount++);

                addWidgetsOrder.push({order: order, template: template});
              }
            });


            var _function = function(widget) {
              self.fixAddWidget(widget.parent.order);
              self.fixRemove(widget.parent.order);
            };
            self.object.workspaceByOrder(order).addWidgets(addWidgetsOrder, _function, self);

            $dialog.dialog('close');
          });
        },
        close: function() {
          $addWidget.removeClass('addWidgetActive');
          $dialog.dialog('destroy');
          $dialog.remove();
       }
      });
    });
  };

  // fix remove
  this.fixRemove = function(order) {
    if (order == self.object.defaultWorkspace().order
        || self.object.workspaceByOrder(order).hasWidgets()) {
      self.flow.disableRemove();
    } else {
      self.flow.enableRemove();
    }
  };

  // fix update
  this.fixUpdate = function(order) {
    var $updateWorkspace = jQuery('.updateWorkspace');
    var $content = jQuery('#content');

    if (self.object.workspaceByOrder(order).dirty) {
      $content.saverOn(self.object.workspaceByOrder(order).workspaceUpdater);

      $updateWorkspace.css('display', 'inline-block');

      $updateWorkspace.hover(
          function() {
            $updateWorkspace.addClass('updateWorkspaceHover');
            $updateWorkspace.attr('title', 'Save this workspace');
          },
          function() {
            $updateWorkspace.removeClass('updateWorkspaceHover');
            $updateWorkspace.removeAttr('title');
          }
      );

      $updateWorkspace.off('click');
      $updateWorkspace.on('click', function() {
        $content.saverOff(self.object.workspaceByOrder(order).workspaceUpdater);

        $updateWorkspace.css('display', 'none');

        var controllers = new xenos$DBD$Element$Controllers();
        controllers.align();

        self.object.workspaceByOrder(order).updateWorkspace();
      });
    } else {
      $content.saverOff(self.object.workspaceByOrder(order).workspaceUpdater);

      $updateWorkspace.css('display', 'none');
    }
  };


  // render
  this.render = function(unprepared) {
    // primary handle
    var $dashboard = jQuery('#dashboard');

    // other handle
    var controllers = new xenos$DBD$Element$Controllers();
    var workspaces = new xenos$DBD$Element$Workspaces();
    var loading = new xenos$DBD$Element$Loading();


    // look and feel
    controllers.align();
    workspaces.resize();
    loading.remove();

    // flow
    self.flow = $dashboard.xenosFlow({
      slideType: 'workspace',
      slideNames: self.object.workspacesName,
      slidesSelector: '#workspaces',
      width: workspaces.handle().width(),
      height: workspaces.handle().height(),
      selectedIndex: self.object.selectedWorkspace() ? self.object.selectedWorkspace().order : -1,
      selectedClass: 'selectedWorkspace',
      controllersSelector: '.controller',
      previousSelector: '.previousWorkspace',
      nextSelector: '.nextWorkspace',
      addSelector: '.addWorkspace',
      addHoverClass: 'addWorkspaceHover',
      enabledAddTitle: 'Add new workspace',
      addToTail: true,
      removeSelector: '.removeWorkspace',
      removeHoverClass: 'removeWorkspaceHover',
      enabledRemoveTitle: 'Remove this workspace',
      slideTemplate: '<div class="workspaceHolder workspace${slideIndex}"><div class="clear"></div></div>',
      controllerTemplate: '<span class="controller" activeTitle="${slideName}" inactiveTitle="Switch to ${slideName}"></span>',
      activeControllerTitleTemplate: '${slideName}',
      inactiveControllerTitleTemplate: 'Switch to ${slideName}',
      onSwitch: function(order) {
        if (!self.object.hasWorkspaces()) return;

        self.object.selectedWorkspacePk = self.object.workspaceByOrder(order).pk;
        self.object.disconnect();
        self.object.connect();

        self.fixAddWidget(order);
        self.fixRemove(order);
        self.fixUpdate(order);

        controllers.align();
      },
      preAdd: function(order) {
        // get the name
        jPrompt(xenos$DBD$i18n.dashboard.new_workspace_name, '', null, function(name) {
          if (name == null) return;
          name = $.trim(name);
          if (name != null && name != '') {
            var _function = function(workspace) {
              workspace.render('render', true);
              self.flow.add(name, false, workspace);
            };
            self.object.addWorkspace(name, order, _function, self);
          } else {
            xenos.postNotice(xenos.notice.type.info, xenos$DBD$i18n.dashboard.no_workspace_name);
          }
        });
      },
      onAdd: function(oldOrder, order, workspace) {
        self.fixAddWidget(order);
        self.fixRemove(order);
        self.fixUpdate(order);

        controllers.align();
      },
      preRemove: function(order) {
        // get the confirmation
        jConfirm(xenos$DBD$i18n.dashboard.confirm_workspace_remove, null, function(confirmation) {
          if (confirmation) {
            var _function = function(workspace) {
              jQuery('#content').saverOff(workspace.workspaceUpdater);
              self.flow.remove(workspace.name, true, workspace);
            };
            self.object.removeWorkspace(order, _function, self);
          }
        });
      },
      onRemove: function(oldOrder, order, workspace) {
        self.fixAddWidget(order);
        self.fixRemove(order);
        self.fixUpdate(order);

        controllers.align();
      }
    }).disableRemove();


    if (self.object.selectedWorkspace()) {
	  self.deleteSavedQueryObj.savedQueryList();
      self.fixAddWidget(self.object.selectedWorkspace().order);
      self.fixRemove(self.object.selectedWorkspace().order);
      self.fixUpdate(self.object.selectedWorkspace().order);

      controllers.align();
    }


    // editable/uneditable
    var $editableWorkspace = jQuery('.editableWorkspace');
    $editableWorkspace.off('click');
    $editableWorkspace.on('click', function() {
      if (self.object.editable) {
        self.object.makeUneditable();
      } else {
        self.object.makeEditable();
      }
    });


    jQuery(window).on('resize', self.fixSize);
    jQuery(document).on('mousedown', self.hideAddWidget);


    // additional
    xenos$Event.on('menu-area-expanded menu-area-collapsed', self.fixSize);
  };


  this.dispose = function() {
    jQuery(window).off('resize', self.fixSize);
    jQuery(document).off('mousedown', self.hideAddWidget);

    // additional
    xenos$Event.off('menu-area-expanded menu-area-collapsed', self.fixSize);
  };
}


// Workspace
function xenos$DBD$Workspace$renderer(object) {
  // inherit
  this.inherit = xenos$DBD$renderer;
  this.inherit(object);
  // self
  var self = this;


  this.render = function(unprepared) {
    if (!unprepared && this.object.preRendered) {
      // fix add widget
      self.object.parent.renderer.fixAddWidget(self.object.order);
      self.object.parent.renderer.fixRemove(self.object.order);
    }


    if (self.object.preRendered) return;
    self.object.preRendered = true;


    // primary handle
    var $dashboard = jQuery('#dashboard');

    // other handle
    var controllers = new xenos$DBD$Element$Controllers();
    var workspaces = new xenos$DBD$Element$Workspaces();


     // look and feel
	var escapedName = self.object.escapeHtml(this.object.name);
    var controller = ''
        + '<span class="controller" activeTitle="' + escapedName + '" inactiveTitle="Switch to ' + this.object.name + '">'
        + '  <span class="dashboardName">'
        + '    <span class="dashboardName-arrow"></span>'
        + '    <span class="dashboardName-inner">' + escapedName + '</span>'
        + '  </span>'
        + '</span>';
    controllers.handle().append(controller);

    var workspace = '<div class="workspaceHolder workspace' + this.object.pk + '"><div class="clear"></div></div>';
    workspaces.handle().append(workspace);
  };
}


// Widget
function xenos$DBD$Widget$renderer(object) {
  // inherit
  this.inherit = xenos$DBD$renderer;
  this.inherit(object);
  // self
  var self = this;
  var timer;

  // editable
  self.object.onEditable = function() {
    var $workspace = jQuery('.workspace' + self.object.parent.pk);
    $workspace.sortable('enable');
    $workspace.disableSelection();

    var $widget = jQuery('#Widget' + self.object.selector);
    $widget.addClass('editable');
    $widget.find('.editButtonHolder').show();
    $widget.find('.addButtonHolder').show();
    $widget.find('.configureButtonHolder').show();
    $widget.find('.closeButtonHolder').show();
    
	// Making Feeds Draggable.
	self.timer = setInterval(function() {
		if($($widget).find('.jspPane').length>0){
			clearInterval(self.timer);
		}
		$($widget).find('.jspPane').sortable('enable');
		$($widget).find('.jspPane').sortable({
			stop: function(e, ui) {
				self.object.editFeedOrder(true);
				self.fixUpdate();
			}
		}); 
	},100);
  };
  // uneditable
  self.object.onUneditable = function() {
    var $workspace = jQuery('.workspace' + self.object.parent.pk);
    $workspace.sortable('disable');

    var $widget = jQuery('#Widget' + self.object.selector);
    $widget.removeClass('editable');
    $widget.find('.editButtonHolder').hide();
    //$widget.find('.addButtonHolder').hide(); needs special treatment
    $widget.find('.configureButtonHolder').hide();
    $widget.find('.closeButtonHolder').hide();
    
    $($widget).find('.jspPane').sortable('disable');
    
    // content
    // specific
    if (self.object.widgetType == 'BUSINESS') {
      $widget.find('.addButtonHolder').hide();
    } else if (self.object.widgetType == 'SAVED_QUERY') {
      $widget.find('.addButtonHolder').hide();
    } else if (self.object.widgetType == 'TASK_LIST') {
      // no-op;
    } else if (self.object.widgetType == 'MENU_SHORTCUT') {
      $widget.find('.addButtonHolder').hide();
    }
  };


  // hide edit name
  this.hideEditName = function(e) {
    var $widget = jQuery('#Widget' + self.object.selector);
    var $name = $widget.find('.widgetName');
    var $editName = $widget.find('.editWidgetName');

    if (e.target == $name[0] || e.target == $editName[0]) return;

    self.object.editName($editName.val());
    self.fixUpdate();

    $editName.css('display', 'none');

    $name.text(self.object.name);
    $name.attr('title', self.object.name);
    $name.css('display', 'block');
  };

  // hide add feed
  this.hideAddFeed = function(e) {
    var $add = jQuery('.addFeed');
    if ($add.length == 0) return;

    var af = jQuery(e.target).parents('.addFeed').length;
    if (e.target == $add[0] || af > 0) return;

    $add.remove();

    //hide button background
    $('.addFeedButton').parent().parent().addClass('addButtonOpc');
  };

  // hide configure widget
  this.hideConfigureWidget = function(e) {
    var $configure = jQuery('.configureWidget');
    if ($configure.length == 0) return;

    var cs = jQuery(e.target).parents('#color_selector').length;
    var cw = jQuery(e.target).parents('.configureWidget').length;
    if (e.target == $configure[0] || cs > 0 || cw > 0) return;

    $configure.remove();

    //hide button background
    $('.widgetConfigureButton').parent().parent().addClass('configureButtonOpc');
  };


  // fix update
  this.fixUpdate = function() {
    var $widget = jQuery('#Widget' + self.object.selector);

    var $updateHolder = $widget.find('.updateButtonHolder');
    var $content = jQuery('#content');

    var content = self.object.content;
    if (self.object.dirty || (content && content.dirty && jQuery.isFunction(content.contentUpdater))) {
      if (self.object.dirty)
        $content.saverOn(self.object.widgetUpdater);
      if (content && content.dirty && jQuery.isFunction(content.contentUpdater))
        $content.saverOn(content.contentUpdater);

      $updateHolder.css('display', 'inline-block');

      var $update = $widget.find('.widgetUpdateButton');

      $update.off('click');
      $update.on('click', function() {
        var content = self.object.content;

        $content.saverOff(self.object.widgetUpdater);
        if (content && jQuery.isFunction(content.contentUpdater)) $content.saverOff(content.contentUpdater);

        $updateHolder.css('display', 'none');

        if (self.object.dirty)
          self.object.widgetUpdater(true);
        if (content && content.dirty && jQuery.isFunction(content.contentUpdater))
          content.contentUpdater(true);
      });
    } else {
      $content.saverOff(self.object.widgetUpdater);
      if (content && jQuery.isFunction(content.contentUpdater)) $content.saverOff(content.contentUpdater);

      $updateHolder.css('display', 'none');
    }
  };


  this.addFeedHandle = function() {
    return jQuery('#Widget' + self.object.selector).find('.addFeedButton');
  };

  this.refreshFeedHandle = function() {
    return jQuery('#Widget' + self.object.selector).find('.refreshFeedButton');
  };

  this.configureWidgetHandle = function() {
    return jQuery('#Widget' + self.object.selector).find('.widgetConfigureButton');
  };


  this.render = function(unprepared) {
    // primary handle
    var $workspace = jQuery('.workspace' + self.object.parent.pk);

    // look and feel
    var widgetClasses = '';
    if (self.object.widgetType == 'BUSINESS') {
      widgetClasses = ' business';      
    } else if (self.object.widgetType == 'SAVED_QUERY') {
      widgetClasses = ' savedQuery';
    } else if (self.object.widgetType == 'TASK_LIST') {
      widgetClasses = ' big task';
    } else if (self.object.widgetType == 'MENU_SHORTCUT') {
      widgetClasses = ' shortcut';
    }
	var escapedName = self.object.escapeHtml(self.object.name);
    var widget = ''
        + '<div id="Widget' + self.object.selector + '" pk="' + self.object.pk + '" class="widgetHolder ' + widgetClasses + ' editable" style="background-color:' + self.object.backColor + '; color:' + self.object.foreColor + ';">'
        + '  <div class="widgetContentArea">'
        + '    <div class="widgetHeader">'		
        + '       <h1 class="widgetName" style="color:' + self.object.foreColor + ';" title="' + escapedName + '">' + escapedName + '</h1>'
        + '       <span><input class="editWidgetName" type="text" value="' + escapedName + '" style="display:none;"/></span>'
        + '    </div>'
        + '    <div class="contentHolder">'
        + '      <div class="clear"></div>'
        + '    </div>'
        + '    <div class="clear"></div>';

    widget += '<div class=buttonHolder " style="color:' + self.object.foreColor + ';">';

    // update
    widget += ''
        + '<div class="updateButtonHolder hiddenButton">'
        + '  <div><a href="#" title="Update this widget" class="widgetUpdateButton btnHolderCol" style="color:' + self.object.foreColor + ';">Q</a></div>'
        + '</div>'
        + '<div class="editButtonHolder">'
        + '  <div><a href="#" title="Edit this widget name" class="widgetEditButton btnHolderCol" style="color:' + self.object.foreColor + ';">Y</a></div>'
        + '</div>';

    if (self.object.feedAddable) {
      // add feeds
      widget += ''
          + '<div class="addButtonHolder">'
          + '  <div class="addButtonOpc">'
          + '    <div><a href="#" title="Add feed" class="addFeedButton btnHolderCol" style="color:' + self.object.foreColor + ';">M</a></div>'
          + '  </div>'
          + '</div>';
    }

    if (self.object.feedRefreshable) {
      // refresh feeds
      widget += ''
          + '<div class="refreshButtonHolder">'
          + '  <div class="refreshButtonOpc">'
          + '    <div><a href="#" title="Refresh feeds" class="refreshFeedButton btnHolderCol" style="color:' + self.object.foreColor + ';">R</a></div>'
          + '  </div>'
          + '</div>';
    }

    // configurable
    if (self.object.configurable) {
      widget += ''
          + '<div class="configureButtonHolder">'
          + '  <div class="configureButtonOpc">'
          + '    <div><a href="#" title="Configure this widget" class="widgetConfigureButton btnHolderCol" style="color:' + self.object.foreColor + ';">b</a></div>'
          + '  </div>'
          + '</div>';
    }

    // closeable
    if (self.object.closeable) {
      widget += ''
          + '<div class="closeButtonHolder">'
          + '  <div><a href="#" title="Close this widget" class="widgetCloseButton btnHolderCol" style="color:' + self.object.foreColor + ';">L</a></div>'
          + '</div>';
    }

    widget += '</div>';

    widget += ''
        + '  </div>'
        + '  <span class="tBdr"></span><span class="rBdr"></span><span class="lBdr"></span><span class="bBdr"></span>'
        + '</div>';


    var $widget = jQuery(widget);
    $workspace.children().last().before($widget);


    // draggable
    $workspace.sortable({
      stop: function() {
        // reordered?
        var widgetsOrder = {};
        $workspace.children().each(function(order, widget) {
          if (order < self.object.parent.count)
            widgetsOrder[order] = jQuery(widget).attr('pk');
        });
        if (!self.object.parent.reorderWidgets(widgetsOrder)) return;

        // fix update
        self.object.parent.parent.renderer.fixUpdate(self.object.parent.order);
      }
    });
    $workspace.disableSelection();


    self.fixUpdate();


    // name
    var $name = $widget.find('.widgetName');
    var $editName = $widget.find('.editWidgetName');

    var $editButton = $widget.find('.widgetEditButton');
    $editButton.on('click', function() {
      $name.css('display', 'none');

      $editName.css('display', 'inline-block');
      $editName.focus();

      $editName.off('mousedown selectstart');
      $editName.on('mousedown selectstart', function(e) {
        e.stopPropagation();
      });
    });
    jQuery(document).on('mousedown', self.hideEditName);


    // add feeds
    if (self.object.feedAddable) {
      var $addButton = $widget.find('.addFeedButton');

      $addButton.on('click', function() {
        $addButton.parent().parent().removeClass('addButtonOpc');


        var add = ''
            + '<div class="addFeed contentArea">'
            + '  <div class="content">'
            + '    <div class="block">'
            + '      <div class="scrollable">'
            + '        <div class="row">'
            + '          <div class="left contentBlockLabel">'
            + '            <span title="Loading..." class="chkboxHolder">Loading...</span>'
            + '          </div>'
            + '          <div class="right contentBlockValue">'
            + '          </div>'
            + '          <div class="clear"></div>'
            + '        </div>'
            + '      </div>'
            + '      <div class="right" style="margin:4px 0 0;">'
            + '        <div class="submitBtn"><input type="button" value="Add" class="AddFeedDone inputBtnStyle"/></div>'
            + '      </div>'
            + '      <div class="clear"></div>'
            + '    </div>'
            + '  </div>'
            + '</div>';


        var $add = jQuery(add);
        $widget.find('.addButtonHolder').append($add);


        // content
        // specific
        if (self.object.widgetType == 'BUSINESS') {
          // no-op;
        } else if (self.object.widgetType == 'SAVED_QUERY') {
          self.object.prepareFeeds();
        } else if (self.object.widgetType == 'TASK_LIST') {
          // no-op;
        } else if (self.object.widgetType == 'MENU_SHORTCUT') {
          // no-op;
        }


        var _function = function() {
          var feeds = '';
          var rowCount = 0;
          var content = self.object.content;
          jQuery.each(self.object.feeds, function(pk, feed) {
              if (content && jQuery.isFunction(content.feedByPk) && !content.feedByPk(feed.pk)) {
					// trim to remove trailing spaces and convert null/undefined values to empty string
            	  var escapedFeedName = $.trim(self.object.escapeHtml(feed.name));
    				if (self.object.widgetType == 'BUSINESS'){
  						rowCount ++;
  						if(feed.pk == -1 && rowCount != 1){
  							feeds += ''
  							  + '</div>';
  						}
						// trim to remove trailing spaces and convert null/undefined values to empty string
  						var escapedCategoryTitle = $.trim(self.object.escapeHtml(feed.categoryName));
  						var escapedCategoryName = '- '+escapedCategoryTitle+' -';
  						// When the categoryName comes populated , then the markup for creating category is generated, otherwise individual feed markup is generated 
    						if(escapedCategoryTitle != ''){
    							feeds += ''
    							  + '<div class="row categoryDiv" pk="'+feed.categoryPk+'">'
  							      + '  <div class="left contentBlockValue">'
    							  + '    <span><input id="addFeedC' + feed.categoryPk + '" class="categoryChkBx" type="checkbox" value="' + feed.categoryPk + '" displayseq= "' + pk + '"/></span>'
    							  + '  </div>'
    							  + '  <div class="left contentBlockLabel">'
    							  + '    <label for="addFeedC' + feed.categoryPk + '"> <span title="' + escapedCategoryTitle + '"><b>' + escapedCategoryName + '</b></span> </label>'
    							  + '  </div>'
    							  + '  <div class="clear"></div>'
    						}else{
    							feeds += ''
    							  + '<div class="row subCategoryDiv" parentPk="'+feed.categoryPk+'">'
    							  + '  <div class="left contentBlockValue">'
    							  + '    <span>&nbsp;&nbsp;<input id="addFeed' + feed.pk + '" class="AddFeedId subCategoryChkBx" type="checkbox" value="' + feed.pk + '" displayseq= "' + pk + '"/></span>'
    							  + '  </div>'
    							  + '  <div class="left contentBlockLabel">'
    							  + '    <label for="addFeed' + feed.pk + '"><span title="' + escapedFeedName + '">' + escapedFeedName + '</span> </label>'
    							  + '  </div>'
    							  + '  <div class="clear"></div>'
    							  + '</div>';
    						}
    				}else{
    						feeds += ''
    						  + '<div class="row">'
    						  + '  <div class="left contentBlockValue">'
    						  + '    <span><input id="addFeed' + feed.pk + '" class="AddFeedId" type="checkbox" value="' + feed.pk + '" displayseq= "' + pk + '"/></span>'
    						  + '  </div>'
    						  + '  <div class="left contentBlockLabel">'
    						  + '    <label for="addFeed' + feed.pk + '"><span title="' + escapedFeedName + '">' + escapedFeedName + '</span>'
    						  + '  </div>'
    						  + '  <div class="clear"></div>'
    						  + '</div>';
    				
    				}
  			}
         });


          var $scrollable = $add.find('.scrollable');
          $scrollable.html(feeds);
          $scrollable.jScrollPane({showArrows: true});
          
          //1. hide checkbox of category when no sub category present
  		  jQuery('.categoryDiv').each(function() {
  		     var $eachCatChkBx = jQuery(this).find('input.categoryChkBx');
  			 var $eachSubCatChkBx = jQuery(this).find('input.subCategoryChkBx');
  			 if($eachSubCatChkBx.length == 0){
  				$eachCatChkBx.hide();
  			 }else{
  				$eachCatChkBx.show();
  			 }
  		  });
  		  
  		  //1. checked all sub category under the category which is clicked
  		  $add.find(".categoryDiv").bind('click',function(event) {
  		    if($(event.target).hasClass('categoryChkBx')){
  				var $CatChkBx = $(this).find("input");
  				$CatChkBx.prop("checked", $CatChkBx.prop("checked"));
  		
  			}
  		  });
  		
  		  //1. uncheck category, when any of its sub category unchecked
  		  //2. check category, when all sub category checked
  		 $add.find(".subCategoryChkBx").bind('click',function(event) {
  		     var clickedDiv = $(this);
  			 var $parentCategory = clickedDiv.closest(".categoryDiv");
  			 
  			 //1
  			 $(".clickedDiv").prop("checked", clickedDiv.prop("checked"));
  			 $parentCategory.children("div:first-child").find("input").prop("checked",false);
  			 //stop to call click handler of parent i.e click handler of category
  			 event.stopPropagation();
  			 
  			 //2
  			 var isAllSubCategoryChecked = true;
  			 $parentCategory.find('input.subCategoryChkBx').each(function() {
  				  var $eachSubInput = jQuery(this);
  				  if (!$eachSubInput.prop('checked')){
  						isAllSubCategoryChecked = false;
  						return;
  				  }
  			 });
  			if(isAllSubCategoryChecked){
  				$parentCategory.find('input.categoryChkBx').prop("checked",true);
  			}
	  	  });
  		
          $add.find('.AddFeedDone').click(function() {
            var addFeedsPk = [];
            jQuery('.AddFeedId').each(function() {
              var $this = jQuery(this);
              if ($this.attr('checked') == 'checked')
            	  addFeedsPk.push({pk: $this.val(), displayRowNum:$this.attr('displayseq')});
            });

            if (content && jQuery.isFunction(content.addFeeds)) {
              var _function1 = function() {
                content.render('update');
              };
              content.addFeeds(addFeedsPk, _function1, self);
            }

            // remove
            $add.remove();

            //hide button background
            $('.addFeedButton').parent().parent().addClass('addButtonOpc');
          });
        };

        xenos.waitFor({
          target: self.object,
          state: 'feedsFound',
          callback: _function,
          delegator: self
        });
      });
      jQuery(document).on('mousedown', self.hideAddFeed);
    }


    // refresh feeds
    if (self.object.feedRefreshable) {
      var $refreshButton = jQuery('#Widget' + self.object.selector).find('.refreshFeedButton');
      var $refreshFeedOpaque = jQuery('#Widget' + self.object.selector).find('.refreshButtonOpc');
      $refreshFeedOpaque.hover(
          function() {
            if (!$refreshButton.attr('disabled')) {
              $refreshButton.attr('title', 'Refresh feeds');
              $refreshButton.css('cursor', 'pointer');
              $refreshFeedOpaque.addClass('refreshButtonOpcHover');
            } else {
              $refreshButton.css('cursor', 'text');
            }
          },
          function() {
            $refreshButton.removeAttr('title');
            $refreshFeedOpaque.removeClass('refreshButtonOpcHover');
          }
      );
    }


    // configurable
    if (self.object.configurable) {
      var $configureButton = $widget.find('.widgetConfigureButton');

      $configureButton.on('click', function() {
        $configureButton.parent().parent().removeClass('configureButtonOpc');

        var configure = ''
            + '<div class="configureWidget contentArea">'
            + '  <div class="content">'
            + '    <div class="block">'
            + '      <div class="row">'
            + '        <div class="left contentBlockLabel">'
            + '          <span>Background color</span>'
            + '        </div>'
            + '        <div class="right contentBlockValue">'
            + '          <input id="backColor" value="' + self.object.backColor + '"/>'
            + '        </div>'
            + '        <div class="clear"></div>'
            + '      </div>'
            + '      <div class="row">'
            + '        <div class="left contentBlockLabel">'
            + '          <span>Foreground color</span>'
            + '        </div>'
            + '        <div class="right contentBlockValue">'
            + '          <input id="foreColor" value="' + self.object.foreColor + '"/>'
            + '        </div>'
            + '        <div class="clear"></div>'
            + '      </div>'
            + '      <div class="row">'
            + '        <div class="left contentBlockLabel">'
            + '          <span>Link color</span>'
            + '        </div>'
            + '        <div class="right contentBlockValue">'
            + '          <input id="linkColor" value="' + self.object.linkColor + '"/>'
            + '        </div>'
            + '        <div class="clear"></div>'
            + '      </div>';

        if (self.object.hasGraph) {
          configure += ''
              + '      <div class="row">'
              + '        <div class="left contentBlockLabel">'
              + '          <span title="Show graph">Show graph</span>'
              + '        </div>'
              + '        <div class="right contentBlockValue">'
              + '          <input id="showGraph" type="checkbox"' + (self.object.showGraph ? ' checked' : '') + ' class="chkboxHolder"/>'
              + '        </div>'
              + '        <div class="clear"></div>'
              + '      </div>';
        }

        configure += ''
            + '      <div class="clear"></div>'
            + '    </div>'
            + '  </div>'
            + '</div>';


        var $configure = jQuery(configure);
        var $backColor = $configure.find('#backColor');
        $backColor.on('change', function() {
          if (self.object.configureBackColor($backColor.val())) {
            $widget.css('background-color', $backColor.val());
            self.fixUpdate();
          }
        });
        var $foreColor = $configure.find('#foreColor');
        $foreColor.on('change', function() {
          if (self.object.configureForeColor($foreColor.val())) {
            $widget.find('.btnHolderCol').css('color', $foreColor.val());
            $widget.find('.widgetName').css('color', $foreColor.val());
            self.object.content.render('update');
            self.fixUpdate();
          }
        });
        var $linkColor = $configure.find('#linkColor');
        $linkColor.on('change', function() {
          if (self.object.configureLinkColor($linkColor.val())) {
            self.object.content.render('update');
            self.fixUpdate();
          }
        });
        var $showGraph = $configure.find('#showGraph');
        $showGraph.on('change', function() {
          if (self.object.configureShowGraph($showGraph.attr('checked'))) {
            self.object.content.render('update');
            self.fixUpdate();
          }
        });

        $backColor.colorPicker();
        $foreColor.colorPicker();
        $linkColor.colorPicker();

        var content = self.object.content;
        if (content
            && content.renderer
            && jQuery.isFunction(content.renderer.renderConfiguration))
          $configure.find('.block').children().last().before(content.renderer.renderConfiguration());

        $widget.find('.configureButtonHolder').append($configure);
      });
      jQuery(document).on('mousedown', self.hideConfigureWidget);
    }


    // closeable
    if (self.object.closeable) {
      $widget.find('.widgetCloseButton').on('click', function() {
        // get the confirmation
        jConfirm(xenos$DBD$i18n.workspace.confirm_widget_close, null, function(confirmation) {
          if (confirmation) {
            var $content = jQuery('#content');

            var _function = function(widget) {
              var content = widget.content;

              $content.saverOff(widget.widgetUpdater);
              if (content && jQuery.isFunction(content.contentUpdater)) $content.saverOff(content.contentUpdater);

              $widget.remove();

              self.object.parent.parent.renderer.fixAddWidget(widget.parent.order);
              self.object.parent.parent.renderer.fixRemove(widget.parent.order);
              self.object.parent.parent.renderer.fixUpdate(widget.parent.order);
            };
            self.object.parent.closeWidget(self.object.order, _function, self);
          }
        });
      });
    }
  };


  this.dispose = function() {
    jQuery(document).off('mousedown', self.hideEditName);
    jQuery(document).off('mousedown', self.hideAddFeed);
    jQuery(document).off('mousedown', self.hideConfigureWidget);
  };
}


// Content
function xenos$DBD$Content$renderer(object) {
  // inherit
  this.inherit = xenos$DBD$renderer;
  this.inherit(object);
  // self
  var self = this;


  // render
  this.render = function(unprepared) {
  };
}
//
// xenos
//  - Dashboard plugin infrastructure
//


// no-op hooks
function NoOpPrepareHook() {
  console.log(this.type + ' is prepared');
}
function NoOpRenderHook() {
  console.log(this.type + ' is rendered');
}
function NoOpConnectHook() {
  console.log(this.type + ' is connected');
}
function NoOpDisconnectHook() {
  console.log(this.type + ' is disconnect');
}
function NoOpDisposeHook() {
  console.log(this.type + ' is disposed');
}


// dashboard hooks
function HideDockMenu() {
  jQuery('.rightDockMenu').hide();
}
function ShowDockMenu() {
  jQuery('.rightDockMenu').show();
}


if (typeof xenos$Dashboard$plugin === 'undefined') {

  // define xenos Dashboard hook
  window.xenos$Dashboard$hook = {
    xenos$DBD$Dashboard: {
      prepare: {
        'no-op': NoOpPrepareHook
      },
      render: {
        'no-op': NoOpRenderHook,
        'hide-dock-menu': HideDockMenu
      },
      connect: {
        'no-op': NoOpConnectHook
      },
      disconnect: {
        'no-op': NoOpDisconnectHook
      },
      dispose: {
        'no-op': NoOpDisposeHook,
        'show-dock-menu': ShowDockMenu
      }
    },
    xenos$DBD$Workspace: {
      prepare: {
      },
      render: {
      },
      connect: {
      },
      disconnect: {
      },
      dispose: {
      }
    },
    xenos$DBD$Widget: {
      prepare: {
      },
      render: {
      },
      connect: {
      },
      disconnect: {
      },
      dispose: {
      }
    },
    xenos$DBD$Content: {
      prepare: {
      },
      render: {
      },
      connect: {
      },
      disconnect: {
      },
      dispose: {
      }
    }
  };


  // define xenos Dashboard plugin
  window.xenos$Dashboard$plugin = function() {
    // dashboard object
    var object = new xenos$DBD$Dashboard();

    // dashboard plugin
    var plugin = {
      name: 'xenos$Dashboard',
      event: {
        prefix: 'xenos$Dashboard'
      },

      reInitialize: function() {
		object = new xenos$DBD$Dashboard();
	  },

      create: function() {
        // align controllers
        var controllers = new xenos$DBD$Element$Controllers();
        controllers.align();

        // resize workspaces
        var workspaces = new xenos$DBD$Element$Workspaces();
        workspaces.resize();

        // show loading
        var loading = new xenos$DBD$Element$Loading();
        loading.align();
        loading.show();
      },

      init: function() {
        if (object.rendered) {
          xenos.waitFor(object, 'rendered', false, function() {object.connect();}, object);
        } else {
          setTimeout(function() {object.connect();}, 0);
        }
      },
      destroy: function() {
        setTimeout(function() {object.dispose();}, 0);
      }
    };


    // return
    return plugin;
  }();
}
