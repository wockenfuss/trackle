(function(myApp, $, undefined) {
	$.extend(myApp, {
		Tasks: function( selector ) {
			var $target = $(selector);
			var addListener = function() {
				$target.find('.taskBoxName').on('click', function(e) {
					var taskId = $(this).parent().attr('data-task');
					var projectId = $(this).parent().attr('data-project');
					$.ajax({
						url: '/tasks',
						dataType: 'script',
						type: 'get',
						data: {
							project_id: projectId,
							task_id: taskId
						},
						success: function(result) {

						}
					});
				});
			};

			var updateView = function() {
				$.each($target, function( index, value ) {
					// setColor(value);
					setProgress(value);
				});
			};
			var setColor = function( value ) {
				var color = $(value).attr('data-taskColor');
				$(value).css('background-color', color);
			};

			var setProgress = function( value ) {
				var taskProgress = $(value).find('.taskProgress').first().text().replace(/\s+/g, '').split('/');
				var percentage;
				if ( taskProgress[1] === "0" ) {
					percentage = 100;
				} else {
					percentage = (taskProgress[0] / taskProgress[1]) * 100;
				}
				$(value).find('.completeTasks').css('width', percentage + "%");
			};

			var refresh = function() {
				addListener();
				updateView();
			};

			var renderAdminIndex = function( html ) {
				var taskFormSelector = '#taskList .resourceFormDrawer';
				var visibility = $(taskFormSelector).is(':visible');
				$target.html(html);
				if ( visibility ) {
					$(taskFormSelector).show();
				}
			};

			return {
				listen: addListener,
				update: updateView, 
				refresh: refresh,
				renderIndex: renderAdminIndex
			};
		}
	});
})(myApp = window.myApp || {}, jQuery);