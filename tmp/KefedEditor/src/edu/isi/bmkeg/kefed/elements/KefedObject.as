package edu.isi.bmkeg.kefed.elements
{
	import flare.data.DataField;
	import flare.data.DataSchema;
	import flare.data.DataTable;
	import flare.data.DataUtil;
	import flare.vis.data.NodeSprite;
	import mx.collections.ArrayCollection;
			
	public class KefedObject extends NodeSprite
	{
		[Bindable]
		public var type:String;

		[Bindable]
		public var spriteid:String;

		[Bindable]
		public var did:String;

		[Bindable]
		public var nameValue:String;	
		
		[Bindable]
		public var uid:String;
		
		[Bindable]
		public var compositions:Number;

		[Bindable]
		public var master:String;

		[Bindable]
		public var dataTable:ArrayCollection;
		
		public function KefedObject()
		{
            dataTable = new ArrayCollection();
			super();
		}

	}
	
}