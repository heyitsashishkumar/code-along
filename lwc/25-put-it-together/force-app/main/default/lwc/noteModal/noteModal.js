import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class NoteModal extends LightningModal {
    @api customerName;
    note = '';

    get heading() {
        return `Add a note about ${this.customerName}`;
    }

    handleNoteChange(event) {
        this.note = event.target.value;
    }

    handleSave() {
        this.close(this.note);
    }

    handleCancel() {
        this.close();
    }
}
