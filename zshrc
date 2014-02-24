# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to  shown in the command execution time stamp 
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH="$HOME/bin/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/sbin"

export EDITOR=vim

# Java
export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64
export PATH=$JAVA_HOME:$PATH

# Maven Stuff
#export M2_HOME=$HOME/bin/apache-maven-2.2.1
export M2_HOME=$HOME/bin/apache-maven-3.0.5
export PATH=$M2_HOME:$PATH
export M2=$M2_HOME/bin
export PATH=$M2:$PATH
export MAVEN_OPTS="-Xms256m -Xmx512m"
export PATH=$MAVEN_OPTS:$PATH

# Groovy
export GROOVY_HOME=$HOME/bin/groovy-2.2.1
export PATH=$GROOVY_HOME/bin:$PATH

# Grails
export GRAILS_HOME=$HOME/bin/grails-2.3.6
export PATH=$GRAILS_HOME/bin:$PATH

# Gradle
export GRADLE_HOME=$HOME/bin/gradle-1.11
export PATH=$GRADLE_HOME/bin:$PATH

# Alias
alias pastebinit="pastebinit -b http://paste.debian.net"
alias openconnect="sudo openconnect --no-cert-check -u costanzoj vpn1.gsicommerce.com"

# Graphics
#export DISPLAY=:8 LD_LIBRARY_PATH=/usr/lib/nvidia:$LD_LIBRARY_PATH
