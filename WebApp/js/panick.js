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
var anxietyLevel = "test";
var cause = "test";
var depressionLevel = "test";
var expected = "test";
var startDate = "test";
//medication
var medicationName = "test";
var medicationID = "test";
//symptom
var symptomName = "test";

var medsAndObs = "test";
var count = 4;

var userNameArray = new Array();
var users = new Array();
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
                users.push(object.id);
                userName = object.get('firstName') + " " + object.get('lastName');
                email = object.get('email');
                var objDate = new Date(object.get('birthDate'));
                birthDay = objDate.getMonth() + "/" + objDate.getDate() + "/" + objDate.getFullYear();
                $.when(this, addPatients());
               // userNameArray.fill(document.getElementsByName(userName).valueOf());
            }
        },
        error: function(error) {
            status.error("Error: " + error.code + " " + error.message);
        }
    });
    //parse Medication
    var userMedication = Parse.Object.extend("Medication");
    var queryMedication = new Parse.Query(userMedication);
    var medicationIdArray = new Array();
    queryMedication.find({
        success:function(results){
            console.log(results.length);
            for (var i = 0; i<results.length; i++){
                var object = results[i];
                medicationName = object.get('name');
                medicationIdArray.push( object.id);
            }
        }
    });

    //parse Symptom
    var userSymptom = Parse.Object.extend('Symptom');
    var querySymptom = new Parse.Query(userSymptom);
    var symptomIdArray = new Array();
    querySymptom.find({
        success: function(results){
            console.log(results.length);
            for(var i = 0; i< results.length; i++){
                var object = results[i];
                symptomName = object.get('name');
                symptomIdArray.push(object.id);
            }
        }
    });

    //parse for Event
    function retriveEventForUser(userId)
    {
        var userEvent = Parse.Object.extend("Event");
        var queryEvent = new Parse.Query(userEvent);
        //queryEvent.equalTo('user',users[0]);
        queryEvent.find({
            success: function(results) {
                console.log(results.length);
                // Do something with the returned Parse.Object values
                for (var i = 0; i < results.length; i++) {
                    var object = results[i];
                    console.log(results[i]);
                    observations = object.get('observations');
                    anxietyLevel = object.get('anxietyLevel');
                    cause = object.get('cause');
                    depressionLevel = object.get('depressionLevel');
                    expected = object.get('expected');
                    var objDateEv = object.get('startDate');
                    startDate = objDateEv.getMonth() + "/" + objDateEv.getDate() + "/" + objDateEv.getFullYear();

                }
            },
            error: function(error) {
               // status.error("Error: " + error.code + " " + error.message);
            }
        });
    }
    //console.log(retriveEventForUser("LTUE6Jvo62"));
    //console.log(queryEvent.containsAll('medications', medicationIdArray));

    function addPatients () {
        $('#userTable tbody').append(
            '<tr></tr> <td><img src="' + randomImg() + '" alt="">' +
            ' <button type="button" class="btn btn-link" data-toggle="modal" data-target="#myModal"><span  id="userName' + count + '" name="' + userName + '">' + userName + '</span></button>' +
            '</td><td id="lastTimeAttack' + count + '">' + lastTimeAttack + '</td><td class="text-center"><span class="text-center" id="birthDay' + count + '">' + birthDay + '</span>' +
            '</td><td class="text-center"><a href="#" id="userEmail' + count + '">' + email + '</a></td>' +
            '<td class="text-center"><button id="toggle'+count+'" data="'+count+'" class="toggle btn btn-xs btn-info"> Details </button>' +
            '<div class="target" style="display: none;" id="details'+count+'">'+medsAndObs+' </div></tr>'
        );
        count++;

        $(".toggle").on("click",function(){
            //debugger;
            var data = $(this).attr("data");
            var $target = $("#details" + data),
                $toggle = $(this);
            $target.toggle( 500, function () {
                $toggle.text(($target.is(':visible') ? 'Details' : 'Details'));

            });
        });
    }

    userNameArray.fill(document.getElementsByName('userName').valueOf());
    $( "#search" ).autocomplete({
        source: userNameArray
    });


});
      function randomImg(){
        var images = ['img/user_1.jpg', 'img/user_2.jpg', 'img/user_3.jpg'];
          return images[Math.floor(Math.random() * images.length )];
    }
        //console.log(imgSource);
function populateUserProfile(){
}

var data = {
    labels: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
    datasets: [
        {
            label: "First dataset",
            fillColor: "rgba(220,220,220,0.2)",
            strokeColor: "rgba(220,220,220,1)",
            pointColor: "rgba(220,220,220,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(220,220,220,1)",
            data: [120, 125, 140, 131, 129, 150, 146]
        },
        {
            label: "Second dataset",
            fillColor: "rgba(151,187,205,0.2)",
            strokeColor: "rgba(151,187,205,1)",
            pointColor: "rgba(151,187,205,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(151,187,205,1)",
            data: [119, 130, 114, 125, 146, 137, 120]
        }
    ]
};