package  {
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	
	public class ScrollControllerDoc extends MovieClip {
		
		
		public function ScrollControllerDoc() {
			// constructor code
			var sc :ScrollController = new ScrollController();
			
			var container:RectangleSprite = new RectangleSprite(0x440000, 50, 50, this.stage.stageWidth - 100, this.stage.stageHeight - 100);//red background
			this.addChild(container);
			
			var content:RectangleSprite = new RectangleSprite(0x444477, 0, 0, this.stage.stageWidth - 100, this.stage.stageHeight * 2, 30);//blue foreground
			container.addChild(content);
			
			var containerViewport:Rectangle = new Rectangle(0, 0, this.stage.stageWidth - 100, this.stage.stageHeight - 100);
			
			sc = new ScrollController();
			sc.horizontalScrollingEnabled = false;
			sc.addScrollControll(content, container, containerViewport);
		}
	}
	
}
