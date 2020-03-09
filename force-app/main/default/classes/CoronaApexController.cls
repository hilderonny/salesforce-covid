public with sharing class CoronaApexController {

    private class CoronaResponse {
        public String country;
        public Integer cases;
        public Integer todayCases;
        public Integer deaths;
        public Integer todayDeaths;
        public Integer recovered;
        public Integer critical;
    }

    /**
     * Fetch the current statistics from the API
     * and store the data in the custom object.
     */
    public static void fetch() {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Corona_API');
        request.setMethod('GET');
        Http http = new Http();
        HttpResponse response = http.send(request);
        String responseText = response.getBody();
        List<CoronaResponse> infections = (List<CoronaResponse>)JSON.deserialize(responseText, List<CoronaResponse>.class);
        List<Infection_status__c> statuses = [SELECT Id, Country__c, Cases__c, Cases_today__c, Critical__c, Deaths__c, Deaths_today__c, Recovered__c FROM Infection_status__c];
        Map<String, Infection_status__c> countryMap = new Map<String, Infection_status__c>();
        for (Infection_status__c status : statuses) {
            countryMap.put(status.Country__c, status);
        }
        for (CoronaResponse infection : infections) {
            Infection_status__c status;
            if (countryMap.containsKey(infection.country)) {
                status = countryMap.get(infection.country);
            } else {
                status = new Infection_status__c();
                status.Country__c = infection.country;
	            statuses.add(status);
            }
            status.Cases__c = infection.cases;
            status.Cases_today__c = infection.todayCases;
            status.Critical__c = infection.critical;
            status.Deaths__c = infection.deaths;
            status.Deaths_today__c = infection.todayDeaths;
            status.Recovered__c = infection.recovered;
        }
        upsert(statuses);
    }
}