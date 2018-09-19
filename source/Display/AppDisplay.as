package  {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	
	public class AppDisplay extends Sprite {
		
		public var appData:AppData;
		public var logoScreen : LogoScreen;
		public var homeScreen : HomeScreen;
		public var boxScreen:BoxScreen;
		public var newBoxScreen:NewBoxScreen;
		public var newItemScreen : NewItemScreen;
		public var boxInfoScreen : BoxInfoScreen;
		public var editBoxScreen : EditBoxScreen;
		public var itemInfoScreen : ItemInfoScreen;
		public var editItemScreen : EditItemScreen;
		public var moveBoxScreen : MoveBoxScreen;
		public var moveItemScreen : MoveItemScreen;
		public var tagScreen : TagScreen;
		
		public function AppDisplay(_appData:AppData) {
			// constructor code
			appData = _appData;
			logoScreen = new LogoScreen(this);
			homeScreen = new HomeScreen(this);
			boxScreen = new BoxScreen(this);
			newBoxScreen = new NewBoxScreen(this);
			newItemScreen = new NewItemScreen(this);
			boxInfoScreen = new BoxInfoScreen(this);
			editBoxScreen = new EditBoxScreen(this);
			itemInfoScreen = new ItemInfoScreen(this);
			editItemScreen = new EditItemScreen(this);
			moveBoxScreen = new MoveBoxScreen(this);
			moveItemScreen = new MoveItemScreen(this);
			tagScreen = new TagScreen(this);
			
			startApp();
		}
		
		public function startApp() : void {
			toLogoScreen();
		}
		
		public function toLogoScreen():void {
			addChild(logoScreen);
		}
		
		public function logoScreenToHomeScreen() : void {
			removeChild(logoScreen);
			addChild(homeScreen);
			homeScreen.refresh();
		}
		
		public function homeScreenToLogoScreen() : void {
			removeChild(homeScreen);
			addChild(logoScreen);
		}
		
		public function homeScreenToBoxScreen(newBox:Box) : void {
			removeChild(homeScreen);
			addChild(boxScreen);
			boxScreen.setBox(newBox);
		}
		
		public function homeScreenToTagScreen(newTag:String) : void {
			removeChild(homeScreen);
			addChild(tagScreen);
			tagScreen.setTag(newTag);
		}
		
		public function homeScreenToItemInfoScreen(newItem:Item) : void {
			removeChild(homeScreen);
			addChild(itemInfoScreen);
			itemInfoScreen.setup(newItem);
			boxScreen.setBox(newItem.box);
		}
		
		public function homeScreenResetToLogoScreen() : void {
			var newSharedObject : SharedObject = SharedObject.getLocal(GlobalSharedObject.localString);
			newSharedObject.clear();
			
			homeScreenToLogoScreen();
			
			appData.docClass.loadAppData();
		}
		
		public function boxScreenToHomeScreen(): void {
			removeChild(boxScreen);
			boxScreen.reset();
			addChild(homeScreen);
			homeScreen.refresh();
		}
		
		public function tagScreenToHomeScreen(): void {
			removeChild(tagScreen);
			tagScreen.reset();
			addChild(homeScreen);
			homeScreen.refresh();
		}
		
		public function homeScreenToNewBoxScreen() : void {
			removeChild(homeScreen);
			newBoxScreen.setup();
			addChild(newBoxScreen);
		}
		
		public function newBoxScreenToHomeScreen() : void {
			newBoxScreen.resetAll();
			removeChild(newBoxScreen);
			addChild(homeScreen);
			homeScreen.refresh();
		}
		
		public function boxInfoScreenToHomeScreen() : void {
			boxInfoScreen.reset();
			removeChild(boxInfoScreen);
			addChild(homeScreen);
			homeScreen.refresh();
		}
		
		public function newBoxScreenToBoxScreen(newBox:Box) : void {
			newBoxScreen.resetAll();
			removeChild(newBoxScreen);
			addChild(boxScreen);
			boxScreen.setBox(newBox);
		}

		public function boxScreenToNewItemScreen(thisBox:Box) : void {
			removeChild(boxScreen);
			newItemScreen.setup(thisBox);
			addChild(newItemScreen);
		}

		public function boxScreenToBoxInfoScreen(thisBox:Box) : void {
			removeChild(boxScreen);
			boxInfoScreen.setup(thisBox);
			addChild(boxInfoScreen);
		}

		public function boxScreenToItemInfoScreen(thisItem:Item) : void {
			removeChild(boxScreen);
			itemInfoScreen.setup(thisItem);
			addChild(itemInfoScreen);
		}

		public function tagScreenToBoxInfoScreen(thisBox:Box) : void {
			removeChild(tagScreen);
			boxInfoScreen.setup(thisBox);
			addChild(boxInfoScreen);
		}

		public function tagScreenToItemInfoScreen(thisItem:Item) : void {
			removeChild(tagScreen);
			itemInfoScreen.setup(thisItem);
			addChild(itemInfoScreen);
		}
		
		public function boxInfoScreenToMoveBoxScreen(thisBox:Box) : void {
			boxInfoScreen.reset();
			removeChild(boxInfoScreen);
			moveBoxScreen.setup(thisBox);
			addChild(moveBoxScreen);
		}

		public function moveBoxScreenToBoxInfoScreen(thisBox:Box) : void {
			moveBoxScreen.reset();
			removeChild(moveBoxScreen);
			boxInfoScreen.setup(thisBox);
			addChild(boxInfoScreen);
		}
		
		public function itemInfoScreenToMoveItemScreen(thisItem:Item) : void {
			itemInfoScreen.reset();
			removeChild(itemInfoScreen);
			moveItemScreen.setup(thisItem);
			addChild(moveItemScreen);
		}

		public function moveItemScreenToItemInfoScreen(thisItem:Item) : void {
			moveItemScreen.reset();
			removeChild(moveItemScreen);
			itemInfoScreen.setup(thisItem);
			addChild(itemInfoScreen);
		}
		
		public function newItemScreenToBoxScreen() : void {
			newItemScreen.reset();
			removeChild(newItemScreen);
			addChild(boxScreen);
			boxScreen.refresh();
		}
		
		public function boxInfoScreenToBoxScreen() : void {
			boxScreen.box = boxInfoScreen.box;
			boxInfoScreen.reset();
			removeChild(boxInfoScreen);
			addChild(boxScreen);
			boxScreen.refresh();
		}
		
		public function itemInfoScreenToBoxScreen() : void {
			boxScreen.box = itemInfoScreen.item.box;
			itemInfoScreen.reset();
			removeChild(itemInfoScreen);
			addChild(boxScreen);
			boxScreen.refresh();
			//trace("	-	-	-	-	-	-	-	-	-		: " + boxScreen.box.items);
		}
		
		public function boxInfoScreenToEditBoxScreen(thisBox:Box) : void {
			boxInfoScreen.reset();
			removeChild(boxInfoScreen);
			addChild(editBoxScreen);
			editBoxScreen.setup(thisBox);
		}
		
		public function itemInfoScreenToEditItemScreen(thisItem:Item) : void {
			itemInfoScreen.reset();
			removeChild(itemInfoScreen);
			addChild(editItemScreen);
			editItemScreen.setup(thisItem);
		}
		
		public function editBoxScreenToBoxScreen() : void {
			editBoxScreen.resetAll();
			removeChild(editBoxScreen);
			addChild(boxScreen);
			boxScreen.refresh();
		}
		
		public function editItemScreenToBoxScreen() : void {
			editItemScreen.reset();
			removeChild(editItemScreen);
			addChild(boxScreen);
			boxScreen.refresh();
		}
		
		public function tagScreenToBoxScreen(thisBox:Box) : void {
			boxScreen.box = thisBox;
			removeChild(tagScreen);
			addChild(boxScreen);
			boxScreen.refresh();
		}
		
		
	}
	
}
