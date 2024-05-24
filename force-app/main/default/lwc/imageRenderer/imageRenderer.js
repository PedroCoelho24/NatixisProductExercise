import { LightningElement, api } from 'lwc';

export default class ImageRenderer extends LightningElement {
    @api value;
    @api altText;
    @api width;
    @api height;
}