#!/bin/bash

root_folder='/mnt/SSD/'
logs_folder="${root_folder}Logs"
source_folder="${root_folder}Source/"
startUp=15
logfile="/mnt/SSD/Logs/jetson.log"

function getSignalInfo(){
	time=$(timestamp)
	info=$(iwconfig | grep Link)
	ping_info=$(ping www.google.com -c 2)
	echo $time >> ${logs_folder}/signal.txt  
	echo $info >> ${logs_folder}/signal.txt 
	echo $ping_info >> ${logs_folder}/signal.txt 
}

function isMounted(){
	#verifica se o ssd está montado e pronto para ser usado
	if mountpoint -q /mnt/SSD/
	then
		return 1
	else
		return 0
	fi
}

function waitMount(){
	#caso o ssd não estiver montado, espera e checa novamente
	isMounted
	while [ $? -eq 0 ];
	do
		sleep 3
		isMounted
	echo "Falhou ..."
	done
}

function startDaemons(){
	#Inicializa as daemons de orientação e update do servidor e do app
	echo "starting deamons" >> "${logfile}"
	/home/nvidia/c4aarch64_installer/bin/python "${source_folder}/deamons/orientation/main-orientation.py" &
	#/home/nvidia/c4aarch64_installer/bin/python "${source_folder}/deamons/updateApp/send.py" &
	#/home/nvidia/c4aarch64_installer/bin/python "${source_folder}/deamons/updateServer/send.py" &
}

function startProcess(){
	#Inicializa o processamento de dados
	echo "starting process" >> "${logfile}"
	/home/nvidia/c4aarch64_installer/bin/python "${source_folder}main/processData/main-process.py" -p True &
}

function startCaptures(){
	#Inicia a captura de dados
	echo "starting captures" >> "${logfile}"
	/home/nvidia/c4aarch64_installer/bin/python "${source_folder}main/getData/main-capture.py" &
}

function checkNetwork(){
	#Checa a conexão com a internet
	echo "Interface 	Estado		      IP"
	if ip -br address | grep UP | cut -f 1 -d '/' | grep w -n 
	then	
        echo "Conexão ativa"
        netstate=1
		return $netstate
	else	
        echo "Conexão inativa"
        netstate=0
		return $netstate
	fi
}

function waitNetwork(){
	#Caso a Jetson estiver conectada com a rede, espera e checa novamente
	checkNetwork
	while [ $netstate -ne 0 ];
	do	
		echo ""
        echo "...Esperando o encerramento da conexão ..."
		echo ""
		sleep 3
		#clear
		checkNetwork
	
	done
}

echo "Iniciando" >> "${logfile}"
sleep $startUp

echo "Procurando SSD" >> "${logfile}"
waitMount

#echo "Verificando conexão" >> "${logfile}"
#waitNetwork

echo "Iniciando os processos" >> "${logfile}"
startDaemons
#startProcess

echo "Iniciando as capturas" >> "${logfile}"

while true
do

	# TO DO
	#Checar se tem internet. Se tiver, pular o loop e gerar um sleep antes de checar novamente
	#waitNetwork

	startCaptures
	sleep 10
done
# Loop de captura -> Checando sempre a internet