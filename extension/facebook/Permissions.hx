package extension.facebook;

import haxe.Json;

enum Status {
	Granted;
	Declined;
}
typedef PermissionStatus = { permission : String, status : Status }

class Permissions {

	public static function currentPermissions(
		f : Facebook,
		onSuccess : Array<PermissionStatus>->Void,
		onError : Dynamic->Void
	) : Void {

		f.get(
			"/me/permissions",
			function(data) {
				var arr = [];
				for (json in cast(data.data, Array<Dynamic>)) {
					var ps : PermissionStatus = {
						permission : json.permission,
						status: json.status=="granted" ? Granted : Declined
					};
					arr.push(ps);
				}
				onSuccess(arr);
			},
			onError
		);

	}

}
