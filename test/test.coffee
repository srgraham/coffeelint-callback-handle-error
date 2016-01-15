fs = require 'fs'
expect = require('chai').expect
CoffeeScript = require 'coffee-script'
Rule = require '../index'

getFixtureAST = (fixture)->
  source = fs.readFileSync("#{__dirname}/fixtures/#{fixture}.coffee").toString()
  return CoffeeScript.nodes source

describe 'lint the things', ->


  getErrors = (fixture)=>
    @rule = new Rule()
    @rule.errors = []
    astApi =
      config: use_strict: {}
      createError: (e) -> e
    @rule.lintAST getFixtureAST(fixture), astApi
    @rule.errors.sort (a, b)->
      return a.lineNumber > b.lineNumber
    return

  it 'random tests', =>
    getErrors('basic')
    expect(@rule.errors.length).to.be.equal(3)
    expect(@rule.errors[0].lineNumber).to.be.equal(7)
    expect(@rule.errors[1].lineNumber).to.be.equal(14)
    expect(@rule.errors[2].lineNumber).to.be.equal(40)
    return
  return
