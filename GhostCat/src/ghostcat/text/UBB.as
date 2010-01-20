package ghostcat.text
{
	public class UBB
	{
		public static function decode(v:String):String
		{
			v = v.replace(/\[(b|i|u)\]/ig,"<$1>");
			v = v.replace(/\[\/(b|i|u)\]/ig,"</$1>");
			
			v = v.replace(/\[(color|size|face|align)=(.*?)]/ig,replFN);
			v = v.replace(/\[\/(color|size|face|align)\]/ig,"</font>");
			
			v = v.replace(/\[img\](.*?)\[\/img\]/ig,"<img src='$1'/>");
			v = v.replace(/\[url\](.*?)\[\/url\]/ig,"<a href='$1'/>$1</a>");
			v = v.replace(/\[url=(.*?)\](.*)?\[\/url\]/ig,"<a href='$1'/>$2</a>");
			v = v.replace(/\[email\](.*?)\[\/email\]/ig,"<a href='mailto:$1'>$1</a>");
			v = v.replace(/\[email=(.*?)\](.*)?\[\/email\]/ig,"<a href='mailto:$1'>$2</a>");
			
			return v;
		}
		
		private static const COLORS:Array = ["red","blue","green","yellow","fuchsia","aqua","black","white","gray"];
		private static const COLOR_REPS:Array = ["#FF0000","#0000FF","#00FF00","#FFFF00","#FF00FF","#00FFFF","#000000","#FFFFFF","#808080"];
		
		private static function replFN():String
		{
			var s:String = arguments[2];
			var f:String = s.charAt(0);
			var e:String = s.charAt(s.length - 1);
			if (e == f && (e == "'" || e=="\""))
				s = s.slice(1,s.length - 1);
			
			if (arguments[1].toLowerCase() == "color")
			{
				var index:int = COLORS.indexOf(s.toLowerCase());
				if (index != -1)
					s = COLOR_REPS[index];
			}
			
			return "<font "+arguments[1]+"=\""+s+"\">"
		}
	}
}