CodeContext = require '../lib/code-context'
OperatingSystem = require '../lib/grammar-utils/operating-system'
grammarMap = require '../lib/grammars'

describe 'grammarMap', ->
  beforeEach ->
    @codeContext = new CodeContext('test.txt', '/tmp/test.txt', null)
    # TODO: Test using an actual editor or a selection?
    @dummyTextSource = {}
    @dummyTextSource.getText = -> ""

  it "has a command and an args function set for each grammar's mode", ->
    @codeContext.textSource = @dummyTextSource
    for lang,modes of grammarMap
      for mode,commandContext of modes
        expect(commandContext.command).toBeDefined()
        argList = commandContext.args(@codeContext)
        expect(argList).toBeDefined()

  describe 'Operating system specific runners', ->
    beforeEach ->
      @_originalPlatform = OperatingSystem.platform
      @reloadGrammar = ->
        delete require.cache[require.resolve('../lib/grammars.coffee')]
        grammarMap = require '../lib/grammars.coffee'

    afterEach ->
      OperatingSystem.platform = @_originalPlatform
      @reloadGrammar()

    describe 'C', ->
      it 'returns the appropriate File Based runner on Mac OS X', ->
        OperatingSystem.platform = -> 'darwin'
        @reloadGrammar()

        grammar = grammarMap['C']
        fileBasedRunner = grammar['File Based']
        args = fileBasedRunner.args(@codeContext)
        expect(fileBasedRunner.command).toEqual('bash')
        expect(args[0]).toEqual('-c')
        expect(args[1]).toMatch(/^xcrun clang/)

      it 'is not defined on other operating systems', ->
        OperatingSystem.platform = -> 'win32'
        @reloadGrammar()

        grammar = grammarMap['C']
        expect(grammar).toBe(undefined)

    describe 'C++', ->
      it 'returns the appropriate File Based runner on Mac OS X', ->
        OperatingSystem.platform = -> 'darwin'
        @reloadGrammar()

        grammar = grammarMap['C++']
        fileBasedRunner = grammar['File Based']
        args = fileBasedRunner.args(@codeContext)
        expect(fileBasedRunner.command).toEqual('bash')
        expect(args[0]).toEqual('-c')
        expect(args[1]).toMatch(/^xcrun clang\+\+/)

      it 'is not defined on other operating systems', ->
        OperatingSystem.platform = -> 'win32'
        @reloadGrammar()

        grammar = grammarMap['C++']
        expect(grammar).toBe(undefined)

    describe 'Objective-C', ->
      it 'returns the appropriate File Based runner on Mac OS X', ->
        OperatingSystem.platform = -> 'darwin'
        @reloadGrammar()

        grammar = grammarMap['Objective-C']
        fileBasedRunner = grammar['File Based']
        args = fileBasedRunner.args(@codeContext)
        expect(fileBasedRunner.command).toEqual('bash')
        expect(args[0]).toEqual('-c')
        expect(args[1]).toMatch(/^xcrun clang/)

      it 'is not defined on other operating systems', ->
        OperatingSystem.platform = -> 'win32'
        @reloadGrammar()

        grammar = grammarMap['Objective-C']
        expect(grammar).toBe(undefined)

    describe 'Objective-C++', ->
      it 'returns the appropriate File Based runner on Mac OS X', ->
        OperatingSystem.platform = -> 'darwin'
        @reloadGrammar()

        grammar = grammarMap['Objective-C++']
        fileBasedRunner = grammar['File Based']
        args = fileBasedRunner.args(@codeContext)
        expect(fileBasedRunner.command).toEqual('bash')
        expect(args[0]).toEqual('-c')
        expect(args[1]).toMatch(/^xcrun clang\+\+/)

      it 'is not defined on other operating systems', ->
        OperatingSystem.platform = -> 'win32'
        @reloadGrammar()

        grammar = grammarMap['Objective-C++']
        expect(grammar).toBe(undefined)
