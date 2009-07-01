package edu.isi.bmkeg.kefed.elements
{

	import com.kapit.diagram.view.DiagramView;
	import com.kapit.diagram.IDiagramElement;
	
	public class KefedDiagramView extends DiagramView
	{

		public override function notifyElementMoved(arg0:IDiagramElement):void
		{
			super.notifyElementMoved(arg0);
		}

		public override function notifyElementCreated(arg0:IDiagramElement):void
		{
			super.notifyElementCreated(arg0);
		}

	}

}