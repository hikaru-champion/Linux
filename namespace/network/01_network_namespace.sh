## reset network namespace
sudo ip --all netns delete

## create network namespaces
sudo ip netns add ns1
sudo ip netns add ns2

## create veth interfaces
sudo ip link add ns1-veth0 type veth peer name ns2-veth0

## move veth interfaces to each namespaces
sudo ip link set ns1-veth0 netns ns1
sudo ip link set ns2-veth0 netns ns2

sudo ip netns exec ns1 ip link show | grep veth
sudo ip netns exec ns2 ip link show | grep veth

## add ip address
sudo ip netns exec ns1 ip address add 192.0.2.1/24 dev ns1-veth0
sudo ip netns exec ns2 ip address add 192.0.2.2/24 dev ns2-veth0
sudo ip netns exec ns1 ip address show
sudo ip netns exec ns2 ip address show

## up veth interfaces
sudo ip netns exec ns1 ip link set ns1-veth0 up
sudo ip netns exec ns2 ip link set ns2-veth0 up

## ping exec
sudo ip netns exec ns1 ping -c 3 192.0.2.2