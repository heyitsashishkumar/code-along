import { createElement } from '@lwc/engine-dom';
import ContactSearch from 'c/contactSearch';
import findContacts from '@salesforce/apex/ContactController.findContacts';
import { publish } from 'lightning/messageService';
import CUSTOMER_SELECTED from '@salesforce/messageChannel/Customer_Selected__c';

jest.mock(
    '@salesforce/apex/ContactController.findContacts',
    () => {
        const { createApexTestWireAdapter } = require('@salesforce/sfdx-lwc-jest');
        return { default: createApexTestWireAdapter(jest.fn()) };
    },
    { virtual: true }
);

const CONTACTS = [
    { Id: '1', Name: 'Ravi Verma', Title: 'Owner', Phone: '+91 90000 00109', AccountId: '001A' },
    { Id: '2', Name: 'Rakesh Gupta', Title: 'Owner', Phone: '+91 90000 00111', AccountId: '001B' }
];

describe('c-contact-search', () => {
    beforeEach(() => {
        jest.useFakeTimers();
    });

    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.useRealTimers();
    });

    function search(element, text) {
        const input = element.shadowRoot.querySelector('lightning-input');
        input.value = text;
        input.dispatchEvent(new CustomEvent('change'));
    }

    it('asks Apex for everyone before anything is typed', async () => {
        const element = createElement('c-contact-search', { is: ContactSearch });
        document.body.appendChild(element);
        await Promise.resolve();

        expect(findContacts.getLastConfig()).toEqual({ searchKey: '' });
    });

    it('asks Apex again 300 ms after typing stops, once', async () => {
        const element = createElement('c-contact-search', { is: ContactSearch });
        document.body.appendChild(element);

        search(element, 'r');
        jest.advanceTimersByTime(100);
        search(element, 'ra');
        jest.advanceTimersByTime(299);
        await Promise.resolve();
        expect(findContacts.getLastConfig()).toEqual({ searchKey: '' });

        jest.advanceTimersByTime(1);
        await Promise.resolve();
        expect(findContacts.getLastConfig()).toEqual({ searchKey: 'ra' });
    });

    it('shows a tile per contact Apex returns, and the one picked', async () => {
        const element = createElement('c-contact-search', { is: ContactSearch });
        document.body.appendChild(element);
        findContacts.emit(CONTACTS);
        await Promise.resolve();

        const tiles = element.shadowRoot.querySelectorAll('c-contact-tile');
        expect(tiles).toHaveLength(2);

        tiles[1].dispatchEvent(new CustomEvent('select', { detail: '2', bubbles: true }));
        await Promise.resolve();
        expect(element.shadowRoot.querySelector('.selected').textContent).toBe(
            'Selected: Rakesh Gupta, +91 90000 00111'
        );
        expect(publish).toHaveBeenCalledWith(undefined, CUSTOMER_SELECTED, {
            contactId: '2',
            accountId: '001B'
        });
    });

    it('shows the error when Apex fails', async () => {
        const element = createElement('c-contact-search', { is: ContactSearch });
        document.body.appendChild(element);

        findContacts.error({ message: 'No access' });
        await Promise.resolve();

        expect(element.shadowRoot.querySelector('c-error-panel').errors).toBeTruthy();
    });
});
