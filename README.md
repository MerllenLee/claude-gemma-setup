# 🚀 Claude Code $\rightarrow$ Gemma 4 安裝使用指南 (Enterprise 版)

這份文件將指導你如何配置 Claude Code，使其透過 **Gemma 4 (Google AI Studio)** 驅動，讓你能在本地端免費使用強大的 AI 編碼助手。

---

## 🌟 功能概述
本方案使用 `claude-code-router` 作為代理層，將 Claude Code 的請求路由至 Google 的 Gemma 4 模型。
- **完全免費**：利用 Google AI Studio 的免費層級額度。
- **權限自適應**：腳本會自動處理工具安裝權限，確保系統配置安全且正確。
- **靈活選擇**：可選擇不同規模的模型 (31B 或 26B) 以平衡效能與速度。

---

## 📋 安裝前準備

在執行安裝腳本之前，請確保你已完成以下準備：

### 1. 安裝 Node.js v20+ 與 npm (必備)
本工具要求 **Node.js v20.0.0 或以上版本** 才能穩定運行。

**如果你尚未安裝或版本過低，請在終端機執行以下指令安裝 v20 (適用於 Ubuntu/Debian/WSL)：**
```bash
# 1. 下載並執行 NodeSource 安裝腳本 (設定 v20 倉庫)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -

# 2. 安裝 Node.js (包含 npm)
sudo apt-get install -y nodejs
```

**驗證安裝是否成功：**
```bash
node -v  # 應顯示 v20.x.x
npm -v   # 應顯示版本號
```

### 2. 獲取 Google AI Studio API Key
你需要一個 API Key 來驅動模型：
1. 前往 [Google AI Studio (aistudio.google.com)](https://aistudio.google.com/)。
2. 登入你的 Google 帳號。
3. 點擊左側的 **"Get API key"** $\rightarrow$ **"Create API key in new project"**。
4. **複製並妥善保存此 Key**，在執行安裝腳本時會用到。

---

## ⚡ 快速安裝 (推薦)

如果你已經完成上述準備，可以直接在終端機執行以下組合指令：

```bash
curl -sSL https://raw.githubusercontent.com/MerllenLee/claude-gemma-setup/main/setup_gemma.sh -o setup_gemma.sh && chmod +x setup_gemma.sh && ./setup_gemma.sh
```

---

## 🛠️ 手動安裝步驟 (備用方案)

如果你希望先檢查腳本內容再安裝，請參考以下步驟：

### Step 1: 獲取安裝腳本
下載 `setup_gemma.sh` 檔案，並將其放置在你的家目錄或任何方便的資料夾中。

### Step 2: 執行安裝指令
打開終端機 (Terminal)，切換到腳本所在目錄，執行以下指令：

```bash
# 1. 給予執行權限
chmod +x setup_gemma.sh

# 2. 以「普通使用者」身份啟動安裝程式 (請勿使用 sudo 啟動整個腳本)
./setup_gemma.sh
```

### Step 3: 跟隨互動提示
安裝程式啟動後，請按照提示操作：
1. **輸入 API Key**：貼上你在 Google AI Studio 申請的 Key。
2. **選擇模型**：
   - `1` $\rightarrow$ **Gemma-4-31B** (能力最強，推薦用於複雜邏輯)。
   - `2` $\rightarrow$ **Gemma-4-26B** (速度較快，適合簡單任務)。
3. **權限驗證**：如果在安裝工具時系統提示 `[sudo] password for ...`，請輸入你的**電腦登入密碼**即可。

---

## 🚀 如何使用

安裝完成後，你不需要執行任何複雜的啟動指令，直接在終端機輸入：

```bash
claude
```

### ⚠️ 重要注意事項：
- **首次啟動信任檢查**：
  當你第一次在某個專案資料夾啟動 `claude` 時，它會詢問：
  `Quick safety check: Is this a project you created...`
  請輸入 **`1`** (Yes, I trust this folder) 即可進入對話介面。

- **API 額度限制**：
  由於使用的是免費層級，若遇到 `429 Too Many Requests` 錯誤，請稍等 1 分鐘後再試。

---

## ❓ 常見問題 (FAQ)

**Q: 我可以直接用 `sudo ./setup_gemma.sh` 執行嗎？**
A: **強烈不建議！** 請以普通使用者身份執行。腳本內部會根據需要自動請求 `sudo` 權限來安裝工具，這樣可以確保你的設定檔擁有權正確，避免後續出現 `Permission Denied` 錯誤。

**Q: 我需要重新啟動終端機嗎？**
A: 不需要。腳本最後會自動激活環境。如果你開啟新的視窗發現 `claude` 指令失效，請執行 `source ~/.zshrc` (或 `.bashrc`)。

**Q: 我可以更改模型版本嗎？**
A: 可以。最簡單的方法是重新執行一次 `./setup_gemma.sh` 並選擇不同的版本。

**Q: 這安全嗎？我的 API Key 會外流嗎？**
A: 本腳本僅將 API Key 寫入你本地端的 `~/.claude-code-router/config.json` 檔案中，不會上傳至任何伺服器。請勿將此配置檔案分享給他人。
