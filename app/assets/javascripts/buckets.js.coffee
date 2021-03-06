App.buckets ||= {}

App.buckets['show'] = ->
  tipsyConfig = title: 'Copy to Clipboard', copiedHint: 'Copied!'

  $copyButton = $('#copy-button')
  $copyButton.tipsy(gravity: $.fn.tipsy.autoNS)
  $copyButton.attr('title', tipsyConfig.title)

  clipboard = new Clipboard('#copy-button')
  clipboard.on 'success', ->
    $copyButton.prop('title', tipsyConfig.copiedHint).tipsy('show')
    $copyButton.attr('original-title', tipsyConfig.title)

  emailCountPoller()

  favicon = new Favico(bgColor: '#6C92C8', animation: 'none')
  favicon.badge $('#putsbox-token-input').data('bucket-emails-count')

  $('body').on 'new-email', (e, data) -> favicon.badge data.emailsCount


emailCountPoller = ->
  bucket = $('#putsbox-token-input').data('bucket-token')

  pusher = new Pusher($('body').data('pusher-key'), { cluster: $('body').data('pusher-cluster'), encrypted: true })

  channel = pusher.subscribe("channel_emails_#{bucket}")

  channel.bind('update_count', (data) -> $('body').trigger('new-email', email: data.email, emailsCount: data.emails_count))
