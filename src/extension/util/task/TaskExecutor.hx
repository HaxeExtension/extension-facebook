package extension.util.task;

#if cpp
import cpp.vm.Mutex;
import cpp.vm.Thread;
#else
import neko.vm.Mutex;
import neko.vm.Thread;
#end

class TaskExecutor {

	var taskList : List<Task>;
	var taskListMutex : Mutex;

	public function new() {
		taskList = new List<Task>();
		taskListMutex = new Mutex();
		var timer = new haxe.Timer(100);
		timer.run = update;
	}

	function addTask(task : Task) {
		taskListMutex.acquire();
		taskList.add(task);
		taskListMutex.release();
	}

	function update() {
		if (taskList.isEmpty()) {
			return;
		}
		taskListMutex.acquire();
		var next = taskList.pop();
		taskListMutex.release();
		if (next!=null) {
			next._do();
		}
	}

}
