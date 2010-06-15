SCUI.WIDGET_TYPE="widget";SCUI.WIDGET_EDIT="editing";SCUI.DashboardDelegate={isDashboardDelegate:YES,dashboardWidgetViewFor:function(a,c,d,b){return null
},dashboardWidgetEditViewFor:function(a,c,d,b){return null},dashboardWidgetDidMove:function(a,b){},dashboardDeleteWidget:function(a,b){return NO
},dashboardWidgetDidCommitEditing:function(a,b){}};SCUI.Widget={isWidget:YES,widgetViewClassKey:"widgetViewClass",widgetEditViewClassKey:"widgetEditViewClass",positionKey:"position",sizeKey:"size",nameKey:"name",isLocked:NO,canEdit:YES,isEditing:NO,showDoneButton:YES,widgetDidMove:function(){},widgetDidCommitEditing:function(){}};
sc_require("mixins/widget");SCUI.ClockWidget=SC.Object.extend(SCUI.Widget,{widgetViewClass:"SCUI.ClockWidgetView",widgetEditViewClass:"SCUI.ClockWidgetEditView",position:{x:40,y:40},size:{width:320,height:150},showGreeting:NO,greeting:"Hello World".loc(),now:"--",value:function(){return this.get(this.get("showGreeting")?"greeting":"now")
}.property("showGreeting","greeting","now").cacheable(),init:function(){arguments.callee.base.apply(this,arguments);
this.tick()},tick:function(){this.set("now",new Date().format("hh:mm:ss"));this.invokeLater(this.tick,1000)
}});sc_require("models/clock_widget");SCUI.ClockWidgetView=SC.View.extend({layout:{left:0,right:0,top:0,bottom:0},content:null,childViews:["clockView"],clockView:SC.View.design({classNames:["scui-clock-widget-view"],layout:{left:0,right:0,top:0,bottom:0},childViews:["labelView"],labelView:SC.LabelView.design({layout:{left:10,right:10,centerY:0,height:48},tagName:"h1",valueBinding:".parentView.parentView*content.value"})})});
SCUI.ClockWidgetEditView=SC.View.extend({layout:{left:0,right:0,top:0,bottom:0},content:null,childViews:["optionView"],optionView:SC.View.design({classNames:["scui-clock-widget-view"],layout:{left:0,right:0,top:0,bottom:0},childViews:["checkboxView"],checkboxView:SC.CheckboxView.design({layout:{centerX:0,centerY:0,width:130,height:18},title:"Show Greeting".loc(),valueBinding:".parentView.parentView*content.showGreeting"})})});
SCUI.MissingWidgetView=SC.View.extend(SC.Border,{layout:{left:0,right:0,top:0,bottom:0},message:"Widget is missing or broken. Please remove and replace this widget using the plus button in the bottom left.".loc(),classNames:"missing-widget".w(),createChildViews:function(){var a=[];
a.push(this.createChildView(SC.LabelView.design({layout:{left:10,right:10,centerY:0,height:40},textAlign:SC.ALIGN_CENTER,value:this.get("message")})));
this.set("childViews",a)}});sc_require("views/missing_widget");SCUI.WidgetContainerView=SC.View.extend(SC.Control,{classNames:["scui-widget-container-view"],canDeleteWidget:NO,layout:{left:0,top:0,width:400,height:200},widgetViewClass:null,widgetEditViewClass:null,deleteHandleViewClass:SC.View.extend(SCUI.SimpleButton,{classNames:["scui-widget-delete-handle-view"],layout:{left:0,top:0,width:28,height:28}}),editHandleViewClass:SC.View.extend(SCUI.SimpleButton,{classNames:["scui-widget-edit-handle-view"],layout:{right:0,top:0,width:28,height:28}}),doneButtonViewClass:SC.ButtonView.extend({classNames:["scui-widget-done-button-view"],layout:{right:10,bottom:10,width:80,height:24},title:"Done".loc()}),displayProperties:["canDeleteWidget","isEditing"],createChildViews:function(){var e=[];
var d;var c=this.get("content");var b=c?c.get("isEditing"):NO;var f=c?c.get("showDoneButton"):NO;
var a=c?c.get("canEdit"):NO;d=this._getViewClass("widgetEditViewClass");if(!d){d=SCUI.MissingWidgetView.extend({backgroundColor:"#729c5a",message:"Widget's edit view is missing.".loc()})
}this._editView=this.createChildView(d,{content:c,isVisible:(a&&b)});e.push(this._editView);
d=this._getViewClass("doneButtonViewClass");if(d){this._doneButtonView=this.createChildView(d,{target:this,action:"commitEditing",isVisible:(a&&b&&f)});
e.push(this._doneButtonView)}d=this._getViewClass("widgetViewClass");if(!d){d=SCUI.MissingWidgetView
}this._widgetView=this.createChildView(d,{content:c,isVisible:(!b||!a)});e.push(this._widgetView);
d=this._getViewClass("editHandleViewClass");if(d){this._editHandleView=this.createChildView(d,{target:this,action:"beginEditing",isVisible:(a&&!b)});
e.push(this._editHandleView)}d=this._getViewClass("deleteHandleViewClass");if(d){this._deleteHandleView=this.createChildView(d,{target:this,action:"deleteWidget",isVisible:this.get("canDeleteWidget")});
e.push(this._deleteHandleView)}this.set("childViews",e)},beginEditing:function(){if(this.getPath("content.canEdit")){this.setPathIfChanged("content.isEditing",YES)
}},commitEditing:function(){var b=this.get("content");var a=this.get("dashboardDelegate");
this.setPathIfChanged("content.isEditing",NO);if(a&&a.dashboardWidgetDidCommitEditing){a.dashboardWidgetDidCommitEditing(this.get("owner"),b)
}if(b&&b.widgetDidCommitEditing){b.widgetDidCommitEditing()}},deleteWidget:function(){var a=this.get("owner");
if(a&&a.deleteWidget){a.deleteWidget(this.get("content"))}},contentPropertyDidChange:function(b,a){if(a===this.getPath("content.sizeKey")){this._sizeDidChange()
}else{if(a==="isEditing"){this._isEditingDidChange()}}},_sizeDidChange:function(){var a=this.getPath("content.sizeKey");
var b=a?this.getPath("content.%@".fmt(a)):null;if(b){this.adjust({width:(parseFloat(b.width)||0),height:(parseFloat(b.height)||0)})
}},_isEditingDidChange:function(){var c=this.get("content");var b=c?c.get("isEditing"):NO;
var a=c?c.get("canEdit"):NO;var d=c?c.get("showDoneButton"):NO;if(this._editView){this._editView.set("isVisible",(a&&b))
}if(this._doneButtonView){this._doneButtonView.set("isVisible",(a&&b&&d))}if(this._widgetView){this._widgetView.set("isVisible",(!b||!a))
}if(this._editHandleView){this._editHandleView.set("isVisible",(a&&!b))}},_canDeleteWidgetDidChange:function(){if(this._deleteHandleView){this._deleteHandleView.set("isVisible",this.get("canDeleteWidget"))
}}.observes("canDeleteWidget"),_contentDidChange:function(){var a=this.get("content");
if(this._widgetView){this._widgetView.set("content",a)}if(this._editView){this._editView.set("content",a)
}}.observes("content"),_getViewClass:function(e){var f=this.get(e);var d,a,b;if(SC.typeOf(f)===SC.T_STRING){d=SC.tupleForPropertyPath(f);
if(d){a=d[0];b=d[1];f=a.get?a.get(b):a[b]}}return(f&&f.kindOf(SC.View))?f:null},_widgetView:null,_editView:null,_activeView:null,_deleteHandleView:null,_editHandleView:null,_doneButtonView:null});
sc_require("views/widget_container");sc_require("mixins/dashboard_delegate");SCUI.DashboardView=SC.View.extend(SCUI.DashboardDelegate,{classNames:"scui-dashboard-view",content:null,acceptsFirstResponder:YES,canDeleteContent:NO,widgetContainerView:SCUI.WidgetContainerView,delegate:null,dashboardDelegate:function(){var a=this.get("delegate");
var b=this.get("content");return this.delegateFor("isDashboardDelegate",a,b)}.property("delegate","content").cacheable(),didCreateLayer:function(){arguments.callee.base.apply(this,arguments);
this._contentDidChange()},beginManaging:function(){this.setIfChanged("canDeleteContent",YES)
},endManaging:function(){this.setIfChanged("canDeleteContent",NO)},deleteWidget:function(c){var b=this.get("content");
var a=this.get("dashboardDelegate");if((a&&!a.dashboardDeleteWidget(this,c))||!a){if(b&&b.removeObject){b.removeObject(c)
}}},mouseDown:function(a){var b,d,c;this._dragData=null;if(a&&a.which===1){b=this._itemViewForEvent(a);
if(b&&!b.getPath("content.isLocked")){this._dragData=SC.clone(b.get("layout"));this._dragData.startPageX=a.pageX;
this._dragData.startPageY=a.pageY;this._dragData.view=b;this._dragData.didMove=NO
}}return YES},mouseDragged:function(c){var b,a;if(this._dragData){this._dragData.didMove=YES;
b=c.pageX-this._dragData.startPageX;a=c.pageY-this._dragData.startPageY;this._dragData.view.adjust({left:this._dragData.left+b,top:this._dragData.top+a})
}return YES},mouseUp:function(b){var c,e,d,a;if(this._dragData&&this._dragData.didMove){c=this._dragData.view.get("content");
e=this._dragData.view.get("frame");if(c&&e){d={x:e.x,y:e.y};this._setItemPosition(c,d);
if(c.widgetDidMove){c.widgetDidMove();a=this.get("dashboardDelegate");if(a&&a.dashboardWidgetDidMove){a.dashboardWidgetDidMove(this,c)
}}}}this._dragData=null;return YES},_contentDidChange:function(){this.invokeOnce("_updateItemViews")
}.observes("*content.[]"),_canDeleteContentDidChange:function(){var b=this.get("canDeleteContent");
var a=this._itemViews||[];a.forEach(function(c){c.setIfChanged("canDeleteWidget",b)
})}.observes("canDeleteContent"),_updateItemViews:function(){var m=this.get("content");
var a=this._itemViewCache||{};var f=[];var b={};var r=this.get("dashboardDelegate");
var o=this.get("canDeleteContent");var n=this.get("widgetContainerView");var d=[],h=[];
var l=this;var e,g,q,j,c,p,k;if(m&&m.isEnumerable){m.forEach(function(s,i){q=SC.guidFor(s);
c=a[q];if(!c){p={widgetViewClass:r.dashboardWidgetViewFor(l,m,i,s)||s.get(s.get("widgetViewClassKey")),widgetEditViewClass:r.dashboardWidgetEditViewFor(l,m,i,s)||s.get(s.get("widgetEditViewClassKey")),canDeleteWidget:o,content:s,owner:l,displayDelegate:l,dashboardDelegate:r,layout:l._layoutForItemView(s),layerId:"%@-%@".fmt(SC.guidFor(l),q)};
c=l.createChildView(n,p)}f.push(c);b[q]=c})}if(!f.isEqual(this._itemViews)){this.beginPropertyChanges();
this.removeAllChildren();f.forEach(function(i){l.appendChild(i)});this._itemViews.forEach(function(i){if(f.indexOf(i)<0){i.set("content",null)
}});this.endPropertyChanges()}this._itemViews=f;this._itemViewCache=b},_layoutForItemView:function(c){var b=null,d,a;
if(c){d=this._getItemPosition(c)||{x:20,y:20};a=this._getItemSize(c)||{width:300,height:100};
b={left:d.x,top:d.y,width:a.width,height:a.height}}return b},_itemViewForEvent:function(i){var d=this.getPath("pane.rootResponder");
if(!d){return null}var c=SC.guidFor(this)+"-",a=c.length,e=i.target,f=this.get("layer"),b,h,g=null;
while(e&&e!==document&&e!==f){b=e?SC.$(e).attr("id"):null;if((b.length>c.length)&&(b.indexOf(c)===0)){h=b.slice(b.lastIndexOf("-")+1);
if(g=this._itemViewCache[h]){break}}e=e.parentNode}return g},_getItemPosition:function(b){var a,c;
if(b){a=b.get("positionKey")||"position";c=b.get(a);if(c){return{x:(parseFloat(c.x)||0),y:(parseFloat(c.y)||0)}
}}return null},_setItemPosition:function(b,c){var a;if(b){a=b.get("positionKey")||"position";
b.set(a,c)}},_getItemSize:function(c){var a,b;if(c){a=c.get("sizeKey");b=a?c.get(a):null;
if(b){return{width:(parseFloat(b.width)||0),height:(parseFloat(b.height)||0)}}}return null
},_setItemSize:function(c,b){var a;if(c){a=c.get("sizeKey");if(a){c.set(a,b)}}},_itemViewCache:{},_itemViews:[]});
if((typeof SC!=="undefined")&&SC&&SC.bundleDidLoad){SC.bundleDidLoad("scui/dashboard")
};