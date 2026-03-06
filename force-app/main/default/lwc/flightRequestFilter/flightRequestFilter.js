import { api, LightningElement } from "lwc";

/**
 * @typedef {object} value filter values
 * @property {number} price maximum price filter
 * @property {number} discountPercentage minimum discount percentage filter
 */

export default class FlightRequestFilter extends LightningElement {
  /**
   * Indicate whether the component is in readonly state
   * @type {boolean}
   */
  @api readOnly;

  /**
   * Component value(s) in the form of an object that holds all inputs.
   * @type {value}
   */
  @api
  get value() {
    return {
      price: this.price,
      discountPercentage: this.discountPercentage
    };
  }
  set value(value) {
    this.price = value?.price || 20000;
    this.discountPercentage = value?.discountPercentage || 0;
  }

  price;
  discountPercentage;

  handleInputChange(event) {
    // Update component properties
    this[event.target.name] = event.detail.value;
    // Notify parent component of the update
    this.dispatchEvent(
      new CustomEvent("valuechange", {
        detail: {
          value: this.value
        }
      })
    );
  }
}