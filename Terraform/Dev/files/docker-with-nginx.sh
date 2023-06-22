#!/bin/bash

#SWITCHING TO SUPER USER AND THEN CREATING THE id_rsa.pub FILE WHICH CONTAINS PUBLIC KEY FOR ANISBLE TO SUCESSFULLY ESTABLISH THE CONNECTION
sudo su
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0v7xIOG8D8+7RGW5kg6NKVVKMdRplhkY/fhnzM2DPiWPR0gcBgx1x1K6sTQSf+uNYYgoF8trz5U2s4Vxh9I8e/tg5Lm06iRzP8NUyW5cz+VYpsIIeRIfRvj5BKsfokMq9wetSSwKJkcADxzcwLctDAfEkZIDxKRUDZJk8c5NHq7Rn3Bx7TXDnBFNq3N4fbLb9mPL3tLYd10Hm0f6m/6yzwlG0MwYSqvajrY58LQIDQjGyJJ63Y3abH8DRHnD84zDVbUrPO50XKklJBPkf9MYUEpqvtP4L09yEczfz2YrzqnGh0yFahk74zkK82I/ELS84BH1FzXc4AWn5n/AEfyGz0rdnI5JH3Mh+pFsBCwo7qG9ul6EiyopIst1QMAouKVui08wxxThLHh96Kp+pbUY0/mx4swVXGcNFa7Dh2heDErBEXXtUKHV9YnOaCDqhV75Dho45A1Xx3tS7tPE/yyGvWZfIPB14X374aIQxBwZo4FwR9w6KicriK8WlWb1o7HU= akamble@CAI1150LT00057.local
" > /home/ubuntu/.ssh/id_rsa.pub

sudo apt update -y

depends = ("apt-transport-https" "ca-certificates" "curl" "gnupg-agent" "software-properties-common")

for i in "${depends[@]}"; do
    sudo apt install -y $i

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

apt-cache policy docker-ce

sudo apt install -y docker-ce

sudo docker run -d -p 5000:80 nginx:latest


