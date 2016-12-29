//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
/**
*
* @param options (Object) Javascript object containing options that can be passed into the treeview control. Following
* are the available attributes for the options object.
*
*<ol>
* <li>- contentName (String)  Name of the content to be loaded from DOM cache into the tree </li>
* <li>- type (String) Type of tree view - Instrument tree, market tree, etc.</li>
* <li>- isPopUp (Boolean) Whether the treeview is to be rendered on a popup. Default false.</li>
* <li>- showReset (Boolean) Whether the reset icon is to be displayed beside the tree control. Default true.</li>
* <li>- showCheckbox (Boolean) Whether the reset icon is to be displayed beside the tree control. Default true.</li>
* <li>- showTitle (Boolean) Whether the title is to be displayed on top of the treeview. Default false.</li>
* <li>- width (String) Width of the tree control. Default 220px.</li>
* <li>- height (String) Height of the tree control. Default 150px.</li>
* <li>- collapseOnReset (Boolean) Whether the tree view will collapse on clicking the reset icon. Default true.</li>
* <li>- typeahead (Object) Contains typeahead related option like typeahead interval. Default interval is 1000ms.</li>
* </ol>
*
* @return jQuery selector object
*
**/
$.fn.treeview2 = function(options) {

  // var _cache = $('div#footer>div#xenos-cache-container>span#cache'); // Get the cache data
  var _self = this;
  var _cacheContentName = options.contentName; // Get the content name to load from cache
  var _treeContent = xenos$Cache.get(_cacheContentName) || []; // Get the actual data from cache based on the cacheContentName above
  var _type = options.type; // Get the type of tree (Instrument Tree, Market Tree, etc.)
  var _isPopUp = options.isPopUp || false; // Check if the tree is to be rendered on a popup.
  var _showReset = options.showReset || true; // Show reset icon
  var _showCheckbox = options.showCheckbox || false; // Show the checkbox icon beside each node
  var _showTitle = options.showTitle || false; // Show the tree header title
  var _width = options.width || '220px'; // If not specified width fixed to prevent horizontal scroll
  var _height = options.height || '150px';
  var _collapseOnReset = options.collapseOnReset || true; // Collapse entire tree once reset icon is clicked
  var _treeViewdiv = false;
  var _treeViewContentDiv = false;
  var _treeControlResetDiv = false;
  var _treeControlInitDiv = false;
  var _tree = false;
  var _previousValue = false;
  var _previousSelectionExists = false;
  var _treeInitialized = false;
  var _regexp_special_chars = new RegExp('[.\\\\+*?\\[\\^\\]$(){}=!<>|:]', 'g');
  var _isFiltered = false;
  var _typeaheadTimer = false;
  var _typeaheadInterval = (options.typeahead && options.typeahead.interval) ? options.typeahead.interval : 500; // Typeahead interval in ms


  /**
  * Function to process the tree data and set 2 new attributes
  * namely, title and key from text and value respectively.
  * Recursively called throughout the entire tree data.
  **/
  var processContent = function(data) {
    for (var i = 0; i < data.length; i++) {
      var obj = data[i];
      obj.title = obj.text;
      obj.key = obj.value;
      if(!obj.leaf && obj.children && obj.children.length > 0) {
        processContent(obj.children);
      }
    }
    return data;
  };

  /**
  * Function to get the tree view configuration
  **/
  var getTreeConfig = function() {
    var processedContent = processContent(_treeContent);
    var config = {
      selectMode: 1,
      checkbox: _showCheckbox,
      autoScroll: true,
      keyboard: true,
      scrollParent: _treeViewContentDiv,
      source: processedContent,
      select: selectionHandler,
      click: treeViewClickHandler,
      dblclick: treeViewDblClickHandler,
      keydown: treeControlKeyDownHandler
    };
    return config;
  };

  /**
  * Function to initialize the tree view via jquery fancy tree plugin
  **/
  var initializeTree = function() {
    if(_treeViewContentDiv) {
      var fancyTreeConfig = getTreeConfig(); // Create the fancytree configuration object
      _tree = _treeViewContentDiv.fancytree(fancyTreeConfig); // Initilaize the tree
    }
  };

  /**
  * Function to append the tree view content wrapper div to the tree view
  * content div. This function in turn calls the tree view initialization.
  **/
  var appendTreeViewContent = function() {
    var contentWrapper = '<div id="contentWrapper"><div id="treeViewContent"></div></div>';
    jQuery('#treeViewContent', contentWrapper).css({'height': _height, 'width': _width, 'overflow-y': 'scroll', 'overflow-x': 'hidden'}).appendTo(_treeViewdiv);

    _treeViewContentDiv = $('#treeViewContent');
    initializeTree(); // Initilaize the tree
  };

  /**
  * Function to append the tree view header to the tree view div.
  * It is option driven and calls the tree view content append function in
  * its turn.
  **/
  var appendTreeViewHeader = function() {
    if(_showTitle) {
      var headerwrapper  = '<div id="headerwrapper"><div id="treeViewHeader">' + _type.toUpperCase() + '</div></div>';
      var headerCssJson = {
        'text-align': 'center',
        'font-weight': 'bold',
        'color': 'white',
        'border-bottom': '1px solid white',
        'padding': '3px'
      };
      $(headerwrapper).css(headerCssJson).appendTo(_treeViewdiv);
    }

    appendTreeViewContent(); // Append content with wrapper
  };

  /**
  * Function to create the tree view div and append the same to
  * the text box. the rest of the tree view is created within this div.
  **/
  var createIfNotExists = function() {
    if($('div #treeviewdiv').length == 0) {
      _self.after('<div id="treeviewdiv" viewtype='+ _self.attr('id') +' style="position:absolute;"/>');

      var styleJson = {};
      if(_isPopUp) {
        styleJson = {
          'left': _self.closest('label').width(),
          'top':_self.closest('label').height()
        };
      } else {
        styleJson = {
          'left': _self.parent().prev('label').width() + 1 +'px',
          'top': _self.parent().parent().height() - 2 +'px'
        };
      }
      styleJson.width = _width; // Assign tree control's width

      _treeViewdiv = $('#treeviewdiv');
      _treeViewdiv.css(styleJson).show().animate({height: _height}, 500, postInitialize);

      appendTreeViewHeader(); // Append header with wrapper
    }
  };

  /**
  * Post initialization function for the tree view that check if any previous
  * value exists in the tree view text box. If yes, then the tree view is scrolled
  * to the existing value and if not then the tree view text box is focused.
  **/
  var postInitialize = function() {
    _treeInitialized = true;
    _previousValue = _self.attr('value') || false; // Check for previously selected values
    _previousSelectionExists = _previousValue && _previousValue.length > 0;
    if(_previousSelectionExists) {
      if(_treeViewContentDiv) {
        _treeViewContentDiv.fancytree('getTree').activateKey(_previousValue);
        var node = _treeViewContentDiv.fancytree("getActiveNode");
        if(node) {
          node.makeVisible({scrollIntoView: true});
        }
      }
    }

    $('body').on('click', treeViewFocusOutHandler);
  };

  /**
  * Remove any existing tree of the same type
  **/
  var removeIfCreated = function() {
    if($('div #treeviewdiv').length > 0) {
      if(_self.attr('id') != $('div #treeviewdiv').attr('viewtype')){
        $('#treeviewdiv').remove();
      }
    }
  };

  /**
  * Entry function for creation of tree view on the tree control. This function
  * creates a nested call to other functions in the following order :-
  * |_ removeIfCreated()
  * |_ createIfNotExists()
  *   |_ appendTreeViewHeader()
  *     |_ appendTreeViewContent()
  *       |_ initializeTree()
  *       |_ postInitialize()
  **/
  var appendTreeViewContainer = function() {
    removeIfCreated(); // Remove if already created
    createIfNotExists(); // Create if not exists
  };

  /**
  * Click handler for the reset icon beside the tree view text box
  **/
  var resetHandler = function() {
    _self.attr('value', '');

    if(_isFiltered) {
      _isFiltered = false;
    }

    if (_typeaheadTimer) {
      clearTimeout(_typeaheadTimer); // Clear if already set
    }

    if(_collapseOnReset && _treeViewContentDiv) {
      var rootNode = _treeViewContentDiv.fancytree('getRootNode') || false;
      if(rootNode.visit && (typeof rootNode.visit === 'function')){
        _treeViewContentDiv.fancytree('getRootNode').visit(function(node) {
          node.setExpanded(false);
        });
      }
      
      var tree = _treeViewContentDiv.fancytree('getTree') || false;
      if(tree.setFocus && (typeof tree.setFocus === 'function')){
        _treeViewContentDiv.fancytree('getTree').setFocus(true);
      }
    }
    $('body').unbind('click', treeViewFocusOutHandler);
  };

  /**
  * Function the append the reset value icon beside the tree view text box.
  **/
  var appendResetControl = function() {
    var resetControl = '<div class="treeResetBtn"><input type="button" class="treeResetBtnIco" /></div>';
    var ctx = !_isPopUp ? _self.closest('.formItem') : _self.closest('.popFormItem');
    _treeControlResetDiv = $(resetControl);
    _treeControlResetDiv.off('click');
    _treeControlResetDiv.on('click', resetHandler);

    if($('.treeResetBtn', ctx).length > 0) { // Remove existing rest button
      $('.treeResetBtn', ctx).remove();
    }

    if(!_isPopUp) {
      _treeControlResetDiv.insertBefore($(ctx).children().last());
    } else {
      _treeControlResetDiv.appendTo(ctx);
    }
  };

  /**
  * Function to append the dropdown icon deside the tree view text box
  **/
  var appendDropdownIcon = function() {
    var dropdownCtrl = '<div class="treeInitBtn"><input type="button" class="treeInitBtnIco" /></div>';
    var ctx = !_isPopUp ? _self.closest('.formItem') : _self.closest('.popFormItem');
    _treeControlInitDiv = $(dropdownCtrl);
    _treeControlInitDiv.click(appendTreeViewContainer);

    if($('.treeInitBtn', ctx).length > 0) { // Remove existing rest button
      $('.treeInitBtn', ctx).remove();
    }

    if(!_isPopUp) {
      _treeControlInitDiv.insertBefore($(ctx).children().last());
    } else {
      _treeControlInitDiv.appendTo(ctx);
    }

  };

  /**
  * Function to select a value from the tree view and the set the same value
  * in the tree view text box.
  **/
  var selectionHandler = function(event, data) {
    if(event.target && !$(event.target).hasClass('fancytree-expander')) {
      if(data && data.node) {
        var selectedValue = data.node.data.value;
        _self.attr('value', selectedValue); // Assign selected value
        removeTreeView();
      }
    }
  };

  /**
  * Function to remove the tree view from the DOM along with all it's event
  * bindings. It also resets the required variables to their initial state
  **/
  var removeTreeView = function() {
    if(_treeViewdiv) {
      _treeViewdiv.remove();
    }
    _treeViewdiv = false;
    _treeViewContentDiv = false;
    _parentNode = false;
    _treeInitialized = false;
    _keyBoardInit = false;
    $(_self).trigger('xenos-treeview.FocusOut');
    $(_self).trigger('focus', {focusOnControl: true});
    $('body').unbind('click', treeViewFocusOutHandler);
  };

  /**
  * Click handler for the tree view. The function in its turn invokes the
  * selection handler. This function is passed as tree view configuration options.
  **/
  var treeViewClickHandler = function(event, data) {
     _treeViewContentDiv.fancytree('getTree').setFocus(true);
    selectionHandler(event, data);
  };

  /**
  * Double click handler for the tree view. The function in its turn invokes the
  * selection handler. This function is passed as tree view configuration options.
  **/
  var treeViewDblClickHandler = function(event, data) {
     _treeViewContentDiv.fancytree('getTree').setFocus(true);
    selectionHandler(event, data);
  };

  /**
  * Key down handler for the tree view. The function detects the keycode and if
  * enter is pressed, it signifies user selection and selection handler is invoked.
  **/
  var treeViewKeyDownHandler = function(event, data) {
    if(_treeInitialized) {
      if(!_treeViewContentDiv.fancytree('getTree').hasFocus()){
        _treeViewContentDiv.fancytree('getTree').setFocus(true);
      }
    }
    var keyCode = event.which || event.keyCode;
    if(keyCode == 13) {
      event.stopPropagation();
      event.preventDefault();
      selectionHandler(event, data);
    }
  };

  /**
  * Focus out event handler for the tree view. The function checks if the focus
  * out event has been made in the tree view text box. If not, then it is
  * checked if the focus out is caused due to click on the tree itself, if not
  * then the tree view removed along with all it's bindings.
  **/
  var treeViewFocusOutHandler = function(event) {
    var targetElm = event.target || event.relatedTarget;
    if(targetElm && !$(targetElm).hasClass('treeViewControl')) {
      var isTreeViewClick = $(targetElm).closest('.fancytree-container').length > 0;
      if(!isTreeViewClick && _treeInitialized) {
        removeTreeView();
      }
    }
  };

  /**
  * Focus In event handler for the tree view text box. The function checks if any
  * previous value is present in the tree view control, if present and the tree
  * is not initialized, then initiates the tree view.
  **/
  var treeControlFocusInHandler = function(event, data) {    
    var evData = false;
    if(data){
      evData = data;
    }
    
    if(evData && evData.focusOnControl){
      // Let the focus event continue propagation
    } else {
      var keyCode = false;
      if(event.which || event.keyCode) {
        keyCode = event.which || event.keyCode;
      }
      
      if(!_treeInitialized) {
        _previousValue = _self.attr('value') || false; // Check for previously selected values
        _previousSelectionExists = _previousValue && _previousValue.length > 0;

        if(_previousSelectionExists) {
          if(!_self.hasClass('treeViewControl')) {
            _self.addClass('treeViewControl');
          }
          if(keyCode && keyCode == 40){
            appendTreeViewContainer(); // Create the container for header and content
          }
        } else if(keyCode && (keyCode != 13 || keyCode == 40)) {
          appendTreeViewContainer(); // Create the container for header and content
        }

      } else {
        
        if(keyCode == 40) {
      
          var tree = _treeViewContentDiv.fancytree('getTree') || false;
          if(_treeViewContentDiv && tree) {
            var node = false;

            if(_previousSelectionExists) {
              if(tree){
                if(tree.activateKey && typeof tree.activateKey === 'function'){
                  _treeViewContentDiv.fancytree('getTree').activateKey(_previousValue);
                  node = _treeViewContentDiv.fancytree("getActiveNode");
                }
              }
              
            } else {
              if(tree){
                if(tree.getFirstChild && typeof tree.getFirstChild === 'function'){
                  node = _treeViewContentDiv.fancytree("getTree").getFirstChild();
                }
              }
            }

            if(node) {
              node.makeVisible({scrollIntoView: _previousSelectionExists});
              node.setFocus(_previousSelectionExists);
            }
          }
          
          
          

        }
      }
    }
  };

  /**
  * Focus out event handler for the tree view text box. The function checks if the
  * tree is open and closes it
  **/
  var treeControlFocusOutHandler = function(event) {
    var targetElm = event.target || event.relatedTarget;
    var originElm = (event.originalEvent && event.originalEvent.relatedTarget) ? event.originalEvent.relatedTarget : document.activeElement;
    var parent = $(targetElm).parent();
    var isTreeViewOpen = $(parent).find('.fancytree-container').length > 0;
    var tree = _treeViewContentDiv && _treeViewContentDiv.fancytree('getTree') ? _treeViewContentDiv.fancytree('getTree') : false;
    var isTreeViewFocus = false;
    if(tree){
      if(tree.hasFocus && typeof tree.hasFocus === 'function'){
        isTreeViewFocus = _treeViewContentDiv && _treeViewContentDiv.fancytree('getTree') ? _treeViewContentDiv.fancytree('getTree').hasFocus() : _treeInitialized;
      }
    }
    var isTreeViewClick = false;

    if(originElm) {
      isTreeViewClick = $(originElm).closest('.fancytree-container').length > 0;
    }

    if($(targetElm).hasClass('treeViewControl') && isTreeViewOpen && !isTreeViewFocus && !isTreeViewClick) {
      removeTreeView();
    }
  };

  /**
  * Keyup event handler for the tree view text box. The function clears any timer
  * created due to any previous typeahead function and re-initializes the timer
  * via setTimeout for the typeahead function with typeahead interval as timeout
  * value.
  **/
  var treeControlKeyUpHandler = function(event) {
    var keyCode = event.which || event.keyCode;
    
    if(keyCode == 9){
      return;
    }
    
    if (_typeaheadTimer) {
      clearTimeout(_typeaheadTimer); // Clear if already set
    }
    _typeaheadTimer = setTimeout(typeaheadFn, _typeaheadInterval); // Invoke typeahead after the set time interval
  };

  /**
  * Keydown event handler for the tree view text box. The function clears any timer
  * created due to typeahead functionality. If enter key is pressed and tree view is open
  * it signifies user selection.
  **/
  var treeControlKeyDownHandler = function(event, data) {
    clearTimeout(_typeaheadTimer);
    var keyCode = event.which || event.keyCode;
    
    if(keyCode == 9){
      var isTreeViewOpen = $($(_self).parent()).find('.fancytree-container').length > 0;
      if(isTreeViewOpen){
        event.stopPropagation();
        event.preventDefault();
        return false;
      } else {
        return;
      }
    }

    // If tree is not created, create it
    if(!_treeInitialized && keyCode != 13) {
      if(!_self.hasClass('treeViewControl')) {
        _self.addClass('treeViewControl');
      }
      appendTreeViewContainer();
    }

    // if(keyCode == 13 || keyCode == 9) { // Enter and tab
    if(keyCode == 13) { // Enter
      var isTreeViewOpen = $($(_self).parent()).find('.fancytree-container').length > 0;
      
      if(isTreeViewOpen) {
        event.stopPropagation();
        event.preventDefault();
        selectionHandler(event, data);
      }
     
    } else if(keyCode == 40) { // Down arrow
      var tree = _treeViewContentDiv.fancytree('getTree') || false;  
      if(_treeViewContentDiv && _tree) {
        var node = false;

        if(_previousSelectionExists) {
          if(tree){
            if(tree.activateKey && (typeof tree.activateKey === 'function')){
              _treeViewContentDiv.fancytree('getTree').activateKey(_previousValue);
              node = _treeViewContentDiv.fancytree("getActiveNode");
            }
          }
        } else {
          if(tree){
            if(tree.getFirstChild && (typeof tree.getFirstChild === 'function')){
              node = _treeViewContentDiv.fancytree("getTree").getFirstChild();
            }
          }
        }

        if(node) {
          node.makeVisible({scrollIntoView: true});
          if(!_previousSelectionExists) {
            node.setFocus(true);
          }
        }
      }

    } else if(keyCode == 27) { // Escape

      if(_treeInitialized) {
        var isTreeViewOpen = $($(_self).parent()).find('.fancytree-container').length > 0;
        if($(_self).hasClass('treeViewControl') && isTreeViewOpen) {
          removeTreeView();
        }
      }

    }
  };

  /**
  * Function to search for tree node based on user typed content. The function
  * creates dynamic regex from user input and calls a recursive search function
  * to search for matching nodes. If a matching node is found the tree automatically
  * scrolls to the node and expands any parent nodes if required.
  **/
  var typeaheadFn = function() {
    var value = $.trim(_self.attr('value'));

    if(value.length > 0 && !_isFiltered) {
      /*
      var regEx = new RegExp('^'+regexp_escape(value),'i');
      var searchResult = searchTree(regEx, _treeContent);
      if(searchResult && searchResult.text) {
        if(_treeViewContentDiv) {
          _treeViewContentDiv.fancytree('getTree').activateKey(searchResult.text);
          var node = _treeViewContentDiv.fancytree("getActiveNode");
          if(node) {
            node.makeVisible({scrollIntoView: true});
          }
        }
        _self.focus();
      }
      */
      if(_treeViewContentDiv) {
        var tree = _treeViewContentDiv.fancytree("getTree") || false;
        if(tree){
          if(tree.findFirst && typeof tree.findFirst === 'function'){
            var node = _treeViewContentDiv.fancytree("getTree").findFirst(value) || false;
            if(node) {
              node.makeVisible({scrollIntoView: true});
              node.setFocus(true);
            }
          }
        }
      }
      _isFiltered = true;
    } else {
      _isFiltered = false;
      if(_treeViewContentDiv){
        var rootNode = _treeViewContentDiv.fancytree('getRootNode') || false;
        if(rootNode.visit && (typeof rootNode.visit === 'function')){
          _treeViewContentDiv.fancytree("getRootNode").visit(function(node) {
            node.setExpanded(false);
          });
        }
      }
    }
  };

  /**
  * Search the entire tree content recursively for the typed data
  * and return the search result if found or false otherwise.
  **/
  /*
  var searchTree = function(regex, data) {
    var retVal = false;
    var matchResult = false;

    for (var i = 0; i < data.length; i++) {
      var obj = data[i];
      matchResult = obj.text.match(regex);

      if(matchResult && matchResult[0].length > 0) {
        retVal = obj;
        if(retVal) {
          break;
        }
      } else {
        if(!obj.leaf && obj.children && obj.children.length > 0) {
          retVal = searchTree(regex, obj.children);
          if(retVal) {
            break;
          }
        }
      }
    }

    return retVal;
  };
  */

  /**
  * Create a dynamic regex expression to match the tree leaf title
  * based on what has been typed in the tree view control
  **/
  /*
  var regexp_escape = function(value) {
    return value.replace(_regexp_special_chars, '\\$&');
  };
  */

  appendDropdownIcon();

  // Show the reset icon permanently
  if(_showReset) {
    appendResetControl();
  }


  /**
  * Bind events to the tree view control element and return
  **/
  return _self.on('focus', treeControlFocusInHandler)
  .on('blur', treeControlFocusOutHandler)
  .on('keyup', treeControlKeyUpHandler)
  .on('keydown', treeControlKeyDownHandler);
};
