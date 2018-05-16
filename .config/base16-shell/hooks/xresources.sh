#!/usr/bin/env bash
curl -s https://raw.githubusercontent.com/chriskempson/base16-xresources/master/xresources/base16-${BASE16_THEME}.Xresources > ~/.Xresources
cat ~/.Xresources.base >> ~/.Xresources
xrdb -load ~/.Xresources

curl -s https://raw.githubusercontent.com/khamer/base16-i3/master/colors/base16-${BASE16_THEME}.config > ~/.config/i3/config
cat ~/.config/i3/config.base >> ~/.config/i3/config
i3-msg reload
