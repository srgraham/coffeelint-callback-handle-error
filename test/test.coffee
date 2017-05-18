fs = require 'fs'
expect = require('chai').expect
CoffeeScript = require 'coffee-script'
Rule = require '../index'
_ = require 'lodash'

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

  hasErrorAtLine = (line_number)=>
    error_at_line = _.find @rule.errors, (obj)->
      return obj.lineNumber is line_number

    if error_at_line
      return true

    return false

  checkFixtureForHits = (fixture)=>
    fixture_source = fs.readFileSync("#{__dirname}/fixtures/#{fixture}.coffee").toString()
    fixture_nodes = CoffeeScript.nodes fixture_source

    @rule = new Rule()
    @rule.errors = []

    astApi =
      config: use_strict: {}
      createError: (e) -> e

    @rule.lintAST fixture_nodes, astApi

    regex_is_hit = /#\s*(HIT|BAD)\s*$/i
    _.each fixture_source.split('\n'), (line_content, key)=>
      line_number = key + 1
      if regex_is_hit.test line_content
        expectHasErrorAtLine line_number
      else
        expectHasNoErrorAtLine line_number
      return

    return

  expectHasErrorAtLine = (line_number)=>
    has_err = hasErrorAtLine line_number
    expect(has_err, "Could not find HIT at line #{line_number}").to.be.true
    return

  expectHasNoErrorAtLine = (line_number)=>
    has_err = hasErrorAtLine line_number
    expect(has_err, "Found unexpected HIT at line #{line_number}").to.be.false
    return

  it 'basic', =>
    getErrors('basic')
    checkFixtureForHits('basic')
    return

  return
