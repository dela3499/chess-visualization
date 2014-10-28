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
config = { h = 800, w = 1500 }  
{--
makeBar: number -> number -> number -> Form
makeBar i h w  = 
    let x = config.w / 2
        y = config.h / 2
    in filled red (rect w (h*7)) |> move (i * w - x , -y)

--}
makeBar y w x h = filled red (rect w h) |> move (x,y)

makeChart config dataset = 
  let 
    y = -config.height / 2
    w = config.width / (length dataset)
    
    getX i = (i * w) - (config.width / 2)
    xs = map getX [0 .. (length dataset - 1)]
    
    getH value = scale 50 value
    hs = map getH dataset
  in 
    zipWith (makeBar y w) xs hs
{--
makeChart c d = 
    let cb i h = makeBar i h (c.w / toFloat(length d))
    in indexedMap cb d
    --}
render c d = collage c.w c.h (makeChart c d)
  
main: Signal Element    
main = (render config) <~ dataset