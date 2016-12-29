//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos.ns.views.cashTransferEntry.checkNegativeNumber = function(val) {
	var i = 0;
	var char = val.charAt(i);
	if (char == '-') {
		return false; // If negative number
	}
	return true; // Success
}
xenos.ns.views.cashTransferEntry.checkInvalidNumber = function(val) {
	var length = val.length;
	var dotCount = 0;
	var i = 0;
	var char = val.charAt(i);
	if (char = '-')
		i++;
	for (; i < length; i++) {
		char = val.charAt(i);
		if (char == ',') {
			continue;
		}
		if (char == '.') {
			dotCount++;
			if (dotCount > 1) {
				return false;
			}
			continue;
		}
		if ((char < '0' || char > '9') && 
				   (char != 'M' && char !='B' && char !='T')) {
					return false; // If not a valid number
		}

	}

	return true; // Success
}