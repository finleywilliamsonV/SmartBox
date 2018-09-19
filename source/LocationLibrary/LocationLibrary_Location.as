package {

	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;

	
	public class LocationLibrary_Location extends MovieClip {

		public var locationContainer: Shape;
		public var locationText: String;
		public var isSelected: Boolean;

		public var myText: TextField;
		public var myFormat: TextFormat;

		public function LocationLibrary_Location(text: String = "EMPTY LOCATION"): void {

			locationText = text;

			isSelected = false;

			// text
			myFormat = new TextFormat();
			myFormat.align = TextFormatAlign.CENTER;
			myFormat.font = "Raleway ExtraLight";
			myFormat.size = GlobalVariables.LOC_LIB_TXT_S;

			myText = new TextField();
			myText.defaultTextFormat = myFormat;
			myText.text = text;
			myText.selectable = false;

			myText.border = true;
			myText.width = myText.textWidth + 10;
			myText.height = myText.textHeight + 6;

			// container
			locationContainer = new Shape();
			locationContainer.graphics.beginFill(0xEEEEEE);
			locationContainer.graphics.drawRect(0, 0, myText.width, myText.height);
			locationContainer.graphics.endFill();

			addChild(locationContainer);
			addChild(myText);
		}

		public function toggleSelected(): Boolean {
			if (isSelected) {
				setSelected(false);
			} else {
				setSelected(true);
			}

			return isSelected;
		}

		public function setSelected(tf: Boolean): void {
			isSelected = tf;

			locationContainer.graphics.clear();
			trace("SELECTED SET TO: " + tf);

			if (isSelected) {
				locationContainer.graphics.beginFill(0xAAAAAA);
			} else {
				locationContainer.graphics.beginFill(0xEEEEEE);
			}

			locationContainer.graphics.drawRect(0, 0, myText.width, myText.height);
			locationContainer.graphics.endFill();
		}
		
		override public function toString(): String {
			return String(locationText);
		}
	}

}