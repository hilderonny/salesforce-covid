public with sharing class CoronaApexController {

    private class Location {
        public Decimal lat;
        public Decimal lng;
    }

    private class CoronaResponse {
        public String provincestate;
        public String countryregion;
        public Location location;
        public Integer confirmed;
        public Integer deaths;
        public Integer recovered;
    }

    public class InfectionStatus {
        // Each property which should be available on the client side must be prefixed with @AuraEnabled
        // See https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/controllers_server_apex_returning_data.htm
        @AuraEnabled public Decimal Confirmed;
        @AuraEnabled public String Country;
        @AuraEnabled public Decimal Deaths;
        @AuraEnabled public Decimal Lat;
        @AuraEnabled public Decimal Lon;
        @AuraEnabled public Decimal Recovered;
    }

    /**
     * Fetch the current statistics from the API
     * and store the data in the custom object.
     */
    @AuraEnabled
    public static void fetch() {
        HttpRequest request = new HttpRequest();
        // https://developer.salesforce.com/forums/?id=906F0000000BIAJIA4
        request.setEndpoint('callout:Corona_API');
        request.setMethod('GET');
        Http http = new Http();
        HttpResponse response = http.send(request);
        String responseText = response.getBody();
        List<CoronaResponse> infections = (List<CoronaResponse>)JSON.deserialize(responseText, List<CoronaResponse>.class);
        List<Infection_status__c> statuses = [SELECT Id, Confirmed__c, Country__c, Deaths__c, Lat__c, Lon__c, Recovered__c FROM Infection_status__c];
        Map<String, Infection_status__c> countryMap = new Map<String, Infection_status__c>();
        for (Infection_status__c status : statuses) {
            countryMap.put(status.Country__c, status);
        }
        for (CoronaResponse infection : infections) {
            Infection_status__c status;
            String countryKey = String.isBlank(infection.provincestate) ? infection.countryregion : infection.provincestate + ' ' + infection.countryregion;
            if (String.isBlank(countryKey)) continue;
            countryKey = countryKey.trim(); // Sometimes there are trailing spaces in Montreal
            if (countryMap.containsKey(countryKey)) {
                status = countryMap.get(countryKey);
            } else {
                status = new Infection_status__c();
                status.Country__c = countryKey;
	            statuses.add(status);
            }
            status.Confirmed__c = infection.confirmed;
            status.Deaths__c = infection.deaths;
            if (infection.location != null) {
                status.Lat__c = infection.location.lat;
                status.Lon__c = infection.location.lng;
            }
            status.Recovered__c = infection.recovered;
        }
        upsert(statuses);
    }
    
    @AuraEnabled
    public static List<InfectionStatus> getInfections() {
        // Mapping is needed because on namespace-orgs the field names from the database have a prefix.
        List<InfectionStatus> infectionsForClient = new List<InfectionStatus>();
        List<Infection_status__c> infectionsFromDatabase = [SELECT Id, Confirmed__c, Country__c, Deaths__c, Lat__c, Lon__c, Recovered__c FROM Infection_status__c];
        for (Infection_status__c infectionFromDatabase : infectionsFromDatabase) {
            InfectionStatus inf = new InfectionStatus();
            inf.Confirmed = infectionFromDatabase.Confirmed__c;
            inf.Country = infectionFromDatabase.Country__c;
            inf.Deaths = infectionFromDatabase.Deaths__c;
            inf.Lat = infectionFromDatabase.Lat__c;
            inf.Lon = infectionFromDatabase.Lon__c;
            inf.Recovered = infectionFromDatabase.Recovered__c;
            infectionsForClient.add(inf);
        }
        return infectionsForClient;
    }

}