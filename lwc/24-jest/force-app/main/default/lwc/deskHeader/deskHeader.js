import { LightningElement } from 'lwc';
import LOGO from '@salesforce/resourceUrl/sharmaTradersLogo';
import DESK_TITLE from '@salesforce/label/c.Desk_Title';
import DESK_SUBTITLE from '@salesforce/label/c.Desk_Subtitle';

export default class DeskHeader extends LightningElement {
    logoUrl = LOGO;
    label = {
        title: DESK_TITLE,
        subtitle: DESK_SUBTITLE
    };
}
