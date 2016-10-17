package extension.util.task;

#if cpp
import cpp.vm.Mutex;
#elseif neko
import neko.vm.Mutex;
#end

class TaskExecutor {

	var taskList : List<Task>;
	#if (cpp || neko)
	var taskListMutex : Mutex;
	#end

	public function new() {
		taskList = new List<Task>();
		#if (cpp || neko)
		taskListMutex = new Mutex();
		#end
		var timer = new haxe.Timer(100);
		timer.run = update;
	}

	private function mutexAcquire(){
		#if (cpp || neko)
		taskListMutex.acquire();
		#end		
	}

	private function mutexRelease(){
		#if (cpp || neko)
		taskListMutex.release();
		#end		
	}

	function addTask(task : Task) {
		mutexAcquire();
		taskList.add(task);
		mutexRelease();
	}

	function update() {
		if (taskList.isEmpty()) {
			return;
		}
		mutexAcquire();
		var next = taskList.pop();
		mutexRelease();
		if (next!=null) {
			next._do();
		}
	}

}
