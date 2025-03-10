# lampstack
A podman LAMP stack that runs as the local user.  

## Ports
To run as the local user, the ports have to be above 1024.

The ports.conf file sets apache to run on port 8000 for the websesrver container. For phymyadmin, the   -e APACHE_PORT=8080  flag is used to set the ports. 

Run the intialsetup.sh script to create the subdirectories.

The buildbod.sh script will create the podman containers.

The code should be setup as below:
```
  ├── buildpod.sh
  ├── lampstack
  │   ├── html
  │   ├── logs
  │   ├── mysql
  │   └── ports.conf
  ├── LICENSE
  └── README.md
```
The html directory is where the app for testing is placed, such as Wordpress.

Everything runs as the local user, so sudo access is not needed.  
