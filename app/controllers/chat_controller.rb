class ChatController < ApplicationController
  def index; end

  def handle
    chat_info = params[:chat_info]

    head 400 unless chat_info

    channel_name = 'meetings-6'
    options = sanitise_input(chat_info)

    activity = Activity.new('chat-message', options['text'], options)

    data = activity.getMessage
    response = Pusher[channel_name].trigger('chat_message', data)

    result = { 'activity' => data, 'pusherResponse' => response }

    headers['Cache-Control'] = 'no-cache, must-revalidate'
    headers['Content-Type'] = 'application/json'
    render json: result.to_json
  end

  def get_channel_name(http_referer)
    pattern = /(\W)+/
    http_referer.gsub pattern, '-'
  end

  def sanitise_input(chat_info)
    email = chat_info['email'] ? chat_info['email'] : ''

    options = {}
    options['displayName'] = chat_info['nickname'].html_safe.slice(0, 30)
    options['text'] = chat_info['text'].html_safe.slice(0, 300)
    options['email'] = email.html_safe.slice(0, 100)
    options['get_gravatar'] = true

    options
  end
end
