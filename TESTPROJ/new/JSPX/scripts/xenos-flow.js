//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
(function(jQuery) {

  jQuery.fn.xenosFlow = function(options) {
    // define flow
    var JxenosFlow = function(element, options) {
      // default options
      var defaultOptions = {
        slideType: 'slide',
        slideNames: [],
        slidesSelector: '#slides',
        slidesWrapperSelector: '#slidesWrapper',
        width: '100%',
        height: '100%',
        duration: 400,
        easing: 'swing',
        selectedIndex: 0,
        selectedClass: 'selectedSlide',
        controllersSelector: '.controller',
        previousSelector: '.previousSlide',
        nextSelector: '.nextSlide',
        addSelector: '.addSlide',
        addHoverClass: 'addSlideHover',
        enabledAddTitle: 'Add new slide',
        disabledAddTitle: '',
        addToTail: false,
        removeSelector: '.removeSlide',
        removeHoverClass: 'removeSlideHover',
        enabledRemoveTitle: 'Remove this slide',
        disabledRemoveTitle: '',
        slideTemplate: '<div class="${slideType}"></div>', /* slideType, capitalisedSlideType, slideName, controllerIndex, slideIndex */
        controllerTemplate: '<span class="controller" activeTitle="${slideName}" inactiveTitle="Switch to ${slideName}"><span>${slideName}</span></span>', /* slideType, capitalisedSlideType, slideName, controllerIndex, slideIndex */
        activeControllerTitleTemplate: '${slideName}', /* slideType, capitalisedSlideType, slideName, controllerIndex, slideIndex */
        inactiveControllerTitleTemplate: 'Switch to ${slideName}', /* slideType, capitalisedSlideType, slideName, controllerIndex, slideIndex */
        onSwitch: function(slideIndex) {},
        preAdd: function(slideIndex) {}, /* should return false to cancel */
        onAdd: function(slideIndex) {},
        preRemove: function(slideIndex) {}, /* should return false to cancel */
        onRemove: function(slideIndex) {}
      };


      // options manipulations
      if (options && options.slideType) {
        options.capitalisedSlideType
            = options.slideType.substring(0, 1).toUpperCase() + options.slideType.substring(1);

        defaultOptions.slidesSelector = '#' + options.slideType + 's';
        defaultOptions.slidesWrapperSelector = '#' + options.slideType + 'sWrapper';
        defaultOptions.selectedClass = 'selected' + options.capitalisedSlideType;
        defaultOptions.addSelector = '.add' + options.capitalisedSlideType;
        defaultOptions.addHoverClass = '.add' + options.capitalisedSlideType + 'Hover';
        defaultOptions.enabledAddTitle = 'Add new ' + options.slideType;
        defaultOptions.removeSelector = '.remove' + options.capitalisedSlideType;
        defaultOptions.removeHoverClass = '.remove' + options.capitalisedSlideType + 'Hover';
        defaultOptions.enabledRemoveTitle = 'Remove this ' + options.capitalisedSlideType;
        defaultOptions.previousSelector = '.previous' + options.capitalisedSlideType;
        defaultOptions.nextSelector = '.next' + options.capitalisedSlideType;
      }
      options = jQuery.extend({}, defaultOptions, options);


      var currentIndex = options.selectedIndex;
      var slideCount = jQuery(options.controllersSelector).length;

      var slideNames = {};
      jQuery.each(options.slideNames, function(index, slideName) {
        slideNames[index] = slideName;
      });


      // prepare slide
      var slide = function(duration, index) {
        var $slidesSelector = jQuery(options.slidesSelector);
        $slidesSelector.children().css({overflow: "hidden"});
        jQuery(options.slidesSelector + " iframe").hide().addClass("iframe_hide");

        $slidesSelector.animate(
            {marginLeft: "-" + (index * $slidesSelector.find(":first-child").width() + "px")},
            options.duration * duration,
            options.easing,
            function() {
              $slidesSelector.children().css({overflow: "auto"});
              jQuery(".iframe_hide").show();
            }
        );
      };


      // prepare controller
      var controller = function() {
        jQuery(options.controllersSelector).each(function(index) {
          var $this = jQuery(this);
          var $controllersSelector = jQuery(options.controllersSelector);

          $this.off('click');
          $this.on('click', function() {
            if (jQuery(options.slidesSelector).is(":animated")) return;

            var oldIndex = currentIndex;
            currentIndex = index;

            $controllersSelector.removeClass(options.selectedClass);
            $this.addClass(options.selectedClass);

            $controllersSelector.each(function() {
              var $this = jQuery(this);
              $this.attr('title', $this.attr('inactiveTitle'));
            });
            $this.attr('title', $this.attr('activeTitle'));

            slide(Math.abs(oldIndex - currentIndex), currentIndex);
            if (options.onSwitch) options.onSwitch(currentIndex);
          });
        });
      };


      // prepare previous next
      var previous = function() {
        jQuery(options.previousSelector).on('click', function() {
          if (jQuery(options.slidesSelector).is(":animated")) return;

          var duration = 1;
          if (currentIndex > 0)
            currentIndex--;
          else {
            currentIndex = slideCount - 1;
            duration = currentIndex;
          }

          var $controllersSelector = jQuery(options.controllersSelector);
          var $activeControllerSelector = $controllersSelector.eq(currentIndex);

          $controllersSelector.removeClass(options.selectedClass);
          $activeControllerSelector.addClass(options.selectedClass);

          $controllersSelector.each(function() {
            var $this = jQuery(this);
            $this.attr('title', $this.attr('inactiveTitle'));
          });
          $activeControllerSelector.attr('title', $activeControllerSelector.attr('activeTitle'));

          slide(duration, currentIndex);
          if (options.onSwitch) options.onSwitch(currentIndex);
        });
      };
      var next = function() {
        jQuery(options.nextSelector).on('click', function() {
          if (jQuery(options.slidesSelector).is(":animated")) return;

          var duration = 1;
          if (currentIndex < slideCount - 1)
            currentIndex++;
          else {
            currentIndex = 0;
            duration = slideCount - 1;
          }

          var $controllersSelector = jQuery(options.controllersSelector);
          var $activeControllerSelector = $controllersSelector.eq(currentIndex);

          $controllersSelector.removeClass(options.selectedClass);
          $activeControllerSelector.addClass(options.selectedClass);

          $controllersSelector.each(function() {
            var $this = jQuery(this);
            $this.attr('title', $this.attr('inactiveTitle'));
          });
          $activeControllerSelector.attr('title', $activeControllerSelector.attr('activeTitle'));

          slide(duration, currentIndex);
          if (options.onSwitch) options.onSwitch(currentIndex);
        });
      };


      // prepare add
      var add = function(slideName, processMarkup, data) {
        var oldIndex = currentIndex;

        var variables = {
          slideType: options.slideType,
          capitalisedSlideType: options.capitalisedSlideType,
          slideName: slideName
        };

        if (options.addToTail) {
          if (processMarkup) {
            variables.controllerIndex = jQuery(options.controllersSelector).length;
            variables.slideIndex = jQuery(options.controllersSelector).length;

            var html = jQuery.tmpl(options.controllerTemplate, variables);
            jQuery(options.controllersSelector).last().after(html);

            var html = jQuery.tmpl(options.slideTemplate, variables);
            jQuery(options.slidesSelector).children().last().after(html);
          } else {
            variables.controllerIndex = jQuery(options.controllersSelector).length - 1;
            variables.slideIndex = jQuery(options.controllersSelector).length - 1;
          }

          slideNames[variables.slideIndex] = variables.slideName;
          currentIndex = variables.slideIndex;
        } else {
          var tempSlideNames = {};

          jQuery(options.controllersSelector).each(function(index) {
            if (index == currentIndex) {
              variables.controllerIndex = index;
              variables.slideIndex = index;

              if (processMarkup) {
                var html = jQuery.tmpl(options.controllerTemplate, variables);
                jQuery(this).after(html);

                var html = jQuery.tmpl(options.slideTemplate, variables);
                jQuery(options.slidesSelector).children().eq(index).after(html);
              }

              tempSlideNames[variables.slideIndex] = variables.slideName;
            } else if (index > currentIndex) {
              variables.slideName = slideNames[index];
              variables.controllerIndex = index + 1;
              variables.slideIndex = index + 1;

              if (processMarkup) {
                var $this = jQuery(this);

                var activeTitle = jQuery.tmpl(options.activeControllerTitleTemplate, variables);
                $this.attr('activeTitle', jQuery(activeTitle).text());
                var inactiveTitle = jQuery.tmpl(options.inactiveControllerTitleTemplate, variables);
                $this.attr('inactiveTitle', jQuery(inactiveTitle).text());
              }

              tempSlideNames[variables.slideIndex] = variables.slideName;
            }
          });

          slideNames = jQuery.extend({}, slideNames, tempSlideNames);

          currentIndex++;
        }

        slideCount = jQuery(options.controllersSelector).length;
        controller();
        resize();

        var $controllersSelector = jQuery(options.controllersSelector);
        var $activeControllerSelector = $controllersSelector.eq(currentIndex);

        $controllersSelector.removeClass(options.selectedClass);
        $activeControllerSelector.addClass(options.selectedClass);

        $controllersSelector.each(function() {
          var $this = jQuery(this);
          $this.attr('title', $this.attr('inactiveTitle'));
        });
        $activeControllerSelector.attr('title', $activeControllerSelector.attr('activeTitle'));

        slide(Math.abs(oldIndex - currentIndex), currentIndex);
        if (options.onAdd) options.onAdd(oldIndex, currentIndex, data);
        if (options.onSwitch) options.onSwitch(currentIndex, data);
      };

      var addDisabled = false;
      var enableAdd = function() {
        addDisabled = false;

        var $addSelector = jQuery(options.addSelector);
        $addSelector.off('click');
        $addSelector.on('click', function() {
          if (jQuery(options.slidesSelector).is(":animated")) return;

          if (options.preAdd) {
            var response = options.preAdd(currentIndex);
            if (typeof response === 'undefined') return;
            if ((typeof response === 'boolean' || typeof response === 'Boolean') && !response) return;

            add(response);
          } else {
            add();
          }
        });
      };
      var disableAdd = function() {
        addDisabled = true;
        jQuery(options.addSelector).off('click');
      };

      jQuery(options.addSelector).hover(
          function() {
            var $this = jQuery(this);

            if (addDisabled) {
              $this.attr('title', options.disabledAddTitle);
            } else {
              $this.addClass(options.addHoverClass);
              $this.attr('title', options.enabledAddTitle);
            }
          },
          function() {
            var $this = jQuery(this);
            $this.removeClass(options.addHoverClass);
            $this.removeAttr('title');
          }
      );


      // prepare remove
      var remove = function(slideName /* for future */, processMarkup, data) {
        var tempSlideNames = {};

        jQuery(options.controllersSelector).each(function(index) {
          if (index == currentIndex) {
            if (processMarkup) {
              jQuery(this).remove();
              jQuery(options.slidesSelector).children().eq(index).remove();
            }
          } else if (index > currentIndex) {
            var variables = {
              slideType: options.slideType,
              capitalisedSlideType: options.capitalisedSlideType,
              slideName: slideNames[index],
              controllerIndex: index - 1,
              slideIndex: index - 1
            };

            if (processMarkup) {
              var $this = jQuery(this);

              var activeTitle = jQuery.tmpl(options.activeControllerTitleTemplate, variables);
              $this.attr('activeTitle', jQuery(activeTitle).text());
              var inactiveTitle = jQuery.tmpl(options.inactiveControllerTitleTemplate, variables);
              $this.attr('inactiveTitle', jQuery(inactiveTitle).text());
            }

            tempSlideNames[variables.slideIndex] = variables.slideName;
          }
        });

        slideNames = jQuery.extend({}, slideNames, tempSlideNames);

        slideCount = jQuery(options.controllersSelector).length;
        controller();
        resize();

        var oldIndex = currentIndex;
        if (currentIndex == slideCount) {
          oldIndex = slideCount;
          currentIndex = 0;
        }

        var $controllersSelector = jQuery(options.controllersSelector);
        var $activeControllerSelector = $controllersSelector.eq(currentIndex);

        $controllersSelector.removeClass(options.selectedClass);
        $activeControllerSelector.addClass(options.selectedClass);

        $controllersSelector.each(function() {
          var $this = jQuery(this);
          $this.attr('title', $this.attr('inactiveTitle'));
        });
        $activeControllerSelector.attr('title', $activeControllerSelector.attr('activeTitle'));

        slide(Math.abs(oldIndex - currentIndex), currentIndex);
        if (options.onRemove) options.onRemove(oldIndex, currentIndex, data);
        if (options.onSwitch) options.onSwitch(currentIndex, data);
      };

      var removeDisabled = false;
      var enableRemove = function() {
        removeDisabled = false;

        var $removeSelector = jQuery(options.removeSelector);
        $removeSelector.off('click');
        $removeSelector.on('click', function() {
          if (jQuery(options.slidesSelector).is(":animated")) return;


          if (options.preRemove) {
            var response = options.preRemove(currentIndex);
            if (typeof response === 'undefined') return;
            if ((typeof response === 'boolean' || typeof response === 'Boolean') && !response) return;

            remove(response);
          } else {
            remove();
          }
        });
      };
      var disableRemove = function() {
        removeDisabled = true;
        jQuery(options.removeSelector).off('click');
      };

      jQuery(options.removeSelector).hover(
          function() {
            var $this = jQuery(this);

            if (removeDisabled) {
              $this.attr('title', options.disabledRemoveTitle);
            } else {
              $this.addClass(options.removeHoverClass);
              $this.attr('title', options.enabledRemoveTitle);
            }
          },
          function() {
            var $this = jQuery(this);
            $this.removeClass(options.removeHoverClass);
            $this.removeAttr('title');
          }
      );


      // resize handler
      var resize = function() {
        jQuery(options.slidesWrapperSelector).css({
          position: "relative",
          width: options.width,
          height: options.height,
          overflow: "hidden"
        });

        jQuery(options.slidesSelector).css({
          position: "relative",
          width: jQuery(options.slidesWrapperSelector).width() * jQuery(options.controllersSelector).length + "px",
          height: jQuery(options.slidesWrapperSelector).height() + "px",
          overflow: "hidden"
        });

        jQuery(options.slidesSelector).children().css({
          "float": "left",
          position: "relative",
          width: jQuery(options.slidesWrapperSelector).width() + "px",
          height: jQuery(options.slidesWrapperSelector).height() + "px",
          overflow: "auto"
        });

        jQuery(options.slidesSelector).css({
          marginLeft: "-" + (currentIndex * jQuery(options.slidesSelector).find(":eq(0)").width() + "px")
        });
      };

      // initialise
      var initialise = function() {
        controller();
        previous();
        next();
        enableAdd();
        enableRemove();

        var slidesWrapperId = options.slidesWrapperSelector.substring(1, options.slidesWrapperSelector.length);
        jQuery(options.slidesSelector).before('<div id="' + slidesWrapperId + '"></div>').appendTo(options.slidesWrapperSelector);

        var $controllersSelector = jQuery(options.controllersSelector);
        var $activeControllerSelector = $controllersSelector.eq(currentIndex);

        $controllersSelector.removeClass(options.selectedClass);
        $activeControllerSelector.addClass(options.selectedClass);

        $controllersSelector.each(function() {
          var $this = jQuery(this);
          $this.attr('title', $this.attr('inactiveTitle'));
        });
        $activeControllerSelector.attr('title', $activeControllerSelector.attr('activeTitle'));

        resize();
      };
      initialise();


      // reinitialise
      return {
        reinitialise: function(modifiedOptions) {
          options = jQuery.extend({}, options, modifiedOptions);
          slideCount = jQuery(options.controllersSelector).length;

          controller();
          resize();
          return this;
        },
        add: function(slideName, processMarkup, data) {
          add(slideName, processMarkup, data);
          return this;
        },
        enableAdd: function() {
          enableAdd();
          return this;
        },
        disableAdd: function() {
          disableAdd();
          return this;
        },
        remove: function(slideName, processMarkup, data) {
          remove(slideName, processMarkup, data);
          return this;
        },
        enableRemove: function() {
          enableRemove();
          return this;
        },
        disableRemove: function() {
          disableRemove();
          return this;
        }
      }
    };

    // apply flow
    var flowApi = this.data('xenosFlow');
    if (flowApi) {
      flowApi.reinitialise(options);
    } else {
      flowApi = JxenosFlow(this, options);
      this.data('xenosFlow', flowApi);
    }
    return flowApi;
  }

})(jQuery);