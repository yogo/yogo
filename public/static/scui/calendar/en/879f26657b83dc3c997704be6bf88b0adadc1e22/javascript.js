SCUI.PAST="past";SCUI.PRESENT="present";SCUI.TODAY="today";SCUI.FUTURE="future";sc_require("core");
SCUI.DateView=SC.View.extend(SCUI.SimpleButton,{classNames:["scui-date"],date:null,calendarView:null,timing:SCUI.PRESENT,content:null,isSelected:NO,init:function(){this.set("target",this);
this.set("action","_selectedDate");arguments.callee.base.apply(this,arguments)},displayProperties:["date","isSelected","timing"],render:function(c,e){var b=this.get("date")||SC.DateTime.create();
var d=this.get("timing");var a=this.get("isSelected");c.setClass(SCUI.PAST,SCUI.PAST===d);
c.setClass(SCUI.PRESENT,SCUI.PRESENT===d);c.setClass(SCUI.TODAY,SCUI.TODAY===d);c.setClass(SCUI.FUTURE,SCUI.FUTURE===d);
c.setClass("sel",a);c.begin("div").attr("class","date_number").push(b.get("day")).end()
},_selectedDate:function(){var a=this.get("calendarView");var b=this.get("date");
if(a){a.set("selectedDate",b)}}});sc_require("core");sc_require("views/date");SCUI.CalendarView=SC.View.extend({classNames:["scui-calendar"],monthStartOn:null,content:null,titleKey:"title",dateKey:"date",dateSize:{width:100,height:100},dateBorderWidth:0,headerHeight:null,weekdayHeight:20,exampleDateView:SCUI.DateView,selectedDate:null,weekdayStrings:["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],monthStrings:["January","February","March","April","May","June","July","August","September","October","November","December"],_dateGrid:[],init:function(){var e=this.get("monthStartOn")||SC.DateTime.create({day:1});
this.set("monthStartOn",e);var d=this.get("dateSize");var b=d.width||100;var c=d.height||100;
var a=this.get("headerHeight")||c/4;if(a<20){a=20}this.set("dateSize",{width:b,height:c});
this.set("headerHeight",a);this._dateGrid=[];arguments.callee.base.apply(this,arguments)
},awake:function(){this.resetToSelectedDate();arguments.callee.base.apply(this,arguments)
},resetToSelectedDate:function(){var a=this.get("selectedDate");if(a){this.set("monthStartOn",a.adjust({day:1}))
}},displayProperties:["monthStartOn","selectedDate","titleKey","dateKey","content","content.[]"],render:function(a,f){var t=this.get("dateBorderWidth");
var l=this.get("dateSize");var s=(2*t)+l.width;var c=(2*t)+l.height;var n=this.get("headerHeight");
var j=this.get("weekdayHeight");var b=s*7;var q=(c*6)+(n+j);var p=this.get("layout");
p=SC.merge(p,{width:b,height:q});this.set("layout",p);var m=this.get("monthStartOn");
var g=this.get("weekdayStrings");var k=this.get("monthStrings");var e=m.get("month");
var r=m.get("year");if(f){var d='<div class="month_header" style="position: absolute; left: %@1px; right: %@1px; height: %@2px;">%@3 %@4</div>';
a.push(d.fmt(s,n,k[e-1].loc(),r));var h=0;for(var o=0;o<7;o++){a.push('<div class="weekday" style="position: absolute; left: %@1px; top: %@2px; width: %@3px; height: 20px;">%@4</div>'.fmt(h,n,l.width,g[o].loc()));
h+=s}}else{this.$(".month_header").text("%@ %@".fmt(k[e-1].loc(),r))}this._updateDates();
arguments.callee.base.apply(this,arguments)},createChildViews:function(){var h=[],k=null;
var b=this.get("dateBorderWidth");var j=this.get("dateSize");var a=(2*b)+j.width;
var l=(2*b)+j.height;var e=this.get("headerHeight");k=this.createChildView(SC.View.design(SCUI.SimpleButton,{classNames:["scui-cal-button","previous-month-icon"],layout:{left:5,top:6,width:8,height:9},target:this,action:"previousMonth"}),{rootElementPath:[0]});
h.push(k);k=this.createChildView(SC.View.design(SCUI.SimpleButton,{classNames:["scui-cal-button","next-month-icon"],layout:{right:5,top:6,width:8,height:9},target:this,action:"nextMonth"}),{rootElementPath:[1]});
h.push(k);var c=b;var g=e+this.get("weekdayHeight");var f=this.get("exampleDateView");
for(var d=0;d<42;d++){k=this.createChildView(f.design({layout:{left:c,top:g,width:j.width,height:j.height},timing:SCUI.PAST,calendarView:this,date:d}),{rootElementPath:[d+2]});
this._dateGrid.push(k);h.push(k);if(((d+1)%7)===0){g+=l;c=b}else{c+=a}}this.set("childViews",h);
return this},nextMonth:function(){var b=this.get("monthStartOn");var a=b.advance({month:1});
this.set("monthStartOn",a);this.displayDidChange()},previousMonth:function(){var a=this.get("monthStartOn");
var b=a.advance({month:-1});this.set("monthStartOn",b);this.displayDidChange()},_updateDates:function(){var e=this.get("monthStartOn");
var f=e.get("month");var g=e.get("dayOfWeek");var c=e.advance({day:-g});var h=SC.DateTime.create();
var d=this.get("selectedDate");var b,a;for(var i=0;i<42;i++){if(i<g){this._dateGrid[i].set("timing",SCUI.PAST)
}else{if(c.get("month")===f){if(d){b=SC.DateTime.compareDate(c,d)===0?YES:NO;this._dateGrid[i].set("isSelected",b)
}a=SC.DateTime.compareDate(c,h)===0?SCUI.TODAY:SCUI.PRESENT;this._dateGrid[i].set("timing",a)
}else{this._dateGrid[i].set("timing",SCUI.FUTURE)}}this._dateGrid[i].set("date",c);
c=c.advance({day:1})}}});sc_require("core");SCUI.DatePickerView=SC.View.extend({classNames:["scui-datepicker-view"],date:null,dateString:"",isShowingCalendar:NO,hint:"",dateFormat:null,_textfield:null,_date_button:null,_calendar_popup:null,_calendar:null,_layout:{width:195,height:25},displayProperties:["date"],init:function(){arguments.callee.base.apply(this,arguments);
this.set("dateString",this._genDateString(this.get("date")));var a=this.get("layout");
a=SC.merge(this._layout,a);this.set("layout",a);this._calendar_popup=SC.PickerPane.create({layout:{width:195,height:215},contentView:SC.View.design({childViews:"calendar todayButton noneButton".w(),calendar:SCUI.CalendarView.design({layout:{left:10,top:0},dateSize:{width:25,height:25},weekdayStrings:["Su","Mo","Tu","We","Th","Fr","Sa"],selectedDate:this.get("date")}),todayButton:SC.View.extend(SCUI.SimpleButton,{classNames:["scui-datepicker-today"],layout:{left:10,bottom:0,width:50,height:18},target:this,action:"selectToday",render:function(b,c){if(c){b.push("Today")
}}}),noneButton:SC.View.design(SCUI.SimpleButton,{classNames:["scui-datepicker-none"],layout:{right:10,bottom:0,width:50,height:18},target:this,action:"clearSelection",render:function(b,c){if(c){b.push("None")
}}})})});if(this._calendar_popup){this.bind("date","._calendar_popup.contentView.calendar.selectedDate");
this.bind("isShowingCalendar","._calendar_popup.isPaneAttached");this._calendar=this._calendar_popup.getPath("contentView.calendar")
}},createChildViews:function(){var a,c=[];a=this._textfield=this.createChildView(SC.TextFieldView.design({layout:{left:0,top:0,right:25,bottom:0},classNames:["scui-datechooser-text"],isEnabled:NO,valueBinding:".parentView.dateString",hint:this.get("hint")}));
c.push(a);var b=this;a=this._date_button=this.createChildView(SC.View.design(SCUI.SimpleButton,{classNames:["scui-datechooser-button","calendar-icon"],layout:{right:0,top:3,width:16,height:16},target:this,action:"toggle",isEnabledBinding:SC.binding("isEnabled",b)}));
c.push(a);this.set("childViews",c);arguments.callee.base.apply(this,arguments)},hideCalendar:function(){if(this._calendar_popup){this._calendar_popup.remove();
this.set("isShowingCalendar",NO)}},showCalendar:function(){if(this._calendar_popup){this._calendar_popup.popup(this._textfield);
this._calendar.resetToSelectedDate();this.set("isShowingCalendar",YES)}},toggle:function(){if(this.isShowingCalendar){this.hideCalendar()
}else{this.showCalendar()}},selectToday:function(){this._calendar.set("selectedDate",SC.DateTime.create())
},clearSelection:function(){this._calendar.set("selectedDate",null)},_genDateString:function(b){var a=this.get("dateFormat")||"%a %m/%d/%Y";
var c=b?b.toFormattedString(a):"";return c},_dateDidChange:function(){this.set("dateString",this._genDateString(this.get("date")));
this.hideCalendar()}.observes("date")});if((typeof SC!=="undefined")&&SC&&SC.bundleDidLoad){SC.bundleDidLoad("scui/calendar")
};