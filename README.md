# Docker demarches-simplifiees

Le docker pour le projet [demarches-simplifiees.fr](http://demarches-simplifiees.fr "demarches-simplifiees.fr")

### Lancer docker-compose
```bash
docker-compose up
```

### Connecter en SSH dans le conteneur docker, setup & lancer le serveur: 
```bash
docker exec -it <container name> /bin/bash

cd /ds

# Lancer le setup
bin/setup

# Lancer le serveur
bin/rails s -b 0.0.0.0
```

### Tester demarches-simplifiees
http://127.0.0.1:3000
