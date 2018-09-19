package {

	import flash.display.MovieClip;


	public class TagDisplay extends MovieClip {
		
		public var display:TagDisplay_Display;
		public var tag: String;

		public function TagDisplay(): void {
			// constructor code
			display = new TagDisplay_Display();
			addChild(display);
		}

		public function populateList(newTag: String): void {
			trace("\n - STARTING POPULATE tag LIST - ");
			tag = newTag;
			display.populate(GlobalVariables.instance.appData.searchTag(tag));
		}
		
		public function reset() : void {
			display.reset();
		}
	}

}