---
title: "Kubernetes Inventory"
linkTitle: "Kubernetes Inventory"
weight: 1
---
Anchore Enterprise allows you to navigate through your Kubernetes clusters to quickly and easy asses your vulnerabilites, apply policies, and take action on them. You'll need to configure your clusters for collection before being able to take advanatage of these features. See our [installation instructions to get setup](/docs/overview/concepts/images/inventory/).

### Watching Clusters and Namespaces
Users can opt to automatically scan all the images that are deployed to a specific cluster or namespace. This is helpful to monitor
your overall security posture in your runtime and enforce policies. Before opting to subscribe to a new cluster it's important to ensure you have proper credentials saved in Anchore to pull the images from the registry. Also watching a new cluster can create a considerable queue of images to work through and impact other users of your Anchore Enterprise deployment.

### Using Charts Filters
The charts at the top of the UI provide key contextual information about your runtime. Upon landing on the page you'll see a summary of your policy evaluations and vulnerabilities for all your clusters. Drilling down into a cluster or namespace will update these charts to represent the data for the selected cluster and/or namespace. Additionally users can select to only view clusters or namespaces with the selected filters. For example selecting only high and critical vulnerabilities will only show the clusters and/or namespaces that have those vulnerabilities.

### Using Views
In addition to navigating your runtime inventory by clusters and namespaces, users can opt to view the images or vulnerabilties across. This is a great way to identify vulnerabilities across your runtime and asses thier impact.

### Assesing impact
Another important aspect of the Kubernetes Inventory UI is the ability to asses how a vulnerability in a container images impacts your environment. For every container when you see a note about it usage being seen in particular cluster and X more... you will be able to mouse over the link for a detailed list of where else that container image is being used. This is quick way to determine the "bast-radius" of a vulnerabilty. 

## Data Delays
Due to the processing required to generate the data used by the Kubernetes Inventory UI, the results displayed may not be fully up to date. The ovreall delay depends on the configuration of how often inventory data is collected, and how frequently your reporting data is refreshed. This is similar to delays present on the dashboard. 

## Policy and Account Considerations 
The Kubernetes Inventory is only availale for an Account's default policy. You may want to consider setting up an account specifically for tracking your Kubernetes Inventory and enforcing a policy. 