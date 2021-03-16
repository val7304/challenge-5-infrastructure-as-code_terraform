# Challenge 5 - Infrastructure As Code with Terraform
---
Date limite de remise du challenge: le 20 février 2021 

# Task 1: Using Terraform modules
L'objectif ici est de comprendre le principe des modules Terraform et de les mettre en application. 

Travail demandé: 
 - Implémenter les étapes du tutoriel de démarrage avec Terraform modules de Hashicorp se trouvant [ici](https://learn.hashicorp.com/collections/terraform/modules). Ce tutoriel comprend 6 étapes et requiert 1heure 9minutes. Si besoin, vous pouvez trouvez d'autres ressources sur les modules de Terraform : La [section sur les modules](https://app.pluralsight.com/course-player?clipId=694f2109-1579-4d9c-9fb6-3e4f9e96a574) du cours Pluralsight : Terraform, getting started. Les clips Youtube suivants : [How to Create AWS VPC with Terraform Modules](https://www.youtube.com/watch?v=5-0bAfZd7SY,https://www.youtube.com/watch?v=5-0bAfZd7SY),  [Modules | Terraform Tutorial | #15](https://www.youtube.com/watch?v=7jnuTdhxjhw), et [Azure Fundamentals - #22 - Azure Bastion](https://youtu.be/Ixl44IRkxj0).
 - Déployer le module Terraform de démonstration d'une application Nginx sur une instance EC2 d'AWS. Voici son [URL](https://registry.terraform.io/modules/codygreen/nginx-demo-app/aws/latest). Sur cet URL vous trouverez le lien GitHub du module ainsi que les 'Provision instructions' : <https://github.com/codygreen/terraform-aws-nginx-demo-app>. A titre de remarque, ce module n'a qu'une seule variable obligatoire, celle nommée `ec2_key_name`, de type `string` et qui représente le nom de la clé AWS EC2 pour l'accès SSH. 
 --- 
### Mise en pratique

### Install and run:

Est inclus: 

- Un folder terraform contenant les fichiers à runner contenant main.tf, outputs.tf et variables.tf
- Un folder ssh-keys contenant la clé permettant de se connecter,

```sh
$ terraform init
$ terraform validate
$ terraform plan
$ terraform apply
```
une x la commande 'apply' démarrée, un prompt vous demande le nom ec2_key_name => la valeur à lui donner est admin 

Go to the aws-online, au niveau de vos instances:  
https://us-east-2.console.aws.amazon.com/ec2/v2/home?region=us-east-2#Instances:instanceState=running;sort=elasticIp

Vous verrez alors vos 4 instances
Vous devrez relever l'/es adresse(s) IP pour voir le site nginx
et les tester dans votre navigateur 

### Connection && Vérification SSH de l'installation nginx: 
Connection à l'une des instances avec: 
right-click sur une des instances >> connection > onglet SSH pour la marche à suivre 

La connection dans votre terminal:
```sh
valer@DESKTOP-L2RC63V MINGW64 /d/challenge-5/task1/terraform
$ ssh -i "ssh-keys/id_rsa_aws" ubuntu@ec2-18-219-17-40.us-east-2.compute.amazonaws.com
Welcome to Ubuntu 18.04.5 LTS (GNU/Linux 5.4.0-1037-aws x86_64)

  Documentation:  https://help.ubuntu.com
  Management:     https://landscape.canonical.com
  Support:        https://ubuntu.com/advantage
  //.etc boot ubuntu ..
ubuntu@ip-10-0-1-44: cd /var/www/html
ubuntu@ip-10-0-1-44:/var/www/html$ ll -ls
total 12
drwxr-xr-x 2 root root 4096 Feb 20 17:58 ./
drwxr-xr-x 3 root root 4096 Feb 20 17:58 ../
-rw-r--r-- 1 root root  612 Feb 20 17:58 index.nginx-debian.html

ubuntu@ip-10-0-1-44:~$ cd /etc/nginx
ubuntu@ip-10-0-1-44:/etc/nginx$ ll
total 72
drwxr-xr-x  8 root root 4096 Feb 20 17:58 ./
drwxr-xr-x 90 root root 4096 Feb 20 17:58 ../
drwxr-xr-x  2 root root 4096 Jan 10  2020 conf.d/
-rw-r--r--  1 root root 1077 Apr  6  2018 fastcgi.conf      
-rw-r--r--  1 root root 1007 Apr  6  2018 fastcgi_params    
-rw-r--r--  1 root root 2837 Apr  6  2018 koi-utf
-rw-r--r--  1 root root 2223 Apr  6  2018 koi-win
-rw-r--r--  1 root root 3957 Apr  6  2018 mime.types        
drwxr-xr-x  2 root root 4096 Jan 10  2020 modules-available/
drwxr-xr-x  2 root root 4096 Feb 20 17:58 modules-enabled/  
-rw-r--r--  1 root root 1482 Apr  6  2018 nginx.conf        
-rw-r--r--  1 root root  180 Apr  6  2018 proxy_params
-rw-r--r--  1 root root  636 Apr  6  2018 scgi_params
drwxr-xr-x  2 root root 4096 Feb 20 17:58 sites-available/
drwxr-xr-x  2 root root 4096 Feb 20 17:58 sites-enabled/
drwxr-xr-x  2 root root 4096 Feb 20 17:58 snippets/
-rw-r--r--  1 root root  664 Apr  6  2018 uwsgi_params
-rw-r--r--  1 root root 3071 Apr  6  2018 win-utf

ubuntu@ip-10-0-1-44:/etc/nginx$ cat nginx.conf 
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
        worker_connections 768;
        # multi_accept on;     
}
//... etc 
ubuntu@ip-10-0-1-44:/etc/nginx$ exit
logout
Connection to ec2-18-219-17-40.us-east-2.compute.amazonaws.com closed.
```

Une fois toutes les vérifications faites: 
```sh
terraform destroy 

#au prompt: 
Do you really want to destroy all resources?
Terraform will destroy all your managed infrastructure, as shown above.
There is no undo. Only 'yes' will be accepted to confirm.
  Enter a value: yes

//..... 
e.vpc.aws_subnet.public[0]: Destroying... [id=subnet-0dbadd2d3894266ac]
module.vpc.aws_subnet.public[1]: Destroying... [id=subnet-06f5e7445e8b90c02]
module.ssh_secure_sg.module.sg.aws_security_group.this_name_prefix[0]: Destroying... [id=sg-07b2fb3459c67a310]
module.web_server_sg.module.sg.aws_security_group.this_name_prefix[0]: Destroying... [id=sg-0ce946408d1c59f05]
module.web_server_sg.module.sg.aws_security_group.this_name_prefix[0]: Destruction complete after 1s
module.ssh_secure_sg.module.sg.aws_security_group.this_name_prefix[0]: Destruction complete after 1s
module.vpc.aws_subnet.public[1]: Destruction complete after 1s
module.vpc.aws_subnet.public[0]: Destruction complete after 1s
module.vpc.aws_vpc.this[0]: Destroying... [id=vpc-0eca41fef4d95dc82]
module.vpc.aws_vpc.this[0]: Destruction complete after 1s
random_id.id: Destroying... [id=vJc]
random_id.id: Destruction complete after 0s

Destroy complete! Resources: 22 destroyed.
valer@DESKTOP-L2RC63V MINGW64 /d/challenge-5/task1/aws-nginx
$
```
