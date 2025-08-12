### gh-er-updates
A Github script which will pull down enhancement requests, then upload them to an Elastic cluster.

## er-updater-setup.sh
Run the `er-updater-setup.sh` which will walk you through the RSA key setup for GitHub SSH access.

## er-updater-CUSTOMER.sh
Change the word `CUSTOMER` within `er-updater-CUSTOMER.sh` script to reflect your customer.
You can accomplish with either the mv (move) or cp (copy/paste) command.

## Add the index template
In DevTools of your cluster, run the gh-er-track-index-template portion.

## Add the ingest pipelein
In DevTools of your cluster, run the gh-er-parser-ingest-pipeline portion.

## er-updater-abc123.sh
With the script now updated, open up and update the values to reflect your cluster:

`ES_URL="https://myclustername.es.my-region.provider.elastic-cloud.com:443"`

`ES_USER="username"`

`ES_PASS="password"`

`CUSTOMER_INDEX="my-customer-title-in-lowercase"`

`CUSTOMER_SEARCH="my-customer-search-term-from-within-brackets"`

`ES_INDEX="er-tracker-$CUSTOMER_INDEX"`


## Make the script executable then run it
`sudo chmod +x er-updater-CUSTOMER.sh`

`./er-updater-CUSTOMER.sh`

## Express yourself with a dashboard
Upload dashboard and associated saved objects from er-updater.ndjson
