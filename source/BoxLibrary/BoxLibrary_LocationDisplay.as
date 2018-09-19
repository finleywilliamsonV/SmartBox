package  {
	
	import flash.display.MovieClip;
	
	
	public class BoxLibrary_LocationDisplay extends MovieClip {
		
		public var locationName:String;
		
		public function BoxLibrary_LocationDisplay(_locationName : String) {
			// constructor code
			locationName = _locationName;
			locationText.text = locationName;
		}
	}
	
}
