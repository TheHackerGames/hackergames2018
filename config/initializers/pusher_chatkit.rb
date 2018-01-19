CHATKIT = Chatkit::Client.new(
  instance_locator: "v1:us1:7c755ba5-78ac-49c2-96e6-a2b1c08e723c",
  key: "59e302ee-472c-4e82-8a09-f3ab2a6e5252:PwVwjB3Wpg177+/1npKJ5YejV3zsXcHmnb14HFzazS0=",
)

module Chatkit
  class Client
    def create_room(user_id, name, user_ids)
      body = { name: name, user_ids: user_ids }

      @api_instance.request(
        method: "POST",
        path: "/rooms",
        headers: {
          "Content-Type": "application/json",
        },
        body: body,
        jwt: generate_su_token(user_id: user_id)
      )
    end

    # def get_room(user_id, room_id)
    #   @api_instance.request(
    #     method: "GET",
    #     path: "/rooms/#{room_id}",
    #     jwt: generate_su_token(user_id: user_id)
    #   )
    # end

    # def post_message(user_id, room_id, text)
    #   body = { text: text }

    #   @api_instance.request(
    #     method: "POST",
    #     path: "/rooms/#{room_id}/messages",
    #     headers: {
    #       "Content-Type": "application/json",
    #     },
    #     body: body,
    #     jwt: generate_su_token(user_id: user_id)
    #   )
    # end
  end
end
