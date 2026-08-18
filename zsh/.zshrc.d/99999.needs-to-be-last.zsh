# Zoxide - optional. This stays last because it defines the cd wrapper.
_zsh_cache_init zoxide "$ZSH_INIT_CACHE_DIR/zoxide.zsh" zoxide init zsh --cmd cd

unfunction _zsh_cache_init
unset ZSH_INIT_CACHE_DIR
