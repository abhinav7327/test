//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
(function($){
  var excelColumnPicker = function() {
    var self = this;
    this.$excelColumnPicker;
    /*
     * dirtyState depends on the modCnt and dragState. The state of $excelColumnPicker is dirty either modCnt is not zero 
     * or dragState is true.
    */
    this.dirtyState ;
    this.modCnt;
    this.dragState;
    this.xlsColPkr = {};
    this.options = {
        fadeSpeed: 250 
    };
    this.updateSaveAction = function() {
      self.dirtyState = self.modCnt !== 0 || self.dragState; //state is darty only if monCnt not zero
      $('#excelPrefSave').prop('disabled', !self.dirtyState);
      $('#excelPrefReset').prop('disabled', !self.dirtyState);
      if (self.dirtyState || jQuery('.slick-columnpicker').data("isDirty")) {
        jQuery('#content').saverOn(self.saver);
      } else {
        jQuery('#content').saverOff();
      }
    };
    this.saver = function ( confirm ) {
      if ( !confirm ) return;
      self.saveHandler({
        stopPropagation: function() {//no-op
        },
        preventDefault: function() {//no-op
        }
      });
    };
    this.checkboxChangeHandler = function ( e ) {
      if (self.$excelColumnPicker.find(":checkbox:checked").length == 0) {
        $(e.target).attr("checked","checked");
        return;
      }
      var $chkbox = $(this);
      //XOR the checked state and initial visible state...
      self.modCnt += ($chkbox.data('initialState').visible ^ $chkbox.is(':checked')) === 1 ? 1 : -1;
      self.updateSaveAction();
    };
    
    this.resetHandler = function( e ) {
      //e.stopPropagation();
      e.preventDefault();
      jConfirm(xenos.i18n.message.excel_preference_reset_confirm, null, function(confirmation) {
        if(confirmation){
          var requestUrl = xenos.context.path + "/secure/ref/personalized/excelPref/clear.json?commandFormId=" + $('[name=commandFormId]').val(); 
          xenos$excelColumnPicker$RequestHandler.generic(e, {	
              requestUri: requestUrl,
              settings: {data : JSON.stringify({})},
              onJsonContent :  function(e, options, $target, content) {
                if ( content.modelMap.success === true ){
                  self.resetStates();
                  self.updateSaveAction();
                  xenos.postNotice(xenos.notice.type.success, xenos.i18n.message.excel_preference_reset_message);
                } else {
                  xenos.postNotice(xenos.notice.type.error, xenos.i18n.message.excel_preference_reset_error);
                }
              }
          });
        }
        return confirmation;
      });
      
    };
    
    this.saveHandler = function( e ) {
      e.stopPropagation();
      e.preventDefault();
      var updatedColumns = [];
      var cols = $('input[type="checkbox"]', self.$excelColumnPicker);
      var columns = self.$excelColumnPicker.data('columns');
      for( var i=0; i< cols.length; i++ ) {
        updatedColumns[i] = $.extend({}, $(cols[i]).data('initialState'));
        updatedColumns[i].order = i;
        updatedColumns[i].visible = $(cols[i]).is(':checked');
      }
      var requestUrl = xenos.context.path + "/secure/ref/personalized/excelPref/save.json?commandFormId=" + $('[name=commandFormId]').val(); 
      xenos$excelColumnPicker$RequestHandler.generic(e, {	
          requestUri: requestUrl,
          settings: {data : JSON.stringify(updatedColumns)},
          onJsonContent :  function(e, options, $target, content) {
            if ( content.modelMap.success === true ) {
              self.resetStates();
              self.updateSaveAction();
              self.$excelColumnPicker.fadeOut(self.options.fadeSpeed);
              xenos.postNotice(xenos.notice.type.success, xenos.i18n.message.excel_preference_save_message);
            } else {
              xenos.postNotice(xenos.notice.type.error, xenos.i18n.message.excel_preference_save_error);
            }
          }
      });
    };
    
    this.resetPrefHandler = function ( e ) {
      e.stopPropagation();
      e.preventDefault();
      self.prepareContextMenu(self.$excelColumnPicker.data('columns'));
      self.updateSaveAction();
      self.displayContextMenu();
      self.modCnt = 0;
      self.dragState = false;
      self.updateSaveAction();
    };
    
    this.dragHandler = function( event, ui ) {
      var cols = $('input[type="checkbox"]', $(this));
      var columns = self.$excelColumnPicker.data('columns');
      self.dragState = false; //considering nothing has been dragged...  
      for(var i = 0; i< cols.length && !self.dragState; i++) {
        self.dragState = self.dragState || columns[i].order !== $(cols[i]).data('initialState').order;
      }
      self.updateSaveAction();
    };
    
    this.htmlClickHandler = function ( e ) {
      if ( $(e.target).closest('.slick-excelcolumnpicker').size() > 0 ) {
        return;
      } else {
        self.$excelColumnPicker.fadeOut(self.options.fadeSpeed);
      }
    };
    
    this.displayContextMenu = function() {
      self.xlsColPkr.contentHeight = self.$excelColumnPicker.height();
      self.xlsColPkr.btn = $('.xlsColumnPicker');
      self.xlsColPkr.top = self.xlsColPkr.btn.offset().top + self.xlsColPkr.btn.height() + 2;
      self.xlsColPkr.left = self.xlsColPkr.btn.offset().left - self.$excelColumnPicker.width() + 7;
      self.xlsColPkr.maxHeight = $('#footer').offset().top - self.xlsColPkr.btn.offset().top - self.xlsColPkr.btn.height() - 3;
      self.xlsColPkr.needScroll = self.xlsColPkr.contentHeight + 7 > self.xlsColPkr.maxHeight;
      self.xlsColPkr.height = self.xlsColPkr.contentHeight;
      self.xlsColPkr.api = self.$excelColumnPicker.data('jsp');
      if (self.xlsColPkr.needScroll) {
        self.xlsColPkr.height = self.xlsColPkr.maxHeight;
      } else if (self.xlsColPkr.api) {
        self.xlsColPkr.height += 11;
      }
      self.$excelColumnPicker
              .css('top', self.xlsColPkr.top)
              .css("left", self.xlsColPkr.left)
              .css('height', self.xlsColPkr.height)
              .fadeIn(self.options.fadeSpeed);
              
      if (self.xlsColPkr.api) {
        self.xlsColPkr.api.reinitialise();
      } else if (self.xlsColPkr.needScroll) {
        self.$excelColumnPicker.jScrollPane({showArrows:true});
      }
    };
    this.prepareContextMenu = function(columns) {
      var $li, $input, $liWrapper, $sortContainer;
      var columns;
      $sortContainer = self.$excelColumnPicker;
      if (self.$excelColumnPicker.find('.jspPane').size() != 0) {
        self.$excelColumnPicker.find('.jspPane').empty();
        $sortContainer = self.$excelColumnPicker.find('.jspPane');
      } else {
        self.$excelColumnPicker.empty();
      }
      self.$excelColumnPicker.data('columns', columns);
      $liWrapper = $('<div class="column-picker-li-wrapper"/>');
      //we need a sequential processing, otherwise we could have used $.each(...)
      for ( var i = 0; i < columns.length; i++ ) {
        $li = $('<li />').appendTo($liWrapper); //we will populate $li later
        $input = $('<input type="checkbox" />')
          .attr('id', 'excelcolumnpicker_' + i)
          .attr('columnId', columns[i].order)
          .data('initialState', columns[i]) //initial state
          .appendTo($li); //populating $li
        
        $input.prop("checked", columns[i].visible);
        $input.on('change', self.checkboxChangeHandler);
        $('<label for="columnpicker_' + i + '" />')
          .html(columns[i].headerText)
          .appendTo($li);
      }
      $liWrapper.appendTo($sortContainer);
      $('<div class="hrBorder"></div>').appendTo($sortContainer);
      var $save = $('<div class="btnWrapStyle saveBtn savePref"><input class="inputBtnStyle" type="button" value="Save" id="excelPrefSave"/></div>');
      var $reset = $('<div class="btnWrapStyle resetBtn resetPref"><input class="inputBtnStyle" type="reset" value="Reset" id="excelPrefReset"/></div>');
      $save.appendTo($sortContainer);
      $reset.appendTo($sortContainer);
      $('input[type="button"]', $save).off('click', self.saveHandler);
      $('input[type="button"]', $save).on('click', self.saveHandler);
      $('input[type="reset"]', $reset).off('click', self.resetPrefHandler);
      $('input[type="reset"]', $reset).on('click', self.resetPrefHandler);
      $liWrapper.sortable({
        stop: self.dragHandler,
        containment: "parent",
        tolerance: "pointer"
      });

    };
    this.handleExcelContextMenu = function( e ) {
      e.stopPropagation();
      e.preventDefault();
      //if excel column picker already visible, then hide the same. This will happen when excel column picker is clicked and excel column picker container is already open   
      if ( self.$excelColumnPicker.is(':visible') ) {
        self.$excelColumnPicker.fadeOut(self.options.fadeSpeed);
        return;
      }
      if ($('.slick-excelcolumnpicker:visible').size() > 0 ) {
        $('.slick-excelcolumnpicker').fadeOut(self.options.fadeSpeed);
      }
      //if state is darty, then we will not fetch data from server, rather we will display current state...
      if ( self.dirtyState ) {
        self.displayContextMenu();
        return;
      }
      //we need to fetch the columns from server, hence make a server call for data
      var form = $('#queryResultForm');
      var requestUrl = xenos.context.path + "/secure/ref/personalized/excelPref.json?commandFormId=" + $('[name=commandFormId]').val(); 
      xenos$excelColumnPicker$RequestHandler.generic(e, {	
          requestUri: requestUrl,
          settings: {data : {}},
          onJsonContent :  function(e, options, $target, content) {
            if ( content.modelMap && content.modelMap.success === true ) {
              columns = content.modelMap.value;
              self.prepareContextMenu(columns);
              self.updateSaveAction();
              self.displayContextMenu();
            } else {
              xenos.postNotice(xenos.notice.type.error, xenos.i18n.message.excel_preference_retrieve_error);
            }
          }
       });
    };
    
    var xenos$excelColumnPicker$RequestHandler = xenos$Handler$function({
      get: {
        contentType: 'json',
        requestType: xenos$Handler$default.requestType.asynchronous
      },	
      settings: {
          beforeSend: function(request) {
            request.setRequestHeader('Accept', 'application/json');
            request.setRequestHeader('Content-type', 'application/json');
        },
          type: 'POST'
      }
    });
    
    this.resetStates = function() {
      self.dirtyState = false;
      self.modCnt = 0;
      self.dragState = false;
    };
    
    this.init = function() {
      self.resetStates();
      $(".pagerWrap .xlsColumnPicker").on('click', self.handleExcelContextMenu);
      $(".pagerWrap .resetXlsReportPref").on('click', self.resetHandler);
      $('html').on('click', self.htmlClickHandler);
      self.$excelColumnPicker = $("<ul class='slick-excelcolumnpicker' style='display:none;position:absolute;z-index:100000;' />").appendTo(document.body);
    };
    
    this.destroy= function() {
       $(".pagerWrap .xlsColumnPicker").off('click', self.handleExcelContextMenu);
       $(".pagerWrap .resetXlsReportPref").off('click', self.resetHandler);
       $('html').off('click', self.htmlClickHandler);
       jQuery('#content').saverOff();
       self.$excelColumnPicker.remove();
    };
    
    this.hideIfVisible = function() {
      if (self.$excelColumnPicker) {
        self.$excelColumnPicker.fadeOut(self.options.fadeSpeed);
      }
    };
  };
  var $excelColumnPicker = undefined;
	$xenos$excelColumnPicker$init = function() {
    if ( !$excelColumnPicker )
      $excelColumnPicker = new excelColumnPicker();
    $excelColumnPicker.init();
	};
  $xenos$excelColumnPicker$destroy = function() {
    $excelColumnPicker.destroy();
  };
  
  $xenos$excelColumnPicker$hideIfVisible = function() {
    $excelColumnPicker.hideIfVisible();
  };
})(jQuery);