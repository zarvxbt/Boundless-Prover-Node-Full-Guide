
# Boundless Script Automatic Installation Guide

## What to Do Before Starting:

1. Create a new wallet.  
   Send **5 USDC (test token)** and **1-2 USD worth of Sepolia ETH** to the Base Sepolia network.

2. Follow the steps below to get the test tokens:

   - Get test USDC from https://faucet.circle.com  
   - Bridge Sepolia ETH to Base Sepolia using https://superbridge.app/base-sepolia

3. Get Base Sepolia RPC from the site below:  
   → Go to https://dashboard.blockpi.io and register.  
   → Register for free and create a "Base-Sepolia" endpoint.  

📌 These amounts and steps are valid for all networks.  
You can apply the same steps for Base Mainnet, Ethereum Sepolia, or other supported networks.

---

## Adding SSH Key via Vast.ai:

1. Open **Terminal** (or PowerShell) on your computer.

2. Enter the following command:

```bash
ssh-keygen
```

3. Press **Enter** for all 3 questions that appear.

4. Your SSH key will be generated, and its path will be shown. Copy this path.

5. To view your public key, enter the following command in the terminal:

```bash
cat ~/.ssh/id_rsa.pub
```

6. Go to [https://cloud.vast.ai/?ref_id=222215](https://cloud.vast.ai/) → Click on the **Keys** tab from the left menu.

7. Click `New` in the upper right, paste the copied line, and save.

---

## Choosing a Template and Renting a Server on Vast.ai

To run the Boundless node, you need to rent a suitable server. Follow these steps:

1. Log into the Vast panel and click the **Templates** tab in the upper left.

2. From the list, select the **Ubuntu 22.04 VM** template.

3. From the top menu, select a GPU: **RTX 3090** or **RTX 4090** is recommended.

   > It may work on lower systems, but performance will decrease.

4. Set storage between **150-200 GB SSD**. (NVMe recommended)

5. From the top-left sorting menu, select **Price (inc)**.

   > This way, the best price/performance options will be listed at the top.

6. Select a suitable device and click the **Rent** button.

---

## Accessing the Server

1. From the Vast panel, go to the **Instances** section in the left menu.

2. Click the terminal button on your device and copy the command starting with **SSH**.

3. Paste it into your Terminal or PowerShell to access your server.

---

## Installation:

### Download the Script:

```bash
wget https://raw.githubusercontent.com/UfukNode/Boundless-ZK-Mining/main/boundless.sh
```

### Run the Script:

```bash
chmod +x boundless.sh
sudo ./boundless.sh
```

⌛️ The installation process will take approximately 45-50 minutes. Please be patient.

---

### Installation Process and Input Information

After the installation, you’ll be asked to enter some information:

- You will choose which network to be a prover on.
- You’ll be asked to enter your previously prepared wallet address.
- You’ll be asked to enter the RPC connection you created for free. (Use the RPC for the network you selected.)

---

### Log Monitoring:

```bash
cd boundless
```

```bash
docker compose logs -f broker
```

Example of a successful log output.
![456639519-c4758f65-b931-4f81-91d0-2701f5233662](https://github.com/user-attachments/assets/e592ac03-1f56-44a5-882f-b6d43a83e38d)

---

### Useful Commands:

1. Stop the Node:
```bash
just broker down
```

2. Restart the Node:
```bash
just broker up
```

3. Access broker.toml:
```bash
nano broker.toml
```

---

### Common Issues:

If you've configured your private key and RPC but you're seeing "WARN" logs, you need to activate your `.env` file:

```bash
just broker down
```
```bash
source .env.base-sepolia #adjust the ending depending on the network you're using
```
```bash
just broker
```

---

# Broker.toml Configuration Guide for RTX 4090

### Aggressive Configuration:
```toml
[prover]
mcycle_price = "0.0000000000002" 
peak_prove_khz = 500 
max_mcycle_limit = 25000
min_deadline = 180
max_concurrent_proofs = 2
lockin_priority_gas = 50000000000
```

### Balanced Configuration:
```toml
[prover]
mcycle_price = "0.000000000001"
peak_prove_khz = 420
max_mcycle_limit = 15000
min_deadline = 240
max_concurrent_proofs = 1
lockin_priority_gas = 25000000000
```

## Explanation of Settings:

- **mcycle_price**: The fee per task. The lower you set it, the more orders you can receive.
- **peak_prove_khz**: The number of operations your GPU can perform per second. (If problems arise, lower it or run a benchmark test.)
- **max_mcycle_limit**: Represents the maximum job size you'll accept.
- **min_deadline**: Minimum time to complete a task (for safety).
- **max_concurrent_proofs**: Number of tasks processed simultaneously. (Don’t go above 2.)
- **lockin_priority_gas**: The commission you’re willing to pay to grab a job (higher gwei = better chance to get orders)

Competition is high, and you may need to tweak these settings. Test each setting for at least 2 hours before changing again.

