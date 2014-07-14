//state = 0  //Highlights red: error class
//state = 1  //Highlights green: success class

function validateInput(element) {

	if( $(element).hasClass('MMsignatureBox') ) {
		if ( $(element).attr('signed') !== 'true' && $(element).attr('req') === 'true' ) { 
			highlightElement($(element).find('.signBox')[0],0);
			return false;
		} 
	}
	else if ( $(element).attr('type') == 'checkbox' && $(element).closest('div').attr('req') === 'true' ) {
		return $(element).is(':checked');
	}
	else if ( $(element).closest('div').hasClass('MMimagePicker') || $(element).closest('div').hasClass('MMradioControl') ) {
		var tmp = $(element).attr('name');

		var isChecked = false;
		$('input[name="' + tmp +'"]').each(function(){
			if ( $(this).is(':checked') ) isChecked = true;
		});

		if ( !isChecked && $(element).closest('div').attr('req') === 'true' ) {
			highlightElement(element,0);
			return false;
		}
	}
	else if ( !$(element).val() && $(element).closest('div').attr('req') === 'true' ) {
		highlightElement(element,0);
		return false;
	}
	else if ( $(element).val() ) {
		return evaluateInput(element);
	}

	return true;
}


function highlightElement(element,state) {
	switch (state) {
		case 0:
			$(element).removeClass("success").addClass("error");
			break;
		case 1:
			$(element).removeClass("error").addClass("success");
			break;
		default:
			console.log('Unknown state when highlighting element');
			break;
	}
}

function regExFilterForType(type) {
	var resp = /[^]/g;

	switch(type) {
		case "lettersOnly":
			resp = /[a-zA-ZÀÁÂÄáàâäãæÈÉÊËèéêëÎÏÍÌîïíìÔÖÒÓôöòóœõÛÜÙÚûüùúÑñçÇ]/g;
			break;
		case "letters":
			resp = /[a-zA-ZÀÁÂÄáàâäãæÈÉÊËèéêëÎÏÍÌîïíìÔÖÒÓôöòóœõÛÜÙÚûüùúÑñ'\-\.çÇ\s]/g;
			break;
		case "numericOnly":
			resp = /[0-9]/g;
			break;
		case "numericWithPeriods":
			resp = /[0-9\.]/g;
			break;
		case "numeric":
			resp = /[0-9\.\-\s]/g;
			break;
		case "lettersNumericOnly":
			resp = /[a-zA-Z0-9ÀÁÂÄáàâäãæÈÉÊËèéêëÎÏÍÌîïíìÔÖÒÓôöòóœõÛÜÙÚûüùúÑñçÇ]/g;
			break;
		case "lettersNumeric":
			resp = /[a-zA-Z0-9ÀÁÂÄáàâäãæÈÉÊËèéêëÎÏÍÌîïíìÔÖÒÓôöòóœõÛÜÙÚûüùúÑñçÇ'\-\.\s]/g;
			break;
		case "alphaOnly":
			resp = /[a-zA-Z]/g;
			break;
		case "alpha":
			resp = /[a-zA-Z'\.\s]/g;
			break;
		case "alphanumericOnly":
			resp = /[a-zA-Z0-9]/g;
			break;
		case "plain":
			resp = /[a-zA-Z\s]/g;
			break;
		case "alphanumeric":
			resp = /[a-zA-Z0-9'\.\-\s]/g;
			break;
		case "intlphonenumber":
			resp = /[0-9()\+\-\s]/g;
			break;
		case "usphonenumber":
			resp = /[0-9()\+\-\s]/g;
			break;
		case "creditcard":
			resp = /[0-9]/g;
			break;
		case "email":
			resp = /[a-zA-Z0-9_@\.\+\-\s]/g;
			break;
		case "day":
			resp = /[0-9]/g;
			break;
		case "month":
			resp = /[0-9]/g;
			break;
		case "year":
			resp = /[0-9]/g;
			break;
		case "luhn":
			resp = /[0-9]/g;
			break;
		case "names":
			resp = /[a-zA-ZÀÁÂÄáàâäãæÈÉÊËèéêëÎÏÍÌîïíìÔÖÒÓôöòóœõÛÜÙÚûüùúÑñ'\-çÇ\s]/g;
			break;
		case "namesNumeric":
			resp = /[a-zA-Z0-9ÀÁÂÄáàâäãæÈÉÊËèéêëÎÏÍÌîïíìÔÖÒÓôöòóœõÛÜÙÚûüùúÑñ'\-çÇ\s]/g;
			break;
		case "canadianPostalCode":
			resp = /[a-zA-Z0-9]/g;
			break;
	}

	return resp;
}


function filterInput(e, element) {
	//We start by deciding weather the input element is a valid character:
	var _to_ascii = {
        '188': '44',
        '109': '45',
        '190': '46',
        '191': '47',
        '192': '96',
        '220': '92',
        '222': '39',
        '221': '93',
        '219': '91',
        '173': '45',
        '187': '61', //IE Key codes
        '186': '59', //IE Key codes
        '189': '45'  //IE Key codes
    }

    var shiftUps = {
        "96": "~",
        "49": "!",
        "50": "@",
        "51": "#",
        "52": "$",
        "53": "%",
        "54": "^",
        "55": "&",
        "56": "*",
        "57": "(",
        "48": ")",
        "45": "_",
        "61": "+",
        "91": "{",
        "93": "}",
        "92": "|",
        "59": ":",
        "39": "\"",
        "44": "<",
        "46": ">",
        "47": "?"
    };

    var c = e.which;

    //Backspace key:
    if( c == 8 ) return;

    //Normalize keyCode
    if (_to_ascii.hasOwnProperty(c)) {
        c = _to_ascii[c];
    }

    if (!e.shiftKey && (c >= 65 && c <= 90)) {
        c = String.fromCharCode(c + 32);
    }
    else if (!e.shiftKey && (c >= 95 && c <= 105)) {
    	//These are keypad codes:
        c = String.fromCharCode(c - 48);
    }
    else if (e.shiftKey && shiftUps.hasOwnProperty(c)) {
    	//get shifted keyCode value
    	c = shiftUps[c];
    }
    else {
        c = String.fromCharCode(c);
    }

	var type = $(element).attr("validation");
	var maxL = $(element).attr("maxlength");
	if (typeof maxL === 'undefined') {
		if (type == 'creditcard') {
			maxL = 19;
		}
		else if (type == 'usphonenumber') {
			maxL = 17;
		}
		else if (type == 'day') {
			maxL = 2;
		}
		else if (type == 'month') {
			maxL = 2;
		}
		else if (type == 'year') {
			maxL = 4;
		}
		else if (type == 'canadianPostalCode') {
			maxL = 6;
		}
		else {
			maxL = 1000;
		}
	}

	var filter = regExFilterForType(type);
	var valid = filter.test(c);

	var currentValue = $(element).val();
	if (typeof currentValue === 'undefined') {
		currentValue = '';
	}

   	if( !valid || currentValue.length == maxL ) {
   		//This is our first check, we prevent invalid characters from being entered at all.
   		e.preventDefault();
   		return false;
   	}

   	if ( currentValue.length > maxL ) {
   		$(element).val( currentValue.substring( 0, maxL ) );
   	}

   	//Continue with further validation testing:
   	return true;
}

function evaluateInput(element) {

	var name = $(element).attr("name");
	if ( name && name.toLowerCase().indexOf('repeat') == 0 ) {
		 //This is a repeat check, fetch the repeated element's value and compare to this value:
		name = name.substring(6);
		var searchPaths = [ name, '_' + name, name.charAt(0).toLowerCase() + name.slice(1), '_' + name.charAt(0).toLowerCase() + name.slice(1) ];
		var currentValue = '';
		for (var i = searchPaths.length - 1; i >= 0; i--) {
			var tmp = searchPaths[i];
			var resp = $('#'+ tmp + " input[name='" + tmp + "']:first");
			if (resp.length !== 0) {
				//Found the matching item!
				currentValue = resp.val();
				break;
			}
		}

		var limit = currentValue.length;
		var thisValue = $(element).val();

		if (thisValue.length > limit) {
			thisValue = thisValue.substring(0,limit);
			$(element).val( thisValue );
			if( thisValue == currentValue ) {
				highlightElement(element, 1);
				return true;
			}
			else {
				highlightElement(element, 0);
				return false;
			}
		}

		if( thisValue == currentValue ) {
				highlightElement(element, 1);
				return true;
		}
		else {
				highlightElement(element, 0);
				return false;
		}

	}

	var type = $(element).attr("validation");
	var filter = regExFilterForType(type);
	var input  = $(element).val();
	if (typeof input === 'undefined') {
		input = '';
	}

   	var minL = $(element).attr("minlength");
	if (typeof minL !== 'undefined' && input.length < minL) {
		//Throw some alert indicating that this value has a min length:
		console.log('YOU MUST ENTER AT LEAST ' + minL + ' CHARACTERS!');
		highlightElement(element, 0);
	}

	var allMatches = input.match(filter);
	var totalChars = 0;
	if (allMatches) {
		totalChars = allMatches.length;
	}

	//First we check that no invalid character made it this far (which could happen if the keyCode was not recognized)
	if (totalChars != input.length) {
		//There is some character not allowed here. Probably the last one. Delete it!
		console.log('UNALLOWED CHARACTER FOUND IN ' + input);
		$(element).val(input.substring(0,input.length - 1));
		//highlightElement(element, 0);
		return false;
	}
	else {

		var nextRegEx;
		//Continue our validation checks:

		switch(type) {
			case "intlphonenumber":
				nextRegEx = /^\(?[2-9]\d{2}[\)\.-]?\s?\d{3}[\s\.-]?\d{4}$/g;
				break;
			case "usphonenumber":
				nextRegEx = /^\(?[2-9]\d{2}[\)\.-]?\s?\d{3}[\s\.-]?\d{4}$/g;
				break;
			case "email":
				nextRegEx = /^[_A-Za-z0-9-]+(\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*(\.[A-Za-z]{2,4})$/g;
				break;
			case "day":
				nextRegEx = /3[01]|[12][0-9]|0?[1-9]/g;
				break;
			case "month":
				nextRegEx = /1[012]|0?[1-9]/g;
				break;
			case "year":
				nextRegEx = /(19|20)[0-9]{2}/g;
				break;
			case "canadianPostalCode":
				nextRegEx = /^[ABCEGHJKLMNPRSTVXYabceghjklmnprstvxy]{1}\d{1}[A-Za-z]{1} *\d{1}[A-Za-z]{1}\d{1}$/g;
				break;
		}

		if(typeof nextRegEx !== 'undefined') {
			//One of the previous cases applies. Make sure the entire string matches:
			var matches = input.match(nextRegEx);
			if (matches && matches.length == 1 && matches[0].length == input.length) {
				//This is a beautiful match!
				highlightElement(element, 1);
				return true;
			}
			else {
			   //There is some error with this input:
			   	if (type == 'canadianPostalCode') {
			   	   if ( input.length != 7) {
					   highlightElement(element, 0);				   			
			   	   }
				}
				else {
					highlightElement(element, 0);
					return false;
				}
			}

			//Handle the canadianPostalCode case:
			if (type == 'canadianPostalCode') {
				var pos = input.length;
				if (pos > 0) {
					var ch = input.charAt( pos - 1);
					console.log('Char: ' + ch + ' at position: ' + pos);
						switch (pos) {
                			case 2:
                			case 4:
                			case 6:
                				if( (parseFloat(ch) == parseInt(ch) ) && !isNaN(ch) ) {
      								//Go ahead switch for a defaultkeyboard:
      								console.log('Switching to text keyboard');

      								var newElement = $(element).clone();
      								newElement.attr('type','text');
      								$(element).after(newElement);
									$(element).remove();

									newElement.val(input);
									newElement.focus();
      							}
      							else {
      								//Letter given at the wrong index. Delete:
                    				$(element).val(input.substring(0,input.length - 1));
  								}
                    			break;
                			case 1:
                			case 3:
                			case 5:
                				if( (parseFloat(ch) == parseInt(ch) ) && !isNaN(ch) ) {
      								//Integer given at the wrong index. Delete:
                    				$(element).val(input.substring(0,input.length - 1));
      							}
      							else {
      								//Go ahead switch for a numberkeyboard:
      								console.log('Switching to number keyboard');

      								var newElement = $(element).clone();
      								newElement.attr('type','tel');
      								$(element).after(newElement);
									$(element).remove();

									newElement.val(input);
									newElement.focus();

  								}
                    			break;
                			default:
								$(element).val(input.substring(0,input.length - 1));
                    			break;
            			}
            		return false;	
				}
				else {
					var newElement = $(element).clone();
      				newElement.attr('type','text');
      				$(element).after(newElement);
					$(element).remove();

					newElement.val('');
					newElement.focus();
                	highlightElement(element, 0);
					return false;
				}
            }
            else if (type == 'email') {
                $('#'+element.name+' :input[type="email"]').removeClass('success')
                $('#'+element.name+' :button').removeClass("validated")
            }
		}
		else {

			//We may be looking at an algorithmic validation check:
			if (type == 'creditcard') {
				var linkedElement = $(element).attr("linksto");
				var algorithm = -1;
				if (typeof linkedElement !== 'undefined') {

					//When the field is linked, we must check the user has input something in the linked element first:
					var sel = $('#'+ linkedElement + " select[name='" + linkedElement + "']:first").val();

					//When linked, credit card type must be selected first:
					if( !sel ) {
						console.log('Must select ' + linkedElement + 'first!');
						$('#'+ linkedElement).removeClass("success").addClass("error");
						$(element).val('');
						return false;
					}

					//Now, classify the selection to pick the appropiate validation type:
					sel = sel.toLowerCase();

					if (sel == 'visa' || sel ==  'v') {
						algorithm = 0;
					}
					else if (sel == 'mc' || sel == 'master' || sel == 'mastercard' || sel == 'master card' || sel == 'm') {
						algorithm = 1;
					}
					else if (sel == 'amex' || sel == 'american' || sel == 'americanexpress' || sel == 'american express' || sel == 'express' || sel == 'a') {
						algorithm = 2;
					}
					else if (sel == 'discover' || sel == 'novus' || sel == 'n' || sel == 'discovernovus' || sel == 'discover novus') {
						algorithm = 3;
					}
					else if (sel == 'diners' || sel == 'd' || sel == 'dinersclub' || sel == 'diners club') {
						algorithm = 4;
					}
					else {
						console.log('Unknown credit card selection type at ' + linkedElement);
						highlightElement(element, 0);
						$(element).val('');
						return false;
					}

					if( validateCreditCard(input, algorithm, element) ) {
						highlightElement(element, 1);
						return true;
					}	
					else {
						highlightElement(element, 0);
						return false;
					}	
				}
				else {
					var currentInput = $(element).val();
					if( validateCreditCard(input, 0, element) || validateCreditCard(input, 1, element) ||
						validateCreditCard(input, 2, element) || validateCreditCard(input, 3, element) ||
						validateCreditCard(input, 4, element) ) {
							highlightElement(element, 1);
							$(element).val(currentInput);
							return true;
					}
					else {
						highlightElement(element, 0);
						$(element).val(currentInput);
						return false;
					}	

				}
			}
			else if (type == 'luhn') {

				if( validateLuhn(input) ) {
					highlightElement(element, 1);
					return true;
				}	
				else {
					highlightElement(element, 0);
					return false;
				}	

			}
			else if (type == 'repeat') {
				//This field must have the same value as the matching field:
				console.log('Repeat validation type not implemented');
			}
		}
	}

	return true;
}

//Meanings for the algorithm argument:
//-1 No credit card defined. Check if any is true!
// 0 Visa
// 1 MC
// 2 Amex
// 3 Discover Novus
// 4 Diners
function validateCreditCard(number, algorithm, element) {
    var resp = true;
	var maxlength;
	var minlength;
	var options;

	switch (algorithm) {
		case 0:
			maxlength = 19;
			minlength = 16;
			options = ['4'];
			break;
		case 1:
			maxlength = 19;
			minlength = 16;
			options = ['5','51','52','53','54','55'];
			break;
		case 2:
			maxlength = 15;
			minlength = 15;
			options = ['3','34','37'];
			break;
		case 3:
			maxlength = 16;
			minlength = 14;
			options = ['2','3','6','62','26','30','35','60','39','36','38','64','65'];
			break;
		case 4:
			maxlength = 16;
			minlength = 14;
			options = ['3','5','36','54','55'];
			break;
		default:
			console.log('validateCreditCard function called with unknown algorithm type');
			break;
	}

	if (number.length == 1) {
		//~ is a bitwise NOT operator, which returns 0 only for -1 (1111111111111111)
        var isThere = ~$.inArray(number, options);
        if ( !isThere ) {
			$(element).val('');
        }

        resp = false;
	}
	else if ( number.length == 2 && algorithm > 0) {
        var isThere = ~$.inArray(number, options);
        if ( !isThere ) {
			number = number.substring(0,1);
			$(element).val(number);
        }

        resp = false;
	}
	else if ( number.length < minlength ) {
		resp = false;
	}
	else if ( number.length >= minlength && number.length <= maxlength ) {
		//Test if luhn passes:
		resp = validateLuhn(number);
	}
	else if ( number.length > maxlength ) {
		number = number.substring(0,maxlength);
		$(element).val(number);
		//Test if luhn passes:
		resp = validateLuhn(number);
	}

	return resp;
}

function validateLuhn(str) {

	var luhnArr = [0, 2, 4, 6, 8, 1, 3, 5, 7, 9];

	var counter = 0;
	var incNum;
	var odd = false;
	var temp = String(str).replace(/[^\d]/g, "");
	if ( temp.length == 0)
			return false;

	for (var i = temp.length-1; i >= 0; --i) {
		incNum = parseInt(temp.charAt(i), 10);
		counter += (odd = !odd)? incNum : luhnArr[incNum];
	}

	return (counter%10 == 0);

}

function validateAddress(element) {
    var address = {
        'address1': $('#'+element+' :input[name="address1"]').val(),
        'address2': $('#'+element+' :input[name="address2"]').val(),
        'address3': $('#'+element+' :input[name="address3"]').val(),
        'province': $('#'+element+' .dropdown select :selected').val(),
        'city': $('#'+element+' :input[name="city"]').val(),
        'postal': $('#'+element+' :input[name="postalCode"]').val()
    }
    var country = $('#'+element+' .countryName').html().substring(0,3).toUpperCase()
    var jsonAddress = '{"action":"search","country":"'+country+'","addressInfo":'+JSON.stringify(address)+'}'

    $.ajax({
        type: "POST",
        url: 'https://onboard.madeportal.com/addressval/index.php',
        data: {"json":jsonAddress},
        dataType: "html",
        success: function(data, status, jqXHR) {
            data = JSON.parse(data)
            if (data.Condition == 'Success') {
                $('#'+element+' :button').addClass("validated")
                $('#'+element+' :input[name="address1"]').removeClass('error')
                $('#'+element+' :input[name="address2"]').removeClass('error')
                $('#'+element+' :input[name="address3"]').removeClass('error')
                $('#'+element+' :input[name="city"]').removeClass('error')
                $('#'+element+' :input[name="postalCode"]').removeClass('error')

                $('#'+element+' :input[name="address1"]').val(data.Addresses[0].address1)
                $('#'+element+' :input[name="address2"]').val(data.Addresses[0].address2)
                $('#'+element+' :input[name="address3"]').val(data.Addresses[0].address3)
                $('#'+element+' .dropdown select').val(data.Addresses[0].province)
                $('#'+element+' :input[name="city"]').val(data.Addresses[0].city)
                $('#'+element+' :input[name="postalCode"]').val(data.Addresses[0].postal.replace(/ /g,''))
            } else if (data.Condition == 'Picklist') {
                popupDiv = '<div class="modalBackground"></div><div id="addressModal" owner="'+element+'" class="modal">'
                popupDiv += '<div class="modalHeader" name="modalHeader"><div><span class="modalHeaderText">Choose Your Address</span></div><div><a href="#" id="addressModalClose" class="modalClose">X</a></div></div>'

                popupDiv += '<div class="modalBody" name="modalBody"><ul style="float:left;">'
                for (var index in data.Addresses) {
                    popupDiv += '<li><button type="button" id="'+data.Addresses[index].Moniker+'">'+data.Addresses[index].Address+'</button></li>'
                }

                popupDiv += '</ul></div></div>'

                $('body').append(popupDiv)
            } else {
                $('#'+element+' :button').removeClass("validated")
                $('#'+element+' :input[name="address1"]').addClass('error').removeClass('success')
                $('#'+element+' :input[name="address2"]').addClass('error').removeClass('success')
                $('#'+element+' :input[name="address3"]').addClass('error').removeClass('success')
                $('#'+element+' :input[name="city"]').addClass('error').removeClass('success')
                $('#'+element+' :input[name="postalCode"]').addClass('error').removeClass('success')
            }
        },
        error: errorCallback
    });
}

function validateMoniker(element, moniker) {
    var country = $('#'+element+' .countryName').html().substring(0,3).toUpperCase()

    $.ajax({
        type: "POST",
        url: 'https://onboard.madeportal.com/addressval/index.php',
        data: {"json":'{"action":"format","country":"'+country+'","addressInfo":{"address1":"","address2":"","address3":"","city":"","province":"","postal":"", "moniker":"'+moniker+'"}}'},
        dataType: "html",
        success: function(data, status, jqXHR) {
            data = JSON.parse(data)
            if (data.Condition == 'Success') {
                $('#'+element+' :button').addClass("validated")
                $('#'+element+' :input[name="address1"]').removeClass('error')
                $('#'+element+' :input[name="address2"]').removeClass('error')
                $('#'+element+' :input[name="address3"]').removeClass('error')
                $('#'+element+' :input[name="city"]').removeClass('error')
                $('#'+element+' :input[name="postalCode"]').removeClass('error')

                $('#'+element+' :input[name="address1"]').val(data.Addresses[0].address1)
                $('#'+element+' :input[name="address2"]').val(data.Addresses[0].address2)
                $('#'+element+' :input[name="address3"]').val(data.Addresses[0].address3)
                $('#'+element+' .dropdown select').val(data.Addresses[0].province)
                $('#'+element+' :input[name="city"]').val(data.Addresses[0].city)
                $('#'+element+' :input[name="postalCode"]').val(data.Addresses[0].postal.replace(/ /g,''))
            } else if (data.Condition == 'Picklist') {
                popupDiv = '<div class="modalBackground"></div><div id="addressModal" owner="'+element+'" class="modal">'
                popupDiv += '<div class="modalHeader" name="modalHeader"><div><span class="modalHeaderText">Choose Your Address</span></div><div><a href="#" id="addressModalClose" class="modalClose">X</a></div></div>'

                popupDiv += '<div class="modalBody" name="modalBody"><ul style="float:left;">'
                for (var index in data.Addresses) {
                    popupDiv += '<li><button type="button" id="'+data.Addresses[index].Moniker+'">'+data.Addresses[index].Address+'</button></li>'
                }

                popupDiv += '</ul></div></div>'

                $('body').append(popupDiv)
            } else {
                $('#'+element+' :button').removeClass("validated")
                $('#'+element+' :input[name="address1"]').addClass('error').removeClass('success')
                $('#'+element+' :input[name="address2"]').addClass('error').removeClass('success')
                $('#'+element+' :input[name="address3"]').addClass('error').removeClass('success')
                $('#'+element+' :input[name="city"]').addClass('error').removeClass('success')
                $('#'+element+' :input[name="postalCode"]').addClass('error').removeClass('success')
            }
        },
        error: errorCallback
    });
}

function validateEmail(element) {
    var email = $('#'+element+' :input').val()

    $.ajax({
        url: "https://madeportal.com/postcodeEntry/mmEmailValidation.php",
        type: 'POST',
        data: {"json":'{"userEmail":"'+email+'"}'},
        dataType: "html",
        success: function(data, status, jqXHR) {
            data = JSON.parse(data)
            if (data.Condition == 'Success') {
                $('#'+element+' :input[type="email"]').removeClass('error').addClass('success')
                $('#'+element+' :button').addClass("validated")
            } else {
                $('#'+element+' :input[type="email"]').addClass('error').removeClass('success')
                $('#'+element+' :button').removeClass("validated")
            }
        },
        error: errorCallback
    });
}

function errorCallback(jqXHR, status, errorThrown) {
    console.log(errorThrown)
}


// -----------------------------------------------
// Equivant Javascript de � strtr en PHP
function strtr (str, from, to) {
    // http://kevin.vanzonneveld.net
    // original by: Brett Zamir (http://brett-zamir.me)
    // example 1: $trans = {'hello' : 'hi', 'hi' : 'hello'}; strtr('hi all, I said hello', $trans); returns: 'hello all, I said hi'
    // example 2: strtr('�aaba�ccasde�oo', '���','aao'); returns: 'aaabaaccasdeooo'
    // example 3: strtr('��������', '�', 'a'); returns: 'aaaaaaaa'
    // example 4: strtr('http', 'pthxyz','xyzpth'); returns: 'zyyx'
    // example 5: strtr('zyyx', 'pthxyz','xyzpth'); returns: 'http'
    var fr = '', i = 0, j = 0, lenStr = 0, lenFrom = 0;
    var tmpFrom = [];
    var tmpTo   = [];
    var ret = '';
    var match = false;
    // Received replace_pairs?
    // Convert to normal from->to chars
    if (typeof from === 'object') {
        for (fr in from) {
            tmpFrom.push(fr);
            tmpTo.push(from[fr]);
        }
        from = tmpFrom;
        to = tmpTo;
    }
    // Walk through subject and replace chars when needed
    lenStr  = str.length;
    lenFrom = from.length;
    for (i = 0; i < lenStr; i++) {
        match = false;
        for (j = 0; j < lenFrom; j++) {
            if (str.substr(i, from[j].length) == from[j]) {
                match = true;
                // Fast forward
                i = (i + from[j].length)-1;
                break;
            }
        }
        if (false !== match) {
            ret += to[j];
        } else {
            ret += str[i];
        }
    }
    return ret;
}