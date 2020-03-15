When first adding a computer:
Add the user you want to initially log into the system (e.g. ben.greene)
add ben.greene to sudoers group

Then follow this command where samspi is the hostname (found in hosts file)

    ansible-playbook ansible-initial-config.yaml -l samspi -kKb


