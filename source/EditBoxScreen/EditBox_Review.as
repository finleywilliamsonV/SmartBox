package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class EditBox_Review extends MovieClip {
		
		public var parentScreen : EditBoxScreen;
		
		public function EditBox_Review(_parentScreen:EditBoxScreen) {
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
		
		public function setup(existingBox:Box, editedName:String, editedLocation:String, editedPic:*=null) : void {
			nameText.text = editedName;
			locationText.text = editedLocation;
			tagsText.text = existingBox.tags.join(", ");
			numItemsText.text = String(existingBox.items.length);
			dateCreatedText.text = String(existingBox.dateCreated.month + "/" + existingBox.dateCreated.date + "/" + existingBox.dateCreated.fullYear);
		}
		
		public function onClick(mE:MouseEvent) {
			trace("\nCLICK!");
			trace(mE.target);
			trace(mE);
			
			mE.stopPropagation();
			
			var target = mE.target;
			
			if (target is FinishButton) {
				trace("FINALIZING EDITS");
				parentScreen.finalizeEdits();
				parentScreen.appDisplay.editBoxScreenToBoxScreen();
			} else if (target is CancelButton) {
				trace("CANCELLING EDITS");
				parentScreen.appDisplay.editBoxScreenToBoxScreen();
			} else if (target is ReturnButton) {
				reset();
				parentScreen.switchScreens(this, parentScreen.locationScreen);
			} else if (target is ExitButton) {
				parentScreen.appDisplay.editBoxScreenToBoxScreen();
			}
		}
		
		public function storePhotoData(_photo:Photo) : void {
			parentScreen.editedBoxPicture = _photo;
			addChild(_photo);
			_photo.x = addPhotoButton.x;
			_photo.y = addPhotoButton.y;
		}
		
		public function reset():void {
			nameText.text = "";
			locationText.text = "";
			tagsText.text = "";
			numItemsText.text = "";
			dateCreatedText.text = "";
		}
	}
	
}
