global with sharing class ImportJob implements Schedulable {
    global void execute(SchedulableContext SC) {
        CoronaApexController.fetch();
    }
}