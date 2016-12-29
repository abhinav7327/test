//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
//
// xenos
//  - Dashboard business feed infrastructure
//


// Object
function xenos$DBD$BusinessFeed(parent) {
  // inherit
  this.inherit = xenos$DBD$Content;
  this.inherit(parent, 'xenos$DBD$BusinessFeed');
  // self
  var self = this;


  // attributes

  self.parent.hasGraph = true;


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


  // chart data
  this.chartData = [];


  this.polling = function(feed) {
    var uri = xenos.context.path + '/secure/ref/businessfeed/detail/' + feed.pk + '.json';
    var options = {
      url: uri,
      dataType: 'json',
      success: function(json) {
        if (!json.success) {
          console.log(json);
 		  if(json.warning) {
		  feed.warning = true;
		  } else {
		  feed.error = true;
		  }
          self.render('update');
          return;
        }

        // prepare
        feed.error = false;
		feed.warning = false;
        if (json.value[0].count != null)
          feed.data = json.value[0].count;

        // chart data
        var series = self.chartData[feed.order];
        if (series.data.length >= 10) {
          for (var i = 1 ; i < series.data.length ; i++) {
            series.data[i - 1] = series.data[i];
          }
        }
        series.data.push([new Date().getTime(), feed.data]);

        self.render('update');


        // direct chart
        if (self.renderer.chart) {
          series = self.renderer.chart.get(feed.name);
          series.addPoint({x: new Date().getTime(), y: feed.data}, true, series.data.length >= 10);
        }
      }
    };

    jQuery.ajaxq(self.parent.name, options);
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
        order: order,
        maiden: true,
        error: false,
		warning: false,
        data: 0,
        dataUri: rawFeed.dataUrl,
        dataInterval: rawFeed.asyncInterval,
        pollingId: 0,
        viewUri: rawFeed.feedUrl,
		countRendered : false
      };

      // prepare
      self.count++;

      self.feeds[feed.pk] = feed;
      self.feedsOrder[order] = feed.pk;

      // chart data
      self.chartData.push({
        id: feed.name,
        name: feed.name,
        showInLegend: false,
        data: []
      });
    });
  };


  // rendition
  this.renderer = new xenos$DBD$BusinessFeed$renderer(this);


  // connection
  this.connectActivity = function() {
    jQuery.each(self.feeds, function(pk, feed) {
      if (feed.dataInterval) {
        if (!feed.countRendered)
          setTimeout(function() {self.polling(feed);}, 0);

        if (!feed.pollingId)
          feed.pollingId = setInterval(function() {self.polling(feed);}, feed.dataInterval);
      }
    });
  };

  this.disconnectActivity = function() {
    jQuery.each(self.feeds, function(pk, feed) {
      if (feed.pollingId) {
        clearInterval(feed.pollingId);
        feed.pollingId = 0;

        jQuery.ajaxq(self.parent.name);
      }
    });
  };


  // other functions

  // add feeds
  this.addFeeds = function(feedsPk, callback, delegator) {
	    if (feedsPk.length == 0) return false;

	    var uri = xenos.context.path + '/secure/ref/widget/addfeed.json';

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
          console.log(json);
          jQuery.each(feedsPk, function(p, pk) {
		  
            var feed = self.parent.feeds[pk.displayRowNum];
            messages.push(xenos$DBD$i18n.business.feed_not_added + feed.name);
          });
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
          feed.error = false;
		  feed.warning = false;
          feed.data = 0;

          self.feeds[feed.pk] = feed;
          self.feedsOrder[feed.order] = feed.pk;

          // chart data
          self.chartData.push({
            id: feed.name,
            name: feed.name,
            showInLegend: false,
            data: []
          });

          // connect
          if (feed.dataInterval) {
            if (feed.data == 0)
              setTimeout(function() {self.polling(feed);}, 0);

            if (!feed.pollingId)
              feed.pollingId = setInterval(function() {self.polling(feed);}, feed.dataInterval);
          }

          messages.push(feed.name + xenos$DBD$i18n.business.feed_added);
        });


        xenos.postNotice(xenos.notice.type.info, messages);
        if (callback) callback.call(delegator ? delegator : self, feedsPk);
      }
    });

    return true;
  };

  // remove feed
  this.removeFeed = function(feedPk, callback, delegator) {
    var feed = self.feedByPk(feedPk);

    var uri = xenos.context.path + '/secure/ref/widget/remove/' + self.parent.parent.pk + '/' + self.parent.pk + '/' + feedPk + '.json';
    jQuery.getJSON(uri, function(json) {
      if (!json.success) {
        console.log(json);
        xenos.postNotice(xenos.notice.type.error, xenos$DBD$i18n.business.feed_not_removed + feed.name);
        return;
      }

      // remove from feeds
      self.count--;

      // disconnect
      if (feed.pollingId) {
        clearInterval(feed.pollingId);
        feed.pollingId = 0;
      }

      delete self.feeds[feedPk];

      for (var newOrder = 0; newOrder < self.count; newOrder++)
        if (newOrder >= feed.order) {
          self.feedsOrder[newOrder] = self.feedsOrder[newOrder + 1];
          self.feeds[self.feedsOrder[newOrder]].order = newOrder;

          // chart data
          self.chartData[newOrder] = self.chartData[newOrder + 1];
        }

      delete self.feedsOrder[self.count];

      // chart data
      self.chartData.pop();

      xenos.postNotice(xenos.notice.type.info, feed.name + xenos$DBD$i18n.business.feed_removed);
      if (callback) callback.call(delegator ? delegator : self, feed);
    });

    return true;
  };
}


// Renderer
function xenos$DBD$BusinessFeed$renderer(object) {
  // inherit
  this.inherit = xenos$DBD$Content$renderer;
  this.inherit(object);
  // self
  var self = this;


  // colors
  this.colorRoller = 0;
  this.chartColors = ['#6f9b1e', '#004b94', '#e5cb05', '#e98115'];
  this.iconColors = ['colorIconGreen', 'colorIconBlue', 'colorIconYellow', 'colorIconOrange'];


  // chart options
  var chartOptions = {
    chart: {
      renderTo: jQuery('#Widget' + self.object.parent.selector).find('.graphHolder'),
      backgroundColor: 'none',
      marginRight: 10,
      type: 'spline'
    },
    credits: {
      enabled: false
    },
    title: {
      text: ''
    },
    xAxis: {
      type: 'datetime',
      tickPixelInterval: 75,

      lineColor: '#ffffff',
      tickColor: '#ffffff',
      labels: {
        style: {
          color: '#ffffff'
        }
      }
    },
    yAxis: {
      title: {
        text: ''
      },
      min: 0,

      lineColor: '#ffffff',
      tickColor: '#ffffff',
      labels: {
        style: {
          color: '#ffffff'
        }
      }
    },
    tooltip: {
      formatter: function() {
        var name = this.series.name;
        if (name.length > 25)
          name = name.substr(0, 22).concat('...');

        return '<b>' + name + '</b><br/>' + this.y + ' at ' + Highcharts.dateFormat('%H:%M:%S', this.x);
      }
    },
    series: self.object.chartData
  };


  // chart
  this.chart;


  // editable
  self.object.onEditable = function() {
    var $widget = jQuery('#Widget' + self.object.parent.selector);
    $widget.find('.removeFeedButton').show();
  };
  // uneditable
  self.object.onUneditable = function() {
    var $widget = jQuery('#Widget' + self.object.parent.selector);
    $widget.find('.removeFeedButton').hide();
  };


  // refresh feed
  this.refreshFeed = function(e) {
    var $refreshFeedHandle = self.object.parent.renderer.refreshFeedHandle();
    $refreshFeedHandle.off('click');
    $refreshFeedHandle.attr('disabled', true);

    var _function = function() {
      $refreshFeedHandle.removeAttr('disabled');
      $refreshFeedHandle.on('click', self.refreshFeed);
    };
    setTimeout(_function, self.object.parent.refreshIntervalMin);

    self.object.disconnectActivity();
    jQuery.each(self.object.feeds, function(pk, feed) {
      self.object.polling(feed);
    });
    self.object.connectActivity();
  };


  this.doRender = function(action, phase) {
    // primary handle
    var $widget = jQuery('#Widget' + self.object.parent.selector);
	
    if (action == 'render') {
      var $refreshFeedHandle = self.object.parent.renderer.refreshFeedHandle();
      $refreshFeedHandle.off('click');
      $refreshFeedHandle.on('click', self.refreshFeed);
    }

    // look and feel
    var big = self.object.parent.feedRemovable ? '' : 'Big';
	
	// Reset the Color Roller count each time a widget is rendered.
	self.colorRoller = 0;
	
    jQuery.each(self.object.feedsOrder, function(order, pk) { 
      var feed = self.object.feeds[pk];
      if (action == 'render' || feed.maiden) {
        var markup = ''
            + '<div pk="' + feed.pk + '"class="row">'
            + '  <div class="left ' + self.iconColors[self.colorRoller] + '"></div>'
            + '  <div class="left contentBlockLabel' + big + '">';

        if (feed.viewUri == 'NO_HYPERLINK') {
          markup += '<span class="feedRow" title="' + feed.name + '" style="color:' + self.object.parent.foreColor + ';">' + feed.name + '</span>';
        } else {
			// in case of if any feed contains "xenos.context.path" then consider it as absolute URL
			// otherwise build it carefully to avoid relative URL problem(s)
		  var absolute_feed_uri = (xenos.context.path + (feed.viewUri.charAt(0) != '/' ? '/' : '') + feed.viewUri)
								  + (feed.viewUri.indexOf("?") == -1 ? '?' : '&');
		  var feed_uri = absolute_feed_uri + "pk=" + feed.pk + "&query=dashboard&fragments=content";
          markup += '<a href="' + encodeURI(feed_uri) + '" title="' + feed.name + '" style="color:' + self.object.parent.linkColor + ';">' + feed.name + '</a>';
        }
		
        markup += ''
            + '  </div>'
            + '  <div id="Feed' + feed.selector + '" class="right contentBlockValue' + big + '" style="color:' + self.object.parent.foreColor + ';">';
        if (feed.maiden) {
          feed.maiden = false;
          markup += '<img src="' + xenos.context.path + '/images/xenos/dashboardLoader.gif" alt="" border="0"/>';
        } else if (feed.error) {
          markup += '<div class="formTabErrorIco"><a href="#">Error</a></div>';
        } else if (feed.warning) {
          markup += '<div class="formTabWarningIco"><a href="#">Error</a></div>';
        }else {
          markup += feed.data;
        }

        markup += ''
            + '  </div>';

        if (self.object.parent.feedRemovable) {
          markup += ''
              + '  <div class="right contentBlockButton">'
              + '    <a href="#" title="Remove this feed" class="removeFeedButton" pk="' + feed.pk + '" style="color:' + self.object.parent.foreColor + ';">h</a>'
              + '  </div>';
        }

        markup += ''
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
        $markup.find('.contentBlockLabel a').on('click', {resultType: "feed_query"}, _handleWidgetLinkClick);

        /**/
        /**/


        // chart data
        self.object.chartData[feed.order].color = self.chartColors[self.colorRoller];

        // roller
        self.colorRoller++;
        if (self.colorRoller == self.iconColors.length) self.colorRoller = 0;

        // chart
        if (self.chart)
          self.chart.addSeries(self.object.chartData[feed.order]);
      } else {
		var $fedSelector = $('#Feed' + feed.selector);
        if (feed.error) {
			$fedSelector.html('<div class="formTabErrorIco"><a href="#">Error</a></div>');
        } else if (feed.warning) {
			$fedSelector.html('<div class="formTabWarningIco"><a href="#">Error</a></div>');
        } else {
        	if($fedSelector.length ==0){
				setTimeout(function(){self.renderFeed($widget, feed)},0);
			} else {
          		$fedSelector.text(feed.data);
			}
			feed.countRendered = true;
        }
      }
    });


    $widget.find('.contentHolder .row a').css('color', self.object.parent.linkColor);
    $widget.find('.contentHolder .row span').css('color', self.object.parent.foreColor);
    $widget.find('.contentHolder .row .contentBlockValue').css('color', self.object.parent.foreColor);
    $widget.find('.contentHolder .row .contentBlockButton a').css('color', self.object.parent.foreColor);


    // feed remove handler
    $widget.find('.contentBlockButton a').off('click');
    $widget.find('.contentBlockButton a').on('click', function(e) {
      // get the confirmation
      jConfirm(xenos$DBD$i18n.business.confirm_feed_remove, null, function(confirmation) {
        if (confirmation) {
          var _function = function(feed) {
            $(e.target).parent().parent().remove();

            // chart
            if (self.chart) {
              var series = self.chart.get(feed.name);
              series.remove();
            }

            $widget.find('.contentHolder').jScrollPane({showArrows: true});
          };
          self.object.removeFeed($(e.target).attr('pk'), _function, self);
        }
      });
    });


    // scroll pane & chart
    var $contentHolder = $widget.find('.contentHolder');
    if (self.object.parent.showGraph) {
      if ($widget.find('.graphHolder').length == 0) {
        var markup = '<div class="graphHolder"></div>';
        $contentHolder.before(markup);

        Highcharts.setOptions({
          global: {
            useUTC: false
          }
        });

        chartOptions.chart.renderTo = $widget.find('.graphHolder')[0];
        if($widget.find('.graphHolder').length){
          self.chart = new Highcharts.Chart(chartOptions);
        }
      }

      $contentHolder.css('height', 160);
    } else {
      if ($widget.find('.graphHolder').length == 1) {
        $widget.find('.graphHolder').remove();
        self.chart = undefined;
      }

      $contentHolder.css('height', 280);
    }

    $contentHolder.jScrollPane({showArrows: true});
  };

   /* Feed render and count update are two parallel process. When user navigate to screen before full dashboard
    * loading some feeds may not be rendered. Feed rendering is the part of business feed component. After giving call
	* to business feed component Widget marked it's property as prepared. So during rendering of feed if some wrong
	* happens Widget don't have any clue. In this scenario if user again navigate to dashboard, not rendered feeds will 
	* not be rendered again. That's why this API is introduced to focefully render a given feed.
    */
   this.renderFeed = function($widget, feed){
	// look and feel
    var big = self.object.parent.feedRemovable ? '' : 'Big';
	
	var markup = ''
            + '<div class="row">'
            + '  <div class="left ' + self.iconColors[self.colorRoller] + '"></div>'
            + '  <div class="left contentBlockLabel' + big + '">';

        if (feed.viewUri == 'NO_HYPERLINK') {
          markup += '<span class="feedRow" title="' + feed.name + '" style="color:' + self.object.parent.foreColor + ';">' + feed.name + '</span>';
        } else {
			// in case of if any feed contains "xenos.context.path" then consider it as absolute URL
			// otherwise build it carefully to avoid relative URL problem(s)
		  var absolute_feed_uri = (xenos.context.path + (feed.viewUri.charAt(0) != '/' ? '/' : '') + feed.viewUri)
								  + (feed.viewUri.indexOf("?") == -1 ? '?' : '&');
		  var feed_uri = absolute_feed_uri + "pk=" + feed.pk + "&query=dashboard&fragments=content";
          markup += '<a href="' + encodeURI(feed_uri) + '" title="' + feed.name + '" style="color:' + self.object.parent.linkColor + ';">' + feed.name + '</a>';
        }

        markup += ''
            + '  </div>'
            + '  <div id="Feed' + feed.selector + '" class="right contentBlockValue' + big + '" style="color:' + self.object.parent.foreColor + ';">';
        if (feed.maiden) {
          feed.maiden = false;
          markup += '<img src="' + xenos.context.path + '/images/xenos/dashboardLoader.gif" alt="" border="0"/>';
        } else if (feed.error) {
          markup += '<div class="formTabErrorIco"><a href="#">Error</a></div>';
        } else if (feed.warning) {
          markup += '<div class="formTabWarningIco"><a href="#">Error</a></div>';
        }else {
          markup += feed.data;
        }

        markup += ''
            + '  </div>';

        if (self.object.parent.feedRemovable) {
          markup += ''
              + '  <div class="right contentBlockButton">'
              + '    <a href="#" title="Remove this feed" class="removeFeedButton" pk="' + feed.pk + '" style="color:' + self.object.parent.foreColor + ';">h</a>'
              + '  </div>';
        }

        markup += ''
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
        $markup.find('.contentBlockLabel a').on('click', {resultType: "feed_query"}, _handleWidgetLinkClick);

        /**/
        /**/


        // chart data
        self.object.chartData[feed.order].color = self.chartColors[self.colorRoller];

        // roller
        self.colorRoller++;
        if (self.colorRoller == self.iconColors.length) self.colorRoller = 0;

        // chart
        if (self.chart)
          self.chart.addSeries(self.object.chartData[feed.order]);
		  
		self.object.onUneditable();
   }

  this.render = function(unprepared) {
    self.doRender('render', unprepared);
  };

  this.update = function(unprepared) {
    self.doRender('update', unprepared);
  };


  this.dispose = function() {
    self.chart = undefined;
  };
}
