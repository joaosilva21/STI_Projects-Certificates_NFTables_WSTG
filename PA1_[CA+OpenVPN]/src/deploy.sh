#!/bin/bash
name_sudo="stipl1"
pass_sudo="stipl1"
ip_coimbra="192.168.172.20"; pass_coimbra="stipl1"; user_coimbra="stipl1";
ip_lisboa="192.168.172.30"; pass_lisboa="stipl1"; user_lisboa="stipl1";
ip_warrior="192.168.172.10"; pass_warrior="stipl1"; user_warrior="stipl1";
passphrase="stipl1"
password_pkcs12="stipl1"
sudo_use="echo ${pass_sudo} | sudo -S"
sudo_coimbra_use="echo ${pass_coimbra} | sudo -S"
sudo_lisboa_use="echo ${pass_lisboa} | sudo -S"
sudo_warrior_use="echo ${pass_warrior} | sudo -S"

ips=(${ip_coimbra} ${ip_warrior} ${ip_lisboa})
passs=(${pass_coimbra} ${pass_warrior} ${pass_lisboa})
users=(${user_coimbra} ${user_warrior} ${user_lisboa})

country="PT"
state="Coimbra"
locality="Coimbra"
organization="UC"
organization_unit="DEI"
CN_Coimbra_CA="[Coimbra]:CA"; CN_Coimbra_OCSP="[Coimbra]:OCSP"; CN_Coimbra="[Coimbra]:Local"; CN_Warrior="[Warrior]:Local";
CN_Lisboa="[Lisboa]:Local"; CN_Lisboa_Apache="[Lisboa]:Apache"; CN_Lisboa_Apache_User="[Lisboa]:Apache_User"; CN_Lisboa_Apache_Revo="[Lisboa]:Apache_Revo";
email_Coimbra="coimbra@mail.com"; email_Warrior="warrior@mail.com"; email_Lisboa="lisboa@mail.com"
validity_days=1825

# PKI [VARIABLE]
pki="/etc/pki"

# Certification Authority [VARIABLES]
cadir="${pki}/CA"
cacerts="${cadir}/certs"
canewcerts="${cadir}/newcerts"
cacrl="${cadir}/crl"
caprivate="${cadir}/private"
cacsrs="${cadir}/csrs"
caindex="${cadir}/index.txt"
caserial="${cadir}/serial"
cacrlnumber="${cadir}/crlnumber"

# Openvpn [VARIABLES]
openvpndir="${pki}/Openvpn";
openvpnprivate="${openvpndir}/private";
openvpnconfigs="${openvpndir}/configs";

openvpnclient_w="client-warrior.conf"; openvpnclient_l="client-lisboa.conf";
openvpnserver_c_w="server-coimbra-warrior.conf"; openvpnserver_c_l="server-coimbra-lisboa.conf";

# Apache [VARIABLES]
apachedir="${pki}/Apache";
apacheconfigs="${apachedir}/configs";

apache_sslconfig="config.conf";

# Directories(Coimbra, Lisboa, Warrior) [VARIABLES]
dirdir="/home/stipl1"
coimbradir="/home/stipl1/coimbra"
lisboadir="/home/stipl1/lisboa"
warriordir="/home/stipl1/warrior"

dirs=(${coimbradir} ${warriordir} ${lisboadir})

openvpndirserver_local="/etc/openvpn/server"
openvpndirclient_local="/etc/openvpn/client"
apache_local="/etc/apache2"

# Key, CSR and Certificate [VARIABLES]
cakey_name="ca.key"; ocspkey_name="ocsp.key"; coimbrakey_name="coimbra.key"; warriorkey_name="warrior.key"; lisboakey_name="lisboa.key"; apachekey_name="apache.key"; 
cacsr_name="ca.csr"; ocspcsr_name="ocsp.csr"; coimbracsr_name="coimbra.csr"; warriorcsr_name="warrior.csr"; lisboacsr_name="lisboa.csr"; apachecsr_name="apache.csr";
cacrt_name="ca.crt"; ocspcrt_name="ocsp.crt"; coimbracrt_name="coimbra.crt"; warriorcrt_name="warrior.crt"; lisboacrt_name="lisboa.crt"; apachecrt_name="apache.crt";
apacheuserkey_name="apacheuser.key"; apacheusercsr_name="apacheuser.csr"; apacheusercrt_name="apacheuser.crt"; apacheuserpkcs12_name="apacheuser.p12"
apacherevokey_name="apacherevo.key"; apacherevocsr_name="apacherevo.csr"; apacherevocrt_name="apacherevo.crt"; apacherevopkcs12_name="apacherevo.p12"

# dh2048 and Takey [VARIABLES]
dh2048_c_w_name="dh2048_c_w.pem"; dh2048_c_l_name="dh2048_c_l.pem";
takey_c_w_name="ta_c_w.key"; takey_c_l_name="ta_c_l.key";

keys=(${cakey_name} ${ocspkey_name} ${coimbrakey_name} ${warriorkey_name} ${lisboakey_name} ${apachekey_name} ${apacheuserkey_name} ${apacherevokey_name})
csrs=(${cacsr_name} ${ocspcsr_name} ${coimbracsr_name} ${warriorcsr_name} ${lisboacsr_name} ${apachecsr_name} ${apacheusercsr_name} ${apacherevocsr_name})
crts=(${cacrt_name} ${ocspcrt_name} ${coimbracrt_name} ${warriorcrt_name} ${lisboacrt_name} ${apachecrt_name} ${apacheusercrt_name} ${apacherevocrt_name})
emails=(${email_Coimbra} ${email_Coimbra} ${email_Coimbra} ${email_Warrior} ${email_Lisboa} ${email_Lisboa} ${email_Lisboa} ${email_Lisboa})
CNs=(${CN_Coimbra_CA} ${CN_Coimbra_OCSP} ${CN_Coimbra} ${CN_Warrior} ${CN_Lisboa} ${CN_Lisboa_Apache} ${CN_Lisboa_Apache_User} ${CN_Lisboa_Apache_Revo})

dh2048s=(${dh2048_c_w_name} ${dh2048_c_l_name})
takeys=(${takey_c_w_name} ${takey_c_l_name})

help(){
	echo "How to use: bash deploy.sh [option]"
	echo ""
	echo " -h    |  --help         Display all commands"
	echo " -ca   |  --certauth     Generate certification authority and the keys, CSRs, certificates and files necessary to this project"
	echo " -dist |  --distribute   Distribute all the files to all the Virtual Machines"
	echo " -c    |  --coimbra      Organize the files of Coimbra's Virtual Machine"
	echo " -l    |  --lisboa       Organize the files of Lisboa's Virtual Machine"
	echo " -w    |  --warrior      Organize the files of Warrior's Virtual Machine" 
}

certauth(){
	# PKI [CREATION]
	eval $sudo_use mkdir ${pki}

	# Certification Authority [CREATION]
	eval $sudo_use mkdir ${cadir}
	eval $sudo_use mkdir ${cacerts}
	eval $sudo_use mkdir ${canewcerts}
	eval $sudo_use mkdir ${cacrl}
	eval $sudo_use mkdir ${caprivate}
	eval $sudo_use mkdir ${cacsrs}
	eval $sudo_use touch ${caindex}
	sudo bash -c "echo 01 > ${caserial}"
	sudo bash -c "echo 01 > ${cacrlnumber}"

	# Openvpn [CREATION]
	eval $sudo_use mkdir ${openvpndir}
	eval $sudo_use mkdir ${openvpnprivate}
	eval $sudo_use mkdir ${openvpnconfigs}

	# Apache [CREATION]
	eval $sudo_use mkdir ${apachedir}
	eval $sudo_use mkdir ${apacheconfigs}

	# Generate Keys, CSR and Certificates
	for i in ${!keys[@]};
	do
		eval $sudo_use openssl genrsa \
			-out ${caprivate}/${keys[$i]} \
			-des3 \
			-passout pass:${passphrase} 2048

		eval $sudo_use openssl req \
			-new \
			-key ${caprivate}/${keys[$i]} \
			-out ${cacsrs}/${csrs[$i]} \
			-subj /C=${country}/ST=${state}/L=${locality}/O=${organization}/OU=${organization_unit}/CN=${CNs[$i]}/emailAddress=${emails[$i]} \
			-passin pass:${passphrase}

		if [ $i -eq 0 ]; then
			eval $sudo_use openssl x509 \
				-req \
				-in ${cacsrs}/${csrs[$i]} \
				-out ${cacerts}/${crts[$i]} \
				-signkey ${caprivate}/${keys[$i]} \
				-passin pass:${passphrase} \
				-days ${validity_days}
		elif [ $i -eq 1 ]; then
			eval $sudo_use openssl ca \
				-batch \
				-in ${cacsrs}/${csrs[$i]} \
				-cert ${cacerts}/${crts[0]} \
				-keyfile ${caprivate}/${keys[0]} \
				-out ${cacerts}/${crts[$i]} \
				-extensions v3_OCSP \
				-passin pass:${passphrase}
		elif [ $i -eq 2 ]; then
			eval $sudo_use openssl ca \
				-batch \
				-in ${cacsrs}/${csrs[$i]} \
				-cert ${cacerts}/${crts[0]} \
				-keyfile ${caprivate}/${keys[0]} \
				-out ${cacerts}/${crts[$i]} \
				-extensions server \
				-passin pass:${passphrase}
		elif [ $i -eq 3 ] || [ $i -eq 4 ]; then
			eval $sudo_use openssl ca \
				-batch \
				-in ${cacsrs}/${csrs[$i]} \
				-cert ${cacerts}/${crts[0]} \
				-keyfile ${caprivate}/${keys[0]} \
				-out ${cacerts}/${crts[$i]} \
				-extensions client \
				-passin pass:${passphrase}
		else
			eval $sudo_use openssl ca \
				-batch \
				-in ${cacsrs}/${csrs[$i]} \
				-cert ${cacerts}/${crts[0]} \
				-keyfile ${caprivate}/${keys[0]} \
				-out ${cacerts}/${crts[$i]} \
				-passin pass:${passphrase}
		fi
	done

	# Create dh2048 and Takeys
	for i in ${!dh2048s[@]};
	do
		eval $sudo_use openssl dhparam \
			-out ${openvpnprivate}/${dh2048s[$i]} 2048
		eval $sudo_use openvpn \
			--genkey tls-auth ${openvpnprivate}/${takeys[$i]}
	done
}

distribute(){
	eval $sudo_use chmod +r ${cacerts}/${cacrt_name}

	for i in ${!dh2048s[@]};
	do
		eval $sudo_use chmod +r ${openvpnprivate}/${dh2048s[$i]}
		eval $sudo_use chmod +r ${openvpnprivate}/${takeys[$i]}
	done

	for i in ${!ips[@]};
	do
		eval $sudo_use chmod +r ${cacerts}/${crts[$i+2]}
		eval $sudo_use chmod +r ${caprivate}/${keys[$i+2]}

		eval sshpass -p ${passs[$i]} ssh \
			${users[$i]}@${ips[$i]} \
			mkdir ${dirs[$i]}

		eval sshpass -p ${passs[$i]} scp \
			-r \
			"deploy.sh" \
			${users[$i]}@${ips[$i]}:${dirdir}

		eval sshpass -p ${passs[$i]} scp \
			-r \
			${cacerts}/${cacrt_name} \
			${caprivate}/${keys[$i+2]} \
			${cacerts}/${crts[$i+2]} \
			${users[$i]}@${ips[$i]}:${dirs[$i]}

		if [ $i -eq 0 ]; then
			eval sshpass -p ${passs[$i]} scp \
				-r \
				${openvpnprivate}/${dh2048s[0]} \
				${openvpnprivate}/${dh2048s[1]} \
				${openvpnprivate}/${takeys[0]} \
				${openvpnprivate}/${takeys[1]} \
				${openvpnconfigs}/${openvpnserver_c_l} \
				${openvpnconfigs}/${openvpnserver_c_w} \
				${users[$i]}@${ips[$i]}:${dirs[$i]}
		elif [ $i -eq 1 ]; then
			eval $sudo_use chmod +r ${cacerts}/${crts[6]} ${cacerts}/${crts[7]}
			eval $sudo_use chmod +r ${caprivate}/${keys[6]} ${caprivate}/${keys[7]}

			eval sshpass -p ${passs[$i]} scp \
				-r \
				${openvpnprivate}/${takeys[0]} \
				${openvpnconfigs}/${openvpnclient_w} \
				${cacerts}/${crts[6]} \
				${cacerts}/${crts[7]} \
				${caprivate}/${keys[6]} \
				${caprivate}/${keys[7]} \
				${users[$i]}@${ips[$i]}:${dirs[$i]}
		else
			eval $sudo_use chmod +r ${cacerts}/${crts[5]}
			eval $sudo_use chmod +r ${caprivate}/${keys[5]}

			eval sshpass -p ${passs[$i]} scp \
				-r \
				${openvpnprivate}/${takeys[1]} \
				${openvpnconfigs}/${openvpnclient_l} \
				${apacheconfigs}/${apache_sslconfig} \
				${cacerts}/${crts[5]} \
				${caprivate}/${keys[5]} \
				${users[$i]}@${ips[$i]}:${dirs[$i]}
		fi
	done
}

coimbra(){
	eval $sudo_coimbra_use mv \
		${coimbradir}/${cacrt_name} \
		${coimbradir}/${coimbrakey_name} \
		${coimbradir}/${coimbracrt_name} \
		${coimbradir}/${takey_c_w_name} ${coimbradir}/${takey_c_l_name} \
		${coimbradir}/${dh2048_c_w_name} ${coimbradir}/${dh2048_c_l_name} \
		${coimbradir}/${openvpnserver_c_w} ${coimbradir}/${openvpnserver_c_l} \
		${openvpndirserver_local}
}

warrior(){
	eval $sudo_warrior_use openssl pkcs12 \
		-export \
		-clcerts \
		-in ${warriordir}/${apacheusercrt_name} \
		-inkey ${warriordir}/${apacheuserkey_name} \
		-out ${warriordir}/${apacheuserpkcs12_name} \
		-passin pass:${passphrase} \
		-password pass:${password_pkcs12}

	eval $sudo_warrior_use openssl pkcs12 \
		-export \
		-clcerts \
		-in ${warriordir}/${apacherevocrt_name} \
		-inkey ${warriordir}/${apacherevokey_name} \
		-out ${warriordir}/${apacherevopkcs12_name} \
		-passin pass:${passphrase} \
		-password pass:${password_pkcs12}

	eval $sudo_warrior_use chmod +r ${warriordir}/${apacheuserpkcs12_name}
	eval $sudo_warrior_use chmod +r ${warriordir}/${apacherevopkcs12_name}

	eval $sudo_warrior_use mv \
		${warriordir}/${cacrt_name} \
		${warriordir}/${warriorkey_name} \
		${warriordir}/${warriorcrt_name} \
		${warriordir}/${takey_c_w_name} \
		${warriordir}/${openvpnclient_w} \
		${openvpndirclient_local}
}

lisboa(){
	eval $sudo_lisboa_use cp \
		${lisboadir}/${cacrt_name} \
		${openvpndirclient_local}
		

	eval $sudo_lisboa_use mv \
		${lisboadir}/${lisboakey_name} \
		${lisboadir}/${lisboacrt_name} \
		${lisboadir}/${takey_c_l_name} \
		${lisboadir}/${openvpnclient_l} \
		${openvpndirclient_local}
		
	eval $sudo_lisboa_use mv \
		${lisboadir}/${apachekey_name} \
		${lisboadir}/${apachecrt_name} \
		${lisboadir}/${cacrt_name} \
		${apache_local}
		
	eval $sudo_lisboa_use mv \
		${lisboadir}/${apache_sslconfig} \
		${apache_local}/sites-available 
}

if [ $# -eq 0 ]; then
	echo "How to use: bash $0 [option]"
	echo "For any doubts use: bash $0 --help"
	exit 1;
fi

option=$1
case ${option} in
	-h    | --help) help && shift ;;
	-ca   | --certauth) certauth && shift ;; 
	-dist | --distribute) distribute && shift ;;
	-c    | --coimbra) coimbra && shift ;;
	-l    | --lisboa) lisboa && shift ;;
	-w    | --warrior) warrior && shift ;;
esac	

