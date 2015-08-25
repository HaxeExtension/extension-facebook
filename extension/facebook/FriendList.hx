package extension.facebook;

import flash.net.SharedObject;
import haxe.Json;

typedef ProfilePictureSource = { height : Int, is_silhouette : Bool, url : String, width : Int }
typedef UserInvitableFriendPicture = { data : ProfilePictureSource }
typedef UserInvitableFriend = { id : String, name : String, picture : UserInvitableFriendPicture }

class FriendList {

	public static function invitableFriends(
		f : Facebook,
		onSuccess : Array<UserInvitableFriend>->Void,
		onError : Dynamic->Void
	) : Void {
		f.getAll(
			"/me/invitable_friends",
			onSuccess,
			onError
		);
	}

	public static function friendsWhoHaveInstalled(
		f : Facebook,
		onSuccess : Array<String>->Void,
		onError : Dynamic->Void
	) : Void {
		f.getAll(
			"/me/friends",
			function(data) {
				var arr = [];
				for (it in data) {
					arr.push(it.id);
				}
				onSuccess(arr);
			},
			["fields"=>"installed"],
			onError
		);
	}

	public static function newInstalledFriendsSinceLastTime(
		f : Facebook,
		onSuccess : Int->Void,
		onError : Dynamic->Void
	) : Void {
		friendsWhoHaveInstalled(
			f,
			function (result : Array<String>) {
				var thisTimeCount = result.length;
				var so = SharedObject.getLocal("facebook_extension_friends");
				var lastTimeCount : Int = so.data.lastTimeCount!=null ? 0 : so.data.lastTimeCount;
				onSuccess(thisTimeCount-lastTimeCount);
				so.data.lastTimeCount = thisTimeCount;
				so.flush();
			},
			onError
		);
	}

}
