#!/bin/bash

# Atualizar pacotes e instalar dependências
echo "🔄 Atualizando pacotes e instalando dependências..."
sudo apt update && sudo apt install -y git cmake build-essential libssl-dev libhwloc-dev

# Remover qualquer instalação anterior do XMRig
echo "🗑️ Removendo instalação antiga, se existir..."
rm -rf ~/xmrig

# Clonar o repositório do XMRig
echo "⬇️ Baixando o XMRig..."
git clone https://github.com/xmrig/xmrig.git ~/xmrig
cd ~/xmrig || { echo "❌ Erro ao acessar a pasta xmrig"; exit 1; }

# Criar e entrar na pasta de build
echo "📁 Criando pasta de build..."
mkdir build && cd build || { echo "❌ Erro ao acessar a pasta build"; exit 1; }

# Compilar o XMRig
echo "⚙️ Compilando XMRig, isso pode demorar um pouco..."
cmake .. && make -j$(nproc)

# Criar arquivo de configuração
echo "🛠️ Criando arquivo de configuração..."
cat > config.json <<EOL
{
    "autosave": true,
    "cpu": { "enabled": true, "huge-pages": true, "hw-aes": null, "asm": true, "rx": [0, 1, 2, 3] },
    "pools": [
        {
            "url": "pool.supportxmr.com:3333",
            "user": "SUA_CARTEIRA_MONERO",
            "pass": "x",
            "keepalive": true,
            "tls": false
        }
    ]
}
EOL

# Conceder permissão de execução ao XMRig
chmod +x xmrig

# Executar o XMRig
echo "🚀 Iniciando o XMRig..."
./xmrig
