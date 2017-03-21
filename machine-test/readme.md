The machine starts an sshd service on the port 4022. You should open that port with docker swarm; but probably not on the VPS's firewall (this allows localhost to connect to the container.)
The login:password is test:test.
