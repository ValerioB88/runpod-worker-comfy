We are builidng and pushing the container onto Google Cloud. To do that we use the cloudbuild.yml conf file. Notice we tag the container there! 
Just run in this folder with ANACONDA (you need python) 

gcloud builds submit --config=cloudbuild.yaml .