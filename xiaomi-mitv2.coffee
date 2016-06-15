# #Plugin template

# This is an plugin template and mini tutorial for creating pimatic plugins. It will explain the
# basics of how the plugin system works and how a plugin should look like.

# ##The plugin code

# Your plugin must export a single function, that takes one argument and returns a instance of
# your plugin class. The parameter is an envirement object containing all pimatic related functions
# and classes. See the [startup.coffee](http://sweetpi.de/pimatic/docs/startup.html) for details.
module.exports = (env) ->

  # ###require modules included in pimatic
  # To require modules that are included in pimatic use `env.require`. For available packages take
  # a look at the dependencies section in pimatics package.json

  # Require the  bluebird promise library
  Promise = env.require 'bluebird'

  # Require the [cassert library](https://github.com/rhoot/cassert).
  assert = env.require 'cassert'
  MITV = Promise.promisify(require('xiaomi-mitv2-remote'))
  _ = env.require 'underscore'

  # Include you own depencies with nodes global require function:
  #
  #     someThing = require 'someThing'
  #

  # ###MyPlugin class
  # Create a class that extends the Plugin class and implements the following functions:
  class XiaomiMiTV2Plugin extends env.plugins.Plugin

    # ####init()
    # The `init` function is called by the framework to ask your plugin to initialise.
    #
    # #####params:
    #  * `app` is the [express] instance the framework is using.
    #  * `framework` the framework itself
    #  * `config` the properties the user specified as config for your plugin in the `plugins`
    #     section of the config.json file
    #
    #
    init: (app, @framework, @config) =>
      #env.logger.info("Hello World")

      deviceConfigDef = require("./device-config-schema")

      env.logger.info("Hello World")

      @framework.deviceManager.registerDeviceClass("XiaomiDevice", {
        configDef: deviceConfigDef.XiaomiDevice
        createCallback: (config) => new XiaomiDevice(config)
      })

  plugin = new XiaomiMiTV2Plugin

  class XiaomiDevice extends env.devices.Device
    actions:
      powerOn:
        description: "power the TV on"
      powerOff:
        description: "power the TV off"
      changeStateTo:
        description: "changes the power to on or off"
        params:
          powerState:
            type: Boolean
    attributes:
      powerState:
        type: Boolean

    constructor: (@config) ->
      @name = @config.name
      @id = @config.id
      @mitv = new MITV(@config.ip)
      @powerState = off

      super()

    # Returns a promise
    powerOn: -> @changeStateTo on

    # Retuns a promise
    powerOff: -> @changeStateTo off

    changeStateTo: (powerState) ->
      if @powerState is powerState then return
      return mitv.sendPowerButtonAsync().catch( (error) =>
        env.logger.error error.message
        env.logger.debug error.stack
      )

  # For Testing
  plugin.XiaomiDevice = XiaomiDevice

  # and return it to the framework.
  return plugin
