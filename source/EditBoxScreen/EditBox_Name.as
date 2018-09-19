package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class EditBox_Name extends MovieClip {
		
		public var parentScreen : EditBoxScreen;
		
		public function EditBox_Name(_parentScreen:EditBoxScreen) {
			// constructor code
			parentScreen = _parentScreen;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function onAddedToStage(e:Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function onRemovedFromStage(e:Event) : void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function onClick(mE:MouseEvent) {
			trace("\nCLICK!");
			trace(mE.target);
			trace(mE);
			
			var target = mE.target;
			
			if (target is NextButton) {
				parentScreen.editedBoxName = nameText.text;
				trace("NAME SET TO: " + nameText.text);
				parentScreen.switchScreens(this, parentScreen.locationScreen);
			} else if (target == nameText) {
				target.setSelection(0, target.getLineLength(0));
			} else if (target is AddPhotoButton) {
				addPhotoButton.takePicture();
			} else if (target is ReturnButton || target is ExitButton) {
				parentScreen.appDisplay.editBoxScreenToBoxScreen();
			}
		}
		
		public function storePhotoData(_photo:Photo) : void {
			parentScreen.editedBoxPicture = _photo;
			addChild(_photo);
			_photo.x = addPhotoButton.x;
			_photo.y = addPhotoButton.y;
		}
		
		public function setup(existingBox:Box) : void {
			nameText.text = existingBox.name;
		}
		
		public function reset():void {
			nameText.text = "";
		}
	}
	
}
