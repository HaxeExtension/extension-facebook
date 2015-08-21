package extension.facebook;

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

}
