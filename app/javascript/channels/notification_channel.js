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
    let counterElement = document.getElementById('notifications_count');
    let currentNotificationCount = parseInt(counterElement.textContent)
    let newNotificationCount = parseInt(data["total"]);

    if (data["count"]) {
      newNotificationCount = currentNotificationCount + parseInt(data["count"]);
    };

    counterElement.textContent = ` ${newNotificationCount} `;
    
    if (newNotificationCount > 0 ) {
      counterElement.parentElement.classList.remove('is-hidden');
    } else {
      counterElement.parentElement.classList.add('is-hidden');
    }
  },
});
