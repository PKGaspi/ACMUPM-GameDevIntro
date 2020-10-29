extends ProgressBar


var to_monitor

func _process(delta):
	if is_instance_valid(to_monitor):
		value = to_monitor.hp
	else:
		value = 0
