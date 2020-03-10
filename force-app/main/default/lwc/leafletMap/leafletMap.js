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
                if (!infection.HaeR__Confirmed__c || infection.HaeR__Confirmed__c < 1 || !infection.HaeR__Lat__c || !infection.HaeR__Lon__c) return;
                var radius = infection.HaeR__Confirmed__c > 10000 ? 10000 : infection.HaeR__Confirmed__c;
                var circle = L.circle([infection.HaeR__Lat__c, infection.HaeR__Lon__c], {color: 'red', fillColor: '#f03', fillOpacity: 0.5, radius: radius * 100});
                circle.bindPopup('<b>' + infection.HaeR__Country__c + '</b><br/><i>Confirmd</i>:' + infection.HaeR__Confirmed__c + '<br/><i>Deaths</i>:' + infection.HaeR__Deaths__c + '<br/><i>Recovered</i>:' + infection.HaeR__Recovered__c);
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