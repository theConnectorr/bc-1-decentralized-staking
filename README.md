# ⏳ Decentralized Staking App (Crowdfunding) - Speedrun Ethereum

Bài tập môn Blockchain: Xây dựng ứng dụng gây quỹ phi tập trung (tương tự Kickstarter) trên nền tảng Ethereum.
**Sinh viên:** 22120165 - Lê Anh Khôi

## 🛠 Tech Stack

- **Framework:** Scaffold-ETH 2
- **Blockchain:** Optimism Sepolia (Testnet)
- **Language:** Solidity (Smart Contract) & TypeScript (Frontend)
- **Core Concepts:** Payable functions, Time manipulation, State Machine, External Contract Calls.

## 🌟 Cơ chế hoạt động (Game Mechanics)

Dự án mô phỏng một chiến dịch gọi vốn với các quy tắc Smart Contract chặt chẽ:

1.  **Stake (Góp vốn):** Người dùng gửi ETH vào contract `Staker`.

    - Contract ghi nhận số dư của từng người qua `mapping`.
    - Chỉ được phép góp khi thời gian chưa kết thúc (`block.timestamp < deadline`).

2.  **Execute (Chốt kèo):** Hàm này được gọi khi hết thời gian.

    - **Kịch bản Thành công:** Nếu tổng tiền gom được `>= Threshold` (1 ETH) ➔ Toàn bộ tiền được chuyển sang `ExampleExternalContract` để thực hiện dự án.
    - **Kịch bản Thất bại:** Nếu tổng tiền `< Threshold` ➔ Contract chuyển sang trạng thái "Rút tiền".

3.  **Withdraw (Hoàn tiền):**

    - Nếu kèo thất bại, người dùng được phép rút lại đúng số ETH mình đã góp.
    - Cơ chế bảo mật: Chống Re-entrancy bằng cách trừ số dư (`balances = 0`) trước khi chuyển tiền.

4.  **Time Logic:** Sử dụng `block.timestamp` để đếm ngược thời gian còn lại.

## 🚀 Hướng dẫn chạy chương trình (How to run)

### 1. Cài đặt (Installation)

Yêu cầu: Node.js (>= 20.17.0) và Yarn.

```bash
git clone https://github.com/theConnectorr/bc-1-decentralized-staking
cd bc-1-decentralized-staking
yarn install

```

### 2. Cấu hình môi trường (Environment)

Tạo file `.env` trong thư mục `packages/nextjs/` và điền Alchemy API Key:

```env
NEXT_PUBLIC_ALCHEMY_API_KEY=your_alchemy_api_key

```

### 3. Deploy Smart Contract

Triển khai cả `ExampleExternalContract` và `Staker` lên mạng Optimism Sepolia.

```bash
# 1. Tạo ví deployer & Nạp ETH
yarn generate
yarn account

# 2. Deploy
yarn deploy --network optimismSepolia --reset

```

### 4. Kiểm thử (Testing)

Dự án bao gồm các test case quan trọng để kiểm tra logic thời gian và chuyển tiền.

```bash
yarn test

```

### 5. Chạy Frontend

```bash
yarn start

```

Truy cập `http://localhost:3000`.

### 6. Verify Contract

```bash
yarn verify --network optimismSepolia

```
