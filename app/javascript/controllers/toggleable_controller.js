import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = [ 'change' ] 
  static targets = [ 'toggle']

  toggle() {
    this.toggleTargets.forEach( element => {
      element.classList.toggle(this.changeClass);
    })
  }
}
