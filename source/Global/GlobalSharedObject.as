package {

	import flash.net.SharedObject;
	import flash.utils.getQualifiedClassName;
	import flash.net.getClassByAlias;
	import flash.text.ReturnKeyLabel;
	import flash.net.registerClassAlias;

	public class GlobalSharedObject {

		private static var _instance: GlobalSharedObject;
		private static var _allowInstantiation: Boolean;

		private static var _sharedObject: SharedObject;
		public static var localString: String = "WhereTheBox10"


		// v v v v v
		// Stored:
		//
		//    

		public function get sharedObject(): SharedObject {
			return _sharedObject;
		}

		public static function get instance(): GlobalSharedObject {

			if (!_instance) {
				_allowInstantiation = true;
				_instance = new GlobalSharedObject();
				_allowInstantiation = false;

				_sharedObject = SharedObject.getLocal(localString);
			}

			return _instance;
		}


		// check boxes
		public function boxesCheck(): void {
			if (_sharedObject.data.boxes == null) {
				_sharedObject.data.boxes = [];
				_sharedObject.flush();
			}
		}

		// check tags
		public function tagsCheck(): void {
			if (_sharedObject.data.tags == null) {
				_sharedObject.data.tags = [];
				_sharedObject.flush();
			}
		}

		// check locations
		public function locationsCheck(): void {
			if (_sharedObject.data.locations == null) {
				_sharedObject.data.locations = [];
				_sharedObject.flush();
			}
		}

		public function get boxes(): Array {
			trace(" - - Retrieving Boxes - - ");
			boxesCheck();
			trace(" - - " + _sharedObject.data.boxes);
			return _sharedObject.data.boxes;
		}

		public function get tags(): Array {
			trace(" - - Retrieving Tags - - ");
			tagsCheck();
			trace(" - - " + _sharedObject.data.tags);
			return _sharedObject.data.tags;
		}

		public function get locations(): Array {
			trace(" - - Retrieving Locations - - ");
			locationsCheck();
			trace(" - - " + _sharedObject.data.locations);
			return _sharedObject.data.locations;
		}
		
		public function saveAppData(_appData:AppData) : void {
			_sharedObject = SharedObject.getLocal(localString);
			registerClassAlias("AppData", AppData);
			_sharedObject.data.appData = _appData;
			_sharedObject.flush();
		}
		
		public function loadAppData() : AppData {
			_sharedObject = SharedObject.getLocal(localString);
			registerClassAlias("AppData", AppData);
			var loadedAppData:AppData = _sharedObject.data.appData;
			trace(" * * LOADED APP DATA " + loadedAppData + " * * ");
			return loadedAppData;
		}
		
		public function saveData(_boxes:Array, _tags:Array, _locations:Array) : void {
			
			trace(" - SAVING DATA - ");
			trace("boxes: " + _boxes);
			trace("tags: " + _tags);
			trace("locations: " + _locations);
			
			boxesCheck();
			_sharedObject.data.boxes = _boxes;
			_sharedObject.flush();
			
			tagsCheck();
			_sharedObject.data.tags = _tags;
			_sharedObject.flush();
			
			locationsCheck();
			_sharedObject.data.locations = _locations;
			_sharedObject.flush();
		}

		// *** reset function ***

		public function resetSharedObject(): void {
			_sharedObject.clear();
			_sharedObject = SharedObject.getLocal(localString);
		}

		public function GlobalSharedObject(): void {
			if (!_allowInstantiation) {
				throw new Error("ERROR: STOP IT FOOL, DON'T INITIALIZE!!");
			}
		}

	}

}