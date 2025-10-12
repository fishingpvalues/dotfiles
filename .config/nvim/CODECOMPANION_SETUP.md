# CodeCompanion.nvim Setup Guide

## ✅ Installation Complete!

I've installed and configured **codecompanion.nvim** - the best AI coding assistant for your setup.

---

## 🎯 Why CodeCompanion?

**Perfect for Your Workflow:**
- ✅ **Multi-provider** - Use ANY LLM (Ollama, Claude, GPT, Gemini)
- ✅ **Vim-native** - Respects your modal editing workflow
- ✅ **Flexible** - Chat interface + inline assistance
- ✅ **No vendor lock-in** - Switch providers anytime
- ✅ **Context-aware** - Understands your LSP, buffers, diagnostics
- ✅ **Multi-language** - Works with Go, Rust, Python, TypeScript, etc.

**Why NOT the others:**
- ❌ sidekick.nvim - Requires paid Copilot subscription, less flexible
- ❌ avante.nvim - Too heavy, Cursor-like (not Vim-like), opinionated
- ❌ CopilotChat - Fewer features, still requires subscription

---

## 🚀 Quick Start (3 Options)

### **Option 1: Free Local AI (Recommended to Start!)**

**Install Ollama:**
```bash
# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Pull a coding model (choose one)
ollama pull qwen2.5-coder:7b        # Best balance (4.7GB)
ollama pull deepseek-coder:6.7b     # Alternative (3.8GB)
ollama pull codellama:13b           # Larger, more capable (7.4GB)
```

**That's it!** CodeCompanion is already configured to use Ollama by default.

**Pros:**
- ✅ 100% Free
- ✅ Works offline
- ✅ No API keys needed
- ✅ Privacy-focused (everything local)
- ✅ Fast responses

**Cons:**
- ⚠️ Requires ~5-8GB disk space
- ⚠️ Needs decent CPU/GPU

---

### **Option 2: Anthropic Claude (Best Quality)**

**Setup:**
1. Get API key from https://console.anthropic.com/
2. Add to your shell config:
```bash
echo 'export ANTHROPIC_API_KEY="your-key-here"' >> ~/.bashrc
source ~/.bashrc
```

3. Edit `/home/daniel/.config/nvim/lua/plugins/codecompanion.lua`:
   - Uncomment the `anthropic` adapter section
   - Change `adapter = "ollama"` → `adapter = "anthropic"` in strategies

**Pros:**
- ✅ Best code quality (Claude 3.5 Sonnet)
- ✅ Great at complex refactoring
- ✅ Understands context deeply

**Cons:**
- ⚠️ Costs money ($3-15/month typical usage)
- ⚠️ Requires internet

---

### **Option 3: OpenAI GPT**

**Setup:**
1. Get API key from https://platform.openai.com/
2. Add to shell config:
```bash
echo 'export OPENAI_API_KEY="your-key-here"' >> ~/.bashrc
source ~/.bashrc
```

3. Edit codecompanion.lua, uncomment openai adapter, change strategy adapter

**Pros:**
- ✅ Fast responses
- ✅ Good code quality
- ✅ Reliable

**Cons:**
- ⚠️ Costs money
- ⚠️ Less powerful than Claude for code

---

## ⌨️ Keybindings (All under `<leader>a`)

### **Main Actions**
| Key | Action | Mode | Description |
|-----|--------|------|-------------|
| `<leader>aa` | **AI Actions** | n, v | Show all available AI actions (⭐ **START HERE**) |
| `<leader>ac` | **Toggle Chat** | n, v | Open/close chat window |
| `<leader>ai` | **Inline Prompt** | n, v | Prompt AI inline in your code |

### **Quick Commands**
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>ae` | **Explain** | Explain selected code or buffer |
| `<leader>af` | **Fix** | Fix bugs in selection |
| `<leader>at` | **Tests** | Generate tests for code |
| `<leader>ad` | **Docs** | Generate documentation |
| `<leader>ar` | **Refactor** | Refactor selected code (visual mode) |

### **Context-Aware**
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>ab` | **Ask Buffer** | Ask questions about current buffer |
| `<leader>al` | **Ask LSP** | Ask about LSP diagnostics/symbols |
| `<leader>aA` | **Add to Chat** | Add selection to existing chat (visual) |

---

## 📖 Usage Examples

### **1. Quick Bug Fix**
```
1. Select code with bug (visual mode)
2. Press <leader>af
3. Review the fix
4. Apply or iterate
```

### **2. Generate Tests**
```
1. Put cursor on function
2. Press <leader>at
3. AI generates unit tests
4. Review and accept
```

### **3. Chat with AI**
```
1. Press <leader>aa (Actions menu)
2. Choose "Chat"
3. Type your question
4. AI responds with context of your code
```

### **4. Explain Complex Code**
```
1. Select confusing code
2. Press <leader>ae
3. Get detailed explanation
```

### **5. Refactor Code**
```
1. Select code to refactor (visual mode)
2. Press <leader>ar
3. Describe desired changes
4. AI refactors and shows diff
```

---

## 💡 Pro Tips

### **Chat Commands (Type in chat):**
- `/help` - Show all slash commands
- `/buffer` - Include current buffer in context
- `/buffers` - Include all open buffers
- `/lsp` - Include LSP diagnostics
- `/viewport` - Include visible code
- `/clear` - Clear chat history

### **Chat Variables (Use @ in chat):**
- `@buffer` - Reference current buffer
- `@buffers` - Reference all buffers
- `@lsp` - Reference LSP info
- `@viewport` - Reference visible code

### **Best Practices:**
1. **Start specific** - "Fix this Go function" vs "Fix my code"
2. **Provide context** - Use `/buffer` or `/lsp` in chat
3. **Iterate** - Don't accept first suggestion, ask for alternatives
4. **Visual mode** - Select exactly what you want AI to work on
5. **Check diffs** - Always review changes before applying

---

## 🔧 Advanced Configuration

### **Switch AI Providers:**

Edit `/home/daniel/.config/nvim/lua/plugins/codecompanion.lua`:

```lua
strategies = {
  chat = {
    adapter = "ollama", -- Change to "anthropic" or "openai"
  },
  inline = {
    adapter = "ollama", -- Change to "anthropic" or "openai"
  },
},
```

### **Use Different Models:**

For Ollama:
```lua
ollama = function()
  return require("codecompanion.adapters").extend("ollama", {
    schema = {
      model = {
        default = "deepseek-coder:33b", -- Larger model
      },
    },
  })
end,
```

For Claude:
```lua
anthropic = function()
  return require("codecompanion.adapters").extend("anthropic", {
    schema = {
      model = {
        default = "claude-3-opus-20240229", -- More powerful
      },
    },
  })
end,
```

### **Add Custom Prompts:**

Add to `prompt_library` in config:
```lua
prompt_library = {
  ["Go Error Handling"] = {
    strategy = "inline",
    description = "Add proper Go error handling",
    prompts = {
      {
        role = "system",
        content = "Add comprehensive error handling to this Go code following best practices",
      },
    },
  },
  ["Rust Safety"] = {
    strategy = "inline",
    description = "Make Rust code more idiomatic and safe",
    prompts = {
      {
        role = "system",
        content = "Refactor this Rust code to be more idiomatic, safe, and efficient",
      },
    },
  },
},
```

---

## 🆘 Troubleshooting

### **"Ollama not found"**
```bash
# Check if ollama is running
ollama list

# Start ollama service
ollama serve

# Pull a model if none installed
ollama pull qwen2.5-coder:7b
```

### **"API key not found"**
```bash
# Check if key is set
echo $ANTHROPIC_API_KEY
echo $OPENAI_API_KEY

# If empty, add to ~/.bashrc and restart terminal
```

### **Chat window doesn't open**
```vim
" Check for errors
:checkhealth codecompanion

" Check keymaps
:map <leader>a

" Try command directly
:CodeCompanionChat
```

### **Model responses are slow**
- For Ollama: Use smaller model (qwen2.5-coder:7b vs codellama:34b)
- For Claude: Use claude-3-5-haiku instead of sonnet
- For OpenAI: Use gpt-4o-mini instead of gpt-4o

### **Enable debug logging:**
Edit codecompanion.lua:
```lua
log_level = "DEBUG", -- Change from "ERROR"
```
Then check `:messages` for detailed logs

---

## 📊 Cost Comparison

### **Ollama (Local)**
- **Cost:** $0 (Free)
- **Speed:** Fast (depends on hardware)
- **Privacy:** 100% local
- **Quality:** Good for most tasks

### **Anthropic Claude**
- **Cost:** ~$3-15/month (typical usage)
  - Input: $3 per million tokens
  - Output: $15 per million tokens
- **Speed:** Fast
- **Privacy:** Sent to Anthropic
- **Quality:** ⭐⭐⭐⭐⭐ Best for complex code

### **OpenAI GPT-4o-mini**
- **Cost:** ~$2-10/month
  - Input: $0.15 per million tokens
  - Output: $0.60 per million tokens
- **Speed:** Very fast
- **Privacy:** Sent to OpenAI
- **Quality:** ⭐⭐⭐⭐ Good

---

## 🎓 Learning Resources

**Official Docs:** https://codecompanion.olimorris.dev/

**Video Tutorials:**
- Search YouTube: "codecompanion.nvim tutorial"
- NeovimConf talks on AI integration

**Community:**
- GitHub Discussions: https://github.com/olimorris/codecompanion.nvim/discussions
- Reddit: r/neovim

---

## 🚀 Next Steps

1. **Install Ollama** (or set up API key)
2. **Restart Neovim** to load CodeCompanion
3. **Press `<leader>aa`** to see actions menu
4. **Try `<leader>ae`** on some code to get explanation
5. **Open chat** with `<leader>ac` and ask questions!

---

## 📝 Your Keymap Summary

**Full AI Group (`<leader>a`):**
- `aa` - Actions menu (⭐ **your starting point**)
- `ac` - Toggle chat
- `aA` - Add to chat (visual)
- `ai` - Inline prompt
- `ae` - Explain code
- `af` - Fix code
- `at` - Generate tests
- `ad` - Generate docs
- `ar` - Refactor (visual)
- `ab` - Ask about buffer
- `al` - Ask about LSP

**Remember:** Press `<leader>a` and which-key will show all options!

Happy coding with AI! 🤖✨
