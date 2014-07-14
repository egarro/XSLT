//This function is called with a variable number of arguments:
function updateItemOptions(target) {
 console.log("Must ad " + arguments.length + " options to " + target);
 for (var i = 1; i < arguments.length; i++) {
    console.log(arguments[i]);
  }
}

//This function is called with a variable number of arguments:
function updateItemOptionTags(target) {
 console.log("Must ad " + arguments.length + " option tags to " + target);
 for (var i = 1; i < arguments.length; i++) {
    console.log(arguments[i]);
  }
}

function valueOfItem(item) {
	var theClass = $('#'+item).attr("class").split(" ")[0];

	if (theClass == 'MMlocalImage' ||
		theClass == 'MMzipImage' ||
		theClass == 'MMspacerBlock' ||
		theClass == 'MMphotoCapture' ||
		theClass == 'MMsignatureBox' ||
		theClass == 'MMspacerBlock' ||
		theClass == 'MMaddressField' ||
		theClass == 'MMlabel' ||
		theClass == 'MMmultilineLabel' ||
		theClass == 'MMinfoButton' ||
		theClass == 'MMFRBankPinger' ||
		theClass == 'MMUKBankPinger' ) {

		return "";
	}
    else if (theClass == 'MMdateField'){

	}
    else if (theClass == 'MMcheckbox'){
    	if ( $('#'+item).is(':checked') ) return "YES";
    	else return "NO";
	}
    else if (theClass == 'MMradioControl' ||
	 		 theClass == 'MMimagePicker'
    	    ) {

    	 var resp = $('#'+ item + " input[name='" + item + "']:checked").val();
		 return resp;
	}
    else if (theClass == 'MMdropDown' ||
    		 theClass == 'MMvaluePicker' ||
    		 theClass == 'MMsegmentedControl'
			) {

    	var resp = $('#'+ item + " select[name='" + item + "']:first").val();
    	return resp;
	}
    else if (theClass == 'MMtextField' ||
    		 theClass == 'MMcanadianPostalCode' ||
    		 theClass == 'MMemailPinger'
    		) {

    	var resp = $('#'+ item + " input[name='" + item + "']:first").val();
    	return resp;
	}
	else {
		console.log("Warning: Unknown class found while finding valueOfItem: " + theClass + " for item " + item );
	}

	return "";
}


function generateUFUSourceCode(target) {
 console.log("Generating UFU source code onto target " + target);
}

function sumItemsWithPredicate(predicate) {
 console.log("Must interpret predicate " + predicate);
}

function setForceReceiptAttributeForElement(element,bool) {
	console.log("Must set the forceReceipt attribute for element " + element);
}

function displayElement(element,bool) {

	if (bool) {
		$('#'+element).show();
	}
	else {
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
    
    var sourceVal = $('#' + source).val();
    $('#' + target).val(sourceVal);
}

function forItemSetAttributeWithValue(element,attribute,bool) {
	console.log("Modify or add an attribute of type " + attribute + " for item " + element);
}

function openPhotoCapture(element) {
  console.log("Opening Photo Capture");
	
  if (typeof MainViewController !== 'undefined') {
		MainViewController.openPhotoCapture();
  }
}

function openSignaturePanel(element) {

    var submissionID = '';
    var obj = $("#submissionId");
    if (obj.length !== 0) {
        submissionID = $(obj).val();
        var imageName = submissionID + '__' + element;
        if (typeof MainViewController !== 'undefined') {
           console.log("Opening Signature Panel for " + imageName);
           MainViewController.openSignaturePanel(imageName);
        }
        else {
            console.log('No controller implements the openSignaturePanel method.');        
        }    
    }
    else {
        console.log('ERROR fetching submissionId from for element! Reload the form and try again.');        
    }

}

function openInfoPanelWithText(element,text) {
  console.log("Opening Info Panel");
}

// function validateEmail(inputName) {
//   console.log("Validating Email");
// }

// function validateAddress(inputName,validationService) {
//   console.log("Validating Address");
// }

function validateFRBank(inputName) {
  console.log("Validating FR Bank");
}

function validateUKBank(inputName) {
  console.log("Validating UK Bank");
}

function saveExistingForm() {

    var obj = {};
    $('input:visible:not([type="button"],[type="submit"]), select:visible').each(function(){
            var value = fetchInputValue(this);
            var name = fetchInputName(this);

            if( name && value )
                obj[name] = value;
    });

    obj['submissionId'] = $('#submissionId').val();

    var campaignId = $('#campaignId').val();
    obj['campaignId'] = campaignId;

    postPartialSubmissionWithObject(JSON.stringify({"submission":obj,"campaignId":campaignId}));
}

function submitForm(campaignId) {
    console.log("Submitting the form");

    var resp = true;
    $('input:visible:not([type="button"],[type="submit"]), select:visible, .MMsignatureBox').each(function(){
            var tmp = validateInput(this);
            resp = resp && tmp;
        
            populateWarnings(this);

    });

    if(resp) {
        var obj = {};
        $('input:visible:not([type="button"],[type="submit"]), select:visible').each(function(){
                var value = fetchInputValue(this);
                var name = fetchInputName(this);

                if( name && value )
                    obj[name] = value;
        });

        var signatures = [];
        $('.MMsignatureBox').each(function(){
            if ( $(this).attr('signed') === 'true' ) { 
                 signatures.push( $(this).attr('id') );
            } 
        });        

        obj['submissionId'] = $('#submissionId').val();
        obj['campaignId'] = $('#campaignId').val();

        //USE THIS TO TEST HARDCODED SIGNATURES:
        //postSubmissionWithObject(JSON.stringify({"submission":obj,"campaignId":campaignId,"signatures":["chSign","custInitial-1","custSign","repSign"]}));
        postSubmissionWithObject(JSON.stringify({"submission":obj,"campaignId":campaignId,"signatures":signatures}));
    }
    else {
        console.log('Validation failing...');
    }
}

function postPartialSubmissionWithObject(obj) {
    console.log('Saving partial submission ');

    $.ajax({
        type: "POST",
        url: 'http://localhost:8080/save',
        data: obj,
        dataType: "json",
        success: function(data, status, jqXHR) {

            if (data.resp == 'success') {
                console.log('SUCCESSFUL SAVE!!');
            } 
            else  {
                console.log('SAVING FAILED :(');
            }
        },
        error: function(jqXHR, status, errorThrown) {
            //There was an error. Maybe alert the user to try again!
                console.log(errorThrown);
        }
    });    
}

function postSubmissionWithObject(obj) {
    console.log('Posting submission... ');

    $.ajax({
        type: "POST",
        url: 'http://localhost:8080/submit',
        data: obj,
        contentType: 'application/json',
        dataType: "json",
        success: function(data, status, jqXHR) {

            if (data.resp == 'success') {
                console.log('SUCCESSFUL SUBMISSION!! Notifying');
                
                var popupDiv = '<div class="modalBackground"></div><div id="addressModal" owner="submitButton" class="modal">';
                popupDiv += '<div class="modalHeader" name="modalHeader"><div><span class="modalHeaderText">THANK YOU!!</span></div></div>';
                popupDiv += '<div class="modalBody" name="modalBody">';
                popupDiv += '<p>Your submission was successfully submitted!</p>';
                popupDiv += '<p class="submissionId">Submission ID: ' + data.message + '</p><br/><br/>';
                popupDiv += '<p><button type="button" onclick="javascript:window.location.replace(\'http://localhost:8080/campaigns/' + data.campaignId + '\');">OKAY</button></p>';
                popupDiv += '</div></div>';
                $('body').append(popupDiv);
            } 
            else  {
                console.log('SUBMISSION FAILED!! Notifying');

                var popupDiv = '<div class="modalBackground"></div><div id="addressModal" owner="submitButton" class="modal">';
                popupDiv += '<div class="modalHeader" name="modalHeader"><div><span class="modalHeaderText">ATTENTION!!</span></div><div><a href="#" id="addressModalClose" class="modalClose">X</a></div></div>';
                popupDiv += '<div class="modalBody" name="modalBody">';
                popupDiv += '<p>There was a problem processing your submission 1. Please try again!</p><p class="submissionId">' + data.message + '<p>';
                popupDiv += '</div></div>';
                $('body').append(popupDiv);
            }
        },
        error: function(jqXHR, status, errorThrown) {
            //There was an error. Maybe alert the user to try again!
                console.log(errorThrown);

                var popupDiv = '<div class="modalBackground"></div><div id="addressModal" owner="submitButton" class="modal">';
                popupDiv += '<div class="modalHeader" name="modalHeader"><div><span class="modalHeaderText">ATTENTION!!</span></div><div><a href="#" id="addressModalClose" class="modalClose">X</a></div></div>';
                popupDiv += '<div class="modalBody" name="modalBody">';
                popupDiv += '<p>There was a problem processing your submission 2. Please try again!</p><p class="submissionId">' + errorThrown + '<p>';
                popupDiv += '</div></div>';
                $('body').append(popupDiv);
        }
    });
}

function fetchInputValue(element) {

    if ( $(element).attr('type') == 'checkbox' && $(element).attr('submitsValue') ) {
        if ( $(element).is(':checked') ) return "YES";
        else return "NO";
    }
    else if ( $(element).closest('div').hasClass('MMimagePicker') || $(element).closest('div').hasClass('MMradioControl') ) {
        var tmp = $(element).attr('name');
        $('input[name="' + tmp +'"]').each(function(){
            if ( $(this).is(':checked') ) { 
                isChecked = true;
                return $(this).val();
            }
        });

        return null;
    }
    else if ( !$(element).val() ) {
        return null;
    }
    else if ( $(element).val() ) {
        return $(element).val();
    }


}

function fetchInputName(element) {
 
    var sname = $(element).attr('submitName');
    if(sname) return sname;

    sname = $(element).attr('name');
    if(sname) return sname;

    console.log('NO SUBMIT NAME FOUND');
    return null;
}


function setNavLineHeight(amt) {
    $('.circleIcon').css('top', amt - 40);
    $('.reached').css('height', amt);
}


function populateWarnings (element) {

    if($(element).hasClass('error')) {
        if($('div[inputname="'+$(element).attr('name')+'"]').length == 0) {
            var text = $(element).prev().children('span').text();
            if(text === undefined || text == '' ) {
                text = $(element).attr('placeholder');
            }

            $('.errorSection').append('<div class="errorDiv" inputName="'+$(element).attr('name')+'"><span>'+text+'</span><span>TAP HERE</span></div>');
            $('.errorList').append('<div class="errorCircle" inputname="'+$(element).attr('name')+'"></div>');
            $('.errorCircle[inputname="'+$(element).attr('name')+'"]').css('top', $('.lineBar').height() * $(element).offset().top / $(document).height() - 40);
        }
    }
    else {
       if($('div[inputname="'+$(element).attr('name')+'"]').length != 0) {
            $('div[inputname="'+$(element).attr('name')+'"]').remove();
       }
    }

}

function populateFormWithJSON(obj) {
    for (var item in obj) {
        var obj = $('#'+ item + " select[name='" + item + "']:first");
        if (obj.length !== 0) {
            $(obj).val(obj[item]);
        }
        else {
            obj = $('#'+ item + " input[name='" + item + "']");
            if (obj.length !== 0) {
                if( obj.length > 1) {
                    //This is some radio option, iterate to find the value to check:
                    var value = obj[item].toLowerCase();
                    obj.each(function(idx){
                        if( $(this).val().toLowerCase() == value) {
                            $(this).prop("checked", true);
                            return false;
                        } 
                    });
                }
                else {
                    $(obj[0]).val(obj[item]); 
                }
            }
            else {
                switch(item) {
                    case 'city':
                    case 'postalCode':
                        obj = $("#address1 input[name='" + item + "']");
                        if (obj.length !== 0) {
                            $(obj[0]).val(obj[item]); 
                        }
                        break;  
                    case 'stateProv':
                        obj = $("#address1 select[name='" + item + "']:first");
                        if (obj.length !== 0) {
                            $(obj).val(obj[item].toUpperCase());
                        }
                        break;
                    default:
                        console.log("SKIPPING: " + item);
                        break;
                }
            }           
        }           
    }
}

function populateSignatureFromPath(path) {
    var now = new Date().getTime();
    var element = path.split('__')[1];
    
    path += '.png?' + now;
    console.log('POPULATING SIGNATURE: ' + path);

    $('#' + element + ' .signBox').html('<span><img src="http://localhost:8080/signatures/' + path + '"></img></span>');
    $('#' + element).attr('signed',true);

    $('#' + element + ' .signBox').removeClass('error');
}

//Bridge between iOS and Javascript context:

document.addEventListener('ScannerDidCaptureInfo',function(e){
    populateFormWithJSON(e.detail);
},false);

document.addEventListener('SignaturePanelDidCaptureSignature',function(e){
    populateSignatureFromPath(e.detail.path);
},false);

document.addEventListener('ResetSignaturePanel',function(e){

    var path = e.detail.path;
    var element = path.split('__')[1];
    
   $('#' + element + ' .signBox').html('<span>TAP HERE TO SIGN</span>');
   $('#' + element).attr('signed',false);

    $('#' + element + ' .signBox').removeClass('error');
},false);


$(document).ready(function() {

    var documentURI = window.location.href.split('/');
    var campaignId = documentURI[4];
    //Bind the onclick submit even to submit under this campaignId:
    $('#submitButton').on("click",function(){
        submitForm(campaignId);
    });
    //Bind the form_menu back button to go back to correct campaign dashboard: 
    $('.form_menu').click(function(){
        window.location.replace('http://localhost:8080/campaigns/' + campaignId);
    });
    //Re-route all campaign asset images to load for the proper campaign:
    $('.campaignAsset').each(function(){
        var tmp = $(this).attr('src');
        $(this).attr('src','images/' + campaignId + '/' + tmp);
    });
    //Inject the campaignId into the campaignId form field:
    $('#campaignId').val(campaignId);


    if( documentURI.length < 6 ) {
        //If this is a new submission, create a new UUID for this submission:
        $('#submissionId').val(generateUUID());
        console.log('documentURI of size < 6: ' + documentURI);
    }
    else {
        console.log('documentURI of size >= 6: ' + documentURI);
        //If this is an existing submission, use it and repopulate form:
        var submissionId = documentURI[5];
        $('#submissionId').val(submissionId);
        //Do an ajax request to fetch the entire submission from disk and populate the fields:
        $.ajax({
           url: "http://localhost:8080/submissions/" + submissionId,
           type: 'GET',
           dataType: "json",
           success: function(data, status, jqXHR) {
                
                populateFormWithJSON(data.contents);
                
                for (var i = 0 ; i < data.signatures.length; i++) {
                     populateSignatureFromPath(data.signatures[i]);
                };
           },
           error:  function(jqXHR, status, errorThrown) {
                console.log(errorThrown);
                //Show the user the partial submission couldn't be retrieved?
           }
        });
    }

    //USE THIS TO FORCE THE SUBMISSION INTO A SPECIFIC VALUE, USE FOR TESTING ALONG WITH HARDCODED SIGNATURES:
    //$('#submissionId').val('26ea2448-d9f0-4e3f-8918-0ecc0175c358');
    
    console.log('Submission ID: ' + $('#submissionId').val());
    console.log('Campaign ID: ' + $('#campaignId').val());

    var dragging = false;
    $('.HTMLPage:last-of-type').css('height', $(document).height());

    document.addEventListener('touchmove', processScroll, false);
    //document.addEventListener('mousemove', processMouse, false);

    $(document).on('scroll', function(e) {
        $('.HTMLPage:last-of-type').css('height', $('.HTMLPage:last-of-type').height()-50).css('height', $(document).height());

        if(!dragging) {
            var amt = Math.floor($('.lineBar').height() * $(window).scrollTop() / $(document).height());
            setNavLineHeight(amt);

            $('.circleIcon').css('top', ($('.lineBar').height() * $(window).scrollTop() / $(document).height()) - 5.0);
        }


        $('#sidePanel').css('left', -($(window).scrollLeft()));
        if($(window).scrollTop() < 420) { // height of top bar (don't scroll under it)
            $('#sidePanel').css('top', 418 - $(window).scrollTop());
        }
        else {
            $('#sidePanel').css('top', 0);
        }

        if(dragging) {
            e.preventDefault();
        }
    });

    $('.circleIcon').on('mousedown', stopScrollView);
    $('.circleIcon').on('touchstart', stopScrollView);
    $('html').on('mouseup', startScrollView);
    $('.circleIcon').on('touchend', startScrollView);

    
    function generateUUID() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
                var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
                return v.toString(16);
                });
    }

	function processMouse(e) {
		console.log('Implement desktop behaviour');
	}

    function processScroll(e) {
         if(dragging) { //stop touch events on touch devices & move page/button to correct position
            var touch = e.touches[0];
            //console.log(touch.pageY);
            if(touch.pageY - $('.lineBar').offset().top  >= 0 && touch.pageY - $('.lineBar').offset().top <= $('.lineBar').height() - 40.0) {
                setNavLineHeight(touch.pageY - $('.lineBar').offset().top);
                $('.circleIcon').css('top', touch.pageY - $('.lineBar').offset().top - 40);

                if($(document).height() * $('.circleIcon').position().top / $('.lineBar').height() >= 420) {
                   // $('body').scrollTop($(document).height() * $('.circleIcon').position().top / $('.lineBar').height()+ 200);
                }
                else {
                    $('body').scrollTop(420);
                }
            }
            e.preventDefault();
         }
    }

    function stopScrollView(e){
        dragging = true;
        $('html, body').css({
            'overflow': 'hidden'
        });
    }

    function startScrollView(e){
      if(dragging) {

        $('body').scrollTop($(document).height() * $('.circleIcon').position().top / $('.lineBar').height()+ 200);
        $('html, body').css({
                'overflow': 'auto'
        });

        dragging = false;
      }
    }

    $(document).on('focus', 'input', function(e) {
        var tmp = $(this).attr('validation');
        if( tmp != 'canadianPostalCode') {
            $(this).removeClass("success").removeClass("error"); 
            var name = $(this).attr('name');
            if(name) {
                $('input[name="' + name +'"]').removeClass("success").removeClass("error"); 
            }
        }
    });

    $(document).on('blur', 'input', function(e) {
        populateWarnings(this);
        saveExistingForm();
    });

    $('.errorSection').on('click', '.errorDiv', function(e) {
        $('html, body').animate({scrollTop: $('input[name="'+$(this).attr('inputname')+'"]').offset().top - 200}, 1000);
    });

    $('.lineBar').on('click', function(e) {
        var pos = e.pageY - $('.lineBar').offset().top;
        $('html, body').animate({scrollTop: $(document).height() * pos / $('.lineBar').height() + 200}, 1000);
    }).children('.circleIcon').click(function(e) {return false});

    $(document).on('click', '#addressModal :button, #addressModalClose', function (e) {
        var owner = $('#addressModal').attr('owner')
        if (this.id != "addressModalClose") {
            validateMoniker(owner, this.id)
        }
        $('#addressModal').remove()
        $('.modalBackground').remove()
    })

    $('.MMaddressField').keyup(function(e) {
        $('#'+e.currentTarget['id']+' :button').removeClass("validated")
        $('#'+e.currentTarget['id']+' :input[name="address1"]').removeClass('success').removeClass('error')
        $('#'+e.currentTarget['id']+' :input[name="address2"]').removeClass('success').removeClass('error')
        $('#'+e.currentTarget['id']+' :input[name="address3"]').removeClass('success').removeClass('error')
        $('#'+e.currentTarget['id']+' .dropdown').removeClass('success').removeClass('error')
        $('#'+e.currentTarget['id']+' :input[name="city"]').removeClass('success').removeClass('error')
    })

    $('.MMaddressField').change(function(e) {
        $('#'+e.currentTarget['id']+' :button').removeClass("validated")
        $('#'+e.currentTarget['id']+' :input[name="address1"]').removeClass('success').removeClass('error')
        $('#'+e.currentTarget['id']+' :input[name="address2"]').removeClass('success').removeClass('error')
        $('#'+e.currentTarget['id']+' :input[name="address3"]').removeClass('success').removeClass('error')
        $('#'+e.currentTarget['id']+' .dropdown').removeClass('success').removeClass('error')
        $('#'+e.currentTarget['id']+' :input[name="city"]').removeClass('success').removeClass('error')
    })
});