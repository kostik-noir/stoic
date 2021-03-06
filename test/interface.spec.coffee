async = require 'async'
should = require 'should'
stoic = require '../lib/main'

describe 'schema with interface', ->
  before ->
    stoic.init()

  beforeEach (done) ->
    @schema = require './examples/interface'
    stoic.load @schema
    done()

  it 'should load', (done) ->
    {User} = stoic.models

    User.create {name: 'Jon'}, (err, res) ->
      should.exist res.id

      user = User.get(res.id)
      user.name.get (err, name) ->
        should.exist name
        name.should.eql 'Jon'
        done()

  it "should trigger 'after' callback", (done) ->
    {User} = stoic.models

    User.create {name: 'Jon', email: 'jon@gmail.com'}, (err, user) ->
      user.email.get (err, email) ->
        should.exist email, "Expected email to exist"
        email.should.eql '<div>jon@gmail.com</div>'
        done()
