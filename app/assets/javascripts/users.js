(function(myApp, $, undefined) {
	$.extend(myApp, {
		Users: function( selector ) {
			var $target = $(selector);

			var rowSize = function() {
				var length = 0;
		    var top = $('.userBox').first().position().top;
		    $.each($('.userBox'), function(index, value) {
		    	if ($(value).position().top !== top ) {
		    		return length;
		    	} else {
		    		length++;
		    	}
		    });
		   	return length;
			};

			var rowPosition = function(user) {
				var index = $('.userBox').index(user);
				var rowPosition = Math.floor(index / rowSize());
				return rowPosition * rowSize();
			};

			var addListener = function() {
				$target.on('click', function(e) {
		   		var userId = $(this).attr('data-user');
		   		var appendLocation = rowPosition(this);
		   		var data = {
		   			appendLocation: appendLocation
		   		};
		   		$.ajax({
		   			url: "/users/" + userId,
		   			type: "get",
		   			dataType: "script",
		   			data: data,
		   			success: function(result) {
		   				if ( $('#userDisplay').is(':hidden') ) {
		   					$('#current').next().find('.assignmentDetails').show();
		   				}
		   				$('#userDisplay').slideToggle()
		   			}
		   		})
		   	});
		   	return myApp.Users($target);
			};

			var refresh = function() {
				setColor();
				addListener();
				droppable();
			};

			var droppable = function() {
				$target.droppable({
		      hoverClass: "ui-state-hover",
		      tolerance: "pointer",
		      drop: myApp.drop
		    });
		    return myApp.Users($target);
			};

			var setColor = function() {
				$.each($target, function(index, value) {
					var interiorColor = $(value).attr('data-taskColor');
					var boxColor = $(value).attr('data-color');
					$(value).css('border-color', boxColor);
					// $(value).css('background-color', interiorColor);
					// $(value).find('.cityStripe').css('background-color', boxColor);
				});
				return myApp.Users($target);
			};
			return {
				refresh: refresh
			};
		}
	});
})(myApp = window.myApp || {}, jQuery);