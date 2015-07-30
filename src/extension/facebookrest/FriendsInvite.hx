package extension.facebookrest;

import haxe.Json;

typedef ProfilePictureSource = { height : Int, is_silhouette : Bool, url : String, width : Int }
typedef UserInvitableFriendPicture = { data : ProfilePictureSource }
typedef UserInvitableFriend = { id : String, name : String, picture : UserInvitableFriendPicture }

class FriendsInvite {
	
	public static function invitableFriends(
		graph : Graph,
		onSuccess : Array<UserInvitableFriend>->Void,
		onError : Dynamic->Void
	) : Void {
		
		graph.get(
			"/me/invitable_friends",
			function(data) {
				onSuccess(data.data);
			},
			null,
			onError
		);
 
	}

}
