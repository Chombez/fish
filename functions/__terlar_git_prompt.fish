set -g fish_color_git_clean green
set -g fish_color_git_staged cyan
set -g fish_color_git_dirty yellow

set -g fish_color_git_added green
set -g fish_color_git_modified brown
set -g fish_color_git_renamed magenta
set -g fish_color_git_copied magenta
set -g fish_color_git_deleted red
set -g fish_color_git_untracked yellow
set -g fish_color_git_unmerged red
set -g fish_color_git_desync green
set -g fish_color_git_stash cyan

set -g fish_prompt_git_status_added '🞥'
set -g fish_prompt_git_status_modified '🟊'
set -g fish_prompt_git_status_renamed '🠊'
set -g fish_prompt_git_status_copied '⁑'
set -g fish_prompt_git_status_deleted '❌'
set -g fish_prompt_git_status_untracked '?'
set -g fish_prompt_git_status_unmerged '!'
set -g fish_prompt_git_status_desync '⟲'
set -g fish_prompt_git_status_stash '§'

set -g fish_prompt_git_status_order added modified renamed copied deleted untracked unmerged desync stash

function __terlar_git_prompt --description 'Write out the git prompt'
  # If git isn't installed, there's nothing we can do
  # Return 1 so the calling prompt can deal with it
  if not command -s git >/dev/null
    return 1
  end

  set -l branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if test -z $branch
    return
  end

  echo -n '['

  set -l index (git --no-optional-locks status --porcelain 2>/dev/null|cut -c 1-2|sort -u)

  set -l gs
  set -l staged

  # Check if remote HEAD matches local HEAD
  if test (git rev-parse HEAD 2>/dev/null) != (git rev-parse '@{u}' 2>/dev/null) 2>/dev/null
    set gs $gs desync
  end

  # Check if and stashed changes
  if count (git stash list 2>/dev/null) > /dev/null
    set gs $gs stash
  end

  for i in $index
    if echo $i | grep '^[AMRCD]' >/dev/null
      set staged 1
    end

    switch $i
      case 'A '               ; set gs $gs added
      case 'M ' ' M' 'MM'     ; set gs $gs modified
      case 'R '               ; set gs $gs renamed
      case 'C '               ; set gs $gs copied
      case 'D ' ' D'          ; set gs $gs deleted
      case '\?\?'             ; set gs $gs untracked
      case 'U*' '*U' 'DD' 'AA'; set gs $gs unmerged
    end
  end

  if test -z "$index"
    set_color $fish_color_git_clean
    echo -n '✔'
  else if set -q staged[1]
    set_color $fish_color_git_staged
    echo -n '❖'
  else
    set_color $fish_color_git_dirty
    echo -n '⚡'
  end

  echo -n $branch

  for i in $fish_prompt_git_status_order
    if contains $i in $gs
      set -l color_name fish_color_git_$i
      set -l status_name fish_prompt_git_status_$i

      set_color $$color_name
      echo -n $$status_name
    end
  end

  set_color normal
  echo -n '] '
end
