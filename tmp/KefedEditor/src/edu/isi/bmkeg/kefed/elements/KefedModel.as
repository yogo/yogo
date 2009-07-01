package edu.isi.bmkeg.kefed.elements
{
	import com.kapit.diagram.IDiagramElement;
	
	import flare.vis.data.Data;
	import flare.vis.data.EdgeSprite;
	import flare.vis.data.NodeSprite;
	
	import mx.collections.ArrayCollection;

	public class KefedModel extends Data
	{
		[Bindable]
		private var _bNodes:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		private var _bEdges:ArrayCollection = new ArrayCollection();
		
		public function get bNodes():ArrayCollection { return _bNodes; }
		public function get bEdges():ArrayCollection { return _bEdges; }
		
		override public function addNode(d:Object=null):NodeSprite {
			_bNodes.addItem(d);
			return super.addNode(d);	
		}

		override public function addEdge(e:EdgeSprite):EdgeSprite {
			_bEdges.addItem(e);
			return super.addEdge(e);	
		}

		override public function removeNode(n:NodeSprite):Boolean {
			
			var kn:KefedObject = KefedObject(n);
			
			var pos:int = -1; 
			for(var i:int=0; i < this._bNodes.length; i++) {
				var obj:KefedObject = _bNodes[i];
				if (obj.uid == kn.uid) {
					pos = i;
					break;
				}
			}
			
			if( pos != -1 ) {
				_bNodes.removeItemAt(pos);
			} else {
				throw new Error("Can't find node, uid: " + kn.uid );
			}
			
			return super.removeNode(n);	
		
		}

		override public function removeEdge(e:EdgeSprite):Boolean {
			
			var ke:KefedLink = KefedLink(e);
			
			var pos:int = -1; 
			for(var i:int=0; i < this._bNodes.length; i++) {
				var link:KefedLink = _bEdges[i];
				if (link.uid == ke.uid) {
					pos = i;
					break;
				}
			}
			
			if( pos != -1 ) {
				_bEdges.removeItemAt(pos);
			} else {
				throw new Error("Can't find edge, uid: " + ke.uid );
			}
			
			return super.removeEdge(e);	
		
		}

		public function KefedModel(directedEdges:Boolean=true)
		{
			super(directedEdges);
		}
		
		public function getKefedObjectFromDiagramElement(el:IDiagramElement):KefedObject
		{
			return this.getKefedObjectFromUID(el.dataobjectid);
		}
		
		public function getKefedObjectFromUID(uid:String):KefedObject
		{
			if (uid)
			{
				for(var i:int=0; i < this.nodes.length; i++)
				{
					var obj:KefedObject = this.nodes[i];
					if (obj.uid == uid)
					{
						return obj;								
					}
				}
			}
			return null;
		}
		
		public function getKefedLinkFromDiagramElement(el:IDiagramElement):KefedLink
		{
			return this.getKefedLinkFromUID(el.dataobjectid);
		}
		
		public function getKefedLinkFromUID(uid:String):KefedLink
		{
			if (uid)
			{
				for(var i:int=0; i < this.edges.length; i++)
				{
					var obj:KefedLink = this.edges[i];
					if (obj.uid == uid)
					{
						return obj;								
					}
				}
			}
			return null;
		}
		
	}
		
}