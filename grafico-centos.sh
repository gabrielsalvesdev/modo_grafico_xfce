#!/bin/bash

# Mensagens de log
exec > >(tee /var/log/mylog.log)
exec 2>&1

# Export DISPLAY
export DISPLAY=:0

# Instalar xfce4
function instalar_xfce4() {
   if ! rpm -qa | grep xfce4; then
       echo "Instalando o xfce..."
       sudo yum -y install epel-release
       sudo yum -y groupinstall "Xfce"
       echo "xfce instalado."
   else
       echo "O xfce já está instalado."
   fi
}

# Função para verificar e instalar o servidor VNC
function instalar_servidor_vnc() {
   if ! rpm -qa | grep tigervnc-server; then
       echo "Instalando o servidor VNC..."
       sudo yum install tigervnc-server -y
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
xrdb \$HOME/.Xresources
startxfce4 &
EOF
   chmod +x ~/.vnc/xstartup
   echo "Arquivo de inicialização do VNC configurado."
}


export DISPLAY=:0

sudo systemctl restart user@0.service

instalar_xfce4
instalar_servidor_vnc
configurar_senha_vnc
criar_arquivo_inicializacao_vnc

echo "Configuração concluída."