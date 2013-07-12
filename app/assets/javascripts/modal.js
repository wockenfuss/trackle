(function($, undefined) {
	$(document).ready(function() {
		$.rails.allowAction = function(link) {
			if ( link.attr('data-confirm') === undefined ) {
				return true;
			} else {
				$.rails.showConfirmDialog(link);
				return false;
			}
		};

		$.rails.confirmed = function(link) {
			link.removeAttr('data-confirm');
			link.trigger('click.rails');
		};

		$.rails.showConfirmDialog = function(link) {
			message = link.attr('data-confirm');
		  html = '<div id="dialog-confirm" title="Confirmation Required">' + 
		           '<p>' + message + '</p></div>';
		  $('body').prepend(html);
		  $('#dialog-confirm').dialog({
			  draggable: false,
	      closeText: 'X',
		  	resizable: false,
		    modal: true,
		    buttons: {
		      OK: function() {
		      	$.rails.confirmed(link);
		        $(this).dialog("close");
		      },
	        Cancel: function() {
		        $(this).dialog("close");
	        }
		    }
		  });
		};
	});

})(jQuery);