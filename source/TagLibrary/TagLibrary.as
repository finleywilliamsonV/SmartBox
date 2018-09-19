package {

	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;

	//------------------------------------------------------------------------------ import Scroller
	import com.doitflash.consts.Orientation;
	import com.doitflash.consts.Easing;
	import com.doitflash.events.ScrollEvent;
	import com.doitflash.starling.utils.scroller.Scroller;
	import flash.geom.Point;
	import flash.events.TransformGestureEvent;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;


	public class TagLibrary extends MovieClip {
		
		
		public var appData: AppData;

		public static const LIBRARY_WIDTH = GlobalVariables.TAG_LIB_WIDTH;
		public static const LIBRARY_HEIGHT = GlobalVariables.TAG_LIB_HEIGHT;
		public static const BUFFER = GlobalVariables.TAG_LIB_BUFFER;
		
		// scroller variables
		private var _scroller: Scroller;
		private var _body: Sprite;
		private var _mask: Sprite;
		public var MASK_WIDTH: Number;	// changed
		public var MASK_HEIGHT: Number;	// changed
		private var _mouseOver: Boolean = false;
		private var _content: * ;

		public var tagArray: Array;
		public var tagObjectArray: Array;
		public var tagContainer: Sprite;
		public var tagPanel: Sprite;

		public var deletableTagArray: Array;

		public var inputField: TextField;
		public var inputFormat: TextFormat;

		public var tagsSelected: Array;

		public var newTagButton: TagLibrary_NewTagButton;

		public function TagLibrary(_appData: AppData = null) {

			// store app data reference
			appData = _appData;

			// new tag button
			newTagButton = new TagLibrary_NewTagButton();
			addChild(newTagButton);
			newTagButton.x = LIBRARY_WIDTH - newTagButton.width;

			// text field & format
			inputFormat = new TextFormat();
			inputField = new TextField();

			inputFormat.font = "Raleway Light";
			inputFormat.size = GlobalVariables.TAG_LIB_TXT_L;
			inputFormat.leftMargin = 5;
			inputFormat.rightMargin = 5;

			inputField.defaultTextFormat = inputFormat;
			inputField.width = newTagButton.x - BUFFER;
			inputField.height = inputFormat.size + BUFFER;
			inputField.type = TextFieldType.INPUT;
			inputField.background = true;
			inputField.border = true;
			inputField.multiline = false;
			inputField.wordWrap = false;

			addChild(inputField);

			// container
			tagContainer = new Sprite();
			tagContainer.graphics.beginFill(0xFFFFFF);
			tagContainer.graphics.drawRect(0, 0, LIBRARY_WIDTH, LIBRARY_HEIGHT);
			tagContainer.graphics.endFill();

			tagContainer.graphics.lineStyle(1, 0x000000);
			tagContainer.graphics.beginFill(0x000000, 0);
			tagContainer.graphics.drawRect(0, 0, LIBRARY_WIDTH, LIBRARY_HEIGHT);
			tagContainer.graphics.endFill();

			addChild(tagContainer);
			tagContainer.y = inputField.height + BUFFER;

			// tag panel
			tagPanel = new Sprite();
			//addChild(tagPanel);
			
			
			
			MASK_WIDTH = LIBRARY_WIDTH - 2; 
			MASK_HEIGHT = LIBRARY_HEIGHT - 2;
			
			//var panelMask : Shape = new Shape();
			//panelMask.graphics.beginFill(0x000000);
			//panelMask.graphics.drawRect(0,0, LIBRARY_WIDTH, LIBRARY_HEIGHT);
			//addChild(panelMask);
			//panelMask.y += inputField.height + BUFFER;
			//tagPanel.mask = panelMask;

			// constructor code
			tagArray = [];
			tagObjectArray = [];
			tagsSelected = [];

			deletableTagArray = [];

			/*addTag("BAGELS");
			addTag("GOO");
			addTag("EGG SALAMI");
			addTag("CHAIR LUNCH DINNER");
			addTag("WORMS");
			addTag("REGULAR PEOPLE");
			addTag("GRAPES");
			addTag("LIGHTBULB CONTRACTS");*/

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function onAddedToStage(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			if (GlobalVariables.isMobile) {
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				addEventListener(TouchEvent.TOUCH_TAP, onTap);
			} else {
				addEventListener(MouseEvent.CLICK, onClick);
			}
						
			populate(appData.tags);
			trace(" ADDED - - - - - - - APP TAGS: " + appData.tags);
			populate(GlobalVariables.DEFAULT_TAGS);
			trace(" ADDED - - - - - - - DEFAULT TAGS: " + GlobalVariables.DEFAULT_TAGS);
			
			if (!_body) _body = new Sprite();
			this.addChild(_body);
			_body.x = 1;
			_body.y = inputField.height + BUFFER + 1;

			setScroller();
			onResize();
		}

		public function onRemovedFromStage(e: Event): void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			if (GlobalVariables.isMobile) {
				removeEventListener(TouchEvent.TOUCH_TAP, onTap);
			} else {
				removeEventListener(MouseEvent.CLICK, onClick);
			}
			
			_content.removeEventListener(MouseEvent.MOUSE_DOWN, onTouchDown);
			_content.removeEventListener(MouseEvent.MOUSE_MOVE, onTouchMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onTouchUp);

			trace(" REMOVED - - - - - - - APP TAGS: " + appData.tags);
		}
		
		
		private function setScroller(): void {
			// set the mask
			if (!_mask) _mask = new Sprite();
			//_mask.y = tagContainer.y;

			if (!_content) _content = tagPanel;
			//trace(_content.x,_content.y,_content.width, _content.height);
			//_content.y = tagContainer.y + inputField.height;

			_content.mask = _mask;
			//_content.txt.autoSize = TextFieldAutoSize.LEFT;
			//_content.txt.addEventListener(Event.CHANGE, onTextChange);
			_content.addEventListener(MouseEvent.MOUSE_DOWN, onTouchDown);
			_content.addEventListener(MouseEvent.MOUSE_MOVE, onTouchMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onTouchUp);

			_body.addChild(_mask);
			_body.addChild(_content);

			//------------------------------------------------------------------------------ set Scroller
			if (!_scroller) _scroller = new Scroller();
			_scroller.content = _content; // you MUST set scroller content before doing anything else
			_scroller.orientation = Orientation.VERTICAL; // accepted values: Orientation.AUTO, Orientation.VERTICAL, Orientation.HORIZONTAL
			_scroller.easeType = Easing.Expo_easeOut;
			_scroller.duration = .1;
			_scroller.holdArea = 0;
			_scroller.isStickTouch = false;

			_scroller.yPerc = 0;
		}

		private function onTouchDown(e: MouseEvent): void {
			if (!_mouseOver) {
				var pos: Point = new Point(e.stageX, e.stageY);
				_scroller.startScroll(pos); // on touch begin and move
				_mouseOver = true;
			}
		}

		private function onTouchMove(e: MouseEvent): void {
			if (_mouseOver) {
				var pos: Point = new Point(e.stageX, e.stageY);
				_scroller.startScroll(pos); // on touch begin and move
			}

		}

		private function onTouchUp(e: MouseEvent): void {
			_scroller.fling(); // on touch ended
			_mouseOver = false;
		}

		private function onResize(e: *= null): void {
			
			trace("!!! ON RESIZE ");
			if (_mask) drawRect(_mask, 0x000000, 1, MASK_WIDTH, MASK_HEIGHT);

			if (_scroller) {
				_scroller.boundWidth = MASK_WIDTH;
				_scroller.boundHeight = MASK_HEIGHT - BUFFER - BUFFER;
			}

			if (_body && _scroller) {
				//_body.x = (stage.stageWidth / 2) - (_scroller.boundWidth / 2);
				//_body.y = (stage.stageHeight / 2) - (_scroller.boundHeight / 2);
				//_body.y = 100;
			}
		}

		private function drawRect($target: * , $color: uint, $alpha: Number, $width: Number, $height: Number): void {
			$target.graphics.clear();
			//$target.graphics.lineStyle(5, 0x0000FF, .5, false);
			$target.graphics.beginFill($color, $alpha);
			$target.graphics.drawRect(0, 0, $width, $height);
			$target.graphics.endFill();
		}
		

		public function reset(): void {
			tagPanel.removeChildren();
			//tagContainer.graphics.clear();
			tagArray = [];
			tagObjectArray = [];
			tagsSelected = [];
			deletableTagArray = [];
		}

		public function setup(): void {
			//populate(appData.tags);
			
		}

		public function setSelected(theseTags: Array): void {

			//trace("setSelected: " + theseTags);
			var tempTagObject: TagLibrary_Tag;

			for (var i: int = 0; i < tagObjectArray.length; i++) {
				tempTagObject = tagObjectArray[i];
				//trace("Checking " + tempTagObject + " in " + theseTags.join(", "));

				if (theseTags.indexOf(tempTagObject.tagText) >= 0) {
					tempTagObject.setSelected(true);
					tagsSelected.push(tempTagObject.tagText);
				}
			}
			
			populate();
		}

		public function destroy(): void {
			tagPanel.removeChildren();
			tagContainer.graphics.clear();
			tagArray = [];
			tagObjectArray = [];
			tagsSelected = [];
		}

		public function addTag(tag: String): void {
			tagArray.push(tag.toUpperCase());
			populate();
		}

		public function addDeletableTag(tag: String): void {
			deletableTagArray.insertAt(0,tag.toUpperCase());
			populate();
		}

		public function populate(newTags: Array = null): void {

			trace("\nTagLibrary: populating");

			if (newTags) {
				tagArray = GlobalVariables.clone(newTags) as Array;
			}

			tagPanel.removeChildren();
			tagObjectArray = [];

			var tempTag: String;
			var tempTagObject;

			// deletable tags first
			for (var i: int = 0; i < deletableTagArray.length; i++) {
				tempTag = deletableTagArray[i];
				tempTagObject = new TagLibrary_DeletableTag(tempTag);
				tagObjectArray.push(tempTagObject);
				if (tagsSelected.indexOf(tempTag) >= 0) {
					tempTagObject.setSelected(true);
				}
			}

			// then selected tags
			for (var j: int = 0; j < tagsSelected.length; j++) {
				tempTag = tagsSelected[j];
				tempTagObject = new TagLibrary_Tag(tempTag);
				tagObjectArray.push(tempTagObject);
				tempTagObject.setSelected(true);
			}

			// existing tags next
			for (var k: int = 0; k < tagArray.length; k++) {
				tempTag = tagArray[k];
				if (tagsSelected.indexOf(tempTag) >= 0) continue;
				tempTagObject = new TagLibrary_Tag(tempTag);
				tagObjectArray.push(tempTagObject);
				if (tagsSelected.indexOf(tempTag) >= 0) {
					tempTagObject.setSelected(true);
				}
			}

			trace("Number of Tags: " + tagObjectArray.length);

			//tagObjectArray.push(newTagButton);
			trace(tagObjectArray.join(", "));

			var leadingEdgeWidth: int = 0;
			var leadingEdgeHeight: int = 0;

			var currentRow: int = 1;

			if (tagObjectArray.length == 0) return;
			var leaveSpaceForSelected: Boolean = tagObjectArray[0].isSelected;
			var spaceLeft: Boolean = false;

			for (var j: int = 0; j < tagObjectArray.length; j++) {

				tempTagObject = tagObjectArray[j];
				tagPanel.addChild(tempTagObject);

				tempTagObject.x = leadingEdgeWidth + BUFFER;
				tempTagObject.y = leadingEdgeHeight + BUFFER;

				// space for selected
				if (tempTagObject.isSelected == false && leaveSpaceForSelected) {

					leaveSpaceForSelected = false;
					leadingEdgeHeight += tempTagObject.height + BUFFER;
					leadingEdgeWidth = 0;
					tempTagObject.x = leadingEdgeWidth + BUFFER;
					tempTagObject.y = leadingEdgeHeight + BUFFER;
					leadingEdgeWidth += tempTagObject.width + BUFFER;


				} else if (leadingEdgeWidth + tempTagObject.width + BUFFER < tagContainer.width) { // if tag fits
					leadingEdgeWidth += tempTagObject.width + BUFFER;


				} else {
					leadingEdgeHeight += tempTagObject.height + BUFFER;
					leadingEdgeWidth = 0;

					tempTagObject.x = leadingEdgeWidth + BUFFER;
					tempTagObject.y = leadingEdgeHeight + BUFFER;

					leadingEdgeWidth += tempTagObject.width + BUFFER;
				}
				//leadingEdgeHeight += tempTagObject.height;

			}
		}



		public function onTap(tE: TouchEvent) {
			tE.stopPropagation();
			onClick(null, tE.target);
		}
		
		public function onClick(mE: MouseEvent = null, tapTarget:* = null) {
			
			var target;
			if (tapTarget) {
				target = tapTarget;
			} else {
				target = mE.target;
				mE.stopPropagation();
			}
			
			trace("\nTagLibrary CLICK! - " + target);
			
			// tag library TEMPORARY
			if (target is TextField) {

				if (target == inputField) {
					return;
				}

				if (target.parent is TagLibrary_Tag) {

					var currentTag: TagLibrary_Tag = target.parent as TagLibrary_Tag;

					trace("\ncurrentTag: " + currentTag);

					if (currentTag.toggleSelected()) {
						tagsSelected.push(currentTag.tagText);
						populate();
					} else {
						tagsSelected.splice(tagsSelected.indexOf(currentTag.tagText), 1);
						populate();
					}

				} else if (target.parent is TagLibrary_DeletableTag) {

					var currentDeletableTag: TagLibrary_DeletableTag = target.parent as TagLibrary_DeletableTag;

					deletableTagArray.splice(tagsSelected.indexOf(currentDeletableTag.tagText), 1);
					//tagsSelected.splice(tagsSelected.indexOf(currentDeletableTag.tagText), 1);

					populate();

				}


			} else if (target is TagLibrary_NewTagButton) {

				if (inputField.text == "") return;
				
				var tempTag: String = inputField.text;
				tempTag = tempTag.toUpperCase();

				trace("inputField.text: " + tempTag);

				if (tagArray.indexOf(tempTag) > -1) {	// in the list already, select it

					//tagsSelected.indexOf(tempTag) > -1) return;
					tagsSelected.insertAt(0,tempTag);
					populate();

				} else if (deletableTagArray.indexOf(tempTag) == -1) { 	// not in the deletableTagArray, add it
					
					addDeletableTag(tempTag);
					
				}

				// clear inputField
				inputField.text = "";

				// tags should be selected when created
				// add new tags deselects all previous
			}
		}


	} //end
}