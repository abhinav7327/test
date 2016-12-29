<!-- saved from url=(0022)http://internet.e-mail -->


<%

%>

<%--@ taglib uri="http://jakarta.apache.org/struts/tags-tiles" prefix="tiles" --%>

<!-- 
============================================================
=======  xenos Query Layout ================================
============================================================
-->
<%@ include file="/WEB-INF/tiles/pageHeader.jsp"%>
<%@ include file="/WEB-INF/tiles/stripes.jsp"%>
<%@ include file="/WEB-INF/tiles/menu.jsp"%>
<%@ include file="/WEB-INF/tiles/formHeader.jsp"%>
<jsp:include page="/WEB-INF/tiles/queryHeader.jsp"/>
<tiles:insert attribute="queryBody" />
<%@ include file="/WEB-INF/tiles/queryFooter.jsp"%>
<%@ include file="/WEB-INF/tiles/formFooter.jsp"%>
<%@ include file="/WEB-INF/tiles/pageFooter.jsp"%>