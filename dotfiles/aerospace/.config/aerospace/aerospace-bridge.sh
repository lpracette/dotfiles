#!/bin/sh

# Add AeroSpace CLI and Homebrew to PATH
export PATH="$PATH:/usr/local/bin:/opt/homebrew/bin"

DIRECTION="$1" # left, down, up, right, resize-*
APP_NAME=$(aerospace list-windows --focused --format '%{app-name}')

# Map directions to tmux keys and edge variables
get_key_and_edge() {
    case "$1" in
        left)  KEY="C-h"; EDGE="pane_at_left" ;;
        down)  KEY="C-j"; EDGE="pane_at_bottom" ;;
        up)    KEY="C-k"; EDGE="pane_at_top" ;;
        right) KEY="C-l"; EDGE="pane_at_right" ;;
        *)     KEY=""; EDGE="" ;;
    esac
}

# Move focus in iTerm2/tmux/nvim or fallback to AeroSpace
move_focus() {
    get_key_and_edge "$DIRECTION"
    if [ "$APP_NAME" = "iTerm2" ]; then
        # Check if current tmux pane is running nvim
        IS_NVIM=$(tmux display-message -p "#{pane_current_command}" | grep -iqE '(n|v)vim' && echo "1" || echo "0")
        if [ "$IS_NVIM" = "1" ]; then
            CURRENT_PANE=$(tmux display-message -p "#{pane_id}")
            tmux send-keys "$KEY"
            sleep 0.05
            NEW_PANE=$(tmux display-message -p "#{pane_id}")
            IS_EDGE=$(tmux display-message -p "#{${EDGE}}" 2>/dev/null)
            if [ "$CURRENT_PANE" = "$NEW_PANE" ] && { [ "$IS_EDGE" = "1" ] || [ -z "$IS_EDGE" ]; }; then
                aerospace focus --boundaries all-monitors-outer-frame "$DIRECTION"
            fi
            exit 0
        fi

        # Not in nvim: standard tmux logic
        IS_EDGE=$(tmux display-message -p "#{${EDGE}}" 2>/dev/null)
        if [ "$IS_EDGE" = "1" ] || [ -z "$IS_EDGE" ]; then
            aerospace focus --boundaries all-monitors-outer-frame "$DIRECTION"
        else
            case "$DIRECTION" in
                left)  tmux select-pane -L ;;
                down)  tmux select-pane -D ;;
                up)    tmux select-pane -U ;;
                right) tmux select-pane -R ;;
            esac
        fi
    else
        aerospace focus --boundaries all-monitors-outer-frame "$DIRECTION"
    fi
}

# Resize logic for tmux/nvim or fallback to AeroSpace
resize_window() {
    DIR="${DIRECTION#resize-}"
    case "$DIR" in
        left)  KEY="M-h" ;;
        down)  KEY="M-j" ;;
        up)    KEY="M-k" ;;
        right) KEY="M-l" ;;
        *)     KEY="" ;;
    esac

    if [ "$APP_NAME" = "iTerm2" ]; then
        [ -n "$KEY" ] && tmux send-keys "$KEY"
    else
        case "$DIR" in
            left|up)   aerospace resize smart -50 ;;
            right|down) aerospace resize smart +50 ;;
        esac
    fi
}

# Main logic
case "$DIRECTION" in
    left|down|up|right)
        move_focus
        ;;
    resize-*)
        resize_window
        ;;
esac
