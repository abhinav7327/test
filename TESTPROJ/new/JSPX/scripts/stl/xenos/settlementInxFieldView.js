/*state variables*/
var settlementInstruction$dynamicFields={};
var settlementInstruction$dynamicDisabledFields={};
var settlementInstruction$dynamicSections={};
var settlementInstruction$defaultValues={};

/*state functions*/
function settlementInstruction$defaultViewSetting(){
	settlementInstruction$dynamicFields["status"]=true;
	settlementInstruction$dynamicFields["originDataSource"]=true;
	settlementInstruction$defaultValues["valueDateFrom"]="";
	
	settlementInstruction$dynamicDisabledFields["acceptanceStatusDisp"]=false;
	
	settlementInstruction$dynamicSections["more"]=true;
	settlementInstruction$dynamicSections["moreHandle"]=true;
	
}
function settlementInstruction$sendNew() {
	settlementInstruction$defaultViewSetting();/* since the states are same*/
}
function settlementInstruction$pending(){
	settlementInstruction$dynamicFields["status"]=false;
	settlementInstruction$dynamicFields["originDataSource"]=false;
	settlementInstruction$defaultValues["valueDateFrom"]="";
	
	settlementInstruction$dynamicDisabledFields["acceptanceStatusDisp"]=false;
	
	settlementInstruction$dynamicSections["more"]=true;
	settlementInstruction$dynamicSections["moreHandle"]=true;
}
function settlementInstruction$markAsTransmitted(){
	settlementInstruction$dynamicFields["status"]=true;
	settlementInstruction$dynamicFields["originDataSource"]=false;
	settlementInstruction$defaultValues["valueDateFrom"]="";
	
	settlementInstruction$dynamicDisabledFields["acceptanceStatusDisp"]=true;
	
	settlementInstruction$dynamicSections["more"]=true;
	settlementInstruction$dynamicSections["moreHandle"]=true;	
}
function settlementInstruction$messageCancellation(){
	settlementInstruction$dynamicFields["status"]=false;
	settlementInstruction$dynamicFields["originDataSource"]=false;
	settlementInstruction$defaultValues["valueDateFrom"]="";	
	
	settlementInstruction$dynamicDisabledFields["acceptanceStatusDisp"]=true;
	
	settlementInstruction$dynamicSections["more"]=true;
	settlementInstruction$dynamicSections["moreHandle"]=true;
}
function settlementInstruction$resend(){
	settlementInstruction$markAsTransmitted();/* since the states are same*/
}
function settlementInstruction$resetLiveIntruction(){
	settlementInstruction$messageCancellation();/* since the states are same*/
}
function settlementInstruction$query(){
	settlementInstruction$dynamicFields["status"]=true;
	settlementInstruction$dynamicFields["originDataSource"]=false;
	settlementInstruction$defaultValues["valueDateFrom"]=valueDateFrom;
	
	settlementInstruction$dynamicDisabledFields["acceptanceStatusDisp"]=true;
	
	settlementInstruction$dynamicSections["more"]=true;
	settlementInstruction$dynamicSections["moreHandle"]=true;	
}
function settlementInstruction$inxReportQuery(){
	settlementInstruction$dynamicFields["status"]=false;
	settlementInstruction$dynamicFields["originDataSource"]=false;
	
	settlementInstruction$dynamicDisabledFields["acceptanceStatusDisp"]=false;
	
	settlementInstruction$dynamicSections["more"]=false;
	settlementInstruction$dynamicSections["moreHandle"]=false;	
}

/*render function*/
function settlementInstruction$render(){

	for(var field in settlementInstruction$dynamicFields){
		if(settlementInstruction$dynamicFields[field]){
			$('#'+field).closest('.formItem').show();
		}
		else{
			$('#'+field).closest('.formItem').hide();
		}
	}
	
	for(var field in settlementInstruction$dynamicDisabledFields){
		if(settlementInstruction$dynamicDisabledFields[field]){
			$('#'+field).prop('disabled',false);
		}
		else{
			$('#'+field).prop('disabled',true);
		}
	}
	
	for(var section in settlementInstruction$dynamicSections){
		if(settlementInstruction$dynamicSections[section]){
			$('.'+section).show();
		}
		else{
			$('.'+section).hide();
		}
	}
	
	for(var section in settlementInstruction$defaultValues){
		$('#'+section).val(settlementInstruction$defaultValues[section]);
	}
	settlementInstruction$defaultValues["valueDateFrom"]
}
function $settlementInstruction$onLoad$fieldView() {
	console.log('Setting up field view');
	settlementInstruction$defaultViewSetting();
	settlementInstruction$render();
	
	$('#operationObjective').change($settlementInstruction$changeFieldView);
}
function $settlementInstruction$changeFieldView(){
		if(($.trim($('option:selected', this).text())=='SEND NEW')){
			settlementInstruction$sendNew();
		}
		else if(($.trim($('option:selected', this).text())=='PENDING')){
			settlementInstruction$pending();
		}		
		else if(($.trim($('option:selected', this).text())=='MARK AS TRANSMITTED')){
			settlementInstruction$markAsTransmitted();
		}
		else if(($.trim($('option:selected', this).text())=='MESSAGE CANCELLATION')){
			settlementInstruction$messageCancellation();
		}
		else if(($.trim($('option:selected', this).text())=='RESEND')){
			settlementInstruction$resend();
		}
		else if(($.trim($('option:selected', this).text())=='RESET LIVE INSTRUCTION')){
			settlementInstruction$resetLiveIntruction();
		}
		else if(($.trim($('option:selected', this).text())=='QUERY')){
			settlementInstruction$query();
		}
		else if(($.trim($('option:selected', this).text())=='INX REPORT QUERY')){
			settlementInstruction$inxReportQuery();
		}
		settlementInstruction$render();
}