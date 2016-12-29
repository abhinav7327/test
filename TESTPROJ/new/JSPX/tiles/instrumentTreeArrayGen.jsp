



<%@ page import="com.nri.xenos.inf.*,com.nri.xenos.startup.Application,com.nri.xenos.ref.*" %>
<%@ page import="java.util.*,org.apache.commons.beanutils.DynaBean" %>
<script>
var instrument = new Array();
//instrumentTreeGenerator ();

  if (window.parent.document.getElementById('instChache')) {

        if (window.parent.document.getElementById('instChache').innerHTML == "") {

            instrumentTreeGenerator ();
        }
    } else if (window.parent.document.getElementById('instChache').innerHTML == "") {

            instrumentTreeGenerator ();
    }

//alert(window.parent.document.getElementById('instChache').innerHTML);


/**
 * This API will create the array to be used by thin client for instrument tree 
 *
 */

function instrumentTreeGenerator () {

    <%
	List parents = Application.getInstance()
							   .getContext()
							   .getModuleContext(Module.REF)
							   .getService(InstrumentTypeAccessor.class).getAllInstrumentTypeWithParent();
	//Collections.reverse(parents);
	int idx = 0 ;
	for(Iterator it = parents.iterator(); it.hasNext(); ){
		DynaBean db = (DynaBean)it.next();
		String type = (String)db.get("instrument_type"); 
		String parent = (String)db.get("instrument_type_belongs_to"); 
		String description = (String)db.get("name"); 
		if(parent== null)
		{
			parent = "0";
		}	
    %>
		instrument[<%=idx%>]=["<%=type%>","<%=parent%>","<%=description%>"]	
    <%
		idx++;
	}	
    %>
}
</script>