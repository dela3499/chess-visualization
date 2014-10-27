module BarChart where
    
import Mouse
import Window
import Transform2D

config: {h: Int, w: Int}
config = { h = 800, w = 1500 }

port dataset : Signal [Float]

port moveInput : Signal Int
port moveInput = scaleInput <~ Mouse.x
  
scaleInput: number -> number
scaleInput x = x `div` 50

createBar: number -> number -> number -> Form
createBar i w h  = 
    let x = (toFloat config.w) / 2
        y = (toFloat config.h) / 2
    in filled red (rect w (h*7)) |> move (i * w - x , -y)

createBarChart: [number] -> [Form]
createBarChart d = 
    let w = toFloat (config.w `div` (length d))
    in map (\t -> createBar (toFloat (fst t)) w (snd t))  (zip [0..(length d) - 1] d)
    
render: [number] -> Element
render ds = collage config.w config.h (createBarChart ds)
  
main: Signal Element    
main = lift render dataset

