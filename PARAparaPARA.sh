#!/bin/bash

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
	done
}

function renameAutoExec(){
	#renomeia o arquivo start.sh para start2.sh
	#para que em caso de erro ele não será executado automaticamente na inicialização da Jetson
	mv /home/nvidia/Desktop/start.sh /home/nvidia/Desktop/start2.sh
	sleep 60 #após 1 minuto, volta o nome original
	mv /home/nvidia/Desktop/start2.sh /home/nvidia/Desktop/start.sh
}

waitMount
renameAutoExec
