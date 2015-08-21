package extension.facebook;

import haxe.Json;

typedef ProfilePictureSource = { height : Int, is_silhouette : Bool, url : String, width : Int }
typedef UserInvitableFriendPicture = { data : ProfilePictureSource }
typedef UserInvitableFriend = { id : String, name : String, picture : UserInvitableFriendPicture }

class FriendList {
	
	public static function invitableFriends(
		f : Facebook,
		onSuccess : Array<UserInvitableFriend>->Void,
		onError : Dynamic->Void,
		withFriends : Array<UserInvitableFriend> = null,
		after : String = null
	) : Void {
		if (withFriends==null) {
			withFriends = [];
		}
		f.get(
			"/me/invitable_friends",
			function(data) {
				for (f in cast(data.data, Array<Dynamic>)) {
					withFriends.push(f);
				}
				if (data.paging!=null && data.paging.cursors!=null && data.paging.cursors.after!=null) {
					invitableFriends(f, onSuccess, onError, withFriends, data.paging.cursors.after);
				} else {
					onSuccess(withFriends);
				}
			},
			after==null ? null : [ "after" => after ],
			onError
		);

	}

}
