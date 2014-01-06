# function deploy() {
#   source deploy.sh
# }

function pg_restart() {
	launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
	sleep 1
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
}