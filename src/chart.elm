myData = [10,20,30,40,390,400]

config = {
  h = 400, 
  w = 400
  }


main = barchart myData config

--main = asText myData

barchart: [number] -> {h: number, w: number} -> Element
barchart dataset config = 
  let c = config
      barWidth = c.w // (length dataset)
      align forms = group forms |> move (-0.5 * toFloat(c.w) + toFloat(barWidth) * 0.5, -(toFloat c.h) / 2)
  in collage c.w c.h [(createBars dataset barWidth 0 |> align)]
  
createBars: [number] -> number -> number -> [Form]
createBars list barWidth i = 
  case list of
    [] -> []
    head::tail -> 
      let firstBar = filled red (rect barWidth head) |> move (i * barWidth, (head / 2))
          restBars = createBars tail barWidth (i + 1) 
      in firstBar :: restBars
