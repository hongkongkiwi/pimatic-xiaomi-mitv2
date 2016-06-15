$(document).on( "templateinit", (event) ->

  # define the item class
  class CustomDeviceItem extends pimatic.DeviceItem
    constructor: (data) ->
      super(data)
      # Do something, after create: console.log(this)
    afterRender: (elements) ->
      super(elements)
      # Do something after the html-element was added
    onButtonPress: ->
      $.get("/api/device/#{@deviceId}/actionToCall").fail(ajaxAlertFail)

  # register the item-class
  pimatic.templateClasses['mitv-device'] = CustomDeviceItem
)
