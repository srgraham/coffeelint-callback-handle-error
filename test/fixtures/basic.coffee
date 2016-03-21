class Snake
  move: (asdf)->
    if err
      throw err
    return
  d:
    bad: (err)->
      return
    good: (err)->
      if err
        console.log err
      return

bad 777, (err)->
  # bad
  return

good 777, (err)->
  if err
    console.log err
  return

abc = 1
bad = 666

good 777, (err)->
  if abc or err
    console.log err
  return

good1 777, (err, callback)->
  if err
    return

  good2 777, (err)->
    callback err
    return
  return

bad1 777, (overwritten_err, callback)->
  if bad
    return

  good2 777, (overwritten_err)->
    callback overwritten_err
    return
  return

good 777, (stuff, ..., err, ttt)->
  callback err
  return

badExpansion 777, (stuff, ..., err, ttt)->
  callback ttt
  return