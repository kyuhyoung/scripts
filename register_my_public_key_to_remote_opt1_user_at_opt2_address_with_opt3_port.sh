#!/usr/bin/env bash
# Register my public key (~/.ssh/id_ed25519.pub) to a remote server's authorized_keys
# so that ssh to that server no longer asks for a password.
# It asks the remote password ONCE (this time), and never again afterwards.
# usage (with port option)    : sh register_my_public_key_to_remote_opt1_user_at_opt2_address_with_opt3_port.sh kevin 192.168.2.50 1122
# usage (without port option) : sh register_my_public_key_to_remote_opt1_user_at_opt2_address_with_opt3_port.sh kevin 192.168.2.240
ID_REMOTE=$1
IP_REMOTE=$2
PUBKEY="$HOME/.ssh/id_ed25519.pub"
REMOTE_CMD='mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'
if [ ! -f "$PUBKEY" ]; then
echo "public key not found: $PUBKEY  (make one with: ssh-keygen -t ed25519)"
exit 1
fi
if [ "$#" -eq 3 ]; then
PORT_REMOTE=$3
ssh $ID_REMOTE@$IP_REMOTE -p $PORT_REMOTE "$REMOTE_CMD" < "$PUBKEY"
else
ssh $ID_REMOTE@$IP_REMOTE "$REMOTE_CMD" < "$PUBKEY"
fi
