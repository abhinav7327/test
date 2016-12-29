//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
//
// xenos
//  - Menu
//


// apply superfish
jQuery('ul.sf-menu').superfish({
    autoArrows: false,
    dropShadows: false,
	delay		: 400,
	speed		: 1,
	disableHI	: true,
    /*
    * Below callbacks onBeforeShow and onHide were introduced to render menu on top of any dialogue/notification DOM.
    * onBeforeShow: Sets the menu's z-index based on highest z-index visible in the DOM.
    * onHide: Resets the menu's z-index to default so that it doesn't shows on top of dialogue overlay.
    * */
         onBeforeShow: function () {
        //Setting Class for the Topmost Dialogue
        setTopMost();
        var maxZ = xenos.utils.getMaxZ();
        if (maxZ) {
            //Resetting z-index to (highest z-index visible in DOM + 1)
            $('#xenosMenuContainer,#personalise').css('zIndex', maxZ + 1);
        }
    },
    onHide: function () {
        //This condition is to prevent resetting menu z-index when the following actions take place:
        //1. User hovers on the menu item using mouse, to open the menu list.
        //2. User using keyboard shortcut to open the menu list.
        if ($($(this).context).hasClass('sfHover') || $($(this).context).hasClass('sf-menu')) {
            return;
        }
        //This condition is to check whether the hide callbak is for the top level menu and not the child level menu.
        if ($($(this).parent()[0]).parent().hasClass('sf-menu')) {
            //Resetting z-index to it's default.
            $('#xenosMenuContainer,#personalise').css('zIndex', 1000);
        }
    }
});

jQuery('ul.sf-menu li ul').each(function() {
  jQuery(this).find('li:last-child').children('a:first-child').addClass('borderLast');
});
// end


// few utilities
function applyHoverHandler(jObject) {
  var probableUl = jObject.children().last();
  if (probableUl.is('ul')) {
    var ul = probableUl;
    jObject.hover(
      function() {
        ul.css('display', 'block');
      },
      function() {
        ul.css('display', 'none');
      }
    );

    ul.children().each(function() {
      if (jQuery(this).children().last().is('ul')) applyHoverHandler(jQuery(this));
    });
  }
}

function findSuperUl(jObject, superClass) {
  if (jObject.length > 0) {
    var probableSuperUl = jObject.parent();
    if (probableSuperUl.parent().parent().hasClass(superClass)) {
      return probableSuperUl;
    } else {
      return findSuperUl(probableSuperUl, superClass);
    }
  }
}
// end


// legacy should open in ie only
function openLegacy() {
  if (jQuery.browser.msie) {
    jQuery('.sf-menu a[href*=".action"]').colorbox({iframe: true, title: xenos.i18n.title.legacy, width: "98%", height: "98%",
		onComplete:function(){
			 $('#cboxLoadingGraphic,#cboxLoadingOverlay').remove();
		}
	});
  } else {
    jQuery('.sf-menu a[href*=".action"]').click(function(e) {
      e.preventDefault();
      findSuperUl(jQuery(this).parent(), 'sf-menu').css('display', 'none');

      // inform
      jAlert(xenos.i18n.message.window_not_supported, null);
    });
  }
}
//xenos.waitFor({target: xenos, state: 'i18n', callback: openLegacy});
// end

// asynchronous handler
var xenos$Handler$asynchronous = xenos$Handler$function({
  get: {
    requestType: xenos$Handler$default.requestType.asynchronous,
    target: '#content'
  },
  settings: {
    beforeSend: function(request) {
      request.setRequestHeader('Accept', 'text/html;type=ajax');
    },
    data: {fragments: 'content'}
  },
  callback: {
    success : function(evt, options){
		if(options){
			setMenuInCache(options.menuPk);
			$.each(options['gridInstance'] || [], function (ind, grid) {
				grid.destroy();
				delete grid;
			});
		}
	}
  }
});

var cachedPref = false;
xenos$Event.on('xenos-preferences-synced', function(e, data){
  cachedPref = xenos$Cache.get(data.key);
});

function refreshCache(cacheArg){
  cacheArg = cachedPref;
  return cacheArg;
}

jQuery('.sf-menu a').filter(function(index) {
  var href = jQuery(this).attr('href');
  return href != '#'
      && href.indexOf('.action') == -1
      && href.indexOf('secure/ref/personalized/user/globalconfig/load') == -1
      && href.indexOf('resources/j_spring_security_logout') == -1
	  && href.indexOf('personalization/export/own') == -1
  	  && href.indexOf('changePassword/initPopup') == -1;
}).click(function(e) {
  e.preventDefault();
  var cached = false;
  var $this = jQuery(this);
  var menuPk = $this.parent().attr('menuPk');	
  var superUl = findSuperUl($this.parent(), 'sf-menu');
  if (superUl) {
	  var reqURI = $this.attr('href');
	    superUl.css('display', 'none');
		if(reqURI.indexOf('implementationFlag=N')>0){
			jAlert(xenos.i18n.message.feature_not_implemented, null);
		}else{
			//Collecting Grids for clean up
			var gridInstanceArray = [];
			var grids = $("[class*=slickgrid_]", $(e.target).parents('div#menu').siblings('div#content').find('#queryResultForm,.entryContainer, .entryContainerConfirm'));
			$.each(grids, function (ind, grid) {
				if($(grid).data("gridInstance").getEditorLock().isActive()){
					$(grid).data("gridInstance").getEditorLock().commitCurrentEdit();
				}
				gridInstanceArray.push($(grid).data("gridInstance"));
			});
			
		cached = refreshCache(cached);
		if(cached.openNewTab=='Y'){
			
			xenos$Handler$asynchronous.generic(e, { requestUri: reqURI, 'menuPk':menuPk, requestType:'synchronous',target:'_blank'  });				
		}
		else{
			xenos$Handler$asynchronous.generic(e, { requestUri: reqURI, 'gridInstance' : gridInstanceArray,'menuPk':menuPk  });	
		}
			
		}
  }

  //
  //
  $.each($('.active.taskBtn'), function(index, el) {
    $('#' + $(el).attr('rel')).closest('.ui-dialog').find('.minDialog').trigger('click');
  });
  //
  //
});
// end


// collapse/expand menu handler
// handle
var $toggleMenuArea = jQuery('.toggleMenuArea');

var $window = jQuery(window);
$window.resize(function() {
  $toggleMenuArea.css('width', $window.width());
});

function setMenuInCache(menuPk) {
	var cached = xenos$Cache.get('globalPrefs');
	if(cached.openNewTab!='Y') {
		var $cache = $('div#footer>div#xenos-cache-container>span#cache');
		$cache.data('menuPk',menuPk);
	}	
}

$toggleMenuArea.css('width', $window.width()).on('click', function() {
  var $this = jQuery(this);

  // handle
  var $menuArea = jQuery('.menuArea');
  // toggle
  $menuArea.toggle();

  // action
  if ($menuArea.is(':visible')) {
    $this.html('Collapse');
    $this.attr('title', 'Collapse Menu Bar');
    xenos$Event.trigger('menu-area-expanded');
  } else {
    $this.html('Expand');
    $this.attr('title', 'Expand Menu Bar');
    xenos$Event.trigger('menu-area-collapsed');
  }
}).mouseover(function(){
  jQuery(this).removeClass('img').animate({'height': '10px', 'border-bottom-width': '1px'}, {"queue": false, "duration": 100});
}).mouseout(function(){
  jQuery(this).addClass('img').animate({'height': '0', 'border-bottom-width': '0'}, {"queue": false, "duration": 100});
});


// handling right dock menu
jQuery('.rightDockMenu a').click(function(e) {
	// We have two different ways to back to dashboard as by clicking rightDock menu and dashboard menu under user icon. While user will
    // click on the right dock menu dashboard will be full refreshed, i.e. we need to reinitialize the dashboard comoinent. That's 
	// why following API is called.
    // While user will click on the dashboard icon under user, dashboard will not be refreshed fully.
	if(typeof xenos$Dashboard$plugin != 'undefined') {
		xenos$Dashboard$plugin.reInitialize();
	}
  e.preventDefault();
	//Collecting Grids for clean up
	var gridInstanceArray = [];
	var grids = $("[class*=slickgrid_]", $(e.target).parents('div#menu').siblings('div#content').find('#queryResultForm, .entryContainer, .entryContainerConfirm'));
	$.each(grids, function (ind, grid) {
		if($(grid).data("gridInstance").getEditorLock().isActive()){
			$(grid).data("gridInstance").getEditorLock().commitCurrentEdit();
		}
		gridInstanceArray.push($(grid).data("gridInstance"));
	});
  xenos$Handler$asynchronous.generic(e, {requestUri: jQuery(this).attr('href'), 'gridInstance' : gridInstanceArray});
});


  jQuery('.rightDockMenu').mouseover(function(){
  $(this).animate({'width': jQuery('.rightDocTxt').width() + 54 + 'px'},{"queue": false, "duration": 100});
}).mouseout(function(){
	$(this).animate({'width':'15px'},{"queue": false, "duration": 100});	
});


