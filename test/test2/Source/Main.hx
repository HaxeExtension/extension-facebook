package;


import extension.facebook.Facebook;
import openfl.display.Sprite;


class Main extends Sprite {
	
	
	public function new () {
		
		super ();
		haxe.Timer.delay(function() {
			var face = new Facebook();
			face.login(
				PermissionsType.Read,
				["email", "user_likes"],
				function() trace("Logged in"), 		// Sucess
				function() {		// Cancel
					trace("Cancel");
				},
				function(error) {	// Error
					trace("error " + error);
				}
			);
		}, 5000);
		
		
	}
	
	
}