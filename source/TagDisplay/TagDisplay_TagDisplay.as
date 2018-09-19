package  {
	
		import flash.display.MovieClip;
	
	
	public class TagDisplay_TagDisplay extends MovieClip {
		
		public var tagName:String;
		
		public function TagDisplay_TagDisplay(_name:String) {
			// constructor code
			tagName = _name;
			tagText.text = tagName;
		}
	}
	
}
