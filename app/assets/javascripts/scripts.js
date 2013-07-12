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
      helper: "clone"
    });

    $('.userBox').on('click', function(e) {
    	var userId = $(this).attr('data-user');
    	var url = "/users/" + userId;
    	console.log(url);
    	myApp.userModal();
    	$.ajax({
    		url: url,
				dataType: 'script',
				type: 'get',
				success: function(result) {
					// console.log(result);	
				}
    	});

    	$('#dialog-form').dialog("open");
    });

    $( ".droppable" ).droppable({
      // activeClass: "ui-state-default",
      hoverClass: "ui-state-hover",
      // accept: ":not(.ui-sortable-helper)",
      drop: function( event, ui ) {
      	var task = ui.draggable.attr('data-task');
      	var city = ui.draggable.attr('data-city');
      	var user = $(event.target).attr('data-user');
        $(this).removeClass('available')
        				.addClass('occupied');
        // $( "<li></li>" ).text( ui.draggable.text() ).appendTo( this );
        //ajax call to create assignment
        var data = {
        	assignment: {
        		task_id: task,
        		city_id: city,
        		user_id: user
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
      }
    })
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
			var top = $dropdown.position().top;
			var left = $dropdown.position().left + $dropdown.width() + 15;
			$menu.css('top', top);
			$menu.css('left', left);
			// var position = 
		}
		
		$menu.show();

		$dropdown.on('mouseleave', function(e) {
			$dropdown.find('.dropdownMenu').hide();
			$dropdown.off('mouseleave');
			$('.dropdown a').on('mouseenter', myApp.dropdown);
		})
	};

	myApp.userModal = function() {
		$( "#dialog-form" ).dialog({
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