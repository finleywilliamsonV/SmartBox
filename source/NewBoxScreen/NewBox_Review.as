package {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;


	public class NewBox_Review extends MovieClip {

		public var parentScreen: NewBoxScreen;
		public var savedPhoto: Photo;

		public function NewBox_Review(_parentScreen: NewBoxScreen) {
			// constructor code

			parentScreen = _parentScreen;

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function onAddedToStage(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(MouseEvent.CLICK, onClick);
			
			// TUTORIAL CHECK - Intro Review New Box
			var tutorialChecks : Array = GlobalVariables.instance.appData.tutorialChecks;
			var tutIndex : int = TutorialOverlay.NBR_REVIEW_BOX;
			trace("\nNewBox_Review - tutorialChecks: " + tutorialChecks[tutIndex]);
			if (tutorialChecks[tutIndex] > 0) {
				addChild(new TutorialOverlay(tutIndex));
			}
		}

		public function onRemovedFromStage(e: Event): void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function setup(newName: String, newLocation: String) {
			nameText.text = newName;
			locationText.text = newLocation;
			
			savedPhoto = parentScreen.newBoxPhoto;
			trace(savedPhoto);
			if (savedPhoto) {
				addChild(savedPhoto);
				savedPhoto.x = addPhotoButton.x;
				savedPhoto.y = addPhotoButton.y;
			}
		}

		public function onClick(mE: MouseEvent) {
			trace("\nCLICK!");
			trace(mE.target);
			trace(mE);

			mE.stopPropagation();

			var target = mE.target;

			if (target is FinishButton) {
				trace("FINALIZING BOX");
				parentScreen.finalizeBox();
				parentScreen.appDisplay.newBoxScreenToHomeScreen();

			} else if (target is AddPhotoButton) {
				addPhotoButton.takePicture();

			} else if (target is FinishAndAddItemsButton) {
				trace("FINALIZING BOX");
				var newBox: Box = parentScreen.finalizeBox();
				parentScreen.appDisplay.newBoxScreenToBoxScreen(newBox);
			} else if (target is ReturnButton) {
				reset();
				parentScreen.switchScreens(this, parentScreen.locationScreen);
			} else if (target is ExitButton) {
				parentScreen.appDisplay.newBoxScreenToHomeScreen();
			}
		}
		
		public function storePhotoData(_photo:Photo) : void {
			parentScreen.newBoxPhoto = _photo;
			savedPhoto = _photo;
			addChild(savedPhoto);
			savedPhoto.x = addPhotoButton.x;
			savedPhoto.y = addPhotoButton.y;
		}

		public function reset(): void {
			nameText.text = "";
			locationText.text = "";
			
			if (savedPhoto && savedPhoto.parent == this) {
				removeChild(savedPhoto);
			}
			savedPhoto = null;
		}
	}

}