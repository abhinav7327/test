


<%@ include file="/WEB-INF/tiles/tldDefinition.jsp"%>


<html>
<head>
<title><c:out value="${applicationScope['enterprise.current']}"/><bean:message key="inf.label.nomuratitle"/></title>
<xenos:css href="styles/xenos.css"/>
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td class="003366" height="25" valign="bottom"><xenos:img srcKey="inf.image.inf.image.logotop" width="147" height="7"/></td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="175" valign="bottom" class="003366"><xenos:img srcKey="inf.image.logobottom" width="147" height="18"/></td>
    <td width="314" valign="bottom" class="486D92"><xenos:img srcKey="inf.image.triangle2" width="19" height="18"/></td>
    <td class="486D92" align="right" valign="bottom">
	<!--
	<img srcKey="inf.image.triangle1" width="19" height="18"><a href="index.jsp" onMouseOver="document.imgHome.src='images/menuHome2'" onMouseOut="document.imgHome.src='images/menuHome1'"><img name="imgHome" srcKey="inf.image.menuHome1" width="79" height="18" border="0"></a><a href="index.jsp" onMouseOver="document.imgHelp.src='images/menuHelp2'" onMouseOut="document.imgHelp.src='images/menuHelp1'"><img name="imgHelp" srcKey="inf.image.menuHelp1" width="78" height="18" border="0"></a><a href="index.jsp?logoff=true" target="_top" onMouseOver="document.imgLogout.src='images/menuLogout2'" onMouseOut="document.imgLogout.src='images/menuLogout1'"><img name="imgLogout" srcKey="inf.image.menuLogout1" width="81" height="18" border="0"></a>
	-->
	</td>
  </tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td class="bgStripes" width="100%" nowrap>&nbsp;<img srcKey="inf.image.whitespace" width="1" height="22"></td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td class="head" valign="bottom" width="30%">&nbsp;&nbsp;<bean:message key="inf.label.accessdenied"/><c:out value="${applicationScope['enterprise.current']}"/></td>
    <td align="right" width="70%"><xenos:img srcKey="inf.image.imgnomura" width="480" height="45"/></td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="CECFCE">&nbsp;</td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="9">
  <tr> 
    <td align="center"> 
      <p class="text"><bean:message key="inf.label.enterprisenoaccess"/></p>
	  <br><br>
	  <span class="Label"><bean:message key="inf.label.changeenterprise"/></span>
	       <select name="enterprise" class="textBox" onchange="top.location.href=this.options[this.selectedIndex].value">
		      <option value=""/>
		      <c:forEach var='eMap' items='${applicationScope["enterprise.friends"]}'>
		      <option value="<c:out value='${eMap.value}'/>"> <c:out value='${eMap.key}'/></option>
		      </c:forEach>
	       </select>
   </td>
  </tr>
</table>
</body>
</html>
