Elm.BarChart = Elm.BarChart || {};
Elm.BarChart.make = function (_elm) {
   "use strict";
   _elm.BarChart = _elm.BarChart || {};
   if (_elm.BarChart.values)
   return _elm.BarChart.values;
   var _op = {},
   _N = Elm.Native,
   _U = _N.Utils.make(_elm),
   _L = _N.List.make(_elm),
   _A = _N.Array.make(_elm),
   _E = _N.Error.make(_elm),
   $moduleName = "BarChart",
   $Basics = Elm.Basics.make(_elm),
   $Color = Elm.Color.make(_elm),
   $Graphics$Collage = Elm.Graphics.Collage.make(_elm),
   $Graphics$Element = Elm.Graphics.Element.make(_elm),
   $List = Elm.List.make(_elm),
   $Mouse = Elm.Mouse.make(_elm),
   $Native$Json = Elm.Native.Json.make(_elm),
   $Native$Ports = Elm.Native.Ports.make(_elm),
   $Signal = Elm.Signal.make(_elm);
   var makeBar = F4(function (x,
   y,
   w,
   h) {
      return $Graphics$Collage.move({ctor: "_Tuple2"
                                    ,_0: x
                                    ,_1: y})(A2($Graphics$Collage.filled,
      $Color.red,
      A2($Graphics$Collage.rect,
      w,
      h)));
   });
   var makeChart = F2(function (c,
   d) {
      return function () {
         var hs = A2($List.map,
         function ($) {
            return $Basics.toFloat(F2(function (x,
            y) {
               return x * y;
            })(5)($));
         },
         d);
         var indexes = _L.range(0,
         $List.length(d) - 1);
         var y = (0 - c.h) / 2 | 0;
         var w = c.w / $List.length(d) | 0;
         var xs = A2($List.map,
         function (i) {
            return $Basics.toFloat(i * w - ((c.w - w) / 2 | 0));
         },
         indexes);
         var drawBar = F2(function (x,
         h) {
            return A4(makeBar,
            x,
            $Basics.toFloat(y),
            $Basics.toFloat(w),
            h);
         });
         return A3($List.zipWith,
         drawBar,
         xs,
         hs);
      }();
   });
   var render = F2(function (c,d) {
      return A3($Graphics$Collage.collage,
      c.w,
      c.h,
      A2(makeChart,c,d));
   });
   var config = {_: {}
                ,h: 800
                ,w: 1500};
   var Config = F2(function (a,b) {
      return {_: {},h: a,w: b};
   });
   var moveInput = $Native$Ports.portOut("moveInput",
   $Native$Ports.outgoingSignal(function (v) {
      return v;
   }),
   A2($Signal._op["<~"],
   A2($Basics.flip,
   F2(function (x,y) {
      return x / y | 0;
   }),
   50),
   $Mouse.x));
   var dataset = $Native$Ports.portIn("dataset",
   $Native$Ports.incomingSignal(function (v) {
      return _U.isJSArray(v) ? _L.fromArray(v.map(function (v) {
         return typeof v === "number" ? v : _E.raise("invalid input, expecting JSNumber but got " + v);
      })) : _E.raise("invalid input, expecting JSArray but got " + v);
   }));
   var main = A2($Signal._op["<~"],
   render(config),
   dataset);
   _elm.BarChart.values = {_op: _op
                          ,Config: Config
                          ,config: config
                          ,makeBar: makeBar
                          ,makeChart: makeChart
                          ,render: render
                          ,main: main};
   return _elm.BarChart.values;
};