#!/bin/bash
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
		clear
		checkNetwork
	
	done
}

echo "Verificando conexão..."
echo ""
waitNetwork