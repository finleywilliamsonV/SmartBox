package {

	import flash.display.MovieClip;


	public class TagDisplay_Display extends MovieClip {


		public function TagDisplay_Display() {
			// constructor code
			y = 400;
		}

		public function populate(elements: Array): void {
			removeChildren();
			for (var l: int = 0; l < elements.length; l++) {

				var tempElement: * = elements[l];
				var newDisplay;
				
				if (tempElement is Box) {
					newDisplay = new BoxLibrary_BoxDisplay(tempElement);
				} else if (tempElement is Item) {
					newDisplay = new BoxLibrary_ItemDisplay(tempElement);
				}
				
				addChild(newDisplay);
				newDisplay.y = (numChildren - 1) * 75;
				

			}
		}
		
		public function reset() : void {
			removeChildren();
		}

	}

}