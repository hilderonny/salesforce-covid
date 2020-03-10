# Salesforce Corona tracker

## Objective

This project shows up the current COVID-19 world status as a heatmap.
For this purpose the project imports the catual corona statistics every hour from an external API.

The project contains an app for displaying a world map, a custom object for storing the data and default list and page layouts for the custom object. It also defines a CRON job which runs hourly for importing.

For progress statistics the field history tracking feature of salesforce is used.

## Audience

This project is meantioned for every organization which has international relations and want to have actual data about the COVID-19 virus status of the countries of its business relationships.

## Technologies

As map resource [Leaflet.js](https://leafletjs.com/) is used. For the implementation I followed [this article](https://www.forcetalks.com/blog/introduction-of-leaflet-map-in-salesforce-lightning-component/) and [these hints](https://salesforce.stackexchange.com/a/254218) and [this doc](https://developer.salesforce.com/docs/component-library/bundle/lightning-platform-resource-loader/documentation).

## Installation

After package installation a named credential must be created.

* Named credential name: Corona_API
* URL: https://wuhan-coronavirus-api.laeyoung.endpoint.ainize.ai/jhu-edu/latest
* Identity Type: Anonymous
* Authentication Protocol: No Authentication

|Version|URL|
|---|---|
|ver 0.1|https://login.salesforce.com/packaging/installPackage.apexp?p0=04t3X000002tt8fQAA|
|ver 0.2|https://login.salesforce.com/packaging/installPackage.apexp?p0=04t3X000002tu8gQAA|
|ver 0.4|https://login.salesforce.com/packaging/installPackage.apexp?p0=04t3X000002tuPlQAI|
|ver 0.5|https://login.salesforce.com/packaging/installPackage.apexp?p0=04t3X000002tuohQAA|
