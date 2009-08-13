package org.ghostcat.display
{
	/**
	 * 浏览器IFrame
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class IFrame extends GNoScale
	{
		import flash.external.ExternalInterface;
        import flash.geom.Point;
        import flash.net.navigateToURL;
		
		[Embed(source = "IFrame.js",mimeType="application/octet-stream")]
		private static var jsCode:Class;
		ExternalInterface.available && ExternalInterface.call("eval",new jsCode().toString());
		
		
		private var _url: String;
		private var _id:String;
		
		public function IFrame(id:String = "myFrame")
		{
			super();
			this._id = id;
			
			ExternalInterface.call("IFrameManager.createIFrame", id);
		}
		
		public override function updateSize() : void
		{
			super.updateSize();
			moveIFrame();
		}
		
		public override function updatePosition() : void
		{
			super.updatePosition();
			moveIFrame();
		}
		
		private function moveIFrame(): void
        {
        	if (!_url)
        		return;

            var localPt:Point = new Point(0, 0);
            var globalPt:Point = this.localToGlobal(localPt);

            ExternalInterface.call("IFrameManager.moveIFrame", id ,globalPt.x, globalPt.y, this.width, this.height);
        }
        
        /**
         * IFrame的唯一标识
         * @return 
         * 
         */
        public function get id():String
        {
        	return _id;
        }

        /**
         * 网页URL
         * @param source
         * 
         */
        public function set url(v: String): void
        {
            if (v)
            {
                _url = v;
                
                ExternalInterface.call("IFrameManager.loadIFrame", id ,_url);
                moveIFrame();
                
                this.visible = visible;
            }
        }

        public function get url(): String
        {
            return _url;
        }

        override public function set visible(v: Boolean): void
        {
            super.visible = v;

            ExternalInterface.call(v ? "IFrameManager.showIFrame":"IFrameManager.hideIFrame" , id);            
        }
        
        override public function destory() : void
        {
        	super.destory();
        	
        	ExternalInterface.call("IFrameManager.removeIFrame", id);
        }
	}
}