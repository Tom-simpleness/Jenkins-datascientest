# Projet DevOps - Pipeline de Déploiement Multi-Environnements

## Aperçu du Projet

Ce projet met en place un pipeline de déploiement continu (CD) pour une application en microservices. L'objectif est de déployer automatiquement l'application dans plusieurs environnements de développement en utilisant Jenkins, Kubernetes, et Helm.

## Structure du Projet

```
.
├── k8s/                  # Manifestes Kubernetes
├── microservices/        # Code source des microservices
│   └── helm/             # Charts Helm pour le déploiement
├── Jenkinsfile           # Pipeline Jenkins
└── README.md             # Ce fichier
```

## Technologies Utilisées

- **Jenkins**: Orchestration du pipeline CI/CD
- **Kubernetes**: Plateforme de container orchestration pour le déploiement
- **Helm**: Gestionnaire de packages Kubernetes pour le déploiement des microservices
- **Docker**: Conteneurisation des microservices

## Fonctionnalités du Pipeline

1. Build et test des microservices
2. Création et push des images Docker
3. Déploiement dans différents environnements (dev, staging, prod) via Helm
4. Tests d'intégration post-déploiement
5. Promotion entre environnements

## Prérequis

- Cluster Kubernetes opérationnel
- Jenkins installé et configuré avec les plugins nécessaires
- Helm installé sur le serveur Jenkins et les nœuds Kubernetes
- Registre Docker accessible

## Configuration et Utilisation

1. Clonez ce dépôt sur votre serveur Jenkins.
2. Configurez les credentials nécessaires dans Jenkins (Docker registry, Kubernetes, etc.).
3. Créez un nouveau pipeline Jenkins pointant vers le `Jenkinsfile` de ce projet.
4. Lancez le pipeline manuellement ou configurez des webhooks pour un déclenchement automatique.

## Déploiement

Le pipeline déploie automatiquement l'application dans les environnements suivants :

- Développement
- Staging
- Production

Chaque environnement est isolé dans son propre namespace Kubernetes.

## Monitoring et Logging

- Utilisez les outils intégrés à Kubernetes pour le monitoring (ex: Prometheus, Grafana)
- Les logs des applications sont centralisés via une stack ELK (Elasticsearch, Logstash, Kibana)

## Dépannage

En cas de problème lors du déploiement :

1. Vérifiez les logs Jenkins pour des erreurs spécifiques
2. Utilisez `kubectl` pour inspecter l'état des pods et services dans le cluster Kubernetes
3. Vérifiez les logs des applications via `kubectl logs`


## Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.
