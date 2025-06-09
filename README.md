# PingUpTime

PingUpTime est une application web légère qui permet de surveiller l'état (UP/DOWN) d'une liste d'URL. Elle est développée en Python avec Flask, conteneurisée avec Docker, et déployée automatiquement sur Oracle Cloud Infrastructure (OCI) via Terraform et un pipeline GitHub Actions.

---

## 📂 Structure du projet

```plaintext
PingUpTime/
├── app/                   # Code source de l'application Flask
│   ├── __init__.py        # Création de l'app Flask et enregistrement du blueprint
│   ├── main.py            # Route principale et logique d'ajout d'URL
│   ├── template/          # Fichiers de template Jinja2 (index.html)
│   └── uptime_checker.py  # Module de vérification d'URLs
├── Dockerfile             # Construction multi-stage de l'image Docker
├── .dockerignore          # Fichiers/ dossiers ignorés par Docker
├── requirements.txt       # Dépendances Python
├── infra/                 # Infrastructure as Code avec OpenTofu/Terraform
│   ├── provider.tf        # Configuration du provider OCI
│   ├── variables.tf       # Déclaration des variables
│   ├── data.tf            # Data sources (tenancy, AD, image)
│   ├── network.tf         # VCN, Subnet, IGW, Route Table, Security List
│   ├── ssh_key.tf         # Génération de la paire SSH
│   ├── compute.tf         # Déploiement de l'instance Always Free + Docker
│   ├── outputs.tf         # Récupération IP et chemin de clé SSH
│   ├── terraform.tfvars   # Valeurs spécifiques (OCID tenancy, region...)
│   └── ...                # États, lock file, etc.
├── .github/               # Pipeline GitHub Actions (CI/CD)
│   └── workflows/
│       └── deploy.yml     # Build, tests, push Docker image & déploiement
└── README.md              # Ce fichier
```

---

## 🚀 Prérequis

* **Docker** (version ≥ 20.10)
* **Terraform / OpenTofu** (version ≥ 1.0)
* Un **compte OCI** avec les identifiants configurés (OCID tenancy, user OCID, fingerprint, key file).
* **GitHub** : secrets configurés pour GHCR, SSH\_PRIVATE\_KEY, INSTANCE\_PUBLIC\_IP.

---

## 🛠️ Développement local

1. Clonez le repo:

   ```bash
   git clone https://github.com/clemuscle/PingUptime.git
   cd PingUpTime
   ```
2. (Optionnel) Créez un virtualenv:

   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   ```
3. Installez les dépendances:

   ```bash
   pip install -r requirements.txt
   ```
4. Lancez l'app en mode dev:

   ```bash
   export FLASK_APP=app/main.py
   flask run --host=0.0.0.0 --port=5000
   ```
5. Accédez à [http://localhost:5000](http://localhost:5000)

---

## 🐳 Docker

* **Build** de l'image :

  ```bash
  docker build -t ping-uptime:latest .
  ```
* **Run** du container :

  ```bash
  docker run -d --name pinguptime -p 5000:5000 ping-uptime:latest
  ```
* **Healthcheck** disponible sur l'endpoint `/` grâce à la directive `HEALTHCHECK` dans le Dockerfile.

---

## ☁️ Infrastructure (OCI via Terraform)

1. Allez dans le dossier `infra/` :

   ```bash
   cd infra
   ```
2. Remplissez `terraform.tfvars` avec vos OCID, region (`eu-marseille-1`), etc.
3. Initialisez et déployez :

   ```bash
   terraform init
   terraform apply
   ```
4. Récupérez :

   * l'IP publique : `terraform output public_ip`
   * le chemin de la clé SSH privée : `terraform output ssh_private_key_path`

---

## 🔄 CI/CD & Déploiement automatique

Le workflow GitHub Actions (`.github/workflows/deploy.yml`) :

1. **Test** (pytest) et **build** de l'image Docker
2. **Push** sur GitHub Container Registry (GHCR)
3. **Login** sur l'OCI VM via SSH (clé `SSH_PRIVATE_KEY`)
4. **Pull** de la nouvelle image et **re-run** du container

**Secrets GitHub requis** :

* `SSH_PRIVATE_KEY` (clé privée `id_rsa_pinguptime`)
* `INSTANCE_PUBLIC_IP` (IP de la VM)
* Permissions `packages: write` pour pousser sur GHCR

---

## 🎯 Utilisation

1. Après déploiement, ouvrez votre navigateur sur :

   ```
   http://<INSTANCE_PUBLIC_IP>:5000
   ```
2. Ajoutez dynamiquement des URLs à surveiller via le formulaire.
3. Le statut UP/DOWN s’affiche en temps réel.

---

## 🤔 Questions ?

N’hésitez pas si vous voulez voir le contenu d’un fichier spécifique ou si vous avez des questions pour compléter ce README !
