//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
//
// xenos
//  - Dashboard: Business feed infrastructure
//

function xenos$DBD$TaskFeed(parent) {
    this.type = 'xenos$DBD$TaskFeed';
    // inherit
    this.inherit = xenos$DBD$Content;
    this.inherit(parent);
    // self
    var self = this;
	var renderFirstTime = true;	
	
	/*default markup*/
	this.myTaskMarkup = "<div class=\"row\">"
						+ "<div class=\"left contentBlockLabel {{if taskStatusName == 'CLOSE'}}strike{{/if}}\" >"
						+ "  <span class=\"taskName\" title=${taskName}>${taskName}</span>"
						+ "  <span class=\"taskAssignee\">${reporter}</span>"		   
						+ "  <span class=\"taskDate\">${dueDateStr}</span>"
						+ "</div>"				   
						+ "{{if taskStatusName == 'CLOSE'}}"
						+"   <div class=\"right task-reopen-ico-holder\"><span title=\"ReOpen\" class=\"right task-reopen-ico\" taskPk=${taskDetailPk}>R</span></div>"
						+ "{{else}}"
						+"   <div class=\"right task-resolved-ico-holder\"><span title=\"Resolved\" class=\"right task-resolved-ico\" taskPk=${taskDetailPk}>Q</span></div>"
						+ "{{/if}}"
						+ "<div class=\"clear rowfooter\"></div>"
						+ "</div>";
	
	this.assignedTaskMarkup = "<div class=\"row\">"
					   + "<div class=\"left contentBlockLabel {{if taskStatusName == 'CLOSE'}}strike{{/if}}\" >"
					   + "<span class=\"taskName\">${taskName}</span>"				   
					   + "<span class=\"taskAssignee\">${assignee}</span>"				   
					   + "<span class=\"taskDate\">${dueDateStr}</span>"
					   + "</div><div class=\"clear rowfooter\"></div>"
					   + "</div>";
	
	/*group markup for my task*/
	this.dueDateMyTaskMarkup =  "<div class=\"row grpHead group\" dueDate=${dueDateStr}> "
		+ "<div class=\"left contentBlockLabel\">"
        + "  <span class=\"expand grpSymbol ${expanderSymbol($item)}\"></span> "
        + "  <span class=\"grpTitle\">${dueDateStr}</span> "
        + "  <span class=\"grpCount\">[${getItemsLength($item)}]</span> "
		+ "</div>"
		+ "<div class=\"clear rowfooter\"></div>"
		+ "</div>"
		+ "{{if expanded}} "
			+ "{{each getItems($item)}}	 "
				+"<div class=\"row grpRow\">"
						+ "<div class=\"left contentBlockLabel {{if taskStatusName == 'CLOSE'}}strike{{/if}}\" >"
						+ "  <span class=\"taskName\" title=${taskName}>${taskName}</span>"
						+ "  <span class=\"taskAssignee\">${reporter}</span>"	
						+ "</div>"				   
						+ "{{if taskStatusName == 'CLOSE'}}"
						+"   <div class=\"right task-reopen-ico-holder\"><span title=\"ReOpen\" class=\"right task-reopen-ico\" taskPk=${taskDetailPk}>R</span></div>"
						+ "{{else}}"
						+"   <div class=\"right task-resolved-ico-holder\"><span title=\"Resolved\" class=\"right task-resolved-ico\" taskPk=${taskDetailPk}>Q</span></div>"
						+ "{{/if}}"
						+ "<div class=\"clear rowfooter\"></div>"
						+ "</div>"
			+ "{{/each}}  "
		+ "{{/if}} ";
		
	this.repoterMyTaskMarkup =  "<div class=\"row grpHead groupReporter\" reporter=${reporter}> "
		+ "<div class=\"left contentBlockLabel\">"
        + "  <span class=\"expand grpSymbol ${expanderSymbol($item)}\"></span> "
        + "  <span class=\"grpTitle\">${reporter}</span> "
        + "  <span class=\"grpCount\">[${getItemsLength($item)}]</span> "
		+ "</div>"
		+ "<div class=\"clear rowfooter\"></div>"
		+ "</div>"
		+ "{{if expanded}} "
			+ "{{each getItems($item)}}	 "
				+"<div class=\"row grpRow\">"
						+ "<div class=\"left contentBlockLabel {{if taskStatusName == 'CLOSE'}}strike{{/if}}\" >"
						+ "  <span class=\"taskName\" title=${taskName}>${taskName}</span>"
						+ "  <span class=\"taskDate\">${dueDateStr}</span>"
						+ "</div>"				   
						+ "{{if taskStatusName == 'CLOSE'}}"
						+"   <div class=\"right task-reopen-ico-holder\"><span title=\"ReOpen\" class=\"right task-reopen-ico\" taskPk=${taskDetailPk}>R</span></div>"
						+ "{{else}}"
						+"   <div class=\"right task-resolved-ico-holder\"><span title=\"Resolved\" class=\"right task-resolved-ico\" taskPk=${taskDetailPk}>Q</span></div>"
						+ "{{/if}}"
						+ "<div class=\"clear rowfooter\"></div>"
						+ "</div>"
			+ "{{/each}}  "
		+ "{{/if}} ";
		
	/*group markup for assigned task*/	
	this.dueDateAssignedTaskMarkup =  "<div class=\"row grpHead groupAssignedDueDate\" dueDate=${dueDateStr}> "
		+ "<div class=\"left contentBlockLabel\">"
        + "  <span class=\"expand grpSymbol ${expanderSymbol($item)}\"></span> "
        + "  <span class=\"grpTitle\">${dueDateStr}</span> "
        + "  <span class=\"grpCount\">[${getItemsLength($item)}]</span> "
		+ "</div>"
		+ "<div class=\"clear rowfooter\"></div>"
		+ "</div>"
		+ "{{if expanded}} "
			+ "{{each getItems($item)}}	 "
				+"<div class=\"row grpRow\">"
					+ "<div class=\"left contentBlockLabel {{if taskStatusName == 'CLOSE'}}strike{{/if}}\" >"
					+ "<span class=\"taskName\">${taskName}</span>"				   
					+ "<span class=\"taskAssignee\">${assignee}</span>"	
					+ "</div><div class=\"clear rowfooter\"></div>"
				+ "</div>"
			+ "{{/each}}  "
		+ "{{/if}} ";
		
	this.assignedGrpTaskMarkup =  "<div class=\"row grpHead groupAssigned\" assignee=${assignee}> "
		+ "<div class=\"left contentBlockLabel\">"
        + "  <span class=\"expand grpSymbol ${expanderSymbol($item)}\"></span> "
        + "  <span class=\"grpTitle\">${assignee}</span> "
        + "  <span class=\"grpCount\">[${getItemsLength($item)}]</span> "
		+ "</div>"
		+ "<div class=\"clear rowfooter\"></div>"
		+ "</div>"
		+ "{{if expanded}} "
			+ "{{each getItems($item)}}	 "
				+"<div class=\"row grpRow\">"
					   + "<div class=\"left contentBlockLabel {{if taskStatusName == 'CLOSE'}}strike{{/if}}\" >"
					   + "<span class=\"taskName\">${taskName}</span>"					   
					   + "<span class=\"taskDate\">${dueDateStr}</span>"
					   + "</div><div class=\"clear rowfooter\"></div>"
					   + "</div>"
			+ "{{/each}}  "
		+ "{{/if}} ";
	/**
		Add some simple templete methods to display items
	*/
	$.extend( window, { 
    getItems: function( tmplItem ) {
        //console.log(tmplItem.data);
		return tmplItem.data.value;
    },  
    getItemsLength : function( tmplItem ) {
		var length = 0;
		if(tmplItem.data.value)
			length = tmplItem.data.value.length
        //console.log(length);
		return length;
    }, 
    expanderSymbol: function( tmplItem ) {
        return tmplItem.data.expanded ? "collapse" : "expand";
    }
	});
    // feeds
    this.feeds = {};
    this.feedsPk = {};
	this.itemExpand = [];
    this.feedsOrder = [];
	this.$filterPending = false;
	this.$filterRoutine = false;
	this.$filterTask = '';
	this.taskconfig = {};
	this.modifiedtaskconfig = {};
	
	this.taskFeedPks=[];
	this.selectedPk = {};
	this.$fn = function(feed){};
	this.$filterfn = function(feed){};
	this.$jsonresult = [];

    // has feeds
    this.hasFeeds = function() {
        return this.feedsOrder.length != 0;
    };

	this.polling = function(feed) {
		if(renderFirstTime) {
			renderFirstTime = false;
		} else {
			//this.renderer.hideAddBtn($widget);
			this.renderer.render('update');
		}
	};

    // preparation
    this.prepareActivity = function() {
		var index = 0;
		//alert('task prepareActivity called');
			//console.log('this.json.value %o',this.json.value[0]);
		jQuery.each(this.json.value, function(order, rawFeed) {
			
            var feed = {
                pk: rawFeed.pk,
                name: rawFeed.name,
                id: rawFeed.id,
                order: order,
                data: 0,
                dataUri: rawFeed.dataUrl,
                dataInterval: rawFeed.asyncInterval,
                pollingId: 0,
				dateOffset:rawFeed.dateOffset,
				userList:rawFeed.userList,
                viewUri: rawFeed.feedUrl
            }
			
            self.taskFeedPks[index] = feed.pk;
			self.taskconfig['dateOffset'] = feed.dateOffset;
			self.taskconfig['userList'] = feed.userList;
			self.taskconfig['dbdWorkspaceWidgetPk'] = rawFeed.dbdWorkspaceWidgetPk;
			/*if(index == 0){
				self.selectedPk =feed.id;
			}*/
			self.feeds[feed.id] = feed;			
            self.feedsPk[order] = feed.pk;
            self.feedsOrder.push(order);
			index++;
        });
		self.taskconfig['pks'] = self.taskFeedPks;
		
    };
	
	
	
	this.contentUpdater = function(update){
		if (update) {
            self.updateContent();
        } else {
            self.discardConyentUpdate();
        }
	};
	
	

    // update widget
    this.updateContent = function(callback, delegator) {
	//console.log('.taskDateOffset %o :: ',$('.taskDateOffset'));
	//console.log($('.taskDateOffset').val());
        var uri = xenos.context.path + '/secure/ref/taskfeed/saveconfig.json';


        var json = ''
                + '{'
                +   '"dbdWorkspaceWidgetPk": ' + self.taskconfig.dbdWorkspaceWidgetPk + ','
                +       '"pks": [' + self.taskconfig.pks + '],'
                +       '"dateOffset": ' + self.modifiedtaskconfig.dateOffset + ','
                +       '"userList": "' +  self.modifiedtaskconfig.userList + '"'
                + '}';


        jQuery.ajax({
            url: uri,
            type: 'POST',
            contentType: 'application/json',
            data: json,
            success: function(json) {
                if (!json.success) {
                    //console.log(json);
                    xenos.postNotice(xenos.notice.type.error, xenos$DBD$i18n.widget.widget_not_saved + self.parent.name);
                    return;
                }
			  self.taskconfig.dateOffset =self.modifiedtaskconfig.dateOffset;
			  self.taskconfig.userList = self.modifiedtaskconfig.userList ;

                self.dirty = false;

                xenos.postNotice(xenos.notice.type.info, self.parent.name + xenos$DBD$i18n.widget.widget_saved);
                if (callback) callback.call(delegator ? delegator : self, self);
            }
        });
    };

    // discard update
    this.discardConyentUpdate = function() {
		 self.modifiedtaskconfig.dateOffset = self.taskconfig.dateOffset;
		 self.modifiedtaskconfig.userList = self.taskconfig.userList;

        self.dirty = false;
    };

    // rendition
    this.renderer = new xenos$DBD$TaskFeed$renderer(this);

    // connection
    this.connectActivity = function() {
        jQuery.each(self.feeds, function(pk, feed) {
            if (feed.dataInterval) {
                self.polling(feed);
                if (!feed.pollingId) {
                    feed.pollingId = setInterval(function() {self.polling(feed);}, feed.dataInterval);
				}
            }
        });
    };

    this.disconnectActivity = function() {
		renderFirstTime = true;
        jQuery.each(self.feeds, function(pk, feed) {
            if (feed.pollingId) {
                clearInterval(feed.pollingId);
                feed.pollingId = 0;
			}
        });
    };
}

// Renderer
function xenos$DBD$TaskFeed$renderer(object) {
    // inherit
    this.inherit = xenos$DBD$Content$renderer;
    this.inherit(object);
    // self
    var self = this;
	
	this.markup = "";
	
	var clearOldElements = function ($widget){
	 var jscrollpane_api = $widget.find('.contentHolder').data('jsp');
	 if (jscrollpane_api) jscrollpane_api.destroy();
	 $widget.find('div.row > div.task-resolved-ico-holder > span.task-resolved-ico').unbind('click');
	 $widget.find('div.row > div.task-reopen-ico-holder > span.task-reopen-ico').unbind('click');
	 $widget.find('div.row').remove();
	 $widget.find('div.group').remove();
	 $widget.find('div.groupReporter').remove();
	 $widget.find('div.groupAssignedDueDate').remove();
	 $widget.find('div.groupAssigned').remove();
	 //self.object.itemExpand = [];
	 $widget.find('div.rowfooter').remove();
	}
	/*
	this.hideAddBtn = function($widget) {
		$widget.find('#addTaskBtn').css('display','none');
	}
	*/
	var refreshTasks = function(){
		$(document).unbind('mouseup', overlayclickclose);
		$('.ui-dialog').remove();
		$('#taskDialog').remove();
		$widget.find('.addFeedButton').removeAttr('disabled');
		//self.hideAddBtn($widget);
		self.render('update');
	}

	var closedialog;

	var overlayclickclose =  function() {
		if (closedialog) {
			$('#taskDialog').dialog('close');
		}
		closedialog = 1;
	}

	var loadTaskScreen = function($btn){
		var url = xenos.context.path + "/secure/ref/taskfeed/initaddtask";
		var dialog_width = 462;
		var dialog_height = 330;
		
		var posLeft = $btn.closest('.task').offset().left+1;
		var posTop = $btn.closest('.task').offset().top+1;
		
		$.ajax({
				type: "GET",
				url: url,
				beforeSend: function(req) {
					req.setRequestHeader("Accept", "text/html;type=ajax");
				},  
				complete : function(jqXHRT) {
					xenos.loadScript([{path: xenos.context.path + '/scripts/inf/fieldvalidator.js'},
									{path: xenos.context.path + '/scripts/inf/datevalidation.js'},
									{path: xenos.context.path + '/scripts/ref/addTask.js'}], {
									success: function() {
										var $dialog = $('<div id="taskDialog"></div>');
										$dialog.html(jqXHRT.responseText).dialog({
													resizable: false,
													title: 'Add Task',
													width: dialog_width,
													height: dialog_height,
													position: [posLeft,posTop],
													closeOnEscape: false,
													close: refreshTasks,
													draggable: false,
														open: function(){
															var $self = $(this);
															var $dialogContext = $self.parent();
															closedialog = 1;
															var $currentWidget = jQuery('#Widget' + self.object.parent.selector);
															$('#taskDialog',$dialogContext).data('closeFn',overlayclickclose);
															$(document).bind('mouseup', overlayclickclose);
															$('#taskDialog',$dialogContext).unbind('mouseup').bind('mouseup', function(event){event.stopPropagation();});
															$('#taskDialog',$dialogContext).css('border-color',$currentWidget.css('background-color'));
															$('.ui-dialog-titlebar',$dialogContext).css('background',$currentWidget.css('background-color'));
															$('.ui-dialog-titlebar',$dialogContext).css('border-color',$currentWidget.css('background-color'));
															$('.ui-dialog',$dialogContext).css('background',$currentWidget.css('background-color'));
															$('.ui-dialog',$dialogContext).css('border-color',$currentWidget.css('background-color'));
															$self.addTask({});
														},
														focus: function(){
															 closedialog = 0;
														},
														hide: 'fade',
														show: 'fade'
													}).dialog('open');
									}
								});
							}
						});
	}
	
	/**
	* show my Task
	*/
	this.showMyTask = function(feedUri){
	$widget.find('.assigneeGrpBtn').hide();
	$widget.find('.myGrpBtn').show();
	var menuItemObj = $widget.find('.taskmenuitem');
	menuItemObj.removeClass('active');	
	$widget.find('#mtitem').addClass('active');
	var dataMap = {dateOffset : self.object.taskconfig.dateOffset,userList : self.object.taskconfig.userList};
			jQuery.post(feedUri, dataMap,function(json) {
				  if (!json.success) {
					return;
				  }
				self.object.$jsonresult = json.value;
				self.markup = self.object.myTaskMarkup;
				self.object.$filterfn();
				
			});
	}
	
	
	/**
	* today's task filter
	*/
	this.todayDateFilter = function(){
		var filterItemObj = $widget.find('.taskfilteritem');
		filterItemObj.removeClass('active');	
		$widget.find('#today').addClass('active');
		  clearOldElements($widget);
		  var feedMarkup = '';
		  if(self.object.$jsonresult.length == 0) { 
			feedMarkup = '<div class="dummyrow"></div>';
			$widget.find('.contentHolder').children().last().before($(feedMarkup));
		  } else {
			$widget.find('.dummyrow').remove();
		  }
		var today = $('div#footer>div#xenos-cache-container>span#cache').data('refApplicationDate');
		var feeds = $.grep(self.object.$jsonresult,function(task,index){ return task.dueDate == today.getTime(); });
		
		if(self.object.$filterRoutine==true)
			feeds = $.grep(feeds,function(task,index){return task.isRoutine == 'Y'; });
		if(self.object.$filterPending==true)
			feeds = $.grep(feeds,function(task,index){return task.taskStatusName == 'OPEN'; });
		
		if(self.object.$filterTask){
			var regEx = new RegExp("^"+self.object.$filterTask,'i');
			feeds = $.grep(feeds,function(task,index){
			return regEx.test(task.taskName); });
		}
		
		//Apply  Template
		feeds = self.applyTemplate(feeds);
		$.tmpl("$feedMarkup",feeds).appendTo( $widget.find('.contentHolder') );
		$widget.find('.contentHolder').jScrollPane({showArrows: true});
		
		self.addTaskActionHandler();
		
		/* expand previously expanded items */
		self.expandPrvItems();
	}
	
	/**
	* future task filter
	*/
	this.futureDateFilter = function(){
		var filterItemObj = $widget.find('.taskfilteritem');
		filterItemObj.removeClass('active');	
		$widget.find('#future').addClass('active');
		  clearOldElements($widget);
		  var feedMarkup = '';
		  if(self.object.$jsonresult.length == 0) { 
			feedMarkup = '<div class="dummyrow"></div>';
			$widget.find('.contentHolder').children().last().before($(feedMarkup));
		  } else {
			$widget.find('.dummyrow').remove();
		  }
		var today = $('div#footer>div#xenos-cache-container>span#cache').data('refApplicationDate');
		//today = new Date(today.getFullYear(),today.getMonth(),today.getDate());
		var feeds = $.grep(self.object.$jsonresult,function(task,index){return (task.dueDate > today.getTime() ); }) //&& task.dueDate < = futureDay
		
		if(self.object.$filterRoutine==true)
			feeds = $.grep(feeds,function(task,index){return task.isRoutine == 'Y'; });
		if(self.object.$filterPending==true)
			feeds = $.grep(feeds,function(task,index){return task.taskStatusName == 'OPEN'; });
			
		if(self.object.$filterTask){
			var regEx = new RegExp("^"+self.object.$filterTask,'i');
			feeds = $.grep(feeds,function(task,index){
			//console.log(regEx.test(task.taskName));
			return regEx.test(task.taskName); });
		}
		
		//console.log('before group :: %o ',feeds);
		feeds = self.applyTemplate(feeds);
		//console.log('after group :: %o ',feeds);
		$.tmpl("$feedMarkup",feeds).appendTo( $widget.find('.contentHolder') );
		$widget.find('.contentHolder').jScrollPane({showArrows: true});
		
		self.addTaskActionHandler();
		
		/* expand previously expanded items */
		self.expandPrvItems();        
	}
	
	
	/**
	* future task filter
	*/
	this.historyDateFilter = function(){
		var filterItemObj = $widget.find('.taskfilteritem');
		filterItemObj.removeClass('active');	
		$widget.find('#history').addClass('active');
		  clearOldElements($widget);
		  var feedMarkup = '';
		  if(self.object.$jsonresult.length == 0) { 
			feedMarkup = '<div class="dummyrow"></div>';
			$widget.find('.contentHolder').children().last().before($(feedMarkup));
		  } else {
			$widget.find('.dummyrow').remove();
		  }
		var today = $('div#footer>div#xenos-cache-container>span#cache').data('refApplicationDate');
		//today = new Date(today.getFullYear(),today.getMonth(),today.getDate());
		var feeds = $.grep(self.object.$jsonresult,function(task,index){return (task.dueDate < today.getTime()); }) //&& task.dueDate < = futureDay
		
		if(self.object.$filterRoutine==true)
			feeds = $.grep(feeds,function(task,index){return task.isRoutine == 'Y'; });
		if(self.object.$filterPending==true)
			feeds = $.grep(feeds,function(task,index){return task.taskStatusName == 'OPEN'; });
			
		if(self.object.$filterTask){
			var regEx = new RegExp("^"+self.object.$filterTask,'i');
			feeds = $.grep(feeds,function(task,index){
			//console.log(regEx.test(task.taskName));
			return regEx.test(task.taskName); });
		}
		
		//console.log('before group :: %o ',feeds);
		feeds = self.applyTemplate(feeds);
		//console.log('after group :: %o ',feeds);
		$.tmpl("$feedMarkup",feeds).appendTo( $widget.find('.contentHolder') );
		$widget.find('.contentHolder').jScrollPane({showArrows: true});
		
		self.addTaskActionHandler();
		
		/* expand previously expanded items */
		self.expandPrvItems();        
	}
	
	/**
	* Apply  Template for Task
	*/
	this.applyTemplate = function(feeds){	
		//groupAssignedDueDate	
		if(self.object.$grpOn && self.object.$grpOn == 'dueDateGrp'){
			var feedArray = []
			objx(feeds.sort(function(a,b){ return (a.dueDate > b.dueDate) ? 1: -1;})).group('dueDateStr')
				.each(function(item,key){
					if(!(self.object.itemExpand.length > 0 &&
						$.grep(self.object.itemExpand,function(item,index){return item.dueDateStr == key;}).length > 0) ) {
							self.object.itemExpand.push({"dueDateStr":key,"expanded":false});
						}
						feedArray.push({"dueDateStr":key,"value":item});
				});			
			$.template( "$feedMarkup", self.grpMarkup);
			feeds = feedArray;
		}else if(self.object.$grpOn && self.object.$grpOn == 'myReporterGrp'){
			var feedArray = []
			objx(feeds.sort(function(a,b){ return (a.assignedBy > b.assignedBy) ? 1: -1;})).group('reporter')
				.each(function(item,key){
					if(!(self.object.itemExpand.length > 0 &&
						$.grep(self.object.itemExpand,function(item,index){return item.reporter == key;}).length > 0) ){
							self.object.itemExpand.push({"reporter":key,"expanded":false});
						}
						feedArray.push({"reporter":key,"value":item});
				});			
			$.template( "$feedMarkup", self.grpMarkup);
			feeds = feedArray;
		}else if(self.object.$grpOn && self.object.$grpOn == 'assigneeDueDateGrp'){
			var feedArray = [];			
			objx(feeds.sort(function(a,b){ return (a.dueDate > b.dueDate) ? 1: -1;})).group('dueDateStr')
				.each(function(item,key){
					if(!(self.object.itemExpand.length > 0 &&
						$.grep(self.object.itemExpand,function(item,index){return item.dueDateStr == key;}).length > 0) ) {
							self.object.itemExpand.push({"dueDateStr":key,"expanded":false});
						}
						feedArray.push({"dueDateStr":key,"value":item});
				});			
			$.template( "$feedMarkup", self.grpMarkup);
			feeds = feedArray;
		}else if(self.object.$grpOn && self.object.$grpOn == 'assignedTaskGrp'){
			var feedArray = []
			objx(feeds.sort(function(a,b){ return (a.assignedTo > b.assignedTo) ? 1: -1;})).group('assignee')
				.each(function(item,key){
					if(!(self.object.itemExpand.length > 0 &&
						$.grep(self.object.itemExpand,function(item,index){return item.assignee == key;}).length > 0) ){
							self.object.itemExpand.push({"assignee":key,"expanded":false});
						}
						feedArray.push({"assignee":key,"value":item});
				});			
			$.template( "$feedMarkup", self.grpMarkup);
			feeds = feedArray;
		}else{
			$.template( "$feedMarkup", self.markup );
		}
		return feeds;
	}
	
	/**
	* expand previously expanded items
	*/
	this.expandPrvItems = function(){
		//alert(self.object.$grpOn);
		
		var expandedToggleItems=false;
		$.each(self.object.itemExpand,
			function(key,expandedItem){ 
				if(expandedItem.expanded == true &&  $( ".group[dueDate="+expandedItem.dueDateStr+"]").length > 0)
				{
					expandedToggleItems=true; $( ".group[dueDate="+expandedItem.dueDateStr+"]").trigger("click");
				}
		});
		
		var expandedReporterItems=false;
		$.each(self.object.itemExpand,
			function(key,expandedItem){
				if(expandedItem.expanded == true &&  $( ".groupReporter[reporter="+expandedItem.reporter+"]").length > 0)
				{
					expandedReporterItems=true; $( ".groupReporter[reporter="+expandedItem.reporter+"]").trigger("click");
				}
		});
		
	
		//groupAssignedDueDate
		
		var expandedAssignedDueDateToggleItems=false;
		$.each(self.object.itemExpand,
			function(key,expandedItem){ 
				if(expandedItem.expanded == true &&  $( ".groupAssignedDueDate[dueDate="+expandedItem.dueDateStr+"]").length > 0)
				{
					expandedAssignedDueDateToggleItems=true; $( ".groupAssignedDueDate[dueDate="+expandedItem.dueDateStr+"]").trigger("click");
				}
		});
		
		var expandedAssignedItems=false;
		$.each(self.object.itemExpand,
			function(key,expandedItem){
				if(expandedItem.expanded == true &&  $( ".groupAssigned[assignee="+expandedItem.assignee+"]").length > 0)
				{
					expandedAssignedItems=true; $( ".groupAssigned[assignee="+expandedItem.assignee+"]").trigger("click");
				}
		});
		
		/* expand first items */
		if(expandedToggleItems==false)
			$( ".group").first().trigger("click");
			
		if(expandedReporterItems==false)
			$( ".groupReporter").first().trigger("click");
		if(expandedAssignedDueDateToggleItems==false)
			$( ".groupAssignedDueDate").first().trigger("click");
			
		if(expandedAssignedItems==false)
			$( ".groupAssigned").first().trigger("click");
	}
	/**
	* task action (i.e resolve and reopen)  handler
	*/
	this.addTaskActionHandler = function(){
			
	
		$( ".contentHolder" )
			.delegate( ".group", "click", function() {
			
				/* group expanded property on data, then update rendering */
				var tmplItem = $.tmplItem( this );
				if(tmplItem.data.value){
					tmplItem.data.expanded = !tmplItem.data.expanded;			

					$.grep(self.object.itemExpand,function(item,index){if(item.dueDateStr == tmplItem.data.dueDateStr) item.expanded = tmplItem.data.expanded;	 });	
					tmplItem.update();
					self.addTaskActionHandler();
					$widget.find('.contentHolder').jScrollPane({showArrows: true});
				}
			});
			
			
		$( ".contentHolder" )
			.delegate( ".groupReporter", "click", function() {
			
				/* group expanded property on data, then update rendering */
				var tmplItem = $.tmplItem( this );
				if(tmplItem.data.value){
					tmplItem.data.expanded = !tmplItem.data.expanded;			

					$.grep(self.object.itemExpand,function(item,index){if(item.reporter == tmplItem.data.reporter) item.expanded = tmplItem.data.expanded;	 });	
					tmplItem.update();
					self.addTaskActionHandler();
					$widget.find('.contentHolder').jScrollPane({showArrows: true});
				}
			});
			
			
		//groupAssignedDueDate
	
		$( ".contentHolder" )
			.delegate( ".groupAssignedDueDate", "click", function() {
			
				/* group expanded property on data, then update rendering */
				var tmplItem = $.tmplItem( this );
				if(tmplItem.data.value){
					tmplItem.data.expanded = !tmplItem.data.expanded;			

					$.grep(self.object.itemExpand,function(item,index){if(item.dueDateStr == tmplItem.data.dueDateStr) item.expanded = tmplItem.data.expanded;	 });	
					tmplItem.update();
					self.addTaskActionHandler();
					$widget.find('.contentHolder').jScrollPane({showArrows: true});
				}
			});
			
			
		$( ".contentHolder" )
			.delegate( ".groupAssigned", "click", function() {
			
				/* group expanded property on data, then update rendering */
				var tmplItem = $.tmplItem( this );
				if(tmplItem.data.value){
					tmplItem.data.expanded = !tmplItem.data.expanded;			

					$.grep(self.object.itemExpand,function(item,index){if(item.assignee == tmplItem.data.assignee) item.expanded = tmplItem.data.expanded;	 });	
					tmplItem.update();
					self.addTaskActionHandler();
					$widget.find('.contentHolder').jScrollPane({showArrows: true});
				}
			});
			
		//console.log('task-resolved-ico-holder %o ',$widget.find('div.row > div.task-resolved-ico-holder > span.task-resolved-ico'));
			
        $widget.find('div.row > div.task-resolved-ico-holder > span.task-resolved-ico').unbind('click').click(function(){
            var _taskPk = $(this).attr('taskPk');
            var _url = xenos.context.path + "/secure/ref/taskfeed/closetask.json";
            $.ajax({
                url: _url,
                type: "POST",
                data:{
                    taskPk: _taskPk
                },
                success:function(data){
                    //self.hideAddBtn($widget);
                    self.render('update');
                },
                error:function(){
                    jAlert(xenos$DBD$i18n.taskvalidation.task_close_error, null);
                }
            });
			//$(document).find('.tipsy').remove();
        });

        $widget.find('div.row > div.task-reopen-ico-holder > span.task-reopen-ico').unbind('click').click(function(){
            var _taskPk = $(this).attr('taskPk');
            var _url = xenos.context.path + "/secure/ref/taskfeed/reopentask.json";
            $.ajax({
                url: _url,
                type: "POST",
                data:{
                    taskPk: _taskPk
                },
                success:function(data){
                    //self.hideAddBtn($widget);
                    self.render('update');
                },
                error:function(){
                    jAlert(xenos$DBD$i18n.taskvalidation.task_reopen_error, null);
                }
            });
			//$(document).find('.tipsy').remove();
        });
	}
	
	
	/**
	* show all task assigned by me
	*/
	this.showAssignedByMe = function(feedUri){
	$widget.find('.myGrpBtn').hide();
	$widget.find('.assigneeGrpBtn').show();
	var menuItemObj = $widget.find('.taskmenuitem');	
	menuItemObj.removeClass('active');	
	$widget.find('#abmitem').addClass('active');
	var dataMap = {dateOffset : self.object.taskconfig.dateOffset,userList : self.object.taskconfig.userList};
			jQuery.post(feedUri,dataMap, function(json) {
				  if (!json.success) {
					return;
				  }
				self.object.$jsonresult = json.value;
				self.markup = self.object.assignedTaskMarkup;
				self.object.$filterfn();
				//$widget.find('#addTaskBtn').css('display','block');
				$widget.find('.contentHolder').jScrollPane({showArrows: true});
				
			});
	}
	
	
	/**
	* add task menu and filter handler
	*/
	this.addHandler = function(){
		$('span.taskmenuitem',$('div#Widget'+self.object.parent.selector+ ' >div.widgetContentArea > div.actionArea')).die();
		$('span.taskmenuitem',$('div#Widget'+self.object.parent.selector+ ' >div.widgetContentArea > div.actionArea')).live('click', function(e){	
			self.object.$fn = eval('('+$(this).attr('fn')+')');
			self.object.itemExpand = [];
			$widget.find('select.mycomboGrp option').first().attr("selected", true);
			$widget.find('select.assigneecomboGrp option').first().attr("selected", true);
			self.object.$grpOn = false;
			self.object.$filterfn = eval('('+$(this).attr('filterfn')+')');
			var $feedindex = $(this).attr('feedindex');//eval($(this).attr('feedindex'));
			self.object.selectedPk = $feedindex;//self.object.taskFeedPks[$feedindex];
			var feed = self.object.feeds[self.object.selectedPk];
			if(feed){
				self.object.$fn(xenos.context.path + feed.dataUri + '/' + feed.pk + '.json');
			}
		});
		
		
		$('span.taskfilteritem',$('div#Widget'+self.object.parent.selector+ ' >div.widgetContentArea > div.actionArea')).die();
		$('span.taskfilteritem',$('div#Widget'+self.object.parent.selector+ ' >div.widgetContentArea > div.actionArea')).live('click', function(e){
			self.object.$filterfn = eval('('+$(this).attr('fn')+')');
			self.object.itemExpand = [];
			self.object.$filterfn();
		});
		
		/* Pending */
		$('input[type=checkbox].pendingChkBox',$('div#Widget'+self.object.parent.selector+ ' >div.widgetContentArea > div.advanceActionArea')).die();
		$('input[type=checkbox].pendingChkBox',$('div#Widget'+self.object.parent.selector+ ' >div.widgetContentArea > div.advanceActionArea')).live('click', function(e){
			//console.log($(this).is(':checked'));
			if($(this).get(0).id == 'pending'){
				self.object.$filterPending = $(this).is(':checked');
			}
			self.object.$filterfn();
		});
		
		
		/* Routine */
		$('input[type=checkbox].routineChkBox',$('div#Widget'+self.object.parent.selector+ ' >div.widgetContentArea > div.advanceActionArea')).die();
		$('input[type=checkbox].routineChkBox',$('div#Widget'+self.object.parent.selector+ ' >div.widgetContentArea > div.advanceActionArea')).live('click', function(e){
			//console.log($(this).is(':checked'));
			self.object.$filterRoutine = $(this).is(':checked');
			self.object.$filterfn();
		});
		
		/* Grouping on task*/
		$("select.mycomboGrp",$('div#Widget'+self.object.parent.selector+ ' >div.widgetContentArea > div.advanceActionArea')).die();
		$("select.mycomboGrp",$('div#Widget'+self.object.parent.selector+ ' >div.widgetContentArea > div.advanceActionArea')).live('change', function(e){	
			//console.log(self.object.parent.selector);
			var selectedValue = $(this).find("option:selected").val();
			//alert(self.object.parent.selector +' :: '+selectedValue);
			if(selectedValue == 'dateGrp'){
				self.object.itemExpand = [];
				self.object.$grpOn = 'dueDateGrp';
				self.grpMarkup = self.object.dueDateMyTaskMarkup;
			}else if(selectedValue=='repoterGrp'){
				self.object.itemExpand = [];
				self.object.$grpOn = 'myReporterGrp';
				self.grpMarkup = self.object.repoterMyTaskMarkup;
			}else{
				self.object.$grpOn = false;
			}
			self.object.$filterfn();
		});
		
		$("select.mycomboGrp",$('div#Widget'+self.object.parent.selector+ ' >div.widgetContentArea > div.advanceActionArea')).live("keypress",function(){
			$(this).trigger("change");
		});
		
		$("select.mycomboGrp",$('div#Widget'+self.object.parent.selector+ ' >div.widgetContentArea > div.advanceActionArea')).live("click",function(){
			$(this).focus();
		});

		
		$("select.assigneecomboGrp",$('div#Widget'+self.object.parent.selector+ ' >div.widgetContentArea > div.advanceActionArea')).die();
		$("select.assigneecomboGrp",$('div#Widget'+self.object.parent.selector+ ' >div.widgetContentArea > div.advanceActionArea')).live('change', function(e){
			//console.log(self.object.parent.selector);
			var selectedValue = $(this).find("option:selected").val();
			
			//alert(self.object.parent.selector +' :: '+selectedValue);
			if(selectedValue=='assigneeDateGrp'){
				self.object.itemExpand = [];
				self.object.$grpOn = 'assigneeDueDateGrp';
				self.grpMarkup = self.object.dueDateAssignedTaskMarkup;
			}else if(selectedValue=='assigneeGrp'){
				self.object.itemExpand = [];
				self.object.$grpOn = 'assignedTaskGrp';
				self.grpMarkup = self.object.assignedGrpTaskMarkup;
			}else{
				self.object.$grpOn = false;
			}
			self.object.$filterfn();
		});
		
		
		$("select.assigneecomboGrp",$('div#Widget'+self.object.parent.selector+ ' >div.widgetContentArea > div.advanceActionArea')).live("keypress",function(){
			$(this).trigger("change");
		});
		
		
		$("select.assigneecomboGrp",$('div#Widget'+self.object.parent.selector+ ' >div.widgetContentArea > div.advanceActionArea')).live("click",function(){
			$(this).focus();
		});
		
		/* text remove on focus */
		var input = $('.searchTaskTxtBox',$('div#Widget'+self.object.parent.selector+ ' >div.widgetContentArea > div.actionArea'));
		var default_value = input.val();
		input.focus(function(){
			if ($.trim($(input).val()) == default_value) input.val('');
		});
		input.blur(function(){
			if ($.trim($(input).val()) == '') input.val(default_value);
		});
		/* text remove on focus */
		
		$('input[type=text].searchTaskTxtBox',$('div#Widget'+self.object.parent.selector+ ' >div.widgetContentArea > div.actionArea')).die();
		$('input[type=text].searchTaskTxtBox',$('div#Widget'+self.object.parent.selector+ ' >div.widgetContentArea > div.actionArea')).live('click', function(e){
			$(this).focus();
		});
		
		$('input[type=text].searchTaskTxtBox',$('div#Widget'+self.object.parent.selector+ ' >div.widgetContentArea > div.actionArea')).live('keyup', function(e){
			self.object.$filterTask = $(this).val();
			self.object.$filterfn();
		});
		
	}
	
	
	/**
	* render my task
	*/
	this.render = function(unprepared) {
	//alert('render');
		$widget = jQuery('#Widget' + self.object.parent.selector);
		clearOldElements($widget);
		
		// primary handle
		$widget.find('.contentHolder').addClass('taskContentHolder');		
		
		if($widget.find('.taskmenu').length == 0) {
		
			var actionArea =  '    <div class="actionArea">'
							+ '    </div>';
			$widget.find('.contentHolder').before(actionArea);			
			var advanceActionArea =  '    <div class="advanceActionArea">'							
							+ '    </div>';
			$widget.find('.contentHolder').after(advanceActionArea);			
			
			var $actionAreaObj = $widget.find('.actionArea');
			var $advanceActionAreaObj = $widget.find('.advanceActionArea');
			
			var filterMarkup = '<div class="taskfilter left">'
							+'<span id="history" title=\"Task History\" class="taskfilteritem taskTopBtn left" fn="self.historyDateFilter">History</span>'
							+'<span id="today" title=\"Today Task\" class="taskfilteritem taskTopBtn left" fn="self.todayDateFilter">Today</span>'
							+'<span id="future" title=\"Future Task\" class="taskfilteritem taskTopBtn left" fn="self.futureDateFilter">Future</span>'
							+'<span class="left searchTaskBtn"><input type="text" class="searchTaskTxtBox" value="Search Task" tabindex="991" /></span>'
							+'</div>';
			$actionAreaObj.append(filterMarkup);
			
			var advFilterMarkup = '<div class="taskaction left">'
							+'<span class="left pendingBtn"><input type="checkbox" class="pendingChkBox" id="pending" title= "Pending" tabindex="992" /><label class="right" title="Pending Task" for="pending">Pending</label></span>'
							+'<span class="left pendingBtn"><input type="checkbox" class="routineChkBox" id="routine" title= "Routine" tabindex="993" /><label class="right" title="Routine Task" for="routine">Routine</label></span>'
							+'</div>';
			
			var advGrpMarkup = '<div class="taskaction marginRight right">'
							+'<span class="right myGrpBtn"><label class="left">Group By</label><select class="mycomboGrp" title="Group By" tabindex="994"><option value=" " ></option><option value="dateGrp">Due Date</option> <option value="repoterGrp">Reporter</option></select></span>'
							+'<span class="right assigneeGrpBtn"><label class="left">Group By</label><select class="assigneecomboGrp" title="Group By" tabindex="994"><option value=" "></option><option value="assigneeDateGrp">Due Date</option><option value="assigneeGrp">Assignee</option></select></span>'
							+'<div class="clear"></div>'
							+'</div>'
							+ '<div class="clear"></div>';
			$advanceActionAreaObj.append(advFilterMarkup);
			$advanceActionAreaObj.append(advGrpMarkup);
			
			var manuMarkup = '<div class="taskmenu right">'
							+'<span id="mtitem" title=\"My Task\" class="taskmenuitem taskTopBtn left" fn="self.showMyTask" filterfn="self.todayDateFilter" feedindex="MT">'+self.object.feeds['MT'].name+'</span>'
							+'<span id="abmitem" title=\"Task Assigned by me\" class="taskmenuitem taskTopBtn left" fn="self.showAssignedByMe" filterfn="self.todayDateFilter" feedindex="ABM">'+self.object.feeds['ABM'].name+'</span>'
							+'</div>';
			$actionAreaObj.append(manuMarkup);
			
			/*if($widget.find('#addTaskBtn').length == 0) {
				$actionAreaObj.find('.taskmenu').append('<span id="addTaskBtn" title="Add Task" class="addTaskBtn left">M</span><div class="clear"></div>');
				$widget.find('#addTaskBtn').unbind('click').click(function(){
					$(this).attr('disabled',true);
					loadTaskScreen($(this));
				});
			}*/
			
			self.object.parent.renderer.addFeedHandle().attr('title', 'Add Task');
			self.object.parent.renderer.addFeedHandle().off('click');
			self.object.parent.renderer.addFeedHandle().on('click',function(e){
					$(e.target).attr('disabled',true);
					loadTaskScreen($(e.target));
				});
			
			$actionAreaObj.append('<div class="clear"></div>');
			self.object.selectedPk = 'MT';
			self.object.$fn = self.showMyTask;
			self.object.$filterfn = self.todayDateFilter;
			self.addHandler();			
		}
		//console.log('$widget taskList :: %o',$widget.find('.taskList'));
		//$.extend({}, {self.object.taskFeedPks['TodayTask'] : self.object.feeds[self.object.taskFeedPks['TodayTask']]}); //[self.object.feeds[self.object.taskFeedPks['TodayTask']]];
		var feed = self.object.feeds[self.object.selectedPk];
		if(feed){
			self.object.$fn(xenos.context.path + feed.dataUri + '/' + feed.pk + '.json');
		}
		$widget.find('.contentHolder').css('color', self.object.parent.foreColor);  
		//console.log('self.object.feeds %o',feed);
		
    };

	this.renderConfiguration = function(){
		 self.object.modifiedtaskconfig.dateOffset = self.object.taskconfig.dateOffset;
		 self.object.modifiedtaskconfig.userList = self.object.taskconfig.userList;
	 var config ='      <div class="row">'
				+ '        <div class="left contentBlockLabel">'
				+ '          <span>Day Offset</span>'
				+ '        </div>'
				+ '        <div class="right contentBlockValue">'
				+ '          <input id="dateOffset" class="taskConfigInput taskDateOffset" value="' + self.object.taskconfig.dateOffset + '"/>'
				+ '        </div>'
				+ '        <div class="clear"></div>'
				+ '      </div>'
				+ '      <div class="row">'
				+ '        <div class="left contentBlockLabel">'
				+ '          <span>User List</span>'
				+ '        </div>'
				+ '        <div class="right contentBlockValue">'
				+ '          <input id="userList" class="taskConfigInput taskUserList" value="' + self.object.taskconfig.userList + '"/>'
				+ '        </div>'
				+ '        <div class="clear"></div>'
				+ '      </div>';
		
		 var $configure = jQuery(config);
                var $taskDateOffset = $configure.find('.taskDateOffset');
				$taskDateOffset.unbind('click').bind('click', function() {
					self.object.dirty = true;                    
					$taskDateOffset.focus();
                });
                $taskDateOffset.unbind('keyup').bind('keyup', function() {
				//alert('hi');
					self.object.modifiedtaskconfig.dateOffset = $taskDateOffset.val();
                });
               
                var $taskUserList = $configure.find('.taskUserList');
				$taskUserList.unbind('click').bind('click', function() {        
					self.object.dirty = true;                         
					$taskUserList.focus();
                });
                $taskUserList.unbind('keyup').bind('keyup', function() {                    
					self.object.modifiedtaskconfig.userList = $taskUserList.val();
                });
		
		return  $configure ;
	};
    this.update = function() {
        $widget = jQuery('#Widget' + self.object.parent.selector);
		$widget.find('.row span').css('color', self.object.parent.foreColor);               		
    };

    this.dispose = function() {
        var $taskDialog = $('#taskDialog');
        $taskDialog.dialog('destroy');
        $taskDialog.remove();
    };
}