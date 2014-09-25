require! fs
require! parse: "csv-parse"

stream = fs.createReadStream "#__dirname/../data/prebehlici.csv"
reader = parse {delimiter: ','}
stream.pipe reader

tituly_assoc = {}
rsdrs = []
currentObecId = null
currentObec = []
headers = <[jmeno prijmeni titulpred titulza vek povolani cislo strana zkratka cislo_old, strana_old zkratka_old prebehlik]>
saveCurrentObec = ->
  return if currentObec.length == 0
  out = ([headers] ++ currentObec).map (.join '\t') .join '\n'
  fs.writeFileSync "#__dirname/../data/obce/#currentObecId.tsv", out
  currentObec.length = 0

reader.on \data (line) ->
  [_, jmeno, prijmeni, IDzastup, okres2014, obec2014, poradi2014, titulpred2014, titulza2014, vek2014, povolani2014, IDstrany2014, hlasu2014, IDskupiny2014, nazevstrany2014, zkratkastrany2014, koalice2014, pohlavi2014, okres2010, obec2010, poradi2010, titulpred2010, titulza2010, vek2010, povolani2010, IDstrany2010, hlasu2010, IDskupiny2010, nazevstrany2010, zkratkastrany2010, koalice2010, pohlavi2010, prebehlik, KODZASTUP, id, MANDATY, POCOBYV, NAZEVOBCE] = line
  if id != currentObecId
    saveCurrentObec!
  currentObecId := id
  prebehlik = prebehlik == \True
  vek2014 = parseInt vek2014, 10
  currentObec.push [jmeno, prijmeni, titulpred2014, titulza2014, vek2014, povolani2014, poradi2014, nazevstrany2014, zkratkastrany2014, poradi2010, nazevstrany2010, zkratkastrany2010, prebehlik]

<~ reader.on \end
saveCurrentObec!
