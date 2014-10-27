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
   var Window = Elm.Window.make(_elm);
   var _op = {};
   var scale = F2(function (pos,
   width) {
      return pos / 200 | 0;
   });
   var move = Native.Ports.portOut("move",
   Native.Ports.outgoingSignal(function (v) {
      return v;
   }),
   A2(Signal._op["~"],
   A2(Signal._op["<~"],
   scale,
   Mouse.x),
   Window.width));
   var dataset = Native.Ports.portIn("dataset",
   Native.Ports.incomingSignal(function (v) {
      return _U.isJSArray(v) ? _L.fromArray(v.map(function (v) {
         return typeof v === "number" ? v : _E.raise("invalid input, expecting JSNumber but got " + v);
      })) : _E.raise("invalid input, expecting JSArray but got " + v);
   }));
   var main = A2(Signal._op["<~"],
   Text.asText,
   dataset);
   _elm.BarChart.values = {_op: _op
                          ,scale: scale
                          ,main: main};
   return _elm.BarChart.values;
};