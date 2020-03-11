import { api, LightningElement } from 'lwc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import getInfections from '@salesforce/apex/CoronaApexController.getInfections';
import fetch from '@salesforce/apex/CoronaApexController.fetch';
import leaflet from '@salesforce/resourceUrl/leaflet';

export default class LeafletMap extends LightningElement {

    @api height;
    map;
    
    get componentStyle() {
        return `height:${this.height}px;`;
    }

    handleFetchClick() {
        fetch().then(() => {
            this.loadData();
        });
    }

    loadData() {
        getInfections().then((infections) => {
            infections.forEach((infection) => {
                if (!infection.Confirmed || infection.Confirmed < 1 || !infection.Lat || !infection.Lon) return;
                var radius = infection.Confirmed > 10000 ? 10000 : infection.Confirmed;
                var circle = L.circle([infection.Lat, infection.Lon], {color: 'red', fillColor: '#f03', fillOpacity: 0.5, radius: radius * 100});
                circle.bindPopup('<b>' + infection.Country + '</b><br/><i>Confirmd</i>:' + infection.Confirmed + '<br/><i>Deaths</i>:' + infection.Deaths + '<br/><i>Recovered</i>:' + infection.Recovered);
                circle.addTo(this.map);
            });
        });
    }
    
    connectedCallback() {

        Promise.all([
            loadStyle(this, leaflet + '/leaflet.css'),
            loadScript(this, leaflet + '/leaflet.js')
        ]).then(() => {
            const el = this.template.querySelector('.map');
            this.map = L.map(el).setView([52, 0], 2);
            L.tileLayer(
                'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; <a href="http://openstreetmap.org">OpenStreetMap</a> Contributors',
                maxZoom: 18,
            }).addTo(this.map);
            this.loadData();
        });
    }
}