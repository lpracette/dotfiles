#!/bin/sh

DIRECTION="$1" # left, down, up, right, resize-*
APP_NAME=$(aerospace list-windows --focused --format '%{app-name}')

# Detect if the current tmux pane is running Neovim
is_nvim() {
    tmux display-message -p "#{pane_current_command}" | grep -iqE '^(n|v)vim'
}

# Move focus in iTerm2/tmux/nvim or fallback to AeroSpace
move_focus() {
    # If not iTerm2, just use AeroSpace
    if [ "$APP_NAME" != "iTerm2" ]; then
        aerospace focus --boundaries all-monitors-outer-frame "$DIRECTION"
        return
    fi

    # Map directions to tmux keys and edge variables
    case "$DIRECTION" in
        left)  KEY="C-h"; EDGE="pane_at_left" ;;
        down)  KEY="C-j"; EDGE="pane_at_bottom" ;;
        up)    KEY="C-k"; EDGE="pane_at_top" ;;
        right) KEY="C-l"; EDGE="pane_at_right" ;;
        *)     KEY=""; EDGE="" ;;
    esac

    if is_nvim; then
        # We assume smart-splits.nvim is set up with proper 'at_edge' hook.
        CURRENT_PANE=$(tmux display-message -p "#{pane_id}")
        tmux send-keys -t "$CURRENT_PANE" "$KEY"
    else
        IS_EDGE=$(tmux display-message -p "#{${EDGE}}" 2>/dev/null)
        if [ "$IS_EDGE" = "1" ] || [ -z "$IS_EDGE" ]; then
            # We are at the Tmux edge -> Hand off to AeroSpace
            aerospace focus --boundaries all-monitors-outer-frame "$DIRECTION"
        else
            # We are NOT at the edge -> Tell Tmux to switch panes
            # in tmux send-keys won't work here for navigation (it just types ^H).
            case "$DIRECTION" in
                left)  tmux select-pane -L ;;
                down)  tmux select-pane -D ;;
                up)    tmux select-pane -U ;;
                right) tmux select-pane -R ;;
            esac
        fi
    fi
}

# Resize logic for tmux/nvim or fallback to AeroSpace
resize_window() {
    DIR="${DIRECTION#resize-}"
    case "$DIR" in
        left)  TMUX_FLAG="-L"; NVIM_KEY="M-h" ;;
        down)  TMUX_FLAG="-D"; NVIM_KEY="M-j" ;;
        up)    TMUX_FLAG="-U"; NVIM_KEY="M-k" ;;
        right) TMUX_FLAG="-R"; NVIM_KEY="M-l" ;;
        *)     TMUX_FLAG=""; NVIM_KEY="" ;;
    esac

    if [ "$APP_NAME" = "iTerm2" ]; then
        CURRENT_PANE=$(tmux display-message -p "#{pane_id}")
        if is_nvim; then
            [ -n "$NVIM_KEY" ] && tmux send-keys -t "$CURRENT_PANE" "$NVIM_KEY"
        else
            [ -n "$TMUX_FLAG" ] && tmux resize-pane -t "$CURRENT_PANE" $TMUX_FLAG 5
        fi
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
