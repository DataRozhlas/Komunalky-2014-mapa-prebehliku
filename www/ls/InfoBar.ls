vekGroups = <[18 25 30 35 40 45 50 55 60 65 70 75 80 85 90+]>
titulClassNames = <[ing mgr mudr judr jiny bez]>
titulLegend = [\Ing. \Mgr. \MUDr. \JUDr. \Jiný "Bez titulu"]

bezKandidatky =
  "Petkovy"
  "Zadní Střítež"
  "Srní"
  "Úherce"
  "Víska u Jevíčka"
  "Slavníč"
  "Růžená"

window.ig.InfoBar = class InfoBar
  (parentElement) ->
    @init parentElement

  displayData: ({nazev, celkem, prebehliku}) ->
    @nazev.text "#{nazev}"
    @container.classed \noData celkem == 0
    if !celkem
      if nazev in bezKandidatky
        @helpText.html "Obec nesestavila kandidátku"
      else
        @helpText.html "Vojenský újezd"
    else
      @helpText.html "Kliknutím do mapy zobrazíte detail kandidátky"

    prebehlikuPrc = (prebehliku / celkem * 100).toFixed 2 .replace '.' ','
    prebehlikuPrc += " %"

    if celkem
      @stats.data [celkem, prebehliku, prebehlikuPrc] .html -> it
    else
      @stats.data ['-' '-' '-'] .html -> it


  init: (parentElement) ->
    @container = parentElement.append \div
      ..attr \class "infoBar noData"
    @nazev = @container.append \h2
      ..text "Analýza kandidátní listiny"
    @helpText = @container.append \span
      ..attr \class \clickInvite
      ..text "Podrobnosti o obci zobrazíte najetím myši nad obec"

    stats = @container.append \div
      ..attr \class \stats
      ..append \div
        ..attr \class \celkem
        ..append \h4 .html \Kandidátů
        ..append \span .attr \class \value
      ..append \div
        ..attr \class \mandaty
        ..append \h4 .html \Přeběhlíků
        ..append \span .attr \class \value
      ..append \div
        ..attr \class \tlacenka
        ..append \h4 .html "Podíl přeběhlíků"
        ..append \span .attr \class \value
    @stats = stats.selectAll \span.value
