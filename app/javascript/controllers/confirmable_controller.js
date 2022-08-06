import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    message: String 
  }

  connect() {
  }

  confirm(event) {
    if(confirm(this.messageValue) === false)
    {
      event.preventDefault()
      event.stopImmediatePropagation()
    }
  }
}
