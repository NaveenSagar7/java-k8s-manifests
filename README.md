# ArgoCD Setup Guide for Manifest Repository

This document explains how to configure ArgoCD to deploy Kubernetes
manifests from a Git repository.

The repository typically contains Kubernetes manifests such as:

-   deployment.yaml
-   service.yaml

ArgoCD continuously watches this repository and synchronizes the
Kubernetes cluster whenever changes occur.

------------------------------------------------------------------------

# 1. Prerequisites

Before configuring ArgoCD ensure the following components are available:

-   Kubernetes Cluster (Minikube / Kind / EKS / AKS / GKE)
-   kubectl installed
-   ArgoCD installed in the cluster
-   GitHub repository containing Kubernetes manifests

Example manifest repository:

java-k8s-manifests

Repository structure:

k8s/ deployment.yaml service.yaml

------------------------------------------------------------------------

# 2. Access ArgoCD UI

After installing ArgoCD, expose the service and access the UI.

Example:

kubectl port-forward svc/argocd-server -n argocd 8080:443

Then open:

https://localhost:8080

Login using the admin credentials generated during installation.

------------------------------------------------------------------------

# 3. Add GitHub Repository to ArgoCD

1.  Open the ArgoCD UI
2.  Navigate to **Settings**
3.  Click **Repositories**
4.  Click **Connect Repo**

Fill in the repository details:

Repository Type: Git

Repo URL: https://github.com/username/java-k8s-manifests.git

Authentication options:

Public repository: No authentication required

Private repository: Provide either

-   GitHub Personal Access Token
-   SSH Key

Click **Connect**.

ArgoCD will now have access to your manifest repository.

------------------------------------------------------------------------

# 4. Create a New Application in ArgoCD

Next create an ArgoCD application which defines how the repository maps
to Kubernetes.

Steps:

1.  Open **Applications** in ArgoCD UI
2.  Click **New App**

Fill in the application details.

Application Name:

java-demo

Project:

default

Sync Policy:

Manual (or Automatic depending on preference)

------------------------------------------------------------------------

# 5. Configure Source Repository

Under the **Source** section provide:

Repository URL:

https://github.com/username/java-k8s-manifests.git

Revision:

main

Path:

k8s

This tells ArgoCD where the Kubernetes manifests exist in the
repository.

------------------------------------------------------------------------

# 6. Configure Destination Kubernetes Cluster

Under the **Destination** section provide:

Cluster URL:

https://kubernetes.default.svc

Namespace:

default

This tells ArgoCD where the application should be deployed.

------------------------------------------------------------------------

# 7. Create the Application

Click **Create**.

ArgoCD will now register the application but it will initially appear
as:

OutOfSync

This means the cluster state and Git state are not yet synchronized.

------------------------------------------------------------------------

# 8. Sync Git Repository with Kubernetes

To deploy the application:

1.  Open the created application
2.  Click **Sync**
3.  Review the manifest changes
4.  Click **Synchronize**

ArgoCD will now apply the manifests to Kubernetes.

Internally ArgoCD runs commands similar to:

kubectl apply -f deployment.yaml kubectl apply -f service.yaml

------------------------------------------------------------------------

# 9. Verify Deployment

After syncing, the application status should show:

Synced Healthy

You can also verify using kubectl:

kubectl get pods

kubectl get services

------------------------------------------------------------------------

# 10. Automatic Sync (Optional)

To enable automatic deployment when Git changes:

1.  Open the application
2.  Click **Edit**
3.  Enable:

Auto-Sync

Options:

Prune: removes resources deleted from Git

Self Heal: restores resources if manually modified

With Auto-Sync enabled:

Any commit to the manifest repository will automatically trigger a
deployment.

------------------------------------------------------------------------

# 11. GitOps Deployment Flow

Developer updates image tag in manifest repository:

image: dockerhub-user/java-demo:v25

GitHub repository is updated.

ArgoCD detects the commit.

ArgoCD synchronizes the cluster.

Kubernetes performs a rolling update.

New pods start using the updated container image.

------------------------------------------------------------------------

# Summary

ArgoCD continuously monitors the Git repository and ensures the
Kubernetes cluster state always matches the manifests stored in Git.

This model is known as **GitOps**, where Git acts as the single source
of truth for deployments.
