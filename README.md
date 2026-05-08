# KAFA Member Portal

A Flutter web demo of the KAFA member portal — an insurance cooperative management app. Members can view policies, payment history, beneficiaries, and make premium payments via Stripe.

No login is required. The app loads with a pre-configured demo user (Alex Johnson) so you can explore all screens immediately.

---

## Running Locally

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x or later)
- A free [Stripe account](https://dashboard.stripe.com/register)

### 1. Clone and install dependencies

```bash
git clone https://github.com/Philmattt04/kafa_member.git
cd kafa_member
flutter pub get
```

### 2. Run without Stripe (browse-only mode)

The app works without a Stripe key — all screens are accessible, but the payment form card fields will not appear.

```bash
flutter run -d chrome
```

### 3. Run with Stripe (payment enabled)

Follow the steps below to get your Stripe publishable key, then pass it at run time:

```bash
flutter run -d chrome --dart-define=STRIPE_KEY=pk_test_YOUR_KEY
```

---

## Setting Up Stripe

### Step 1 — Create a Stripe account

Go to [dashboard.stripe.com/register](https://dashboard.stripe.com/register) and create a free account. No business or credit card required for test mode.

### Step 2 — Get your publishable key

1. In the Stripe dashboard, make sure **Test mode** is toggled on (top-right switch).
2. Go to **Developers → API keys**.
3. Copy the **Publishable key** — it starts with `pk_test_`.

> Never use your **Secret key** (`sk_test_...`) in the frontend. Only the publishable key goes in the Flutter app.

### Step 3 — Run the app with your key

```bash
flutter run -d chrome --dart-define=STRIPE_KEY=pk_test_YOUR_KEY_HERE
```

The card number, expiry, and CVC fields will now appear on the payment screen.

### Step 4 — Test a payment

Use Stripe's test card numbers — no real money is charged:

| Card number          | Scenario             |
|----------------------|----------------------|
| `4242 4242 4242 4242` | Payment succeeds     |
| `4000 0025 0000 3155` | 3D Secure required   |
| `4000 0000 0000 9995` | Payment declined     |

For any test card:
- **Expiry**: any future date (e.g. `12/34`)
- **CVC**: any 3 digits (e.g. `123`)
- **ZIP**: any 5 digits (e.g. `12345`)

---

## Building for Web

```bash
flutter build web --release --dart-define=STRIPE_KEY=pk_test_YOUR_KEY
```

Output is in `build/web/`. Deploy that folder to any static host (S3, Netlify, GitHub Pages, etc.).

---

## Project Structure

```
lib/
├── main.dart                  # Entry point — auto-logs in demo user
├── screens/
│   ├── member_dashboard_screen.dart   # Main dashboard + tabs
│   ├── payment_screen.dart            # Stripe payment form
│   ├── payment_confirmation_screen.dart
│   ├── policy_screen.dart
│   ├── beneficiaries_screen.dart
│   └── ...
├── services/
│   ├── payment_service.dart   # Stripe PaymentIntent flow
│   └── api_service.dart       # AWS API Gateway calls (SigV4)
└── stripe_web_helper_web.dart # Stripe.js element mounting (web only)
```

---

## Tech Stack

- **Flutter** — cross-platform UI
- **Stripe** — payment processing (`flutter_stripe` + Stripe.js)
- **AWS** — API Gateway, Lambda, DynamoDB (backend, not included in this repo)
- **S3 + CloudFront** — hosting at [kafa.philmathieu.com](https://kafa.philmathieu.com)
