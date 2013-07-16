(function(myApp, $, undefined) {
	$(document).ready(function() {
		bind();
	});



	var bind = function() {
		$('.colorPicker').minicolors();
		myApp.setCityColor();
		myApp.setTaskColor();
		myApp.setTaskProgress();

		myApp.setFlashAlerts();
		myApp.setDropdowns();
		myApp.draggable(".draggable");
		myApp.droppable('.droppable');
    myApp.taskModal();
   	myApp.userModal();
   	myApp.taskDisplay();
   	$('#announcements span').on('click', function(e) {
   		$(e.target).parent().find('#announcementInterior').slideToggle();
   	})

   	myApp.Users('.userBox').refresh();


	};

	myApp.addAssignmentListeners = function() {
		$('.assignmentName').on('click', function(e) {
   		e.preventDefault();
   		// console.log(e.target);
   		$(e.target).parent().find('.assignmentDetails').slideToggle();
   	});
	};

	myApp.setDropdowns = function() {
		$('.dropdown a[href="#"]').on('click', function(e) {
			e.preventDefault();
		});

		$('.dropdown a').on('mouseenter', myApp.dropdown); 
	}

	myApp.setFlashAlerts = function() {
		$('#flash_alert, #flash_error, #flash_notice').fadeIn('normal', function() {
			$(this).delay(2500).fadeOut('slow');
		});
	}

	myApp.draggable = function( selector ) {
		$(selector).draggable({
      appendTo: "body",
      cursorAt: {top: 0, left: 0},
      helper: "clone"
    });
	};

	myApp.droppable = function( selector ) {
		$(selector).droppable({
      hoverClass: "ui-state-hover",
      tolerance: "pointer",
      drop: myApp.drop
    });
	};

	myApp.drop = function( event, ui ) {
    //ajax call to create assignment
    var data = {
    	assignment: {
    		task_id: ui.draggable.attr('data-task'),
    		city_id: ui.draggable.attr('data-city'),
    		user_id: $(event.target).attr('data-user')
    	}
    };
    $.ajax({
			url: '/assignments/new',
			dataType: 'script',
			type: 'get',
			data: data,
			success: function(result) {

				// $('#task-modal').dialog("open");

				// console.log(result);	
			}
		});
	};

	myApp.dropdown = function(e) {
		$trigger = $(e.target);
		$dropdown = $(e.target).parent();
		$menu = $dropdown.find('.dropdownMenu');

		$('.dropdown a').off('mouseenter');

		if ( $dropdown.hasClass('navbar') ) {
			var position = $trigger.position().left + $trigger.width() - $menu.width() + parseInt($trigger.css('margin-right'), 10) - 10;
			$menu.css('left', position);
		} else {
			var top = $dropdown.position().top + $dropdown.height() + 10;
			var left = $dropdown.position().left + 10;
			$menu.css('width', $dropdown.width());
			$menu.css('top', top);
			$menu.css('left', left);
		}
		
		$menu.show();

		$dropdown.on('mouseleave', function(e) {
			$dropdown.find('.dropdownMenu').hide();
			$dropdown.off('mouseleave');
			$('.dropdown a').on('mouseenter', myApp.dropdown);
		})
	};

	myApp.setCityColor = function() {
		//city name bar color
		var $city = $('.cityName');
		var cityColor = $city.attr('data-color');
		$city.css('background-color', cityColor);

		//dropdown colors
		$.each($('.cityName li'), function( index, value ) {
			var color = $(value).attr('data-color');
			$(value).css('background-color', color);
		});

	};

	myApp.setTaskColor = function(index, value) {
		$.each($('.taskBox'), function(index, value) {
			var color = $(value).attr('data-taskColor');
			$(value).css('background-color', color);
			myApp.setTaskProgress(index, value);
		});
	};

	myApp.setTaskProgress = function(index, value) {
		var taskProgress = $(value).find('.taskProgress').first().text().replace(/\s+/g, '').split('/');
		var percentage;
		if ( taskProgress[1] === "0" ) {
			percentage = 100;
		} else {
			percentage = (taskProgress[0] / taskProgress[1]) * 100;
		}
		$(value).find('.completeTasks').css('width', percentage + "%");
	}

	myApp.taskModal = function() {
		$( "#task-modal" ).dialog({
			closeText: 'X',
      autoOpen: false,
      height: 400,
      width: 500,
      modal: true,
      draggable: false,
      buttons: {
      	// "Assign Task": function() {
       //  	$( this ).dialog( "close" );
       //  },
        // Cancel: function() {
        //   $( this ).dialog( "close" );
        // }
      },
      close: function() {
        // allFields.val( "" ).removeClass( "ui-state-error" );
      }
    });
	};

		myApp.taskDisplay = function() {
		$( "#task-display" ).dialog({
			closeText: 'X',
      autoOpen: false,
      height: 600,
      width: 600,
      modal: true,
      draggable: false,
      buttons: {

      },
      close: function() {
        // allFields.val( "" ).removeClass( "ui-state-error" );
      }
    });

    myApp.bindTaskDisplay('.taskBox');
	};

	myApp.userModal = function() {
		$( "#user-modal" ).dialog({
			closeText: 'X',
      autoOpen: false,
      height: 600,
      width: 600,
      modal: true,
      draggable: false,
      buttons: {
        "OK": function() {
          $( this ).dialog( "close" );
        }
      },
      close: function() {
        // allFields.val( "" ).removeClass( "ui-state-error" );
      }
    });

		// myApp.bindUserModal('.userBox');
	};
	
	myApp.bindUserModal = function( selector ) {
		$(selector).on('click', function(e) {
    	var userId = $(this).attr('data-user');
    	$.ajax({
    		url: "/users/" + userId,
				dataType: 'script',
				type: 'get',
				success: function(result) {
					// console.log(result);	
		    	$('#user-modal').dialog("open");
				}
    	});

    });
	};

	myApp.bindTaskDisplay = function( selector ) {
		$(selector).on('click', function(e) {
			var taskId = $(this).attr('data-task');
			var cityId = $(this).attr('data-city');
			$.ajax({
				url: "/tasks/" + taskId,
				dataType: 'script',
				type: 'get',
				data: {
					city_id: cityId
				},
				success: function(result) {
					$('#task-display').dialog("open");
				}
			});

		});
	}




})(window.myApp = window.myApp || {}, jQuery);