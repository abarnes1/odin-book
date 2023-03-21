import consumer from "channels/consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    let counter_container = document.getElementById('notifications_count');
    let notification_count = parseInt(counter_container.textContent)
    counter_container.textContent = ` ${notification_count + parseInt(data["count"])} `;
  }
});
