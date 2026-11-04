import { createElement } from '@lwc/engine-dom';
import ContactTile from 'c/contactTile';

const CONTACT = { Id: '1', Name: 'Ravi Verma', Title: 'Owner' };

describe('c-contact-tile', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('shows the name and title it is given', () => {
        const element = createElement('c-contact-tile', { is: ContactTile });
        element.contact = CONTACT;
        document.body.appendChild(element);

        const [name, title] = element.shadowRoot.querySelectorAll('p');
        expect(name.textContent).toBe('Ravi Verma');
        expect(title.textContent).toBe('Owner');
        expect(element.shadowRoot.querySelector('.initials').textContent).toBe('RV');
    });

    it('sends a select event with the contact Id when clicked', () => {
        const element = createElement('c-contact-tile', { is: ContactTile });
        element.contact = CONTACT;
        document.body.appendChild(element);
        const handler = jest.fn();
        element.addEventListener('select', handler);

        element.shadowRoot.querySelector('.tile').click();

        expect(handler).toHaveBeenCalledTimes(1);
        expect(handler.mock.calls[0][0].detail).toBe('1');
        expect(handler.mock.calls[0][0].bubbles).toBe(true);
    });
});
