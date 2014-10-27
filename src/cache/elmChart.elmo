Elm.BarChart = Elm.BarChart || {};
Elm.BarChart.make = function (_elm) {
   "use strict";
   _elm.BarChart = _elm.BarChart || {};
   if (_elm.BarChart.values)
   return _elm.BarChart.values;
   var _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "BarChart";
   var Basics = Elm.Basics.make(_elm);
   var Color = Elm.Color.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Collage = Elm.Graphics.Collage.make(_elm);
   var Graphics = Graphics || {};
   Graphics.Element = Elm.Graphics.Element.make(_elm);
   var List = Elm.List.make(_elm);
   var Maybe = Elm.Maybe.make(_elm);
   var Mouse = Elm.Mouse.make(_elm);
   var Native = Native || {};
   Native.Json = Elm.Native.Json.make(_elm);
   var Native = Native || {};
   Native.Ports = Elm.Native.Ports.make(_elm);
   var Signal = Elm.Signal.make(_elm);
   var String = Elm.String.make(_elm);
   var Text = Elm.Text.make(_elm);
   var Time = Elm.Time.make(_elm);
   var Transform2D = Elm.Transform2D.make(_elm);
   var Window = Elm.Window.make(_elm);
   var _op = {};
   var createBars = F3(function (list,
   barWidth,
   i) {
      return function () {
         switch (list.ctor)
         {case "::": return function () {
                 var restBars = A3(createBars,
                 list._1,
                 barWidth,
                 i + 1);
                 var firstBar = Graphics.Collage.move({ctor: "_Tuple2"
                                                      ,_0: i * barWidth
                                                      ,_1: list._0 / 2})(A2(Graphics.Collage.filled,
                 Color.red,
                 A2(Graphics.Collage.rect,
                 barWidth,
                 list._0)));
                 return {ctor: "::"
                        ,_0: firstBar
                        ,_1: restBars};
              }();
            case "[]":
            return _L.fromArray([]);}
         _E.Case($moduleName,
         "between lines 32 and 38");
      }();
   });
   var barchart = F2(function (dataset,
   config) {
      return function () {
         var scaleChart = F2(function (m,
         forms) {
            return A2(Graphics.Collage.groupTransform,
            Transform2D.scaleY(m),
            forms);
         });
         var c = config;
         var barWidth = c.w / List.length(dataset) | 0;
         var align = function (form) {
            return Graphics.Collage.move({ctor: "_Tuple2"
                                         ,_0: -0.5 * Basics.toFloat(c.w) + Basics.toFloat(barWidth) * 0.5
                                         ,_1: -75})(form);
         };
         return A3(Graphics.Collage.collage,
         c.w,
         c.h,
         _L.fromArray([align(scaleChart(5)(A3(createBars,
         dataset,
         barWidth,
         0)))]));
      }();
   });
   var config = Signal.constant({_: {}
                                ,h: 800
                                ,w: 1500});
   var scaleInput = F2(function (pos,
   width) {
      return pos / 50 | 0;
   });
   var moveInput = Native.Ports.portOut("moveInput",
   Native.Ports.outgoingSignal(function (v) {
      return v;
   }),
   A2(Signal._op["~"],
   A2(Signal._op["<~"],
   scaleInput,
   Mouse.x),
   Window.width));
   var dataset = Native.Ports.portIn("dataset",
   Native.Ports.incomingSignal(function (v) {
      return _U.isJSArray(v) ? _L.fromArray(v.map(function (v) {
         return typeof v === "number" ? v : _E.raise("invalid input, expecting JSNumber but got " + v);
      })) : _E.raise("invalid input, expecting JSArray but got " + v);
   }));
   var main = A2(Signal._op["~"],
   A2(Signal._op["<~"],
   barchart,
   dataset),
   config);
   _elm.BarChart.values = {_op: _op
                          ,scaleInput: scaleInput
                          ,config: config
                          ,barchart: barchart
                          ,createBars: createBars
                          ,main: main};
   return _elm.BarChart.values;
};