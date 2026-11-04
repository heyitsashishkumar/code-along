import { createElement } from '@lwc/engine-dom';
import CustomerDeals from 'c/customerDeals';
import getDeals from '@salesforce/apex/DealController.getDeals';
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { subscribe } from 'lightning/messageService';

jest.mock(
    '@salesforce/apex/DealController.getDeals',
    () => {
        const { createApexTestWireAdapter } = require('@salesforce/sfdx-lwc-jest');
        return { default: createApexTestWireAdapter(jest.fn()) };
    },
    { virtual: true }
);
jest.mock('lightning/uiRecordApi', () => ({ updateRecord: jest.fn() }), { virtual: true });
jest.mock('@salesforce/apex', () => ({ refreshApex: jest.fn(() => Promise.resolve()) }), { virtual: true });

const DEALS = [
    { Id: '006A', Name: 'Packing material, yearly', StageName: 'Closed Won', Amount: 95000, CloseDate: '2026-08-20' },
    { Id: '006B', Name: 'Warehouse racks', StageName: 'Negotiation/Review', Amount: 180000, CloseDate: '2026-12-15' }
];

// Lets the component's awaited calls finish.
const flush = async () => {
    for (let i = 0; i < 20; i++) {
        // eslint-disable-next-line no-await-in-loop
        await Promise.resolve();
    }
};

describe('c-customer-deals', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    async function showDeals() {
        const element = createElement('c-customer-deals', { is: CustomerDeals });
        element.recordId = '001A';
        document.body.appendChild(element);
        getDeals.emit(DEALS);
        await Promise.resolve();
        return element;
    }

    it('asks Apex for the deals of its account', async () => {
        await showDeals();
        expect(getDeals.getLastConfig()).toEqual({ accountId: '001A' });
    });

    it('shows the deals in a table with Amount and Close date editable', async () => {
        const element = await showDeals();
        const table = element.shadowRoot.querySelector('lightning-datatable');

        expect(table.data).toEqual(DEALS);
        const editable = table.columns.filter((column) => column.editable).map((column) => column.fieldName);
        expect(editable).toEqual(['Amount', 'CloseDate']);
    });

    it('saves the edited rows, says so, and reloads the deals', async () => {
        updateRecord.mockResolvedValue({});
        const element = await showDeals();
        const toast = jest.fn();
        element.addEventListener('lightning__showtoast', toast);

        const table = element.shadowRoot.querySelector('lightning-datatable');
        table.dispatchEvent(
            new CustomEvent('save', { detail: { draftValues: [{ Id: '006B', Amount: '200000' }] } })
        );
        await flush();

        expect(updateRecord).toHaveBeenCalledWith({ fields: { Id: '006B', Amount: '200000' } });
        expect(toast.mock.calls[0][0].detail.title).toBe('Deals saved');
        expect(refreshApex).toHaveBeenCalledTimes(1);
        expect(table.draftValues).toEqual([]);
    });

    it('shows the error when a save fails', async () => {
        updateRecord.mockRejectedValue({ body: { message: 'Amount too large' } });
        const element = await showDeals();

        element.shadowRoot
            .querySelector('lightning-datatable')
            .dispatchEvent(new CustomEvent('save', { detail: { draftValues: [{ Id: '006B', Amount: '1' }] } }));
        await flush();

        expect(element.shadowRoot.querySelector('c-error-panel').errors).toEqual({ body: { message: 'Amount too large' } });
    });

    it('on the desk, shows the deals of the customer picked elsewhere', async () => {
        const element = createElement('c-customer-deals', { is: CustomerDeals });
        document.body.appendChild(element);
        await Promise.resolve();
        expect(element.shadowRoot.querySelector('.hint')).not.toBeNull();

        subscribe.mock.calls[0][2]({ contactId: '003A', accountId: '001Z' });
        await Promise.resolve();
        expect(getDeals.getLastConfig()).toEqual({ accountId: '001Z' });
    });
});
