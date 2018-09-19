package {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;

	//------------------------------------------------------------------------------ import Scroller
	import com.doitflash.consts.Orientation;
	import com.doitflash.consts.Easing;
	import com.doitflash.events.ScrollEvent;
	import com.doitflash.starling.utils.scroller.Scroller;
	import flash.geom.Point;


	public class HomeScreen extends MovieClip {


		// scroller variables
		private var _scroller: Scroller;
		private var _body: Sprite;
		private var _mask: Sprite;
		private var _point: Point;
		public static const MASK_WIDTH: Number = 750;
		public static const MASK_HEIGHT: Number = 1084;
		private var _mouseOver: Boolean = false;
		private var _content: * ;

		// home screen variables
		public var appDisplay: AppDisplay;
		public var boxLibrary: BoxLibrary;
		public var searchActive: Boolean = false;


		public function HomeScreen(_appDisplay: AppDisplay) {
			// constructor code
			appDisplay = _appDisplay;
			boxLibrary = new BoxLibrary(this);
			
			_point = new Point();
			//addChild(boxLibrary);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function onAddedToStage(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			addEventListener(MouseEvent.CLICK, onClick);

			if (!_body) _body = new Sprite();
			this.addChild(_body);
			
			for (var i:int = 0; i < numChildren; i++){
				trace(getChildAt(i));
			}

			setScroller();
			onResize();
		}

		public function onRemovedFromStage(e: Event): void {
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function refresh(): void {
			boxLibrary.reset();
			boxLibrary.populateList(appDisplay.appData.boxes);
			//searchBar.reset();
		}

		private function setScroller(): void {
			// set the mask
			if (!_mask) _mask = new Sprite();
			_mask.y = 250;

			if (!_content) _content = boxLibrary;

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
			_scroller.duration = .25;
			_scroller.holdArea = 100;
			_scroller.isStickTouch = false;

			//_scroller.yPerc = 25;
		}

		private function onTouchDown(e: MouseEvent): void {
			if (!_mouseOver) {
				_point.x = e.stageX;
				_point.y = e.stageY;
				_scroller.startScroll(_point); // on touch begin and move
				_mouseOver = true;
			}
		}

		private function onTouchMove(e: MouseEvent): void {
			if (_mouseOver) {
				_point.x = e.stageX;
				_point.y = e.stageY;
				_scroller.startScroll(_point); // on touch begin and move
			}

		}

		private function onTouchUp(e: MouseEvent): void {
			_scroller.fling(); // on touch ended
			_mouseOver = false;
		}

		private function onResize(e: *= null): void {
			if (_mask) drawRect(_mask, 0x000000, 1, MASK_WIDTH, MASK_HEIGHT);

			if (_scroller) {
				_scroller.boundWidth = MASK_WIDTH;
				_scroller.boundHeight = MASK_HEIGHT;
			}

			if (_body && _scroller) {
				//_body.x = (stage.stageWidth / 2) - (_scroller.boundWidth / 2);
				//_body.y = (stage.stageHeight / 2) - (_scroller.boundHeight / 2);
			}
		}

		private function drawRect($target: * , $color: uint, $alpha: Number, $width: Number, $height: Number): void {
			$target.graphics.clear();
			//$target.graphics.lineStyle(5, 0x0000FF, .5, false);
			$target.graphics.beginFill($color, $alpha);
			$target.graphics.drawRect(0, 0, $width, $height);
			$target.graphics.endFill();
		}

		public function onClick(mE: MouseEvent) {
			trace("\nCLICK! - " + mE.target);
			//trace(mE);

			var target = mE.target;

			if (target is TextField) {
				target = target.parent;
				trace("-> parent: " + target);
			}

			if (target is BackButton) {

				if (searchActive) {
					boxLibrary.reset();
					//searchBar.reset();
					refresh();
				} else {
					appDisplay.homeScreenToLogoScreen();
				}

			} else if (target is BoxLibrary_BoxDisplay) {
				appDisplay.homeScreenToBoxScreen(target.box);
			} else if (target is BoxLibrary_ItemDisplay) {
				appDisplay.homeScreenToItemInfoScreen(target.item);
			} else if (target is NewBoxButton) {
				appDisplay.homeScreenToNewBoxScreen();
			} else if (target is ResetAppDataButton) {
				appDisplay.homeScreenResetToLogoScreen();
			}
		}
	}

}