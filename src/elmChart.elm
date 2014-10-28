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

makeChart: Config -> DataSeries
makeChart c d = 
  let
    barWidth = c.width / (length d)
    yOffset = -c.height / 2
    drawBar xOffset barHeight = makeBar barWidth barHeight xOffset yOffset
    indexes = [0 .. (length d - 1)]
    xOffsets = map (\i -> (i * barWidth) - (config.width / 2)) indexes
    barHeights = map (scale 50) d
  in 
    zipWith drawBar xOffsets barHeights

render: Config -> DataSeries -> Element
render c d = collage c.w c.h (makeChart c d)
  
main: Signal Element    
main = (render config) <~ dataset