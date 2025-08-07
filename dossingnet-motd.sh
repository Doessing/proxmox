#!/bin/bash
# save as /etc/profile.d/dossingnet-motd.sh
# chmod +x /etc/profile.d/dossingnet-motd.sh
clear

# Clear original
rm /etc/update-motd.d/10-help-text

# Colors
BLUE="\e[34m"
BOLD="\e[1m"
RESET="\e[0m"

# Info
public_ip=$(curl -s https://api.ipify.org)
private_ip=$(hostname -I | awk '{print $1}')
hostname=$(hostname)
uptime=$(uptime -p)
username=$(whoami)
os_version=$(lsb_release -d | cut -f2-)
memory=$(free -h | awk '/Mem:/ {print $3 " used of " $2}')
disk=$(df -h / | awk 'NR==2 {print $3 " used of " $2 " (" $5 " used)"}')

# ASCII header
echo -e "${BLUE}${BOLD}"
cat <<'EOF'
                 .-'''-.                                                                                             
_______         '   _    \                                                                                           
\  ___ `'.    /   /` '.   \              .--.   _..._                          _..._         __.....__               
 ' |--.\  \  .   |     \  '              |__| .'     '.   .--./)             .'     '.   .-''         '.             
 | |    \  ' |   '      |  '             .--..   .-.   . /.''\\             .   .-.   . /     .-''"'-.  `.      .|   
 | |     |  '\    \     / /              |  ||  '   '  || |  | |            |  '   '  |/     /________\   \   .' |_  
 | |     |  | `.   ` ..' / _         _   |  ||  |   |  | \`-' /             |  |   |  ||                  | .'     | 
 | |     ' .'    '-...-'`.' |      .' |  |  ||  |   |  | /("'`              |  |   |  |\    .-------------''--.  .-' 
 | |___.' /'            .   | /   .   | /|  ||  |   |  | \ '---.            |  |   |  | \    '-.____...---.   |  |   
/_______.'/           .'.'| |// .'.'| |//|__||  |   |  |  /'""'.\           |  |   |  |  `.             .'    |  |   
\_______|/          .'.'.-'  /.'.'.-'  /     |  |   |  | ||     ||          |  |   |  |    `''-...... -'      |  '.' 
                    .'   \_.' .'   \_.'      |  |   |  | \'. __//           |  |   |  |                       |   /  
                                             '--'   '--'  `'---'            '--'   '--'                       `'-'   
EOF
echo -e "${RESET}"

# Info section
echo -e "${BLUE}  Welcome to Dossing Net, SÃ¸ren DÃ¸ssing${RESET}"
echo
echo -e "${BLUE}  ðŸ–¥ï¸  Hostname     :${RESET} $hostname"
echo -e "${BLUE}  ðŸ“¡  Public IP    :${RESET} $public_ip"
echo -e "${BLUE}  ðŸ›œ  Private IP   :${RESET} $private_ip"
echo -e "${BLUE}  ðŸ“…  Uptime       :${RESET} $uptime"
echo -e "${BLUE}  ðŸ”  Logged in as :${RESET} $username"
echo -e "${BLUE}  ðŸ§   Memory usage :${RESET} $memory"
echo -e "${BLUE}  ðŸ’¾  Disk usage   :${RESET} $disk"
echo -e "${BLUE}  ðŸ§  OS version   :${RESET} $os_version"
echo
echo -e "${BLUE}  ðŸ› ï¸  Services     :${RESET} nginx | cacme.sh | ssh | php | rclone"
echo -e "${BLUE}------------------------------------------------------------${RESET}"
