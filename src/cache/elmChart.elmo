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
   var createBar = F3(function (i,
   w,
   h) {
      return Graphics.Collage.move({ctor: "_Tuple2"
                                   ,_0: i * w
                                   ,_1: 0})(A2(Graphics.Collage.filled,
      Color.red,
      A2(Graphics.Collage.rect,w,h)));
   });
   var scaleInput = function (x) {
      return x / 50 | 0;
   };
   var moveInput = Native.Ports.portOut("moveInput",
   Native.Ports.outgoingSignal(function (v) {
      return v;
   }),
   A2(Signal._op["<~"],
   scaleInput,
   Mouse.x));
   var dataset = Native.Ports.portIn("dataset",
   Native.Ports.incomingSignal(function (v) {
      return _U.isJSArray(v) ? _L.fromArray(v.map(function (v) {
         return typeof v === "number" ? v : _E.raise("invalid input, expecting JSNumber but got " + v);
      })) : _E.raise("invalid input, expecting JSArray but got " + v);
   }));
   var config = {_: {}
                ,h: 800
                ,w: 1500};
   var createBarChart = function (d) {
      return function () {
         var w = Basics.toFloat(config.w / List.length(d) | 0);
         return A2(List.map,
         function (t) {
            return A3(createBar,
            Basics.toFloat(Basics.fst(t)),
            w,
            Basics.snd(t));
         },
         A2(List.zip,
         _L.range(0,List.length(d) - 1),
         d));
      }();
   };
   var render = function (ds) {
      return A3(Graphics.Collage.collage,
      config.w,
      config.h,
      createBarChart(ds));
   };
   var main = A2(Signal.lift,
   render,
   dataset);
   _elm.BarChart.values = {_op: _op
                          ,config: config
                          ,scaleInput: scaleInput
                          ,createBar: createBar
                          ,createBarChart: createBarChart
                          ,render: render
                          ,main: main};
   return _elm.BarChart.values;
};