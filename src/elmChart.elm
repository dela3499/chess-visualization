module BarChart where
    
import Mouse
import Window

-- Ports --
type DataSeries = [Int]
port dataset : Signal DataSeries -- from JS

port moveInput : Signal Int -- to JS
port moveInput = (flip (//) 50) <~ Mouse.x -- Divide mouse x-pos by 50

-- Chart --
type Config = {h: Int, w: Int}

config: Config
config = { h = 800, w = 1500 }  

makeBar: Float -> Float -> Float -> Float -> Form
makeBar x y w h = filled red (rect w h) |> move (x,y)

makeChart: Config -> DataSeries -> [Form]
makeChart c d = 
  let
    w = c.w // (length d)
    y = -c.h // 2
    indexes = [0 .. (length d - 1)] 
    xs = map (\i -> i * w - (c.w - w) // 2 |> toFloat) indexes
    hs = map ((*) 5 >> toFloat) d
    drawBar x h = makeBar x (toFloat y) (toFloat w) h
  in 
    zipWith drawBar xs hs

render: Config -> DataSeries -> Element
render c d = collage c.w c.h (makeChart c d)
  
main: Signal Element    
main = (render config) <~ dataset