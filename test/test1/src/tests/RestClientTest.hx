package tests;

import extension.facebookrest.RestClient;
import haxe.unit.TestCase;

class RestClientTest extends TestCase {

	public function test() {
		RestClient.getAsync("http://jsonplaceholder.typicode.com/posts");
		assertTrue(true);
	}

}
