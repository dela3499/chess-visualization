module BarChart where
    
import Mouse
import Window

indexedMap: (Int -> a -> b) -> [a] -> [b]
indexedMap f list =  
  let indexes = [0 .. (length list - 1)]
  in zipWith f indexes list

config: {h: Float, w: Float}
config = { h = 800, w = 1500 }

port dataset : Signal [Float]

port moveInput : Signal Int
port moveInput = scaleInput <~ Mouse.x
  
scaleInput: number -> number
scaleInput x = x `div` 50

createBar: number -> number -> number -> Form
createBar i h w  = 
    let x = config.w / 2
        y = config.h / 2
    in filled red (rect w (h*7)) |> move (i * w - x , -y)

createBarChart: [number] -> [Form]
createBarChart d = 
    let w  = config.w / toFloat(length d)
        cb i h = createBar i h w
    in indexedMap cb d
    
render: [number] -> render
Element ds = collage config.w config.h (createBarChart ds)
  
main: Signal Element    
main = lift render dataset