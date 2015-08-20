package extension.facebook;

class HTMLAssets {

	public static function getSuccessHTML() : String {
		return '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
				<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
				<head>
					<title>Facebook Graph API - Login Successful</title>
					<meta name="viewport" content="width=device-width, height=device-height, initial-scale=0.8, maximum-scale=0.8,user-scalable=no" />
				</head>
				<body style="background-color:#ffffff;margin: 0;padding: 0;border: 0;">

				<table style="width:100%;position:absolute;height:100%;margin:auto 0"><tr>
					<td valign="center">
						<center>
						<h1>LOGIN SUCCESSFUL</h1>
						<p>You can now close this browser...</p>
						</center>
					</td>
				</tr></table>

				<script type="text/javascript">
				//window.open("","_self").close();
				</script>

				</body>
				</html>';
	}

	public static function getErrorHTML() : String {
		return '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
				<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
				<head>
					<title>Facebook Graph API - Login Error</title>
					<meta name="viewport" content="width=device-width, height=device-height, initial-scale=0.8, maximum-scale=0.8,user-scalable=no" />
				</head>
				<body style="background-color:#ffffff;margin: 0;padding: 0;border: 0;">

				<table style="width:100%;position:absolute;height:100%;margin:auto 0"><tr>
					<td valign="center">
						<center>
						<h1>LOGIN ERROR</h1>
						<p>
						There was an error dungin the login.
						<br/>
						<strong>Don\'t panic:</strong> This is not really needed to play this game :)
						<br/>
						<br/>
						<i>You can close this browser and begin to play without Google Play Games (or you can retry later if you wish).</i>
						</p>
						</center>
					</td>
				</tr></table>

				<script type="text/javascript">
				//window.open("","_self").close();
				</script>

				</body>
				</html>';
	}

}
