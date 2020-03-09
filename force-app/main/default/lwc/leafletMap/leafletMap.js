import { api, LightningElement } from 'lwc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import leaflet from '@salesforce/resourceUrl/leaflet'

export default class LeafletMap extends LightningElement {

    @api height;
    
    get componentStyle() {
        return `height:${this.height}px;`;
    }
    
    connectedCallback() {

        Promise.all([
            loadStyle(this, leaflet + '/leaflet.css'),
            loadScript(this, leaflet + '/leaflet.js')
        ]).then(() => {
            const el = this.template.querySelector('div');
            const map = L.map(el).setView([52, 0], 2);
            L.tileLayer(
                'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; <a href="http://openstreetmap.org">OpenStreetMap</a> Contributors',
                maxZoom: 18,
            }).addTo(map);
        });
    }
}