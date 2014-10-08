require! fs
require! parse: "csv-parse"

obce = {}

groupVek = (vek) ->
  if vek <= 25
    return 0
  if vek > 95
    return 14
  vek -= 25
  Math.ceil vek / 5


stream = fs.createReadStream "#__dirname/../data/prebehliciMapa.csv"
reader = parse {delimiter: ','}
stream.pipe reader


initObec = (id, nazev) ->
  obce[id] =
    id: id
    nazev: nazev
    celkem: 0
    prebehliku: 0


reader.on \data (line) ->
  [_, _, ID, _, obec, ...pycoviny, prebehlik] = line
  return if obec == \NAZEVOBCE
  return if ID not in <[582786 563889 555134 554821 554804 554791 554782 505927]>
  if not obce[ID] then initObec ID, obec
  obec = obce[ID]
  obec.celkem++
  if prebehlik == \TRUE
    obec.prebehliku++
<~ reader.on \end

obce_arr = for id, obec of obce
  for key, value of obec
    value

obce_arr.unshift do
  for key, value of obec
    key
fs.writeFileSync do
  "#__dirname/../data/magose.tsv"
  obce_arr.map (.join '\t') .join '\n'
