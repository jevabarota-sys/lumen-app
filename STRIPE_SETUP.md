# Stripe Setup Guide for Lumen App

This guide will help you set up Stripe for subscription payments in the Lumen mobile app.

## Prerequisites
- Stripe account (https://stripe.com)
- Supabase project already configured
- Access to your app's backend/webhook endpoints

## Step 1: Create Stripe Account & Get API Keys

1. Go to https://stripe.com and create an account
2. Complete business verification if required
3. Go to **Developers** > **API keys**
4. Copy your keys:
   - **Publishable key** (starts with `pk_test_` or `pk_live_`)
   - **Secret key** (starts with `sk_test_` or `sk_live_`)

⚠️ **Important**: Use test keys during development, live keys only in production.

## Step 2: Create Subscription Product

1. Go to **Products** in Stripe dashboard
2. Click **Add product**
3. Configure the Lumen Premium subscription:
   - **Name**: "Lumen Premium"
   - **Description**: "Unlock advanced features including unlimited journal entries, premium tarot spreads, and AI insights"
   - **Pricing model**: Recurring
   - **Price**: $9.99 USD
   - **Billing period**: Monthly
   - **Trial period**: 7 days (optional)
4. Click **Save product**
5. Copy the **Price ID** (starts with `price_`)

## Step 3: Configure Webhook Endpoints

Webhooks notify your app when subscription events occur.

1. Go to **Developers** > **Webhooks**
2. Click **Add endpoint**
3. Configure webhook:
   - **Endpoint URL**: `https://your-supabase-project.supabase.co/functions/v1/stripe-webhook`
   - **Events to send**:
     - `customer.subscription.created`
     - `customer.subscription.updated`
     - `customer.subscription.deleted`
     - `invoice.payment_succeeded`
     - `invoice.payment_failed`
4. Click **Add endpoint**
5. Copy the **Webhook signing secret** (starts with `whsec_`)

## Step 4: Set Up Environment Variables

Add these to your CI/CD secrets and local environment:

```bash
# Stripe Configuration
STRIPE_PUBLISHABLE_KEY=pk_test_your_publishable_key_here
STRIPE_SECRET_KEY=sk_test_your_secret_key_here
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret_here
STRIPE_PRICE_ID=price_your_price_id_here
```

### For GitHub Actions (CI/CD):
1. Go to your GitHub repo > **Settings** > **Secrets and variables** > **Actions**
2. Add repository secrets:
   - `STRIPE_PUBLISHABLE_KEY`
   - `STRIPE_SECRET_KEY` (if needed for server-side)
   - `STRIPE_PRICE_ID`

### For Local Development:
Add to your `.env` file:
```bash
STRIPE_PUBLISHABLE_KEY=pk_test_your_publishable_key_here
STRIPE_PRICE_ID=price_your_price_id_here
```

## Step 5: Update App Configuration

Update `lib/core/constants/app_constants.dart`:

```dart
class AppConstants {
  // ... existing constants ...
  
  // Stripe Configuration
  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: 'pk_test_your_default_key_here',
  );
  
  static const String stripePriceId = String.fromEnvironment(
    'STRIPE_PRICE_ID', 
    defaultValue: 'price_your_default_price_here',
  );
}
```

## Step 6: Create Supabase Edge Function for Webhooks

Create a Supabase Edge Function to handle Stripe webhooks:

1. In your Supabase project, go to **Edge Functions**
2. Create new function: `stripe-webhook`
3. Use this code template:

```typescript
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const stripe = Stripe(Deno.env.get('STRIPE_SECRET_KEY')!)
const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
)

serve(async (req) => {
  const signature = req.headers.get('stripe-signature')!
  const body = await req.text()
  
  try {
    const event = stripe.webhooks.constructEvent(
      body,
      signature,
      Deno.env.get('STRIPE_WEBHOOK_SECRET')!
    )
    
    // Handle subscription events
    switch (event.type) {
      case 'customer.subscription.created':
      case 'customer.subscription.updated':
        await handleSubscriptionUpdate(event.data.object)
        break
      case 'customer.subscription.deleted':
        await handleSubscriptionCancellation(event.data.object)
        break
    }
    
    return new Response('OK', { status: 200 })
  } catch (err) {
    return new Response('Webhook error', { status: 400 })
  }
})
```

## Step 7: Test Payment Flow

### Test Cards (Use in development):
- **Success**: `4242 4242 4242 4242`
- **Decline**: `4000 0000 0000 0002`
- **3D Secure**: `4000 0025 0000 3155`

### Testing Steps:
1. Run your app in development mode
2. Navigate to subscription/payment screen
3. Use test card numbers
4. Verify subscription is created in Stripe dashboard
5. Check that user's premium status is updated in Supabase

## Step 8: Configure Apple Pay & Google Pay (Optional)

### Apple Pay:
1. In Stripe dashboard, go to **Settings** > **Payment methods**
2. Enable **Apple Pay**
3. Add your app's domain to Apple Pay verification
4. Configure in your iOS app settings

### Google Pay:
1. Enable **Google Pay** in Stripe dashboard
2. Configure in your Android app settings
3. Test with Google Pay test cards

## Step 9: Production Checklist

Before going live:

- ✅ Switch to live Stripe keys
- ✅ Update webhook endpoint to production URL
- ✅ Test payment flow with real cards (small amounts)
- ✅ Verify subscription management works
- ✅ Test cancellation and refund flows
- ✅ Set up monitoring for failed payments
- ✅ Configure email notifications for payment events

## Security Best Practices

- ✅ Never expose secret keys in client-side code
- ✅ Use publishable keys only in mobile app
- ✅ Validate webhooks with signing secrets
- ✅ Handle payment failures gracefully
- ✅ Implement proper error handling
- ✅ Log payment events for debugging

## Subscription Management Features

The app should support:
- ✅ Starting premium subscription
- ✅ Viewing subscription status
- ✅ Canceling subscription
- ✅ Updating payment method
- ✅ Handling failed payments
- ✅ Managing trial periods

## Troubleshooting

### Common Issues:

1. **"No such price"**
   - Verify STRIPE_PRICE_ID is correct
   - Check that price exists in Stripe dashboard

2. **"Invalid API key"**
   - Verify you're using the correct environment keys
   - Check for extra spaces in environment variables

3. **Webhook not receiving events**
   - Verify webhook URL is accessible
   - Check webhook signing secret
   - Review webhook logs in Stripe dashboard

4. **Payment sheet not showing**
   - Verify Stripe publishable key is set
   - Check device/simulator payment settings
   - Ensure proper Stripe SDK initialization

## Next Steps

After Stripe is configured:
1. Implement subscription UI in the app
2. Test end-to-end payment flows
3. Set up customer support for billing issues
4. Configure analytics for subscription metrics
5. Prepare for app store review (payment compliance)

---

**Need help?** Check the [Stripe documentation](https://stripe.com/docs) or contact the development team.
