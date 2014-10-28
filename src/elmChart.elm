module BarChart where
    
import Mouse
import Window

-- Ports --
port dataset : Signal [Float] -- from JS

scaleInput: number -> number -> number
scaleInput s x = x // s

port moveInput : Signal Int -- to JS
port moveInput = (scaleInput 50) <~ Mouse.x

-- Chart --
type Config = {h: Int, w: Int}
type DataSeries = [Int]

config: Config
config = { h = 800, w = 1500 }  

makeBar: Float -> Float -> Float -> Float -> Form
makeBar w h x y = filled red (rect w h) |> move (x,y)

makeChart: Config -> DataSeries -> [Form]
makeChart c d = 
  let
    w = c.w / (length d)
    y = -c.h / 2
    indexes = [0 .. (length d - 1)]
    xs = map (\i -> (i * w) - (c.w / 2)) indexes
    hs = map (scale 50) d
    drawBar x h = makeBar w h x y
  in 
    zipWith drawBar xs hs

render: Config -> DataSeries -> Element
render c d = collage c.w c.h (makeChart c d)
  
main: Signal Element    
main = (render config) <~ dataset