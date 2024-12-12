#!/bin/bash

# Apex Test Runner Script
# mohan chinnappan

# Function to display usage information
function usage() {
    echo "Usage: $0 --target-org <target-org>"
    echo "Runs Apex tests on the specified Salesforce org and generates a detailed report."
    exit 1
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --target-org) target_org="$2"; shift ;;
        --help) usage ;;
        *) echo "Unknown parameter: $1"; usage ;;
    esac
    shift
done

# Check if target-org is provided
if [[ -z "$target_org" ]]; then
    echo "Error: --target-org is required."
    usage
fi

# Run Apex tests and get the test run ID
echo "Running Apex tests on org: $target_org"
run_output=$(sf apex run test -o "$target_org")
#run_id=$(echo "$run_output" | grep -oP '707\w+')
run_id=$(echo "$run_output" | grep -Eo '707[[:alnum:]]+')

if [[ -z "$run_id" ]]; then
    echo "Error: Could not retrieve test run ID."
    exit 1
fi

echo "Test run ID: $run_id"

# Fetch the test results in JSON format
echo "Fetching test results..."
json_results=$(sf apex get test -i "$run_id" -o "$target_org" -r json)

echo "$json_results" > results.json 
echo "Test results saved to results.json."


if [[ -z "$json_results" ]]; then
    echo "Error: Failed to fetch test results."
    exit 1
fi

# Parse the JSON results and extract relevant data
report_data=$(echo "$json_results" | jq '.result.tests | map({TestCase: .ApexClass.Name, Pass: (if .Outcome == "Pass" then 1 else 0 end), Fail: (if .Outcome == "Fail" then 1 else 0 end)})')

# Create the data.json file for D3.js
echo "$report_data" > data.json
echo "Summary Test results saved to data.json."

