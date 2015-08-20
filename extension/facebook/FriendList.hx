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
		
		f.get(
			"/me/invitable_friends",
			function(data) {
				onSuccess(data.data);
			},
			null,
			onError
		);
 
	}

}
