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
config: {h: number, w: number}
config = { h = 800, w = 1500 }  

makeBar: number -> number -> number -> Form
makeBar i h w  = 
    let x = config.w / 2
        y = config.h / 2
    in filled red (rect w (h*7)) |> move (i * w - x , -y)

makeChart: [number] -> [Form]
makeChart d = 
    let w  = config.w / toFloat(length d)
        cb i h = makeBar i h w
    in indexedMap cb d
    
render: [number] -> Element
render ds = collage config.w config.h (makeChart ds)
  
main: Signal Element    
main = lift render dataset