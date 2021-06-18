
# USERNAME=""
# PASSWORD=""
# TENANT=""
SUBSCRIPTION_ID=""
RESOURCE_GROUP="aks-demo"
LOCATION="eastus"
CLUSTER_NAME="aks-demo-cluster"
NODE_COUNT="1"

# Auth with ASP interactive
az login

# Auth with ASP
az login --service-principal -u $USERNAME -p $PASSWORD --tenant $TENANT

# Select Subscription
az account set -s $SUBSCRIPTION_ID

# Creating Resource Group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Registering Monitoring Services
az provider register --namespace Microsoft.OperationsManagement
az provider register --namespace Microsoft.OperationalInsights

# Deploy AKS Cluster
az aks create --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --node-count $NODE_COUNT --enable-addons monitoring --generate-ssh-keys

# Create Demo App Namespace
kubectl create ns demo-app-ns

# Deploy Demo Application
kubectl apply -f ./demo-app.yaml -n demo-app-ns

# Get Kubeconfig from AKS Cluster
az aks get-credentials --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME

# Clean up resources
az group delete --name $RESOURCE_GROUP --yes --no-wait