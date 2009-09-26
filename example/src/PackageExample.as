package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	[SWF(width="520",height="400",frameRate="30")]
	
	/**
	 * 一个简易却有效的加密方式，目前的硕思是无法破解出代码的。
	 * （但只要有一点对SWF结构的了解很容易就可以破解了）
	 * 原来的入口类目前无法引用到stage了，只需要处理这一点即可。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class PackageExample extends Sprite
	{
		[Embed(source = "../bin-debug/CollisionExample.swf",mimeType="application/octet-stream")]
		public var app:Class;
		public function PackageExample()
		{
			var loader:Loader = new Loader();
			addChild(loader);
			loader.loadBytes(new app());
		}
	}
}