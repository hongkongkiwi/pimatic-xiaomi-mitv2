class PowerActionHandler extends env.actions.ActionHandler

  constructor: (@framework) ->

  executeAction: (simulate) =>
    if simulate
      return Promise.resolve(__("would log 42"))
    else
      env.logger.info "42"
      return Promise.resolve(__("logged 42"))

class PowerActionProvider extends env.actions.ActionProvider

  constructor: (@framework) ->
  # ### executeAction()
  ###
  This function handles action in the form of `execute "some string"`
  ###
  parseAction: (input, context) =>
    retVal = null
    commandTokens = null
    fullMatch = no

    setCommand = (m, tokens) => commandTokens = tokens
    onEnd = => fullMatch = yes

    m = M(input, context)
      .match("execute ")
      .matchStringWithVars(setCommand)

    if m.hadMatch()
      match = m.getFullMatch()
      return {
        token: match
        nextInput: input.substring(match.length)
        actionHandler: new ShellActionHandler(@framework, commandTokens)
      }
    else
      return null
