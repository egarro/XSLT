//This function is called with a variable number of arguments:
function updateItemOptions(target) {
 console.log("Must ad " + arguments.length + " options to " + target);
 // for (var i = 1; i < arguments.length; i++) {
 //    alert(arguments[i]);
 //  }
}

function valueOfItem(item) {
console.log("Must fetch " + item + " value and return a string");
}

function generateUFUSourceCode(target) {
 console.log("Generating UFU source code onto target " + target);
}

function sumItemsWithPredicate(predicate) {
 console.log("Must interpret predicate " + predicate);
}

function linkFieldToTypeField(caller,element) {
	//This is only used for credit cards. Fetch the element value and verify the caller has a proper value:
	console.log("Caller " + caller + " must check against element " + element + " for validation");
}

function setForceReceiptAttributeForElement(element,bool) {
	console.log("Must set the forceReceipt attribute for element " + element);
}

function displayElement(element,bool) {

	if (bool) {
		console.log("DISPLAY " + element);
		$('#'+element).show();
	}
	else {
		console.log("HIDE " + element);
		$('#'+element).hide();
	}
}

function evaluatePredicateForItem(element,predicate) {
	console.log("Must evaluate predicate " + predicate + " for item " + element);
}

function setTextForItem(element,text) {
  	console.log("Set text for item " + element + " to " + text);		
}

function checkItem(element,bool) {
	console.log("Check or uncheck " + element + " box");
}
    
function copyOntoItemFromItem(target,source) {
	console.log("Copy " + source + " onto " + target);
}

function forItemSetAttributeWithValue(element,attribute,bool) {
	console.log("Modify or add an attribute of type " + attribute + " for item " + element);
}

function openPhotoCapture(element) {
  console.log("Opening Photo Capture");
}

function openSignaturePanel(element) {
  console.log("Opening Signature Panel");
}

function openInfoPanelWithText(element,text) {
  console.log("Opening Info Panel");
}

function validateEmail(inputName) {
  console.log("Validating Email");
}

function validateAddress(inputName,validationService) {
  console.log("Validating Address");
}

function validateFRBank(inputName) {
  console.log("Validating FR Bank");
}

function validateUKBank(inputName) {
  console.log("Validating UK Bank");
}

function submitForm(element) {
  console.log("Submitting the form");
  return false;	
}