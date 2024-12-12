# Script to run the Apex Classes in a given org


## Login
- Make sure that you have logged into this org and note down the username


```
## Sandbox
sf force auth web login -r https://test.salesforce.com 

## PROD
sf force auth web login -r https://test.salesforce.com 
`
```

## Run the test classes
```
bash run_apex_test.sh --target-org mohan.chinnappan.n.ea10@gmail.com 

```

##  Open the Test Results reports app and load the results.json file we got from the above step

open https://mohan-chinnappan-n5.github.io/apex/apex-test-results.html


<video src="apexTestClasses.web" width="600" controls>
    Your browser does not support the video tag.
</video>
