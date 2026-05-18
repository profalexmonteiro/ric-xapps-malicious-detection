#!/bin/bash


# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update

sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

CURRENT_USER=$(whoami)
sudo usermod -aG docker "$CURRENT_USER"

# Atualiza os repositórios
sudo apt-get update

# Instala GNU Radio e TMUX
sudo apt-get install -y gnuradio tmux libzmq3-dev cmake make gcc g++ pkg-config libfftw3-dev libmbedtls-dev libsctp-dev libyaml-cpp-dev build-essential cmake libfftw3-dev libmbedtls-dev libboost-program-options-dev libconfig++-dev libsctp-dev git curl jq 

echo ""
echo "Verificando disponibilidade do comando 'gnb'..."
 
if sudo gnb --version > /dev/null 2>&1; then
    echo "✅ 'gnb' encontrado e funcional: $(sudo gnb --version 2>&1 | head -n1)"
else
    echo "⚠️  'gnb' não encontrado ou não funcional. Iniciando compilação do srsRAN_Project..."
 
    SRSRAN_DIR="$PWD/openran/srsRAN_Project"
 
    if [[ ! -d "$SRSRAN_DIR" ]]; then
        echo "❌ Diretório não encontrado: $SRSRAN_DIR"
        echo "   Verifique se o repositório foi clonado corretamente."
        exit 1
    fi
 
    cd "$SRSRAN_DIR" || exit 1
 
    mkdir -p build
    cd build/ || exit 1
 
    echo "▶ Executando cmake..."
    cmake ../ -DENABLE_EXPORT=ON -DENABLE_ZEROMQ=ON
 
    echo "▶ Compilando com $(nproc) threads..."
    make -j"$(nproc)"
 
    echo "▶ Copiando binário para /usr/bin/gnb..."
    sudo cp "$SRSRAN_DIR/build/apps/gnb/gnb" /usr/bin/gnb  
 
    # Valida se a compilação foi bem-sucedida
    if sudo gnb --version > /dev/null 2>&1; then
        echo "✅ srsRAN compilado e instalado com sucesso: $(sudo gnb --version 2>&1 | head -n1)"
    else
        echo "❌ Compilação concluída, mas 'gnb' ainda não está acessível."
        echo "   Verifique se o binário está no PATH ou execute 'sudo make install' manualmente em $SRSRAN_DIR/build"
        exit 1
    fi
fi

# Verifica se o comando srsue está disponível e funcional
echo ""
echo "Verificando disponibilidade do comando 'srsue'..."
 
if srsue --version > /dev/null 2>&1; then
    echo "✅ 'srsue' encontrado e funcional: $(srsue --version 2>&1 | head -n1)"
else
    echo "⚠️  'srsue' não encontrado ou não funcional. Iniciando compilação do srsRAN_4G..."
 
    SRSRAN_4G_DIR="$PWD/openran/srsRAN_Project/srsRAN_4G"
 
    if [[ ! -d "$SRSRAN_4G_DIR" ]]; then
        echo "❌ Diretório não encontrado: $SRSRAN_4G_DIR"
        echo "   Verifique se o repositório foi clonado corretamente."
        exit 1
    fi
 
    cd "$SRSRAN_4G_DIR" || exit 1
 
    mkdir -p build
    cd build/ || exit 1
 
    echo "▶ Executando cmake..."
    cmake ../ -DENABLE_EXPORT=ON -DENABLE_ZEROMQ=ON
 
    echo "▶ Compilando com $(nproc) threads..."
    make -j"$(nproc)"
 
    echo "▶ Copiando binário para /usr/bin/srsue..."
    sudo cp "$SRSRAN_4G_DIR/build/srsue/src/srsue" /usr/bin/srsue
 
    # Valida se a compilação foi bem-sucedida
    if srsue --version > /dev/null 2>&1; then
        echo "✅ srsRAN 4G compilado e instalado com sucesso: $(srsue --version 2>&1 | head -n1)"
    else
        echo "❌ Compilação concluída, mas 'srsue' ainda não está acessível."
        echo "   Verifique se o binário está no PATH ou em $SRSRAN_4G_DIR/build/srsue/src/srsue"
        exit 1
    fi
fi
