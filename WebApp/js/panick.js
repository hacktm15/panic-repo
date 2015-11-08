/**
 * Created by Alin on 11/7/2015.
 */
//--------------DbFieldsMapping------------
//patient
var userName = "test";
var lastTimeAttack = "test";
var birthDay = "test";
var email = "test";
//events
var observations = "test";
var medicationsID = "test";
var symptomsID = "test";
var anxietyLevel = "test";
var cause = "test";
var depressionLevel = "test";
var expected = "test";
var startDate = "test";
//medication
var medicationName = "test";
//symptom
var symptomName = "test";

var count = 4;

var userNameArray = new Array();
function getFormatedDate(object) {
    var objDate = new Date(object);
     var dbDate = objDate.getMonth() + "/" + objDate.getDate() + "/" + objDate.getFullYear();
    return dbDate;
}
$(document).ready(function(){
    //parse for patient
    Parse.initialize("cx8RDcpcylmUJ4jX9FEjrZAlBSy0WGx7RN8VLSvT", "2OL1B1mmqwTyJijH1yPVppGzogRnJLPiaVN64LAE");
    var usersName = Parse.Object.extend("Patient");
    var queryPatient = new Parse.Query(usersName);
    queryPatient.find({
        success: function(results) {
            // Do something with the returned Parse.Object values
            for (var i = 0; i < results.length; i++) {
                var object = results[i];
                userName = object.get('firstName') + " " + object.get('lastName');
                email = object.get('email');
                birthDay = getFormatedDate(object);
                $.when(this, addPatients());
               // userNameArray.fill(document.getElementsByName(userName).valueOf());
            }
        },
        error: function(error) {
            status.error("Error: " + error.code + " " + error.message);
        }
    });

    //parse for userDetails
    var userDetails = Parse.Object.extend("Event");
    var queryEvent = new Parse.Query(userDetails);
    queryEvent.find({
        success: function(results) {
            console.log(results.length);
            // Do something with the returned Parse.Object values
            for (var i = 0; i < results.length; i++) {
                var object = results[i];
                observations = object.get('observations');
                anxietyLevel = object.get('anxietyLevel');
                cause = object.get('cause');
                depressionLevel = object.get('depressionLevel');
                expected = object.get('expected');
                startDate = object.get('startDate');
            }
            },
        error: function(error) {
            status.error("Error: " + error.code + " " + error.message);
        }
    });

    function addPatients () {
        $('#userTable tbody').append(
            '<tr></tr> <td><img src="' + randomImg() + '" alt="">' +
            ' <button type="button" class="btn btn-link" data-toggle="modal" data-target="#myModal"><span  id="userName' + count + '" name="' + userName + '">' + userName + '</span></button>' +
            '</td><td id="lastTimeAttack' + count + '">' + lastTimeAttack + '</td><td class="text-center"><span class="text-center" id="birthDay' + count + '">' + birthDay + '</span>' +
            '</td><td class="text-center"><a href="#" id="userEmail' + count + '">' + email + '</a></td>' +
            '</tr>'
        );
        count++;
    }

    userNameArray.fill(document.getElementsByName('userName').valueOf());
    $( "#search" ).autocomplete({
        source: userNameArray
    });

    $("#toggle").click(function(){
        var $target = $('.target'),
            $toggle = $(this);

        $target.slideToggle( 500, function () {
            $toggle.text(($target.is(':visible') ? 'Details' : 'Details'));

        });
    });
});
      function randomImg(){
        var images = ['img/user_1.jpg', 'img/user_2.jpg', 'img/user_3.jpg'];
          return images[Math.floor(Math.random() * images.length )];
    }
        //console.log(imgSource);
