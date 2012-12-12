$(document).ready( function () {

	function chgt (e) {
		e.preventDefault();
		$(this).fadeOut("slow");
	}

	$("nav h1").bind("click", chgt);
});