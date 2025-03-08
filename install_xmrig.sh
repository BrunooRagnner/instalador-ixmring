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
echo "⚙️ Compilando o XMRig, isso pode demorar um pouco..."
cmake .. && make -j$(nproc)

# Solicitar o endereço da carteira e o pool
echo "🖊️ Insira o seu endereço de carteira Monero (Exemplo: 42fn4du2y9XYxhdM4K3V9hdf2h8wfpYKiUq7oeF16tnwvYoeHgdyTyzFz1zBshYQjpXQ1bE9z2hGq8z7fEJ7kqtQp9zxfWcsHq6Y): "
read carteira
echo "🖊️ Insira o endereço do pool (Exemplo: pool.supportxmr.com:3333): "
read pool

# Criar arquivo de configuração
echo "🛠️ Criando arquivo de configuração..."
cat > config.json <<EOL
{
    "autosave": true,
    "cpu": { "enabled": true, "huge-pages": true, "hw-aes": null, "asm": true, "rx": [0, 1, 2, 3] },
    "pools": [
        {
            "url": "$pool",
            "user": "$carteira",
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

