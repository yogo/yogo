package edu.isi.bmkeg.kefed.elements
{
	import flare.vis.data.EdgeSprite;
	import flare.vis.data.NodeSprite;

	public class KefedLink extends EdgeSprite
	{
		[Bindable]
		public var uid:String;
		
		[Bindable]
		public var start:String;
		
		[Bindable]
		public var end:String;
		
		public function KefedLink(uid:String=null, source:NodeSprite=null, 
				target:NodeSprite=null, directed:Boolean=true)	{
					
			this.uid = uid;
			
			var s:KefedObject = KefedObject(source);
			var t:KefedObject = KefedObject(target);
			
			this.start = s.uid;
			this.end = t.uid;
			
			super(source, target, directed);
		
		}
		
	}
	
}