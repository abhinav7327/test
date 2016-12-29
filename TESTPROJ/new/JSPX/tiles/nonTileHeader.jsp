

<%

%>


<%@ include file="/WEB-INF/tiles/pageHeader.jsp"%>
<!-- include file="/WEB-INF/tiles/stripes.jsp" -->
<%@ include file="/WEB-INF/tiles/menu.jsp"%>
<logic:messagesPresent>
<bean:message key="inf.errors.header"/>
	<html:messages id="message">
		<bean:message key="inf.errors.prefix"/><c:out value="${message}" escapeXml="false"/><bean:message key="inf.errors.suffix"/>
	</html:messages>
<bean:message key="inf.errors.footer"/>
</logic:messagesPresent>

<logic:messagesPresent message="true">
<bean:message key="inf.messages.header"/>
	<html:messages id="softmessage" message="true">
		<bean:message key="inf.messages.prefix"/><c:out value="${softmessage}" escapeXml="false"/><bean:message key="inf.messages.suffix"/>
	</html:messages>
<bean:message key="inf.messages.footer"/>
</logic:messagesPresent>
<%@ include file="/WEB-INF/tiles/formHeader.jsp"%>
