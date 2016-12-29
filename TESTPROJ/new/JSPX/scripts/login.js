//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
// Login
function xenos$Element$Login() {
  // handles
  var $j_username = jQuery('#j_username');


  // functions
  // focus
  this.focus = function() {
    $j_username.focus();
  };
}


xenos$onReady$Array.push(function() {
  // login
  var login = new xenos$Element$Login();

  // focus
  login.focus();
  jQuery(document).focus(login.focus);
});
