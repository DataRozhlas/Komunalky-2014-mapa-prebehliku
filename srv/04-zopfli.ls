require! {
  fs
  child_process.exec
  async
}
readdir = (dir, cb) ->
  (err, entries) <~ fs.readdir dir
  console.log err if err
  console.log dir if not entries
  dirs = []
  files = []
  for entry in entries
    addr = dir + "/" + entry
    if '.json' == entry.substr -5
      files.push addr
    else if '.png' != entry.substr -4
      dirs.push addr
  (err, subFiles) <~ async.map dirs, readdir

  cb null, files.concat ...subFiles
(err, list) <~ readdir "#__dirname/../data/tiles"
chunks = []
i = Infinity
for item in list
  if i > 10
    i = 0
    chunk = []
    chunks.push chunk
  chunk.push item
  ++i

len = chunks.length
i = 0
async.eachLimit chunks, 8, (chunk, cb) ->
  (err) <~ exec "zopfli #{chunk.join ' '}"
  i++
  console.log "#i / #len -- #{(i / len * 100).toFixed 2}%"
  cb!
