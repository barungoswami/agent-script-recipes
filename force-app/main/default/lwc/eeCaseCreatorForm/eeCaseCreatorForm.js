import { LightningElement,api } from 'lwc';

export default class EeCaseCreatorForm extends LightningElement {
    @api accountId;
    @api subject;
    @api description;

    handleSubjectChange(event) {
        this.subject = event.target.value;
        this.dispatchValueChangeEvent();
    }

    handleDescriptionChange(event) {
        this.description = event.target.value;
        this.dispatchValueChangeEvent();
    }

    handleFacilityNameChange(event) {
        this.accountId = event.target.value;
        this.dispatchValueChangeEvent();
    }

    // Essential function to notify the Agentforce runtime of value changes
    dispatchValueChangeEvent() {
        const detail = {
            accountId: this.accountId,
            subject: this.subject,
            description: this.description
        };
        const valueChangeEvent = new CustomEvent('valuechange', {
            detail: detail,
            bubbles: true,
            composed: true
        });
        this.dispatchEvent(valueChangeEvent);
    }
}