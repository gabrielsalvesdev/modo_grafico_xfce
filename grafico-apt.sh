#!/bin/bash

# Mensagens de log
exec > >(tee /var/log/mylog.log)
exec 2>&1


# Instalar xfce4
function instalar_xfce4() {
    if ! dpkg -l | grep ubuntu-desktop; then
        echo "Instalando o xfce 🐀..."
        sudo apt install xfce4
        echo "xfce instalado🐀 ."
    else
        echo "O xfce já está instalado."
    fi
}
# Função para verificar e instalar o servidor VNC
function instalar_servidor_vnc() {
    if ! dpkg -l | grep tightvncserver; then
        echo "Instalando o servidor VNC..."
        sudo apt install tightvncserver -y
        echo "Servidor VNC instalado."
    else
        echo "O servidor VNC já está instalado."
    fi
}

# Função para configurar a senha do VNC
function configurar_senha_vnc() {
    VNC_PASSWORD=SUA,SENHA,OU,VAI,SER,ESSA
    echo "Configurando senha VNC..."
    echo "${VNC_PASSWORD}" | vncpasswd -f > ~/.vnc/passwd
    sudo chmod 600 ~/.vnc/passwd
    echo "Senha VNC configurada."
}


function criar_arquivo_inicializacao_vnc() {
    echo "Configurando arquivo de inicialização do VNC..."
    cat << EOF > ~/.vnc/xstartup
#!/bin/bash
export DISPLAY=:0
export XKL_XMODMAP_DISABLE=1
xrdb \$HOME/.Xresources
startxfce4 &
EOF
    chmod +x ~/.vnc/xstartup
    echo "Arquivo de inicialização do VNC configurado."
}

criar_arquivo_inicializacao_vnc

export DISPLAY=:0

sudo systemctl restart user@0.service


function reiniciar_vnc_server() {
    echo "Reiniciando o VNC Server..."
    vncserver -kill :1
    sudo systemctl restart user@0.service
    vncserver :0
    echo "VNC Server reiniciado."
}



instalar_xfce4
instalar_servidor_vnc
configurar_senha_vnc
criar_arquivo_inicializacao_vnc
reiniciar_vnc_server


echo "Configuração concluída."
