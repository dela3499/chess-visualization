module BarChart where
    
import Mouse
import Window
import Transform2D

port dataset : Signal [Int]

port moveInput : Signal Int
port moveInput = scaleInput <~ Mouse.x ~ Window.width
  
scaleInput: number -> number -> number
scaleInput pos width = pos`div` 50  

config = constant {
  h = 800, 
  w = 1500
  }  

barchart: [number] -> {h: number, w: number} -> Element
barchart dataset config = 
  let c = config
      barWidth = c.w `div` (length dataset)
      align form = form |> move (-0.5 * toFloat(c.w) + toFloat(barWidth) * 0.5, -75)
      scaleChart m forms = groupTransform (Transform2D.scaleY m) forms
  in collage c.w c.h [(createBars dataset barWidth 0 |> scaleChart 5 |> align)]
  
  
createBars: [number] -> number -> number -> [Form]
createBars list barWidth i = 
  case list of
    [] -> []
    head::tail -> 
      let firstBar = filled red (rect barWidth head) |> move (i * barWidth, (head / 2))
          restBars = createBars tail barWidth (i + 1) 
      in firstBar :: restBars
  
main: Signal Element    
main = barchart <~ dataset ~ config