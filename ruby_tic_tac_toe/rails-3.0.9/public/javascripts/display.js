$(document).ready(function() {	
	$("select#ai2").attr("disabled","disabled");
    setOptionsToSelectedOptionsFromLastPage();
	
	$("select").change(function () {
		var playerOptions = $("select#players option:selected").val();
	
		if(playerOptions == "pvp") {
			$("select#ai1").attr("disabled","disabled");
			$("select#ai2").attr("disabled","disabled");
			$("select#team").attr("disabled","disabled");
		}
		else if(playerOptions == "pvc") {
			$("select#ai1").removeAttr('disabled');
			$("select#ai2").attr("disabled","disabled");
			$("select#team").removeAttr('disabled');
		}
		else if(playerOptions == "cvc") {
			$("select#ai1").removeAttr('disabled');
			$("select#ai2").removeAttr('disabled');
			$("select#team").attr("disabled","disabled");
		}
	});
	
	for(square = 0; square < 16; square++) {
		armCellForClick(square);
	}
});

function setOptionsToSelectedOptionsFromLastPage() {
    var temp = $("html").html().split("***");
    var arrayOfOptions = temp[1].split(",");
        
    $("select#board_size").val(arrayOfOptions[0]);
    $("select#rules").val(arrayOfOptions[1]);
    $("select#players").val(arrayOfOptions[2]);
    $("select#team").val(arrayOfOptions[3]);
    $("select#ai1").val(arrayOfOptions[4]);
    $("select#ai2").val(arrayOfOptions[5]);
}

function armCellForClick(square) {
	var cell = $("td#" + square);

	cell.live("click", function() {
		$("#board_con").load("/index?move="+square+" #board_con")
	});
}