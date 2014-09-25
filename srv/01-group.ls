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


stream = fs.createReadStream "#__dirname/../data/prebehlici.csv"
reader = parse {delimiter: ','}
stream.pipe reader


initObec = (id, nazev) ->
  obce[id] =
    id: id
    nazev: nazev
    celkem: 0
    prebehliku: 0


reader.on \data (line) ->
  [...pycoviny, prebehlik, kodzastup, ID, mandaty, pocobyv, obec] = line
  return if obec == \NAZEVOBCE
  if not obce[ID] then initObec ID, obec
  obec = obce[ID]
  obec.celkem++
  if prebehlik == \True
    obec.prebehliku++
<~ reader.on \end

obce_arr = for id, obec of obce
  for key, value of obec
    value

obce_arr.unshift do
  for key, value of obec
    key
fs.writeFileSync do
  "#__dirname/../data/obce.tsv"
  obce_arr.map (.join '\t') .join '\n'
