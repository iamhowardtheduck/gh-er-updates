#!/bin/bash

# Define Elasticsearch Credentials & customer details
ES_URL="https://myclustername.es.my-region.provider.elastic-cloud.com:443"
ES_USER="username"
ES_PASS="password"
CUSTOMER_INDEX="my-customer-title-in-lowercase"
CUSTOMER_SEARCH="my-customer-search-term-from-within-brackets"
ES_INDEX="er-tracker-$CUSTOMER_INDEX"

# Fetch GitHub issues and format as JSON
echo "Fetching GitHub issues..."
gh issue list --limit 200 --repo elastic/enhancements --search "is:issue sort:created-asc in:title [$CUSTOMER_SEARCH]" -s all \
--json number,createdAt,state,title,body,updatedAt \
--jq 'map({
          "_id": (.number | tostring),
          "doc": {
              "Number": (.number | tostring),
              "Status": .state,
              "CreatedAt": .createdAt,
              "UpdatedAt": .updatedAt,
              "Title": .title,
              "Body": .body
          },
          "doc_as_upsert": true
      })' > gh_$CUSTOMER_INDEX_issues.json

echo "GitHub issues saved to gh_$CUSTOMER_INDEX_issues.json"

# Convert JSON to Bulk Format
echo "Formatting JSON for bulk update..."
jq -c '.[] | {"update": {"_index": "'"$ES_INDEX"'", "_id": ._id}}, {"doc": .doc, "doc_as_upsert": true}' gh_$CUSTOMER_INDEX_issues.json > gh_$CUSTOMER_INDEX_issues_bulk.json

echo "Bulk JSON file created: gh_$CUSTOMER_INDEX_issues_bulk.json"

# Upload Data to Elasticsearch
echo "Uploading data to Elasticsearch..."
curl -X POST "$ES_URL/_bulk" -u "$ES_USER:$ES_PASS" -H "Content-Type: application/json" --data-binary "@gh_$CUSTOMER_INDEX_issues_bulk.json"

echo "Data upload completed!"
