#!/bin/bash

BOLD="\e[1m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NC="\e[0m"

SWARM_DIR="$HOME/rl-swarm"
TEMP_DATA_PATH="$SWARM_DIR/modal-login/temp-data"
HOME_DIR="$HOME"

cd $HOME

if [ -f "$SWARM_DIR/swarm.pem" ]; then
    echo -e "${BOLD}${YELLOW}你他妈有密钥了 ${GREEN}swarm.pem${YELLOW} file.${NC}\n"
    echo -e "${BOLD}${YELLOW}想吗:${NC}"
    echo -e "${BOLD}1) 使用已经存在的？ swarm.pem${NC}"
    echo -e "${BOLD}${RED}2) 删了重建？${NC}"

    while true; do
        read -p $'\e[1mEnter your choice (1 or 2): \e[0m' choice
        if [ "$choice" == "1" ]; then
            echo -e "\n${BOLD}${YELLOW}[✓] Using existing swarm.pem...${NC}"
            mv "$SWARM_DIR/swarm.pem" "$HOME_DIR/"
            mv "$TEMP_DATA_PATH/userData.json" "$HOME_DIR/" 2>/dev/null
            mv "$TEMP_DATA_PATH/userApiKey.json" "$HOME_DIR/" 2>/dev/null

            rm -rf "$SWARM_DIR"

            echo -e "${BOLD}${YELLOW}[✓] Cloning fresh repository...${NC}"
            cd $HOME && git clone https://github.com/zunxbt/rl-swarm.git > /dev/null 2>&1

            mv "$HOME_DIR/swarm.pem" rl-swarm/
            mv "$HOME_DIR/userData.json" rl-swarm/modal-login/temp-data/ 2>/dev/null
            mv "$HOME_DIR/userApiKey.json" rl-swarm/modal-login/temp-data/ 2>/dev/null
            break
        elif [ "$choice" == "2" ]; then
            echo -e "${BOLD}${YELLOW}[✓] 移除存在的，重新开始...${NC}"
            rm -rf "$SWARM_DIR"
            cd $HOME && git clone https://github.com/zunxbt/rl-swarm.git > /dev/null 2>&1
            break
        else
            echo -e "\n${BOLD}${RED}[✗] Invalid choice. Please enter 1 or 2.${NC}"
        fi
    done
else
    echo -e "${BOLD}${YELLOW}[✓] No existing swarm.pem found. Cloning repository...${NC}"
    cd $HOME && [ -d rl-swarm ] && rm -rf rl-swarm; git clone https://github.com/zunxbt/rl-swarm.git > /dev/null 2>&1
fi

cd rl-swarm || { echo -e "${BOLD}${RED}[✗] Failed to enter rl-swarm directory. Exiting.${NC}"; exit 1; }

if [ -n "$VIRTUAL_ENV" ]; then
    echo -e "${BOLD}${YELLOW}[✓] Deactivating existing virtual environment...${NC}"
    deactivate
fi

echo -e "${BOLD}${YELLOW}[✓] 设置python虚拟环境...${NC}"

# 强制重建虚拟环境
rm -rf .venv
python3 -m venv .venv
source .venv/bin/activate
pip3 install -r  requirements.txt
pip3 install -r  requirements_gpu.txt
pip3 install -r  requirements-hivemind.txt

echo -e "${BOLD}${YELLOW}[✓] Running rl-swarm...${NC}"
./run_rl_swarm.sh
