
## Challenge 5 - Infrastructure As Code with Terraform 

Date limite de remise du challenge: le 20 février 2021 

### Task 2: Implementing Bastion Hosts
L'objectif ici est de comprendre et de mettre en application le pattern _Bastion Host_, connu également sous le nom _Jump Box_. 

Travail demandé:
- Lire l'article [AWS Bastion Host - How to create it?](https://www.knowledgehut.com/tutorials/aws/aws-bastion-hostVisualiser) afin de s'introduire au concept de Bastion Host. Visualier les séquences Youtube suivantes qui expliquent également ce concept :  <https://www.youtube.com/watch?v=pNE9J81aYLc&list>, <https://www.youtube.com/watch?v=VJjy7AH3J9Q>, <https://youtu.be/Mwf17O45IA0> .
   
- Procéder à la mise en place d'un host bastion pour un VPC AWS en suivant l'article _Connecting to an ec2 instance in a private subnet on AWS_ qui se trouve [ici](https://towardsdatascience.com/connecting-to-an-ec2-instance-in-a-private-subnet-on-aws-38a3b86f58fb). Le code du projet  terraform relatif à cet article est disponible sur ce GitHub :  <https://github.com/HDaniels1991/AWS-Bastion-Host/>

 --- 
### Mise en pratique
Est inclus dans le zip: 
- Un folder *aws-bastionHost* contenant les fichiers à runner (9 fichiers .tf : + de fichiers dans le tuto que dans la version github)
- Un folder *keys* contenant la clé permettant de se connecter à l'hôte.
- Un fichier *config* pour activer/paramétrer l'instance privée.
- Un folder *printscreen* avec les étapes en images.

PS: J'ai donc choisi de travailler en Ohio plutôt qu'en Irlande contrairement au tuto. J'ai donc modifié les variables de région ainsi que lid de l'AMI.

**Install and run Step by step:** 

Ces 3 premières commandes **doivent se suivre et être validée** avec succès avant d'aller + loin: 
1. On génère la clé, dans le répertoire keys: 
`ssh-keygen -t rsa -b 2048 -f mykeypair` 
 entrée et entrée pour les passphrases
3. Entrer la commande pour appeler l'agent ssh: 
``$ eval $(ssh-agent)``
retourne un agent ssh avec un pid aléatoire: 
``Agent pid 594``

4. Ajout de la clé :  `$ ssh-add -k mykeypair`

Une fois ces 3étapes franchies avec succès, place à Terraform: 

1. Initialisation du projet, se placer dans le projet :
`$ terraform init`
if success: 
`$ terraform validate #to ensure configuration is okey`
`$ terraform plan`
`$ terraform apply`

2.  Une fois le chargement et la création des vms, vous les verrez apparaitre dans le cloud aws, dans les EC2_instances.
3. Relevez l'adresse IP publique de l'instance: *bastion-instance*
4. Relevez l'adresse IP privée de l'instance: *private-instance*
5. Sous windows, touche clavier Microsoft + r, entrez : `%USERPROFILE%/.ssh/` and click `OK`
6. Faites un click droit dans ce dossier et choisissez Git Bash Here >
entrez la commande: `touch config`, un fichier sera alors crée.
7. Dans ce fichier copiez-collez la configuration de redirection:

	    Host bastion-instance
	       HostName 3.141.37.57
	       User ubuntu
	    
	    Host private-instance
	       HostName 10.0.0.30
	       User ubuntu
	       ProxyCommand ssh -q -W %h:%p bastion-instance

-- HostName *bastion-instance*, remplacer l'ip avec son adresse IpV4 publique.
-- HostName *private-instance*, remplacer l'ip avec son adresse IpV4 privée. Sauvez le fichier et fermer.

Retour dans Vscode, entrez:

    $ ssh private-instance

Il nous demande de confirmer l'ajout de la clé de manière permanente (*fingerprint*), entrez `Yes`  et `Yes`

Cool! the private instance run now!! 

Une fois cela fait, détruisez l'instance pour qu'elle n'engage pas de frais supplémentaire sur le cloud: `$ terraform destroy`
