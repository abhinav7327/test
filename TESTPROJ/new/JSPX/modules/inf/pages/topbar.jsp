


<%@ include file="/WEB-INF/tiles/tldDefinition.jsp"%>
<html>
<head>
<title>Top Bar</title>
<xenos:css href="styles/xenos.css"/>
<%
    String ctxpath= request.getContextPath();
%>
<script>



function dologout(action)
{
    document.forms[0].action=action;
    document.forms[0].submit();
    return true;
}
function modalWin(url)
    {
        posleft=parseInt((screen.width-500)/2);
        posheight=parseInt((screen.height-353)/2);
        window.showModalDialog(url,"","dialogHeight: 335px; dialogWidth: 510px; dialogTop:"+ posheight+"px; dialogLeft: "+posleft+"px; edge: Sunken; center: Yes; help: No; resizable: No; status: No;");
        return false; 
    }

function printMainWindow(){
   bV = parseInt(navigator.appVersion)
        parent.mainFrame.focus();
        parent.mainFrame.print();
       //window.top.mainFrame.focus();
       //window.print();
   if (bV >= 4) {       
       
   }
}

function focusenterprise(){
	document.getElementById('dummy').focus();
}

function onChangeEnterprise(URI) {     
     finalURI = "switchEnterpriseAction.action?uri="+URI +"";
     top.location.href= finalURI
}
	

</script>

<xenos:script src="/scripts/inf/shortcutkeyblocker.js"/>

</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="focusenterprise()">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="003366" height="25" valign="bottom"><xenos:img srcKey="inf.image.logotop"/></td>
    <td class="003366" height="25" valign="bottom" align="right">
        <input type="text" name="dummy" class="dummytextbox">
        <span id="enterprise" class="labelWT"><c:out value="${applicationScope['enterprise.current']}"/>:</span>
        <span id="userid" class="labelWT"></span>
            <span id="screenid" class="labelWT"></span>
            <span id="appdate"  class="labelWT"></span>&nbsp;&nbsp;&nbsp;
    <%--    
			//NCSCD-68
        <span class="labelWT">Change Enterprise :</span>
           <select name="centerprise" class="textBox" onChange="return onChangeEnterprise(this.options[this.selectedIndex].value)">
              <option value=""/>
              <c:forEach var='eMap' items='${applicationScope["enterprise.friends"]}'>
              <option value="<c:out value='${eMap.value}'/>"> <c:out value='${eMap.key}'/></option>
              </c:forEach>
           </select>
           &nbsp;&nbsp;
   --%>
    </td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="175" valign="bottom" class="003366"><xenos:img srcKey="inf.image.logobottom"/></td>
    <td width="314" valign="bottom" class="486D92"><xenos:img srcKey="inf.image.triangle2" width="19" height="18"/></td>
    <td class="486D92" align="right" valign="bottom"><xenos:img srcKey="inf.image.triangle1" width="19" height="18"/><a href="<%=ctxpath%>/main.action?operation=home" onMouseOver="document.imgHome.src='images/menuHome2.gif'" onMouseOut="document.imgHome.src='images/menuHome1.gif'"><img name="imgHome" src="images/menuHome1.gif" width="79" height="18" border="0"></a><a href="javascript:void(0)" onClick="javascript:modalWin('ref/versionDispatch.action?method=initVersion')" onMouseOver="document.imgVer.src='images/menuVersion2.gif'" onMouseOut="document.imgVer.src='images/menuVersion1.gif'"><img name="imgVer" src="images/menuVersion1.gif" width="79" height="18" border="0"></a><!--
    <a href="<%=ctxpath%>/main.action?operation=help" onMouseOver="document.imgHelp.src='images/menuHelp2.gif'" onMouseOut="document.imgHelp.src='images/menuHelp1.gif'"><img name="imgHelp" src="images/menuHelp1.gif" width="78" height="18" border="0"></a>--><a href="javascript:void()" onClick="printMainWindow()" onMouseOver="document.imgLogout.src='images/menuPrint1.gif'" onMouseOut="document.imgLogout.src='images/menuPrint2.gif'"><img name="imgLogout" src="images/menuPrint2.gif" width="81" height="18" border="0"></a><a href="javascript:void(0)" onClick="dologout('logout.action')" target="_top" onMouseOver="document.imgLogout.src='images/menuLogout2.gif'" onMouseOut="document.imgLogout.src='images/menuLogout1.gif'"><img name="imgLogout" src="images/menuLogout1.gif" width="81" height="18" border="0"></a><span id="menuChache" style="display:none"></span><span id="menuChildChache" style="display:none"></span><span id="mktChache" style="display:none"></span><span id="instChache" style="display:none"></span></td>

  </tr>
  
</table>
<form style="display:inline">
</form>
</body>
</html>

