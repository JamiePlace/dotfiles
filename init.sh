sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo >> /Users/jamieplace/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/jamieplace/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install node
brew install fzf
brew install rust
brew install golang
brew install neovim
brew install --cask raycast
brew install --cask rectangle
brew install jless
brew install csvlens
brew install zoxide
brew install starship
brew install pure
brew install luarocks
luarocks install --local luafilesystem


mkdir -p $HOME/Pictures/backgrounds/
ln -ns $HOME/.config/.zshrc $HOME/.zshrc
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
