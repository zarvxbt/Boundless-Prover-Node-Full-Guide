<div align="center">

# 💻 Boundless Prover Node Installation Guide (Base Mainnet) 💻

</div>
This guide explains step-by-step how to set up a Boundless Prover node on the Base Mainnet network and start generating proofs by catching orders.

| Component       | Minimum Requirement        |
| --------------- | -------------------------- |
| **CPU**         | Min. 16 vCPU               |
| **RAM**         | Min. 32 GB                 |
| **Disk**        | Min. 200 GB SSD            |

---

## Why Are We Setting Up This Node?

The Boundless network gives devices tasks like “compute this operation.”  
By running this node, you're taking on these tasks, performing them, and earning rewards.

- These tasks are called “Orders” in the system.
- Your node tries to catch these orders.
- The first to complete the task wins. So if your system is fast, your RPC is solid, and your hardware is strong, you’ll have the advantage.

---

## What You Need to Do Before Starting:

1. Create a new wallet.  
   Send **5 \$USDC** and **1–2 dollars worth of \$ETH** to the Base Mainnet.

2. Get a **Base Mainnet RPC** from one of the following sites:
   * [https://drpc.org/](https://drpc.org/)
   * [https://dashboard.alchemy.com/](https://dashboard.alchemy.com/)

⚠️ Using a fast RPC is very important to catch orders.

---

## Add SSH Key to Vast.ai

1. Open **Terminal** (or PowerShell) on your computer.
2. Run the following command:

```bash
ssh-keygen
```

3. Press **Enter** for all three prompts.
4. It will generate your SSH key and show the file path. Copy that path.

```bash
cat ~/.ssh/id_rsa.pub
```

5. Go to [https://vast.ai/](https://cloud.vast.ai/?ref_id=222215) → Click on **Keys** from the left sidebar.
6. Click `New` in the top-right corner, paste the copied line, and save.

✅ You can now connect to your servers from the terminal without a password.

---

## Select Template and Rent Server on Vast.ai

To run the Boundless node, you need to rent a suitable server. Follow these steps to select a properly configured server:

1. Go to the Vast panel and click the **“Templates”** tab on the top left.
2. Select the **“Ubuntu 22.04 VM”** template.
![Adsız tasarım](https://github.com/user-attachments/assets/452408df-df90-481d-8999-abdec53de3e7)

4. From the top menu, choose a GPU: **RTX 3090** or **4090** is recommended.
   > It may work on lower-end systems, but performance will be reduced.

5. Set storage between **150–200 GB SSD** (NVMe recommended).
6. From the top-left sort menu, select **Price (inc)**.
   > This will list the best price/performance options first.

7. Choose a suitable server from the list and click the **Rent** button.
![1](https://github.com/user-attachments/assets/29c2df12-340e-4aa9-adf9-d684398945a8)

---

## Connect to the Server:

1. Go to the "Instances" section on the left.
2. Click the terminal icon on your server and copy the command that starts with "SSH."
3. Paste it into your PowerShell or Terminal to connect to your server.
![Adsız tasarım](https://github.com/user-attachments/assets/dc14064a-63f0-43a9-b31e-81a2ca2a4bbd)
---

## Boundless Prover Node Setup Steps:

### 1. Update Your System:

```bash
apt update && apt upgrade -y
```

### 2. Install Required Packages:

```bash
apt install -y build-essential clang gcc make cmake pkg-config autoconf automake ninja-build
apt install -y curl wget git tar unzip lz4 jq htop tmux nano ncdu iptables nvme-cli bsdmainutils
apt install -y libssl-dev libleveldb-dev libclang-dev libgbm1
```

---

### 3. Install Required Tools via Script (May Take Time):

```bash
bash <(curl -s https://raw.githubusercontent.com/UfukNode/Boundless-ZK-Mining/refs/heads/main/gerekli_bagimliliklar.sh)
```
---
After the installation is completed, you will get the output as follows.
![image](https://github.com/user-attachments/assets/688d06e5-4a8b-4a01-87f5-08a3949ef098)
After installation, restart the terminal and continue.

---

### 4. Clone the Repo:

```bash
git clone https://github.com/boundless-xyz/boundless
cd boundless
git checkout release-0.10
```
```bash ./scripts/setup.sh
```
---
![image](https://github.com/user-attachments/assets/e55f5a37-e7b5-480d-b9d7-961d888f5bcd)


### 5. Set Up the Base .env File:

```bash
nano .env.base
```
---


If you’re using testnets like Sepolia instead of Base Mainnet:

- For Base Sepolia:
```bash
nano .env.base-sepolia
```
---

- For Ethereum Sepolia:
```bash
nano .env.eth-sepolia
---

![Ekran görüntüsü 2025-06-18 175359](https://github.com/user-attachments/assets/9d406b08-c975-4c8f-9012-721d7e07cdfd)
Set content like this:

```bash
export PRIVATE_KEY=your_private_key
export RPC_URL="https://your-rpc-url"
```

Save and exit with CTRL+X → Y → Enter.

Then activate it:

```bash
source .env.base
```

If using testnets:

```bash
source .env.base-sepolia
# or
source .env.eth-sepolia
```

---

### 6. Stake USDC to the Base Network

```bash
source ~/.bashrc
```

```bash
boundless account deposit-stake 5
```
![image](https://github.com/user-attachments/assets/1f197201-6c24-42dc-bcb1-193097372fdd)

---

### 7. Deposit ETH

```bash
boundless account deposit 0.0001
```

To check your stake balance:

![Ekran görüntüsü 2025-06-18 131640](https://github.com/user-attachments/assets/86d08b4a-1672-4521-ad29-70068ee1bf19)

```bash
boundless account stake-balance
```

---

### 8. Start the Node

```bash
just broker
```

Wait a moment until setup completes.

![Ekran görüntüsü 2025-06-18 133700](https://github.com/user-attachments/assets/c4758f65-b931-4f81-91d0-2701f5233662)

---

### 9. Check Logs

```bash
docker compose logs -f broker
```

![Ekran görüntüsü 2025-06-18 133700](https://github.com/user-attachments/assets/c4758f65-b931-4f81-91d0-2701f5233662)

Press CTRL+C to stop viewing logs. The prover node will continue to run in the background.

---

### Useful Commands:

#### Stop Node:
```bash
just broker down
```

#### Restart Node:
```bash
just broker up
```

#### Check Logs:
```bash
docker compose logs -f broker
```

---

## 📊 Monitor Node Performance via Explorer

After setting up your node, visit:  
**https://explorer.beboundless.xyz/provers/your-wallet-address**

You’ll see detailed stats about your node.

![image](https://github.com/user-attachments/assets/b0cf0733-ca7a-4fdd-929c-582e4d957e2b)

### What to Monitor:

| Field                 | Description                                                                 |
| ---------------------| ---------------------------------------------------------------------------- |
| **Orders Taken**     | Number of orders you’ve accepted. If it’s increasing, your node is active.   |
| **Cycles Proved**    | Total zk computation power processed. Higher means greater contribution.     |
| **Order Earnings**   | Total ETH earned from orders.                                                |
| **Average ETH/MC**   | ETH earned per million cycles. Indicates profitability.                      |
| **Peak MHz Reached** | Max processing power reached at a moment. Shows hardware strength.           |
| **Fulfillment Rate** | Success rate of completing tasks. 95%+ is ideal.                             |


### Made with💚 by [Zarv](https://x.com/zarvxbt) 


####  special thanks to  [Ufuk🩵](https://x.com/ufukdegen)
