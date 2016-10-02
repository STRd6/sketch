ace.require("ace/ext/language_tools")

aceEditor = ace.edit "ace"
aceEditor.$blockScrolling = Infinity
aceEditor.setOptions
  fontSize: "16px"
  enableBasicAutocompletion: true
  enableLiveAutocompletion: true

module.exports = ->
  aceEditor: ->
    aceEditor

  initSession: (content, mode) ->
    session = ace.createEditSession(content)

    session.setMode("ace/mode/#{mode}")

    session.setUseSoftTabs true
    session.setTabSize 2

    aceEditor.setOptions
      highlightActiveLine: true

    return session
