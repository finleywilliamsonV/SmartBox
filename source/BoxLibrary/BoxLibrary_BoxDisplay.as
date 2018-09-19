package  {
	
	import flash.display.MovieClip;
	
	
	public class BoxLibrary_BoxDisplay extends MovieClip {
		
		public var box:Box;
		public var boxName:String;
		
		public function BoxLibrary_BoxDisplay(_box : Box) {
			// constructor code
			box = _box;
			boxName = box.name;
			boxText.text = boxName;
		}
	}
	
}
