# CodeCompanion Setup Guide

CodeCompanion is now configured in your NeoVim setup with support for both GitHub Copilot (default) and Claude (Anthropic).

## Setup

### GitHub Copilot (Default)

CodeCompanion uses your existing Copilot authentication from `copilot.lua`. No additional setup needed!

### Claude/Anthropic API Key (Optional)

If you want to use Claude as an alternative provider:

1. Go to https://console.anthropic.com
2. Sign up or log in
3. Navigate to "API Keys" section
4. Create a new API key
5. Copy the key (starts with `sk-ant-`)

Add to your `~/.zshrc` file:

```bash
# Anthropic Claude API Key (optional)
export ANTHROPIC_API_KEY="sk-ant-xxxxxxxxxxxxx"
```

After adding, reload your shell:
```bash
source ~/.zshrc
```

### Verify Setup

Restart NeoVim and run:
```vim
:checkhealth codecompanion
```

## Available Keymaps

### Chat & Actions
- `<leader>ca` - Open CodeCompanion actions menu (works in normal and visual mode)
- `<leader>cc` - Toggle CodeCompanion chat window
- `<leader>cC` - Start new CodeCompanion chat session
- `<leader>ci` - Inline prompt (generate code at cursor)
- `<leader>cA` - Add visual selection to chat (visual mode only)

### Inside Chat Buffer
- `?` - Show all available keymaps
- `<CR>` or `<C-s>` - Send message
- `<C-c>` - Close chat
- `#` - Add context variables (e.g., `#buffer`, `#lsp`, `#file`)
- `/` - Use slash commands (e.g., `/explain`, `/fix`, `/tests`)

### Inline Diff Keymaps
When CodeCompanion generates code inline:
- `gda` - Accept change (Diff Accept)
- `gdr` - Reject change (Diff Reject)

## Usage Examples

### 1. Start a Chat
```vim
:CodeCompanionChat
```
This opens a chat with Copilot (default).

To use Claude instead:
```vim
:CodeCompanionChat anthropic
```

### 2. Quick Actions
1. Select code in visual mode
2. Press `<leader>ca`
3. Choose from menu: "Explain", "Fix", "Refactor", "Tests", etc.

### 3. Inline Code Generation
Press `<leader>ci` and type a prompt:
```
Write a function to validate email addresses
```

### 4. Using Context in Chat
In the chat buffer, type `#` to add context:
```
Fix the errors in #lsp for #buffer
```

Available variables:
- `#buffer` - Current buffer content
- `#viewport` - Visible lines only
- `#lsp` - LSP diagnostics
- `#file` - Select specific file
- `#git` - Git information

### 5. Slash Commands
Type `/` in chat to use built-in commands:
- `/explain` - Explain selected code
- `/fix` - Fix code issues
- `/doc` - Generate documentation
- `/tests` - Generate tests
- `/commit` - Generate commit message

## Providers

### GitHub Copilot - Default
- Used for: Chat, inline edits, quick commands
- Requires: Active GitHub Copilot subscription
- Uses your existing copilot.lua authentication
- Models available: `claude-sonnet-4`, `gpt-4o`, `o1-preview`

### Claude (Anthropic) - Available
- Used for: Alternative provider when needed
- Model: `claude-sonnet-4-20250514` (latest)
- Requires: API key from console.anthropic.com
- Cost: Pay per use (see Anthropic pricing)
- Switch to Claude: `:CodeCompanionChat anthropic`

## Project Context (Optional)

Create a `CLAUDE.md` file in your project root to provide context:

```markdown
# Project Context

This is a [description of your project].

## Tech Stack
- List your technologies

## Conventions
- Code style preferences
- Naming conventions
- Architecture patterns
```

CodeCompanion will automatically read this file and use it as context.

## Troubleshooting

### "No adapter found" error
- Make sure `ANTHROPIC_API_KEY` is set in your environment
- Restart NeoVim after setting the variable
- Run `:checkhealth codecompanion`

### Enable Debug Logging
Edit `lua/plugins/init.lua` and change:
```lua
log_level = "DEBUG", -- instead of "INFO"
```

View logs:
```vim
:CodeCompanionLog
```

### Check Adapter Status
```vim
:CodeCompanion adapter
```

## Cost Management

- Copilot is included in your GitHub subscription - no additional cost
- Claude API usage costs money (if you choose to use it) - monitor at https://console.anthropic.com
- Start new chats for unrelated topics to avoid large context
- Use `#viewport` instead of `#buffer` for large files

## Additional Resources

- Documentation: https://codecompanion.olimorris.dev
- GitHub: https://github.com/olimorris/codecompanion.nvim
- Anthropic Console: https://console.anthropic.com
