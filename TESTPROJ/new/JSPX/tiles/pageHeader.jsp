



<%@ include file="/WEB-INF/tiles/tldDefinition.jsp"%>

<html>
<head>
<title><c:out value="${applicationScope['enterprise.current']}"/> | Welcome to Application</title>

<xenos:css href="/styles/xenos.css"/>
<xenos:css href="/styles/menu-style.css"/>
<xenos:css href="/styles/nycalendar.css"/>
<script>
var mBarArrowN =  new Image();
var mBarArrowH =  new Image();
var mItemArrowN =  new Image();
var mItemArrowH =  new Image();
var mCalArrow =  new Image();
var mCalSpinnerUp =  new Image();
var mCalSpinnerDn =  new Image();
var mCalClose = new Image();
mBarArrowN.src="<xenos:ctxpath/>images/menubararrowN.gif";
mBarArrowH.src="<xenos:ctxpath/>images/menubararrowH.gif";
mItemArrowN.src="<xenos:ctxpath/>images/submenuarrowN.gif";
mItemArrowH.src="<xenos:ctxpath/>images/submenuarrowH.gif";
mCalArrow.src="<xenos:ctxpath/>images/downArrow.gif";
mCalSpinnerUp.src="<xenos:ctxpath/>images/spinnerUp.gif";
mCalSpinnerDn.src="<xenos:ctxpath/>images/spinnerDn.gif";
mCalClose.src = "<xenos:ctxpath/>images/btnClose.gif";
var enterprisePath = "<xenos:ctxpath/>" ;
var _dateFormat ="yyyyMMdd" ;
</script>

<xenos:script src="/scripts/inf/shortcutkeyblocker.js"/>
<xenos:script src="/scripts/inf/menuTree_lib.js"/>
<xenos:script src="/scripts/inf/util.js"/>
<xenos:script src="/scripts/inf/nycalendar.js"/>
<xenos:script src="/scripts/inf/utilPopup.js"/>
<xenos:script src="/scripts/inf/utilWindow.js"/>
<%--
<script>
var _toHide = 'xenosform';

function showMenu()
{    
    if (top.topFrame.menuChache == null || top.topFrame.menuChache.innerHTML == "") {

       <c:out value="${sessionScope['USER_MENU_STREAM']}" escapeXml="false"/>
       top.topFrame.menuChache.innerHTML=document.getElementById("s1").innerHTML;
       top.topFrame.menuChildChache.innerHTML=document.getElementById("menuchildren").innerHTML;
       
   } else {
   
         var xenosMenuBar = new menuBar(1, 0, 'XENOS');
         xenosMenuBar.init();

         document.getElementById("s1").innerHTML=top.topFrame.menuChache.innerHTML;

         submenu = document.createElement('DIV');
         submenu.setAttribute('id','menuchildren');
         document.body.appendChild(submenu);
         document.getElementById("menuchildren").innerHTML = top.topFrame.menuChildChache.innerHTML;

         doEvenAttach(document.getElementById("s1"));
         doEvenAttach(document.getElementById("menuchildren"));

    }

}

</script>
--%>

</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="initPage()" onFocus="focusPage()" onclick="onclickPage()" style="overflow:auto">
