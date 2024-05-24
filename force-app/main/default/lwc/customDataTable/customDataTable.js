import LightningDatatable from 'lightning/datatable';
import customImage from './customImage.html';

export default class CustomDataTable extends LightningDatatable {
    static customTypes = {
        customImage: {
            template: customImage,
            standardCellLayout: true,
            typeAttributes: ['altText', 'width', 'height']
        }
    };
}