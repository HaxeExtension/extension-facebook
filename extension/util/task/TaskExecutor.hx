package extension.util.task;

class TaskExecutor {

	public function new() { }

	function addTask(task : Task) {
		haxe.Timer.delay(task._do, 0);
	}

}
