package  {
	
		import flash.display.MovieClip;
	
	
	public class BoxLibrary_TagDisplay extends MovieClip {
		
		public var tag:String;
		
		public function BoxLibrary_TagDisplay(_tag : Tag) {
			// constructor code
			tag = _tag.name;
			tagText.text = tag;
		}
	}
	
}
