class Snake
  move: (asdf)->
    if err
      throw err
    return
  d:
    bad: (err)-> # HIT
      return
    good: (err)->
      if err
        console.log err
      return

bad 777, (err)-> # HIT
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

bad1 777, (overwritten_err, callback)-> # HIT
  if bad
    return

  good2 777, (overwritten_err)->
    callback overwritten_err
    return
  return

good 777, (stuff, ..., err, ttt)->
  callback err
  return

badExpansion 777, (stuff, ..., err, ttt)-> # HIT
  callback ttt
  return
