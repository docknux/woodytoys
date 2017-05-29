The machine starts an sshd service on the port 4022. You should open that port with docker swarm; but probably not on the VPS's firewall (this allows localhost to connect to the container.)
The login:password is test:test.

ssh -nvNT -C -L 8080:squid.wt6.ephec-ti.be:3128 -p 4022 test@ip
chromium --proxy-server="http://127.0.0.1:8080"
