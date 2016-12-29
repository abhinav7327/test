//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
// Content
function xenos$Element$Content() {
  // primary handle
  var $content = jQuery('#content');

  // other handle
  var $top = jQuery('#top');
  var $menu = jQuery('#menu');
  var $footer = jQuery('#footer');


  // primary function
  // handle
  this.handle = function() {
    return $content;
  };


  // other function
  // resize
  this.resize = function() {
    var height = jQuery(window).height();
    if ($top.length == 1 && $top.is(':visible')) height -= $top.outerHeight(true);
    if ($menu.length == 1 && $menu.is(':visible')) height -= $menu.outerHeight(true);
    if ($footer.length == 1 && $footer.is(':visible')) height -= $footer.outerHeight(true);

    var paddingTop = $content.css('padding-top');
    var paddingBottom = $content.css('padding-bottom');

    var padding_top_bottom = parseInt(paddingTop.substring(0, paddingTop.length - 2));
    padding_top_bottom += parseInt(paddingBottom.substring(0, paddingBottom.length - 2));

    $content.css('min-height', height - padding_top_bottom - 5);
  };
}


xenos$onReady$Array.push(function() {
  // content
  var content = new xenos$Element$Content();

  // resize
  content.resize();
  jQuery(window).resize(content.resize);

  // additional
  xenos$Event.on('menu-area-expanded menu-area-collapsed', content.resize);
});
