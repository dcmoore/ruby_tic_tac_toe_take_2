$(document).ready(function() {	
	$("select#ai2").attr("disabled","disabled");
	
	$("select").change(function () {
		var player_options = $("select#players option:selected").val();
	
		if(player_options == "pvp") {
			$("select#ai1").attr("disabled","disabled");
			$("select#ai2").attr("disabled","disabled");
			$("select#team").attr("disabled","disabled");
		}
		else if(player_options == "pvc") {
			$("select#ai1").removeAttr('disabled');
			$("select#ai2").attr("disabled","disabled");
			$("select#team").removeAttr('disabled');
		}
		else if(player_options == "cvc") {
			$("select#ai1").removeAttr('disabled');
			$("select#ai2").removeAttr('disabled');
			$("select#team").attr("disabled","disabled");
		}
	});
	
	for(square = 0; square < 16; square++) {
		armCellForClick(square);
	}
});

function armCellForClick(square) {
	var cell = $("td#" + square);

	cell.click(function() {
		window.location = "/index?move=" + square;
	});	
}