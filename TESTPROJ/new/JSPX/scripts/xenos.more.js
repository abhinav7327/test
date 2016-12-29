//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
(function ($) {
  $.fn.xenosmore = function(options) {
    return this.each( function() {
      var $self = $(this);
      var defaultOption = {
        selector : {
          query:'.handleBlock>span.handler',
          detailview:'span.toggleHandle',
          entry:'.handleBlock>span.handler',
          amend:'.handleBlock>span.handler'
        },
        parentSelector: {
          query: 'div.moreHandle',
          detailview: 'h1.msgHead',
          entry: 'div.moreHandle',
          amend: 'div.moreHandle'
        },
        applyFor : 'screen'
      };

      //Extend default options by the options passed to this function
      jQuery.extend(defaultOption , options);

      //Set the data as "Y", to indicate that the call for xenosmore is made on this container
      $self.data('xenos$More$Handler', "Y");

      //Enabling toggling option for more items
      function enableTogglingMoreItems(_handler, _parentHandler, _doExpand) {
        var onclick = function (event) {
          var isCollapsed = true;

          if ($(this).hasClass('expand') || $(this).attr('title') == "Expand") {
            $(this).removeClass("expand");
            $(this).addClass("collapse");
            $(this).attr('title', 'Collapse');
            _parentHandler.attr('title', 'Collapse');
            isCollapsed = false;
          } else {
            $(this).removeClass("collapse");
            $(this).addClass('expand');
            $(this).attr('title', 'Expand');
            _parentHandler.attr('title', 'Expand');
          }

          //class div.exmMoreHandle is explicitly for EXM Detail View (Edit Popup View/Comment Popup View/HTML View)
          //For all other screens, class div.moreHandle is used

          // $(this).parents('div.moreHandle, div.exmMoreHandle').nextAll('.more:first').slideToggle("slow");
          $(this).parents('div').nextAll('div:first').slideToggle("slow", function() {
            // For entry amend and query screens only
            if(defaultOption.mode !== 'detailview') {
              var formItem = false;
              if(!isCollapsed) {
                formItem = _parentHandler.next().find('.formItem:first-child');
              } else {
                var formItemBlock = _parentHandler.parent().find('.formItemBlock:first-child');
                formItem = $(formItemBlock).find('.formItem').last();
              }

              if($('span:first', formItem).children().length > 0) {
                  if($('span:first', formItem).find('.ui-multiselect-input').length > 0) {
                      $('span:first', formItem).find('.ui-multiselect-input').focus();
                  } else {
                      $('span:first', formItem).children().first().focus();
                  }
                }
            }

          });

          // Stop further event propagation to prevent infinite loop
          event.stopPropagation();
        };

        //just to be on safe side to remove existing click if any
        _handler.unbind("click", onclick);
        _handler.bind('click', onclick);

        // Parent panel click handler
        var onPanelClick = function(event) {
          if ($(_handler).hasClass('expand') || $(_handler).hasClass('collapse')) {
            $(_handler).trigger('click');
          } else {
            event.stopPropagation();
          }
        };

        // Un-bind and re-bind the parent click event on the parent
        _parentHandler.unbind("click", onPanelClick);
        _parentHandler.bind("click", onPanelClick).css({'cursor': 'pointer'});

        //Check if the 'applyFor' option is 'screen', if so then do the following
        //If 'applyFor' option is 'personalization' or anything else, then skip this
        if (defaultOption['applyFor'] == "screen") {
          //Initially set the Title as 'Expand' & class as 'expand' to the handler object and then hide the more section
          if(!_handler.hasClass('collapse')) {
            _handler.attr('title', 'Expand');
            _handler.addClass('expand');
            _parentHandler.attr('title', 'Expand');

            // _handler.parents('div.moreHandle, div.exmMoreHandle').nextAll('.more:first').hide();
            _handler.parents('div').nextAll('div:first').hide();
          }

          //Now if the '_doExpand' is true then trigger the click event.
          //i.e. by configuration file it is to be expanded on page load
          if (_doExpand) {
            _handler.trigger('click');
          }
        }
      };

      /*
      if (xenos$Cache.get('screenConfig')) {
        var screenId = "";
        if (defaultOption.mode == "query") {
          screenId = $self.parents('form').find('input[name="screenId"]').val();
        } else {
          screenId = $self.find('form').find('input[name="screenId"]').val();
        }
        if ($.trim(screenId) == "") {
          return false;
        }

        var openSections = [];
        var moresections = xenos$Cache.get('screenConfig').screenList;
        $.each(moresections, function(index, moresection) {
          if (moresection.screenID == screenId) {
            openSections = moresection['openSectionIDS'];
            return false;
          }
        });

        var handlers = $self.find(defaultOption.selector[defaultOption.mode]);
        var parentHandlers = $self.find(defaultOption.parentSelector[defaultOption.mode]);
        $.each(handlers, function(index, handler) {
          if ($.inArray($(handler).attr('id'), openSections)> -1) {
            enableTogglingMoreItems($(handler), $(parentHandlers[index]), true);
          } else {
            enableTogglingMoreItems($(handler), $(parentHandlers[index]), false);
          }
        });

      }
      */

      var handlers = $self.find(defaultOption.selector[defaultOption.mode]);
      var parentHandlers = $self.find(defaultOption.parentSelector[defaultOption.mode]);
      $.each(handlers, function(index, handler) {
        enableTogglingMoreItems($(handler), $(parentHandlers[index]), false);
      });

    });
  }
}(jQuery));
