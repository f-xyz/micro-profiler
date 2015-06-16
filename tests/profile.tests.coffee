{ profile } = require('../index')
sinon = require('sinon')

describe 'profile()', () ->

  dateNow = Date.now

  beforeEach () ->
    dateNowCalledCount = 0
    Date.now = () -> 1000*dateNowCalledCount++

  afterEach () ->
    Date.now = dateNow

  it 'is a function', () ->
    profile.should.be.a('function')

  it 'throws if test function is not provided', () ->
    fnThatThrows = () -> profile()
    fnThatThrows.should.throw('No function to profile!')

  it 'calls provided function at least once', () ->
    spy = sinon.spy();
    profile(spy, { operations: 0, duration: 0 })
    spy.called.should.be.true

  it 'returns average execution time', () ->
    result = profile(() ->)
    result.time.should.eq(1000)

  it 'returns operations per second', () ->
    result = profile(() ->)
    result.ops.should.eq(1)

  it 'returns last result', () ->
    result = profile(() -> 123)
    result.lastResult.should.eq(123)

  it 'respects maxOperations option', () ->
    spy = sinon.spy();
    profile(spy, { maxOperations: 20, duration: Infinity})
    spy.callCount.should.eq(20)

  it 'respects duration option', () ->
    spy = sinon.spy();
    profile(spy, { maxOperations: Infinity, duration: 20e3})
    spy.callCount.should.eq(20)
