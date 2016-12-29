

<%

%>

<%-- NCSRI-1318 --%>
<%! 
	/**
     * Constant value for ENTERPRISE_SGP
     */
    public static final String ENTERPRISE_SGP = "SGP";
	/**
     * Constant value for ENTERPRISE_HKG
     */
    public static final String ENTERPRISE_HKG = "HKG";
	/**
     * Constant value for ENTERPRISE_NYC
     */
	public static final String ENTERPRISE_NYC = "NYC";
	/**
     * Constant value for ENTERPRISE_LDN
     */
	public static final String ENTERPRISE_LDN = "LDN";
%>
<%
//NCSRI-1318
//Set Enterprise Flag.
// Set the Flag for SGP Enterprise
boolean isSGPEnterprise = (getServletContext().getInitParameter("enterpriseId")).equals(ENTERPRISE_SGP);
// Set the Flag for HKG Enterprise
boolean isHKGEnterprise = (getServletContext().getInitParameter("enterpriseId")).equals(ENTERPRISE_HKG);
// Set the Flag for LDN Enterprise
boolean isLDNEnterprise = (getServletContext().getInitParameter("enterpriseId")).equals(ENTERPRISE_LDN);
// Set the Flag for NYC Enterprise
boolean isNYCEnterprise = (getServletContext().getInitParameter("enterpriseId")).equals(ENTERPRISE_NYC);
%>
