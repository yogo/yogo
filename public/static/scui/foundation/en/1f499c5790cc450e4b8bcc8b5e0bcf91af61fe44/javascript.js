var Scui=Scui||{};var SCUI=SCUI||Scui;SCUI.READY="READY";SCUI.BUSY="BUSY";SCUI.DONE="DONE";
SCUI.READY="READY";SCUI.BUSY="BUSY";SCUI.DONE="DONE";SCUI.DISCLOSED_STAND_ALONE="standAlone";
SCUI.DISCLOSED_LIST_DEPENDENT="listDependent";SCUI.DISCLOSED_OPEN="open";SCUI.DISCLOSED_CLOSED="closed";
SCUI.DEFAULT_TREE="default";sc_require("core");SCUI.SearchableArrayController=SC.ArrayController.extend({search:null,searchResults:[],searchKey:"name",init:function(){arguments.callee.base.apply(this,arguments);
this.set("searchResults",[]);this._runSearch()},_searchOrContentDidChange:function(){this._runSearch()
}.observes("search","content"),_sanitizeSearchString:function(c){var a=["/",".","*","+","?","|","(",")","[","]","{","}","\\"];
var b=new RegExp("(\\"+a.join("|\\")+")","g");return c.replace(b,"\\$1")},_runSearch:function(){var a=[];
var m=this.get("search");var d=this.get("searchKey");var l=new RegExp(m,"i");var h=this.get("content");
if(m===null||m===""||m===undefined){this.set("searchResults",h)}else{m=this._sanitizeSearchString(m).toLowerCase();
var j,k,b,c,e;for(var f=0,g=h.get("length");f<g;f++){j=h.objectAt(f);k=j.get(d);if(!k){continue
}if(k.match(l)){a.push(j)}}this.set("searchResults",a)}}});sc_require("core");SCUI.SearchableTreeController=SC.TreeController.extend({search:null,searchResults:[],searchKey:"name",iconKey:"icon",nameKey:"name",init:function(){arguments.callee.base.apply(this,arguments);
this.set("searchResults",[]);this._runSearch()},_searchDidChange:function(){this._runSearch()
}.observes("search","content"),_sanitizeSearchString:function(c){var a=["/",".","*","+","?","|","(",")","[","]","{","}","\\"];
var b=new RegExp("(\\"+a.join("|\\")+")","g");return c.replace(b,"\\$1")},_runSearch:function(){var d=[];
var b=this.get("search");var g=this.get("content");if(b===null||b===""||b===undefined){this.set("searchResults",g)
}else{b=this._sanitizeSearchString(b).toLowerCase();var e=new RegExp(b,"i");var f=this.get("searchKey");
this._iconKey=this.get("iconKey");this._nameKey=this.get("nameKey");d=this._runSearchOnItem(g,b,e,f);
var a=SC.Object.create({treeItemIsExpanded:YES,treeItemChildren:d});this.set("searchResults",a)
}},_runSearchOnItem:function(e,l,k,c){var a=[],h=this.get("iconKey"),f,i,j,b,d=this._nameKey,g;
if(SC.none(e)){return a}b=e.get("treeItemChildren");if(!b){b=e.get("children")}g=this;
b.forEach(function(o){if(o.treeItemChildren){var m=g._runSearchOnItem(o,l,k,c);m.forEach(function(p){a.push(p)
})}if(c&&o.get(c)){i=o.get(c).toLowerCase();if(i.match(k)){var n=SC.Object.create({});
n[c]=o.get(c);n[d]=o.get(d);n.treeItem=o;n.icon=o.get(this._iconKey);a.push(n)}}});
return a}});sc_require("core");SCUI.Cleanup={isClean:YES,log:NO,setup:function(){if(this.log){console.log("%@.setup()".fmt(this))
}},cleanup:function(){if(this.log){console.log("%@.cleanup()".fmt(this))}},destroyMixin:function(){this._c_cleanupIfNeeded();
this._c_bindings=null},_c_isVisibleInWindowDidChange:function(){if(this.get("isVisibleInWindow")){this._c_setupIfNeeded()
}else{this._c_cleanupIfNeeded()}}.observes("isVisibleInWindow"),_c_setupIfNeeded:function(){if(this.get("isClean")&&this.get("isVisibleInWindow")){this.setup();
this.set("isClean",NO)}},_c_cleanupIfNeeded:function(){if(!this.get("isClean")&&!this.get("isVisibleInWindow")){this.cleanup();
this.set("isClean",YES)}},_c_disconnectBindings:function(){var d=this.get("bindings")||[];
var a=d.get("length");var c;for(var b=0;b<a;b++){c=d.objectAt(b);c.disconnect();if(this.log){console.log("### disconnecting %@".fmt(c))
}}this._c_bindings=d.slice();this.set("bindings",[])},_c_connectBindings:function(){var d=this._c_bindings||[];
var a=d.get("length");var c;for(var b=0;b<a;b++){c=d.objectAt(b);c.connect();if(this.log){console.log("### connecting %@".fmt(c))
}}this._c_bindings=null},_c_bindings:null};sc_require("core");SCUI.DropDown={isShowingDropDown:NO,_dropDownPane:null,dropDown:SC.MenuPane.design({layout:{width:100,height:0},contentView:SC.View.design({}),items:["_item".loc("1"),"_item".loc("2")]}),dropDownType:SC.PICKER_MENU,initMixin:function(){var a=this.get("dropDown");
if(a&&SC.typeOf(a)===SC.T_CLASS){this._dropDownPane=a.create();if(this._dropDownPane){this.bind("isShowingDropDown","._dropDownPane.isPaneAttached")
}}if(this.target!==undefined&&this.action!==undefined){this.set("target",this);this.set("action","toggle")
}},hideDropDown:function(){if(this._dropDownPane&&SC.typeOf(this._dropDownPane.remove)===SC.T_FUNCTION){this._dropDownPane.remove();
this.set("isShowingDropDown",NO)}},showDropDown:function(){this.hideDropDown();if(this._dropDownPane&&SC.typeOf(this._dropDownPane.popup)===SC.T_FUNCTION){var a=this.get("dropDownType");
this._dropDownPane.popup(this,a);this.set("isShowingDropDown",YES)}},toggle:function(){if(this.get("isShowingDropDown")){this.hideDropDown()
}else{this.showDropDown()}}};sc_require("core");SCUI.CollectionViewDynamicDelegate={isCollectionViewDynamicDelegate:YES,collectionViewContentExampleViewFor:function(a,b,c){return null
},controllerForContent:function(a){return null},customRowViewMetadata:null,contentViewMetadataForContentIndex:function(a,d){var c=null;
if(a&&a.get("isDynamicCollection")){var b=a.get("customRowViewMetadata");if(!SC.none(b)){c=b.objectAt(d)
}}return c},contentViewDidChangeForContentIndex:function(a,c,b,d){if(a&&a.isDynamicCollection&&c&&c.isDynamicListItem){this.collectionViewSetMetadataForContentIndex(a,c.get("viewMetadata"),d)
}},collectionViewInsertMetadataForContentIndex:function(b,d,e){var c=b.get("customRowViewMetadata");
if(SC.none(c)){return}var a=c.get("length");console.log("Before Insert Length: %@".fmt(a));
if(a<1){c=[d]}else{c.replace(e,0,[d])}console.log("After Insert Length: %@".fmt(c.length));
b.set("customRowViewMetadata",c);b.rowHeightDidChangeForIndexes(e)},collectionViewSetMetadataForContentIndex:function(a,d,e){console.log("\nCollectionViewDynamicDelegate(%@): collectionViewSetMetadataForContentIndex for (%@)".fmt(this,e));
if(a&&a.get("isDynamicCollection")){var b=a.get("customRowHeightIndexes");if(SC.none(b)){b=SC.IndexSet.create()
}b.add(e,1);a.set("customRowHeightIndexes",b);var c=a.get("customRowViewMetadata");
if(SC.none(c)){c=SC.SparseArray.create()}c.replace(e,1,[d]);a.set("customRowViewMetadata",c);
a.rowHeightDidChangeForIndexes(e)}return d}};sc_require("core");SCUI.DynamicCollection={isDynamicCollection:YES,customRowViewMetadata:null,initMixin:function(){this.set("customRowViewMetadata",SC.SparseArray.create());
this.set("rowDelegate",this)},rowMargin:0,itemViewForContentIndex:function(l,k){var i=this.get("content"),d=this._sc_itemViews,p=i.objectAt(l),a=this.get("contentDelegate"),o=this.get("delegate"),j=a.contentGroupIndexes(this,i),c=NO,n,h,q,g,b,e;
if(!d){d=this._sc_itemViews=[]}if(!k&&(h=d[l])){return h}c=j&&j.contains(l);if(c){c=a.contentIndexIsGroup(this,p,l)
}if(c){n=this.get("contentGroupExampleViewKey");if(n&&p){q=p.get(n)}if(!q){q=this.get("groupExampleView")||this.get("exampleView")
}}else{q=this.invokeDelegateMethod(o,"collectionViewContentExampleViewFor",this,p,l);
if(!q){n=this.get("contentExampleViewKey");if(n&&p){q=p.get(n)}}if(!q){q=this.get("exampleView")
}}var m=this._TMP_ATTRS;m.contentIndex=l;m.content=p;m.owner=m.displayDelegate=this;
m.parentView=this.get("containerView")||this;m.page=this.page;m.layerId=this.layerIdFor(l,p);
m.isEnabled=a.contentIndexIsEnabled(this,p,l);m.isSelected=a.contentIndexIsSelected(this,p,l);
m.outlineLevel=a.contentIndexOutlineLevel(this,p,l);m.disclosureState=a.contentIndexDisclosureState(this,p,l);
m.isGroupView=c;m.isVisibleInWindow=this.isVisibleInWindow;if(c){m.classNames=this._GROUP_COLLECTION_CLASS_NAMES
}else{m.classNames=this._COLLECTION_CLASS_NAMES}g=this.layoutForContentIndex(l);if(g){m.layout=g
}else{delete m.layout}e=o.controllerForContent(p);if(e){m.rootController=e}else{delete m.rootController
}m.dynamicDelegate=o;var f=this.invokeDelegateMethod(o,"contentViewMetadataForContentIndex",this,l);
if(f){m.viewMetadata=f}else{delete m.viewMetadata}h=this.createItemView(q,l,m);if(!f){f=this.invokeDelegateMethod(o,"collectionViewSetMetadataForContentIndex",this,h.get("viewMetadata"),l)
}d[l]=h;return h},layoutForContentIndex:function(b){var a=this.get("rowMargin");return{top:this.rowOffsetForContentIndex(b),height:this.rowHeightForContentIndex(b),left:a,right:a}
},contentIndexRowHeight:function(c,e,f){var a=this.get("rowHeight");if(c&&c.get("isDynamicCollection")){var d=c.get("customRowViewMetadata");
if(!SC.none(d)){var b=d.objectAt(f);if(b&&b.height){a=b.height}}}return a}};sc_require("core");
SCUI.DynamicListItem={isDynamicListItem:YES,dynamicDelegate:null,rootController:null,viewMetadata:null,viewMetadataHasChanged:function(){var a=this.get("dynamicDelegate");
this.invokeDelegateMethod(a,"contentViewDidChangeForContentIndex",this.owner,this,this.get("content"),this.contentIndex)
}};SCUI.Mobility={viewThatMoves:null,mouseDown:function(a){var b,c;b=this.get("viewThatMoves")||this;
if(!b){return YES}c=SC.clone(b.get("layout"));c.pageX=a.pageX;c.pageY=a.pageY;this._mouseDownInfo=c;
return YES},_adjustViewLayoutOnDrag:function(k,h,g,m,e,l,c,b,d){var j=e[l],f=e[c],a=e[b],n=e[d];
if(!SC.none(n)){if(!SC.none(j)){k.adjust(l,j+m)}else{if(!SC.none(f)){k.adjust(c,f-m)
}else{if(!SC.none(a)){k.adjust(b,a+m)}}}}},mouseDragged:function(d){var e=this._mouseDownInfo;
if(e){var c=d.pageX-e.pageX,a=d.pageY-e.pageY;var b=this.get("viewThatMoves")||this;
this._adjustViewLayoutOnDrag(b,e.zoneX,e.zoneY,c,e,"left","right","centerX","width");
this._adjustViewLayoutOnDrag(b,e.zoneY,e.zoneX,a,e,"top","bottom","centerY","height");
return YES}return NO}};SCUI.Permissible={isPermitted:null,isPermittedBindingDefault:SC.Binding.oneWay().bool(),displayProperties:["isPermitted","tooltipSuffix"],tooltipSuffix:" (unauthorized)".loc(),_isPermittedDidChange:function(){if(this.get("isPermitted")){if(!SC.none(this._tooltip)){this.setIfChanged("toolTip",this._tooltip)
}}else{this._tooltip=this.get("toolTip");this.set("toolTip",this._tooltip+this.get("tooltipSuffix"))
}}.observes("isPermitted"),renderMixin:function(a,b){a.setClass("unauthorized",!this.get("isPermitted"))
}};SCUI.RECUR_ONCE="once";SCUI.RECUR_REPEAT="repeat";SCUI.RECUR_SCHEDULE="schedule";
SCUI.RECUR_ALWAYS="always";SCUI.Recurrent={isRecurrent:YES,_timer_pool:{},_guid_for_timer:1,fireOnce:function(i,d,j){if(d===undefined){d=1
}var g=i,a=j,h,e;if(!j){a=function(){return YES}}if(SC.typeOf(j)===SC.T_STRING){a=this[j]
}var b=this._name_builder(SCUI.RECUR_ONCE,i);if(arguments.length>3){h=SC.$A(arguments).slice(3);
if(SC.typeOf(g)===SC.T_STRING){g=this[i]}e=g;g=function(){delete this._timer_pool[b];
if(a.call(this)){return e.apply(this,h)}}}var c=SC.Timer.schedule({target:this,action:g,interval:d});
this._timer_pool[b]=c;return b},_name_builder:function(b,c){var a="%@_%@_%@".fmt(b,c,this._guid_for_timer);
this._guid_for_timer+=1;return a}};SCUI.Resizable={viewToResize:null,verticalMove:YES,horizontalMove:YES,mouseDown:function(a){var b,c={};
b=this.get("viewToResize")||this.get("parentView");if(!b){return YES}c.resizeView=b;
var d=b.get("frame");c.width=d.width;c.height=d.height;c.top=d.y;c.left=d.x;c.pageX=a.pageX;
c.pageY=a.pageY;this._mouseDownInfo=c;return YES},mouseDragged:function(d){var f=this._mouseDownInfo;
if(!f){return YES}var c=d.pageX-f.pageX,a=d.pageY-f.pageY;var b=f.resizeView;var g=this.get("horizontalMove");
if(g){b.adjust("width",f.width+c)}var e=this.get("verticalMove");if(e){b.adjust("height",f.height+a)
}b.adjust("top",f.top);b.adjust("left",f.left);return YES}};sc_require("core");SCUI.SimpleButton={target:null,action:null,hasState:NO,hasHover:NO,inState:NO,_hover:NO,stateClass:"state",hoverClass:"hover",activeClass:"active",_isMouseDown:NO,displayProperties:["inState"],mouseDown:function(a){if(!this.get("isEnabledInPane")){return YES
}this._isMouseDown=YES;this.displayDidChange();return YES},mouseExited:function(a){if(this.get("hasHover")){this._hover=NO;
this.displayDidChange()}return YES},mouseEntered:function(a){if(this.get("hasHover")){this._hover=YES;
this.displayDidChange()}return YES},mouseUp:function(a){if(!this.get("isEnabledInPane")){return YES
}this._isMouseDown=false;var c=this.get("target")||null;var b=this.get("action");
if(this._hasLegacyActionHandler()){this._triggerLegacyActionHandler(a)}else{this.getPath("pane.rootResponder").sendAction(b,c,this,this.get("pane"))
}if(this.get("hasState")){this.set("inState",!this.get("inState"))}this.displayDidChange();
return YES},renderMixin:function(c,f){if(this.get("hasHover")){var d=this.get("hoverClass");
c.setClass(d,this._hover&&!this._isMouseDown)}if(this.get("hasState")){var e=this.get("stateClass");
c.setClass(e,this.inState)}var b=this.get("activeClass");c.setClass(b,this._isMouseDown);
var a=this.get("toolTip");if(SC.typeOf(a)===SC.T_STRING){if(this.get("localize")){a=a.loc()
}c.attr("title",a);c.attr("alt",a)}},_hasLegacyActionHandler:function(){var a=this.get("action");
if(a&&(SC.typeOf(a)===SC.T_FUNCTION)){return true}if(a&&(SC.typeOf(a)===SC.T_STRING)&&(a.indexOf(".")!==-1)){return true
}return false},_triggerLegacyActionHandler:function(evt){var target=this.get("target");
var action=this.get("action");if(target===undefined&&SC.typeOf(action)===SC.T_FUNCTION){this.action(evt)
}else{if(target!==undefined&&SC.typeOf(action)===SC.T_FUNCTION){action.apply(target,[evt])
}}if(SC.typeOf(action)===SC.T_STRING){eval("this.action = function(e) { return "+action+"(this, e); };");
this.action(evt)}}};SCUI.StatusChanged={notifyOnContentStatusChange:YES,contentStatusDidChange:function(a){},contentKey:"content",_sc_content_status_changed:function(){var a,b;
if(this.get("contentKey")&&this.get){b=this.get(this.get("contentKey"))}if(b&&b.get){a=b.get("status")
}if(this.get("notifyOnContentStatusChange")&&a&&this.contentStatusDidChange){this.contentStatusDidChange(a)
}},initMixin:function(){if(this.get("notifyOnContentStatusChange")&&this.addObserver){var a;
if(this.get("contentKey")){a="%@.status".fmt(this.get("contentKey"))}if(a&&this.addObserver){this.addObserver(a,this,this._sc_content_status_changed)
}}}};sc_require("core");SCUI.ToolTip={toolTip:"",isImage:NO,renderMixin:function(c,e){var b=this.get("toolTip");
var d=this.get("isImage"),a;if(d){a={title:b,alt:b}}else{a={title:b}}c=c.attr(a)}};
SCUI.ContextMenuPane=SC.MenuPane.extend({usingStaticLayout:NO,popup:function(f,b){if((!f||!f.isView)&&!this.get("usingStaticLayout")){return NO
}if(b&&b.button&&(b.which===3||(b.ctrlKey&&b.which===1))){document.oncontextmenu=function(h){return false
};var d=f.isView?f.get("layer"):f;var c=SC.viewportOffset(d);var a=b.pageX-c.x;var g=b.pageY-c.y;
this.beginPropertyChanges();var e=this.get("displayItems");this.set("anchorElement",d);
this.set("anchor",f);this.set("preferType",SC.PICKER_MENU);this.set("preferMatrix",[a+2,g+2,1]);
this.endPropertyChanges();this.adjust("height",this.get("menuHeight"));this.positionPane();
this.append();this.becomeKeyPane();return YES}else{}return NO},remove:function(){return arguments.callee.base.apply(this,arguments)
}});SCUI.State=SC.Object.extend({initState:function(){},enterState:function(a){},exitState:function(a){},parallelStatechart:SCUI.DEFAULT_STATE,parentState:null,history:null,initialSubState:null,name:null,state:function(){var a=this.get("stateManager");
if(!a){throw"Cannot access the current state because state does not have a state manager"
}return a.currentState(this.get("parallelStatechart"))},goState:function(a){var b=this.get("stateManager");
if(b){b.goState(a,this.get("parallelStatechart"))}else{throw"Cannot goState cause state does not have a stateManager!"
}},goHistoryState:function(a,b){var c=this.get("stateManager");if(c){c.goHistoryState(a,this.get("parallelStatechart"),b)
}else{throw"Cannot goState cause state does not have a stateManager!"}},enterInitialSubState:function(a){var b=this.get("initialSubState");
if(b){if(!a[b]){throw"Cannot find initial sub state: %@ defined on state: %@".fmt(b,this.get("name"))
}this.set("history",b);var c=a[b];return this.goState(b,a)}return this},toString:function(){return this.get("name")
},parentStateObject:function(){var a=this.get("stateManager");if(a){return a.parentStateObject(this.get("parentState"),this.get("parallelStatechart"))
}else{throw"Cannot access parentState cause state does not have a stateManager!"}}.property("parentState").cacheable(),trace:function(){var a=this.get("stateManager");
if(a){return a._parentStates(this)}else{throw"Cannot trace cause state does not have a stateManager!"
}}});require("system/state");SCUI.Statechart={isStatechart:true,log:NO,initMixin:function(){this._all_states={};
this._all_states[SCUI.DEFAULT_TREE]={};this._current_state={};this._current_state[SCUI.DEFAULT_TREE]=null;
this._goStateLocked=NO;this._pendingStateTransitions=[];this.sendAction=this.sendEvent;
if(this.get("startOnInit")){this.startupStatechart()}},startOnInit:YES,startupStatechart:function(){if(!this._started){var e,a,g,c,d,b,f;
for(e in this){if(this.hasOwnProperty(e)&&SC.kindOf(this[e],SCUI.State)&&this[e].get&&!this[e].get("beenAddedToStatechart")){g=this[e];
this._addState(e,g)}}c=this._all_states;for(e in c){if(c.hasOwnProperty(e)){a=c[e];
for(g in a){if(a.hasOwnProperty(g)){a[g].initState()}}}}d=this.get("startStates");
if(!d){throw"Please add startStates to your statechart!"}for(e in c){if(c.hasOwnProperty(e)){b=d[e];
f=c[e];if(!b){console.error("The parallel statechart %@ must have a start state!".fmt(e))
}if(!f){throw"The parallel statechart %@ does not exist!".fmt(e)}if(!f[b]){throw"The parallel statechart %@ doesn't have a start state [%@]!".fmt(e,b)
}this.goState(b,e)}}}this._started=YES},registerState:function(e,d,c){var b,a;b=SCUI.State.create(e);
if(d&&c){if(d.isStatechart){d._addState(c,b);b.initState()}else{throw"Cannot add state: %@ because state manager does not mixin SCUI.Statechart".fmt(b.get("name"))
}}else{b.set("beenAddedToStatechart",NO)}return b},goHistoryState:function(c,a,f){var d=this._all_states[a],b,e;
if(!a||!d){throw"State requesting go history does not have a valid parallel tree"
}b=d[c];if(b){e=b.get("history")||b.get("initialSubState")}if(!e){if(!f){console.warn("Requesting History State for [%@] and it is not a parent state".fmt(c))
}e=c;this.goState(e,a)}else{if(f){this.goHistoryState(e,a,f)}else{this.goState(e,a)
}}},goState:function(a,n){var b=this._current_state[n],k=[],j=[],m,c,l,d,e,g,h=this.get("log"),f;
if(!n){throw"#goState: State requesting go does not have a valid parallel tree"}a=this._all_states[n][a];
if(!a){throw"#goState: Could not find the requested state!"}if(this._goStateLocked){this._pendingStateTransitions.push({requestedState:a,tree:n});
return}this._goStateLocked=YES;k=this._parentStates_with_root(a);j=b?this._parentStates_with_root(b):[];
l=j.find(function(o,i){c=i;m=k.indexOf(o);if(m>=0){return YES}});if(!m){m=k.length-1
}f="";for(g=0;g<c;g+=1){if(h){f+="Exiting State: [%@] in [%@]\n".fmt(j[g],n)}j[g].exitState()
}if(h){console.info(f)}f="";for(g=m-1;g>=0;g-=1){e=k[g];if(h){f+="Entering State: [%@] in [%@]\n".fmt(e,n)
}d=k[g+1];if(d&&SC.typeOf(d)===SC.T_OBJECT){d.set("history",e.name)}e.enterState();
if(e===a){e.enterInitialSubState(this._all_states[n||SCUI.DEFAULT_TREE])}}if(h){console.info(f)
}this._current_state[n]=a;this._goStateLocked=NO;this._flushPendingStateTransition()
},_flushPendingStateTransition:function(){var a=this._pendingStateTransitions.shift();
if(!a){return}this.goState(a.requestedState,a.tree)},currentState:function(a){a=a||SCUI.DEFAULT_TREE;
return this._current_state[a]},isResponderContext:YES,sendEvent:function(g,e,d){var f=this.get("log"),h=NO,c=this._current_state,b;
this._locked=YES;if(f){console.log("%@: begin action '%@' (%@, %@)".fmt(this,g,e,d))
}for(var a in c){if(c.hasOwnProperty(a)){h=NO;b=c[a];while(!h&&b){if(b.tryToPerform){h=b.tryToPerform(g,e,d)
}if(!h){b=b.get("parentState")?this._all_states[a][b.get("parentState")]:null}}if(f){if(!h){console.log("%@:  action '%@' NOT HANDLED in tree %@".fmt(this,g,a))
}else{console.log("%@: action '%@' handled by %@ in tree %@".fmt(this,g,b.get("name"),a))
}}}}this._locked=NO;return b},_addState:function(b,c){c.set("stateManager",this);
c.set("name",b);var a=c.get("parallelStatechart")||SCUI.DEFAULT_TREE;c.setIfChanged("parallelStatechart",a);
if(!this._all_states[a]){this._all_states[a]={}}if(this._all_states[a][b]){throw"Trying to add state %@ to state tree %@ and it already exists".fmt(b,a)
}this._all_states[a][b]=c;c.set("beenAddedToStatechart",YES)},_parentStates:function(b){var a=[],c=b;
a.push(c);c=c.get("parentStateObject");while(c){a.push(c);c=c.get("parentStateObject")
}return a},_parentStates_with_root:function(b){var a=this._parentStates(b);a.push("root");
return a},parentStateObject:function(b,a){if(b&&a&&this._all_states[a]&&this._all_states[a][b]){return this._all_states[a][b]
}return null}};sc_require("core");SCUI.CascadingComboView=SC.View.extend({content:null,propertiesHash:null,masterLabel:null,detailLabel:null,init:function(){arguments.callee.base.apply(this,arguments)
},createChildViews:function(){var e=[],b;var g=["contentPath","masterValueKey","detailValueKey","rootItemKey","childItemKey","relationKey"];
var a=null;var c=this.get("propertiesHash");var d=this.get("content");if(c){g.forEach(function(h){if(!SC.none(c[h])&&c[h]!==""){a=YES
}else{a=null}})}if(a){b=this.createChildView(SC.LabelView.design({layout:{left:20,top:10,right:20,height:22},isEditable:NO,value:this.get("masterLabel").loc()}));
e.push(b);var f="*content.%@".fmt(c.rootItemKey);this.masterCombo=b=this.createChildView(SCUI.ComboBoxView.design({layout:{left:20,right:20,top:32,height:22},objectsBinding:c.contentPath,nameKey:c.masterValueKey,valueBinding:SC.Binding.from("*content.%@".fmt(c.rootItemKey),this)}));
e.push(b);b=this.createChildView(SC.LabelView.design({layout:{left:50,top:64,right:20,height:22},isEditable:NO,value:this.get("detailLabel").loc(),isEnabled:NO,isEnabledBinding:SC.Binding.from("*masterCombo.selectedObject",this).oneWay()}));
e.push(b);b=this.createChildView(SCUI.ComboBoxView.design({layout:{left:50,right:20,top:86,height:22},objectsBinding:SC.Binding.from("*content.%@".fmt(c.relationKey),this).oneWay(),nameKey:c.detailValueKey,isEnabled:NO,isEnabledBinding:SC.Binding.from("*masterCombo.selectedObject",this).oneWay(),valueBinding:SC.Binding.from("*content.%@".fmt(c.childItemKey),this)}));
e.push(b);this.set("childViews",e)}else{b=this.createChildView(SC.View.design({layout:{top:0,left:0,bottom:0,right:0},childViews:[SC.LabelView.design({layout:{centerX:0,centerY:0,width:300,height:18},value:a?"No Content.":"Setup did not meet requirements."})]}));
e.push(b);this.set("childViews",e)}}});sc_require("core");SCUI.CollapsibleView=SC.ContainerView.extend({classNames:["scui-collapsible-view"],expandedView:null,collapsedView:null,_isCollapsed:NO,_expandedView:null,_collapsedView:null,displayProperties:["expandedView","collapsedView"],createChildViews:function(){var b=this.get("expandedView");
this._expandedView=this._createChildViewIfNeeded(b);var c=this.get("collapsedView");
this._collapsedView=this._createChildViewIfNeeded(c);this.set("nowShowing",this._expandedView);
var a=this.get("contentView");this._adjustView(a)},expand:function(){if(this._expandedView){this.set("nowShowing",this._expandedView);
var a=this.get("contentView");this._isCollapsed=NO;this.displayDidChange();this._adjustView(a)
}},collapse:function(){if(this._collapsedView){this.set("nowShowing",this._collapsedView);
var a=this.get("contentView");this._isCollapsed=YES;this.displayDidChange();this._adjustView(a)
}},toggle:function(){if(this._isCollapsed){this.expand()}else{this.collapse()}},_expandedViewDidChange:function(){var a=this.get("expandedView");
console.log("%@._expandableViewDidChange(%@)".fmt(this,a));this._expandedView=this._createChildViewIfNeeded(a);
if(!this._isCollapsed){this.expand()}}.observes("expandedView"),_collapsedViewDidChange:function(){var a=this.get("collapsedView");
console.log("%@._collapsedViewDidChange(%@)".fmt(this,a));this._collapsedView=this._createChildViewIfNeeded(a);
if(this._isCollapsed){this.collapse()}}.observes("collapsedView"),_adjustView:function(a){if(a){var c=a.get("frame");
var b=this.get("layout");console.log("CollapsibleView: Frame for (%@): width: %@, height: %@".fmt(a,c.height,c.width));
b=SC.merge(b,{height:c.height,width:c.width});this.adjust(b)}},_createChildViewIfNeeded:function(a){if(SC.typeOf(a)===SC.T_CLASS){return this.createChildView(a)
}else{return a}}});SCUI.LocalizableListItemView=SC.ListItemView.extend({render:function(c,a){var f=this.get("content"),k=this.displayDelegate,b=this.get("outlineLevel"),e=this.get("outlineIndent"),j,i,h;
c.addClass((this.get("contentIndex")%2===0)?"even":"odd");c.setClass("disabled",!this.get("isEnabled"));
h=c.begin("div").addClass("sc-outline");if(b>=0&&e>0){h.addStyle("left",e*(b+1))}i=this.get("disclosureState");
if(i!==SC.LEAF_NODE){this.renderDisclosure(h,i);c.addClass("has-disclosure")}j=this.getDelegateProperty("contentCheckboxKey",f,k);
if(j){i=f?(f.get?f.get(j):f[j]):NO;this.renderCheckbox(h,i);c.addClass("has-checkbox")
}if(this.getDelegateProperty("hasContentIcon",f,k)){j=this.getDelegateProperty("contentIconKey",k);
i=(j&&f)?(f.get?f.get(j):f[j]):null;this.renderIcon(h,i);c.addClass("has-icon")}j=this.getDelegateProperty("contentValueKey",f,k);
i=(j&&f)?(f.get?f.get(j):f[j]):f;if(i&&SC.typeOf(i)!==SC.T_STRING){i=i.toString()
}if(k&&k.get("localize")&&i&&i.loc){i=i.loc()}if(this.get("escapeHTML")){i=SC.RenderContext.escapeHTML(i)
}this.renderLabel(h,i);if(this.getDelegateProperty("hasContentRightIcon",k)){j=this.getDelegateProperty("contentRightIconKey",k);
i=(j&&f)?(f.get?f.get(j):f[j]):null;this.renderRightIcon(h,i);c.addClass("has-right-icon")
}j=this.getDelegateProperty("contentUnreadCountKey",f,k);i=(j&&f)?(f.get?f.get(j):f[j]):null;
if(!SC.none(i)&&(i!==0)){this.renderCount(h,i);var d=["zero","one","two","three","four","five"];
var g=(i.toString().length<d.length)?d[i.toString().length]:d[d.length-1];c.addClass("has-count "+g+"-digit")
}j=this.getDelegateProperty("listItemActionProperty",f,k);i=(j&&f)?(f.get?f.get(j):f[j]):null;
if(i){this.renderAction(h,i);c.addClass("has-action")}if(this.getDelegateProperty("hasContentBranch",f,k)){j=this.getDelegateProperty("contentIsBranchKey",f,k);
i=(j&&f)?(f.get?f.get(j):f[j]):NO;this.renderBranch(h,i);c.addClass("has-branch")
}c=h.end()}});sc_require("mixins/simple_button");sc_require("views/localizable_list_item");
SCUI.ComboBoxView=SC.View.extend(SC.Control,SC.Editable,{classNames:"scui-combobox-view",isEditable:function(){return this.get("isEnabled")
}.property("isEnabled").cacheable(),objects:null,value:null,selectedObject:null,valueKey:null,nameKey:null,iconKey:null,sortKey:null,disableSort:NO,localize:NO,hint:null,filter:null,useExternalFilter:NO,status:null,isBusy:function(){return(this.get("status")&SC.Record.BUSY)?YES:NO
}.property("status").cacheable(),minListHeight:20,maxListHeight:200,statusIndicatorHeight:18,filteredObjects:function(){var b,d,f,c,a,e,g;
if(this.get("useExternalFilter")){b=this.get("objects")}else{f=this.get("objects")||[];
c=this.get("nameKey");d=this._sanitizeFilter(this.get("filter"))||"";d=d.toLowerCase();
g=this.get("localize");b=[];e=this;f.forEach(function(h){a=e._getObjectName(h,c,g);
if((SC.typeOf(a)===SC.T_STRING)&&(a.toLowerCase().search(d)>=0)){b.push(h)}})}return this.sortObjects(b)
}.property("objects","filter").cacheable(),textFieldView:SC.TextFieldView.extend({classNames:"scui-combobox-text-field-view",layout:{top:0,left:0,height:22,right:28}}),dropDownButtonView:SC.View.extend(SCUI.SimpleButton,{classNames:"scui-combobox-dropdown-button-view",layout:{top:0,right:0,height:24,width:28}}),displayProperties:["isEditing"],init:function(){arguments.callee.base.apply(this,arguments);
this._createListPane();this._valueDidChange();this.bind("status",SC.Binding.from("*objects.status",this).oneWay())
},createChildViews:function(){var c=[],a;var b=this.get("isEnabled");a=this.get("textFieldView");
if(SC.kindOf(a,SC.View)&&a.isClass){a=this.createChildView(a,{isEnabled:b,hintBinding:SC.Binding.from("hint",this),editableDelegate:this,keyDelegate:this,keyDown:function(e){var d=this.get("keyDelegate");
return(d&&d.keyDown&&d.keyDown(e))||arguments.callee.base.apply(this,arguments)},keyUp:function(e){var d=this.get("keyDelegate");
return(d&&d.keyUp&&d.keyUp(e))||arguments.callee.base.apply(this,arguments)},beginEditing:function(){var d=this.get("editableDelegate");
var e=arguments.callee.base.apply(this,arguments);if(e&&d&&d.beginEditing){d.beginEditing()
}return e},commitEditing:function(){var d=this.get("editableDelegate");var e=arguments.callee.base.apply(this,arguments);
if(e&&d&&d.commitEditing){d.commitEditing()}return e}});c.push(a);this.set("textFieldView",a)
}else{this.set("textFieldView",null)}a=this.get("dropDownButtonView");if(SC.kindOf(a,SC.View)&&a.isClass){a=this.createChildView(a,{isEnabled:b,target:this,action:"toggleList"});
c.push(a);this.set("dropDownButtonView",a)}else{this.set("dropDownButtonView",null)
}this.set("childViews",c)},renderMixin:function(a,b){a.setClass("focus",this.get("isEditing"))
},sortObjects:function(b){var a;if(!this.get("disableSort")&&b&&b.sort){a=this.get("sortKey")||this.get("nameKey");
b=b.sort(function(d,c){if(a){d=d.get?d.get(a):d[a];c=c.get?c.get(a):c[a]}d=(SC.typeOf(d)===SC.T_STRING)?d.toLowerCase():d;
c=(SC.typeOf(c)===SC.T_STRING)?c.toLowerCase():c;return(d<c)?-1:((d>c)?1:0)})}return b
},beginEditing:function(){var a=this.get("textFieldView");if(!this.get("isEditable")){return NO
}if(this.get("isEditing")){return YES}this.set("isEditing",YES);this.set("filter",null);
if(a&&!a.get("isEditing")){a.beginEditing()}return YES},commitEditing:function(){var a=this.get("textFieldView");
if(this.get("isEditing")){this._selectedObjectDidChange();this.set("isEditing",NO);
this.hideList()}if(a&&a.get("isEditing")){a.commitEditing()}return YES},toggleList:function(){if(this._listPane&&this._listPane.get("isPaneAttached")){this.hideList()
}else{this.showList()}},showList:function(){if(this._listPane&&!this._listPane.get("isPaneAttached")){this.beginEditing();
this._updateListPaneLayout();this._listPane.popup(this,SC.PICKER_MENU)}},hideList:function(){if(this._listPane&&this._listPane.get("isPaneAttached")){this._listPane.remove()
}},keyDown:function(a){this._keyDown=YES;this._shouldUpdateFilter=NO;return this.interpretKeyEvents(a)?YES:NO
},keyUp:function(a){var b=NO;if(!this._keyDown){this._shouldUpdateFilter=NO;b=this.interpretKeyEvents(a)?YES:NO
}this._keyDown=NO;return b},insertText:function(a){this._shouldUpdateFilter=YES;this.showList();
return NO},deleteBackward:function(a){this._shouldUpdateFilter=YES;this.showList();
return NO},deleteForward:function(a){this._shouldUpdateFilter=YES;this.showList();
return NO},moveDown:function(a){if(this._listPane&&this._listView){if(this._listPane.get("isPaneAttached")){this._listView.moveDown(a)
}else{this.showList()}}return YES},moveUp:function(a){if(this._listPane&&this._listView){if(this._listPane.get("isPaneAttached")){this._listView.moveUp(a)
}else{this.showList()}}return YES},insertNewline:function(a){if(this._listPane&&this._listPane.get("isPaneAttached")){return this._listView.insertNewline(a)
}return NO},cancel:function(a){if(this._listPane&&this._listPane.get("isPaneAttached")){this.hideList()
}return NO},_isEnabledDidChange:function(){var a;var b=this.get("isEnabled");if(!b){this.commitEditing()
}a=this.get("textFieldView");if(a&&a.set){a.set("isEnabled",b)}a=this.get("dropDownButtonView");
if(a&&a.set){a.set("isEnabled",b)}}.observes("isEnabled"),_objectsDidChange:function(){this.notifyPropertyChange("filteredObjects")
}.observes("*objects.[]"),_filteredObjectsLengthDidChange:function(){this.invokeOnce("_updateListPaneLayout")
}.observes("*filteredObjects.length"),_isBusyDidChange:function(){this.invokeOnce("_updateListPaneLayout")
}.observes("isBusy"),_selectedObjectDidChange:function(){var b=this.get("selectedObject");
var a=this.get("textFieldView");this.setIfChanged("value",this._getObjectValue(b,this.get("valueKey")));
if(a){a.setIfChanged("value",this._getObjectName(b,this.get("nameKey"),this.get("localize")))
}this.set("filter",null)}.observes("selectedObject"),_valueDidChange:function(){var d=this.get("value");
var a=this.get("selectedObject");var b=this.get("valueKey");var c;if(d){if(b){if(d!==this._getObjectValue(a,b)){c=this.get("objects");
a=(c&&c.isEnumerable)?c.findProperty(b,d):null;this.set("selectedObject",a)}}else{this.setIfChanged("selectedObject",d)
}}else{this.set("selectedObject",null)}}.observes("value"),_listSelectionDidChange:function(){var c=this.getPath("_listSelection.firstObject");
var b,a;if(c&&this._listPane&&this._listPane.get("isPaneAttached")){b=this._getObjectName(c,this.get("nameKey"),this.get("localize"));
a=this.get("textFieldView");if(a){a.setIfChanged("value",b)}}}.observes("_listSelection"),_textFieldValueDidChange:function(){if(this._shouldUpdateFilter){this._shouldUpdateFilter=NO;
this.setIfChanged("filter",this.getPath("textFieldView.value"))}}.observes("*textFieldView.value"),_createListPane:function(){var b=this.get("isBusy");
var a=this.get("statusIndicatorHeight");this._listPane=SC.PickerPane.create({classNames:["scui-combobox-list-pane","sc-menu"],acceptsKeyPane:NO,acceptsFirstResponder:NO,contentView:SC.View.extend({layout:{left:0,right:0,top:0,bottom:0},childViews:"listView spinnerView".w(),listView:SC.ScrollView.extend({layout:{left:0,right:0,top:0,bottom:b?a:0},hasHorizontalScroller:NO,contentView:SC.ListView.design({classNames:"scui-combobox-list-view",layout:{left:0,right:0,top:0,bottom:0},allowsMultipleSelection:NO,target:this,action:"_selectListItem",contentBinding:SC.Binding.from("filteredObjects",this).oneWay(),contentValueKey:this.get("nameKey"),hasContentIcon:this.get("iconKey")?YES:NO,contentIconKey:this.get("iconKey"),selectionBinding:SC.Binding.from("_listSelection",this),localizeBinding:SC.Binding.from("localize",this).oneWay(),exampleView:SCUI.LocalizableListItemView,mouseUp:function(){var c=arguments.callee.base.apply(this,arguments);
var e=this.get("target");var d=this.get("action");if(e&&d&&e.invokeLater){e.invokeLater(d)
}return c}})}),spinnerView:SC.View.extend({classNames:"scui-combobox-spinner-view",layout:{centerX:0,bottom:0,width:100,height:a},isVisibleBinding:SC.Binding.from("isBusy",this).oneWay(),childViews:"imageView messageView".w(),imageView:SCUI.LoadingSpinnerView.extend({layout:{left:0,top:0,bottom:0,width:18},theme:"darkTrans",callCountBinding:SC.Binding.from("isBusy",this).oneWay().transform(function(c){c=c?1:0;
return c})}),messageView:SC.LabelView.extend({layout:{left:25,top:0,bottom:0,right:0},valueBinding:SC.Binding.from("status",this).oneWay().transform(function(c){c=(c===SC.Record.BUSY_LOADING)?"Loading...".loc():"Refreshing...".loc();
return c})})})}),mouseDown:function(c){arguments.callee.base.apply(this,arguments);
return NO}});this._listView=this._listPane.getPath("contentView.listView.contentView");
this._listScrollView=this._listPane.getPath("contentView.listView")},_updateListPaneLayout:function(){var a,f,c,i,e,h,g,b,d;
if(this._listView&&this._listPane&&this._listScrollView){e=this.get("frame");c=e?e.width:200;
d=this.get("isBusy");b=this.get("statusIndicatorHeight");a=this._listView.get("rowHeight")||18;
f=this.getPath("filteredObjects.length")||(d?0:1);i=(a*f)+(d?b:0);i=Math.min(i,this.get("maxListHeight"));
i=Math.max(i,this.get("minListHeight"));this._listScrollView.adjust({bottom:d?b:0});
this._listPane.adjust({width:c,height:i});this._listPane.updateLayout();this._listPane.positionPane()
}},_selectListItem:function(){var a=this._listView?this._listView.getPath("selection.firstObject"):null;
if(a){this.set("selectedObject",a)}this.hideList()},_sanitizeFilter:function(c){var a,b;
if(c){a=["/",".","*","+","?","|","(",")","[","]","{","}","\\"];b=new RegExp("(\\"+a.join("|\\")+")","g");
return c.replace(b,"\\$1")}return c},_getObjectName:function(d,b,c){var a=d?(b?(d.get?d.get(b):d[b]):d):null;
if(c&&a&&a.loc){a=a.loc()}return a},_getObjectValue:function(b,a){return b?(a?(b.get?b.get(a):b[a]):b):null
},_listPane:null,_listScrollView:null,_listView:null,_listSelection:null,_keyDown:NO,_shouldUpdateFilter:NO});
sc_require("core");sc_require("panes/context_menu_pane");SCUI.ContentEditableView=SC.WebView.extend(SC.Editable,{value:"",valueBindingDefault:SC.Binding.single(),allowScrolling:YES,isOpaque:YES,selection:"",selectedImage:null,selectedHyperlink:null,attachedView:null,offsetWidth:null,offsetHeight:null,hasFixedDimensions:YES,inlineStyle:{},autoCommit:NO,cleanInsertedText:YES,stripCrap:NO,styleSheetCSS:"",rightClickMenuOptions:[],encodeContent:YES,indentOnTab:YES,tabSize:2,displayProperties:["value"],render:function(d,h){var g=this.get("value");
var c=!this.get("isOpaque");var e=this.get("allowScrolling")?"yes":"no";var f=c?"0":"1";
var a="position: absolute; width: 100%; height: 100%; border: 0px; margin: 0px; padding: 0p;";
if(h){d.push('<iframe frameBorder="',f,'" name="',this.get("frameName"));d.push('" scrolling="',e);
d.push('" src="" allowTransparency="',c,'" style="',a,'"></iframe>')}else{if(this._document){var b=this._document.body.innerHTML;
if(this.get("encodeContent")){b=this._encodeValues(b)}if(g!==b){this._document.body.innerHTML=g
}}}},didCreateLayer:function(){arguments.callee.base.apply(this,arguments);var a=this.$("iframe");
SC.Event.add(a,"load",this,this.editorSetup)},displayDidChange:function(){var a=this._document;
if(a){a.body.contentEditable=this.get("isEnabled")}arguments.callee.base.apply(this,arguments)
},willDestroyLayer:function(){var b=this._document;var a=b.body;SC.Event.remove(a,"mouseup",this,this.mouseUp);
SC.Event.remove(a,"keyup",this,this.keyUp);SC.Event.remove(a,"paste",this,this.paste);
SC.Event.remove(a,"dblclick",this,this.doubleClick);if(this.get("indentOnTab")){SC.Event.remove(a,"keydown",this,this.keyDown)
}SC.Event.remove(b,"click",this,this.focus);SC.Event.remove(this.$("iframe"),"load",this,this.editorSetup);
arguments.callee.base.apply(this,arguments)},editorSetup:function(){this._iframe=this._getFrame();
this._document=this._getDocument();if(SC.none(this._document)){console.error("Curse your sudden but inevitable betrayal! Can't find a reference to the document object!");
return}var g=this._document;var d=this.get("styleSheetCSS");if(!(SC.none(d)||d==="")){var f=g.getElementsByTagName("head")[0];
if(f){var c=g.createElement("style");c.type="text/css";f.appendChild(c);if(SC.browser.msie){c.cssText=d
}else{c.innerHTML=d}c=f=null}}var h=this.get("value");var e=g.body;e.contentEditable=true;
if(!this.get("isOpaque")){e.style.background="transparent";this.$().setClass("sc-web-view",NO)
}var b=this.get("inlineStyle");var k=this._document.body.style;for(var i in b){if(b.hasOwnProperty(i)){k[i.toString().camelize()]=b[i]
}}if(SC.browser.msie||SC.browser.safari){e.innerHTML=h}else{this.insertHTML(h,NO)
}if(!this.get("hasFixedDimensions")){var j=this.get("layout").height;if(j){this._minHeight=j
}var a=this.get("layout").width;if(a){this._minWidth=a}}SC.Event.add(e,"mouseup",this,this.mouseUp);
SC.Event.add(e,"keyup",this,this.keyUp);SC.Event.add(e,"paste",this,this.paste);SC.Event.add(e,"dblclick",this,this.doubleClick);
if(this.get("indentOnTab")){SC.Event.add(e,"keydown",this,this.keyDown)}SC.Event.add(this._document,"click",this,this.focus);
SC.Event.add(this._document,"mousedown",this,this.mouseDown);this.iframeDidLoad();
this.focus()},mouseDown:function(a){var c=this.get("rightClickMenuOptions");var b=c.get("length");
if(c.length>0){var d=this.contextMenuView.create({defaultResponder:this.get("rightClickMenuDefaultResponder"),contentView:SC.View.design({}),layout:{width:200,height:(20*b)},itemTitleKey:"title",itemTargetKey:"target",itemActionKey:"action",itemSeparatorKey:"isSeparator",itemIsEnabledKey:"isEnabled",items:c});
d.popup(this,a)}},doubleClick:function(a){SC.RunLoop.begin();SC.RunLoop.end()},contextMenuView:SCUI.ContextMenuPane.extend({popup:function(d,a){if(!d||!d.isView){return NO
}if(a&&a.button&&(a.which===3||(a.ctrlKey&&a.which===1))){document.oncontextmenu=function(){return false
};var b=d.isView?d.get("layer"):d;this.beginPropertyChanges();var c=this.get("displayItems");
this.set("anchorElement",b);this.set("anchor",d);this.set("preferType",SC.PICKER_MENU);
this.set("preferMatrix",[a.pageX+5,a.pageY+5,1]);this.endPropertyChanges();this.append();
this.positionPane();this.becomeKeyPane();return YES}else{}return NO}}),keyUp:function(a){SC.RunLoop.begin();
switch(SC.FUNCTION_KEYS[a.keyCode]){case"left":case"right":case"up":case"down":this.querySelection();
break}if(!this.get("hasFixedDimensions")){this.invokeLast(this._updateLayout)}this.set("isEditing",YES);
SC.RunLoop.end()},keyDown:function(c){SC.RunLoop.begin();var d=this.get("tabSize");
if(SC.typeOf(d)!==SC.T_NUMBER){return}var a=[];for(var b=0;b<d;b++){a.push("\u00a0")
}if(SC.FUNCTION_KEYS[c.keyCode]==="tab"){c.preventDefault();this.insertHTML(a.join(""),NO)
}SC.RunLoop.end()},mouseUp:function(){this._mouseUp=true;SC.RunLoop.begin();this.querySelection();
if(!this.get("hasFixedDimensions")){this.invokeLast(this._updateLayout)}this.set("isEditing",YES);
SC.RunLoop.end()},paste:function(){SC.RunLoop.begin();this.querySelection();if(!this.get("hasFixedDimensions")){this.invokeLast(this._updateLayout)
}this.set("isEditing",YES);SC.RunLoop.end();return YES},frameName:function(){return this.get("layerId")+"_frame"
}.property("layerId").cacheable(),editorHTML:function(a,b){var c=this._document;if(!c){return NO
}if(b!==undefined){c.body.innerHTML=b;return YES}else{if(this.get("cleanInsertedText")){return this.cleanWordHTML(c.body.innerHTML)
}else{return c.body.innerHTML}}}.property(),selectionIsBold:function(a,c){var b=this._document;
if(!b){return NO}if(c!==undefined){if(b.execCommand("bold",false,c)){this.set("isEditing",YES)
}}return this._document.queryCommandState("bold")}.property("selection").cacheable(),selectionIsItalicized:function(a,c){var b=this._document;
if(!b){return NO}if(c!==undefined){if(b.execCommand("italic",false,c)){this.set("isEditing",YES)
}}return b.queryCommandState("italic")}.property("selection").cacheable(),selectionIsUnderlined:function(a,c){var b=this._document;
if(!b){return NO}if(c!==undefined){if(b.execCommand("underline",false,c)){this.set("isEditing",YES)
}}return b.queryCommandState("underline")}.property("selection").cacheable(),selectionIsCenterJustified:function(a,c){var b=this._document;
if(!b){return NO}if(c!==undefined){if(b.execCommand("justifycenter",false,c)){this.querySelection();
this.set("isEditing",YES)}}return b.queryCommandState("justifycenter")}.property("selection").cacheable(),selectionIsRightJustified:function(a,c){var b=this._document;
if(!b){return NO}if(c!==undefined){if(b.execCommand("justifyright",false,c)){this.querySelection();
this.set("isEditing",YES)}}return b.queryCommandState("justifyright")}.property("selection").cacheable(),selectionIsLeftJustified:function(a,c){var b=this._document;
if(!b){return NO}if(c!==undefined){if(b.execCommand("justifyleft",false,c)){this.querySelection();
this.set("isEditing",YES)}}return b.queryCommandState("justifyleft")}.property("selection").cacheable(),selectionIsFullJustified:function(a,c){var b=this._document;
if(!b){return NO}if(c!==undefined){if(b.execCommand("justifyfull",false,c)){this.querySelection();
this.set("isEditing",YES)}}return b.queryCommandState("justifyfull")}.property("selection").cacheable(),selectionIsOrderedList:function(a,c){var b=this._document;
if(!b){return NO}if(c!==undefined){if(b.execCommand("insertorderedlist",false,c)){this.querySelection();
this.set("isEditing",YES)}}return b.queryCommandState("insertorderedlist")}.property("selection").cacheable(),selectionIsUnorderedList:function(a,c){var b=this._document;
if(!b){return NO}if(c!==undefined){if(b.execCommand("insertunorderedlist",false,c)){this.querySelection();
this.set("isEditing",YES)}}return b.queryCommandState("insertunorderedlist")}.property("selection").cacheable(),selectionIsIndented:function(a,c){var b=this._document;
if(!b){return NO}if(c!==undefined){if(b.execCommand("indent",false,c)){this.set("isEditing",YES)
}}if(SC.browser.msie){return b.queryCommandState("indent")}else{return NO}}.property("selection").cacheable(),selectionIsOutdented:function(a,c){var b=this._document;
if(!b){return NO}if(c!==undefined){if(b.execCommand("outdent",false,c)){this.set("isEditing",YES)
}}if(SC.browser.msie){return b.queryCommandState("outdent")}else{return NO}}.property("selection").cacheable(),selectionIsSubscript:function(a,c){var b=this._document;
if(!b){return NO}if(c!==undefined){if(b.execCommand("subscript",false,c)){this.set("isEditing",YES)
}}return b.queryCommandState("subscript")}.property("selection").cacheable(),selectionIsSuperscript:function(a,c){var b=this._document;
if(!b){return NO}if(c!==undefined){if(b.execCommand("superscript",false,c)){this.set("isEditing",YES)
}}return b.queryCommandState("superscript")}.property("selection").cacheable(),selectionFontName:function(b,d){var c=this._document;
if(!c){return""}if(d!==undefined){if(c.execCommand("fontname",false,d)){this.set("isEditing",YES)
}}var a=c.queryCommandValue("fontname")||"";return a}.property("selection").cacheable(),selectionFontSize:function(q,p){var b=this._iframe;
var o=this._document;if(!o){return""}if(p!==undefined){var k=this.get("layerId")+"-fs-identifier";
if(o.execCommand("fontsize",false,k)){var r=o.getElementsByTagName("font");for(var e=0,d=r.length;
e<d;e++){var g=r[e];if(g.size===k){g.size="";g.style.fontSize=p+"px";var f=document.createNodeIterator(g,NodeFilter.SHOW_ELEMENT,null,false);
var c=f.nextNode();while(c){if(c){if(c!==g&&c.nodeName.toLowerCase()==="font"){c.style.fontSize=""
}c=f.nextNode()}}}}this.set("isEditing",YES);return p}}var n=this._getSelection();
if(n){if(n.anchorNode&&n.focusNode){var a=n.anchorNode;var m=n.focusNode;if(a.nodeType===3&&m.nodeType===3){var l=a.parentNode.style.fontSize;
var h=m.parentNode.style.fontSize;if(l===h){if(l.length>=3){return l.substring(0,l.length-2)
}}}}}return""}.property("selection").cacheable(),selectionFontColor:function(b,c){var d=this._document;
if(!d){return""}if(!SC.browser.msie){if(c!==undefined){if(d.execCommand("forecolor",false,c)){this.set("isEditing",YES)
}}var a=SC.parseColor(d.queryCommandValue("forecolor"))||"";return a}return""}.property("selection").cacheable(),selectionBackgroundColor:function(b,c){var d=this._document;
if(!d){return""}if(!SC.browser.msie){if(c!==undefined){if(d.execCommand("hilitecolor",false,c)){this.set("isEditing",YES)
}}var a=this._document.queryCommandValue("hilitecolor");if(a!=="transparent"){if(SC.parseColor(a)){return SC.parseColor(a)
}}}return""}.property("selection").cacheable(),hyperlinkValue:function(a,b){var c=this.get("selectedHyperlink");
if(!c){return""}if(!SC.none(b)){this.set("isEditing",YES);c.href=b;return b}else{return c.href
}}.property("selectedHyperlink").cacheable(),hyperlinkHoverValue:function(a,b){var c=this.get("selectedHyperlink");
if(!c){return""}if(b!==undefined){this.set("isEditing",YES);c.title=b;return b}else{return c.title
}}.property("selectedHyperlink").cacheable(),imageAlignment:function(a,b){var c=this.get("selectedImage");
if(!c){return""}if(b!==undefined){this.set("isEditing",YES);c.align=b;return b}else{return c.align
}}.property("selectedImage").cacheable(),imageWidth:function(a,b){var c=this.get("selectedImage");
if(!c){return""}if(b!==undefined){this.set("isEditing",YES);c.width=b;c.style.width=b;
return b}else{return c.clientWidth}}.property("selectedImage").cacheable(),imageHeight:function(a,b){var c=this.get("selectedImage");
if(!c){return""}if(b!==undefined){this.set("isEditing",YES);c.height=b;c.style.height=b;
return b}else{return c.clientHeight}}.property("selectedImage").cacheable(),imageDescription:function(a,b){var c=this.get("selectedImage");
if(!c){return""}if(b!==undefined){this.set("isEditing",YES);c.title=b;c.alt=b;return b
}else{return c.alt}}.property("selectedImage").cacheable(),imageBorderWidth:function(a,b){var c=this.get("selectedImage");
if(!c){return""}if(b!==undefined){this.set("isEditing",YES);c.style.borderWidth=b;
return b}else{return c.style.borderWidth}}.property("selectedImage").cacheable(),imageBorderColor:function(b,c){var d=this.get("selectedImage");
if(!d){return""}if(c!==undefined){this.set("isEditing",YES);d.style.borderColor=c;
return c}else{var a=d.style.borderColor;if(a!==""){return SC.parseColor(a)}else{return""
}}}.property("selectedImage").cacheable(),imageBorderStyle:function(a,b){var c=this.get("selectedImage");
if(!c){return""}if(b!==undefined){this.set("isEditing",YES);c.style.borderStyle=b;
return b}else{return c.style.borderStyle}}.property("selectedImage").cacheable(),resetImageDimensions:function(){var a=this.get("selectedImage");
if(!a){return NO}a.style.width="";a.style.height="";a.removeAttribute("width");a.removeAttribute("height");
this.set("isEditing",YES);this.notifyPropertyChange("selectedImage");return a},focus:function(){if(!SC.none(this._document)){this._document.body.focus();
this.set("selection","");this.querySelection()}},querySelection:function(){var c=this._iframe;
if(!c){return}var a="";if(SC.browser.msie){a=this._iframe.document.selection.createRange().text;
if(SC.none(a)){a=""}}else{var b=c.contentWindow;a=b.getSelection()}this.propertyWillChange("selection");
this.set("selection",a.toString());this.propertyDidChange("selection")},createLink:function(h){var g=this._document;
var b=this._iframe;if(!(g&&b)){return NO}if(SC.none(h)||h===""){return NO}var e="%@%@%@%@%@".fmt("http://",this.get("frameName"),new Date().getTime(),parseInt(Math.random()*100000,0),".com/");
if(g.execCommand("createlink",false,e)){var c=b.contentWindow.getSelection().focusNode;
var i=c.parentNode;if(i.nodeName.toLowerCase()!=="a"){var a;for(var f=0,d=c.childNodes.length;
f<d;f++){a=c.childNodes[f];if(a.nodeName.toLowerCase()==="a"){if(a.href===e){i=a;
break}}}}i.href=h;this.set("selectedHyperlink",i);this.set("isEditing",YES);return YES
}return NO},removeLink:function(){var a=this._document;if(!a){return NO}if(a.execCommand("unlink",false,null)){this.set("selectedHyperlink",null);
this.set("isEditing",YES);return YES}return NO},insertImage:function(a){var b=this._document;
if(!b){return NO}if(SC.none(a)||a===""){return NO}if(b.execCommand("insertimage",false,a)){this.set("isEditing",YES);
return YES}return NO},insertHTML:function(b,a){var c=this._document;if(!c){return NO
}if(SC.none(b)||b===""){return NO}if(SC.none(a)||a){b+="\u00a0"}if(SC.browser.msie){c.selection.createRange().pasteHTML(b);
this.set("isEditing",YES);return YES}else{if(c.execCommand("inserthtml",false,b)){this.set("isEditing",YES);
return YES}return NO}},insertView:function(a){if(SC.typeOf(a)===SC.T_STRING){if(a===SC.CONTENT_SET_DIRECTLY){return
}if(a&&a.length>0){if(a.indexOf(".")>0){a=SC.objectForPropertyPath(a,null)}else{a=SC.objectForPropertyPath(a,this.get("page"))
}}}else{if(SC.typeOf(a)===SC.T_CLASS){a=a.create()}}var c=SC.RenderContext(a);c=c.begin("span");
a.prepareContext(c,YES);c=c.end();c=c.join();var b;if(SC.browser.msie){b='<span contenteditable=false unselectable="on">'+c+"</span>"
}else{b='<span contenteditable=false style="-moz-user-select: all">'+c+"</span>"}this.insertHTML(b)
},cleanWordHTML:function(a){a=a.replace(/\<o:p>\s*<\/o:p>/g,"");a=a.replace(/\<o:p>[\s\S]*?<\/o:p>/g,"&nbsp;");
a=a.replace(/\s*<w:[^>]*>[\s\S]*?<\/w:[^>]*>/gi,"");a=a.replace(/\s*<w:[^>]*\/?>/gi,"");
a=a.replace(/\s*<\/w:[^>]+>/gi,"");a=a.replace(/\s*<m:[^>]*>[\s\S]*?<\/m:[^>]*>/gi,"");
a=a.replace(/\s*<m:[^>]*\/?>/gi,"");a=a.replace(/\s*<\/m:[^>]+>/gi,"");a=a.replace(/\s*mso-[^:]+:[^;"]+;?/gi,"");
a=a.replace(/\s*mso-[^:]+:[^;]+"?/gi,"");a=a.replace(/\s*MARGIN: 0cm 0cm 0pt\s*;/gi,"");
a=a.replace(/\s*MARGIN: 0cm 0cm 0pt\s*"/gi,'"');a=a.replace(/\s*TEXT-INDENT: 0cm\s*;/gi,"");
a=a.replace(/\s*TEXT-INDENT: 0cm\s*"/gi,'"');a=a.replace(/\s*PAGE-BREAK-BEFORE: [^\s;]+;?"/gi,'"');
a=a.replace(/\s*FONT-VARIANT: [^\s;]+;?"/gi,'"');a=a.replace(/\s*tab-stops:[^;"]*;?/gi,"");
a=a.replace(/\s*tab-stops:[^"]*/gi,"");a=a.replace(/\<\\?\?xml[^>]*>/gi,"");a=a.replace(/\<(\w[^>]*) lang=([^ |>]*)([^>]*)/gi,"<$1$3");
a=a.replace(/\<(\w[^>]*) language=([^ |>]*)([^>]*)/gi,"<$1$3");a=a.replace(/\<(\w[^>]*) onmouseover="([^\"]*)"([^>]*)/gi,"<$1$3");
a=a.replace(/\<(\w[^>]*) onmouseout="([^\"]*)"([^>]*)/gi,"<$1$3");a=a.replace(/\<(meta|link)[^>]+>\s*/gi,"");
return a},commitEditing:function(){var b=this._document;if(!b){return NO}var a=b.body.innerHTML;
if(this.get("cleanInsertedText")){a=this.cleanWordHTML(a)}if(this.get("stripCrap")){a=a.replace(/\r/g,"&#13;");
a=a.replace(/\n/g,"&#10;")}if(this.get("encodeContent")){a=this._encodeValues(a)}this.set("value",a);
this.set("isEditing",NO);return YES},selectContent:function(){var a=this._document;
if(!a){return NO}return a.execCommand("selectall",false,null)},selectionDidChange:function(){var d,a,c=null,e=null;
if(SC.browser.msie){var b=this._iframe.document.selection;a=b.createRange();if(a.length===1){d=a.item()
}if(a.parentElement){d=a.parentElement()}}else{var f=this._iframe.contentWindow;b=f.getSelection();
a=b.getRangeAt(0);d=a.startContainer.childNodes[a.startOffset];if(a.startContainer===a.endContainer){if(a.startContainer.parentNode.nodeName==="A"&&a.commonAncestorContiner!==d){e=a.startContainer.parentNode
}else{e=null}}else{e=null}}if(d){if(d.nodeName==="IMG"){c=d;if(d.parentNode.nodeName==="A"){e=d.parentNode
}}else{if(d.nodeName==="A"){e=d}else{c=null;e=null}}}this.set("selectedImage",c);
this.set("selectedHyperlink",e)}.observes("selection"),isEditingDidChange:function(){if(this.get("autoCommit")){this.commitEditing()
}}.observes("isEditing"),_updateAttachedViewLayout:function(){var c=this.get("offsetWidth");
var a=this.get("offsetHeight");var b=this.get("attachedView");var d=b.get("layout");
d=SC.merge(d,{width:c,height:a});b.adjust(d)},_updateLayout:function(){var d=this._document;
if(!d){return}var b,a;if(SC.browser.msie){b=d.body.scrollWidth;a=d.body.scrollHeight
}else{b=d.body.offsetWidth;a=d.body.offsetHeight}if(a<this._minHeight){a=this._minHeight
}if(b<this._minWidth){b=this._minWidth}this.set("offsetWidth",b);this.set("offsetHeight",a);
if(this.get("attachedView")){this._updateAttachedViewLayout()}if(!this.get("hasFixedDimensions")){var c=this.get("layout");
c=SC.merge(c,{width:b,height:a});this.propertyWillChange("layout");this.adjust(c);
this.propertyDidChange("layout")}},_getFrame:function(){var a;if(SC.browser.msie){a=document.frames(this.get("frameName"))
}else{a=this.$("iframe").firstObject()}if(!SC.none(a)){return a}return null},_getDocument:function(){var b=this._getFrame();
if(SC.none(b)){return null}var a;if(SC.browser.msie){a=b.document}else{a=b.contentDocument
}if(SC.none(a)){return null}return a},_getSelection:function(){var a;if(SC.browser.msie){a=this._getDocument().selection
}else{a=this._getFrame().contentWindow.getSelection()}return a},_getSelectedElemented:function(){var b=this._getSelection();
var d;if(SC.browser.msie){d=b.createRange().parentElement()}else{var a=b.anchorNode;
var c=b.focusNode;if(a&&c){if(a.nodeType===3&&c.nodeType===3){if(a.parentNode===c.parentNode){d=a.parentNode
}}}}return d},_encodeValues:function(d){var f=d.match(/href=".*?"/gi);if(f){var a,e;
for(var c=0,b=f.length;c<b;c++){a=e=f[c];d=d.replace(/\%3C/gi,"<");d=d.replace(/\%3E/gi,">");
d=d.replace(/\%20/g," ");d=d.replace(/\&amp;/gi,"&");d=d.replace(/\%27/g,"'");d=d.replace(a,e)
}}return d}});require("core");SCUI.DisclosedView=SC.View.extend({classNames:["scui-disclosed-view"],displayProperties:["isOpen","statusIconName"],contentView:null,title:"",description:"",iconCSSName:"",statusIconName:"",_contentView:null,_collapsedView:SC.View,isOpen:YES,titleBar:SC.DisclosureView,containerView:SC.ContainerView,collapsedHeight:44,expandedHeight:300,mode:SCUI.DISCLOSED_STAND_ALONE,init:function(){arguments.callee.base.apply(this,arguments)
},createChildViews:function(){var b=[],a;var e=this.get("contentView");var c;var d=this;
a=this._titleBar=this.createChildView(this.titleBar.extend({layout:{top:0,left:5,right:5,height:d.get("collapsedHeight")},titleBinding:SC.binding(".title",this),descriptionBinding:SC.binding(".description",this),iconCSSNameBinding:SC.binding(".iconCSSName",this),statusIconNameBinding:SC.binding(".statusIconName",this),value:this.get("isOpen"),displayProperties:"statusIconName".w(),render:function(f,g){f=f.begin("div").addClass("disclosure-inner");
f=f.begin("div").addClass("disclosure-label");f=f.begin("img").attr({src:SC.BLANK_IMAGE_URL,alt:""}).addClass("button").end();
f=f.begin("img").attr({src:SC.BLANK_IMAGE_URL,alt:""}).addClass("icon").addClass(this.iconCSSName).end();
f=f.begin("img").attr({src:SC.BLANK_IMAGE_URL,alt:""}).addClass("status").addClass(this.statusIconName).end();
f=f.begin("span").addClass("title").push(this.get("displayTitle")).end();f.attr("title",this.description);
f.attr("alt",this.description);f=f.end();f=f.end()},mouseDown:function(f){if(f.target.className!=="button"){return NO
}else{return YES}},_valueObserver:function(){if(this.owner&&this.owner.toggle){this.owner.toggle(this.get("value"))
}}.observes("value")}),{rootElementPath:[0]});b.push(a);e=this.createChildView(e,{classNames:"processing-step-settings".w(),layout:{top:d.get("collapsedHeight")-5,left:5,right:5},render:function(f,g){arguments.callee.base.apply(this,arguments);
if(g){f=f.begin("div").addClass("bottom-left-edge").push("").end();f=f.begin("div").addClass("bottom-right-edge").push("").end()
}}});b.push(e);this.set("childViews",b);return this},render:function(a,b){this._setupView();
arguments.callee.base.apply(this,arguments)},toggle:function(a){if(!a){this.set("isOpen",NO);
if(this.get("mode")===SCUI.DISCLOSED_STAND_ALONE){this._updateHeight(YES)}else{if(this.owner&&this.owner.collapse){this.owner.collapse()
}}}else{this.set("isOpen",YES);if(this.get("mode")===SCUI.DISCLOSED_STAND_ALONE){this._updateHeight()
}else{if(this.owner&&this.owner.expand){this.owner.expand()}}}},updateHeight:function(a,b){if(a){this._updateHeight(b)
}else{this.invokeLast(this._updateHeight)}return this},_updateHeight:function(b){var a;
if(!b){a=this.get("expandedHeight")}else{a=this.get("collapsedHeight")}this.adjust("height",a)
},_createChildViewIfNeeded:function(a){if(SC.typeOf(a)===SC.T_CLASS){return this.createChildView(a)
}else{return a}},_setupView:function(){var a=this.get("isOpen");var b=this.get("mode");
if(a){if(this.get("mode")===SCUI.DISCLOSED_STAND_ALONE){this.updateHeight()}}else{if(this.get("mode")===SCUI.DISCLOSED_STAND_ALONE){this._updateHeight(YES)
}}}});SCUI.LoadingSpinnerView=SC.View.extend({layout:{left:0,right:0,top:0,bottom:0},totalFrames:28,frameChangeInterval:200,callCount:0,appendTo:function(a){if(this.get("callCount")===0){a.appendChild(this)
}this.set("isVisible",true);this.invokeLater(function(){this.set("callCount",this.get("callCount")+1)
});return this},remove:function(){this.set("callCount",this.get("callCount")-1);if(this.get("callCount")<=0){this.set("_state",SCUI.LoadingSpinnerView.STOPPED);
this.get("parentView").removeChild(this);this.destroy()}},callCountDidChange:function(){if(this.get("parentView")!==null){if(this.get("_state")===SCUI.LoadingSpinnerView.STOPPED&&this.get("callCount")>0){this.set("isVisible",true);
this.set("_state",SCUI.LoadingSpinnerView.PLAYING);this.get("spinnerView").nextFrame()
}}if(this.get("callCount")<=0){this.set("isVisible",false);this.set("_state",SCUI.LoadingSpinnerView.STOPPED)
}}.observes("callCount"),theme:"lightTrans",childViews:"spinnerView".w(),spinnerView:SC.View.design({layout:{centerX:0,centerY:0,height:18,width:18},classNames:["loadingSpinner"],currentFrame:0,frameChangeInterval:200,_state:null,init:function(){arguments.callee.base.apply(this,arguments);
this.get("classNames").push(this.getPath("parentView.theme"));this.set("frameChangeInterval",this.getPath("parentView.frameChangeInterval"));
this.set("_state",this.getPath("parentView._state"))},nextFrame:function(){var a=this.get("currentFrame");
var b=0-this.get("layout").height*a;this.$().css("background-position","0px %@1px".fmt(b));
if(this.get("currentState")===SCUI.LoadingSpinnerView.PLAYING){this.invokeLater(function(){this.nextFrame()
},this.get("frameChangeInterval"))}a+=1;if(a===this.getPath("parentView.totalFrames")){a=0
}this.set("currentFrame",a)},currentState:function(){return this.getPath("parentView._state")
}.property()}),_state:"STOPPED"});SC.mixin(SCUI.LoadingSpinnerView,{PLAYING:"PLAYING",STOPPED:"STOPPED"});
SCUI.SelectFieldTab=SC.View.extend({classNames:["scui-select-field-tab-view"],displayProperties:["nowShowing"],nowShowing:null,items:[],isEnabled:YES,itemTitleKey:null,itemValueKey:null,itemIsEnabledKey:null,itemIconKey:null,itemWidthKey:null,itemToolTipKey:null,_tab_nowShowingDidChange:function(){var a=this.get("nowShowing");
this.get("containerView").set("nowShowing",a);this.get("selectFieldView").set("value",a);
return this}.observes("nowShowing"),_tab_itemsDidChange:function(){this.get("selectFieldView").set("items",this.get("items"));
return this}.observes("items"),_isEnabledDidChange:function(){var a=this.get("isEnabled");
if(this.containerView&&this.containerView.set){this.containerView.set("isEnabled",a)
}if(this.selectFieldView&&this.selectFieldView.set){this.selectFieldView.set("isEnabled",a)
}}.observes("isEnabled"),init:function(){arguments.callee.base.apply(this,arguments);
this._tab_nowShowingDidChange()._tab_itemsDidChange()},createChildViews:function(){var d=[],b,a;
var c=this.get("isEnabled");a=this.containerView.extend({layout:{top:24,left:0,right:0,bottom:0}});
b=this.containerView=this.createChildView(a,{isEnabled:c});d.push(b);b=this.selectFieldView=this.createChildView(this.selectFieldView,{isEnabled:c});
d.push(b);this.set("childViews",d);return this},containerView:SC.ContainerView,selectFieldView:SC.SelectFieldView.extend({layout:{left:4,right:0,height:24},items:function(a,b){if(b===undefined){return this.get("objects")
}else{return this.set("objects",b)}}.property("objects").cacheable(),itemTitleKey:function(a,b){if(b===undefined){return this.get("nameKey")
}else{return this.set("nameKey",b)}}.property("nameKey").cacheable(),itemValueKey:function(a,b){if(b===undefined){return this.get("valueKey")
}else{return this.set("valueKey",b)}}.property("valueKey").cacheable(),_scui_select_field_valueDidChange:function(){var a=this.get("parentView");
if(a){a.set("nowShowing",this.get("value"))}this.set("layerNeedsUpdate",YES);this.invokeOnce(this.updateLayerIfNeeded)
}.observes("value"),init:function(){var a=this.get("parentView");if(a){SC._TAB_ITEM_KEYS.forEach(function(b){this[SCUI._SELECT_TAB_TRANSLATOR[b]]=a.get(b)
},this)}return arguments.callee.base.apply(this,arguments)}})});SCUI._SELECT_TAB_TRANSLATOR={itemTitleKey:"nameKey",itemValueKey:"valueKey",items:"objects"};
SCUI.StepperView=SC.View.extend({layout:{top:0,left:0,width:19,height:27},value:0,increment:1,max:null,min:null,valueWraps:NO,createChildViews:function(){var e=[];
var d=this.get("value");var a=this.get("increment");var c=this;var b=this.createChildView(SC.ButtonView.design({classNames:["scui-stepper-view-top"],layout:{top:0,left:0,width:19,height:13},mouseUp:function(){arguments.callee.base.apply(this,arguments);
var i=c.get("value");i=i-0;var f=c.get("max");i=i+a;var h=c.get("valueWraps");if(f===null||i<=f){c.set("value",i)
}else{if(h){var g=c.get("min");if(g!==null){i=i-f-a;i=i+g;c.set("value",i)}}}}}));
e.push(b);b=this.createChildView(SC.ButtonView.design({classNames:["scui-stepper-view-bottom"],layout:{top:14,left:0,width:19,height:13},mouseUp:function(){arguments.callee.base.apply(this,arguments);
var i=c.get("value");i=i-0;var h=c.get("min");i=i-a;var g=c.get("valueWraps");if(h===null||i>=h){c.set("value",i)
}else{if(g){var f=c.get("max");if(f!==null){i=h-i-a;i=f-i;c.set("value",i)}}}}}));
e.push(b);this.set("childViews",e)}});SCUI.UploadView=SC.View.extend({value:null,uploadTarget:null,status:"",inputName:"Filedata",displayProperties:"uploadTarget".w(),render:function(c,h){var d=this.get("layerId")+"Frame";
var g=this.get("uploadTarget");var b=this.get("label");var a=this.get("inputName");
if(h){c.push('<form method="post" enctype="multipart/form-data" target="'+d+'" action="'+g+'">');
c.push('<input type="file" name="'+a+'" />');c.push("</form>");c.push('<iframe frameborder="0" id="'+d+'" name="'+d+'" style="width:0; height:0;"></iframe>')
}else{var e=this._getForm();if(e){e.action=g}}arguments.callee.base.apply(this,arguments)
},didCreateLayer:function(){arguments.callee.base.apply(this,arguments);var b=this.$("iframe");
var a=this.$("input");SC.Event.add(b,"load",this,this._uploadDone);SC.Event.add(a,"change",this,this._checkInputValue);
this.set("status",SCUI.READY)},willDestroyLayer:function(){var b=this.$("iframe");
var a=this.$("input");SC.Event.remove(b,"load",this,this._uploadDone);SC.Event.remove(a,"change",this,this._checkInputValue);
arguments.callee.base.apply(this,arguments)},startUpload:function(){var a=this._getForm();
if(a){a.submit();this.set("status",SCUI.BUSY)}},clearFileUpload:function(){var b=this._getForm();
if(b){var a=this.$("input");SC.Event.remove(a,"change",this,this._checkInputValue);
b.innerHTML=b.innerHTML;this.set("status",SCUI.READY);this.set("value",null);a=this.$("input");
SC.Event.add(a,"change",this,this._checkInputValue)}},validateFileSelection:function(){var a=this.get("value");
if(a){return YES}return NO},_uploadDone:function(){SC.RunLoop.begin();this.set("status",SCUI.DONE);
SC.RunLoop.end()},_checkInputValue:function(){SC.RunLoop.begin();var a=this._getInput();
this.set("value",a.value);SC.RunLoop.end()},_getForm:function(){var a=this.$("form");
if(a&&a.length>0){return a.get(0)}return null},_getInput:function(){var a=this.$("input");
if(a&&a.length>0){return a.get(0)}return null}});if((typeof SC!=="undefined")&&SC&&SC.bundleDidLoad){SC.bundleDidLoad("scui/foundation")
};