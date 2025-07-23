subscription_id=""                                    # Subscription id of azure
tenant_id=""                                          # Tenant id get from DevOps
client_id=""                                          # client ID get from DevOps
client_secret=""                                      # Client_scret get from DevOps
env_name=""
enable_peering_dev=""
enable_peering_jenkins=""
env_address=""                                        # Virtual network range, should have a CIDR(a.b.c.d/X) eg. 10.x.0,0/16 (x will shoube be replae validation number)
management_user=""                                    # Username for management VM access
management_password=""                                # password for management VM access
k8s_user=""                                           # Username for kubernetes nodes access
k8s_password=""                                       # Password for kubernetes nodes access
tags_value=""                                         # Name of azure resource tag eg. MDP                
mgmnt_osdisk_size = ""                                # management Os disk size in GB (must be 200 GB)
k8s_osdisk_size = ""                                  # K8s all nodes  Os disk size in GB
mgmnt_vm_size = ""                                    # Management VM sizes ex: Standard_D4s_v2
k8s_node_vm_size = ""                                 # K8s nodes VM sizes ex: Standard_D4s_v2
k8snode_count= ""                                     # Number of kubernetes nodes
longhorndisks_count= ""                               # Number of longhorn disks per VM
longhorndisks_size= ""                                # Size of longhorn disks
sku_version   = "22_04-LTS"                           # OS version
os_offer      = "0001-com-ubuntu-server-jammy"        # os Provider
lb_ports = {
  # map of ports to redirect on the load-balancer
  # for custom TCP services exposed by a nodeport:
  # - key is the value from the well known port list (for instance, 1883 for MQTT or 5672 for AMQP/RabbitMQ)
  # - value is is the value of the nodePort exposing the service. It is configuration dependent.
  "443" = "443",
  "80" = "80"
}

fw_ports = [ # comma separated list of ports to open on the firewall
  # for custom TCP services exposed by a nodeport, this is the value of the nodePort exposing the service. It is configuration dependent.
  "443",
  "80"
]
