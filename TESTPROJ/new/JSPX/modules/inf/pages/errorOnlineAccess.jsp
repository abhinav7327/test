


<%@ include file="/WEB-INF/tiles/nonTileHeader.jsp"%>

<html>
<head>
<title><c:out value="${applicationScope['enterprise.current']}"/><bean:message key="inf.label.nomuratitle"/></title>
<xenos:css href="styles/xenos.css"/>
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="head" valign="bottom" width="55%">&nbsp;
	<bean:message key="inf.label.onlineaccessdeniedmo"/>&nbsp;<c:out value="${sessionScope['module.current']}"/>
	</td>
    <td align="right" width="45%"><xenos:img srcKey="inf.image.imgnomura" width="480" height="45"/></td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="CECFCE">&nbsp;</td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="9">
  <tr> 
    <td align="center">&nbsp;</td>
  </tr>
</table>
</body>
</html>