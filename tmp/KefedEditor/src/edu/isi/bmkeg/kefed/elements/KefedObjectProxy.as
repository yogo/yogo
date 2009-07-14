package edu.isi.bmkeg.kefed.elements
{
	import com.kapit.diagram.IDiagramElement;
	import com.kapit.diagram.layers.DiagramLane;
	import com.kapit.diagram.model.ISpriteProxy;
	import com.kapit.diagram.view.DiagramSprite;
	import com.kapit.diagram.view.DiagramView;
	
	import flare.vis.data.Data;
	
	import mx.collections.ArrayCollection;
	import mx.utils.UIDUtil;

	public class KefedObjectProxy implements ISpriteProxy
	{
		public static var _graph:KefedModel = null;
		
		protected var _view:DiagramView;
		
		public function KefedObjectProxy(view:DiagramView)
		{
			_view = view;
		}
	
		protected function getElementSpriteId(el:IDiagramElement):String
		{	
			if (el is DiagramSprite)
			{
				var s:DiagramSprite = el as DiagramSprite;
				return s.spriteid;
			}
			return null;
		}		
		
		public function createDataObject(el:IDiagramElement):String
		{
			var type:String = el.getTagName();
			var spriteid:String = DiagramSprite(el).spriteid;
			var name:String = el.did;
			var uid:String = UIDUtil.createUID();
			var obj:KefedObject = new KefedObject();
			obj.type = type;
			obj.spriteid = spriteid;
			obj.did = el.did;
			obj.uid = uid;
			obj.nameValue = "";
			obj.compositions = 0;
			obj.master = "";
			if(_graph) {
				_graph.addNode(obj);
			}
			return uid;
		}
		
		public function removeDataObject(el:IDiagramElement):void
		{
			
			var obj:KefedObject = _graph.getKefedObjectFromDiagramElement(el);
			if (obj) {
				_graph.removeNode(obj);
			}
		
		}
		
		public function allowLinkAction(el:IDiagramElement):Boolean
		{
			return true;
		}
		
		public function propertyModified(el:IDiagramElement, propname:String, propvalue:Object, shapeid:String):void
		{
			var obj:KefedObject = _graph.getKefedObjectFromDiagramElement(el);
			var s:DiagramSprite = null;
			if (el is DiagramSprite)
				s = el as DiagramSprite;

			if ("text" == propname)
			{
				if (obj)
				{
					obj.nameValue = String(propvalue);
					
					/* Trying to center the annotations without any success...
					var x:Number = s.innercenter.x - (s.annotation.innerbox.width / 2.0);
					var y:Number = s.innercenter.y - (s.annotation.innerbox.height / 2.0);
					s.annotation.setPosition(x, y, false);*/
				}				
			}
			if ("compositionmasterleave" == propname)
			{
				if (s && "rectangle-composed" == shapeid)
				{	
					s.spriteid = "rectangle";	
					s.dragenabled = true;
					s.selectable = true;
					if (obj)
					{
						obj.spriteid = s.spriteid;			
						obj.master="";
					}				
				}
			}			
			if ("compositionmaster" == propname)
			{
				if (s && "rectangle" == shapeid)
				{
					s.spriteid = "rectangle-composed";	
					s.dragenabled = true;
					s.selectable = true;		
					if (obj)
					{				
						obj.master=DiagramSprite(propvalue).did;
						obj.spriteid = s.spriteid;
					}				
				}
			}
			if ("compositionelement" == propname)
			{
				if (obj)
				{				
					obj.compositions=obj.compositions + 1;
				}				
			}			 
			if ("compositionelementremove" == propname)
			{
				if (obj)
				{			
					obj.compositions=obj.compositions - 1;
				}				
			}			 

		}
		
		public function preAcceptLinkSource(spriteid:String, sourcespriteid:String, el:IDiagramElement):Boolean
		{
			if (spriteid.indexOf("-composed") != -1 || sourcespriteid.indexOf("-composed") != -1 || spriteid == "comment" || sourcespriteid == "comment")
				return false;
			return true;
		}
		
		public function preAcceptLinkTarget(spriteid:String, targetspriteid:String, el:IDiagramElement):Boolean
		{
			if (spriteid.indexOf("-composed") != -1 || 
					targetspriteid.indexOf("-composed") != -1 || 
					spriteid == "comment" || 
					targetspriteid == "comment" || targetspriteid == "Independent Variable Data")
				return false;
			return true;
		}
		
		public function dataObjectPropertyModified(uid:String, propname:String, propvalue:Object):void
		{
		}
		
		public function acceptLinkTarget(el:IDiagramElement, target:IDiagramElement):Boolean
		{
			if (getElementSpriteId(el) == "comment" || getElementSpriteId(target) == "comment")
				return false;
			return true;
		}
		
		public function dataObjectRemoved(uid:String):void
		{
		}
		
		public function dataObjectLoaded(el:IDiagramElement):void
		{
		}
				
		public function acceptLinkSource(el:IDiagramElement, source:IDiagramElement):Boolean
		{
			if (getElementSpriteId(el) == "comment" || getElementSpriteId(source) == "comment")
				return false;
			
			return true;
		}
		
		public function laneChanged(el:IDiagramElement, lane:DiagramLane):void
		{
		}
		
		public function acceptPropertyModification(el:IDiagramElement,propname:String,propvalue:Object,shapeid:String):Boolean
		{
			var obj:KefedObject =  _graph.getKefedObjectFromDiagramElement(el);

			if ("text" == propname)
			{
				return true;				
			}
			if ("compositionmasterleave" == propname)
			{
				return true;
			}			
			if ("compositionmaster" == propname)
			{
				return ((el as DiagramSprite).masterobject == null || (el as DiagramSprite).masterobject == propvalue);
			}
			if ("compositionelement" == propname)
			{
				// No more than one element in a composition
				if (obj)
				{				
					return ((obj.compositions<1) || (obj.compositions == 1 && (propvalue as DiagramSprite).masterobject == el));						
				}				
			}			 
			if ("compositionelementremove" == propname)
			{
				return true;
			}					
			return true;
		}
		
		public function acceptRemoveObject(el:IDiagramElement):Boolean
		{
			var s:DiagramSprite = el as DiagramSprite;		
			if (s && s.masterobject)
				return false;	
			return true;
		}
		
	}
}