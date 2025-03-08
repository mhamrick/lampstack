# lampstack
A podman LAMP stack that runs as the local user.

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

The ports.conf file sets apache to run on port 8000.   

Everything runs as the local user, so sudo access is not needed.  
