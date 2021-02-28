## What is Simple Kubernetes?
_________________

***Simple Kubernetes*** contains several guides, useful links, troubleshooting, scripts and deployments to make it as easy as possible to create your own bare metal [Kubernetes Cluster](https://github.com/kubernetes/kubernetes) inside [Proxmox](https://www.proxmox.com/de/) in [LXC Containers](https://en.wikipedia.org/wiki/LXC).

## Table of contents
_________________
* [Wiki](../../wiki)
* **Scripts**
    * Installer
        * [Debian Kubernetes installer](debian_installer.sh)
        * [Ubuntu Kubernetes installer](ubuntu_installer.sh)

* **Deployments**
    * [MetalLB](metallb)
    * Dashboard
        * [Official Kubernetes Dashboard](https://github.com/kubernetes/dashboard)
            * [Standard](dashboard) (**without** OAuth Proxy)
            * [OAuth-Proxy](dashboard/oauth) (**with** OAuth Proxy)

    * [Ingress](ingress)
    * [CertManager](https://github.com/jetstack/cert-manager)
        * LetsEncrypt ***(HTTP01 Challenge)***
            * [Prod](cert/letsencrypt-prod-clusterissuer.yaml) (ClusterIssuer)
            * [Staging](cert/letsencrypt-staging-clusterissuer.yaml) (ClusterIssuer)
        * Cloudflare ***(DNS01 Challenge)***
            * [Prod](cert/cloudflare/cloudflare-prod-clusterissuer.yaml) (ClusterIssuer)
            * [Staging](cert/cloudflare/cloudflare-staging-clusterissuer.yaml) (ClusterIssuer)

    * Testing
        * [Deployment](test/test-deployment.yaml)
        * [Ingress](test/test-ingress.yaml)
        * [LetsEncrypt-Ingress](test/test-letsencrypt-ingress.yaml)
        * [Cloudflare-Ingress](test/test-cloudflare-ingress.yaml)