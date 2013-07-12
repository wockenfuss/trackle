(function(myApp, $, undefined) {
	$(document).ready(function() {
		bind();
	});

	var bind = function() {
		$('#flash_alert, #flash_error, #flash_notice').fadeIn('normal', function() {
			$(this).delay(2500).fadeOut('slow');
		});

		$('.dropdown a[href="#"]').on('click', function(e) {
			e.preventDefault();
		});

		$('.dropdown a').on('mouseenter', myApp.dropdown); 

		$( ".draggable" ).draggable({
      appendTo: "body",
      cursorAt: {top: 0, left: 0},
      helper: "clone"
    });

    $('.userBox').on('click', function(e) {
    	var userId = $(this).attr('data-user');
    	$.ajax({
    		url: "/users/" + userId,
				dataType: 'script',
				type: 'get',
				success: function(result) {
					// console.log(result);	
				}
    	});

    	$('#user-modal').dialog("open");
    });

    $( ".droppable" ).droppable({
      hoverClass: "ui-state-hover",
      tolerance: "pointer",
      drop: myApp.drop
    });

    myApp.taskModal();
   	myApp.userModal();
	};

	myApp.drop = function( event, ui ) {
		$('#task-modal').dialog("open");
    //ajax call to create assignment
    var data = {
    	assignment: {
    		task_id: ui.draggable.attr('data-task'),
    		city_id: ui.draggable.attr('data-city'),
    		user_id: $(event.target).attr('data-user')
    	}
    };
    $.ajax({
			url: '/assignments',
			dataType: 'script',
			type: 'post',
			data: data,
			success: function(result) {
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
			var top = $dropdown.position().top + $dropdown.height() - 3;
			var left = $dropdown.position().left + 10;
			$menu.css('width', $dropdown.width() - 30);
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

	myApp.taskModal = function() {
		$( "#task-modal" ).dialog({
			closeText: 'X',
      autoOpen: false,
      height: 400,
      width: 500,
      modal: true,
      draggable: false,
      buttons: {
        Cancel: function() {
          $( this ).dialog( "close" );
        }, 
        "Assign Task": function() {
        	
        }
      },
      close: function() {
        // allFields.val( "" ).removeClass( "ui-state-error" );
      }
    });
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
        Cancel: function() {
          $( this ).dialog( "close" );
        }
      },
      close: function() {
        // allFields.val( "" ).removeClass( "ui-state-error" );
      }
    });
	};
		




})(window.myApp = window.myApp || {}, jQuery);