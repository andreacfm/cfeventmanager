function toggleItems(it){
	$("#"+it).slideToggle('fast');
} 

$(document).ready(function(){
	
	$('.ajax').click(function(e){
		e.preventDefault();
		$('#main').html('<img href="/eventmanager/samples/assets/images/loading.gif"/>');
		$('#main').load($(this).attr('href'));
	});
	
})
