package {

	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;


	public class TagLibrary_DeletableTag extends MovieClip {

		public var tagContainer: Shape;
		public var tagText: String;
		public var isSelected: Boolean;

		public var myText: TextField;
		public var myFormat: TextFormat;
		
		public static const TEXT_SIZE : int = GlobalVariables.TAG_LIB_TXT_S;

		public function TagLibrary_DeletableTag(text: String = "TAG TAG TAG TAG TAG TAG TAG "): void {

			tagText = text;

			isSelected = false;

			// text
			myFormat = new TextFormat();
			myFormat.align = TextFormatAlign.CENTER;
			myFormat.size = TEXT_SIZE;
			myFormat.font = "Raleway Light";

			myText = new TextField();
			myText.defaultTextFormat = myFormat;
			myText.text = text + "   X  ";
			myText.selectable = false;

			myText.border = true;
			myText.width = myText.textWidth + 10;
			myText.height = myText.textHeight + 6;

			// container
			tagContainer = new Shape();
			tagContainer.graphics.beginFill(0xCCCCCC);
			tagContainer.graphics.drawRect(0, 0, myText.width, myText.height);
			tagContainer.graphics.endFill();

			addChild(tagContainer);
			addChild(myText);
			
			setSelected(true);
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

			tagContainer.graphics.clear();
			trace("SELECTED SET TO: " + tf);

			if (isSelected) {
				tagContainer.graphics.beginFill(0xAAAAAA);
			} else {
				tagContainer.graphics.beginFill(0xCCCCCC);
			}

			tagContainer.graphics.drawRect(0, 0, myText.width, myText.height);
			tagContainer.graphics.endFill();
		}
		
		override public function toString(): String {
			return String(tagText);
		}
	}

}