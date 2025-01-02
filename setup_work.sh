# Setup git with gnome-keyring
sudo apt install make gcc git libsecret-1-0 libsecret-1-dev libglib2.0-dev libsecret-tools
sudo make --directory=/usr/share/doc/git/contrib/credential/libsecret
git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret

mkdir ~/.local/share/keyrings

wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
sudo apt update && sudo apt install temurin-21-jdk

sudo add-apt-repository ppa:wslutilities/wslu
sudo apt update
sudo apt install xdg-utils wslu
sudo apt install -y make curl python3 g++ pkg-config gnome-keyring xdg-utils wslu

# Run inside Ubuntu/Debian session
# wsl.exe -d wsl-vpnkit --cd /app cat /app/wsl-vpnkit.service | sudo tee /etc/systemd/system/wsl-vpnkit.service
# sudo systemctl enable wsl-vpnkit
# sudo systemctl start wsl-vpnkit