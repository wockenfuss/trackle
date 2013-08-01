(function(myApp, $, undefined) {
	$(document).ready(function() {
		bind();
	});

	var bind = function() {
		myApp.setTimezone();

		myApp.setProjectColor();

		myApp.flashAlerts();
		myApp.setDropdowns();


    myApp.taskModal();

   	$('#announcements span').on('click', function(e) {
   		$(e.target).parent().find('#announcementInterior').slideToggle();
   	});

   	myApp.Users('.userBox').refresh();
   	myApp.Tasks('.taskBox').refresh();

   	$('.deleteButton').on('click', function(e) {
   		$(this).parent().remove();
   	});

   	myApp.setListeners();


	};

	myApp.setListeners = function() {
		$('.formDisplayLink').off('click').on('click', function(e) {
   		$(this).next().slideToggle();
   	});

   	$('.resourceList h2').off('click').on('click', function(e) {
   		$(this).next().slideToggle();
   	});

   	$('.projectGroupName').off('click').on('click', function(e) {
   		$(this).next().slideToggle();
   	});

   	$( ".datepicker" ).datepicker();
   	// $('.colorPicker').simpleColor();
		$('.colorPicker').minicolors();
		myApp.draggable(".draggable");
		myApp.droppable('.droppable');
		myApp.droppable('.droppableGroup');

		$('#project_completed').on('change', function(e) {
			var currentStatus = !this.checked;
			var confirmation = confirm("Are you sure you want to change the status of this project?");
			if ( confirmation ) {
				myApp.updateProjectCompletion(this);
			} else {
				this.checked = currentStatus;
			}
		});
	};

	myApp.updateProjectCompletion = function(checkbox) {
		var projectId = $(checkbox).attr('data-project');
		$.ajax({
			url: "/projects/" + projectId,
			type: "put",
			dataType: "script",
			data: {
				project: {
					completed: checkbox.checked
				}
			}
		})
	};

	myApp.alert = function( message ) {
		$('#alerts').html("");
		$('#alerts').append(message).fadeIn('slow');
		setTimeout(function() {
			$('#alerts').fadeOut('slow');
		}, 3000);
	}

	myApp.addAssignmentListeners = function() {
		$('.assignmentName').off('click');
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
		$('.dropdownProject').on('click', function(e) {
			var projectId = $(this).attr('data-project');
			var data = {
				project_id: projectId
			};
			$.ajax({
				url: '/',
				dataType: 'script',
				type: 'get',
				data: data
			});
		});
	}

	myApp.setTimezone = function() {
		var timezone = $(window).get_timezone();
		$.ajax({
			url: '/',
			type: 'get',
			dataType: 'json',
			data: {
				time_zone: timezone
			}
		});
	};

	myApp.flashAlerts = function() {
		$('#flash_alert, #flash_error, #flash_notice').fadeIn('normal', function() {
			$(this).delay(2500).fadeOut('slow');
		});
	}

	myApp.draggable = function( selector ) {
		$(selector).draggable({
			distance: 10,
      appendTo: "body",
      cursorAt: {top: 12, left: 30},
      // helper: "clone"
      helper: function() {
      	return $(this).find('.dragHandle').clone();
      }, 
      start: function(e, ui) {
      	$(ui.helper).addClass('ui-draggable-helper');
      }
    });
	};

	myApp.droppable = function( selector ) {
		if ( selector === ".droppableGroup" ) {
			$(selector).droppable({
				accept: ".groupDroppable",
	      hoverClass: "ui-state-hover",
	      tolerance: "pointer",
	      drop: myApp.addToTaskGroup
	    });
		} else {
			$(selector).droppable({
	      hoverClass: "ui-state-hover",
	      tolerance: "pointer",
	      drop: myApp.drop
	    });
		}
			
	};

	myApp.drop = function( event, ui ) {
		if ( ui.draggable.attr('data-task') ) {
			myApp.createAssignment(event, ui);
		} else if ( ui.draggable.attr('data-tasks') ) {
			myApp.addTaskGroupToProject(event, ui);
		} else if ( ui.draggable.attr('data-task-assign') ) {
			if ( $(event.target).attr('data-project') ) {
				myApp.addTaskToProject(event, ui.draggable.attr('data-task-assign'));
			}
		}
	};

	myApp.addTaskGroupToProject = function( event, ui ) {
		var tasks = ui.draggable.attr('data-tasks').split(" ");
		$.each(tasks, function( index, value ) {
			myApp.addTaskToProject( event, value );
		});
	};

	myApp.addTaskToProject = function( event, taskId ) {
		var projectId = $(event.target).attr('data-project');
		$.ajax({
			url: '/projects/' + projectId,
			dataType: 'script',
			type: 'put',
			data: {
				project: {
					task_id: taskId,
					update_type: 'add'
				}
			}
		});
	};

	myApp.addToTaskGroup = function( event, ui ) {
		var taskGroupId = $(event.target).attr('data-task_group');
		console.log(taskGroupId);
		var taskId = ui.draggable.attr('data-task-assign');
		console.log(taskId);
		$.ajax({
			url: '/tasks/' + taskId,
			type: 'put',
			dataType: 'script',
			data: {
				task_group_id: taskGroupId
			}
		});
	};

	myApp.createAssignment = function( event, ui ) {
    var data = {
    	assignment: {
    		task_id: ui.draggable.attr('data-task'),
    		project_id: ui.draggable.attr('data-project'),
    		user_id: $(event.target).attr('data-user')
    	}
    };
    $.ajax({
			url: '/assignments/new',
			dataType: 'script',
			type: 'get',
			data: data
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
			$menu.css('top', '50px');
		} else {
			var top = $dropdown.position().top + 17;
			var left = $dropdown.position().left + $dropdown.width() + 10;			
			// var top = $dropdown.position().top + $dropdown.height() + 12;
			// var left = $dropdown.position().left + 13;
			$menu.css('width', $dropdown.width());
			$menu.css('top', top);
			$menu.css('left', left);
		}
		
		$menu.slideToggle('fast');

		$dropdown.on('mouseleave', function(e) {
			$dropdown.find('.dropdownMenu').slideToggle('fast');
			$dropdown.off('mouseleave');
			$('.dropdown a').on('mouseenter', myApp.dropdown);
		})
	};

	myApp.setProjectColor = function() {
		//project name bar color
		var $project = $('.projectName');
		var projectColor = $project.attr('data-color');
		$project.css('background-color', projectColor);

		//dropdown colors
		$.each($('.projectName li'), function( index, value ) {
			var color = $(value).attr('data-color');
			$(value).css('background-color', color);
		});

	};

	myApp.updateOrder = function(e, ui) {
		$.each(e.target.children, function(index, value) {
			$(value).attr('data-sort', index + 1);
			var item_id = $(value).attr('data-id');
			var data = {
				assignment: {
					queue_index: $(value).attr('data-sort')
				}
			};
			$.ajax({
				url: '/assignments/' + item_id,
				dataType: 'json',
				data: data,
				type: 'put',
				success: myApp.updateText
			});
		});
	};

	myApp.updateText = function(result) {
		var $target = $('div[data-id=' + result.assignment.id + ']');
		var number = result.assignment.queue_index;
		$target.find('.assignmentQueue').html("Queue: " + number);
	};

	myApp.taskModal = function() {
		$( "#task-modal" ).dialog({
			closeText: 'X',
      autoOpen: false,
      height: 450,
      width: 500,
      modal: true,
      draggable: false,
      close: function() {
        // allFields.val( "" ).removeClass( "ui-state-error" );
      }
    });
	};

})(window.myApp = window.myApp || {}, jQuery);